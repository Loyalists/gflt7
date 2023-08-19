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

#namespace character_randomizer;

function init()
{
	clientfield::register("toplayer", "gfl_character_icon", VERSION_SHIP, 4, "int");
	character::init_character_table();
	character_zm::init_character_table();
	init_randomized_character_table();
	spawner::add_archetype_spawn_function("zombie", &zombie_model_fix);

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

	if( GetDvarInt("tfoption_player_determined_character") )
	{
		level.save_character_customization_func = &save_character_customization_func;
		callback::on_spawned( &set_character_customization );

		if( GetDvarInt("tfoption_randomize_character") )
		{
			callback::on_spawned( &set_custom_character_for_bot );
		}
	}
	else
	{
		if( GetDvarInt("tfoption_randomize_character") )
		{
			callback::on_spawned( &set_custom_character );
		}
	}

	if ( level.script == "zm_zod" )
	{
		callback::on_spawned( &altbody_cc_fix );
	}
}

function zombie_model_fix()
{
	self endon( "death" );
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
	
	characters = character_util::get_characters(type);
	character = array::random(characters);
	self character_util::swap_character(type, character);
	self character_util::set_force_reset_flag();
	self character_util::disable_gib();
}

function init_moon()
{
	if( GetDvarInt("tfoption_player_determined_character") )
	{
		level.save_character_customization_func = &save_character_customization_func_moon;
		callback::on_spawned( &set_character_customization );
	}
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

function swap_character(function_index)
{
	key = get_character_table_key();
	self character_util::swap_character(key, function_index);
}

function altbody_cc_fix()
{
	self endon("disconnect");
	self endon("death");

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

function save_character_customization_func()
{
	if ( self IsTestClient() )
	{
		return;
	}

	bodytype = self GetCharacterBodyType();
	bodystyle = 0;
	model = self GetCharacterBodyModel();
	bodystyle_name = undefined;
	modelsubstrs = GetArrayKeys(level.additional_bodystyle_table);
	foreach( modelsubstr in modelsubstrs )
	{
		if( isdefined(model) && issubstr(model, modelsubstr) )
		{
			bodystyle = level.additional_bodystyle_table[modelsubstr];
			bodystyle_name = modelsubstr;
			break;
		}
	}

	self.cc_bodytype = bodytype;
	self.cc_bodystyle = bodystyle;
	self.cc_bodystyle_name = bodystyle_name;
}

function save_character_customization_func_moon()
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
		switch (self.cc_bodystyle_name)
		{
			case "t7_gfl_ro635_fb":
			{
				func_index = "ro635";
				break;
			}
			case "t7_gfl_g36c_fb":
			{
				func_index = "g36c";
				break;
			}
			case "t7_gfl_rfb_fb":
			{
				func_index = "rfb";
				break;
			}
			case "t7_gfl_st_ar15_fb":
			{
				func_index = "st_ar15";
				break;
			}
			case "t7_gfl_m4a1_fb":
			{
				func_index = "m4a1";
				break;
			}
			default:
			{
				func_index = undefined;
				break;
			}
		}
	}

	if ( isdefined( func_index ) )
	{
		self set_icon(func_index);
	}
}

function set_custom_character_for_bot()
{
	if ( !self IsTestClient() )
	{
		return;
	}

	self set_custom_character();
}

function set_custom_character()
{
	level flag::wait_till("all_players_spawned");
	characterindex = self.characterindex;
	if(!isdefined(characterindex))
	{
		characterindex = randomint(level.randomized_character_table.size);
	}

    func_index = randomize_character_function_index(characterindex);
	self swap_character(func_index);
	self set_icon(func_index);
}

function set_icon(func_index)
{
	icon_index = 0;
	switch (func_index)
	{
		case "ro635":
		{
			icon_index = 1;
			break;
		}
		case "g36c":
		{
			icon_index = 2;
			break;
		}
		case "rfb":
		{
			icon_index = 3;
			break;
		}
		case "st_ar15":
		{
			icon_index = 4;
			break;
		}
		case "m4a1":
		{
			icon_index = 5;
			break;
		}
		default:
		{
			icon_index = 0;
			break;
		}
	}
	// works for the current client only
	self clientfield::set_to_player("gfl_character_icon", icon_index);
}

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
		self swap_character(func_index);
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
		self set_custom_character();
		wait 2;
	}
}

function is_vanilla_map()
{
	maps = [];
	maps[maps.size] = "zm_zod";
	maps[maps.size] = "zm_factory";
	maps[maps.size] = "zm_castle";
	maps[maps.size] = "zm_island";
	maps[maps.size] = "zm_stalingrad";
	maps[maps.size] = "zm_genesis";
	maps[maps.size] = "zm_asylum";
	maps[maps.size] = "zm_cosmodrome";
	maps[maps.size] = "zm_prototype";
	maps[maps.size] = "zm_sumpf";
	maps[maps.size] = "zm_temple";
	maps[maps.size] = "zm_theater";
	maps[maps.size] = "zm_moon";
	maps[maps.size] = "zm_tomb";

	foreach( map in maps )
	{
		if ( level.script == map )
		{
			return true;
		}
	}
	return false;
}

function test_if_overrided()
{
	level waittill("initial_blackscreen_passed");
	iPrintLnBold("givecustomcharacters() is overrided!");
}