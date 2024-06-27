#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#using scripts\gfl\clientsystem;

#insert scripts\shared\shared.gsh;

REGISTER_SYSTEM( "thirdperson", &__init__, undefined )

function private __init__()
{
    callback::on_localplayer_spawned(&on_spawned);
    clientsystem::register("tps", &on_state_changed);
    clientsystem::register("tpscam", &on_tpscam_changed);
}

function on_spawned(localClientNum)
{
    if(self != GetLocalPlayer(localClientNum))
    {
        return;
    }

    self thread watch_for_command(localClientNum);
    self thread update_tps_crosshair(localClientNum);
    self thread tps_toggle_think(localClientNum);
}

function on_state_changed(localClientNum, states)
{
    if (states.size == 0)
    {
        return;
    }

    state = states[0];
    player = GetLocalPlayer(localClientNum);
    switch (state)
    {
    case "off":
        player notify("tps_off_notified");
        break;
    case "on":
        player notify("tps_on_notified");
        break;
    default:
        break;
    }
}

function on_tpscam_changed(localClientNum, states)
{
    if (states.size == 0)
    {
        return;
    }

    state = states[0];
    player = GetLocalPlayer(localClientNum);
    switch (state)
    {
    case "front":
        player set_front_camera();
        break;
    case "back":
        player set_back_camera();
        break;
    case "side":
        player set_side_camera();
        break;
    case "side2":
        player set_side2_camera();
        break;
    default:
        break;
    }
}

function watch_for_command(localClientNum)
{
    self notify("tps_watch_for_command");
    self endon("tps_watch_for_command");
    self endon("entityshutdown");
    self endon("disconnect");
    self endon("death");

    old_dvar = GetDvarInt("gfl_thirdperson", 0);
    while (true)
    {
        wait 0.2;
        player = GetLocalPlayer(localClientNum);
        if ( !isdefined(player) || !IsAlive(player) )
        {
            wait 1;
            continue;
        }

        dvar = GetDvarInt("gfl_thirdperson", 0);
        if (old_dvar == dvar)
        {
            continue;
        }

        switch (dvar)
        {
        case 1:
            player notify("tps_on_notified");
            break;
        case 0:
            player notify("tps_off_notified");
            break;
        default:
            break;
        }

        old_dvar = dvar;
    }
}

function tps_toggle_think(localClientNum)
{
    self notify("tps_toggle_think");
    self endon("tps_toggle_think");
    self endon("entityshutdown");
    self endon("disconnect");
    self endon("death");

    while(1)
    {
        event = self util::waittill_any_return("tps_off_notified", "tps_on_notified");

        if (event == "tps_on_notified")
        {
            setdvar("cg_thirdperson", 1);
            set_back_camera();
            self thread update_tps_crosshair(localClientNum);
        }
        else
        {
            setdvar("cg_thirdperson", 0);
            self stop_updating_tps_crosshair();
            self hide_tps_crosshair(localClientNum);
        }
        
        WAIT_CLIENT_FRAME;
    }
}

function set_back_camera()
{
    SetDvar("cg_thirdpersonrange", 60);
    SetDvar("cg_thirdpersonangle", -0.5);
    SetDvar("cg_thirdpersonsideoffset", 20);
    SetDvar("cg_thirdpersoncamoffsetup", -10);
    SetDvar("cg_thirdpersonupoffset", 5);
}

function set_front_camera()
{
    SetDvar("cg_thirdpersonrange", 90);
    SetDvar("cg_thirdpersonangle", 90);
    SetDvar("cg_thirdpersonsideoffset", 0);
    SetDvar("cg_thirdpersoncamoffsetup", 0);
    SetDvar("cg_thirdpersonupoffset", -20);
}

function set_side_camera()
{
    SetDvar("cg_thirdpersonrange", 90);
    SetDvar("cg_thirdpersonangle", 45);
    SetDvar("cg_thirdpersonsideoffset", 0);
    SetDvar("cg_thirdpersoncamoffsetup", 0);
    SetDvar("cg_thirdpersonupoffset", -20);
}

function set_side2_camera()
{
    SetDvar("cg_thirdpersonrange", 90);
    SetDvar("cg_thirdpersonangle", 135);
    SetDvar("cg_thirdpersonsideoffset", 0);
    SetDvar("cg_thirdpersoncamoffsetup", 0);
    SetDvar("cg_thirdpersonupoffset", -20);
}

function update_tps_crosshair(localClientNum)
{
    self notify("update_tps_crosshair");
    self endon("update_tps_crosshair");
    self endon("entityshutdown");
    self endon("disconnect");
    self endon("death");

    controller_model = GetUIModelForController( localClientNum );
    crosshair_model = GetUIModel( controller_model, "hudItems.ThirdpersonCrosshair" );

    while(1)
    {
        WAIT_CLIENT_FRAME;

        if ( !isdefined(self) )
        {
            break;
        }

        if ( !isdefined(crosshair_model) )
        {
            break;
        }

        if ( !IsThirdPerson(localClientNum) )
        {
            hide_tps_crosshair(localClientNum);
            wait 0.5;
            continue;
        }

        pos = self get_trace_pos(localClientNum);
        if ( isdefined(pos) )
        {
            SetUIModelValue( crosshair_model, "" + pos[0] + "," + pos[1] + "," + pos[2] );
        }
        else
        {
            hide_tps_crosshair(localClientNum);
        }
    }

    hide_tps_crosshair(localClientNum);
}

function stop_updating_tps_crosshair()
{
    self notify("update_tps_crosshair");
}

function hide_tps_crosshair(localClientNum)
{
    controller_model = GetUIModelForController( localClientNum );
    crosshair_model = GetUIModel( controller_model, "hudItems.ThirdpersonCrosshair" );

    if(isDefined(crosshair_model))
    {
        SetUIModelValue( crosshair_model, "0" );
    }
}

function get_trace_pos(localClientNum)
{
    if ( !isdefined(self) )
    {
        return undefined;
    }

    camPos = self GetCamPos();
    camAngles = self GetCamAngles();
    if ( !isdefined(camPos) || !isdefined(camAngles) )
    {
        return undefined;
    }

    a_trace = bullettrace(camPos, camPos + AnglesToForward(camAngles) * 1000000, true, undefined);

    pos = a_trace["position"];
    return pos;
}