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

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\zm\_zm_perks.gsh;

#namespace gameplay;

function init()
{
	if( GetDvarInt("tfoption_bot") )
	{
    	thread zm_bot::main();
	}

    character_randomizer::init();

    if( GetDvarInt("tfoption_perk_lose") )
    {
        t8_perkloss::init();
    }

    if( GetDvarInt("tfoption_perkplus") )
    {
        perkplus::init();
    }

    if( GetDvarInt("tfoption_perkplus") || GetDvarInt("tfoption_perk_lose") )
    {
        mule_kick_return::init();
    }

    if( GetDvarInt("tfoption_boxshare") )
    {
        thread magicboxshare::main();
    }

	if ( GetDvarInt("tfoption_cheats") )
	{
		thread enable_cheats();
	}

    mule_kick_indicator::init();

	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );

	if ( level.script == "zm_moon" )
	{
        level.zombiemode_gasmask_reset_player_model = &gasmask_reset_player_model;
        level.zombiemode_gasmask_reset_player_viewmodel = &gasmask_reset_player_set_viewmodel;
        level.zombiemode_gasmask_change_player_headmodel = &gasmask_change_player_headmodel;
        level.zombiemode_gasmask_set_player_model = &gasmask_reset_player_model;
	}
}

function on_player_connect()
{
	self endon("disconnect");

    if( GetDvarInt("tfoption_roundrevive") )
    {
        self thread revive_at_end_of_round();
    }
}

function on_player_spawned()
{
	self endon("disconnect");

    if( level.script == "zm_leviathan" && !GetDvarInt("tfoption_randomize_character") )
    {
        self thread leviathan_character_fix();
    }
}

function leviathan_character_fix()
{
	self endon("disconnect");
	self endon("death");

    if ( GetDvarInt("tfoption_player_determined_character") )
    {
        // apply the fix for bots only if player has a preferred playermodel
        if ( !self IsTestClient() )
        {
            return;
        }
    }

    while(true)
    {
        characterindex = self.characterindex;
        if ( !isdefined(characterindex) )
        {
            characterindex = 0;
        }

        bodytype = 0;
        bodystyle = 0;
        switch(characterindex)
        {
            case 0:
            {
                bodytype = 0;
                bodystyle = 2;
                break;
            }
            case 1:
            {
                bodytype = 1;
                bodystyle = 0;
                break;
            }
            case 2:
            {
                bodytype = 2;
                bodystyle = 0;
                break;
            }
            case 3:
            {
                bodytype = 3;
                bodystyle = 0;
                break;
            }
            default:
            {
                bodytype = 0;
                bodystyle = 0;
                break;
            }
        }
        self setcharacterbodytype(bodytype);
        self setcharacterbodystyle(bodystyle);
        self setcharacterhelmetstyle(0);
        wait(0.5);
    }
}

function enable_cheats()
{
	level waittill( "initial_blackscreen_passed" ); 
    SetDvar("sv_cheats", 1);
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