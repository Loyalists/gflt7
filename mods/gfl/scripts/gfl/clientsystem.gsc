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
    util::registerClientSys( "clientsystem" );
    callback::on_connect( &on_player_connect );
}

function private __main__()
{

}

function on_player_connect()
{
    util::setClientSysState( "clientsystem", "", self );
}

function set_states(system, states)
{
    if ( !isdefined(self) )
    {
        return;
    }

    if ( !isdefined(system) || !isdefined(states) )
    {
        return;
    }

    str = system;
    foreach (state in states)
    {
        str += ",";
        str += state;
    }
    util::setClientSysState( "clientsystem", str, self );
    // self IPrintLnBold(str + " " + "sent to" + " " + system);
}

function set_clientdvar(key, value)
{
    if ( !isdefined(self) )
    {
        return;
    }

    states = [];
    array::add( states, key );
    array::add( states, value );
    self clientsystem::set_states("cldvar", states);
}