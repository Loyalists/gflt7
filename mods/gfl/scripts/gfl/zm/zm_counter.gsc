#using scripts\codescripts\struct;
#using scripts\shared\scene_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\statstable_shared.gsh;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_faller;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_server_throttle;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_weapons;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;

#namespace zm_counter;

function init()
{
	thread enemy_counter_hud();
}

function enemy_counter_hud()
{
	//level endon("end_game");
    level waittill( "initial_blackscreen_passed" );
	enemy_counter_hud = newHudElem();
	enemy_counter_hud.alignx = "left";
	enemy_counter_hud.aligny = "top";
	enemy_counter_hud.horzalign = "left";
	enemy_counter_hud.vertalign = "top";
	enemy_counter_hud.x = 25;
	enemy_counter_hud.y = 20;
	enemy_counter_hud.fontscale = 1.5;
	//enemy_counter_hud.font = "small";
	enemy_counter_hud.alpha = 0;
	enemy_counter_hud.color = ( 1, 1, 1 );
	enemy_counter_hud.hidewheninmenu = 1;
	enemy_counter_hud.foreground = 1;
	enemy_counter_hud.label = &"GFL_ZM_ZMLEFT";
	enemy_counter_hud thread wait_for_gameend();
	enemy_counter_hud thread wait_for_hide();
	enemy_counter_hud.loop = true;
	while ( isdefined(enemy_counter_hud) )
	{
		if (!enemy_counter_hud.loop) 
		{
			break;
		}

		enemies = (zombie_utility::get_current_zombie_count() + level.zombie_total);

		if (enemies == 0)
		{
			enemy_counter_hud.label = &"MENU_INTERMISSION";
			enemy_counter_hud settext("");
			enemy_counter_hud FadeOverTime(1.5);
			enemy_counter_hud.alpha = 0;
		}
		
		while(enemies == 0)
		{
			enemies = (zombie_utility::get_current_zombie_count() + level.zombie_total);
			WAIT_SERVER_FRAME;
		}

		if (enemies > 0)
		{
			enemy_counter_hud.label = &"GFL_ZM_ZMLEFT";
			enemy_counter_hud setValue(enemies);
		}

		if(enemy_counter_hud.alpha == 0)
		{
			enemy_counter_hud FadeOverTime(1.2);
			enemy_counter_hud.alpha = 0.9;
		}

		WAIT_SERVER_FRAME;
	}
}

function wait_for_gameend()
{
	self endon("death");
	
	level util::waittill_any( "game_ended", "end_game" );
	self.loop = false;
	self.label = &"MENU_INTERMISSION";
	self settext("");
	self FadeOverTime(1.5);
	self.alpha = 0;
	wait 1.5;
	self Destroy();
}

function wait_for_hide()
{
	self endon("death");
	
	while(1)
	{
		num = 0;
		foreach(player in GetPlayers())
		{
			if( ( isDefined(player.gamevars) && isDefined(player.gamevars["hardcore"]) ) || isDefined(player.current_player_scene) || player flagsys::get("playing_movie_hide_hud") || player scene::is_igc_active() || (isdefined(player.dont_show_hud) && player.dont_show_hud))
			{
				num++;
			}
		}
		
		if ( GetPlayers().size == num || ( isDefined(player.gamevars) && isDefined(player.gamevars["hardcore"]) ) )
		{
			self.fontscale = 0;
		}
		else
		{
			self.fontscale = 1.5;
		}
		wait 0.048;
	}
}