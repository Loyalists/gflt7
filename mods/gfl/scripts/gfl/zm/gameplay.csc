#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#using scripts\gfl\zm\character_mgr;
#using scripts\gfl\zm\zm_sub;
#using scripts\gfl\zm\_aae_zombie_health_bar;
#using scripts\gfl\zm\_zm_jup_hud;

#insert scripts\shared\shared.gsh;

#namespace gameplay;

function init()
{
	callback::on_localclient_connect( &on_player_connect );
	callback::on_localplayer_spawned( &on_player_spawned );
}

function on_player_connect(localClientNum)
{
	self endon("disconnect");
}

function on_player_spawned(localClientNum)
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");
	self endon("entityshutdown");

    self thread player_screen_cos(localClientNum);
}

function player_screen_cos(localClientNum)
{
    self notify("player_screen_cos");
    self endon("player_screen_cos");
    self endon("entityshutdown");
    self endon("disconnect");

    controllerModel = GetUIModelForController( localClientNum );
    UpdateHudfire = GetUIModel( controllerModel, "hudItems.hud_offset" );
    self thread viewpos_update(localClientNum);

    for(;;)
    {
        speed = self calculate_2D_speed(localClientNum);
        SetUIModelValue( UpdateHudfire, "" + speed[0] + "," + speed[1] );
        waitrealtime(0.1);
    }
}

function calculate_2D_speed(localClientNum)
{
    view_pos_3D = self.viewpos;
    
    pos_2D = Project3Dto2D(localClientNum,view_pos_3D);
    speed_2D_x = pos_2D[0] - 640;
    speed_2D_y = pos_2D[1] - 360;
    return (speed_2D_x ,speed_2D_y ,0);
}

function viewpos_update(localClientNum)
{
    self notify("viewpos_update");
    self endon("viewpos_update");
    self endon("entityshutdown");
    self endon("disconnect");

    for(;;)
    {
        viewpos = self GetPlayerCamPos(localClientNum) + AnglesToForward(GetCamAnglesByLocalClientNum(localclientnum)) * 100;
        WAIT_CLIENT_FRAME;
        self.viewpos = viewpos;
    }
}

function GetPlayerCamPos(localClientNum)
{
    /*angles = GetCamAnglesByLocalClientNum(localclientnum);
    base_origin = self.origin + AnglesToForward(angles) * 5;
    cam_to_base = Distance(base_origin, GetLocalClientEyePos(localClientNum));
    SubtitlePrint(localclientnum, 2000, cam_to_base);
    origin = base_origin + (0,0,cam_to_base);*/
    return GetLocalClientEyePos(localClientNum);
}