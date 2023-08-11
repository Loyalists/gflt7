#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;

#using scripts\gfl\character_util;
#using scripts\gfl\spawner_util;

#namespace cp_mi_cairo_lotus;

function main()
{
    if ( level.script != "cp_mi_cairo_lotus" && level.script != "cp_mi_cairo_lotus2" && level.script != "cp_mi_cairo_lotus3" ) 
    {
        return;
    }

	level thread character_util::reset_friendly_characters();
	level thread character_util::reset_friendly_civilian_characters();
}