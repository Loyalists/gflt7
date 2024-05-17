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

function set_state(system, ...)
{
    if ( !isdefined(self) )
    {
        return;
    }

    if ( !isdefined(system) )
    {
        return;
    }

    str = system;
    if ( isdefined(vararg) )
    {
        foreach (arg in vararg)
        {
            str += ",";
            str += arg;
        }
    }

    util::setClientSysState( "clientsystem", str, self );
    // self IPrintLnBold(str + " " + "sent to" + " " + system);
}

function set_clientdvar(dvar, value)
{
    self clientsystem::set_state("setcldvar", dvar, value);
}

function print_clientdvar(dvar)
{
    self clientsystem::set_state("cldvar", dvar);
}