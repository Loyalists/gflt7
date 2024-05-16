#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace clientsystem;

REGISTER_SYSTEM_EX( "clientsystem", &__init__, &__main__, undefined )

function private __init__()
{
	util::register_system( "clientsystem", &process_clientsystem_callback );
	clientsystem::register("setcldvar", &set_clientdvar);
	clientsystem::register("cldvar", &print_clientdvar);
}

function private __main__()
{

}

function register(system, callback)
{
	if(!isdefined(level.clientsystem_callbacks))
	{
		level.clientsystem_callbacks = [];
	}

	level.clientsystem_callbacks[system] = callback;
}

function process_clientsystem_callback(clientnum, system_states, old_system_states)
{
	self endon("entityshutdown");
    self endon("death");
	self endon("disconnect");
    self endon("bled_out");

	if(!isdefined(self))
	{
		return;
	}

	if(!isdefined(level.clientsystem_callbacks))
	{
		return;
	}

	tokenized = StrTok(system_states, ",");
	system = undefined;
	states = undefined;
	if (tokenized.size > 0)
	{
		system = tokenized[0];
		states = array::remove_index(tokenized, 0);
	}

	if (!isdefined(system) || !isdefined(states))
	{
		return;
	}

	callback = level.clientsystem_callbacks[system];
	if (!isdefined(callback))
	{
		return;
	}

	self thread [[callback]](clientnum, states);
}

function set_clientdvar( clientnum, key_value ) 
{
	if (!isdefined(key_value) || key_value.size < 2)
	{
		return;
	}

	key = key_value[0];
	value = key_value[1];
	setdvar(key,value);
}

function print_clientdvar(clientnum, args)
{
	if ( !isdefined(args) )
	{
		return;
	}

    dvar = args[0];
	if (dvar == "")
	{
		return;
	}

    value = GetDvarString(dvar, "undefined");
    IPrintLnBold("dvar: " + dvar + ", " + "value: " + value);
}