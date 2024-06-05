#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace core_util;

function void( ... )
{
}

function always_true( ... )
{
    return true;
}

function always_false( ... )
{
    return false;
}

function enable_cheats()
{
    SetDvar("sv_cheats", 1);
}

function disable_cheats()
{
    SetDvar("sv_cheats", 0);
}

function is_cheats_enabled( check_tfoption = true )
{
    if ( GetDvarInt("sv_cheats", 0) || GetDvarInt("developer", 0) )
    {
        return true;
    }

    if ( IS_TRUE(check_tfoption) )
    {
        if ( GetDvarInt("tfoption_cheats", 0) )
        {
            return true;
        }
    }

    return false;
}

function mw3_intro()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");
	
	if ( !isdefined(self) )
	{
		return;
	}

    self DisableWeaponCycling();
    self DisableOffhandWeapons();
    self DisableWeapons(true);
    self mw3_intro_cam();
    self notify("mw3_intro_cam_complete");
    self EnableWeapons();
    foreach(weapon in self GetWeaponsListPrimaries())
    {
        self ShouldDoInitialWeaponRaise( weapon, true );
        self SwitchToWeapon(weapon);
        self waittill("weapon_change_complete");
        self ShouldDoInitialWeaponRaise( weapon, false );
    }
    self EnableOffhandWeapons();
    self EnableWeaponCycling();
    self notify("mw3_intro_complete");
}

function mw3_intro_cam()
{
    if ( self IsTestClient() )
    {
        return;
    }

    // if ( level.script == "zm_tomb" || level.script == "zm_theater" || level.script == "zm_asylum" )
    // {
    //     return;
    // }

    self freezecontrols( 1 );
    cam_time = 1.2;
    cam_height = 2000;
    player_origin = self GetPlayerCameraPos() + AnglesToForward(self.angles) * 20;
    //player_origin += ( 0,0,50 );
    cam = spawn( "script_model", ( 69.0, 69.0, 69.0 ) );
    cam setmodel( "tag_origin" );
    cam.origin = player_origin + ( 0, 0, cam_height );
    cam.angles = self.angles;
    cam.angles = ( cam.angles[0] + 89, cam.angles[1], 0 );
    self CameraSetPosition(cam);
    self CameraSetLookAt();
    self CameraActivate(true);
    cam moveto( player_origin + ( 0.0, 0.0, 0.0 ), cam_time, 0, cam_time );
    wait 0.05;
    //self playsound( "survival_slamzoom_out" );
    wait(cam_time - 0.55);
    self thread lui::screen_fade( 0.25, 1, 0 , "white" , false);
    //self visionsetnakedforplayer( "coup_sunblind", 0.25 );
    cam rotateto( ( cam.angles[0] - 89, cam.angles[1], 0 ), 0.5, 0.3, 0.2 );
    wait 0.2;
    self thread lui::screen_fade( 1.1, 0, 1 , "white" , false);
    wait 0.24;
    self CameraActivate(false);
    self freezecontrols( 0 );
    cam delete();
}