#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\array_shared;

#using scripts\gfl\_chat_notify;

#insert scripts\shared\shared.gsh;

REGISTER_SYSTEM_EX( "thirdperson", &__init__, &__main__, undefined )

function private __init__()
{
    callback::on_spawned( &on_player_spawned );
    chat_notify::register_chat_notify_callback( &on_message_sent, "tps" );
}

function private __main__()
{

}

function on_message_sent()
{
    if (isDefined(self.no_skip) || isDefined(self.current_player_scene))
    {
        return;
    }
    
    // if ( !isalive(self) )
    // {
    //     return;
    // }

    self IPrintLnBold("Third Person");
    self toggle_thirdperson();
}

function on_player_spawned()
{
    self endon("disconnect");
    self endon("death");
    self endon("bled_out");
	level endon("game_ended");
	level endon("end_game");

    self force_thirdperson();
}

function toggle_thirdperson()
{
    if (!isdefined(self))
    {
        return;
    }

    if (IS_TRUE(self.spectatingThirdPerson))
    {
        self SetClientThirdPerson( 0 );
        self.spectatingThirdPerson = false;
        self util::clientNotify("thirdperson_notified");
    }
    else
    {
        self SetClientThirdPerson( 1 );
        self.spectatingThirdPerson = true;
        self util::clientNotify("thirdperson_notified");
    }
}

function force_thirdperson()
{
    if (!isdefined(self))
    {
        return;
    }

    if (IS_TRUE(self.spectatingThirdPerson))
    {
        self SetClientThirdPerson( 1 );
        self.spectatingThirdPerson = true;
        self util::clientNotify("thirdperson_notified");
    }
    else
    {
        self SetClientThirdPerson( 0 );
        self.spectatingThirdPerson = false;
        self util::clientNotify("thirdperson_notified");
    }
}