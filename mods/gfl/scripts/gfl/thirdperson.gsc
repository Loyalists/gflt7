#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\array_shared;

#using scripts\gfl\_chat_notify;
#using scripts\gfl\clientsystem;

#insert scripts\shared\shared.gsh;

REGISTER_SYSTEM_EX( "thirdperson", &__init__, &__main__, undefined )

function private __init__()
{
    callback::on_spawned( &on_player_spawned );
    chat_notify::register_chat_notify_callback( "tps", &on_message_sent );
    chat_notify::register_chat_notify_callback( "tpscam", &on_tpscam_message_sent );
}

function private __main__()
{

}

function on_message_sent(args)
{
    if (isDefined(self.no_skip) || isDefined(self.current_player_scene))
    {
        return;
    }

    self IPrintLnBold("Third Person");
    self toggle_thirdperson();
}

function on_tpscam_message_sent(args)
{
	if ( !isdefined(args) )
	{
		return;
	}

	if ( args.size != 1 || args[0] == "" )
	{
		usage_text = "usage: /tpscam/[camera preset]";
        desc_text = "example: /tpscam/front";
		self IPrintLnBold(usage_text);
        self IPrintLnBold(desc_text);
		return;
	}

    preset = args[0];
    switch (preset)
    {
    case "front":
    case "back":
    case "side":
        break;
    default:
        preset = undefined;
        break;
    }

    if (!isdefined(preset))
    {
        return;
    }

    self set_thirdperson_camera_state(preset);
}

function on_player_spawned()
{
	level endon("game_ended");
	level endon("end_game");
    self endon("disconnect");
    self endon("death");
    self endon("bled_out");

    if (IS_TRUE(level.disable_force_thirdperson))
    {
        return;
    }
    
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
        self set_thirdperson_state("off");
    }
    else
    {
        self SetClientThirdPerson( 1 );
        self.spectatingThirdPerson = true;
        self set_thirdperson_state("on");
    }

    self notify("toggle_thirdperson");
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
        self set_thirdperson_state("on");
    }
    else
    {
        self SetClientThirdPerson( 0 );
        self.spectatingThirdPerson = false;
        self set_thirdperson_state("off");
    }
}

function set_thirdperson_state(state)
{
    self clientsystem::set_state("tps", state);
}

function set_thirdperson_camera_state(state)
{
    self clientsystem::set_state("tpscam", state);
}