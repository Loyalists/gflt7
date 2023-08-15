#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;

#using scripts\gfl\character_util;
#using scripts\gfl\spawner_util;

#namespace cp_mi_eth_prologue;

function main()
{
    if ( level.script != "cp_mi_eth_prologue" ) 
    {
        return;
    }

	level thread character_util::reset_friendly_characters();
	level thread character_util::reset_friendly_civilian_characters();
	level thread character_util::reset_all_characters("generic", 0.5, &check_prisoner_model_name);
}

function check_prisoner_model_name()
{
	if(issubstr(self.model, "egypt_prisoner"))
	{
		return true;
	}

	return false;
}