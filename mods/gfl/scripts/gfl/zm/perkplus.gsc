#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_pack_a_punch_util;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\zm\_zm_perks.gsh;

#namespace perkplus;

#precache( "material", "specialty_ads_zombies");

function init()
{
	callback::on_connect( &on_player_connect );
	deadshot_dealer();
	thread main();
}

function main()
{
    level endon("end_game");
    level endon("game_ended");
    level waittill( "initial_blackscreen_passed" );
	
	thread phdwine();
}

function on_player_connect()
{
	self endon("disconnect");
	
	self thread set_perk();
}

function set_perk()
{
	self endon("disconnect");
	level endon("game_ended");
	level endon("end_game");

	while (isdefined(self)) 
	{
		WAIT_SERVER_FRAME;

		if(self HasPerk("specialty_fastreload" ))
		{
			self setperk( "specialty_fastads" );
			self setperk( "specialty_fastequipmentuse" );
			self setperk( "specialty_fastmeleerecovery" );
			self setperk( "specialty_fasttoss" );
			self setperk( "specialty_fastweaponswitch" );
			self setperk("specialty_fastmantle" );
			self setperk("specialty_fastladderclimb" );
		}
		else
		{
			self unsetperk( "specialty_fastads" );
			self unsetperk( "specialty_fastequipmentuse" );
			self unsetperk( "specialty_fastmeleerecovery" );
			self unsetperk( "specialty_fasttoss" );
			self unsetperk( "specialty_fastweaponswitch" );
			self unsetperk("specialty_fastmantle" );
			self unsetperk("specialty_fastladderclimb" );
		}

		if(self HasPerk("specialty_doubletap2" ))
		{
			self setperk( "specialty_overcharge" );
		}
		else
		{
			self unsetperk( "specialty_overcharge" );
		}

		if(self hasPerk("specialty_staminup") || (isDefined(self.beastmode) && self.beastmode == 1))
		{
			self SetPerk( "specialty_unlimitedsprint");
		}
		else
		{
			self unSetPerk( "specialty_unlimitedsprint");
		}

		if(self HasPerk("specialty_staminup" ))
		{
			self setperk( "specialty_sprintrecovery" );
			self setperk( "specialty_sprintfirerecovery" );
			self setperk( "specialty_sprintequipment" );
			self setperk( "specialty_sprintgrenadelethal" );
			self setperk( "specialty_sprintgrenadetactical" );
			self setperk( "specialty_sprintfire" );
			self setperk( "specialty_movefaster" );
		}
		else
		{
			self unsetperk( "specialty_sprintrecovery" );
			self unsetperk( "specialty_sprintfirerecovery" );
			self unsetperk( "specialty_sprintequipment" );
			self unsetperk( "specialty_sprintgrenadelethal" );
			self unsetperk( "specialty_sprintgrenadetactical" );
			self unsetperk( "specialty_sprintfire" );
			self unsetperk( "specialty_movefaster" );
		}	
		self util::waittill_any_return("perk_acquired","perk_lost","weapon_change");
	}
}

function phdwine() 
{
	level endon("game_ended");
	level endon("end_game");

	if(isDefined(level.perk_damage_override) && level.perk_damage_override.size == 1 && checkwine())
	{
		level.perk_damage_override[0] = &widows_wine_damage_callback;
	}
}

function checkwine()
{
	result = false;

	if(!isdefined(level._custom_perks))
	{
		return false;
	}

	foreach(perk in GetArrayKeys( level._custom_perks ))
	{
		if(perk == "specialty_widowswine")
		{
			result = true;
			continue;
		}
	}
	return result;
}

function widows_wine_damage_callback(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	if(self HasPerk("specialty_widowswine"))
	{	
		if(sweapon == GetWeapon("sticky_grenade_widows_wine"))
		{
			idamage = 0;
			return idamage;
			break;
		}
		if(sweapon == self.current_lethal_grenade)
		{
			idamage = 0;
			return idamage;
			break;
		}
		if(self getweaponammoclip(self.current_lethal_grenade) > 0 && !self bgb::is_enabled("zm_bgb_burned_out"))
		{
			if(smeansofdeath == "MOD_MELEE" && isai(eattacker) || (smeansofdeath == "MOD_EXPLOSIVE" && isvehicle(eattacker)))
			{
				self widows_wine_contact_explosion();
			}
		}
		switch ( sMeansOfDeath )
		{
			case "MOD_GRENADE":
			case "MOD_GRENADE_SPLASH":
			case "MOD_PROJECTILE":
			case "MOD_PROJECTILE_SPLASH":
			case "MOD_EXPLOSIVE":
			case "MOD_EXPLOSIVE_SPLASH":
			idamage = 0;
			return idamage;
			break;

		default:
			return idamage;
			break;
		}
	}
	if(self HasPerk("specialty_phdflopper"))
	{	
		if(sweapon == self.current_lethal_grenade)
		{
			idamage = 0;
			return idamage;
			break;
		}
		switch ( sMeansOfDeath )
		{
			case "MOD_FALLING":
			case "MOD_BURNED":
			case "MOD_GRENADE":
			case "MOD_GRENADE_SPLASH":
			case "MOD_PROJECTILE":
			case "MOD_PROJECTILE_SPLASH":
			case "MOD_EXPLOSIVE":
			case "MOD_EXPLOSIVE_SPLASH":
			case "MOD_ELECTOCUTED":
			case "MOD_IMPACT":
			idamage = 0;
			return idamage;
			break;

		default:
			return idamage;
			break;
		}
	}
	return idamage;
}

function widows_wine_contact_explosion()
{
	self magicgrenadetype(GetWeapon("sticky_grenade_widows_wine"), self.origin + vectorscale((0, 0, 1), 48), (0, 0, 0), 0);
	self setweaponammoclip(self.current_lethal_grenade, self getweaponammoclip(self.current_lethal_grenade) - 1);
	self clientfield::increment_to_player("widows_wine_1p_contact_explosion", 1);
}

function deadshot_dealer()
{
	zm_spawner::register_zombie_death_event_callback(&on_zombie_killed);
	callback::on_connect(&init_deadshot_dealer);
	zm::register_actor_damage_callback( &deadshot_damage );
}

function init_deadshot_dealer()
{
	self.deadshot_killstreak = 0;
	self thread deadshot_icon();
}

function deadshot_icon()
{
	self endon("disconnect");

	self.deadshot_icon = newClientHudElem(self);
	self.deadshot_icon.horzAlign = "right";
	self.deadshot_icon.vertAlign = "bottom";
	self.deadshot_icon.x = -175;
	self.deadshot_icon.y = -120;
	self.deadshot_icon.alpha = 0;
	self.deadshot_icon.archived = true;
	self.deadshot_icon.hidewheninmenu = true;
	
	self.deadshot_icon setShader( "specialty_ads_zombies", 24, 24 ); 

	while(isdefined(self))
	{
		WAIT_SERVER_FRAME;
		self waittill("weapon_fired");
		if(isdefined(self.perks_active) && self.perks_active.size >= 4 && !self hide_deadshot_icon() && isprimaries(self GetCurrentWeapon()) && self HasPerk("specialty_deadshot") && isdefined(self.deadshot_killstreak) && self.deadshot_killstreak >= 5)
		{
			self.deadshot_icon.alpha = 1;
		}
		else
		{
			self.deadshot_icon.alpha = 0;
		}
	}
}

function hide_deadshot_icon()
{
	result = false;
	if(isDefined(self.current_player_scene) || self scene::is_igc_active() || (isdefined(self.dont_show_hud) && self.dont_show_hud) || self flagsys::get("playing_movie_hide_hud") )
	{
		result = true;
	}
	return result;
}

function deadshot_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
	if(isdefined(eAttacker.perks_active) && eAttacker.perks_active.size >= 4 && isdefined(eAttacker.deadshot_killstreak) && eAttacker.deadshot_killstreak >= 5 && eAttacker isprimaries(weapon))
	{
		deadshot_damage = int(iDamage * 1.25);
		return deadshot_damage;
	}
	return iDamage;
}

function on_zombie_killed(player)
{
	if( !isdefined( player ) )
	{
		return;
	}

	if( !IsPlayer( player ) )
	{
		return;
	}

	if(player hasperk("specialty_deadshot") && player isprimaries(self.damageweapon) && isdefined(player.perks_active) && player.perks_active.size >= 4)
	{
		if(zm_utility::is_headshot(self.damageweapon, self.damagelocation, self.damagemod))
		{	
			player.deadshot_killstreak++;
			//n_counter = math::clamp(e_attacker.deadshot_killstreak, 0, 5);
			/*if(e_attacker.deadshot_killstreak == 5)
			{
				e_attacker playsoundtoplayer(#"hash_6f931d032000253a", e_attacker);
			}*/
		}
		else
		{
			player.deadshot_killstreak = 0;
		}
	}
}

function isprimaries(weapon)
{
	if(isdefined(weapon))
	{
		weapons = self getweaponslistprimaries();
		if(isinarray(weapons, weapon))
		{
			return true;
		}
	}
	return false;
}