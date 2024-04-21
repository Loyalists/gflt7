#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;

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

#using scripts\gfl\zm\character_randomizer;
#using scripts\gfl\zm\perkplus;
#using scripts\gfl\zm\t8_perkloss;
#using scripts\gfl\zm\magicboxshare;
#using scripts\gfl\zm\mule_kick_indicator;
#using scripts\gfl\zm\mule_kick_return;
#using scripts\gfl\zm\zm_bot;
#using scripts\gfl\zm\zm_counter;
#using scripts\gfl\zm\zm_sub;
#using scripts\gfl\zm\coldwar_scoreevent;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\zm\_zm_perks.gsh;

#namespace gameplay;

function init()
{
    character_randomizer::init();
    mule_kick_indicator::init();

    callback::on_connecting( &on_player_connecting );
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );

	if( GetDvarInt("tfoption_subtitles", 0) )
	{
        zm_sub::init();
	}

	if( GetDvarInt("tfoption_bot", 0) )
	{
    	zm_bot::init();
	}

    if( GetDvarInt("tfoption_perk_lose", 0) )
    {
        t8_perkloss::init();
    }

    if( GetDvarInt("tfoption_perkplus", 0) )
    {
        perkplus::init();
    }

    if( GetDvarInt("tfoption_perkplus", 0) || GetDvarInt("tfoption_perk_lose", 0) )
    {
        mule_kick_return::init();
    }

    if( GetDvarInt("tfoption_boxshare", 0) )
    {
        magicboxshare::init();
    }

	if ( GetDvarInt("tfoption_cheats", 0) )
	{
		thread enable_cheats();
	}
    else
    {
        thread disable_cheats();
    }

    if( GetDvarInt("tfoption_friendlyfire", 0) )
    {
        zm::register_player_friendly_fire_callback(&friendlyfire_damage);
    }

    if( GetDvarInt("tfoption_bgb_off", 0) )
    {
        thread disable_bgb();
    }

    if( GetDvarInt("tfoption_zcounter_enabled", 0) ) {
        zm_counter::init();
    }

    if( GetDvarInt("tfoption_cw_scoreevent", 0) )
    {
        coldwar_scoreevent::init();
    }

	if ( level.script == "zm_moon" )
	{
        level.zombiemode_gasmask_reset_player_model = &gasmask_reset_player_model;
        level.zombiemode_gasmask_reset_player_viewmodel = &gasmask_reset_player_set_viewmodel;
        level.zombiemode_gasmask_change_player_headmodel = &gasmask_change_player_headmodel;
        level.zombiemode_gasmask_set_player_model = &gasmask_reset_player_model;
	}
}

function on_player_connecting()
{

}

function on_player_connect()
{
	self endon("disconnect");

    if( GetDvarInt("tfoption_roundrevive", 0) )
    {
        self thread revive_at_end_of_round();
    }
}

function on_player_spawned()
{
	self endon("disconnect");
	self endon("bled_out");
}

function enable_cheats()
{
	level waittill( "initial_blackscreen_passed" ); 
    SetDvar("sv_cheats", 1);
}

function disable_cheats()
{
	level waittill( "initial_blackscreen_passed" ); 
    SetDvar("sv_cheats", 0);
}

function revive_at_end_of_round()
{
	self endon("disconnect");
	level waittill( "initial_blackscreen_passed" ); 
	
	while (isdefined(self))
	{
		level waittill("end_of_round");
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
		wait 3;
    }
}

function disable_bgb()
{
    level waittill( "initial_blackscreen_passed" ); 

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
        self thread friendlyfire_logic( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex );
    }
    return;
}

function friendlyfire_logic( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{    
    switch(GetDvarInt("tfoption_friendlyfire", 0)) 
    {
        case 1:
            //normal ff
            self DoDamage(int(100/4), vPoint, undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
            break;
    
        case 2:
            //share both
            eAttacker DoDamage(int(100/2), eAttacker GetEye(), undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
            self DoDamage(int(100/2), vPoint, undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
    
        case 3:
            //revert to me
            eAttacker DoDamage(int(100/4), eAttacker GetEye(), undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
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
                if( int(100/4) >= self.health)
                { 
                    self DoDamage(self.health - 1, vPoint, undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
                }
                else
                {
                    self DoDamage(int(100/4), vPoint, undefined, undefined, sHitLoc, "MOD_PROJECTILE", iDFlags , GetWeapon("pistol_standard_upgraded"));
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

