#using scripts\shared\array_shared;
#using scripts\shared\spawner_shared;

#using scripts\gfl\character;
#using scripts\gfl\character_util;
#using scripts\gfl\cp\safehouse;
#using scripts\gfl\cp\cp_mi_eth_prologue;
#using scripts\gfl\cp\cp_mi_sing_vengeance;
#using scripts\gfl\cp\cp_mi_cairo_aquifer;
#using scripts\gfl\cp\cp_mi_cairo_ramses;
#using scripts\gfl\cp\cp_mi_cairo_infection;
#using scripts\gfl\cp\cp_mi_cairo_lotus;

#namespace cp_load;

function main() 
{
	if (level.game_mode_suffix != "_cp")
	{
		return;
	}

	setdvar("sv_cheats", 1);
	character::init_character_table();
	thread set_character_name_for_all_ais();
	// thread character_util::reset_all_characters();
	spawner::add_archetype_spawn_function("human", &character_util::disable_gib);
	spawner::add_archetype_spawn_function("human_riotshield", &character_util::disable_gib);
	spawner::add_archetype_spawn_function("civilian", &character_util::disable_gib);
	
	// map related patches
	thread safehouse::main();
	thread cp_mi_eth_prologue::main();
	thread cp_mi_sing_vengeance::main();
	thread cp_mi_cairo_aquifer::main();
	thread cp_mi_cairo_ramses::main();
	thread cp_mi_cairo_infection::main();
	thread cp_mi_cairo_lotus::main();
}

function set_character_name_for_all_ais()
{
	level endon("game_ended");
	while(true)
	{
		aiarray = getaiteamarray("allies");
		foreach(ai in aiarray)
		{
			if (isvehicle(self))
			{
				continue;
			}

			ai thread character_util::set_character_name();
		}

		wait(2);
	}
}