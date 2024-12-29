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
#precache( "objective", "gfl_objective_perk" );

REGISTER_SYSTEM_EX( "objective", &__init__, &__main__, undefined )

function private __init__()
{

}

function private __main__()
{
	thread wait_for_option_changed();
}

function is_enabled()
{
    if( GetDvarInt("tfoption_objectives", 0) )
    {
        return true;
    }

	return false;
}

function is_supported_by_map()
{
	return true;
}

function wait_for_option_changed()
{
	level endon("game_ended");
	level endon("end_game");
	level flag::wait_till("initial_blackscreen_passed");
	
    while (true)
    {
        level notify("objectives_setup");
        if ( is_enabled() )
        {
			objectives_setup();
        }
        else
        {
            clear_all_objectives();
        }
        WAIT_SERVER_FRAME;
        level waittill("tfoption_objectives_changed");
    }
}

function objectives_setup()
{
    level notify("objectives_setup");
    level endon("objectives_setup");
	level endon("game_ended");
	level endon("end_game");

	if ( !is_supported_by_map() )
	{
		return;
	}

    clear_all_objectives();

    level.gfl_objectives = [];
    level.gfl_3dprompt_objectives = [];

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

            origin = origin + vectorscale((0, 0, 1), 32);
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
        origin = trig.origin;
        origin = origin + vectorscale((0, 0, 1), 32);
		add_objective("pap", "gfl_objective_pap", trig.origin, trig);
    }
}

function perk_objectives_setup()
{
    level.gfl_objectives["perk"] = [];
    vending_triggers = GetEntArray("zombie_vending", "targetname");
    foreach (perk in vending_triggers)
    {
        origin = perk.origin;
        origin = origin + vectorscale((0, 0, 1), 32);
        add_objective("perk", "gfl_objective_perk", origin, perk);
    }
}

function add_3dprompt_objective(type, name, origin, target)
{
    t_use = spawn("trigger_radius_use", origin + vectorscale((0, 0, 1), 30), 0, 64, 64);
	t_use setvisibletoall();
	t_use usetriggerrequirelookat();
	t_use setteamfortrigger("none");
	t_use setcursorhint("HINT_INTERACTIVE_PROMPT");
    // t_use enablelinkto();
    // t_use linkto(target);

    visuals = [];
    use_object = gameobjects::create_use_object("any", t_use, visuals, vectorscale((0, 0, 1), 32), istring( name ));
	use_object gameobjects::allow_use("any");
	use_object gameobjects::set_owner_team("allies");
	use_object gameobjects::set_visible_team("any");
    use_object gameobjects::set_use_time(0.5);
    use_object.useweapon = undefined;
    use_object.origin = origin;
    target.gameobject = use_object;
    return use_object;
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
    if (!isdefined(level.gfl_objectives))
    {
        return;
    }

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