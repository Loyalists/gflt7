#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_weapons;

#using scripts\gfl\zm\zm_bot_combat;
#using scripts\gfl\zm\zm_bot_navigation;
#using scripts\gfl\zm\zm_bot_pap;
#using scripts\gfl\zm\zm_bot_purchase;
#using scripts\gfl\zm\zm_bot_revive;
#using scripts\gfl\zm\zm_bot_util;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_perks.gsh;

#namespace zm_bot;

#define ZM_BOT_ENABLE_STALL_RECOVERY 1
#define ZM_BOT_CATCHUP_DISTANCE 1500
#define ZM_BOT_CATCHUP_CHECK_INTERVAL_MS 5000

REGISTER_SYSTEM_EX( "zm_bot", &__init__, &__main__, undefined )

function private __init__()
{
	if( !GetDvarInt("tfoption_bot", 0) )
	{
    	return;
	}

	SetDvar("bot_mode", "me");
	SetDvar("bot_difficulty","3");
}

function private __main__()
{
	if( !GetDvarInt("tfoption_bot", 0) )
	{
    	return;
	}

	level.getBotSettings = &get_bot_settings;
	level.onbotspawned = &bot_spawn;
	level.botthreatengage = &zm_bot_combat::engage_threat;
	level.onbotdamage = &zm_bot_combat::bot_got_damage;
	level.botcombat = &bot_combat_think;
	if (ZM_BOT_ENABLE_STALL_RECOVERY)
	{
		level.botupdatethreatgoal = &zm_bot_navigation::update_threat_goal;
	}
	level.botgetthreats = &zm_bot_combat::find_zombie_threats;
    level.botsettings.headshotweight = 90;
	level.botsettings.allowmelee = false;
	level.botsettings.meleerange = 0;
	level.botsettings.meleerangesq = 0;
	level.botsettings.pitchspeed = 1000;
	level.botsettings.pitchspeedads = 1000;
	level.botsettings.yawspeedads = 1000;
	level.botsettings.yawspeed = 1000;
	level.botsettings.pitchsensitivity = 5000;
	level.botsettings.yawsensitivity = 5000;

	thread zm_bot_revive::wait_for_downed();
	thread bot_cmd();
	thread server_auto_bot_spawn();
}

function private get_bot_settings()
{
	return struct::get_script_bundle( "botsettings", "bot_mp_veteran" );
}

function private bot_cmd()
{
	level endon("end_game");
	Modvar("botc", "");
	level flag::wait_till("all_players_connected");

	while (true)
	{
		command = GetDvarString("botc");
		if (command != "")
		{
			SetDvar("botc", "");
			args = StrTok(ToLower(command), " ");
			if (args.size > 0)
			{
				run_bot_command(args);
			}
		}
		wait 0.1;
	}
}

function private run_bot_command(args)
{
	switch (args[0])
	{
		case "tp":
			player = get_teleport_target();
			if (isdefined(player))
			{
				foreach (bot in zm_bot_util::get_bot_players())
				{
					bot zm_bot_purchase::finish_bot_purchase();
					bot zm_bot_navigation::reset_recovery();
					bot SetOrigin(player.origin);
					bot BotSetGoal(bot.origin);
				}
				iPrintLnBold("Bot Teleporter");
			}
			break;
		case "me":
			SetDvar("bot_mode", "me");
			set_bots_paused(false);
			iPrintLnBold("Bots Following");
			break;
		case "kill":
			SetDvar("bot_mode", "self");
			set_bots_paused(false);
			iPrintLnBold("Bots Fighting Independently");
			break;
		case "stop":
			set_bots_paused(true);
			iPrintLnBold("Bots Stopped");
			break;
		case "score":
			foreach (bot in zm_bot_util::get_bot_players())
			{
				bot.score = 100000;
			}
			iPrintLnBold("Bot Score");
			break;
		case "god":
		case "ungod":
			foreach (bot in zm_bot_util::get_bot_players())
			{
				if (args[0] == "god")
				{
					bot EnableInvulnerability();
				}
				else
				{
					bot DisableInvulnerability();
				}
			}
			iPrintLnBold("Bot " + args[0]);
			break;
		case "gun":
			weapon_name = "lmg_cqb_upgraded";
			if (args.size > 1)
			{
				weapon_name = args[1];
			}
			weapon = GetWeapon(weapon_name);
			if (isdefined(weapon) && weapon != level.weaponNone)
			{
				level thread bot_give_weapon(weapon);
				iPrintLnBold("Bot GiveWeapon");
			}
			break;
		case "look":
			bot_look();
			iPrintLnBold("Bot LookAt");
			break;
		case "tap":
		case "melee":
		case "fire":
		case "firel":
			foreach (bot in zm_bot_util::get_bot_players())
			{
				bot bot_command_button(args[0]);
			}
			iPrintLnBold("Bot " + args[0]);
			break;
		case "kick":
			throwEm();
			iPrintLnBold("Bot kicked");
			break;
		case "add":
			bot = AddTestClient();
			if (isdefined(bot))
			{
				iPrintLnBold("Bot added");
			}
			break;
	}
}

function private bot_command_button(command)
{
	switch (command)
	{
		case "tap":
			self bot::tap_use_button();
			break;
		case "melee":
			self bot::tap_melee_button();
			break;
		case "fire":
			self bot::tap_attack_button();
			break;
		case "firel":
			self.bot_command_fire = true;
			self bot::press_attack_button();
			break;
	}
}

function private bot_give_random_weapon()
{
    keys = GetArrayKeys( level.zombie_weapons );

	foreach(bot in getPlayers()) 
	{
		if(bot IsTestClient())
		{
			weapon = array::random(keys);
			if ( !isdefined(weapon) )
			{
				continue;
			}

			bot zm_weapons::weapon_give(weapon);
		}
	}
}

function private bot_give_weapon(weapon)
{
	if ( !isdefined(weapon) )
	{
		return;
	}

	foreach(bot in getPlayers()) 
	{
		if(bot IsTestClient())
		{
			bot zm_weapons::weapon_give(weapon);
		}
	}
}

function private throwEm()
{
	bots = zm_bot_util::get_bot_players();
	if (bots.size > 0)
	{
		bots[0] BotDropClient();
	}
}

function private bot_look()
{
	foreach (bot in zm_bot_util::get_bot_players())
	{
		player = bot zm_bot_util::get_closest_alive_player();
		bot BotLookAtPoint(player GetEye() + AnglesToForward(player.angles) * 10000);
	}
}

function private set_bots_paused(paused)
{
	foreach (bot in zm_bot_util::get_bot_players())
	{
		bot.bot_command_fire = undefined;
		if (paused)
		{
			bot.bot_paused = true;
			bot zm_bot_navigation::reset_recovery();
			bot zm_bot_purchase::finish_bot_purchase();
			bot zm_bot_revive::release_revive_target();
			bot BotReleaseButtons();
			if (isdefined(bot.bot))
			{
				bot bot_combat::clear_threat();
			}
			bot BotSetGoal(bot.origin);
			bot SetMoveSpeedScale(0);
		}
		else if (IS_TRUE(bot.bot_paused))
		{
			bot.bot_paused = undefined;
			bot SetMoveSpeedScale(1);
		}
	}
}

function private server_auto_bot_spawn()
{
	level endon("end_game");
	level flag::wait_till( "all_players_connected" );

	server_bot = GetDvarInt("tfoption_bot_count", 0);
	if (server_bot == 0)
	{
		return;
	}

	maxclients = GetDvarInt("com_maxclients");
	players = zm_bot_util::get_real_players();
	while(1)
	{
		bots = zm_bot_util::get_bot_players();
		if( server_bot == bots.size )
		{
			break;
		}

		if( players.size + bots.size >= maxclients )
		{
			break;
		}

		if( server_bot > bots.size )
		{
			bot = AddTestClient();
		}
		else
		{
			if(bots.size != 0)
			{
				bots[0] BotDropClient();
			}
		}

		wait 0.2;
	}
}

function private get_teleport_target()
{
	alive_players = zm_bot_util::get_alive_players();
	foreach( player in alive_players)
	{
		if( player IsHost() )
		{
			return player;
		}
	}

	if ( alive_players.size > 0 ) {
		return alive_players[0];
	}

	return undefined;
}

function private auto_bot_spawn()
{
	level endon("end_game");
	level waittill("initial_players_connected");
	
	while(GetDvarInt("com_maxclients") != GetPlayers().size)
	{
		bot = AddTestClient();
		wait 0.2;
	}
	/*level waittill("initial_blackscreen_passed");
	while(1)
	{
		level waittill("connected", player);
		if(GetDvarInt("com_maxclients") != GetPlayers().size)
		{
			bot = AddTestClient();
		}
	}*/
}

function private bot_combat_think()
{
	if (IS_TRUE(self.bot_paused))
	{
		if (IS_TRUE(self.bot_command_fire))
		{
			self bot::press_attack_button();
		}
		return;
	}

	if (self laststand::player_is_in_laststand() || self.sessionstate != "playing")
	{
		self zm_bot_navigation::reset_recovery();
		self zm_bot_revive::release_revive_target();
		self zm_bot_purchase::finish_bot_purchase();
		return;
	}

	if (isdefined(self.perk_purchased) && IS_TRUE(self.is_drinking))
	{
		return;
	}

	if (self zm_bot_revive::update_revive_task())
	{
		self zm_bot_navigation::reset_stall_sample();
		return;
	}

	if (!self zm_bot_pap::has_pap_purchase() && self try_catchup_teleport())
	{
		return;
	}

	recovering = ZM_BOT_ENABLE_STALL_RECOVERY && self zm_bot_navigation::update_recovery();

	if (self bot_combat::has_threat() && zm_bot_combat::should_ignore_target(self.bot.threat.entity))
	{
		self bot_combat::clear_threat();
	}
	if (!self zm_bot_combat::turn_toward_threat())
	{
		self bot_combat::combat_think();
		if (!recovering && !self bot_combat::threat_visible())
		{
			self bot_idle();
		}
	}

	if (IS_TRUE(self.bot_command_fire))
	{
		self bot::press_attack_button();
	}
}

function private try_catchup_teleport()
{
	now = GetTime();
	if (isdefined(self.bot_catchup_next_check) && now < self.bot_catchup_next_check)
	{
		return false;
	}
	self.bot_catchup_next_check = now + ZM_BOT_CATCHUP_CHECK_INTERVAL_MS;

	player = self zm_bot_util::get_catchup_player();
	if (!isdefined(player) || DistanceSquared(self.origin, player.origin) <= ZM_BOT_CATCHUP_DISTANCE * ZM_BOT_CATCHUP_DISTANCE)
	{
		return false;
	}

	destination = self zm_bot_util::find_catchup_destination(player);
	if (!isdefined(destination))
	{
		return false;
	}

	self zm_bot_purchase::finish_bot_purchase();
	self zm_bot_navigation::reset_recovery();
	self bot_combat::clear_threat();
	self bot::clear_stuck();
	self bot::end_sprint_to_goal();
	self SetOrigin(destination);
	self BotSetGoal(self.origin);
	return true;
}

function private bot_idle()
{
	self bot::sprint_to_goal();

	if (self zm_bot_pap::update_pap_pickup())
	{
		return;
	}

	task = self zm_bot_purchase::get_active_bot_purchase();
	if (isdefined(task) && self [[task.update]](task))
	{
		return;
	}

	if (self zm_bot_purchase::start_shared_weapon_pickup() || self zm_bot_purchase::start_perk_purchase())
	{
		return;
	}

	player = self zm_bot_util::get_closest_alive_player();
	follow_player = GetDvarString("bot_mode") != "self" && player != self;
	player_in_range = self zm_bot_util::is_player_in_follow_range(player);
	if (follow_player && player_in_range)
	{
		self bot::follow_entity(player, 120, 121);
		return;
	}

	if ((!player_in_range && self zm_bot_pap::start_pap_purchase()) ||
	    self zm_bot_purchase::start_wallbuy() || self zm_bot_purchase::start_magicbox_purchase() || self zm_bot_purchase::start_door_purchase())
	{
		return;
	}

	if (follow_player)
	{
		self bot::follow_entity(player, 120, 121);
	}
	else if (!self BotGoalSet() || self BotGoalReached())
	{
		self bot::navmesh_wander();
	}
}

function private health_regen()
{	
	level endon( "game_ended" );
	self endon("disconnect");
	self endon("bled_out");

	while(true) 
	{
		self regain_full_health();
		wait(0.2); 
	}
}

function private regain_full_health()
{	
	level endon( "game_ended" );
	self endon("disconnect");
	self endon("bled_out");
	self endon("damage");

	wait(3); 
	if (!isdefined(self) || !isalive(self))
	{
		return;
	}
	
	self.health = self.maxhealth;
}

function private health_boost()
{	
	level endon( "game_ended" );
	self endon("disconnect");
	self endon("bled_out");

	while(true) 
	{
		level waittill("start_of_round");

		dvar = GetDvarInt("tfoption_bot_health", 0);
		if (dvar == 0)
		{
			WAIT_SERVER_FRAME;
			continue;
		}

		multiplier = 0.5;
		switch(dvar)
		{
			case 1:
			{
				multiplier = 0.1;
				break;
			}
			case 2:
			{
				multiplier = 0.25;
				break;
			}
			case 3:
			{
				multiplier = 0.5;
				break;
			}
			case 4:
			{
				multiplier = 1;
				break;
			}
			case 5:
			{
				multiplier = 2;
				break;
			}
			default:
			{
				break;
			}
		}

		jugg_health = 100;
		if (isdefined(level.zombie_vars["zombie_perk_juggernaut_health"]))
		{
			jugg_health = level.zombie_vars["zombie_perk_juggernaut_health"];
		}
		base_health = level.zombie_vars["player_base_health"] + jugg_health;

		health = level.zombie_health * multiplier;
		if (health > base_health)
		{
			self SetMaxHealth(health);
		}

		WAIT_SERVER_FRAME;
	}
}

function private bot_spawn()
{
	self notify("gfl_bot_stop_semi_auto");
	self.bot_semi_auto_firing = undefined;
	self zm_bot_navigation::reset_recovery();
	if (ZM_BOT_ENABLE_STALL_RECOVERY)
	{
		self thread zm_bot_navigation::watch_path_failures();
	}
	self.bot_catchup_next_check = GetTime() + ZM_BOT_CATCHUP_CHECK_INTERVAL_MS;
	self.box_share_distance = 512;
	self.follow_player_distance = 240;
	self.magic_box_distance = 2000;
	self.wallbuy_distance = 300;
	self.open_door_distance = 1000;
	
	wait 1;
	self zm::spectator_respawn_player();
    self thread bot_setup();
	self thread zm_bot_revive::area_revive();
    //bot1 thread try_slide();
	//self.score = 50000;
}

function private try_slide()
{
	self endon("disconnect");

	while(1)
	{
		if(self IsSprinting() && self IsTestClient())
		{
			self bottapbutton(9);
		}
		wait 0.1;
	}
}

function private bot_setup()
{
	self notify("bot_setup");
	self endon("bot_setup");
	self endon("disconnect");
	self endon("bled_out");
	level endon("game_ended");

	self thread pesSuit();
	self thread health_regen();
	self thread health_boost();

	foreach (perk in array(PERK_QUICK_REVIVE, PERK_JUGGERNOG))
	{
		if (!self HasPerk(perk) && !self zm_perks::has_perk_paused(perk))
		{
			self zm_perks::give_perk(perk, false);
		}
	}

    while(true)
    {
        // self setperk( "specialty_unlimitedsprint");
        // self setperk( "specialty_sprintfire" );
		// self setperk( "specialty_sprintequipment" );
		// self setperk( "specialty_sprintgrenadelethal" );
		// self setperk( "specialty_sprintgrenadetactical" );
		// self setperk( "specialty_phdflopper" );
		self._retain_perks = true;
		self GiveMaxAmmo(self GetCurrentWeapon());
		WAIT_SERVER_FRAME;
		self waittill("reload_start");
    }
}

function private pesSuit()
{
	self notify("pesSuit");
	self endon("pesSuit");
	level endon("game_ended");
	self endon("disconnect");
	self endon("bled_out");

	if ( !does_level_support_pes() )
	{
		return;
	}

	wait(3);
	while(true) 
	{
		player = self zm_bot_util::get_closest_alive_player();
		clothes = self zm_equipment::get_player_equipment();
		suit = player zm_equipment::get_player_equipment();
		if(clothes != suit && player.sessionstate == "playing") 
		{
			self zm_equipment::take(clothes);
			self zm_equipment::give(suit);
			self zm_equipment::set_player_equipment(suit);
			self setactionslot(2,"weapon",suit);
			self switchToWeapon(suit); 
		}
		wait(5); 
	}
}

function private does_level_support_pes()
{
	if ( level.script == "zm_moon" || level.script == "zm_newfound" )
	{
		return true;
	}

	return false;
}
