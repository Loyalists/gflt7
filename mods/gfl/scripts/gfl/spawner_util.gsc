#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;

#using scripts\gfl\character_util;

#namespace spawner_util;

function reset_friendly_character_for_spawner(type = "generic", check_model_name_func = undefined)
{
	if ( !self character_util::is_human() )
	{
		return;
	}

	team = "allies";
	self reset_character_for_spawner(team, type, check_model_name_func);
}

function reset_friendly_civilian_character_for_spawner(type = "generic", check_model_name_func = undefined)
{
	if ( !self character_util::is_civilian() )
	{
		return;
	}

	team = "allies";
	self reset_character_for_spawner(team, type, check_model_name_func);
}

function reset_enemy_character_for_spawner(type = "generic", check_model_name_func = undefined)
{
	team = "axis";
	self reset_character_for_spawner(team, type, check_model_name_func);
}

function reset_character_for_spawner(team, type = "generic", check_model_name_func = undefined)
{
	if ( self.team != team )
	{
		return;
	}

	if ( !self character_util::is_swapping_required(check_model_name_func) )
	{
		return;
	}

	self character_util::randomize_character(type);
	self character_util::set_force_reset_flag();
}