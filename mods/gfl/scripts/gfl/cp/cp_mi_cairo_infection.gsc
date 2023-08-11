#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;

#using scripts\gfl\character_util;
#using scripts\gfl\spawner_util;

#namespace cp_mi_cairo_infection;

function main()
{
    if ( !( level.script == "cp_mi_cairo_infection" || level.script == "cp_mi_cairo_infection2" ) ) 
    {
        return;
    }

    if (level.script == "cp_mi_cairo_infection")
    {
        level thread character_util::reset_friendly_characters();
    }
    else
    {
        level thread character_util::reset_friendly_characters("generic_infection", 0.2, &check_ww2_gi_model_name);
        level thread character_util::reset_enemy_characters("generic", 0.2, &check_german_model_name);
    }
}

function check_ww2_gi_model_name()
{
	if(issubstr(self.model, "usa_ww2_gi"))
	{
		return true;
	}

	return false;
}

function check_german_model_name()
{
	if(issubstr(self.model, "ger_winter_soldier"))
	{
		return true;
	}

	return false;
}