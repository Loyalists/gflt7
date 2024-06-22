#using scripts\zm\_zm;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\callbacks_shared;

#using scripts\gfl\clientsystem;

#insert scripts\shared\shared.gsh;

#namespace aae_zombie_health_bar;

#precache( "eventstring", "aae_zombie_health" );

REGISTER_SYSTEM_EX( "aae_zombie_health_bar", &__init__, &__main__, undefined )

function private __init__()
{
    health_bar_init();
}

function private __main__()
{
	thread level_zombie_heath_notify();
	thread wait_for_option_changed();
}

function health_bar_init()
{
    zm::register_zombie_damage_override_callback( &update_zombie_health );
	zm::register_vehicle_damage_callback(&update_zombie_vehicle);
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");

	healthbar_dvar = GetDvarInt("tfoption_zombie_healthbar", 0);
	self clientsystem::set_clientdvar("tfoption_zombie_healthbar", healthbar_dvar);
}

function wait_for_option_changed()
{
	level endon("game_ended");
	level endon("end_game");
	level flag::wait_till("initial_blackscreen_passed");
	
    while (true)
    {
		healthbar_dvar = GetDvarInt("tfoption_zombie_healthbar", 0);
		foreach ( player in GetPlayers() )
		{
			player clientsystem::set_clientdvar("tfoption_zombie_healthbar", healthbar_dvar);
		}

        WAIT_SERVER_FRAME;
        level util::waittill_any_return("tfoption_zombie_healthbar_changed");
    }
}

function is_enabled()
{
    if( GetDvarInt("tfoption_zombie_healthbar", 0) )
    {
        return true;
    }

	return false;
}

function level_zombie_heath_notify()
{
	level endon("end_game");
	level flag::wait_till("initial_blackscreen_passed");
	
	while(1)
	{
		level waittill( "aae_zombie_health_bar" , zombie , damage_func , entitynumber , boneindex , headshot);

		if( !is_enabled() )
		{
			continue;
		}

		if(isDefined(zombie) && isDefined(damage_func) && isDefined(entitynumber) && isDefined(boneindex))
		{
			damage_value = zombie [[damage_func]](boneindex);
			if(damage_value)
			{
				LUINotifyEvent( &"aae_zombie_health", 3, damage_value , entitynumber , headshot);
			}
		}
		else
		{
			if( isDefined(headshot) && isDefined(entitynumber) && headshot == 1 )
			{
				LUINotifyEvent( &"aae_zombie_health", 2, entitynumber , headshot);
			}
		}
	}
}

function mechz_health(boneindex)
{
	return int((self.health / level.mechz_health) * 100);
}

function margwa_health(boneindex)
{
	partname = getpartname(self.model, boneindex);
    modelhit = self margwaheadhit(self, partname);
    if(isDefined(modelhit))
    {
        headinfo = self.head[modelhit];
        if(headinfo margwacandamagehead())
		{
			return int((self get_margwa_health() / self get_margwa_maxhealth()) * 100);
		}
    }
	return 0;
}

function zombie_health(boneindex)
{
	return int((self.health / self.maxhealth) * 100);
}

function update_zombie_health( death, inflictor, player, damage, flags, mod, weapon, vpoint, vdir, hit_location, psOffsetTime, boneIndex, surfaceType )
{
    if( !is_enabled() )
    {
        return;
    }

    if(isDefined(death) && death)
    {
		if( hit_location == "helmet" || hit_location == "head")
		{
			level notify( "aae_zombie_health_bar" , undefined , undefined , self GetEntityNumber() , undefined , 1 );
		}
	}
    else
    {
		headshot = 0;
		if( hit_location == "helmet" || hit_location == "head")
		{
			headshot = 1;
		}
		if(isDefined(self.archetype))
		{
		if(self.archetype == "mechz")
		{
			if(isDefined(level.mechz_health))
			{
				level notify( "aae_zombie_health_bar" , self , &mechz_health , self GetEntityNumber() , boneindex , headshot);
			}
		}
		else
		{
			if(self.archetype == "margwa")
			{
				level notify( "aae_zombie_health_bar" , self , &margwa_health , self GetEntityNumber() , boneindex , headshot);
			}
			else
			{
				level notify( "aae_zombie_health_bar" , self , &zombie_health , self GetEntityNumber() , boneindex , headshot);
			}
		}
		}
    }
}

function margwacandamagehead()
{
	if(isdefined(self) && self.health > 0 && (isdefined(self.candamage) && self.candamage))
	{
		return true;
	}
	return false;
}

function margwaheadhit(entity, partname)
{
	switch(partname)
	{
		case "j_chunk_head_bone_le":
		case "j_jaw_lower_1_le":
		{
			return self.head_left_model;
		}
		case "j_chunk_head_bone":
		case "j_jaw_lower_1":
		{
			return self.head_mid_model;
		}
		case "j_chunk_head_bone_ri":
		case "j_jaw_lower_1_ri":
		{
			return self.head_right_model;
		}
	}
	return undefined;
}

function update_zombie_vehicle(einflictor, player, damage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)	
{
    if( !is_enabled() )
    {
        return;
    }

    death = ( self.health - damage ) <= 0;
    
    if(isDefined(death) && death)
    {
		if( shitloc == "helmet" || shitloc == "head")
		{
			level notify( "aae_zombie_health_bar" , undefined , undefined , self GetEntityNumber() , undefined , 1 );
		}
	}
    else
    {
		headshot = 0;
		if( shitloc == "helmet" || shitloc == "head")
		{
			headshot = 1;
		}
        if(IsSubStr(self.vehicletype,"nikolai") && self.team == "axis" && isDefined(self.healthdefault))
        {
			level notify( "aae_zombie_health_bar" , self , &nikolai_vehicle_damage_func , self GetEntityNumber() , modelindex , headshot);
        }
        else
        {
			level notify( "aae_zombie_health_bar" , self , &default_vehicle_damage_func , self GetEntityNumber() , modelindex , headshot);
        } 
    }
    return damage;
}

function nikolai_vehicle_damage_func(boneindex)
{
	return int((self.health / self.healthdefault) * 100);
}

function default_vehicle_damage_func(boneindex)
{
	return int((self.health / self.maxhealth) * 100);
}

function get_margwa_maxhealth()
{
    if(isDefined(self.headhealthmax) && isDefined(self.head))
    {
        margwa_health = 0;
        foreach(head in self.head)
        {
            margwa_health += self.headhealthmax;
        }
        return margwa_health;
    }
    return 0;
}

function get_margwa_health()
{
    if(isDefined(self.headhealthmax) && isDefined(self.head))
    {
        margwa_health = 0;
        foreach(head in self.head)
        {
            margwa_health += head.health;
        }
        return margwa_health;
    }
    return 0;
}

function check_nikolai_can_hit(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(!isplayer(eattacker))
	{
		return false;
	}
	if(level flag::get("world_is_paused"))
	{
		return false;
	}
	if(smeansofdeath === "MOD_MELEE")
	{
		return false;
	}
	var_7e43f478 = strtok(partname, "_");
	if(var_7e43f478[1] == "heat" && var_7e43f478[2] == "vent")
	{
		n_index = int(var_7e43f478[3]);
		if(self.var_65850094[n_index] <= 0)
		{
			return false;
		}
	}
	else
	{
		return false;
	}
	str_partname = partname;
	switch(n_index)
	{
		case 1:
		{
			str_partname = "tag_heat_vent_01_d0";
			break;
		}
		case 2:
		{
			str_partname = "tag_heat_vent_02_d0";
			break;
		}
		case 4:
		{
			break;
		}
		case 3:
		{
			break;
		}
		case 5:
		{
			str_partname = "tag_heat_vent_05_d1";
			break;
		}
		default:
		{
			return false;
		}
	}
	if(n_index == 5 && function_86cc3c11() < 4)
	{
		return false;
	}
    return true;
}

function function_86cc3c11()
{
	count = 0;
	for(i = 1; i < 5; i++)
	{
		if(self.var_65850094[i] <= 0)
		{
			count++;
		}
	}
	return count;
}