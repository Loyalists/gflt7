#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_weapons;

#using scripts\gfl\zm\zm_bot_purchase;
#using scripts\gfl\zm\zm_bot_util;

#insert scripts\shared\shared.gsh;

#namespace zm_bot_pap;

#define ZM_BOT_PAP_SEARCH_DISTANCE 1000

function start_pap_purchase()
{
	weapon = self zm_weapons::get_nonalternate_weapon(self GetCurrentWeapon());
	if (!self can_pack_weapon(weapon))
	{
		return false;
	}

	closest = undefined;
	closest_distance_sq = ZM_BOT_PAP_SEARCH_DISTANCE * ZM_BOT_PAP_SEARCH_DISTANCE;
	foreach (pap in zm_pap_util::get_triggers())
	{
		if (!isdefined(pap) || !self zm_bot_purchase::can_retry_purchase(pap) || !self can_use_pap(pap, weapon))
		{
			continue;
		}

		distance_sq = DistanceSquared(self.origin, pap.origin);
		if (distance_sq <= closest_distance_sq)
		{
			closest = pap;
			closest_distance_sq = distance_sq;
		}
	}

	if (!isdefined(closest))
	{
		return false;
	}

	task = self zm_bot_purchase::create_bot_purchase(closest, get_pap_approach(closest), &update_pap_purchase);
	task.pap_weapon = weapon;
	task.is_repack = zm_weapons::is_weapon_upgraded(weapon);
	task.pap_origin = closest.origin;
	return self update_pap_purchase(task);
}

function private can_pack_weapon(weapon)
{
	if (GetDvarInt("tfoption_gungame") == 1 || weapon.isriotshield || !self zm_magicbox::can_buy_weapon())
	{
		return false;
	}
	if (zm_weapons::is_weapon_upgraded(weapon))
	{
		return IS_TRUE(level.aat_in_use) && zm_weapons::weapon_supports_aat(weapon) &&
		       !isdefined(self aat::getAATOnWeapon(weapon));
	}
	return self zm_weapons::can_upgrade_weapon(weapon) && !self zm_weapons::has_upgrade(weapon);
}

function private can_use_pap(pap, weapon)
{
	if (!isdefined(pap) || !isdefined(pap.zbarrier) || !isdefined(pap.zbarrier.state))
	{
		return false;
	}
	if (pap.zbarrier.state != "powered" && pap.zbarrier.state != "power_on")
	{
		return false;
	}
	if (isdefined(pap.pack_player) || !pap IsTriggerEnabled())
	{
		return false;
	}
	if (!pap flag::exists("pap_offering_gun"))
	{
		return false;
	}

	cost = pap.cost;
	if (zm_weapons::is_weapon_upgraded(weapon))
	{
		cost = pap.aat_cost;
	}
	if (!isdefined(cost))
	{
		return false;
	}
	return self zm_score::can_player_purchase(cost);
}

function private get_pap_approach(pap)
{
	offset = level.pack_a_punch.interaction_trigger_radius * 0.75;
	front = pap.origin + AnglesToForward((0, pap.zbarrier.angles[1] - 90, 0)) * offset;
	return BulletTrace(front, front - (0, 0, 1000), false, undefined)["position"];
}

function private update_pap_purchase(task)
{
	pap = task.target;
	player = self zm_bot_util::get_closest_alive_player();
	weapon = self zm_weapons::get_nonalternate_weapon(self GetCurrentWeapon());
	if (self zm_bot_util::is_player_in_follow_range(player) || weapon != task.pap_weapon ||
	    !self can_pack_weapon(weapon))
	{
		self zm_bot_purchase::finish_bot_purchase();
		return false;
	}
	if (pap.origin != task.pap_origin || !self can_use_pap(pap, weapon))
	{
		self zm_bot_purchase::finish_bot_purchase(true);
		return false;
	}
	if (!self IsTouching(pap))
	{
		return self zm_bot_purchase::move_to_purchase(task, 8);
	}

	self zm_bot_purchase::tap_purchase_use(task, pap.origin, true);
	if (task.used)
	{
		self zm_bot_purchase::finish_bot_purchase();
		if (self BotGoalSet() && !self BotGoalReached())
		{
			self BotSetGoal(self.origin);
		}
		task.goal = undefined;
		task.pickup_origin = self.origin;
		self.bot_pap_pickup = task;
		self thread poll_pap_pickup(task);
	}
	return true;
}

function private poll_pap_pickup(task)
{
	self endon("disconnect");
	level endon("end_game");
	level endon("game_ended");

	pap = task.target;
	while (isdefined(pap) && !isdefined(pap.pack_player) && GetTime() < task.deadline)
	{
		wait 0.2;
	}

	while (isdefined(pap) && isdefined(pap.pack_player) && pap.pack_player == self)
	{
		task.return_weapon = pap.upgrade_weapon;
		if (self has_pap_result(task))
		{
			break;
		}
		if (!isdefined(pap.zbarrier) || pap.zbarrier.state == "initial" || pap.zbarrier.state == "power_off")
		{
			break;
		}
		task.offer_ready = pap flag::get("pap_offering_gun");
		wait 0.2;
	}

	self.bot_pap_pickup = undefined;

	if (isdefined(pap) && !self has_pap_result(task))
	{
		self zm_bot_purchase::delay_purchase_retry(pap);
	}
	self zm_bot_purchase::clear_purchase_goal(task);
}

function private has_pap_result(task)
{
	if (task.is_repack)
	{
		return isdefined(task.return_weapon) && self zm_weapons::has_weapon_or_attachments(task.return_weapon) &&
		       isdefined(self aat::getAATOnWeapon(task.return_weapon));
	}
	return self zm_weapons::has_upgrade(task.pap_weapon);
}

function has_pap_purchase()
{
	return isdefined(self.bot_pap_pickup) ||
	       (isdefined(self.bot_purchase) && isdefined(self.bot_purchase.pap_weapon));
}

function update_pap_pickup()
{
	task = self.bot_pap_pickup;
	if (!isdefined(task))
	{
		return false;
	}

	pap = task.target;
	if (!IS_TRUE(task.offer_ready) || !isdefined(pap))
	{
		return true;
	}
	if (!isdefined(pap.pack_player) || pap.pack_player != self)
	{
		return true;
	}
	if (!pap IsTriggerEnabled())
	{
		return true;
	}
	if (self IsTouching(pap))
	{
		self zm_bot_purchase::tap_purchase_use(task, pap.origin, true);
		return true;
	}
	if (GetTime() < task.next_use)
	{
		return true;
	}

	has_current_goal = isdefined(task.goal) && self BotGetGoalPosition() == task.goal;
	if (pap.origin == task.pap_origin && has_current_goal && self BotGoalSet() && !self BotGoalReached())
	{
		return true;
	}

	task.next_use = GetTime() + 400;
	origin = task.pickup_origin;
	if (pap.origin != task.pap_origin || (isdefined(task.goal) && self BotGoalReached()))
	{
		origin = get_pap_approach(pap);
	}
	if (!self BotSetGoal(origin, 8))
	{
		return true;
	}

	task.goal = self BotGetGoalPosition();
	task.pickup_origin = origin;
	task.pap_origin = pap.origin;
	return true;
}
