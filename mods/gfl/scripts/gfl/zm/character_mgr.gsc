#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm_audio;

#using scripts\gfl\character;
#using scripts\gfl\character_util;
#using scripts\gfl\core_util;
#using scripts\gfl\_chat_notify;
#using scripts\gfl\zm\zm_character;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace character_mgr;

#define ALTBODY_BODYTYPE_INDEX 4
#define ALTBODY_BODYSTYLE_INDEX 4

#precache( "lui_menu_data", "hudItems.CharacterPopup" );

REGISTER_SYSTEM_EX( "character_mgr", &__init__, &__main__, undefined )

function private __init__()
{
	util::registerClientSys( "gfl_character_icon" );
	if( is_enabled() )
	{
		chat_notify::register_chat_notify_callback( "char", &on_message_sent );
	}
	
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );

	character::init_character_table();
	zm_character::init_character_table();
	init_randomized_character_table();

	spawner::add_archetype_spawn_function("zombie", &zombie_model_override);
}

function private __main__()
{
	if ( level.script == "zm_moon" || level.script == "zm_tomb" )
	{
		// prone to crash
		// level.save_character_customization_func = &save_character_customization_moon;
	}
	else
	{
		// level.save_character_customization_func = &save_character_customization;
		level._givecustomcharacters_old = level.givecustomcharacters;
		level.givecustomcharacters = &set_character_on_spawned;
	}
}

function on_player_connect()
{
    util::setClientSysState( "gfl_character_icon", "none", self );
	
	if ( level.script == "zm_moon" || level.script == "zm_tomb" )
	{
		return;
	}

	self thread ingame_character_menu_think();
	self thread lock_cc_think();
}

function on_player_spawned()
{
	self endon("disconnect");
	self endon("death");
	self endon("bled_out");

	if ( level.script == "zm_moon" || level.script == "zm_tomb" )
	{
		return;
	}

	if( !is_enabled() )
	{
		return;
	}

	self thread set_character_customization();

	if ( level.script == "zm_zod" )
	{
		// self thread altbody_exit_cc_fix();
		self thread altbody_enter_cc_fix();
	}

    if ( is_cc_watcher_needed() )
    {
		self save_cc_fix();
		wait_interval = 1;
		if ( level.script == "zm_leviathan" )
		{
			wait_interval = 0.05;
		}
		
        self thread cc_watcher_think(wait_interval);
    }
}

function is_enabled()
{
	if( GetDvarInt("tfoption_player_determined_character", 0) || GetDvarInt("tfoption_randomize_character", 0) )
	{
		return true;
	}

	return false;
}

function set_character_on_spawned()
{
	self pre_give_custom_character();

	if(isdefined(level._givecustomcharacters_old))
	{
		self [[level._givecustomcharacters_old]]();
	}

	self post_give_custom_character();
}

function pre_give_custom_character()
{
	if( GetDvarInt("tfoption_player_determined_character", 0) )
	{
		self save_character_customization();

		if( GetDvarInt("tfoption_randomize_character", 0) )
		{
			self set_random_character_for_bot();
		}
	}
	else
	{
		if( GetDvarInt("tfoption_randomize_character", 0) )
		{
			self set_random_character();
		}
	}
}

function post_give_custom_character()
{
	self set_character_customization();
}

function on_message_sent(args)
{
	if ( !isdefined(args) )
	{
		return;
	}

	if ( args.size != 1 || args[0] == "" )
	{
		usage_text = "usage: /char/[character name]";
		desc_text = "characters: ";
		key = get_character_table_type();
		characters = GetArrayKeys(level.charactertable[key]);
		self IPrintLnBold(usage_text);
		count = 0;
		row_length = 15;
		foreach (char in characters)
		{
			if ( count >= row_length )
			{
				self IPrintLnBold(desc_text);
				desc_text = "";
				count = 0;
			}

			desc_text += char;
			desc_text += " ";
			count += 1;
		}
		self IPrintLnBold(desc_text);
		return;
	}

	if ( !self core_util::is_player_alive() )
	{
		return;
	}

	if ( !is_enabled() )
	{
		self IPrintLnBold("Player-determined and randomized character are disabled by the host.");
		return;
	}

	character = args[0];
	if ( character == "random" )
	{
		self set_random_character();
		self thread show_character_popup();
		return;
	}

	type = get_character_table_type();
	if ( character_util::is_character_valid(type, character) )
	{
		self set_character(character);
		self thread show_character_popup();
	}
}

function is_cc_watcher_needed()
{
	if ( level.script == "zm_leviathan" )
	{
		return true;
	}

	if ( level.script == "zm_destiny_tower_beta" )
	{
		return true;
	}

	if ( level.script == "zm_alcatraz_island" )
	{
		return true;
	}

	return false;
}

function get_character_table_type()
{
	if ( level.script == "zm_moon" || level.script == "zm_tomb" )
	{
		return "zm_moon";
	}

	return "zm";
}

function init_randomized_character_table()
{
	level.randomized_character_table = [];
	key = get_character_table_type();

	// 4 players in total
	for (i = 0; i < 4; i++)
	{
		level.randomized_character_table[i] = array::randomize(getarraykeys(level.charactertable[key]));
	}
}

function get_random_character(characterindex = 0)
{
	index = array::random(level.randomized_character_table[characterindex]);
    return index;
}

function show_character_popup(args = undefined)
{
	struct = self get_character_struct();
	if (!isdefined(struct))
	{
		return;
	}

    simplified = get_simplified_character(struct.id);

    self SetControllerUIModelValue("hudItems.CharacterPopup", simplified);
    wait 0.05;
    self SetControllerUIModelValue("hudItems.CharacterPopup", "none");
}

// model fix related
function altbody_exit_cc_fix()
{
	self endon("disconnect");
	self endon("death");
	self endon("bled_out");

	while (true)
	{
		self waittill("altbody_end");
		while (true)
		{
			if ( isdefined(self.altbody) && self.altbody == 0 )
			{
				self set_character_customization();
				break;
			}
			wait 0.1;
		}
		wait 1;
	}
}

function altbody_enter_cc_fix()
{
	self endon("disconnect");
	self endon("death");
	self endon("bled_out");

	if ( !self flag::exists("in_beastmode") )
	{
		return;
	}

	while (true)
	{
		self flag::wait_till("in_beastmode");
		wait 0.05;
		bodytype = self GetCharacterBodyType();
		if ( bodytype == ALTBODY_BODYTYPE_INDEX )
		{
			self setcharacterbodystyle(ALTBODY_BODYSTYLE_INDEX);
		}
		wait 0.05;
	}
}

function save_cc_fix(use_ultimis_bodystyle = false)
{
	if ( isdefined(self.cc_bodytype) && isdefined(self.cc_bodystyle) )
	{
		return;
	}

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
			if (use_ultimis_bodystyle) 
			{
				bodystyle = 2;
			}
			else 
			{
				bodystyle = 0;
			}
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
			break;
		}
	}

	self.cc_bodytype = bodytype;
	self.cc_bodystyle = bodystyle;
}

function cc_watcher_think( wait_interval = 1 )
{
	self endon("disconnect");
	self endon("death");
	self endon("bled_out");

    while (true)
    {
		bodytype = self GetCharacterBodyType();
		if ( isdefined(self.cc_bodytype) && bodytype != self.cc_bodytype )
		{
			self notify("unwanted_cc_changes_detected");
		}

        wait(wait_interval);
    }
}

function lock_cc_think()
{
	self endon("disconnect");

    while (true)
    {
		WAIT_SERVER_FRAME;
		self waittill("unwanted_cc_changes_detected");

		if ( !self core_util::is_player_alive() )
		{
			continue;
		}

		self set_character_customization();
    }
}

function ingame_character_menu_think()
{
	self endon("disconnect");
	
	if ( self IsTestClient() )
	{
		return;
	}

    while (true)
    {
		WAIT_SERVER_FRAME;
		self waittill("menuresponse", menu, response);
        if ( !(menu == "popup_leavegame" && IsSubStr(response, "CharacterSystem") ) )
        {
            continue;
        }

		if ( !is_enabled() )
		{
			self IPrintLnBold("Player-determined and randomized character are disabled by the host.");
			wait 1;
			continue;
		}

		if ( !self core_util::is_player_alive() )
		{
			wait 1;
			continue;
		}

		arr = StrTok(response, ",");
		if ( arr.size != 2 )
		{
			continue;
		}
		// self IPrintLnBold(response);

		char = arr[1];
		if ( char == "random" )
		{
			self set_random_character();
			self thread show_character_popup();
		}
		else
		{
			type = get_character_table_type();
			if ( character_util::is_character_valid(type, char) )
			{
				self set_character(char);
				self thread show_character_popup();
			}
		}
    }
}

function zombie_model_fix()
{
	self endon("death");
	level endon("game_ended");
	level endon("end_game");

	if (isvehicle(self) || isplayer(self))
	{
		return;
	}

	if ( !self character_util::is_force_reset_required() )
	{
		return;
	}

	if ( !( issubstr(self.model, "c_54i_") || issubstr(self.model, "c_nrc_") || issubstr(self.model, "c_zsf_") ) )
	{
		return;
	}

	type = "generic";
	if ( issubstr(self.model, "c_54i_") || issubstr(self.model, "c_nrc_") )
	{
		type = "sf";
	}
	
	self character_util::set_disable_character_name_flag();
	self character_util::randomize_character(type);
	self character_util::set_force_reset_flag();
	self character_util::disable_gib();
}

function zombie_model_override()
{
	self endon("death");
	level endon("game_ended");
	level endon("end_game");

	if ( !GetDvarInt("tfoption_tdoll_zombie", 0) )
	{
		self zombie_model_fix();
		return;
	}

	// modded zombie skeleton are not compatible with the default one used by gfl assets
	if ( level.script == "zm_aliens_acheron" )
	{
		return;
	}

	if (isvehicle(self) || isplayer(self))
	{
		return;
	}

	if ( !self character_util::is_force_reset_required() && self character_util::is_character_swapped() )
	{
		return;
	}

	type = "generic_tdoll";
	switch( GetDvarInt("tfoption_tdoll_zombie", 0) )
	{
		case 1:
		{
			type = "generic_tdoll";
			break;
		}
		case 2:
		{
			type = "sf";
			break;
		}
		case 3:
		{
			type = "generic_sf";
			break;
		}
		default:
		{
			break;
		}
	}
	
	self character_util::set_disable_character_name_flag();
	self character_util::randomize_character(type);
	self character_util::set_force_reset_flag();
	self character_util::disable_gib();
}

function get_character_struct()
{
	type = get_character_table_type();
	struct = undefined;
	if ( isdefined(self.cc_id) && character_util::is_character_valid(type, self.cc_id) )
	{
		struct = level.charactertable[type][self.cc_id];
	}
	else
	{
		struct = self get_character_struct_by_model();
	}

	return struct;
}

function get_character_struct_by_model()
{
	model = self GetCharacterBodyModel();
	type = get_character_table_type();
	structs = level.charactertable[type];

	if ( !isdefined(model) )
	{
		return undefined;
	}

	foreach( struct in structs )
	{
		if ( isdefined(struct.keywords) )
		{
			foreach (keyword in struct.keywords)
			{
				if( !issubstr(model, keyword) )
				{
					continue;
				}

				return struct;
			}
		}

		if ( isdefined(struct.id) )
		{
			if( issubstr(model, struct.id) )
			{
				return struct;
			}
		}
	}

	return undefined;
}

function save_character_customization()
{
	// bots always use the first character (dempsey/m16a1)
	if ( self IsTestClient() )
	{
		return;
	}

	if ( isdefined(self.cc_bodytype) && isdefined(self.cc_bodystyle) )
	{
		return;
	}

	struct = self get_character_struct_by_model();
	if ( !isdefined(struct) )
	{
		return;
	}

	self.cc_bodytype = struct.bodytype;
	self.cc_bodystyle = struct.bodystyle;
	self.cc_id = struct.id;
}

function save_character_customization_moon()
{
	if ( self IsTestClient() )
	{
		return;
	}

	if ( isdefined(self.cc_bodytype) && isdefined(self.cc_bodystyle) )
	{
		return;
	}

	bodytype = self GetCharacterBodyType();
	bodystyle = 0;

	if (bodytype > 8 || bodytype == 4)
	{
		bodytype = undefined;
		bodystyle = undefined;
	}

	self.cc_bodytype = bodytype;
	self.cc_bodystyle = bodystyle;
	self.cc_id = undefined;
}

function set_character(character)
{
	type = get_character_table_type();
	if ( !character_util::is_character_valid(type, character) )
	{
		return;
	}

	struct = level.charactertable[type][character];
	self.cc_bodytype = struct.bodytype;
	self.cc_bodystyle = struct.bodystyle;
	self.cc_id = struct.id;
	self character_util::swap_to_cc();
	self set_icon(struct.id);
	// self IPrintLnBold(self.cc_id);
}

function set_character_customization()
{
	// level flag::wait_till("all_players_spawned");

	self character_util::swap_to_cc();
	func_index = undefined;
	if ( isdefined( self.cc_id ) )
	{
		func_index = self.cc_id;
	}

	self set_icon(func_index);
}

function set_random_character_for_bot()
{
	if ( !self IsTestClient() )
	{
		return;
	}

	self set_random_character();
}

function set_random_character()
{
	// level flag::wait_till("all_players_spawned");
	characterindex = self.characterindex;
	if ( !isdefined(characterindex) || characterindex >= level.randomized_character_table.size)
	{
		characterindex = randomint(level.randomized_character_table.size);
	}

    char = get_random_character(characterindex);
	self set_character(char);
}

function set_icon(func_index)
{
	icon_index = "none";
	if ( isdefined(func_index) )
	{
		icon_index = func_index;
	}
	// works for the current client only
	util::setClientSysState( "gfl_character_icon", icon_index, self );
}

function get_character_name(fallback_name = undefined)
{
	result = "Unknown T-Doll";
	if (isdefined(fallback_name))
	{
		result = fallback_name;
	}

	struct = self get_character_struct();
	if ( !isdefined(struct) )
	{
		return result;
	}

	if ( isdefined(struct.name) )
	{
		result = struct.name;
	}

	return result;
}

function get_simplified_character(name)
{
    if ( issubstr(name, "mp7") )
    {
        return "mp7";
    }

    if ( issubstr(name, "vepley") )
    {
        return "vepley";
    }

	return name;
}

// test func
function revolve_character_test()
{
	self endon("disconnect");

	index = 0;
	key = get_character_table_type();
	characters = GetArrayKeys(level.charactertable[key]);

	while(true)
	{
		if (index >= characters.size)
		{
			index = 0;
		}

		char = characters[index];
		characterindex = self.characterindex;
		self set_character(char);
		index += 1;
		wait 2;
	}
}

function random_character_test()
{
	self endon("disconnect");
	while(true)
	{
		self set_random_character();
		wait 2;
	}
}