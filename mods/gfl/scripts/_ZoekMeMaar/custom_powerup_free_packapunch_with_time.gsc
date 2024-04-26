#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;


#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_magicbox;

#using scripts\shared\array_shared;

#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "model", "free_packapunch" );




//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function init_packapunch_powerup()
{
	zm_powerups::register_powerup( "free_packapunch", &grab_free_pap );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "free_packapunch", "free_packapunch", "", &zm_powerups::func_should_always_drop, POWERUP_ONLY_AFFECTS_GRABBER, !POWERUP_ANY_TEAM, !POWERUP_ZOMBIE_GRABBABLE );
	}
}

function grab_free_pap( player )
{
	player notify( "free_packapunch_grabbed" );

	current_weapon = player GetCurrentWeapon();
	weaponsize = player GetWeaponsListPrimaries();

	if( zm_utility::is_player_valid( player ) && !IS_DRINKING(player.is_drinking) && !zm_utility::is_placeable_mine( current_weapon )  && !zm_equipment::is_equipment( current_weapon ) && !player zm_utility::is_player_revive_tool(current_weapon) && level.weaponNone!= current_weapon  && !player zm_equipment::hacker_active() && !player laststand::player_is_in_laststand() && !bgb::is_active("zm_bgb_ephemeral_enhancement"))
	{
		upgrade_weapon = zm_weapons::get_upgrade_weapon( current_weapon);

		if(weaponsize.size == 1)//Checks if player has one weapon.
		{
			if(!zm_weapons::is_weapon_upgraded(current_weapon))//Checks if that weapon is already upgraded.
			{
				player TakeWeapon(current_weapon);//Takes players original weapon (non pap version), else the player has the pap version and normal one.
			}
		}

		if(!isDefined(level.temp_upgraded_time)){
			level.temp_upgraded_time = 30;
			// IPrintLnBold("The var ^2level.temp_upgraded_time^8 is not found in the your 'mapname.gsc' using normal time (^230sec^7) instead!");
		}

		weapon_limit = zm_utility::get_player_weapon_limit( player );

		player zm_weapons::take_fallback_weapon();

		if(!zm_weapons::is_weapon_upgraded(current_weapon))
		{
			primaries = player GetWeaponsListPrimaries();
			if( isDefined( primaries ) && primaries.size >= weapon_limit )
			{
				upgrade_weapon = player zm_weapons::weapon_give( upgrade_weapon );
			}
			else
			{
				upgrade_weapon = player zm_weapons::give_build_kit_weapon( upgrade_weapon );
				player GiveStartAmmo( upgrade_weapon );
			}
		}

		if(!zm_weapons::is_weapon_upgraded( current_weapon ) && isDefined(level.temp_upgraded_time) && !bgb::is_active("zm_bgb_ephemeral_enhancement"))//Your weapon is not upgraded and level.temp_upgrade_time is defined
		{
			player PlayLocalSound( "free_packapunch_vox" );
			player thread give_temp_upgraded(upgrade_weapon, current_weapon);
		}
		else{
			player PlayLocalSound(level.zmb_laugh_alias);
		}
	}
    else {
    	player PlayLocalSound(level.zmb_laugh_alias);//Sam laughs here, if you are down and try to pick it up, if you are drinking a perkacola, if you are placeing a mine, if you currently are holding equipment (monkey or mine), and if you are reviving someone.
    }
}

function give_temp_upgraded(upgrade_weapon, current_weapon)
{
	if(!isDefined(self.thread_times_pap)){
		self.thread_times_pap = 0;
	}
	self.thread_times_pap++;
	weapon_time_over = self.thread_times_pap + "_time_over";
	self SwitchToWeapon( upgrade_weapon );
	self thread check_temp_upgraded_wep(upgrade_weapon, weapon_time_over);

	for(i=0; i <= level.temp_upgraded_time; i++)
	{
		if(i==level.temp_upgraded_time){
			if(self GetCurrentWeapon() == upgrade_weapon){
				if(self HasWeapon(upgrade_weapon)){
					self TakeWeapon( upgrade_weapon );
					self zm_weapons::weapon_give( current_weapon, false, false, true, false );
					self SwitchToWeaponImmediate( current_weapon );
				}
			}
			else{
				if(self HasWeapon(upgrade_weapon)){
					self TakeWeapon( upgrade_weapon );
					self zm_weapons::weapon_give( current_weapon, false, false, true, false );
				}
			}
			self notify(weapon_time_over);
			self.is_drinking = 0;
	    }
		wait 1;
	}
}

function check_temp_upgraded_wep(upgrade_weapon, weapon_time)
{
	self endon( "disconnect" );
	self endon( weapon_time );
	state = true;
	for(;;)
	{
		if(self GetCurrentWeapon() == upgrade_weapon){
			if(state == true){
				state = false;
				self.is_drinking = 1;
			}
		}
		else{
			if(state == false){
				state = true;
				self.is_drinking = 0;
			}
		}

		if(!self HasWeapon(upgrade_weapon)){
			self notify(weapon_time);
		}
		wait 0.05;
	}
}