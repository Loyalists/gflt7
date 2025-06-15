/*
	Created by Andy King (treminaor) for UGX-Mods.com. © UGX-Mods 2016
	Please include credit if you use this script and do not distribute edited versions of it without my permission.
	Contact: twitter.com/treminaor
	Instructions: https://confluence.ugx-mods.com/display/UGXMODS/BO3+%7C+Adding+Timed+Gameplay+to+Zombiemode

	Version: 1.0 10/13/2016 8:59PM
*/

#using scripts\shared\flag_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;

#insert scripts\shared\shared.gsh;

//default round_wait func but without a check for zero zombies alive, which allows for continuous spawning
function round_wait_override()
{
	level endon("restart_round");
	level endon( "kill_round" );

	wait( 1 );

	while( 1 )
	{
		should_wait = ( level.zombie_total > 0 || level.intermission );	
		if( !should_wait )
		{
			return;
		}			
			
		if( level flag::get( "end_round_wait" ) )
		{
			return;
		}
		wait( 1.0 );
	}
}

function timed_gameplay() //If you want to call this yourself based on some user input or whatever, remove 'autoexec' and call this function externally from somewhere else.
{
	level.round_wait_func = &round_wait_override; //this has to happen before zm::round_start() runs!
	level.custom_game_over_hud_elem = &timed_game_over;

	wait 0.5; 

	level.next_dog_round = 9999; //cheap way to disable dogs after zm_usermap::main() runs.
	level.zombie_vars["zombie_between_round_time"] = 0; //remove the delay at the end of each round 
	level.zombie_round_start_delay = 0; //remove the delay before zombies start to spawn

	level.ugxm_settings = [];
	if(isDefined(level.tgTimer)) level.tgTimer Destroy();
	level.tgTimer = NewHudElem();

	level.isTimedGameplay = true;

	if(!isDefined(level.ugxm_settings["timed_hud_offset"]))
		level.ugxm_settings["timed_hud_offset"] = 0;

	level.tgTimerTime = SpawnStruct();

	level.tgTimerTime.days = 0;
	level.tgTimerTime.hours = 0;
	level.tgTimerTime.minutes = 0;
	level.tgTimerTime.seconds = 0;
	level.tgTimerTime.toalSec = 0;
	
	level.tgTimer.foreground = false; 
	level.tgTimer.sort = 2; 
	level.tgTimer.hidewheninmenu = false; 

	level.tgTimer.fontScale = 1;
	level.tgTimer.alignX = "left"; 
	level.tgTimer.alignY = "bottom";
	level.tgTimer.horzAlign = "left";  
	level.tgTimer.vertAlign = "bottom";
	level.tgTimer.x = 60; 
	level.tgTimer.y = - 65 + level.ugxm_settings["timed_hud_offset"]; 
	
	level.tgTimer.alpha = 0;

	level flag::wait_till("initial_blackscreen_passed");
	
	level.tgTimer SetTimerUp(0);
	
	thread timed_gameplay_bg_counter();
	level.tgTimer.alpha = 1;
}
function timed_gameplay_bg_counter()
{
	level endon("end_game");
		
	while(1)
	{	
		if(level.tgTimerTime.seconds >= 59) 
		{
			level.tgTimerTime.seconds = 0;
			level.tgTimerTime.minutes ++;
		}
		
		if(level.tgTimerTime.minutes >= 59) 
		{
			level.tgTimerTime.minutes = 0;
			level.tgTimerTime.hours ++;
		}
		
		if(level.tgTimerTime.hours >= 23)
		{
			level.tgTimerTime.hours = 0;
			level.tgTimerTime.days ++;
		}
		
		level.tgTimerTime.seconds ++;
		level.tgTimerTime.toalSec ++;

		wait 1;

	}
}

function timed_game_over(player, game_over, survived)
{
	level.tgTimer Destroy();

	new_survived = NewClientHudElem( player );

	game_over.alignX = "center";
	game_over.alignY = "middle";
	game_over.horzAlign = "center";
	game_over.vertAlign = "middle";
	game_over.y -= 130;
	game_over.foreground = true;
	game_over.fontScale = 3;
	game_over.alpha = 0;
	game_over.color = ( 1.0, 1.0, 1.0 );
	game_over.hidewheninmenu = true;
	game_over SetText( "Game Over!" );

	game_over FadeOverTime( 1 );
	game_over.alpha = 1;
	if ( player isSplitScreen() )
	{
		game_over.fontScale = 2;
		game_over.y += 40;
	}

	secondsTxt = "";
	minsTxt = "";
	hoursTxt = "";
	daysTxt = "";
	
	if(level.tgTimerTime.seconds > 0)
	{
		secondsTxt = level.tgTimerTime.seconds + "s ";
	}
	if(level.tgTimerTime.minutes > 0)
	{
		minsTxt = level.tgTimerTime.minutes + "m ";
	}
	if(level.tgTimerTime.hours > 0)
	{
		hoursTxt = level.tgTimerTime.hours + "h ";
	}
	if(level.tgTimerTime.days > 0)
	{
		daysTxt = level.tgTimerTime.days + "d ";
	}
	if(daysTxt + hoursTxt + minsTxt + secondsTxt == "")
	{
		secondsTxt = "0s";
	}

	new_survived.alignX = "center";
	new_survived.alignY = "middle";
	new_survived.horzAlign = "center";
	new_survived.vertAlign = "middle";
	new_survived.y -= 100;
	new_survived.foreground = true;
	new_survived.fontScale = 2;
	new_survived.alpha = 0;
	new_survived.color = ( 1.0, 1.0, 1.0 );
	new_survived.hidewheninmenu = true;
	if ( player isSplitScreen() )
	{
		new_survived.fontScale = 1.5;
		new_survived.y += 40;
	}

	survived.y -= 999; //Hide the one we don't want, shame on Treyarch for not allowing a clean override.
	
	new_survived setText("You survived " + daysTxt + hoursTxt + minsTxt + secondsTxt);
	new_survived FadeOverTime(1);
	new_survived.alpha = 1;

	thread destory_game_over_hud(new_survived);
}

function destory_game_over_hud(hud)
{
	wait( level.zombie_vars["zombie_intermission_time"] );
	hud Destroy();
}