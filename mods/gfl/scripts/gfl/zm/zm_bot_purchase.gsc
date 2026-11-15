#using scripts\codescripts\struct;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\bots\_bot.gsh;

#namespace zm_bot_purchase;

#define ZM_BOT_MAGICBOX_COOLDOWN_MS 20000
#define ZM_BOT_PERK_SEARCH_DISTANCE 600

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

	if ( current_weapon.name == "defaultweapon" || current_weapon.name == "none" || current_weapon.name == weaponNone.name )
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
	if ( zm_weapons::is_weapon_upgraded( current_weapon ) || zm_weapons::is_wonder_weapon( current_weapon ) )
	{
		if ( !zm_weapons::is_weapon_upgraded( weapon ) && !zm_weapons::is_wonder_weapon( weapon ) )
		{
			return false;
		}
	}

	target_weapon_cost = bot_weapon_cost(weapon.rootweapon);
	current_weapon_cost = bot_weapon_cost(current_weapon.rootweapon);

	if (target_weapon_cost > 0 && target_weapon_cost >= current_weapon_cost)
	{
		return true;
	}

	if ( zm_weapons::is_wonder_weapon( weapon ) || weapon.rootweapon.weapClass == "wonder" )
	{
		return true;
	}

	if(
		weapon.rootweapon.weapClass == "rocketlauncher" ||
		weapon.rootweapon.weapClass == "mg" ||
		weapon.rootweapon.inventorytype != "primary" ||
		weapon.rootweapon.weapClass == "spread"
	)
	{
		return true;
	}

	return false;
}

function start_shared_weapon_pickup()
{
	closest = undefined;
	closest_distance_sq = self.box_share_distance * self.box_share_distance;
	foreach (box in get_magicboxes())
	{
		share = box.magicboxshare;
		if (!isdefined(share) || !self can_retry_purchase(share) || !self bot_likes_weapon(share.weapon))
		{
			continue;
		}

		distance_sq = DistanceSquared(self.origin, share.origin);
		if (distance_sq <= closest_distance_sq)
		{
			closest = share;
			closest_distance_sq = distance_sq;
		}
	}

	if (!isdefined(closest))
	{
		return false;
	}
	task = self create_bot_purchase(closest, closest.origin, &update_shared_weapon_pickup);
	return self update_shared_weapon_pickup(task);
}

function private update_shared_weapon_pickup(task)
{
	share = task.target;
	if (!self bot_likes_weapon(share.weapon))
	{
		self finish_bot_purchase();
		return false;
	}
	if (self IsTouching(share))
	{
		self tap_purchase_use(task, share.origin);
		return true;
	}
	return self move_to_purchase(task, 8);
}

function private get_magicboxes()
{
	if (isdefined(level.chests))
	{
		return level.chests;
	}
	return [];
}

function start_magicbox_purchase()
{
	if (isdefined(self.bot_next_box_time) && GetTime() < self.bot_next_box_time)
	{
		return false;
	}
	if (!self zm_magicbox::can_buy_weapon() || GetDvarInt("tfoption_gungame") == 1 || level flag::get("moving_chest_now"))
	{
		return false;
	}

	closest = undefined;
	closest_distance_sq = self.magic_box_distance * self.magic_box_distance;
	foreach (box in get_magicboxes())
	{
		if (!isdefined(box.zbarrier) || !isdefined(box.unitrigger_stub) || !self can_retry_purchase(box))
		{
			continue;
		}

		origin = box.unitrigger_stub.origin;
		distance_sq = DistanceSquared(self.origin, origin);
		if (distance_sq > closest_distance_sq)
		{
			continue;
		}

		owns_box = isdefined(box.chest_user) && box.chest_user == self;
		if ((!owns_box && !self can_open_box(box)) || !self check_playable_area(origin))
		{
			continue;
		}
		closest = box;
		closest_distance_sq = distance_sq;
	}

	if (!isdefined(closest))
	{
		return false;
	}
	task = self create_bot_purchase(closest, closest.unitrigger_stub.origin, &update_magicbox_purchase);
	return self update_magicbox_purchase(task);
}

function private update_magicbox_purchase(task)
{
	box = task.target;
	if (!isdefined(box.zbarrier) || !isdefined(box.unitrigger_stub) ||
	    box.unitrigger_stub.origin != task.origin || level flag::get("moving_chest_now"))
	{
		self finish_bot_purchase(true);
		return false;
	}

	if (isdefined(box.chest_user) && box.chest_user == self)
	{
		if (!IS_TRUE(task.owns_box))
		{
			task.owns_box = true;
			task.used = false;
			task.deadline = GetTime() + 12000;
		}

		// The hint is cleared while the box is rolling or respinning.
		if (!IS_TRUE(box.grab_weapon_hint) || !isdefined(box.grab_weapon) || box.grab_weapon == level.weaponNone)
		{
			return true;
		}

		if (self reached_purchase_goal(task))
		{
			if (IS_TRUE(task.used) && task.offered_weapon == box.grab_weapon &&
			    self zm_weapons::has_weapon_or_upgrade(box.grab_weapon))
			{
				self finish_bot_purchase();
				return false;
			}
			if (!isdefined(task.offered_weapon) || task.offered_weapon != box.grab_weapon)
			{
				task.offered_weapon = box.grab_weapon;
				task.used = false;
				self.bot_next_box_time = GetTime() + ZM_BOT_MAGICBOX_COOLDOWN_MS;
			}

			if (self bot_likes_weapon(box.grab_weapon))
			{
				self tap_purchase_use(task, task.origin);
			}
			else if (isdefined(box.zbarrier.weapon_model) && GetTime() >= task.next_use)
			{
				// The optional box-sharing system listens for melee.
				self BotLookAtPoint(box.zbarrier.weapon_model.origin);
				self bot::tap_melee_button();
				self finish_bot_purchase(true);
				return false;
			}
			return true;
		}
	}
	else
	{
		if (IS_TRUE(task.owns_box) || !self can_open_box(box))
		{
			self finish_bot_purchase();
			return false;
		}
		if (self reached_purchase_goal(task))
		{
			self tap_purchase_use(task, task.origin);
			return true;
		}
	}

	return self move_to_purchase(task);
}

function private can_open_box(box)
{
	if (isdefined(box.chest_user) || !self zm_score::can_player_purchase(box.zombie_cost))
	{
		return false;
	}

	state = box.zbarrier zm_magicbox::get_magic_box_zbarrier_state();
	return state == "close" || state == "initial" || state == "arriving";
}

function private bot_weapon_cost(weapon)
{
	if (!isdefined(weapon) || !isdefined(level.zombie_weapons) || !isdefined(level.zombie_weapons[weapon]))
	{
		return 0;
	}

	cost = zm_weapons::get_weapon_cost(weapon);
	if (!isdefined(cost))
	{
		return 0;
	}
	return int(cost);
}

function start_wallbuy()
{
	if (!self zm_magicbox::can_buy_weapon() || GetDvarInt("tfoption_gungame") == 1 || !isdefined(level._spawned_wallbuys))
	{
		return false;
	}

	current_cost = bot_weapon_cost(self GetCurrentWeapon().rootweapon);
	if (!IS_TRUE(current_cost))
	{
		return false;
	}

	closest = undefined;
	closest_distance_sq = self.wallbuy_distance * self.wallbuy_distance;
	foreach (wallbuy in level._spawned_wallbuys)
	{
		if (!isdefined(wallbuy.trigger_stub) || !self can_retry_purchase(wallbuy))
		{
			continue;
		}
		origin = wallbuy.trigger_stub.origin;
		distance_sq = DistanceSquared(self.origin, origin);
		if (distance_sq > closest_distance_sq)
		{
			continue;
		}

		weapon = wallbuy.weapon;
		cost = bot_weapon_cost(weapon);
		if (cost <= current_cost ||
		    issubstr(weapon.rootweapon.name, "knife") || issubstr(weapon.rootweapon.name, "melee") ||
		    self zm_weapons::has_weapon_or_upgrade(weapon) || !self zm_score::can_player_purchase(cost))
		{
			continue;
		}
		if (self check_playable_area(origin))
		{
			closest = wallbuy;
			closest_distance_sq = distance_sq;
		}
	}

	if (!isdefined(closest))
	{
		return false;
	}
	task = self create_bot_purchase(closest, closest.trigger_stub.origin, &update_wallbuy);
	return self update_wallbuy(task);
}

function private update_wallbuy(task)
{
	wallbuy = task.target;
	if (self zm_weapons::has_weapon_or_upgrade(wallbuy.weapon))
	{
		self finish_bot_purchase();
		return false;
	}

	cost = bot_weapon_cost(wallbuy.weapon);
	if (!isdefined(wallbuy.trigger_stub) || wallbuy.trigger_stub.origin != task.origin ||
	    !self zm_magicbox::can_buy_weapon() || cost <= 0 || !self zm_score::can_player_purchase(cost))
	{
		self finish_bot_purchase(true);
		return false;
	}
	if (self reached_purchase_goal(task))
	{
		model = struct::get(wallbuy.target, "targetname");
		look_at = task.origin;
		if (isdefined(model))
		{
			look_at = model.origin;
		}
		self tap_purchase_use(task, look_at);
		return true;
	}
	return self move_to_purchase(task);
}

function start_perk_purchase()
{
	if (!self zm_utility::can_player_purchase_perk())
	{
		return false;
	}

	closest = undefined;
	closest_distance_sq = ZM_BOT_PERK_SEARCH_DISTANCE * ZM_BOT_PERK_SEARCH_DISTANCE;
	foreach (machine in GetEntArray("zombie_vending", "targetname"))
	{
		distance_sq = DistanceSquared(self.origin, machine.origin);
		if (distance_sq <= closest_distance_sq && self can_retry_purchase(machine) && self can_buy_perk(machine))
		{
			closest = machine;
			closest_distance_sq = distance_sq;
		}
	}

	if (!isdefined(closest))
	{
		return false;
	}

	// The machine model can occupy the center of the use trigger.
	delta = self.origin - closest.origin;
	direction = VectorNormalize((delta[0], delta[1], 0));
	point = closest.origin + direction * (bot::get_trigger_radius(closest) * 0.75);
	approach = BulletTrace(point, point - (0, 0, 1000), false, undefined)["position"];
	task = self create_bot_purchase(closest, approach, &update_perk_purchase);
	task.perk = closest.script_noteworthy;
	task.trigger_origin = closest.origin;
	return self update_perk_purchase(task);
}

function private can_buy_perk(machine)
{
	perk = machine.script_noteworthy;
	return IS_TRUE(machine.power_on) && machine IsTriggerEnabled() && isdefined(machine.cost) &&
	       isdefined(perk) && !self HasPerk(perk) && !self zm_perks::has_perk_paused(perk) &&
	       self zm_score::can_player_purchase(machine.cost) && machine zm_perks::vending_trigger_can_player_use(self);
}

function private update_perk_purchase(task)
{
	machine = task.target;
	if (self HasPerk(task.perk) || self zm_perks::has_perk_paused(task.perk))
	{
		self finish_bot_purchase();
		return false;
	}
	if (isdefined(self.perk_purchased) && self.perk_purchased == task.perk)
	{
		return true;
	}
	if (!self zm_utility::can_player_purchase_perk())
	{
		self finish_bot_purchase();
		return false;
	}
	if (machine.origin != task.trigger_origin || machine.script_noteworthy != task.perk || !self can_buy_perk(machine))
	{
		self finish_bot_purchase(true);
		return false;
	}
	if (self IsTouching(machine))
	{
		if (self BotGoalSet() && !self BotGoalReached())
		{
			self BotSetGoal(self.origin);
		}
		self tap_purchase_use(task, machine.origin, true);
		return true;
	}
	return self move_to_purchase(task, 8);
}

function start_door_purchase()
{
	if (!self zm_magicbox::can_buy_weapon())
	{
		return false;
	}

	closest = undefined;
	closest_distance_sq = self.open_door_distance * self.open_door_distance;
	foreach (targetname in array("zombie_door", "zombie_airlock_buy", "zombie_debris"))
	{
		foreach (door in GetEntArray(targetname, "targetname"))
		{
			distance_sq = DistanceSquared(self.origin, door.origin);
			if (distance_sq > closest_distance_sq || !self can_retry_purchase(door) ||
			    !self can_buy_door(door) || door door_that_cant_open())
			{
				continue;
			}

			if (self check_life_brush(door.origin) || self check_playable_area(door.origin))
			{
				closest = door;
				closest_distance_sq = distance_sq;
			}
		}
	}

	if (!isdefined(closest))
	{
		return false;
	}
	task = self create_bot_purchase(closest, closest.origin, &update_door_purchase);
	return self update_door_purchase(task);
}

function private update_door_purchase(task)
{
	door = task.target;
	if (!self can_buy_door(door))
	{
		self finish_bot_purchase();
		return false;
	}
	if (self IsTouching(door))
	{
		self tap_purchase_use(task, door.origin);
		return true;
	}

	if (isdefined(task.goal) && self BotGetGoalPosition() == task.goal)
	{
		if (self BotGoalReached())
		{
			if (IS_TRUE(task.try_center))
			{
				self finish_bot_purchase(true);
				return false;
			}
			task.try_center = true;
		}
		else if (self BotGoalSet())
		{
			return true;
		}
	}

	if (!self bot_to_trigger(door, IS_TRUE(task.try_center)))
	{
		self finish_bot_purchase(true);
		return false;
	}
	task.goal = self BotGetGoalPosition();
	return true;
}

function private can_buy_door(door)
{
	return door IsTriggerEnabled() && !IS_TRUE(door._door_open) &&
	       isdefined(door.zombie_cost) &&
	       (door.zombie_cost != 0 || door.targetname == "zombie_debris") &&
	       self zm_score::can_player_purchase(door.zombie_cost);
}

function can_retry_purchase(target)
{
	return !isdefined(self.bot_failed_purchase) || self.bot_failed_purchase != target ||
	       GetTime() >= self.bot_purchase_retry_time;
}

function delay_purchase_retry(target)
{
	self.bot_failed_purchase = target;
	self.bot_purchase_retry_time = GetTime() + 5000;
}

function create_bot_purchase(target, origin, update)
{
	task = SpawnStruct();
	task.update = update;
	task.target = target;
	task.origin = origin;
	task.deadline = GetTime() + 12000;
	task.next_use = 0;
	task.used = false;
	self.bot_purchase = task;
	self thread watch_bot_purchase_path(task);
	return task;
}

function private watch_bot_purchase_path(task)
{
	self endon("disconnect");
	self endon("death");
	self endon("gfl_bot_purchase_done");
	level endon("end_game");

	while (true)
	{
		self waittill("bot_path_failed");
		if (isdefined(task.goal) && self BotGetGoalPosition() == task.goal &&
		    !self bot_combat::threat_visible())
		{
			task.path_failed = true;
			return;
		}
	}
}

function finish_bot_purchase(failed = false)
{
	task = self.bot_purchase;
	if (!isdefined(task))
	{
		return;
	}

	if (failed && isdefined(task.target))
	{
		self delay_purchase_retry(task.target);
	}
	self.bot_purchase = undefined;
	self notify("gfl_bot_purchase_done");
	self clear_purchase_goal(task);
}

function clear_purchase_goal(task)
{
	if (isalive(self) && isdefined(task.goal) && self BotGetGoalPosition() == task.goal)
	{
		self BotSetGoal(self.origin);
	}
}

function get_active_bot_purchase()
{
	task = self.bot_purchase;
	if (!isdefined(task))
	{
		return undefined;
	}
	if (!isdefined(task.target))
	{
		self finish_bot_purchase();
		return undefined;
	}
	if (GetTime() >= task.deadline || IS_TRUE(task.path_failed))
	{
		self finish_bot_purchase(true);
		return undefined;
	}
	return task;
}

function tap_purchase_use(task, look_at, require_aim = false)
{
	if (self IsSwitchingWeapons() || self IsFiring() || GetTime() < task.next_use)
	{
		return;
	}

	self BotLookAtPoint(look_at);
	if (require_aim && self bot::fwd_dot(look_at) < 0.95)
	{
		return;
	}
	self bot::tap_use_button();
	task.next_use = GetTime() + 400;
	if (!task.used)
	{
		task.used = true;
		task.deadline = GetTime() + 2500;
	}
}

function private reached_purchase_goal(task)
{
	return isdefined(task.goal) && self BotGetGoalPosition() == task.goal && self BotGoalReached();
}

function move_to_purchase(task, radius = BOT_DEFAULT_GOAL_RADIUS)
{
	if (isdefined(task.goal) && self BotGetGoalPosition() == task.goal)
	{
		if (self BotGoalReached())
		{
			self finish_bot_purchase(true);
			return false;
		}
		if (self BotGoalSet())
		{
			return true;
		}
	}

	if (!self BotSetGoal(task.origin, radius))
	{
		self finish_bot_purchase(true);
		return false;
	}
	task.goal = self BotGetGoalPosition();
	return true;
}

function private bot_to_trigger(trigger, try_center)
{
	if (!try_center && (trigger.classname == "trigger_use" || trigger.classname == "trigger_use_touch"))
	{
		radius = bot::get_trigger_radius(trigger);
		direction = AnglesToForward((0, RandomInt(360), 0));
		point = trigger.origin + direction * radius * 0.75;
		point = BulletTrace(point, point - (0, 0, 1000), true, false, false, false)["position"];
		if (self BotSetGoal(point, 8))
		{
			return true;
		}
	}

	origin = BulletTrace(trigger.origin, trigger.origin - (0, 0, 1000), true, false, false, false)["position"];
	return self BotSetGoal(origin, 8);
}

function private check_playable_area(origin)
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

function private check_life_brush(origin)
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

function private door_that_cant_open()
{
	if (!isdefined(self.script_noteworthy))
	{
		return false;
	}

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
