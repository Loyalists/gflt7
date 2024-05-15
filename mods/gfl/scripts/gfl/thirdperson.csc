#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;

REGISTER_SYSTEM( "thirdperson", &__init__, undefined )

function private __init__()
{
    callback::on_spawned(&on_spawned);
}

function on_spawned(localClientNum)
{
    if(self != GetLocalPlayer(localClientNum))
    {
        return;
    }

    self thread watch_thirdperson_crosshair(localClientNum);
}

function watch_thirdperson_crosshair(localClientNum)
{
    self notify("watch_thirdperson_crosshair");
    self endon("watch_thirdperson_crosshair");
    self endon("entityshutdown");
    self endon("disconnect");
    self endon("death");

    while(1)
    {
        // self waittill("thirdperson_notified");
        // if (IsSpectating(localClientNum))
        // {
        //     break;
        // }

        if (IsThirdPerson(localClientNum))
        {
            set_back_camera();
            self thread update_thirdperson_crosshair(localClientNum);
            while (IsThirdPerson(localClientNum))
            {
                wait 0.5;
            }
        }
        else
        {
            self hide_thirdperson_crosshair(localClientNum);
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
    SetDvar("cg_thirdpersonupoffset", -30);
}

function update_thirdperson_crosshair(localClientNum)
{
    self notify("update_thirdperson_crosshair");
    self endon("update_thirdperson_crosshair");
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
            break;
        }

        // if (IsSpectating(localClientNum))
        // {
        //     break;
        // }

        pos = self get_trace_pos();
        if ( isdefined(pos) )
        {
            SetUIModelValue( crosshair_model, "" + pos[0] + "," + pos[1] + "," + pos[2] );
        }
        else
        {
            hide_thirdperson_crosshair(localClientNum);
        }
    }
}

function hide_thirdperson_crosshair(localclientnum)
{
    controller_model = GetUIModelForController( localClientNum );
    crosshair_model = GetUIModel( controller_model, "hudItems.ThirdpersonCrosshair" );

    if(isDefined(crosshair_model))
    {
        SetUIModelValue( crosshair_model, "0" );
    }
}

function get_trace_pos()
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