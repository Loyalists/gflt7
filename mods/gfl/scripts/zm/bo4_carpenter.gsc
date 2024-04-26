//
//BO4 STYLE CARPENTER v1.0: REPAIRS SHIELD ON GRAB
//CREATED BY FROST ICEFORGE
//ADDITIONAL CREDIT TO MADGAZ FOR CRUSADER ALE SCRIPTS WHICH I MODIFIED
//
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\scoreevents_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_weap_riotshield; 

function __init__() {}

#define SHIELD_CODENAME "zod_riotshield" //Edit if your map uses a custom shield
#define SHIELD_UPGRADE_CODENAME "zod_riotshield_upgraded" //Edit if your custom shield has an upgrade

//BO4 Carpenter
function carpenter_upgrade()
{
	level endon("game_ended");
	level endon("end_game");

	shield_name = get_riot_shield();
	while(isDefined(shield_name))
	{
		level waittill( "carpenter_started" );	
		foreach(player in GetPlayers())
		{
			primary_weapons = player getWeaponsList( 1 ); 
			foreach ( weap in primary_weapons )
			{
				if( weap.name == shield_name )
				{
					player riotshield::player_damage_shield( -1500 );
					player giveMaxAmmo( shield_name ); 
				}
				else if( weap.name == shield_name + "_upgraded" )
				{
					player riotshield::player_damage_shield( -1500 );
					player giveMaxAmmo( shield_name + "_upgraded" );
				} 

				if ( weap.isRiotshield )
				{
					scoreevents::processScoreEvent( "shield_fix", player );
				}
			}
		}
		
	}
}

function get_riot_shield() {
	keys = GetArrayKeys( level.zombie_weapons );
	foreach(weapon in keys) {
		if (weapon.isRiotshield) {
			return(weapon.name);
		}
	}
	return undefined;
}