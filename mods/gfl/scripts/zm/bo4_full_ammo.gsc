#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "string", "ZOMBIE_POWERUP_MAX_AMMO" );
#precache( "eventstring", "zombie_notification" );

#namespace bo4_full_ammo;



//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------

function grab_full_ammo( player )
{	
	level thread full_ammo_powerup( self ,player );
	player thread zm_powerups::powerup_vo("full_ammo");
}

function full_ammo_powerup( drop_item , player)
{
	
	players = GetPlayers( player.team );
	
	if(isDefined(level._get_game_module_players))
	{
		players = [[level._get_game_module_players]](player);
	}
	
	level notify( "zmb_max_ammo_level" );
	
	for (i = 0; i < players.size; i++)
	{
		// skip players in last stand
		if ( players[i] laststand::player_is_in_laststand() )
		{
			continue;
		}
		
		if(isDefined(level.check_player_is_ready_for_ammo))
		{
			if( [[level.check_player_is_ready_for_ammo]](players[i]) == false )
			{
				continue;	//not ready
			}
		}	

		primary_weapons = players[i] GetWeaponsList( true ); 

		players[i] notify( "zmb_max_ammo" );
		players[i] notify( "zmb_lost_knife" );
		players[i] zm_placeable_mine::disable_all_prompts_for_player();
		for( x = 0; x < primary_weapons.size; x++ )
		{
			//don't give grenades if headshot only option is enabled
			if( level.headshots_only && zm_utility::is_lethal_grenade( primary_weapons[x] ) )
			{
				continue;
			}
			
			// Don't refill Equipment
			if ( IsDefined( level.zombie_include_equipment ) && 
			     IsDefined( level.zombie_include_equipment[ primary_weapons[ x ] ] ) &&
			     !IS_TRUE( level.zombie_equipment[ primary_weapons[ x ] ].refill_max_ammo ) )
			{
				continue;
			}
			
			// exclude specific weapons from this list
			if ( IsDefined( level.zombie_weapons_no_max_ammo ) && IsDefined( level.zombie_weapons_no_max_ammo[ primary_weapons[ x ].name ] ) )
			{
				continue;
			}
			
			if ( zm_utility::is_hero_weapon( primary_weapons[ x ] ) )
			{
				continue;
			}
			

			if ( players[i] HasWeapon( primary_weapons[x] ) )
				players[i] GiveMaxAmmo( primary_weapons[x] );
				players[i] SetWeaponAmmoClip(primary_weapons[x], primary_weapons[x].clipSize); 	
		}
	}

	level thread full_ammo_on_hud( drop_item, player.team );
}

function full_ammo_on_hud( drop_item, player_team )
{
	players = GetPlayers( player_team );
	
	players[0] playsoundToTeam ("zmb_full_ammo", player_team);

	if (isdefined(drop_item))
	{
		LUINotifyEvent( &"zombie_notification", 1, drop_item.hint );
	}
}
