#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\util_shared;

#using scripts\gfl\zm\zm_bot_purchase;
#using scripts\gfl\zm\zm_bot_util;

#insert scripts\shared\shared.gsh;

#namespace zm_bot_navigation;

#define ZM_BOT_STALL_TIME_MS 3000
#define ZM_BOT_STALL_DISTANCE 100
#define ZM_BOT_RECOVERY_TIME_MS 10000
#define ZM_BOT_RECOVERY_FOLLOW_CHECK_MS 1000
#define ZM_BOT_RECOVERY_FOLLOW_RADIUS 120
#define ZM_BOT_RECOVERY_BLOCKED_RADIUS 160

function watch_path_failures()
{
	self notify("gfl_bot_watch_path_failures");
	self endon("gfl_bot_watch_path_failures");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	level endon("end_game");

	while (true)
	{
		self waittill("bot_path_failed");
		if (!IS_TRUE(self.bot_paused) && !isdefined(self.bot_revive_target) &&
		    !isdefined(self.bot_recovery_until) && self BotGoalSet() && !self BotGoalReached())
		{
			self.bot_failed_path_goal = self BotGetGoalPosition();
		}
	}
}

function update_recovery()
{
	now = GetTime();
	if (isdefined(self.bot_recovery_until))
	{
		if (now < self.bot_recovery_until)
		{
			self follow_recovery_player(now);
			return true;
		}

		reset_recovery();
		self.bot_recovery_replan = true;
		self BotSetGoal(self.origin);
		return false;
	}

	if (!self BotGoalSet() || self BotGoalReached() || self util::isstunned())
	{
		self reset_stall_sample();
		return false;
	}

	goal = self BotGetGoalPosition();
	path_failed = isdefined(self.bot_failed_path_goal) &&
	              DistanceSquared(goal, self.bot_failed_path_goal) <= ZM_BOT_STALL_DISTANCE * ZM_BOT_STALL_DISTANCE;
	if (!path_failed)
	{
		self.bot_failed_path_goal = undefined;
	}
	if (!isdefined(self.bot_stall_origin) ||
	    Distance2DSquared(self.origin, self.bot_stall_origin) >= ZM_BOT_STALL_DISTANCE * ZM_BOT_STALL_DISTANCE)
	{
		self.bot_stall_origin = self.origin;
		self.bot_stall_since = now;
	}

	if ((!path_failed && now - self.bot_stall_since < ZM_BOT_STALL_TIME_MS) || !self IsOnGround() || self IsMantling())
	{
		return false;
	}

	self.bot_recovery_until = now + ZM_BOT_RECOVERY_TIME_MS;
	self.bot_recovery_blocked_goal = goal;
	self zm_bot_purchase::finish_bot_purchase(true);
	self bot::clear_stuck();
	self bot::end_sprint_to_goal();
	self BotSetGoal(self.origin);
	self follow_recovery_player(now);
	return true;
}

function update_threat_goal()
{
	if (isdefined(self.bot_recovery_until))
	{
		return;
	}

	if (IS_TRUE(self.bot_recovery_replan))
	{
		// The shared hook normally keeps an existing goal for an already visible threat.
		self.bot_recovery_replan = undefined;
		was_visible = self.bot.threat.wasVisible;
		self.bot.threat.wasVisible = false;
		self bot_combat::update_threat_goal();
		self.bot.threat.wasVisible = was_visible;
		return;
	}

	self bot_combat::update_threat_goal();
}

function reset_recovery()
{
	self reset_stall_sample();
	self.bot_recovery_until = undefined;
	self.bot_recovery_blocked_goal = undefined;
	self.bot_recovery_next_follow = undefined;
	self.bot_recovery_replan = undefined;
}

function reset_stall_sample()
{
	self.bot_stall_origin = undefined;
	self.bot_stall_since = undefined;
	self.bot_failed_path_goal = undefined;
}

function private follow_recovery_player(now)
{
	if (isdefined(self.bot_recovery_next_follow) && now < self.bot_recovery_next_follow)
	{
		return;
	}
	self.bot_recovery_next_follow = now + ZM_BOT_RECOVERY_FOLLOW_CHECK_MS;

	player = self zm_bot_util::get_catchup_player(self.bot_recovery_blocked_goal, ZM_BOT_RECOVERY_BLOCKED_RADIUS);
	follow_radius_sq = ZM_BOT_RECOVERY_FOLLOW_RADIUS * ZM_BOT_RECOVERY_FOLLOW_RADIUS;
	if (!isdefined(player) || DistanceSquared(self.origin, player.origin) <= follow_radius_sq)
	{
		if (self BotGoalSet() && !self BotGoalReached())
		{
			self BotSetGoal(self.origin);
		}
		return;
	}

	if (self BotGoalSet() && !self BotGoalReached() &&
	    DistanceSquared(self BotGetGoalPosition(), player.origin) <= follow_radius_sq)
	{
		return;
	}

	if (self BotSetGoal(player.origin, ZM_BOT_RECOVERY_FOLLOW_RADIUS))
	{
		self bot::sprint_to_goal();
	}
}
