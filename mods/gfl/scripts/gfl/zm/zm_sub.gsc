#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;

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
#using scripts\gfl\zm\zm_sub;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_sub;

REGISTER_SYSTEM( "zm_sub", &__init__, undefined )

function __init__()
{
    util::registerClientSys( "sendsub" );
    callback::on_connect(&on_player_connect_sys);
}

function on_player_connect_sys(){
    self util::setClientSysState( "sendsub", "" );
}

function init(){
    callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	self endon("disconnect");

    self thread special_event_sub_think();
    self thread powerup_sub_think();
    self thread weapon_sub_think();
    self thread pap_sub_think();
    self thread bgb_sub_think();
    self thread magicboxshare_sub_think();
    self thread chat_sub_think();
}

function sub_logic(player, type, character, message)
{
	if( !( level flag::exists("start_zombie_round_logic") && level flag::get("start_zombie_round_logic") ) )
    {
        return;
    }

    if( level.script == "zm_der_bunker" )
    {
        return;
    }
        
    if( isdefined(level.gamevars) && IS_TRUE(level.gamevars["hardcore"]) )
    {
        return;
    }
        
    if( !isdefined(message) )
    {
        return;
    }

    if( isdefined(type) ){
        switch(type){
        case 1:
            color = "^1";
            break;
        case 2:
            color = "^2";
            break;
        case 3:
            color = "^7";
            break;
        }
    }

    if(isdefined(player))
    {
        if(isdefined(color))
        {
            if(isdefined(character))
            {
                player util::setClientSysState( "sendsub", color + character + "^7: " + message, player );
            }
            else
            {
                player util::setClientSysState( "sendsub", color + " ^7" + message, player );
            }
        }
        else
        {
            player util::setClientSysState( "sendsub", "^7" + message, player );
        }
    }
    else
    {
        foreach(player_e in GetPlayers())
        {
            if(isdefined(color))
            {
                if(isdefined(character))
                {
                    if( color == "^2" && player_e.name == character)
                    {
                        player_e util::setClientSysState( "sendsub", "^3" + character + "^7: " + message, player_e );
                    }
                    else
                    {
                        player_e util::setClientSysState( "sendsub", color + character + "^7: " + message, player_e );
                    }
                }
                else
                {
                    player_e util::setClientSysState( "sendsub", color + " ^7" + message, player_e );
                }
            }
            else
            {
               player_e util::setClientSysState( "sendsub", "^7" + message, player_e ); 
            }
        }
    }    
}

function sub_logic2(player, type, character, message)
{
    if(level.script == "zm_der_bunker")
        return;
        
    //if(isdefined(level.gamevars["hardcore"]) && level.gamevars["hardcore"] == true)
    //    return;
        
    if(!isdefined(message))
        return;

    if(isdefined(type)){
        switch(type){
            case 1:
                color = "^1";
                break;

            case 2:
                color = "^2";
                break;

            case 3:
                color = "^7";
                break;
        }
    }

    if(isdefined(player))
    {
        if(isdefined(color))
        {
            if(isdefined(character))
            {
                player util::setClientSysState( "sendsub", color + character + "^7: " + message, player );
            }
            else
            {
                player util::setClientSysState( "sendsub", color + " ^7" + message, player );
            }
        }else{
            player util::setClientSysState( "sendsub", "^7" + message, player );
        }
    }
    else
    {
        foreach(player_e in GetPlayers())
        {
            if(isdefined(color))
            {
                if(isdefined(character))
                {
                    if( color == "^2" && player_e.name == character)
                    {
                        player_e util::setClientSysState( "sendsub", "^3" + character + "^7: " + message, player_e );
                    }
                    else
                    {
                        player_e util::setClientSysState( "sendsub", color + character + "^7: " + message, player_e );
                    }
                }
                else
                {
                    player_e util::setClientSysState( "sendsub", color + " ^7" + message, player_e );
                }
            }
            else
            {
               player_e util::setClientSysState( "sendsub", "^7" + message, player_e ); 
            }
        }
    }    
}

function special_event_sub_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (true)
	{
		event = self util::waittill_any_return( "player_downed", "perk_bought", "start_chat_sub" );
        character_name = self character_mgr::get_character_name();

		if (event == "player_downed")
		{
			thread zm_sub::sub_logic(undefined, 2, character_name, "…SUBEVENT_PLAYER_DOWNED…");
		}

		if (event == "perk_bought")
		{
		    thread zm_sub::sub_logic(undefined, 2, character_name, "…SUBEVENT_GOTPERK…");
		}

        WAIT_SERVER_FRAME;
	}
}

function powerup_sub_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (true)
	{
		event = self util::waittill_any_return( "nuke_triggered" );
        character_name = self character_mgr::get_character_name();

		if (event == "nuke_triggered")
		{
			thread zm_sub::sub_logic(undefined, 2, character_name, "…SUBEVENT_NUKE…");
		}

        WAIT_SERVER_FRAME;
	}
}

function pap_sub_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (isdefined(self))
	{
		self waittill("pap_taken");
		self waittill("weapon_change");

        character_name = self character_mgr::get_character_name();
		self zm_sub::show_pap_sub(character_name);
        WAIT_SERVER_FRAME;
	}
}

function weapon_sub_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (isdefined(self))
	{
		self waittill("start_weapon_sub", weapon);

        character_name = self character_mgr::get_character_name();
		self zm_sub::show_weapon_sub(character_name, weapon);
        WAIT_SERVER_FRAME;
	}
}

function bgb_sub_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (isdefined(self))
	{
		self waittill("start_bgb_sub", bgb_string);

        character_name = self character_mgr::get_character_name();
		self zm_sub::show_bgb_sub(character_name, bgb_string);
        WAIT_SERVER_FRAME;
	}
}

function magicboxshare_sub_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (isdefined(self))
	{
		self waittill("magicbox_weapon_shared", weapon);

        character_name = self character_mgr::get_character_name();
		self zm_sub::show_magicboxshare_sub(character_name, weapon);
        WAIT_SERVER_FRAME;
	}
}

function chat_sub_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (isdefined(self))
	{
		self waittill("start_chat_sub", text);

        character_name = self character_mgr::get_character_name();
		thread zm_sub::sub_logic(undefined, 2, character_name, text);
        WAIT_SERVER_FRAME;
	}
}

function show_weapon_sub(character_name, weapon)
{
    wpname = weapon.name;
    if(isdefined(weapon.displayname) && weapon.displayname != "")
    {
        wpname = weapon.displayname;
    }

    if ( zm_weapons::is_wonder_weapon(weapon) )
    {
        thread sub_logic(undefined, 2, character_name, "…" + "…SUBEVENT_GOTWP… …" + wpname + "……SUBEVENT_DOT…" + " …SUBEVENT_GOT_WONDER_WEAPON…");
    }
    else
    {
        thread sub_logic(undefined, 2, character_name, "…" + "…SUBEVENT_GOTWP… …" + wpname + "……SUBEVENT_DOT…");
    }
}

function show_magicboxshare_sub(character_name, weapon)
{
    weapon_name = weapon.name;
    if(isdefined(weapon.displayname) && weapon.displayname != "")
    {
        weapon_name = weapon.displayname;
    }

    thread sub_logic(undefined, 2, character_name, "…SUBEVENT_SHAREWP… …" + weapon_name + "… …SUBEVENT_SHAREWPHERE……SUBEVENT_DOT…");
}

function show_bgb_sub(character_name, bgb_string)
{
    thread sub_logic(undefined, 2, character_name, "…" + "…SUBEVENT_GOTWP… …" + bgb_string + "……SUBEVENT_DOT…");
}

function show_pap_sub(character_name)
{
    upgradedweapon = self GetCurrentWeapon();
    if ( !zm_weapons::is_weapon_upgraded( upgradedweapon ) )
    {
        return;
    }

    baseweapon = zm_weapons::get_base_weapon(upgradedweapon);

    if(isdefined(upgradedweapon.displayname))
    {
        upname = upgradedweapon.displayname;
    }
    else
    {
        upname = upgradedweapon.name;
    }

    if(isdefined(baseweapon.displayname))
    {
        bsname = baseweapon.displayname;
    }
    else
    {
        bsname = baseweapon.name;
    }
    
    thread sub_logic(undefined, 2, character_name, "…SUBEVENT_GOT_PAP… …" + bsname + "… (…" + upname + "…)…SUBEVENT_DOT…");
}