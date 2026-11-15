#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;

#namespace zm_bot_combat;

#define ZM_BOT_SEMI_AUTO_TAP_INTERVAL 0.1
#define ZM_BOT_DUAL_WIELD_FIRE_BUTTON 24

function find_zombie_threats(max_distance)
{
	if (!isdefined(max_distance) || max_distance <= 0)
	{
		max_distance = level.botSettings.threatRadiusMax;
	}
	max_distance_sq = max_distance * max_distance;
	candidates = [];
	foreach (target in GetAITeamArray("axis"))
	{
		if (should_ignore_target(target) || self [[level.botIgnoreThreat]](target))
		{
			continue;
		}
		if (max_distance_sq > 0 && DistanceSquared(self.origin, target.origin) > max_distance_sq)
		{
			continue;
		}
		candidates[candidates.size] = target;
	}

	foreach (target in ArraySort(candidates, self.origin))
	{
		if (self BotSightTrace(target))
		{
			return array(target);
		}
	}
	return [];
}

function should_ignore_target(target)
{
	if (!isdefined(target) || !isalive(target))
	{
		return true;
	}

	if (isdefined(target.archetype) && target.archetype == "zombie_george")
	{
		return !target flag::exists("george_is_enraged") || !target flag::get("george_is_enraged");
	}
	return false;
}

function bot_got_damage()
{
	if (IS_TRUE(self.bot_paused) || isdefined(self.bot_revive_target) || self laststand::player_is_in_laststand())
	{
		return;
	}

	attacker = self.bot.damage.entity;
	if (should_ignore_target(attacker) || attacker.team != "axis" || self [[level.botIgnoreThreat]](attacker))
	{
		return;
	}

	if (!self bot_combat::threat_visible() && self BotSightTrace(attacker))
	{
		self BotLookAtPoint(attacker GetCentroid());
	}
}

function turn_toward_threat()
{
	if (!self bot_combat::has_threat())
	{
		return false;
	}

	target = self.bot.threat.entity;
	prediction_time = VAL(level.botSettings.thinkInterval, 0.05);
	aim_point = target.origin + (target GetVelocity()) * prediction_time + self.bot.threat.aimOffset;
	if (self bot::fwd_dot(aim_point) >= self BotGetFov() || !self BotSightTrace(target))
	{
		return false;
	}

	self BotLookAtPoint(aim_point);
	return true;
}

function engage_threat()
{
	if (!self bot_combat::threat_visible() || self turn_toward_threat())
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
	if (self prepare_combat_weapon())
	{
		return;
	}
	self bot_combat::update_weapon_ads();
	weapon = self GetCurrentWeapon();
	if (weapon.fireType == "Single Shot")
	{
		if (!IS_TRUE(self.bot_semi_auto_firing))
		{
			self.bot_semi_auto_firing = true;
			self thread tap_semi_auto(self.bot.threat.entity, weapon);
		}
		return;
	}

	self bot_combat::fire_weapon();
}

function private tap_semi_auto(target, weapon)
{
	self endon("death");
	self endon("disconnect");
	self endon("gfl_bot_stop_semi_auto");
	level endon("end_game");
	level endon("game_ended");

	while (!should_ignore_target(target) && self bot_combat::threat_visible() &&
	       self.bot.threat.entity == target && self.bot.threat.inRange &&
	       self GetCurrentWeapon() == weapon && self GetWeaponAmmoClip(weapon) > 0)
	{
		if (IS_TRUE(self.bot_paused) || isdefined(self.bot_revive_target) ||
		    self.sessionstate != "playing" || self laststand::player_is_in_laststand() ||
		    self IsReloading() || self IsSwitchingWeapons() || self IsThrowingGrenade() ||
		    self FragButtonPressed() || self SecondaryOffhandButtonPressed() || self IsMeleeing())
		{
			break;
		}

		dot = self bot::fwd_dot(target.origin + self.bot.threat.aimOffset);
		if (dot < self bot_combat::weapon_fire_dot(weapon) || dot < self BotGetFov() || !self BotSightTrace(target))
		{
			break;
		}

		self bot::tap_attack_button();
		if (weapon.isDualWield)
		{
			self BotTapButton(ZM_BOT_DUAL_WIELD_FIRE_BUTTON);
		}
		wait ZM_BOT_SEMI_AUTO_TAP_INTERVAL;
	}

	self.bot_semi_auto_firing = undefined;
}

function private prepare_combat_weapon()
{
	weapon = self GetCurrentWeapon();
	if (weapon == level.weaponReviveTool)
	{
		return true;
	}

	hero_weapon = self zm_utility::get_player_hero_weapon();
	if (hero_weapon != level.weaponNone && weapon != hero_weapon &&
	    self GadgetPowerGet(0) == 100 && self HasWeapon(hero_weapon))
	{
		self SwitchToWeapon(hero_weapon);
		return true;
	}

	if (weapon != level.weaponNone && self GetWeaponAmmoClip(weapon) > 0)
	{
		return false;
	}
	if (weapon != level.weaponNone && self GetWeaponAmmoStock(weapon) > 0)
	{
		self bot::tap_reload_button();
		return true;
	}

	foreach (backup in self GetWeaponsListPrimaries())
	{
		if (backup != weapon && (self GetWeaponAmmoClip(backup) > 0 || self GetWeaponAmmoStock(backup) > 0))
		{
			self BotSwitchToWeapon(backup);
			return true;
		}
	}
	return true;
}
