#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;

#using scripts\gfl\character_util;
#using scripts\gfl\spawner_util;

#namespace safehouse;

function main()
{
    if ( !( level.script == "cp_sh_cairo" || level.script == "cp_sh_mobile" || level.script == "cp_sh_singapore" ) ) 
    {
        return;
    }

    level thread reset_safehouse_characters();
    array::run_all(GetSpawnerArray(), &spawner::add_spawn_function, &spawner_util::reset_enemy_character_for_spawner, "training_sim");
    // level thread character_util::reset_enemy_characters("training_sim", 0.2);
}

function reset_safehouse_characters()
{
	array::run_all(GetSpawnerArray(), &spawner::add_spawn_function, &spawner_util::reset_friendly_character_for_spawner, "generic");
	array::run_all(GetSpawnerArray(), &spawner::add_spawn_function, &spawner_util::reset_friendly_civilian_character_for_spawner, "generic");
	// level thread character_util::reset_friendly_characters();
	// level thread character_util::reset_friendly_civilian_characters();
}
