#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\spawner_shared;

#using scripts\zm\_zm_audio;

#using scripts\gfl\character;
#using scripts\gfl\character_util;
#using scripts\gfl\zm\character_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace character_mgr;

function init()
{
	util::registerClientSys( "gfl_character_icon" );
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );

	character::init_character_table();
	character_zm::init_character_table();
	init_randomized_character_table();

	if( GetDvarInt("tfoption_tdoll_zombie", 0) )
	{
		spawner::add_archetype_spawn_function("zombie", &zombie_model_override);
	}
	else
	{
		spawner::add_archetype_spawn_function("zombie", &zombie_model_fix);
	}

	if( !( GetDvarInt("tfoption_player_determined_character") || GetDvarInt("tfoption_randomize_character") ) )
	{
		return;
	}

	if ( level.script == "zm_moon" || level.script == "zm_tomb" )
	{
		// prone to crash
		// init_moon();
		return;
	}

	if( GetDvarInt("tfoption_player_determined_character", 0) )
	{
		level.save_character_customization_func = &save_character_customization;
	}
}

function init_moon()
{
	if( GetDvarInt("tfoption_player_determined_character", 0) )
	{
		level.save_character_customization_func = &save_character_customization_moon;
	}
}

function on_player_connect()
{
    util::setClientSysState( "gfl_character_icon", "none", self );
}

function on_player_spawned()
{
	self endon("disconnect");
	self endon("bled_out");

	if( GetDvarInt("tfoption_player_determined_character", 0) )
	{
		self thread set_character_customization();

		if( GetDvarInt("tfoption_randomize_character", 0) )
		{
			self thread set_random_character_for_bot();
		}
	}
	else
	{
		if( GetDvarInt("tfoption_randomize_character", 0) )
		{
			self thread set_random_character();
		}
	}

	if ( level.script == "zm_zod" )
	{
		self thread altbody_cc_fix();
	}

    if ( is_cc_watcher_needed() )
    {
		self save_cc_fix();
        self thread cc_watcher_think();
    }

	self thread lock_cc_think();
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

	return false;
}

function get_character_table_key()
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
	key = get_character_table_key();

	// 4 players in total
	for (i = 0; i < 4; i++)
	{
		level.randomized_character_table[i] = array::randomize(getarraykeys(level.charactertable[key]));
	}
}

function randomize_character_function_index(characterindex = 0)
{
	index = array::random(level.randomized_character_table[characterindex]);
    return index;
}


// model fix related
function altbody_cc_fix()
{
	self endon("disconnect");
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

function cc_watcher_think()
{
	self endon("disconnect");
	self endon("bled_out");

    while (true)
    {
		bodytype = self GetCharacterBodyType();
		if ( isdefined(self.cc_bodytype) && bodytype != self.cc_bodytype )
		{
			self notify("unwanted_cc_changes_detected");
		}

        WAIT_SERVER_FRAME;
    }
}

function lock_cc_think()
{
	self endon("disconnect");
	self endon("bled_out");

    while (true)
    {
		self waittill("unwanted_cc_changes_detected");
		self set_character_customization();
        WAIT_SERVER_FRAME;
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

	if ( !self character_util::is_force_reset_required() && self character_util::is_character_swapped() )
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

function save_character_customization()
{
	if ( self IsTestClient() )
	{
		return;
	}

	bodytype = self GetCharacterBodyType();
	bodystyle = 0;
	bodystyle_name = undefined;
	
	model = self GetCharacterBodyModel();
	modelsubstrs = GetArrayKeys(level.additional_bodystyle_table);
	foreach( modelsubstr in modelsubstrs )
	{
		if( isdefined(model) && issubstr(model, modelsubstr) )
		{
			bodystyle = level.additional_bodystyle_table[modelsubstr];
			character = level.model_to_character_table[modelsubstr];
			if ( isdefined(character) )
			{
				bodystyle_name = character;
			}
			break;
		}
	}

	self.cc_bodytype = bodytype;
	self.cc_bodystyle = bodystyle;
	self.cc_bodystyle_name = bodystyle_name;
}

function save_character_customization_moon()
{
	if ( self IsTestClient() )
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
	self.cc_bodystyle_name = undefined;
}

function set_character_customization()
{
	level flag::wait_till("all_players_spawned");

	self character_util::swap_to_cc();
	func_index = undefined;
	if ( isdefined( self.cc_bodystyle_name ) )
	{
		func_index = self.cc_bodystyle_name;
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
	level flag::wait_till("all_players_spawned");
	characterindex = self.characterindex;
	if(!isdefined(characterindex))
	{
		characterindex = randomint(level.randomized_character_table.size);
	}

    func_index = randomize_character_function_index(characterindex);
	key = get_character_table_key();
	self character_util::swap_character(key, func_index);
	self set_icon(func_index);
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

function get_character_name_by_model(fallback_name = undefined)
{
	result = "Unknown";
	if ( isdefined(fallback_name) )
	{
		result = fallback_name;
	}

	model = self GetCharacterBodyModel();
	modelsubstrs = GetArrayKeys(level.model_to_character_name_table);

	foreach( modelsubstr in modelsubstrs )
	{
		if( isdefined(model) && issubstr(model, modelsubstr) )
		{
			name = level.model_to_character_name_table[modelsubstr];
			result = name;
			break;
		}
	}

	return result;
}

// test func
function revolve_character_test()
{
	self endon("disconnect");

	index = 0;
	key = get_character_table_key();
	characters = GetArrayKeys(level.charactertable[key]);

	while(true)
	{
		if (index >= characters.size)
		{
			index = 0;
		}

		func_index = characters[index];
		characterindex = self.characterindex;
		self character_util::swap_character(key, func_index);
		self set_icon(func_index);
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

function test_if_overrided()
{
	level waittill("initial_blackscreen_passed");
	iPrintLnBold("givecustomcharacters() is overrided!");
}