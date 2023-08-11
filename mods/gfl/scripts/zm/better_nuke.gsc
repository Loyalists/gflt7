#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\gib;

#using scripts\zm\_zm_daily_challenges;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;

#insert scripts\shared\ai\systems\gib.gsh;

#define NUKE_EFFECT "zombie/fx_powerup_nuke_zmb"

#precache( "string", "ZOMBIE_POWERUP_NUKE" );
#precache( "fx", NUKE_EFFECT );

#namespace better_nuke;

#define N_NUKE_SPAWN_DELAY 3


//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------

function grab_nuke( player )
{
	
	level thread nuke_powerup( self, player.team );
	
	//chrisp - adding powerup VO sounds
	player thread zm_powerups::powerup_vo("nuke");
	zombies = GetAiTeamArray( level.zombie_team );
	//player.zombie_nuked = array::get_all_closest( self.origin, zombies );
	player.zombie_nuked = ArraySort( zombies, self.origin );
	player notify("nuke_triggered");	
}

// kill them all!
function nuke_powerup( drop_item, player_team )
{
	// First delay spawning while the nuke goes off
	level thread nuke_delay_spawning( N_NUKE_SPAWN_DELAY );
	
	location = drop_item.origin;

	if( isdefined( drop_item.fx ) )
	{
		PlayFx( drop_item.fx, location );
	}
	level thread nuke_flash(player_team);

	wait( 0.5 );
	
	zombies = GetAiTeamArray( level.zombie_team );
	//zombies = array::get_all_closest( location, zombies );
	zombies = ArraySort( zombies, location );
	zombies_nuked = [];

	// Mark them for death
	for (i = 0; i < zombies.size; i++)
	{
		// unaffected by nuke
		if ( IS_TRUE( zombies[i].ignore_nuke ) )
		{
			continue;
		}

		// already going to die
		if ( IsDefined(zombies[i].marked_for_death) && zombies[i].marked_for_death )
		{
			continue;
		}

		// check for custom damage func
		if ( IsDefined(zombies[i].nuke_damage_func) )
		{
			zombies[i] thread [[ zombies[i].nuke_damage_func ]]();
			continue;
		}
		
		if( zm_utility::is_magic_bullet_shield_enabled( zombies[i] ) )
		{
			continue;
		}

		zombies[i].marked_for_death = true;
		if ( !IS_TRUE(zombies[i].nuked) && !zm_utility::is_magic_bullet_shield_enabled( zombies[i] ) )
		{
			zombies[i].nuked = true;
			zombies_nuked[ zombies_nuked.size ] = zombies[i];
			zombies[i] clientfield::increment( "zm_nuked" );
		}
	}

	for (i = 0; i < zombies_nuked.size; i++)
	{
		wait (randomfloatrange(0.1, 0.7));
		if( !IsDefined( zombies_nuked[i] ) )
		{
			continue;
		}

		if( zm_utility::is_magic_bullet_shield_enabled( zombies_nuked[i] ) )
		{
			// This could be potentially confusing to the player
			//   The only way it should get here is if the allowDeath field was cleared between the time the nuke was grabbed and the time this loop gets to it
			//   At this point the zombie is probably already on fire, but now it's not going to die 
			continue;
		}

		if( !( IS_TRUE( zombies_nuked[i].isdog ) ) )
		{
			if ( !IS_TRUE( zombies_nuked[i].no_gib ) )
			{
				zombies_nuked[i] zombie_utility::zombie_head_gib();
			}
			zombies_nuked[i] playsound ("evt_nuked");
		}
		

		zombies_nuked[i] dodamage( zombies_nuked[i].health + 666, zombies_nuked[i].origin );
		level thread zm_daily_challenges::increment_nuked_zombie();
	}

	better_nuke_points = GetDvarInt("tfoption_better_nuke_points");
	pointsToGive = zombies_nuked.size * better_nuke_points;
	if(pointsToGive < 400) pointsToGive = 400;
	level notify( "nuke_complete" );

	players = GetPlayers( player_team );
	for(i = 0; i < players.size; i++)
	{
		players[i] zm_score::player_add_points( "nuke_powerup", pointsToGive ); 
	}
}

function nuke_flash(team)
{
/*	players = GetPlayers();	
	for(i=0; i<players.size; i ++)
	{
		players[i] zm_utility::play_sound_2d("evt_nuke_flash");
	}
	level thread devil_dialog_delay(); */

	if (IsDefined(team))
		GetPlayers()[0] PlaySoundToTeam("evt_nuke_flash", team);
	else
		GetPlayers()[0] PlaySound("evt_nuke_flash");

	lui::screen_flash( 0.2, 0.5, 1.0, 0.8, "white" ); // flash
}

function nuke_delay_spawning( n_spawn_delay )
{
	level endon( "disable_nuke_delay_spawning" ); // kill the thread in situation where the thread is waiting for "nuke_complete" when we turn this off
	
	if( IS_TRUE( level.disable_nuke_delay_spawning ) )
	{
		return;
	}

	b_spawn_zombies_before_nuke = level flag::get( "spawn_zombies" );
	
	level flag::clear( "spawn_zombies" );

	level waittill( "nuke_complete" );

	if( IS_TRUE( level.disable_nuke_delay_spawning ) )
	{
		return;
	}
	
	// A delay where there will be no zombies alive	
	wait( n_spawn_delay );
	
	if ( b_spawn_zombies_before_nuke )
	{
		// only spawn zombies again if it was spawning zombies before the nuke
		level flag::set( "spawn_zombies" );
	}
}
