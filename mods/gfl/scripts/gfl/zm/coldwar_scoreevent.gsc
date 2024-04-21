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
		event = self util::waittill_any_return( "nuke_triggered", "perk_bought", "start_scoreevent_weapon" );

		if (event == "nuke_triggered")
		{
		    scoreevents::processScoreEvent( "nuke", self );
		}

		if (event == "perk_bought")
		{
		    scoreevents::processScoreEvent( "perk_taken", self );
		}

		if (event == "start_scoreevent_weapon")
		{
		    scoreevents::processScoreEvent( "get_weapon", self );
		}

        WAIT_SERVER_FRAME;
	}
}

function coldwar_scoreevent_logic( death, inflictor, player, damage, flags, mod, weapon, vpoint, vdir, hit_location, psOffsetTime, boneIndex, surfaceType )
{
	if( IS_TRUE( death ) && !isDefined(self.disable_scoreevent) && IsPlayer(player) && self.team === level.zombie_team)
	{
        ckill = "";
        aitype = self get_ai_type() + "_" ;
        if(aitype == "_")
        {
            aitype = "z_";
        }

        if( self.maxhealth < damage )
        {
            ckill = "_c";
        }

        if(IsSubStr( player getCurrentWeapon().name, "thundergun") )
        {
            ckill = "_c";
        }

        if(mod != "MOD_MELEE" && (IsSubStr( player getCurrentWeapon().name, "ray_gun") || IsSubStr( player getCurrentWeapon().name, "raygun")) )
        {
            scoreevents::processScoreEvent( aitype + "kill" + ckill, player);
            break;
        }
        
        if( mod == "MOD_MELEE" )
        {
            scoreevents::processScoreEvent( aitype + "melee_kill" + ckill, player);
            break;
        }

        if( mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_PROJECTILE" )
        {
            scoreevents::processScoreEvent( aitype  + "exp_kill" + ckill, player);
            break;
        }

        if( mod != "MOD_MELEE" )
        {
            if ( "head" == hit_location || "helmet" == hit_location )
            {
                if(player is_using_sniper_weapon())
                {
                    scoreevents::processScoreEvent( "sniper_kill" + ckill, player);
                }
                else
                {
                    scoreevents::processScoreEvent( aitype + "headshot" + ckill, player);
                }
            }
            else			
            {
                scoreevents::processScoreEvent( aitype + "kill" + ckill, player);
            }
        }
        
        self.disable_scoreevent = true;
	}
}

function coldwar_scoreevent_logic_vehicle(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
    willBeKilled = ( self.health - idamage ) <= 0;
    self thread coldwar_scoreevent_logic( willBeKilled, einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psOffsetTime, undefined, undefined );
    return idamage;
}

function get_ai_type()
{
	if(isDefined(self.model) && IsSubStr(self.model,"keeper"))
	{
		return "Keeper";
	}
	if(isDefined(self.animname))
	{
		switch (self.animname) 
		{
		case "napalm_zombie":
			return "Napalm_Zombie" ;
			break;
		case "sonic_zombie":
			return "Shrieker" ;
			break;
		}
	}
	if ( isDefined( self.str_name ) )
	{
		str_ai_name = self.str_name;
		return str_ai_name;
	}	
	else
	{
		if(isDefined(self.archetype))
		{
			switch ( self.archetype )
			{
				case "zombie_dog":
				{
					return "Hellhound" ;
					break;
				}
				case "zombie_napalm":
				{
					return "Napalm_Zombie" ;
					break;
				}
				case "zombie_sonic":
				{
					return "Shrieker" ;
					break;
				}
				case "thrasher":
				{
					return "Thrasher";
					break;
				}
				case "zombie_quad":
				{
					return "Nova_Crawler" ;
					break;
				}
				case "apothicon_fury":
				{
					return "Apothicon_Fury" ;
					break;
				}
				case "mechz":
				{
					return "Panzer_Soldat" ;
					break;
				}
				case "margwa":
				{
					return "Margwa" ;
					break;
				}
				case "raz":
				{
					return "Mangler";
					break;
				}
				case "cellbreaker":
				{
					return "Brutus";
					break;
				}
				case "spider":
				{
					return "Spider";
					break;
				}
				case "parasite":
				{
					return "parasite";
					break;
				}
				case "raps":
				{
					return "Meatball";
					break;
				}
				case "keeper":
				{
					return "Keeper";
					break;
				}
				case "sentinel_drone":
				{
					return "Drone";
					break;
				}
				default:
				{
					return "";
					break;
				}
			}
		}
	}
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