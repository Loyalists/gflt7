#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\lui_shared;
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

#using scripts\gfl\zm\character_mgr;
#using scripts\gfl\zm\perkplus;
#using scripts\gfl\zm\t8_perkloss;
#using scripts\gfl\zm\magicboxshare;
#using scripts\gfl\zm\mule_kick_indicator;
#using scripts\gfl\zm\mule_kick_return;
#using scripts\gfl\zm\zm_bot;
#using scripts\gfl\zm\zm_counter;
#using scripts\gfl\zm\zm_sub;
#using scripts\gfl\zm\coldwar_scoreevent;
#using scripts\gfl\zm\_aae_zombie_health_bar;

#using scripts\gfl\_chat_notify;
#using scripts\gfl\core_util;
#using scripts\gfl\thirdperson;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\zm\_zm_perks.gsh;

#namespace gameplay;

#precache( "eventstring", "gfl_cheats_notification" );
#precache( "eventstring", "gfl_tdoll_zombies_notification" );

function init()
{
    mule_kick_indicator::init();
	chat_notify::register_chat_notify_callback( "popup", &on_popup_message_sent );

    callback::on_connecting( &on_player_connecting );
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );

    if( GetDvarInt("tfoption_perkplus", 0) )
    {
        perkplus::init();
    }

    zm::register_player_friendly_fire_callback(&friendlyfire_damage);

    if( GetDvarInt("tfoption_zcounter_enabled", 0) ) {
        zm_counter::init();
    }

    thread map_fixes();
    thread after_blackscreen_setup();

    repeated_setup();
}

function on_player_connecting()
{

}

function on_player_connect()
{
	self endon("disconnect");

    self thread revive_at_end_of_round();
    self thread mw3_intro_zm();
}

function on_player_spawned()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");

    if( GetDvarInt("tfoption_thirdperson", 0) )
    {
        self thread set_thirdperson_on_spawned();
    }

    self thread character_popup_think();
    self thread opening_notifications_think();
}

function on_popup_message_sent(args)
{
    if ( !isdefined(self) || !IsAlive(self) )
    {
        return;
    }

    if ( self.sessionstate == "spectator" )
    {
        return;
    }

    self._opening_notifications_shown = false;

    self thread character_popup_think();
    self thread opening_notifications_think();
}

function opening_notifications_think()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");

    level flag::wait_till( "initial_blackscreen_passed" );

    if ( IS_TRUE( self._opening_notifications_shown ) )
    {
        return;
    }

    self._opening_notifications_shown = true;
    interval = 3;

    wait 1;

    if ( GetDvarInt("tfoption_tdoll_zombie", 0) )
    {
        wait(interval);
        self LUINotifyEvent( &"gfl_tdoll_zombies_notification", 0 );
    }

    if ( core_util::is_cheats_enabled(false) )
    {
        // wait for character popup to fade away
        wait(interval);
        self LUINotifyEvent( &"gfl_cheats_notification", 0 );
    }
}

function character_popup_think()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");

    level flag::wait_till( "initial_blackscreen_passed" );

    wait 1;
    self character_mgr::show_character_popup();
}

function map_fixes()
{
	if ( level.script == "zm_moon" )
	{
        level.zombiemode_gasmask_reset_player_model = &gasmask_reset_player_model;
        level.zombiemode_gasmask_reset_player_viewmodel = &gasmask_reset_player_set_viewmodel;
        level.zombiemode_gasmask_change_player_headmodel = &gasmask_change_player_headmodel;
        level.zombiemode_gasmask_set_player_model = &gasmask_reset_player_model;
	}
}

function repeated_setup()
{
    level.player_too_many_weapons_monitor_func = &player_too_many_weapons_monitor;
    level.player_intersection_tracker_override = &core_util::always_true;
    level.disable_force_thirdperson = true;
}

function after_blackscreen_setup()
{
	level endon("game_ended");
	level endon("end_game");
	level waittill( "initial_blackscreen_passed" ); 

    repeated_setup();

    if( GetDvarInt("tfoption_bgb_off", 0) )
    {
        thread disable_bgb();
    }

	if ( GetDvarInt("tfoption_cheats", 0) )
	{
		thread core_util::enable_cheats();
	}
    else
    {
        thread core_util::disable_cheats();
    }
}

function set_thirdperson_on_spawned()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");

    if (self IsTestClient())
    {
        return;
    }

    self thread watch_for_mw3_intro();
    self.spectatingThirdPerson = true;
    self thirdperson::force_thirdperson();

    // bruteforce for any unexpected situation
    wait 0.2;
    self.spectatingThirdPerson = true;
    self thirdperson::force_thirdperson();
}

function watch_for_mw3_intro()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");

    while (isdefined(self))
    {
        self util::waittill_any_return("mw3_intro_cam_complete", "mw3_intro_complete");
        self thirdperson::force_thirdperson();
        WAIT_SERVER_FRAME;
    }
}

function revive_at_end_of_round()
{
	self endon("disconnect");
	level waittill( "initial_blackscreen_passed" ); 
	
	while (isdefined(self))
	{
		level waittill("end_of_round");
        if( !GetDvarInt("tfoption_roundrevive", 0) )
        {
            wait 1;
            continue;
        }

        if( GetPlayers().size > 1 )
        {
            if ( self laststand::player_is_in_laststand() || isDefined(self.revivetrigger) || (self.sessionstate == "spectator"))
            {
                self zm::spectator_respawn_player();
                self zm_laststand::auto_revive(level, 0);
                scoreevents::processScoreEvent( "auto_revive", self );
            }
        }
        if ( self.health != self.maxhealth )
        {
            self.health = self.maxhealth;
        }
		wait 1;
    }
}

function disable_bgb()
{
    bgbs = GetEntArray("bgb_machine_use", "targetname");
    foreach(bgb in bgbs)
    {
        if(isdefined(bgb.unitrigger_stub))
        {
            bgb.unitrigger_stub.og_origin = bgb.unitrigger_stub.origin;
            bgb.unitrigger_stub.temp_trig = Spawn( "trigger_radius_use", bgb.unitrigger_stub.og_origin, 0, 16, 16);
            bgb.unitrigger_stub.temp_trig SetTeamForTrigger("allies");
            bgb.unitrigger_stub.temp_trig SetCursorHint( "HINT_NOICON" );
            bgb.unitrigger_stub.temp_trig SetHintString(&"ZOMBIE_BGB_MACHINE_DISABLED");
            bgb.unitrigger_stub.origin = bgb.unitrigger_stub.og_origin - (1000,1000,1000);
            bgb SetZBarrierPieceState(3, "closed");
        }
    }
}

function mw3_intro_zm()
{
    while (level clientfield::get( "sndZMBFadeIn") != 1 ) 
    {
        WAIT_SERVER_FRAME;
    }

    self thread core_util::mw3_intro();
}

function gasmask_reset_player_model(entity_num)
{
	self setcharacterbodystyle(0);
    self setcharacterhelmetstyle(0);
}

function gasmask_reset_player_set_viewmodel(entity_num)
{
	gasmask_change_player_headmodel(entity_num, 0);
	self setcharacterbodystyle(0);
	level clientfield::set(("player" + self getentitynumber()) + "wearableItem", 0);
}

function gasmask_change_player_headmodel(entity_num, gasmask_active)
{
    self setcharacterbodystyle(0);
    self setcharacterhelmetstyle(0);
}

function friendlyfire_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{	
    if(self != eAttacker)
    {
        if( !GetDvarInt("tfoption_friendlyfire", 0) )
        {
            return;
        }

        self thread friendlyfire_logic( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex );
    }
    return;
}

function friendlyfire_logic( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
    dmg = int(100/4);
    dmg_shared = int(dmg / 2);
    switch(GetDvarInt("tfoption_friendlyfire", 0)) 
    {
        case 1:
            //normal ff
            self DoDamage(dmg, vPoint, undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
            break;
    
        case 2:
            //share both
            eAttacker DoDamage(dmg_shared, eAttacker GetEye(), undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
            self DoDamage(dmg_shared, vPoint, undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
    
        case 3:
            //revert to me
            eAttacker DoDamage(dmg, eAttacker GetEye(), undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
            break;
    
        case 4:
            //knock back
            if(sMeansOfDeath != "MOD_BURNED")
            {
                self ApplyKnockBack( 20, vDir );
            }
            break;
    
        case 5:
            //ff but cant kill
            if(self.health != 0 || self.health != 1)
            {
                if( dmg >= self.health)
                { 
                    self DoDamage(self.health - 1, vPoint, undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
                }
                else
                {
                    self DoDamage(dmg, vPoint, undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
                }
            }
            else
            {
                self DoDamage(0, vPoint, undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
            }
            break;
    
        default:
    }
}

function player_too_many_weapons_monitor()
{
	self notify( "stop_player_too_many_weapons_monitor" );
	self endon( "stop_player_too_many_weapons_monitor" );
	self endon( "disconnect" );
	level endon("game_ended");
	level endon( "end_game" );

	// load balancing
	scalar = self.characterindex;
	
	if ( !isdefined( scalar ) )
	{
		scalar = self GetEntityNumber();
	}
	
	wait( (0.15 * scalar) );

    too_many_weapons_monitor_wait_time = 3;
	while ( isdefined(self) )
	{
		if ( self zm_utility::has_powerup_weapon() || self laststand::player_is_in_laststand() || self.sessionstate == "spectator" || isdefined( self.laststandpistol ))
		{
			wait( too_many_weapons_monitor_wait_time );
			continue;
		}
		weapon_limit = zm_utility::get_player_weapon_limit( self );

		primaryWeapons = self GetWeaponsListPrimaries();

		if ( primaryWeapons.size > weapon_limit )
		{
			self zm_weapons::take_fallback_weapon();
			primaryWeapons = self GetWeaponsListPrimaries();
		}

		primary_weapons_to_take = [];
		for ( i = 0; i < primaryWeapons.size; i++ )
		{
			if ( zm_weapons::is_weapon_included( primaryWeapons[i] ) || zm_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
			{
				primary_weapons_to_take[primary_weapons_to_take.size] = primaryWeapons[i];
			}
		}

		if ( primary_weapons_to_take.size > weapon_limit )
		{
			if ( !isdefined( level.player_too_many_weapons_monitor_callback ) || self [[level.player_too_many_weapons_monitor_callback]]( primary_weapons_to_take ) )
			{
				//track the cheaters
				//self zm_stats::increment_map_cheat_stat( "cheat_too_many_weapons" );
				//self zm_stats::increment_client_stat( "cheat_too_many_weapons",false );
				//self zm_stats::increment_client_stat( "cheat_total",false );
				
				
				//self thread player_too_many_weapons_monitor_takeaway_sequence( primary_weapons_to_take );
				self playlocalsound( level.zmb_laugh_alias );
				foreach(weapon in primaryWeapons) 
				{
					if(weapon.name == "defaultweapon")
					{
						self takeWeapon(weapon);
					}
				}
				if(isinarray(primary_weapons_to_take, self.currentweapon))
				{
					self takeweapon(self.currentweapon);
				}
				else
				{
					self takeweapon(primary_weapons_to_take[0]);
				}
				self SwitchToWeaponImmediate(self GetWeaponsListPrimaries()[0]);
				wait(1);
				if(!self getweaponslistprimaries().size)
				{
					self zm_utility::give_start_weapon( true );
				}

				//self waittill( "player_too_many_weapons_monitor_takeaway_sequence_done" );
			}
		}

		//self waittill("weapon_change_complete");
		wait( too_many_weapons_monitor_wait_time );
	}
}