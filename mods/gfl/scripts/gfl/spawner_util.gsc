#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;

#using scripts\gfl\character_util;

#namespace spawner_util;

function reset_friendly_character_for_spawner(type = "generic", check_model_name_func = undefined)
{
	team = "allies";
	if ( self.team != team )
	{
		return;
	}

	if ( !self character_util::is_human() )
	{
		return;
	}

	self reset_character_for_spawner(type, check_model_name_func);
}

function reset_friendly_civilian_character_for_spawner(type = "generic", check_model_name_func = undefined)
{
	team = "allies";
	if ( self.team != team )
	{
		return;
	}

	if ( !self character_util::is_civilian() )
	{
		return;
	}

	self reset_character_for_spawner(type, check_model_name_func);
}

function reset_enemy_character_for_spawner(type = "generic", check_model_name_func = undefined)
{
	team = "axis";
	if ( self.team != team )
	{
		return;
	}

	if ( !self character_util::is_human_or_civilian() )
	{
		return;
	}
	

	self reset_character_for_spawner(type, check_model_name_func);
}

function reset_character_for_spawner(type = "generic", check_model_name_func = undefined, check_archetype_func = undefined)
{
	if ( !self character_util::is_swapping_required(check_model_name_func, check_archetype_func) )
	{
		return;
	}

	self character_util::randomize_character(type);
	self character_util::set_force_reset_flag();
	self character_util::disable_gib();
}