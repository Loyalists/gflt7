#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\gameobjects_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_pack_a_punch_util;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\zm\_zm_perks.gsh;

#namespace objective;

#precache( "objective", "gfl_objective_power" );
#precache( "objective", "gfl_objective_pap" );

REGISTER_SYSTEM_EX( "objective", &__init__, &__main__, undefined )

function private __init__()
{

}

function private __main__()
{
	thread objectives_setup();
}

function is_enabled()
{
    if( GetDvarInt("tfoption_objectives", 0) )
    {
        return true;
    }

	return true;
}

function objectives_setup()
{
    level notify("objectives_setup");
    level endon("objectives_setup");
	level endon("game_ended");
	level endon("end_game");
	level waittill( "initial_blackscreen_passed" ); 

    clear_all_objectives();

    level.gfl_objectives = [];

    power_objectives_setup();
	pap_objectives_setup();
    perk_objectives_setup();
}

function power_objectives_setup()
{
    level.gfl_objectives["power"] = [];
    presets = array("elec", "power", "master");
    foreach(preset in presets)
    {
        ents = getentarray("use_" + preset + "_switch", "targetname");
        foreach(ent in ents)
        {
            if (!isdefined(ent) || !isdefined(ent.origin))
            {
                continue;
            }

            origin = ent.origin;
            if (isdefined(ent.trigger))
            {
                origin = ent.trigger.origin;
            }

            add_objective("power", "gfl_objective_power", origin, ent);
        }
    }

    thread power_objectives_cleanup();
}

function power_objectives_cleanup()
{
	level endon("game_ended");
	level endon("end_game");
    level endon("objectives_setup");
    level flag::wait_till( "power_on" );

    clear_objectives("power");
}

function pap_objectives_setup()
{
    level.gfl_objectives["pap"] = [];
	if (!isdefined(level.pack_a_punch))
	{
		return;
	}

	triggers = level.pack_a_punch.triggers;
    foreach(trig in triggers)
    {
		add_objective("pap", "gfl_objective_pap", trig.origin, trig);
    }
}

function perk_objectives_setup()
{
    level.gfl_objectives["perk"] = [];
    vending_triggers = GetEntArray("zombie_vending", "targetname");
    foreach (perk in vending_triggers)
    {
        add_objective("perk", "gfl_objective_perk", perk.origin, perk);
    }
}

function add_objective(type, name, origin, target = undefined)
{
    obj_id = gameobjects::get_next_obj_id();
    objective_add( obj_id, "active", origin, istring( name ) );

	obj = SpawnStruct();
	obj.id = obj_id;
    obj.type = type;
    obj.target = target;

    if (!isdefined(level.gfl_objectives[type]))
    {
        level.gfl_objectives[type] = [];
    }

    str_obj_id = "" + obj_id;
    if (isdefined(level.gfl_objectives[type][str_obj_id]))
    {
        remove_objective(obj_id);
    }

    level.gfl_objectives[type][str_obj_id] = obj;
    return obj;
}

function add_objective_on_entity(type, name, entity)
{
    obj = add_objective(type, name, entity.origin, entity);
	Objective_OnEntity( obj.id, entity );
    return obj;
}

function clear_all_objectives()
{
    if (!isdefined(level.gfl_objectives))
    {
        return;
    }

    keys = GetArrayKeys(level.gfl_objectives);
    foreach (type in keys)
    {
        clear_objectives(type);
    }
}

function clear_objectives(type)
{
    if (!isdefined(level.gfl_objectives[type]))
    {
        return;
    }

    foreach (obj in level.gfl_objectives[type])
    {
        id = obj.id;
        objective_delete( id );
        gameobjects::release_obj_id( id );
    }

    level.gfl_objectives[type] = [];
}

function remove_objective(id)
{
    keys = GetArrayKeys(level.gfl_objectives);
    str_id = "" + id;
    foreach (type in keys)
    {
        objs = level.gfl_objectives[type];
        if ( !isdefined(objs[str_id]) )
        {
            continue;
        }

        objective_delete( id );
        gameobjects::release_obj_id( id );
        level.gfl_objectives[type][str_id] = undefined;
        break;
    }
}