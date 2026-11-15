#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\zm\_zm_laststand;

#using scripts\gfl\zm\zm_bot_purchase;

#insert scripts\shared\shared.gsh;

#namespace zm_bot_revive;

function wait_for_downed()
{
	level endon("end_game");
	level flag::wait_till("initial_blackscreen_passed");

	while (true)
	{
		players = GetPlayers();
		foreach (player in players)
		{
			if (player IsTestClient())
			{
				if (!can_bot_revive(player))
				{
					player release_revive_target();
					player zm_bot_purchase::finish_bot_purchase();
				}
				else if (isdefined(player.bot_revive_deadline) && !array::contains(players, player.bot_revive_target))
				{
					player release_revive_target();
				}
			}
			if (!is_revive_target(player) || IS_TRUE(player.revivetrigger.beingRevived))
			{
				continue;
			}

			reviver = player.bot_reviver;
			if (isdefined(reviver) && array::contains(players, reviver) && can_bot_revive(reviver) &&
			    isdefined(reviver.bot_revive_target) && reviver.bot_revive_target == player)
			{
				continue;
			}
			player.bot_reviver = undefined;

			reviver = player get_closest_reviver(players);
			if (isdefined(reviver))
			{
				reviver zm_bot_purchase::finish_bot_purchase();
				reviver bot_combat::clear_threat();
				reviver.bot_revive_target = player;
				reviver.bot_revive_deadline = GetTime() + 10000;
				reviver.bot_revive_best_distance = Distance(reviver.origin, player.origin);
				player.bot_reviver = reviver;
				reviver bot::tap_offhand_button();
			}
		}
		wait 0.5;
	}
}

function private is_revive_target(player)
{
	return isdefined(player) && isdefined(player.revivetrigger) && player laststand::player_is_in_laststand();
}

function private can_bot_revive(player)
{
	return isalive(player) && player.sessionstate == "playing" && isdefined(player.bot) &&
	       !IS_TRUE(player.bot_paused) && !IS_TRUE(player.is_zombie) &&
	       !player laststand::player_is_in_laststand();
}

function private get_closest_reviver(players)
{
	bots = [];
	foreach (player in players)
	{
		if (!player IsTestClient() || player.team != self.team || !can_bot_revive(player) ||
		    player zm_laststand::is_reviving_any() || isdefined(player.bot_revive_target))
		{
			continue;
		}
		if (isdefined(player.bot_failed_revive_target) && player.bot_failed_revive_target == self && GetTime() < player.bot_failed_revive_until)
		{
			continue;
		}
		bots[bots.size] = player;
	}
	return ArrayGetClosest(self.origin, bots);
}

function update_revive_task()
{
	target = self.bot_revive_target;
	if (!is_revive_target(target) || target.team != self.team)
	{
		self release_revive_target();
		return false;
	}

	if (!self zm_laststand::is_reviving_any())
	{
		now = GetTime();
		distance = Distance(self.origin, target.origin);
		if (distance + 24 < self.bot_revive_best_distance)
		{
			self.bot_revive_best_distance = distance;
			self.bot_revive_deadline = now + 10000;
		}
		if (now >= self.bot_revive_deadline)
		{
			self.bot_failed_revive_target = target;
			self.bot_failed_revive_until = now + 1000;
			self release_revive_target();
			return false;
		}
		if (IS_TRUE(target.revivetrigger.beingRevived))
		{
			self release_revive_target();
			return false;
		}
	}

	self BotLookAtPoint(target GetCentroid());
	if (!self IsTouching(target.revivetrigger))
	{
		self.bot_revive_in_place = undefined;
		self approach_revive_target(target);
	}
	else if (!IS_TRUE(self.bot_revive_in_place))
	{
		self.bot_revive_in_place = true;
		self.bot_revive_goal = undefined;
		self bot::end_sprint_to_goal();
		self BotSetGoal(self.origin);
	}
	return true;
}

function private approach_revive_target(target)
{
	now = GetTime();
	if (isdefined(self.bot_revive_next_path) && now < self.bot_revive_next_path)
	{
		return;
	}

	// Replace the follow goal even when the downed player is still inside its radius.
	if (isdefined(self.bot_revive_goal) && self BotGoalSet() && !self BotGoalReached() &&
	    self BotGetGoalPosition() == self.bot_revive_goal &&
	    DistanceSquared(target.origin, self.bot_revive_goal_target) <= 144)
	{
		return;
	}

	self.bot_revive_next_path = now + 250;
	if (self BotSetGoal(target.origin, 8))
	{
		self.bot_revive_goal = self BotGetGoalPosition();
		self.bot_revive_goal_target = target.origin;
		self bot::sprint_to_goal();
	}
	else
	{
		self.bot_revive_goal = undefined;
	}
}

function release_revive_target()
{
	target = self.bot_revive_target;
	if (isdefined(target) && isdefined(target.bot_reviver) && target.bot_reviver == self)
	{
		target.bot_reviver = undefined;
	}
	if (isdefined(self.bot_revive_deadline) && isalive(self))
	{
		self bot::end_sprint_to_goal();
		self BotSetGoal(self.origin);
		self BotLookForward();
	}
	self.bot_revive_target = undefined;
	self.bot_revive_deadline = undefined;
	self.bot_revive_best_distance = undefined;
	self.bot_revive_goal = undefined;
	self.bot_revive_goal_target = undefined;
	self.bot_revive_next_path = undefined;
	self.bot_revive_in_place = undefined;
}

function area_revive()
{
	if (!isdefined(self.bot_revive_override))
	{
		// Zombies owns the revive tool and restores the previous weapon.
		self.bot_revive_override = self zm_laststand::register_revive_override(&bot_can_revive_target, undefined, true);
	}
}

function private bot_can_revive_target(target)
{
	return !IS_TRUE(self.bot_paused) &&
	       isdefined(self.bot_revive_target) &&
	       self.bot_revive_target == target &&
	       self zm_laststand::can_revive(target);
}
