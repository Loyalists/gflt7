#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace clientdvar;

REGISTER_SYSTEM( "clientdvar", &__init__, undefined )

function __init__()
{
    util::registerClientSys( "elmg_clientdvar" );
    callback::on_connect(&on_player_connect);
}

function on_player_connect(){
    self util::setClientSysState( "elmg_clientdvar", "" );
}

function sendclientdvar(dvar)
{
    if(isdefined(self))
    {
        self util::setClientSysState( "elmg_clientdvar", dvar, self );
    }
}