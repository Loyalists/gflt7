#using scripts\shared\array_shared;

#insert scripts\shared\shared.gsh;

#namespace character_util;

function disable_gib()
{
	if(isdefined(self.gib_data))
	{
		self.gib_data = undefined;
	}

	if(isdefined(self.gibdef))
	{
		self.gibdef = undefined;
	}
}

function reset_all_characters(type = "generic", wait_interval = 0.5, check_model_name_func = undefined)
{
	level endon("game_ended");
	while(true)
	{
		aiarray = getaiarray();
		foreach(ai in aiarray)
		{
			if ( !ai is_swapping_required(check_model_name_func, &is_human_or_civilian) )
			{
				continue;
			}

			ai randomize_character(type);
			ai set_force_reset_flag();
			ai disable_gib();
		}

		wait(wait_interval);
	}
}

function reset_friendly_characters(type = "generic", wait_interval = 0.5, check_model_name_func = undefined)
{
	level endon("game_ended");
	while(true)
	{
		aiarray = getaiteamarray("allies");
		foreach(ai in aiarray)
		{
			if ( !ai is_swapping_required(check_model_name_func, &is_human) )
			{
				continue;
			}

			ai randomize_character(type);
			ai set_force_reset_flag();
			ai disable_gib();
		}

		wait(wait_interval);
	}
}

function reset_friendly_civilian_characters(type = "generic", wait_interval = 0.5, check_model_name_func = undefined)
{
	level endon("game_ended");
	while(true)
	{
		aiarray = getaiteamarray("allies");
		foreach(ai in aiarray)
		{
			if ( !ai is_swapping_required(check_model_name_func, &is_civilian) )
			{
				continue;
			}

			ai randomize_character(type);
			ai set_force_reset_flag();
			ai disable_gib();
		}

		wait(wait_interval);
	}
}

function reset_enemy_characters(type = "generic", wait_interval = 0.5, check_model_name_func = undefined)
{
	level endon("game_ended");
	while(true)
	{
		aiarray = getaiteamarray("axis");
		foreach(ai in aiarray)
		{
			if ( !ai is_swapping_required(check_model_name_func, &is_human_or_civilian) )
			{
				continue;
			}

			ai randomize_character(type);
			ai set_force_reset_flag();
			ai disable_gib();
		}

		wait(wait_interval);
	}
}

function reset_zombie_characters(type = "generic", wait_interval = 0.5, check_model_name_func = undefined)
{
	level endon("game_ended");
	while(true)
	{
		aiarray = getaiarray();
		foreach(ai in aiarray)
		{
			if ( !ai is_swapping_required(check_model_name_func, &is_zombie) )
			{
				continue;
			}

			ai randomize_character(type);
			ai set_force_reset_flag();
			ai disable_gib();
		}

		wait(wait_interval);
	}
}

function is_swapping_required(check_model_name_func = undefined, check_archetype_func = undefined)
{
	if ( self is_hero() )
	{
		return false;
	}
	
	if ( IsFunctionPtr(check_archetype_func) && !self [[check_archetype_func]]() )
	{
		return false;
	}

	if ( IsFunctionPtr(check_model_name_func) && !self [[check_model_name_func]]() )
	{
		return false;
	}

	if ( !self is_force_reset_required() && self is_character_swapped() )
	{
		return false;
	}

	return true;
}

function randomize_character(type)
{
	characters = get_characters(type);
	self swap_character(type, array::random(characters));
}

function get_characters(type)
{
	if ( !isdefined( level.charactertable[type] ) )
	{
		return [];
	}

	keys = getarraykeys(level.charactertable[type]);
	return keys;
}

function swap_character(type, character)
{
	if ( !isdefined( level.charactertable[type] ) )
	{
		return;
	}

	if ( !isdefined( level.charactertable[type][character] ) )
	{
		return;
	}

	func = level.charactertable[type][character];
	self [[func]]();
	self.character_table_index = character;
}

function swap_to_cc()
{
	if ( !( isdefined( self.cc_bodytype ) && isdefined( self.cc_bodystyle ) ) )
	{
		return;
	}

	self detachall();
	self setcharacterbodytype(self.cc_bodytype);
	self setcharacterbodystyle(self.cc_bodystyle);
	self setcharacterhelmetstyle(0);
}

function set_character_name()
{
    self endon("death");

	if ( !isdefined( self.model ) )
	{
		return;
	}

	row_count = tablelookuprowcount("gamedata/gfl/nametable.csv");
	for (row = 1; row < row_count; row++)
	{
		modelsubstr = tablelookupcolumnforrow("gamedata/gfl/nametable.csv", row, 0);
		if (!issubstr(self.model, modelsubstr))
		{
			continue;
		}

		name = tablelookupcolumnforrow("gamedata/gfl/nametable.csv", row, 1);
		self.propername = name;
	}
}

function is_human()
{
	if (isvehicle(self))
	{
		return false;
	}

	if (issubstr(self.archetype, "human"))
	{
		return true;
	}

	return false;
}

function is_civilian()
{
	if (isvehicle(self))
	{
		return false;
	}

	if (issubstr(self.archetype, "civilian"))
	{
		return true;
	}

	return false;
}

function is_human_or_civilian()
{
	if (self is_human())
	{
		return true;
	}

	if (self is_civilian())
	{
		return true;
	}

	return false;
}

function is_hero()
{
	if (isdefined(self.is_hero) && self.is_hero)
	{
		return true;
	}

	if (issubstr(self.model, "_hro_"))
	{
		return true;
	}

	return false;
}

function is_zombie()
{
	if (isvehicle(self))
	{
		return false;
	}

	if (issubstr(self.archetype, "zombie"))
	{
		return true;
	}

	return false;
}

function is_character_swapped()
{
	if (issubstr(self.model, "_gfl_"))
	{
		return true;
	}

	return false;
}

function is_force_reset_required()
{
	if (!isdefined(self.force_reset))
	{
		return true;
	}

	if (self.force_reset != true)
	{
		return true;
	}

	return false;
}

function set_force_reset_flag()
{
	self.force_reset = true;
}