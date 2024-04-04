#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;

#using scripts\zm\_zm;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;

function main()
{
	wait 0.1;
    Modvar("sb","");
	SetDvar("bot_mode", "me");
	SetDvar("bot_difficulty","3");
	level.getBotSettings = &get_bot_settings;
    level.botsettings.headshotweight = 90;
	level.onbotspawned = &bot_spawn;
	level.botthreatengage = &engage_threat;
	level.onbotdamage = &bot_got_damage;
	level.botidle = &bot_idle;
	level.botthreatlost = &bot_idle;
	level.botprecombat = &bot_idle;
	level.botgetthreats = &find_closet_zombie;
	level.botsettings.allowmelee = false;
	level.botsettings.meleerange = 0;
	level.botsettings.meleerangesq = 0;
	level.botsettings.pitchspeed = 1000;
	level.botsettings.pitchspeedads = 1000;
	level.botsettings.yawspeedads = 1000;
	level.botsettings.yawspeed = 1000;
	level.botsettings.pitchsensitivity = 5000;
	level.botsettings.yawsensitivity = 5000;
	
	thread wait_for_downed();
	thread bot_cmd();
	thread server_auto_bot_spawn();

    while(1)
    {
        if(GetDvarString("sb") != "")
        {
            bot = AddTestClient();
        }
        SetDvar("sb", "");
        wait 0.1;
    }
}

function get_bot_settings()
{
	switch ( GetDvarInt( "bot_difficulty", 1 ) )
	{
		case 0:
			bundleName = "bot_mp_easy";
			break;
			
		case 1:
			bundleName = "bot_mp_normal";
			break;
		case 2:
			bundleName = "bot_mp_hard";
			break;
		case 3:
		default:
			bundleName = "bot_mp_veteran";
			break;
	}
	
	return struct::get_script_bundle( "botsettings", bundleName );
}

function bot_cmd()
{
	Modvar("botc", "");
	while(1)
    {
        if(GetDvarString("botc") != "")
        {
            name_state = GetDvarString("botc");
            tokenized = StrTok(name_state, " ");
            gname = ToLower(tokenized[1]);
            playername = ToLower(tokenized[0]);
            if (ToLower(name_state) == "tp")
			{
				realplayer = mplayer();
				foreach(player in GetPlayers())
				{
					if(player IsTestClient())
					{
						player SetOrigin(realplayer.origin);
					}
				}
				iPrintLnBold("Bot Teleporter");
            }
            if (ToLower(name_state) == "me")
			{
				SetDvar("bot_mode", "me");
				iPrintLnBold("Bot On Me");
            }
            if (ToLower(name_state) == "score")
			{
				foreach(player in GetPlayers())
				{
					if(player IsTestClient())
					{
						player.score = 100000;
					}
				}
				iPrintLnBold("Bot Score");
			}
            if (ToLower(name_state) == "ungod")
			{
				foreach(player in GetPlayers())
				{
					if(player IsTestClient())
					{
						player DisableInvulnerability();
					}
				}
				iPrintLnBold("Bot unGod");
			}
            if (ToLower(name_state) == "god")
			{
				foreach(player in GetPlayers())
				{
					if(player IsTestClient())
					{
						player EnableInvulnerability();
					}
				}
				iPrintLnBold("Bot God");
			}
            if (playername == "gun")
			{
				if(gname != "")
				{
					thread bot_give_weapon(GetWeapon(gname));
				}
				else
				{
					thread bot_give_weapon(GetWeapon("lmg_cqb_upgraded"));
				}
				iPrintLnBold("Bot GiveWeapon");
			}
            if (ToLower(name_state) == "look")
			{
				thread bot_look();
				iPrintLnBold("Bot LookAt");
			}
            if (ToLower(name_state) == "tap")
			{
				foreach(player in GetPlayers())
				{
					if(player IsTestClient())
					{
						player bottapbutton(3);
					}
				}
				iPrintLnBold("Bot Press F");
			}
            if (ToLower(name_state) == "stop")
			{
				thread stop_bots();
				iPrintLnBold("Bot Stoped");
			}
            if (ToLower(name_state) == "melee")
			{
				foreach(player in GetPlayers())
				{
					if(player IsTestClient())
					{
						player bottapbutton(2);
					}
				}
				iPrintLnBold("Bot Press Melee");
			}
            if (ToLower(name_state) == "fire")
			{	
				foreach(bot in getPlayers()) 
				{
					if(bot IsTestClient())
					{
						bot bottapbutton(0);
					}
				}
				iPrintLnBold("Bot Fire Once");
			}
            if (ToLower(name_state) == "firel")
			{				
				foreach(bot in getPlayers()) 
				{
					if(bot IsTestClient())
					{
						bot botpressbutton(0);
					}
				}
				iPrintLnBold("Bot Fire loop");
			}
            if (ToLower(name_state) == "kill")
			{
				SetDvar("bot_mode", "self");
				level notify("bots_fire");
				foreach(player in GetPlayers())
				{
					if(player IsTestClient())
					{
						player bot_combat::update_threat( true );
						player bot_combat::update_threat();
						player setMoveSpeedScale(1);
					}
				}
				iPrintLnBold("Bot Killing");
			}
            if (ToLower(name_state) == "kick")
			{
				thread throwEm();
				iPrintLnBold("Bot kicked");
			}
            SetDvar("botc", "");
        } 
		wait 0.05;
    }
}

function throwEm()
{
	num = 0;
	foreach(bot in getPlayers()) 
	{
		if(bot IsTestClient()) 
		num++; 
		if(num>0) 
		{ 
			bot BotDropClient(); 
			break; 
		}
	}
}

function bot_give_weapon(weapon)
{
	foreach(bot in getPlayers()) 
	{
		if(bot IsTestClient())
		{
			bot zm_weapons::weapon_give(weapon);
		}
	}
}

function bot_look()
{
	foreach(bot in getPlayers()) 
	{
		if(bot IsTestClient())
		{
			player = mplayer();
			bot BotLookAtPoint( player.origin + AnglesToForward(player.angles) * 500000 );
		}
	}
}

function stop_bots()	
{
	level endon("bots_fire");
	level notify("stop_bots");
	foreach(bot in getPlayers()) 
	{
		if(bot IsTestClient() && isdefined(bot))
		{
			bot BotSetGoal( bot.origin );
			while (1) 
			{
				bot bot_combat::update_threat( false );
				bot.bot.threat.visible = false;
				bot bot_combat::clear_threat();
				bot setMoveSpeedScale(0);
				wait 0.05;
			}
		}
	}
}

function server_auto_bot_spawn()
{
	level endon("end_game");
	level waittill("initial_players_connected");
	
	server_bot = GetDvarInt("tfoption_bot_count");
	if (server_bot == 0)
	{
		return;
	}

	maxclients = GetDvarInt("com_maxclients");
	players = get_real_players();
	while(1)
	{
		bots = GetBotPlayers();
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

function GetBotPlayers()
{
	bots = [];
	foreach( player in GetPlayers())
	{
		if(player IsTestClient())
		{
			bots[bots.size] = player;
		}
	}
	return bots;
}

function get_real_players()
{
	players = [];
	foreach( player in GetPlayers())
	{
		if(!player IsTestClient())
		{
			players[players.size] = player;
		}
	}
	return players;
}

function get_alive_players()
{
	players = [];
	foreach( player in GetPlayers())
	{
		if(player IsTestClient())
		{
			continue;
		}

		if(!isalive(player))
		{
			continue;
		}

		if(	player.sessionstate == "spectator" )
		{
			continue;
		}

		players[players.size] = player;
	}
	return players;
}

function auto_bot_spawn()
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

function bot_idle()
{
	level endon( "game_ended" );
	self.bot.sprinttogoal = 1;

	if(isDefined(self.is_going_to_reviving))
	{
		return;
	}

	if(self box_share())
	{
		return;
	}

	if(!IS_TRUE(self.bot_is_using_box))
	{
		if ( self is_close_to_any_player() )
		{
			follow_closest_player();
			return;
		}
	}

	if(self wallbuy())
	{
		return;
	}

	if(self magicbox())
	{
		return;
	}

	if(self openDoors())
	{
		return;
	}

	set_bot_goal();
}

function set_bot_goal()
{
	//IPrintLnBold("bot find player");
	players = get_alive_players();
	if(GetDvarString("bot_mode") == "self" || players.size == 0)
	{
		self bot::navmesh_wander();
	}
	else
	{
		self follow_closest_player();
	}
}

function follow_closest_player()
{
	player = self mplayer();
	self BotSetGoal(player.origin, 120);
}

function is_close_to_any_player()
{
	dist = self.follow_player_distance;
	player = self mplayer();
	if ( !isdefined(player) || player == self )
	{
		return false;
	}

	if(distancesquared(self.origin, player.origin) > (dist * dist))
    {
		return false;
    }

	return true;
}

function bot_health()
{	
	level endon( "game_ended" );
	self endon("disconnect");
	self endon("bled_out");

	self thread health_regen();
	self thread health_boost();
}

function health_regen()
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

function regain_full_health()
{	
	level endon( "game_ended" );
	self endon("disconnect");
	self endon("bled_out");
	self endon("damage");

	wait(3); 
	if (!isalive(self))
	{
		return;
	}
	self.health = self.maxhealth;
}

function health_boost()
{	
	level endon( "game_ended" );
	self endon("disconnect");
	self endon("bled_out");

	while(true) 
	{
		level waittill("start_of_round");
		health = level.zombie_health;
		if (self.maxhealth < health)
		{
			self SetMaxHealth(health); 
		}
		wait(1); 
	}
}

function find_closet_zombie()
{
	zombies = [];

	foreach( ai_actor in GetAITeamArray("axis"))
	{
		if ( should_ignore_target(ai_actor) )
		{
			continue;
		}

		if(isalive(ai_actor))
		{
			ArrayInsert(zombies, ai_actor, zombies.size);
		}
	}
	foreach( ai_vehicle in GetVehicleTeamArray("axis"))
	{
		if(IsAlive(ai_vehicle))
		{
			ArrayInsert(zombies, ai_vehicle, zombies.size);
		}
	}
	zombies = self cantseeentities(zombies, cos(350) , 0);
	zombie = ArrayGetClosest(self.origin, zombies);
	if(isDefined(zombie) && IsAlive(zombie))
	{
		zombies = [];
		zombies[0] = zombie;
		return zombies;
	}
	else
	{
		return undefined;
	}
}

function should_ignore_target( target )
{
	if ( !isdefined(target) )
	{
		return true;
	}

	if ( !isalive(target) )
	{
		return true;
	}
	
	// cotd fix
	// hopefully the bots won't piss off george
	if ( target.archetype == "zombie_george" )
	{
		if ( target flag::exists("george_is_enraged") && target flag::get("george_is_enraged") )
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	return false;
}

function wait_for_downed()
{
	level endon( "game_ended" );
	
	while(1)
	{
		if(get_downed_players().size != 0)
		{
			foreach(player in get_downed_players())
			{
				if(!isDefined(player.is_someone_already_going))
				{
					reviver = player get_closet_reviver();
					if(isDefined(reviver))
					{
						if(!isDefined(reviver.is_going_to_reviving))
						{
							reviver bottapbutton(15);
						}
						reviver thread bot_going_to_reviving(player);
						reviver.is_going_to_reviving = true;
						player.is_someone_already_going = true;
					}
				}
			}
		}
		else
		{
			foreach(player in GetPlayers())
			{
				if(player IsTestClient())
				{
					player.throw_monkey = undefined;
					player.is_going_to_reviving = undefined;
				}
			}
		}
		wait 0.5;
	}
}

function bot_going_to_reviving(downed)
{
	self notify("bot_going_to_reviving");
	self endon("bot_going_to_reviving");
	self endon("disconnect");
	downed endon("disconnect");
	if(!isDefined(self.is_going_to_reviving))
	{
		while(downed laststand::player_is_in_laststand() && isDefined(downed.revivetrigger))
		{
			self BotSetGoal(downed.origin,50);
			if(self IsTouching(downed.revivetrigger))
			{
				self AllowSprint(0);
				self SetMoveSpeedScale(0);
				self GiveWeapon(level.weaponReviveTool);
				self SwitchToWeapon(level.weaponReviveTool);
				while(self IsTouching(downed.revivetrigger) && isDefined(downed.revivetrigger))
				{
					self botlookatpoint(downed.origin);
					wait 0.5;
				}
				self SetSpawnWeapon(self GetWeaponsListPrimaries()[0]);
				self TakeWeapon(level.weaponReviveTool);
				self AllowSprint(1);
				self SetMoveSpeedScale(1);
			}
			wait 0.5;
		}
		self AllowSprint(1);
		self botlookforward();
		self SetMoveSpeedScale(1);
		self SetSpawnWeapon(self GetWeaponsListPrimaries()[0]);
		self TakeWeapon(level.weaponReviveTool);
		self.throw_monkey = undefined;
		self.is_going_to_reviving = undefined;
		downed.is_someone_already_going = undefined;
	}
}

function mplayer()
{	
	level endon( "game_ended" );
    players = get_alive_players();
	leader = ArrayGetClosest(self.origin, players);
	if(isDefined(leader))
	{
		return leader;
	}
	else
	{
		return self;
	}
}

function mplayer_origin()
{
	player = self mplayer();
	// startpos = player.origin;
	// endpos = player.origin - (0,0,10000);
	// return BulletTrace(startpos,endpos,true,false,false,false)["position"];
	return player.origin;
}

function bot_spawn()
{
	wait 1;
	self zm::spectator_respawn_player();
    self thread bot_setup();
	self thread area_revive();
    //bot1 thread try_slide();
	//self.score = 50000;
}

function area_revive()
{
	self notify("area_revive");
	self endon("area_revive");
	self endon("disconnect");

	while(1)
	{	
		wait 0.1;
		s_revive_override = self zm_laststand::register_revive_override(&bot_do_area_revive);
		while(!isDefined(self.revivetrigger))
		{
			wait 0.1;
		}
		self zm_laststand::deregister_revive_override(s_revive_override);
		while(isDefined(self.revivetrigger))
		{
			wait 0.1;
		}
	}
}

function try_slide()
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

function bot_setup()
{
	self notify("bot_setup");
	self endon("bot_setup");
	level endon("game_ended");
	self endon("disconnect");

	self.box_share_distance = 512;
	self.follow_player_distance = 240;
	self.magic_box_distance = 3000;
	self.wallbuy_distance = 300;
	self.open_door_distance = 1500;
	self thread pesSuit();
	self thread bot_health();
	self zm_perks::give_perk( "specialty_quickrevive", false );
	self zm_perks::give_perk( "specialty_fastreload", false );
	self zm_perks::give_perk( "specialty_armorvest", false );
	self zm_perks::give_perk( "specialty_staminup", false );
	self zm_perks::give_perk( "specialty_doubletap2", false );
	self zm_perks::give_perk( "specialty_deadshot", false );
	//foreach(weapon in self GetWeaponsListPrimaries())
	//{
	//	//self takeweapon(weapon);
	//}
    //self giveweapon(Getweapon("bowie_knife"));
    //self GiveWeapon(GetWeapon("lmg_light","fastreload","grip","reddot","ir","stalker","steadyaim","quickdraw","extclip"));
	//self SetSpawnWeapon(self GetWeaponsListPrimaries()[0]);
    //self EnableInvulnerability();

    while(1)
    {
        self setperk( "specialty_unlimitedsprint");
        self setperk( "specialty_sprintfire" );
		self setperk( "specialty_sprintequipment" );
		self setperk( "specialty_sprintgrenadelethal" );
		self setperk( "specialty_sprintgrenadetactical" );
		self setperk( "specialty_phdflopper" );
		self._retain_perks = true;
        self GiveMaxAmmo(self GetCurrentWeapon());
		self waittill("reload_start");
    }
}

function bot_got_damage()
{
	if ( !isdefined(self.bot.damage) || !isdefined(self.bot.damage.entity) )
	{
		return;
	}

	if ( should_ignore_target( self.bot.damage.entity ) )
	{
		return;
	}

	self botpressbutton(0);
	self botlookatpoint(self.bot.damage.entity getcentroid());
	self bot_combat::set_threat(self.bot.damage.entity);
	self botlookatpoint(self.bot.damage.entity getcentroid());
	self bot_combat::set_threat(self.bot.damage.entity);
}

function get_downed_players()
{
    players = [];

    foreach(player in GetPlayers())
    {
        if(player laststand::player_is_in_laststand() && isDefined(player.revivetrigger))
        {
			ArrayInsert(players, player, players.size);
        }
    }
	return players;
}

function get_downed_player()
{
	players = get_downed_players();
    if(players.size != 0)
    {
        return ArrayGetClosest(self.origin,players);
    }
    return;
}

function get_closet_reviver()
{
	bots = [];
	foreach(player in GetPlayers())
    {
        if(!player laststand::player_is_in_laststand() && player IsTestClient() && !player zm_laststand::is_reviving_any() && !isDefined(player.is_going_to_reviving))
        {
			ArrayInsert(bots, player, bots.size);
        }
    }

	if(bots.size != 0)
    {
        return ArrayGetClosest(self.origin,bots);
    }
	return;
}

function bot_do_area_revive(e_revivee)
{
	if(!isdefined(e_revivee.revivetrigger) || isdefined(self.revivetrigger))
	{
		return false;
	}
	if(self laststand::player_is_in_laststand())
	{
		return false;
	}
	if(!isalive(self))
	{
		return false;
	}
	if(self.team != e_revivee.team)
	{
		return false;
	}
	if(self GetCurrentWeapon() != level.weaponReviveTool)
	{
		return false;
	}
	if(isdefined(self.is_zombie) && self.is_zombie)
	{
		return false;
	}
	if(isdefined(level.can_revive) && ![[level.can_revive]](e_revivee))
	{
		return false;
	}
	if(e_revivee == self)
	{
		return false;
	}
	if(isdefined(level.can_revive_game_module) && ![[level.can_revive_game_module]](e_revivee))
	{
		return false;
	}
	if(isdefined(level.can_revive_use_depthinwater_test) && level.can_revive_use_depthinwater_test && e_revivee depthinwater() > 10)
	{
		return self IsTestClient();
	}
    if(self IsTouching(e_revivee.revivetrigger))
    {
        return self IsTestClient();
    }
	return false;
}

function pesSuit()
{
	self notify("pesSuit");
	self endon("pesSuit");
	level endon("game_ended");
	self endon("disconnect");

	if ( !does_level_support_pes() )
	{
		return;
	}

	wait(3);
	while(true) 
	{
		player = self mplayer();
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
	dont_have_hero_weapon = 1;
	while(dont_have_hero_weapon)
	{
		player = self mplayer();
		if(zm_utility::is_hero_weapon( player zm_utility::get_player_hero_weapon() ) && player gadgetpowerget(0) == 100)
		{
			self zm_weapons::weapon_give(player zm_utility::get_player_hero_weapon(),undefined,undefined,true);
			wait 0.1;
			self GadgetPowerSet( 0, 100 );
			dont_have_hero_weapon = 0;
		}
		wait 2;
	}
}

function does_level_support_pes()
{
	if ( level.script == "zm_moon" || level.script == "zm_newfound" )
	{
		return true;
	}

	return false;
}

function bot_likes_weapon(weapon)
{
	if ( !isdefined(weapon) )
	{
		return false;
	}

	if ( self zm_weapons::has_weapon_or_upgrade( weapon.rootweapon ) )
	{
		return false;
	}

	current_weapon = self GetCurrentWeapon();
    weaponNone = GetWeapon( "none" ); 
    if ( IsDefined(level.weaponNone) )
	{
        weaponNone = level.weaponNone;
	}

	if ( current_weapon.name == weaponNone.name )
	{
		return true;
	}

	if ( self GetWeaponsListPrimaries().size < 2 )
	{
		return true;
	}

	if ( zm_utility::is_hero_weapon(current_weapon) || current_weapon == level.weaponReviveTool )
	{
		return false;
	}

	// dislikes if bot got an upgraded weapon in hand
	if ( zm_weapons::is_weapon_upgraded( current_weapon.rootweapon ) && !zm_weapons::is_weapon_upgraded( weapon.rootweapon ) && !zm_weapons::is_wonder_weapon( weapon.rootweapon ) )
	{
		return false;
	}

	target_weapon_cost = int(zm_weapons::get_weapon_cost( weapon.rootweapon ));
	current_weapon_cost = int(zm_weapons::get_weapon_cost( current_weapon.rootweapon ));

	// IPrintLnBold("target:" + target_weapon_cost);
	// IPrintLnBold("current:" + current_weapon_cost);
	if ( target_weapon_cost >= current_weapon_cost )
	{
		return true;
	}

	if(
		weapon.rootweapon.weapClass == "rocketlauncher" ||
		weapon.rootweapon.weapClass == "mg" ||
		weapon.rootweapon.inventorytype != "primary" ||
		weapon.rootweapon.weapClass == "wonder" ||
		weapon.rootweapon.weapClass == "spread" ||
		zm_weapons::is_wonder_weapon( weapon.rootweapon )
	)
	{
		return true;
	}

	return false;
}

function box_share()
{
	level endon("game_ended");
	self endon("disconnect");
	if(isDefined(self.bot_is_using_box))
	{
		return false;
	}

	boxes = get_magicboxes();
	if( boxes.size == 0 )
	{
		// IPrintLnBold("no box");
		return false;
	}
	shareweapons = [];
	foreach(box in boxes)
	{
		if ( isdefined( box.magicboxshare ) && isdefined( box.magicboxshare.weapon ) )
		{
			ArrayInsert(shareweapons, box.magicboxshare, shareweapons.size);
		}
	}

	if( shareweapons.size == 0 ) 
	{
		// IPrintLnBold("no shareweapons");
		return false;
	}

	closest_shareweapon = ArrayGetClosest(self.origin, shareweapons);
	if( !isDefined(closest_shareweapon) ) 
	{
		return false;
	}
	
	dist_sqrt = distancesquared(self.origin, closest_shareweapon.origin);
	if ( dist_sqrt > self.box_share_distance * self.box_share_distance )
	{
		// IPrintLnBold("not close enough");
		return false;
	}

	if (!self bot_likes_weapon(closest_shareweapon.weapon))
	{
		return false;
	}

	if ( self istouching(closest_shareweapon) || (self botgetgoalposition() == closest_shareweapon.origin && self botgoalreached()) )
	{
		while(self IsSwitchingWeapons() && self IsFiring())
		{
			wait 0.1;
		}

		self botlookatpoint(closest_shareweapon.origin);
		self SetMoveSpeedScale(0);
		self bot::tap_use_button();
		wait(0.5);
		self SetMoveSpeedScale(1);
	}
	else
	{
		self BotSetGoal(closest_shareweapon.origin);
	}

	return true;
}

function get_magicboxes()
{
	if( isDefined(level.chests) )
	{
		return level.chests;
	}

	return [];
}

function magicbox()
{	
	level endon("game_ended");
	self endon("disconnect");
	if(isDefined(self.bot_is_using_box) || isDefined(self.bot_box_used))
	{
		//IPrintLnBold("cant use box");
		return false;
	}

	boxes = get_magicboxes();
	if( boxes.size == 0 )
	{
		return false;
	}

	if(!self zm_magicbox::can_buy_weapon() || level flag::get( "moving_chest_now" ) || GetDvarInt("tfoption_gungame") == 1)
	{
		//IPrintLnBold("cant use box");
		return false;
	}
	usable_box = [];
	foreach(box in boxes)
	{
		//IPrintLnBold(box.zbarrier zm_magicbox::get_magic_box_zbarrier_state());
		if(self zm_score::can_player_purchase(box.zombie_cost) && (box.zbarrier zm_magicbox::get_magic_box_zbarrier_state() == "close" || box.zbarrier zm_magicbox::get_magic_box_zbarrier_state() == "initial" || box.zbarrier zm_magicbox::get_magic_box_zbarrier_state() == "arriving"))
		{
			ArrayInsert(usable_box, box, usable_box.size);
		}
		if(isDefined(box.chest_user) && box.chest_user == self)
		{
			ArrayInsert(usable_box, box, usable_box.size);
		}
	}
	if(usable_box.size != 0)
	{
		finalbox = ArrayGetClosest(self.origin, usable_box, self.magic_box_distance);
	}
	else
	{
		usable_box = undefined;
		return false;
	}
	
	if ( !isdefined(finalbox) )
	{
		usable_box = undefined;
		return false;
	}

	if(!self check_playable_area(finalbox.unitrigger_stub.origin))
	{
		usable_box = undefined;
		return false;
	}

	if(self botgetgoalposition() == finalbox.unitrigger_stub.origin && self botgoalreached())
	{
		//IPrintLnBold("bot hit box" , finalbox.chest_user.name );
		self BotTapButton(3);
		self BotTapButton(3);
		if(isDefined(finalbox.chest_user) && finalbox.chest_user == self)
		{
			//IPrintLnBold("box used");
			self.bot_is_using_box = true;
			self SetMoveSpeedScale(0);
			//self FreezeControlsAllowLook(1);
			finalbox.zbarrier util::waittill_any( "randomization_done"); 
			if(self GetWeaponsListPrimaries().size == 2)
			{
				if(self GetCurrentWeapon() == self GetWeaponsListPrimaries()[0])
				{
					self SetSpawnWeapon(self GetWeaponsListPrimaries()[1]);
				}
				else
				{
					self SetSpawnWeapon(self GetWeaponsListPrimaries()[0]);
				}	
			}
			wait 1;
			self BotSetGoal(finalbox.unitrigger_stub.origin);
			self thread bot_used_box(finalbox);					
			while(self IsSwitchingWeapons() && self IsFiring())
			{
				wait 0.05;
			}
			self BotSetGoal(finalbox.unitrigger_stub.origin);
			
			if(	bot_likes_weapon(finalbox.zbarrier.weapon) )
			{
				while(self IsSwitchingWeapons() && self IsFiring())
				{
					wait 0.05;
				}
				self BotSetGoal(finalbox.unitrigger_stub.origin);
				self BotTapButton(3);
				self BotTapButton(3);
				self BotTapButton(3);
				wait 0.1;
				//IPrintLnBold("hit the weapon");
				//IPrintLnBold("got a weapon " , finalbox.zbarrier.weapon.rootweapon.name);
			}
			else
			{
				//IPrintLnBold("bot dont like weapon", finalbox.zbarrier.weapon.rootweapon.name);
				self botlookatpoint(finalbox.zbarrier.weapon_model.origin);
				wait 1;
				self bottapbutton(2);
			}
			self SetMoveSpeedScale(1);
			self.bot_is_using_box = undefined;
		}
		else
		{
			self SetMoveSpeedScale(1);
			self.bot_is_using_box = undefined;
		}
	}
	else
	{
		self BotSetGoal(finalbox.unitrigger_stub.origin);
	}

	if(self GetVelocity() == 0)
	{
		self thread release_stuck();
	}
	
	return true;
}

function bot_used_box(box)
{
	if(!isDefined(self.bot_box_used))
	{
		self.bot_box_used = true;
		wait 10;
		while(box.zbarrier zm_magicbox::get_magic_box_zbarrier_state() == "open")
		{
			wait 0.05;
		}
		//IPrintLnBold("allow use box");
		self.bot_box_used = undefined;
	}
}

function wallbuy()
{	
	level endon("game_ended");
	self endon("disconnect");
	if(!self zm_magicbox::can_buy_weapon() || GetDvarInt("tfoption_gungame") == 1)
	{
		return false;
	}
	usable_wallbuy = [];
	foreach(wallbuy in level._spawned_wallbuys)
	{
		// if( !IsEntity(wallbuy) )
		// {
		// 	continue;
		// }

		if ( !IS_TRUE( zm_weapons::get_weapon_cost( wallbuy.weapon ) ) || !IS_TRUE( zm_weapons::get_weapon_cost( self GetCurrentWeapon().rootweapon ) ) )
		{
			continue;
		}

		if( !self check_playable_area(wallbuy.trigger_stub.origin) )
		{
			continue;
		}

		if(!issubstr(wallbuy.weapon.rootweapon.name,"knife")
			&& !issubstr(wallbuy.weapon.rootweapon.name,"melee")
			&& self zm_score::can_player_purchase( zm_weapons::get_weapon_cost( wallbuy.weapon ) ) 
			&& !self zm_weapons::has_weapon_or_upgrade( wallbuy.weapon ) 
			&& int(zm_weapons::get_weapon_cost( wallbuy.weapon )) > int(zm_weapons::get_weapon_cost(self GetCurrentWeapon().rootweapon) )
			)
		{
			ArrayInsert(usable_wallbuy, wallbuy, usable_wallbuy.size);
		}
	}
	
	if(usable_wallbuy.size != 0)
	{
		finalwallbuy = ArrayGetClosest(self.origin, usable_wallbuy, self.wallbuy_distance);
	}
	else
	{
		usable_wallbuy = undefined;
		return false;
	}
	
	if ( !isdefined(finalwallbuy) )
	{
		usable_wallbuy = undefined;
		return false;
	}

	weapon_model_origin = struct::get( finalwallbuy.target, "targetname" ).origin;
	finalwallbuy_origin = finalwallbuy.trigger_stub.origin;
	//BulletTrace(weapon_model_origin + (0,0,10),weapon_model_origin - (0,0,10000),true,false,false,false)["position"];
	if( !self check_playable_area(finalwallbuy_origin) )
	{
		usable_wallbuy = undefined;
		return false;
	}
	
	if(self botgetgoalposition() == finalwallbuy_origin && self botgoalreached())
	{
		//IPrintLnBold("buying ",finalwallbuy.weapon.name);
		self botlookatpoint(weapon_model_origin);
		self BotTapButton(3);
		//IPrintLnBold("buying weapon " , finalwallbuy.weapon.name);	
		self thread wait_for_hasweapon();
		//self thread had_weapon_reset_view();
	}
	else
	{
		//IPrintLnBold("going to ",finalwallbuy.weapon.name);
		//self bot::approach_point(finalwallbuy.trigger_stub.origin, 0, 100, 70);
		//IPrintLnBold(self.name , " " , finalwallbuy.weapon.name , " " , finalwallbuy.trigger_stub.radius );
		self BotSetGoal(finalwallbuy_origin);
	}
	//self bot::clear_stuck();
	if(self GetVelocity() == 0)
	{
		//IPrintLnBold("bot wallbuy stuck");
		self thread release_stuck();
		//return false;
	}
	return true;
}

function release_stuck()
{
	self endon("disconnect");
	
	if(!isDefined(self.wait_stuck_check))
	{
		self.wait_stuck_check = true;

		wait 3;
		if(self GetVelocity() == 0)
		{
			//IPrintLnBold("clear_stuck");
			self bot::clear_stuck();
			self bot::navmesh_wander();
			set_bot_goal();
		}
		self.wait_stuck_check = undefined;
	}
}

function wait_for_hasweapon()
{
	self notify("wait_for_hasweapon");
	self endon("wait_for_hasweapon");	
	self waittill("weapon_give");
	if(self GetWeaponsListPrimaries().size == 2 && !isDefined(self.bot_ischanging_weapon))
	{
		self waittill("weapon_change_complete");	
		self.bot_ischanging_weapon = true;
		if(self GetCurrentWeapon() == self GetWeaponsListPrimaries()[0])
		{
			self SwitchToWeapon(self GetWeaponsListPrimaries()[1]);
		}
		else
		{
			self SwitchToWeapon(self GetWeaponsListPrimaries()[0]);
		}	
		wait 10;
		self.bot_ischanging_weapon = undefined;	
	}
}

function had_weapon_reset_view()
{
	self notify("had_weapon_reset_view");
	self endon("had_weapon_reset_view");
	self waittill("weapon_give");
	self botlookforward();
}

function openDoors()
{	
	level endon("game_ended");
	self endon("disconnect");
	if(!self zm_magicbox::can_buy_weapon())
	{
		return false;
	}
	Doors = [];
	foreach(door in GetEntArray( "zombie_door", "targetname" ))
	{
		if( !( self check_life_brush(door.origin) || self check_playable_area(door.origin) ) )
		{
			continue;
		}

		if(door._door_open == false && door.zombie_cost != 0 && self zm_score::can_player_purchase( door.zombie_cost ) && door IsTriggerEnabled() )
		{
			if(!door door_that_cant_open())
			{
				ArrayInsert(Doors, door, Doors.size);
			}
		}
	}

	foreach( airlock in GetEntArray( "zombie_airlock_buy", "targetname" ) )
	{
		if( !( self check_life_brush(airlock.origin) || self check_playable_area(airlock.origin) ) )
		{
			continue;
		}

		if(airlock.zombie_cost != 0 && self zm_score::can_player_purchase( airlock.zombie_cost ) && airlock IsTriggerEnabled())
		{
			if(!airlock door_that_cant_open())
			{
				ArrayInsert(Doors, airlock, Doors.size);
			}
		}
	}

	foreach(debris in GetEntArray( "zombie_debris", "targetname" ))
	{
		if( !( self check_life_brush(debris.origin) || self check_playable_area(debris.origin) ) )
		{
			continue;
		}

		if( self zm_score::can_player_purchase( debris.zombie_cost ) && debris IsTriggerEnabled() )
		{
			ArrayInsert(Doors, debris, Doors.size);
		}
	}
	nearDoor = ArrayGetClosest(self.origin, Doors, self.open_door_distance);
	//IPrintLnBold("script_noteworthy " , nearDoor.script_noteworthy);
	//IPrintLnBold("targetname ", nearDoor.targetname);
	//PlayFX("zombie/fx_monkey_lightning_zmb", self botgetgoalposition());
	/*if(!self check_playable_area(nearDoor.origin))
	{
		return false;
	}*/
	
	if(isDefined(nearDoor)) 
	{
		nearDoor_origin = BulletTrace(nearDoor.origin + (0,0,10),nearDoor.origin - (0,0,10000),true,false,false,false)["position"];
		if(self IsTouching(nearDoor))
		{
			//IPrintLnBold("bot try open door");
			//self botlookatpoint(nearDoor.origin);
			self BotTapButton(3); 
			//IPrintLnBold("try to open " ,nearDoor.targetname);
		}
		else
		{
			//IPrintLnBold("bot going to the door ",nearDoor_origin);
			//self BotTapButton(3); 
			//self bot::clear_stuck();
			//self bot::approach_goal_trigger(nearDoor);
			//self botlookatpoint(nearDoor.origin);
			self bot_to_trigger(nearDoor);
			//IPrintLnBold("going to " ,nearDoor.targetname);
			//self BotSetGoal(nearDoor_origin);
		}

		if(self GetVelocity() == 0)
		{
			////IPrintLnBold("bot wallbuy stuck");
			self thread release_stuck();//self bot::clear_stuck();//self thread bot::stuck_resolution();
			//return false;
		}
		return true;
	}
	else
	{
		Doors = undefined;
		return false;
	}
}

function bot_to_trigger(trigger, radius)
{
	if(trigger.classname == "trigger_use" || trigger.classname == "trigger_use_touch")
	{
		if(!isdefined(radius))
		{
			radius = bot::get_trigger_radius(trigger);
		}
		randomangle = (0, randomint(360), 0);
		randomvec = anglestoforward(randomangle);
		point = trigger.origin + (randomvec * radius);
		
		point = BulletTrace(point,point - (0,0,1000),true,false,false,false)["position"];
		self botsetgoal(point);
	}
	if(!isdefined(radius))
	{
		radius = 0;
	}
	
	origin = BulletTrace(trigger.origin,trigger.origin - (0,0,1000),true,false,false,false)["position"];
	self botsetgoal(origin, int(radius));
}

function check_playable_area(origin)
{
	if(!isDefined(self.bot_check_model))
	{
		self.bot_check_model = spawn("script_origin", origin);
	}
	else
	{
		self.bot_check_model.origin = origin;
	}

	playable_area = getentarray("player_volume","script_noteworthy");
	valid_point = false;

	for (i = 0; i < playable_area.size; i++)
	{
		if (self.bot_check_model istouching(playable_area[i]))
		{
			valid_point = true;
			break;
		}
	}
	self.bot_check_model delete();
	self.bot_check_model = undefined;
	return valid_point;
}

function check_life_brush(origin)
{
	if(!isDefined(self.bot_check_life_brush_model))
	{
		self.bot_check_life_brush_model = spawn("script_origin", origin);
	}
	else
	{
		self.bot_check_life_brush_model.origin = origin;
	}

	life_brushes = getentarray( "life_brush", "script_noteworthy" );
	valid_point = false;
	
	for ( i = 0; i < life_brushes.size; i++ )
	{
		if ( self.bot_check_life_brush_model istouching( life_brushes[i] ) )
		{
			valid_point = true;
			break;
		}
	}

	self.bot_check_life_brush_model delete();
	self.bot_check_life_brush_model = undefined;
	return valid_point;
}

function engage_threat()
{
	if( isDefined(self.is_going_to_reviving) )
	{
		return;
	}

	if( !self bot_combat::has_threat() )
	{
		return;
	}

	if(!self.bot.threat.wasvisible && self.bot.threat.visible && !self isthrowinggrenade() && !self fragbuttonpressed() && !self secondaryoffhandbuttonpressed() && !self isswitchingweapons())
	{
		visibleroll = randomint(100);
		rollweight = (isdefined(level.botsettings.lethalweight) ? level.botsettings.lethalweight : 0);
		if(visibleroll < rollweight && self.bot.threat.lastdistancesq >= level.botsettings.lethaldistanceminsq && self.bot.threat.lastdistancesq <= level.botsettings.lethaldistancemaxsq && self getweaponammostock(self.grenadetypeprimary))
		{
			self bot_combat::clear_threat_aim();
			self bot_combat::throw_grenade(self.grenadetypeprimary, self.bot.threat.lastposition);
			return;
		}
		visibleroll = visibleroll - rollweight;
		rollweight = (isdefined(level.botsettings.tacticalweight) ? level.botsettings.tacticalweight : 0);
		if(visibleroll >= 0 && visibleroll < rollweight && self.bot.threat.lastdistancesq >= level.botsettings.tacticaldistanceminsq && self.bot.threat.lastdistancesq <= level.botsettings.tacticaldistancemaxsq && self getweaponammostock(self.grenadetypesecondary))
		{
			self bot_combat::clear_threat_aim();
			self bot_combat::throw_grenade(self.grenadetypesecondary, self.bot.threat.lastposition);
			return;
		}
		self.bot.threat.aimoffset = self bot_combat::get_aim_offset(self.bot.threat.entity);
	}
	if(self fragbuttonpressed())
	{
		self bot_combat::throw_grenade(self.grenadetypeprimary, self.bot.threat.lastposition);
		return;
	}
	if(self secondaryoffhandbuttonpressed())
	{
		self bot_combat::throw_grenade(self.grenadetypesecondary, self.bot.threat.lastposition);
		return;
	}
	self bot_combat::update_weapon_aim();
	if(self isreloading() || self isswitchingweapons() || self isthrowinggrenade() || self fragbuttonpressed() || self secondaryoffhandbuttonpressed() || self ismeleeing())
	{
		return;
	}
	/*if(bot_combat::melee_attack())
	{
		return;
	}*/
	self bot_combat::update_weapon_ads();
	self fire_weapon();
}

function fire_weapon()
{
	if(!self.bot.threat.inrange)
	{
		return;
	}
	if(!self bot_combat::threat_visible())
	{
		return;
	}
	weapon = self getcurrentweapon();
	if(weapon == level.weaponnone || !self getweaponammoclip(weapon) || !isDefined(weapon))
	{
		foreach(weapon in self GetWeaponsListPrimaries())
		{
			self SwitchToWeapon(weapon);
			continue;
		}
	}
	if(self gadgetpowerget(0) == 100)
	{
		self SwitchToWeapon(self zm_utility::get_player_hero_weapon());
	}
	self thread bot_firing();
}

function bot_firing()
{
	self notify("bot_firing");
	self endon("bot_firing");
	self endon("disconnect");

	while( self bot_combat::has_threat() && self bot_combat::threat_is_alive() && self.bot.threat.inrange )
	{
		weapon = self getcurrentweapon();
		if(weapon == level.weaponnone || !self getweaponammoclip(weapon) )
		{
			self bot_combat::switch_weapon();
			self notify("bot_firing");
		}
		else
		{
			if(weapon.firetype == "Single Shot" || weapon.firetype == "Burst" || weapon.firetype == "Charge Shot")
			{
				self bottapbutton(0);
				if(weapon.isdualwield)
				{
					self bottapbutton(24);
				}
			}
			else
			{
				self botpressbutton(0);
				if(weapon.isdualwield)
				{
					self botpressbutton(24);
				}
			}
		}
		self bot_combat::update_weapon_aim();
		wait 0.1;
	}
}

function door_that_cant_open()
{
	switch( self.script_noteworthy )
	{
		case "local_electric_door":
			return true;
			
		case "electric_door":
			return true;
		case "electric_buyable_door":
			return true;
		default:
			return false;
	}
}