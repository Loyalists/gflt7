#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_pack_a_punch_util;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\zm\_zm_perks.gsh;

#namespace mule_kick_return;

REGISTER_SYSTEM_EX( "mule_kick_return", &__init__, &__main__, undefined )

function private __init__()
{
	mulekick_return_init();
	callback::on_connect( &on_player_connect );
}

function private __main__()
{
	thread main();
}

function on_player_connect()
{
	self endon("disconnect");
	
	self thread mulekick_return();
}

function is_enabled()
{
    if( GetDvarInt("tfoption_perkplus", 0) || GetDvarInt("tfoption_perk_lose", 0) )
    {
        return true;
    }

	return false;
}

function wait_when_disabled()
{
    wait 5;
}

function main()
{
    level endon("end_game");
    level endon("game_ended");
    level waittill( "initial_blackscreen_passed" );

	thread mulekick_return_watcher();
}

function mulekick_return_init()
{
	level.mulekick_weapon = [];
	level.mulekick_clip = [];
	level.mulekick_stock = [];
}

function mulekick_return_watcher()
{
	level endon("end_game");
	level endon("game_ended");

	while (1) 
	{
		if ( !is_enabled() )
		{
			wait_when_disabled();
			continue;
		}

		foreach(player in level.activeplayers)
		{
			if ( player IsTestClient() )
			{
				continue;
			}

			if ( !isAlive(player) || player.sessionstate == "spectator" )
			{
				continue;
			}

			if ( !player isOnGround() )
			{
				continue;
			}

			if ( player laststand::player_is_in_laststand() )
			{
				continue;
			}

			if ( !player hasPerk("specialty_additionalprimaryweapon") || player GetWeaponsListPrimaries().size < 3 )
			{
				continue;
			}

			xuid = player getXuid(true);
			weapon = player GetWeaponsListPrimaries()[2];
			if (player should_return_weapon(weapon))
			{
				level.mulekick_weapon[xuid] = weapon;
				level.mulekick_clip[xuid] = player getWeaponAmmoClip(weapon);
				level.mulekick_stock[xuid] = player getWeaponAmmostock(weapon);
			}
			else
			{
				level.mulekick_weapon[xuid] = undefined;
				level.mulekick_clip[xuid] = undefined;
				level.mulekick_stock[xuid] = undefined;
			}
		}
		WAIT_SERVER_FRAME;
		wait 2.0001;
	}
}

function should_return_weapon(weapon)
{
	if ( !isdefined(weapon) || !isweapon(weapon) )
	{
		return false;
	}

	if ( !self hasweapon(weapon) )
	{
		return false;
	}

	if ( isdefined(self.laststandpistol) && weapon.name == self.laststandpistol.name )
	{
		return false;
	}

	if ( isdefined(level.zombie_powerup_weapon[ "minigun" ]) && weapon.name == level.zombie_powerup_weapon[ "minigun" ].name )
	{
		return false;
	}

	if ( !zm_weapons::is_weapon_or_base_included( weapon ) )
	{
		return false;
	}

	if ( is_special_weapon(weapon) )
	{
		return false;
	}

	return true;
}

function is_special_weapon(weapon)
{
	if ( IsSubStr( weapon.name, "bottle") || IsSubStr( weapon.name, "wine") )
	{
		return true;
	}

	if ( IsSubStr( weapon.name, "hero") || IsSubStr( weapon.name, "elemental") || IsSubStr( weapon.name, "staff") )
	{
		return true;
	}

	if ( IsSubStr( weapon.name, "grenade") || weapon.name == "knife" )
	{
		return true;
	}

	if ( IsSubStr( weapon.name, "equip") || IsSubStr( weapon.name, "perk") )
	{
		return true;
	}

	return false;
}

function has_mulekick()
{
	if(!isDefined(self.perks_active))
	{
		return false;
	}

	foreach(perk in self.perks_active) 
	{
		if(perk == "specialty_additionalprimaryweapon")
		{
			return true;
		}
	}

	return false;
}

function mulekick_return()
{
	self endon("disconnect");

	while (isdefined(self)) 
	{
		switch_to_weapon = false;
		if ( GetDvarInt("tfoption_perkplus") && GetDvarInt("tfoption_perk_lose") )
		{
			message = self util::waittill_any_return( "perk_acquired", "t8_perkloss_perk_restored", "player_revived" );
			if ( message == "player_revived" )
			{
				self util::waittill_any_timeout(2, "t8_perkloss_perk_restored" );
			}
			else if ( message == "perk_acquired" )
			{
				switch_to_weapon = true;
			}
		}
		else if ( GetDvarInt("tfoption_perkplus") )
		{
			self waittill( "perk_acquired" );
			switch_to_weapon = true;
		}
		else
		{
			self waittill( "t8_perkloss_perk_restored" );
		}

		if(!isDefined(self.perks_active))
		{
			continue;
		}

		if( self has_mulekick() )
		{
			self thread return_mulekick_weapon(switch_to_weapon);
			self util::waittill_any_return( "fake_death", "death", "player_downed", "specialty_additionalprimaryweapon_stop" );
		}
		WAIT_SERVER_FRAME;
	}
}

function return_mulekick_weapon(switch_to_weapon = false)
{
	self notify("elmg_mulekick_return");
	self endon("elmg_mulekick_return");

	if ( self IsTestClient() )
	{
		return;
	}

	WAIT_SERVER_FRAME;
	wait 0.2;
	
	xuid = self getXuid(true);
	weapon = level.mulekick_weapon[xuid];
	if(isDefined(weapon) && self GetWeaponsListPrimaries().size <= 2 && zm_weapons::is_weapon_or_base_included( weapon ))
	{
		self zm_weapons::give_build_kit_weapon( weapon );
		scoreevents::processScoreEvent( "getbackmulekick", self );
		if (isDefined(level.mulekick_stock[xuid]))
		{
			stock_ammo = level.mulekick_stock[xuid];
		}
		if (isDefined(level.mulekick_clip[xuid]))
		{
			clip_ammo = level.mulekick_clip[xuid];
		}
		if (isDefined(stock_ammo))
		{
			self SetWeaponAmmoStock(weapon, stock_ammo);
		}
		if (isDefined(clip_ammo))
		{
			self SetWeaponAmmoClip(weapon, clip_ammo);
		}
		else
		{
			self SetWeaponAmmoClip(weapon, weapon.clipsize);
		}

		if ( IS_TRUE(switch_to_weapon) )
		{
			self SetSpawnWeapon(weapon);
		}
	}
}