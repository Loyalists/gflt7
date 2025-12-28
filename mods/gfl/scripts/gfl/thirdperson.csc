#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#using scripts\gfl\clientsystem;

#insert scripts\shared\shared.gsh;

//How far ahead the focal point of the camera is (where it's pointing)
#define CAMERA_LOOKAT_DISTANCE 1000
#define COLLISION_PADDING 10

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

// old tps
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
    old_dvar2 = GetDvarInt("gfl_thirdperson2", 0);
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
        dvar2 = GetDvarInt("gfl_thirdperson2", 0);
        if (old_dvar == dvar && old_dvar2 == dvar2)
        {
            continue;
        }

        changed_dvar = 0;
        if (old_dvar != dvar)
        {
            changed_dvar = dvar;
        }
        else
        {
            changed_dvar = dvar2;
        }

        switch (changed_dvar)
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
        old_dvar2 = dvar2;
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
            self custom_third_person(true);
            self thread update_tps_crosshair(localClientNum);
        }
        else
        {
            setdvar("cg_thirdperson", 0);
            self custom_third_person(false);
            self stop_updating_tps_crosshair();
            self hide_tps_crosshair(localClientNum);
        }
        
        WAIT_CLIENT_FRAME;
    }
}

function set_back_camera()
{
    SetDvar("cg_thirdpersonrange", 90);
    SetDvar("cg_thirdpersonangle", 0);
    SetDvar("cg_thirdpersonsideoffset", 20);
    SetDvar("cg_thirdpersoncamoffsetup", -10);
    SetDvar("cg_thirdpersonupoffset", -5);
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

	ang = GetLocalClientAngles(localClientNum);
	if(!isdefined(ang))
    {
		return undefined;
    }
	// ang = (ang[0], ang[1], 0);

	forward = AnglesToForward(ang);
	right = AnglesToRight(ang);
	up = AnglesToUp(ang);

	eye_pos = GetLocalClientEyePos(localClientNum);

	if(!isdefined(eye_pos))
    {
		return undefined;
    }

    lookat_point = eye_pos + VectorScale( forward, 1000000 );
    a_trace = bullettrace(eye_pos, lookat_point, true, undefined);

    pos = a_trace["position"];
    return pos;
}

// new tps
function custom_third_person(enabled = true)
{
	if(enabled)
	{
		self camerasetupdatecallback(&spectate);
	}
	else
	{
		self camerasetupdatecallback();
		self.old_eye_height = undefined;
	}
}

function spectate(localclientnum, delta_time)
{
	player = getlocalplayer(localclientnum);
	if(!isdefined(player) || !player isplayer() || !isalive(player))
	{
		return;
	}
	if(isdefined(player.sessionstate))
	{
		if(player.sessionstate == "spectator")
		{
			return;
		}
		if(player.sessionstate == "intermission")
		{
			return;
		}
	}
	ang = GetLocalClientAngles(localClientNum);
	if(!isdefined(ang))
		return;
	ang = (ang[0], ang[1], 0);

	forward = AnglesToForward(ang);
	right = AnglesToRight(ang);
	up = AnglesToUp(ang);

	eye_height = GetLocalClientEyePos(localClientNum);

	if(!isdefined(eye_height))
		return;

	eye_height = eye_height[2] - player.origin[2];

	//Exponential Moving Average smoothing
	if(isdefined(self.old_eye_height))
	{
		eye_height = ema(self.old_eye_height,eye_height,0.05);
	}
	self.old_eye_height = eye_height;

	eye_pos = player.origin + (0,0,eye_height);

	cam_pos = eye_pos;
	cam_pos += VectorScale( right , GetDvarFloat("cg_thirdPersonSideOffset") );
	cam_pos += VectorScale( up , GetDvarFloat("cg_thirdPersonUpOffset") );

	//Used to check camera collision
	cam_trace_pos = cam_pos;

	cam_pos += VectorScale( forward , GetDvarFloat("cg_thirdPersonRange") * -1 );

	a_trace = beamtrace(cam_trace_pos, cam_pos, 0, player);
	if(a_trace["position"] != cam_pos)
	{
		cam_pos = a_trace["position"];
	}

	//We apply collision padding even without collision so the camera doesn't jump when it starts colliding. The effect is subtle, but you could always compensate with more range if you want
	cam_pos += VectorScale( forward , COLLISION_PADDING );
	

	lookat_point = eye_pos + VectorScale( forward , CAMERA_LOOKAT_DISTANCE );
	cam_angles = get_lookat_angles( cam_pos , lookat_point );

	player camerasetposition(cam_pos);
	player camerasetlookat(cam_angles);
}

function get_lookat_angles(v_start, v_end)
{
    v_dir = v_end - v_start;
    v_dir = vectornormalize(v_dir);
    v_angles = vectortoangles(v_dir);
    return v_angles;
}

function ema(old_val,new_val,alpha=0.1)
{
	return (alpha * new_val + (1 - alpha) * old_val);
}