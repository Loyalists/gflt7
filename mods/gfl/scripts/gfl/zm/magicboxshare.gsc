#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\aat_shared;

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

#namespace magicboxshare;

function init()
{
	thread main();
}

function main()
{
    level waittill( "initial_blackscreen_passed" );
	thread magicboxshare();
}

function magicboxshare()
{
	mysterybox = struct::get_array( "treasure_chest_use", "targetname" );
	if( mysterybox.size != 0)
	{
		array::thread_all( mysterybox, &share_chest_think );
	}
}

function share_chest_think()
{
	self thread closeshare();
	self thread closeshare2();
	while (1) 
	{
		self.zbarrier util::waittill_any( "randomization_done"); 
		self thread chest_checker();
	}
}

function chest_checker() 
{
	self notify("elmg_try_share");
	self endon("elmg_try_share");

	if ( level flag::get( "moving_chest_now" ) && !level.zombie_vars[ "zombie_powerup_fire_sale_on" ] && !self._box_opened_by_fire_sale )
	{
		
	}
	else
	{
		if( IS_TRUE( self.unbearable_respin ) )
		{
			return;
		}

		if(self.grab_weapon_hint && isDefined(self.zbarrier.weapon) && isDefined(self.chest_user) && self.zbarrier.weapon != level.weaponnone && self.zbarrier.weapon.name != "")
		{
			if( IS_TRUE( self.chest_user HasHacker() ))
			{
				return;
			}

			readytoshare = self.zbarrier.weapon;
			if(!isDefined(self.chest_user.shareweaponhint))
			{
				if(self.chest_user issplitscreen())
				{
					self.chest_user thread zm_equipment::show_hint_text("Press ^3[{+melee}]^7 to share the weapon", 8, 1, 150);
				}
				else
				{
					self.chest_user thread zm_equipment::show_hint_text("Press ^3[{+melee}]^7 to share the weapon", 8);
				}
				self.chest_user.shareweaponhint = 1;
			}

			while (!self.chest_user meleeButtonPressed()) 
			{
				WAIT_SERVER_FRAME;
			}

			self thread magicweaponsharetimeout();
			self thread spawnshareweapon(readytoshare,self.chest_user,self);
			self.chest_user notify("magicbox_weapon_shared", readytoshare);
			self notify( "trigger", self ); 
			self.grab_weapon_hint = false;
			self.zbarrier notify( "weapon_grabbed" );
			self notify( "user_grabbed_weapon" );
			self.zbarrier thread closebox();
			self.closed_by_emp = true;
			WAIT_SERVER_FRAME;
			self.closed_by_emp = false;
		}
	}
}

function HasHacker()
{
	share_hashacker = false;
	weapons = self GetWeaponsList(true);
	foreach(weapon in weapons) 
	{
		if(IsSubStr( weapon.name, "hacker"))
		{
			share_hashacker = true;
		}
	}

	return share_hashacker;
}

function closebox()
{
	if(IsDefined(self.weapon_model))
	{
		self.weapon_model Delete();
		self.weapon_model = undefined;
	}

	if(IsDefined(self.weapon_model_dw))
	{
		self.weapon_model_dw Delete();
		self.weapon_model_dw = undefined;
	}
}

function closeshare2()
{
	level endon("game_ended");
	level endon("end_game");
	while (1) 
	{
		if( IS_TRUE( self.unbearable_respin ) )
		{
			self notify("elmg_try_share");
		}
		WAIT_SERVER_FRAME;
	}
}

function closeshare()
{
	level endon("game_ended");
	level endon("end_game");
	while (1) 
	{	
		self.zbarrier util::waittill_any( "closed", "box_hacked_respin" ); 
		self notify("elmg_try_share");
	}
}

function spawnshareweapon(weapon,user,barrie)
{
	self endon("elmg_share_timeout");
	origin = user.origin + (AnglesToForward(VectortoAngles(barrie.zbarrier.weapon_model.origin - user.origin)) * -50) ;
	origin = (origin[0] , origin[1] , user.origin[2] + 50);
	
	self.magicboxshare = Spawn("trigger_radius_use", origin, 0, 20, 20);
	self.magicboxshare UseTriggerRequireLookAt();
	self.magicboxshare SetCursorHint( "HINT_NOICON");
	self.magicboxshare SetTeamForTrigger("axis");
	self.magicboxshare SetTeamForTrigger("allies");
	self.magicboxshare SetHintString("Press ^3[{+activate}]^7 to take the weapon");
	self.magicboxshare.targetname = "magicboxshare";    
	self.magicboxshare PlaySound("zmb_spawn_powerup");
	self.magicboxshare.weapon = weapon;
	self.magicboxshare.weapon_model = zm_utility::spawn_buildkit_weapon_model( user, weapon, undefined, origin);
	self.magicboxshare thread waitforgrabweapon(weapon,self);
	// self thread playsharefx(origin);
	self.magicboxshare.weapon_model thread weaponmodelrotate();
	wait 12;
	self thread magicweaponsharetimeout();
}

function playsharefx(origin)
{	
	self endon("elmg_share_timeout");
	
	while (isdefined(self)) 
	{
		Playfx( "zombie/fx_powerup_on_caution_zmb", origin );
		WAIT_SERVER_FRAME;
	}
}

function weaponmodelrotate()
{
	self endon("elmg_share_timeout");
	while (isDefined(self)) 
	{
		waittime = randomfloatrange( 2.5, 5 );
		yaw = RandomInt( 360 );
		if( yaw > 300 )
		{
			yaw = 300;
		}
		else if( yaw < 60 )
		{
			yaw = 60;
		}
		yaw = self.angles[1] + yaw;
		new_angles = (-60 + randomint( 120 ), yaw, -45 + randomint( 90 ));
		self rotateto( new_angles, waittime, waittime * 0.5, waittime * 0.5 );
		wait randomfloat( waittime - 0.1 );
	}
}

function magicweaponsharetimeout()
{
	if(isDefined(self.magicboxshare))
	{
		if(isDefined(self.magicboxshare.weapon_model))
		{
			self.magicboxshare.weapon_model delete();
		}
		self.magicboxshare delete();
	}
	self notify("elmg_share_timeout");
}

function waitforgrabweapon(shareweapon,box) 
{
	self endon("elmg_share_timeout");
	while (1) 
	{
		self waittill( "trigger", player );
		weapon = player GetCurrentWeapon();
		if((!player laststand::player_is_in_laststand() || !isDefined(player.revivetrigger) || player.laststand != true) &&
		player IsTouching(self) && 
		zm_utility::is_player_valid( player ) && 
		!IS_DRINKING(player.is_drinking) && 
		!zm_utility::is_placeable_mine( weapon ) && 
		!zm_equipment::is_equipment( weapon ) && 
		(!player zm_utility::is_player_revive_tool(weapon) || weapon.name != "syrette_quick") &&
		!weapon.isheroweapon &&
		!weapon.isgadget
		)
		{
			if( zm_utility::is_hero_weapon( shareweapon ) )
			{
				player thread give_hero_weapon( shareweapon );
			}
			else
			{
				w_give = player zm_weapons::weapon_give(shareweapon);
				player thread aat::remove( w_give );
			}
			box magicweaponsharetimeout();
		}
	}
}

function give_hero_weapon( weapon )//self = player
{
	w_previous = self GetCurrentWeapon();
	self zm_weapons::weapon_give( weapon );
	self GadgetPowerSet( 0, 99 );
	self Setspawnweapon( weapon );
	self SetLowReady( true ); 
	self waittill( "weapon_change_complete" );
	self Setspawnweapon( w_previous );
	self SetLowReady( false );
	self util::waittill_any_timeout( 1.0, "weapon_change_complete" );
	self GadgetPowerSet( 0, 100 );
}