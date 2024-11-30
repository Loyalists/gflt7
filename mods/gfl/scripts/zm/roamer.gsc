#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_melee_weapon;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\statstable_shared.gsh;
#insert scripts\shared\version.gsh;

#namespace roamer;

function init() 
{
    if (isdefined(level.func_get_delay_between_rounds))
    {
        level._zombie_between_round_time_old = [[level.func_get_delay_between_rounds]]();
    }

    if ( !isdefined(level._zombie_between_round_time_old) )
    {
        if ( isdefined(level.zombie_vars) && isdefined(level.zombie_vars["zombie_between_round_time"]) )
        {
            level._zombie_between_round_time_old = level.zombie_vars["zombie_between_round_time"];
        }
        else
        {
            level._zombie_between_round_time_old = 10;
        }
    }

    createRoamerHud();
    level._round_end_custom_logic_old = level.round_end_custom_logic;
    level.round_end_custom_logic = &roamer;

    if( GetDvarInt("tfoption_roamer_enabled", 0) )
    {
        zombie_utility::set_zombie_var( "zombie_between_round_time", 0);
    }
}

function roamer() 
{
    deadlock = get_deadlock();
    if( !GetDvarInt("tfoption_roamer_enabled", 0) || deadlock )
    {
        if ( isdefined( level._zombie_between_round_time_old ) )
        {
            zombie_utility::set_zombie_var( "zombie_between_round_time", level._zombie_between_round_time_old);
        }

        if ( isdefined( level._round_end_custom_logic_old ) )
        {
            [[level._round_end_custom_logic_old]]();
        }
        
        return;
    }
    
    zombie_utility::set_zombie_var( "zombie_between_round_time", 0);
    timer = GetDvarInt("tfoption_roamer_time", 0);
    if(timer != 0) {
        level thread roamer_wait_time();
    }

    level thread roamer_hud_think();
    level thread wait_for_round_end_notify();
    level thread handle_deadlock();
    level waittill("continue_round");
}

function roamer_hud_think()
{
    level notify("roamer_hud_think");
    level endon("roamer_hud_think");

    level.roamer_hud thread show_roamer_hud(1.5);

    timer = GetDvarInt("tfoption_roamer_time", 0);
    if(timer != 0) {
        level.roamer_counter thread show_roamer_hud(1.5); 
    }

    level util::waittill_any_return("continue_round", "end_game", "kill_round");
    level.roamer_hud thread hide_roamer_hud(1.5);
    level.roamer_counter thread hide_roamer_hud(1.5); 
}

function roamer_wait_time() 
{
    level endon("continue_round");
    oldRound = level.round_number;
    
    timeLeft = GetDvarInt("tfoption_roamer_time", 0);
    level.roamer_counter SetValue(timeLeft);
    while(timeLeft > 0) {
        wait 1;
        timeLeft --;
        level.roamer_counter SetValue(timeLeft);
    }
    level notify("continue_round");
}

function wait_for_round_end_notify()
{
    level endon("end_game");
    level endon("continue_round");
	level endon("kill_round");

    while(1)
    {
        foreach(player in GetPlayers())
        {
            if (player MeleeButtonPressed() && player AdsButtonPressed())
            {
                level notify("continue_round");
            }
        }

        WAIT_SERVER_FRAME;
    }
}

function get_deadlock()
{
    deadlock = true;
    foreach(player in GetPlayers())
    {
        if (player IsTestClient())
        {
            continue;
        }

        if ( player.sessionstate != "spectator" && isalive(player) )
        {
            deadlock = false;
            break;
        }
    }
    
    return deadlock;
}

function handle_deadlock()
{
    level endon("end_game");
    level endon("continue_round");
	level endon("kill_round");

    while(1)
    {
        deadlock = get_deadlock();
        
        if (deadlock)
        {
            level notify("continue_round");
        }

        wait 2;
    }
}

//HUD STUFF
function show_roamer_hud(fadeTime)
{
	if(isDefined(fadeTime))
    {
		self FadeOverTime(fadeTime);
    }

    self.alpha = 1.0;
}

function hide_roamer_hud(fadeTime)
{
	if(isDefined(fadeTime))
    {
		self FadeOverTime(fadeTime);
    }

    self.alpha = 0;
}

function createRoamerHud(){
    level.roamer_hud = createNewHudElement("right", "top", -25, 20, 1, 1);
	level.roamer_hud hudRGBA((1,1,1), 0);
	level.roamer_hud SetText("Press ^3[{+toggleads_throw}]^7 + ^3[{+melee}]^7 to start next round"); 
    level.roamer_counter = createNewHudElement("right", "top", -25, 35, 1, 1);
    level.roamer_counter hudRGBA((1,1,1), 0);
    level.roamer_counter SetValue(0); 
}

function createNewHudElement(xAlign, yAlign, posX, posY, foreground, fontScale)
{
	hud = newHudElem();
	hud.horzAlign = xAlign; 
    hud.alignX = xAlign;
	hud.vertAlign = yAlign; 
    hug.alignY = yAlign;
	hud.x = posX; 
    hud.y = posY;
	hud.foreground = foreground;
	hud.fontscale = fontScale;
    hud.hidewheninmenu = true;
	return hud;
}

function hudRGBA(newColor, newAlpha, fadeTime)
{
	if(isDefined(fadeTime))
		self FadeOverTime(fadeTime);

	self.color = newColor;
	self.alpha = newAlpha;
}
