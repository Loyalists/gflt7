#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;

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

#namespace coldwar_scoreevent;

function init()
{
    callback::on_connect( &on_player_connect );
    zm::register_zombie_damage_override_callback( &coldwar_scoreevent_logic );
    zm::register_vehicle_damage_callback(&coldwar_scoreevent_logic_vehicle);
	level.onlinegame = true;
}

function on_player_connect()
{
	self endon("disconnect");

    self thread pap_scoreevent_think();
    self thread special_event_scoreevent_think();
	self thread powerup_scoreevent_think();
	self thread powerup_level_scoreevent_think();
}

function pap_scoreevent_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (isdefined(self))
	{
		self waittill("pap_taken");
		self waittill("weapon_change");

		scoreevents::processScoreEvent( "pap_taken", self );
        WAIT_SERVER_FRAME;
	}
}

function special_event_scoreevent_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (true)
	{
		event = self util::waittill_any_return( "perk_bought", "start_scoreevent_weapon", "magicbox_weapon_shared" );

		if (event == "perk_bought")
		{
		    scoreevents::processScoreEvent( "perk_taken", self );
		}

		if (event == "start_scoreevent_weapon")
		{
		    scoreevents::processScoreEvent( "get_weapon", self );
		}

		if (event == "magicbox_weapon_shared")
		{
		    scoreevents::processScoreEvent( "weapon_shared", self );
		}

        WAIT_SERVER_FRAME;
	}
}

function powerup_scoreevent_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (true)
	{
		event = self util::waittill_any_return( "nuke_triggered", "free_packapunch_grabbed", "zombie_money_grabbed" );

		if (event == "nuke_triggered")
		{
		    scoreevents::processScoreEvent( "nuke", self );
		}

		if (event == "free_packapunch_grabbed")
		{
		    scoreevents::processScoreEvent( "free_pap", self );
		}

		if (event == "zombie_money_grabbed")
		{
		    scoreevents::processScoreEvent( "zombie_money", self );
		}

        WAIT_SERVER_FRAME;
	}
}

function powerup_level_scoreevent_think()
{
	self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

	while (true)
	{
		event = level util::waittill_any_return( "carpenter_started", "zmb_max_ammo_level", "free_perk_grabbed_level" );

		if (event == "carpenter_started")
		{
		    scoreevents::processScoreEvent( "carpenter", self );
		}

		if (event == "zmb_max_ammo_level")
		{
		    scoreevents::processScoreEvent( "max_ammo", self );
		}

		if (event == "free_perk_grabbed_level")
		{
		    scoreevents::processScoreEvent( "free_perk", self );
		}

        WAIT_SERVER_FRAME;
	}
}

function coldwar_scoreevent_logic( death, inflictor, player, damage, flags, mod, weapon, vpoint, vdir, hit_location, psOffsetTime, boneIndex, surfaceType )
{
	if( IS_TRUE( death ) && !isDefined(self.disable_scoreevent) && IsPlayer(player) && self.team === level.zombie_team)
	{
        ckill = "_c";
		cause = "kill";
		has_cause = self should_display_cause_on_scoreevent();
		has_name = true;
		has_ckill = false;
		has_prefix = true;

        aitype = self get_ai_type() + "_";

        if( self.maxhealth < damage )
        {
            has_ckill = true;
        }
        
        if( mod == "MOD_MELEE" )
        {
			cause = "melee_kill";
        }

        if( mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_PROJECTILE" )
        {
			cause = "exp_kill";
        }

        if( mod != "MOD_MELEE" )
        {
            if ( "head" == hit_location || "helmet" == hit_location )
            {
                if(player is_using_sniper_weapon())
                {
					cause = "sniper_kill";
					has_prefix = false;
                }
                else
                {
					cause = "headshot";
                }
            }

			current_weapon = player GetCurrentWeapon();

			if( IsSubStr( current_weapon.name, "thundergun") )
			{
				cause = "thunder_kill";
				has_prefix = false;
			}

			if( IsSubStr( current_weapon.name, "ray_gun") || IsSubStr( current_weapon.name, "raygun") )
			{
				cause = "rg_kill";
				has_prefix = false;
			}

			if( IsSubStr( current_weapon.name, "raygun_mark2") )
			{
				cause = "rg2_kill";
				has_prefix = false;
			}

			if( IsSubStr( current_weapon.name, "raygun_mark3") )
			{
				cause = "rg3_kill";
				has_prefix = false;
			}

			if( IsSubStr( current_weapon.name, "tesla_gun") )
			{
				cause = "teslagun_kill";
				has_prefix = false;
			}

			if( IS_TRUE( current_weapon.isriotshield ) )
			{
				cause = "shield_kill";
				has_prefix = false;
			}
        }

		if (!has_cause)
		{
			cause = "kill";
		}

		if (has_prefix) 
		{
			if (!has_name)
			{
				aitype = "z_";
			}
		}
		else 
		{
			aitype = "";
		}

		if (!has_ckill)
		{
			ckill = "";
		}

		scoreevents::processScoreEvent( aitype + cause + ckill, player );
        self.disable_scoreevent = true;
	}
}

function coldwar_scoreevent_logic_vehicle(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
    willBeKilled = ( self.health - idamage ) <= 0;
    self thread coldwar_scoreevent_logic( willBeKilled, einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psOffsetTime, undefined, undefined );
    return idamage;
}

function should_display_cause_on_scoreevent()
{
	type = self get_ai_type();
	switch ( type )
	{
		case "z":
			return true;
			break;
		default:
			return false;
			break;
	}
}

function get_ai_type()
{
	default_type = "z";

	if(isDefined(self.model) && IsSubStr(self.model,"keeper"))
	{
		return "keeper";
	}

	if(isDefined(self.animname))
	{
		switch (self.animname) 
		{
		case "napalm_zombie":
			return "napalm_zombie" ;
			break;
		case "sonic_zombie":
			return "shrieker" ;
			break;
		}
	}

	if ( isDefined( self.str_name ) )
	{
		str_ai_name = self.str_name;
		return str_ai_name;
	}

	if (isDefined(self.archetype))
	{
		switch ( self.archetype )
		{
			case "zombie_dog":
			{
				return "hellhound" ;
				break;
			}
			case "zombie_napalm":
			{
				return "napalm_zombie" ;
				break;
			}
			case "zombie_sonic":
			{
				return "shrieker" ;
				break;
			}
			case "thrasher":
			{
				return "thrasher";
				break;
			}
			case "zombie_quad":
			{
				return "nova_crawler" ;
				break;
			}
			case "apothicon_fury":
			{
				return "apothicon_fury" ;
				break;
			}
			case "mechz":
			{
				return "panzer_soldat" ;
				break;
			}
			case "margwa":
			{
				return "margwa" ;
				break;
			}
			case "raz":
			{
				return "mangler";
				break;
			}
			case "cellbreaker":
			{
				return "brutus";
				break;
			}
			case "spider":
			{
				return "spider";
				break;
			}
			case "parasite":
			{
				return "parasite";
				break;
			}
			case "raps":
			{
				return "meatball";
				break;
			}
			case "keeper":
			{
				return "keeper";
				break;
			}
			case "sentinel_drone":
			{
				return "drone";
				break;
			}
			default:
			{
				return default_type;
				break;
			}
		}
	}

	return default_type;
}

function is_using_sniper_weapon()
{
	snipers = Array(
	"sniper",
	"barrett",
	"m82a1",
	"m40a3",
	"mosin",
	"dragnuov",
	"svd",
	"svu",
	"mors",
	"20mm",
	"lynx",
	"l118",
	"l115",
	"usr",
	"vks",
	"ebr",
	"intervention",
	"kbs",
	"dmr",
	"widowmaker",
	"proteus",
	"wa2000",
	"rsass",
	"msr",
	"as50",
	"m21",
	"25s",
	"m40a3",
	"98k",
	"type38",
	"lisle",
	"ptrs",
	"springfield",
	"karabin",
	"lever",
	"mas36",
	"wz35",
	"sdk9");
	weapon = self GetCurrentWeapon();
	foreach( sniper in snipers )
	{
		if( IsSubStr(weapon.name, sniper) || (IS_TRUE(weapon.issniperweapon)) )
		{
			return true;
		}
	}
	return false;
}