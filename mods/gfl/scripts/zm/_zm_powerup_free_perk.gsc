#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "string", "ZOMBIE_POWERUP_FREE_PERK" );

#namespace zm_powerup_free_perk;

REGISTER_SYSTEM( "zm_powerup_free_perk", &__init__, undefined )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "free_perk", &grab_free_perk );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "free_perk", "zombie_pickup_perk_bottle", &"ZOMBIE_POWERUP_FREE_PERK",	&zm_powerups::func_should_never_drop, !POWERUP_ONLY_AFFECTS_GRABBER, !POWERUP_ANY_TEAM, !POWERUP_ZOMBIE_GRABBABLE );
	}
}

function grab_free_perk( player )
{	
	level thread free_perk_powerup( self );
	player PlayLocalSound( "random_perk_vox" ); 
}

function free_perk_powerup( item )
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] laststand::player_is_in_laststand() && !(players[i].sessionstate == "spectator") )
		{
			player = players[i];

			// Notify if its a ghost round powerup
			if ( IsDefined( item.ghost_powerup ) )
			{
				player zm_stats::increment_client_stat( "buried_ghost_perk_acquired", false );
				player zm_stats::increment_player_stat( "buried_ghost_perk_acquired" );

				player notify( "player_received_ghost_round_free_perk" );
			}

			free_perk = player zm_perks::give_random_perk();

			if( IS_TRUE(level.disable_free_perks_before_power) )
			{
				player thread disable_perk_before_power( free_perk );
			}
			
			if ( isDefined( free_perk ) && isDefined( level.perk_bought_func ) )
			{
				player [[ level.perk_bought_func ]]( free_perk );
			}
		}
	}
}

// self = player
function disable_perk_before_power( perk )
{
	self endon( "disconnect" );

	if( IsDefined(perk) )
	{
		// Let the system register the perk
		wait( 0.1 );
		
		if( !level flag::get("power_on") )
		{
			a_players = GetPlayers();
			if( IsDefined(a_players) && (a_players.size == 1) && (perk == PERK_QUICK_REVIVE) )
			{
				return;
			}
			
			self zm_perks::perk_pause( perk );
			level flag::wait_till( "power_on" );
			self zm_perks::perk_unpause( perk );
		}
	}
}
