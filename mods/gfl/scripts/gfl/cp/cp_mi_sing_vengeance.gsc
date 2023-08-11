#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;

#using scripts\gfl\character_util;
#using scripts\gfl\spawner_util;

#namespace cp_mi_sing_vengeance;

function main()
{
    if ( level.script != "cp_mi_sing_vengeance" ) 
    {
        return;
    }

    level thread reset_civ_police();
}

function reset_civ_police()
{
	level thread character_util::reset_friendly_characters("generic", 0.2, &check_model_name);
	level thread character_util::reset_friendly_civilian_characters("generic", 0.2, &check_model_name);
}

function check_model_name()
{
	if(issubstr(self.model, "civ_sing_police"))
	{
		return true;
	}

	if(issubstr(self.model, "cia_blackstation"))
	{
		return true;
	}

	if(issubstr(self.model, "_bloody"))
	{
		return true;
	}

	return false;
}