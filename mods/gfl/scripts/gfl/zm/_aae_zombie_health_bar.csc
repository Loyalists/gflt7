#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;

#namespace aae_zombie_health_bar;

REGISTER_SYSTEM_EX( "aae_zombie_health_bar", &__init__, &__main__, undefined )

function private __init__()
{
    ai::add_ai_spawn_function( &zombie_health_bar_spawn );
	callback::on_localplayer_spawned(&check_near_zombie);
	// callback::on_localplayer_spawned(&clear_health_bar);
}

function private __main__()
{

}

function clear_health_bar(localClientNum)
{
    controllerModel = GetUIModelForController( localClientNum );
	for (i = 24; i < 130; i++) 
	{
		health_bar_model = GetUIModel( controllerModel, "AAE_ZombieHealthModel_" + i );
		zombie_health_bar_visibility_model = GetUIModel(health_bar_model , "visibility");
		if(isDefined(zombie_health_bar_visibility_model))
		{
			SetUIModelValue( zombie_health_bar_visibility_model, 2 );
		}
	}
}

function check_near_zombie(localClientNum)
{    
	if(self != GetLocalPlayer(localClientNum)  )
    {
        return;
    }
    self thread set_zombie_nearby();
}

function set_zombie_nearby()
{
	self notify("aae_zombie_nearby");
	self endon("aae_zombie_nearby");
    self endon("entityshutdown");
    self endon("disconnect");

	while(1)
	{
		if(isDefined(level.elmg_enemies) && level.elmg_enemies.size)
		{
			zombie = self get_zombie_that_player_sees();
			if(isDefined(zombie))
			{
				self._nearby_zombie = zombie GetEntityNumber();
			}
			else
			{
				self._nearby_zombie = undefined;
			}
		}
		else
		{
			self._nearby_zombie = undefined;
		}
		WAIT_CLIENT_FRAME;
	}
}

function get_zombie_that_player_sees()
{
    if(!isDefined(level.elmg_enemies))
    {
		return undefined;
	}

	player_cam = self GetCamPos();
	player_angles = self GetCamAngles();
	new_zombies = [];
	foreach(zombie in level.elmg_enemies)
	{
		if(Distance(zombie.origin, player_cam) <= 400 && !(isDefined(self.vehicletype) && self.vehicletype == "flinger_vehicle"))
		{
			zombie_fov_passed = util::within_fov( player_cam, player_angles , zombie.origin, cos( 50 ) );
			if(zombie_fov_passed)
			{
				trace = BulletTrace(player_cam, zombie.origin, 1, self, 1);
				if(Distance(trace["position"], zombie.origin) < 12)
				{
					new_zombies[new_zombies.size] = zombie;
				}
			}
		}
	}

	return ArrayGetClosest(player_cam,new_zombies,250);
}

function zombie_health_bar_spawn( localClientNum )
{
    if( !isdefined(self) ) 
    {
		return;
	}

    if( !isdefined(self.team) ) 
    {
		return;
	}

    if( !GetDvarInt("tfoption_zombie_healthbar", 0) )
    {
        return;
    }

	if(self.team != "axis")
	{
		if(isDefined(self.vehicletype) )
		{
			if(self.vehicletype == "veh_bo3_dlc_mil_b17_bomber")
			{
				
			}
			
			if(self.vehicletype == "spawner_enemy_boss_vehicle_siegebot_nikolai_dragon" || self.vehicletype == "spawner_enemy_boss_vehicle_siegebot_nikolai")
			{
				while(self.team != "axis")
				{
					WAIT_CLIENT_FRAME;
				}
			}
		}
		else
		{
			return;
		}
	}

	enittynumber = int(self GetEntityNumber());
	level notify("zombie_health_bar_spawn" + enittynumber + localClientNum);
	level endon("zombie_health_bar_spawn" + enittynumber + localClientNum);
	waitrealtime(1);

	controllerModel = GetUIModelForController( localClientNum );
	zombie_health_bar_progress_model = CreateUIModel(CreateUIModel( controllerModel, "AAE_ZombieHealthModel_" + enittynumber ) , "progress");
	zombie_health_bar_ai_icon_model = CreateUIModel(CreateUIModel( controllerModel, "AAE_ZombieHealthModel_" + enittynumber ) , "ai_icon");
	zombie_health_bar_position_model = CreateUIModel(CreateUIModel( controllerModel, "AAE_ZombieHealthModel_" + enittynumber ) , "position");
	zombie_health_bar_visibility_model = CreateUIModel(CreateUIModel( controllerModel, "AAE_ZombieHealthModel_" + enittynumber ) , "visibility");
	zombie_health_bar_name_model = CreateUIModel(CreateUIModel( controllerModel, "AAE_ZombieHealthModel_" + enittynumber ) , "ai_name");
	spawn_healthbar_model = GetUIModel( controllerModel, "hudItems.spawn_actor_healthbar" );

	SetUIModelValue( zombie_health_bar_progress_model, 1 );
	SetUIModelValue( zombie_health_bar_ai_icon_model, self get_ai_icon() );
	SetUIModelValue( zombie_health_bar_name_model, self get_ai_name() );
	SetUIModelValue( spawn_healthbar_model, enittynumber );

	while(isDefined(self) && isAlive(self)) 
	{
		WAIT_CLIENT_FRAME;
		if(isDefined(self.team))
		{
			if(self.team != "axis")
			{
				if(isDefined(self.vehicletype) && (self.vehicletype == "veh_bo3_dlc_mil_b17_bomber" || self.vehicletype == "spawner_enemy_boss_vehicle_siegebot_nikolai_dragon" || self.vehicletype == "spawner_enemy_boss_vehicle_siegebot_nikolai") )
				{

				}
				else
				{
					SetUIModelValue( zombie_health_bar_visibility_model, 2 );
					return;
				}
			}
		}
		zombie_visable = self bulletTracePassed(localClientNum);
		if(zombie_visable)
		{
			origin = self get_origin();
			SetUIModelValue( zombie_health_bar_position_model, "" + origin[0] + "," + origin[1] + "," + origin[2]  );
			SetUIModelValue( zombie_health_bar_visibility_model, 1 );
		}
		else
		{
			SetUIModelValue( zombie_health_bar_visibility_model, 0 );
		}
	}
	SetUIModelValue( zombie_health_bar_progress_model, 0 );
	waitrealtime(0.2);
	SetUIModelValue( zombie_health_bar_visibility_model, 2 );
}

function get_origin()
{
    if(isDefined(self.vehicletype) && self.vehicletype != "")
    {
        if(self.vehicletype == "spawner_enemy_boss_vehicle_siegebot_nikolai_dragon" || self.vehicletype == "spawner_enemy_boss_vehicle_siegebot_nikolai")
        {
            return self GetTagOrigin("tag_eye") + (0,0,50);
        }
        return self.origin + (0 , 0 , 50);
    }
	origin5 = self GetTagOrigin("j_head");
	if(isDefined(origin5) && isDefined(origin5[0])&& isDefined(origin5[1])&& isDefined(origin5[1]) && origin5 != (0,0,0))
	{
		return origin5 + (0,0,10);
	}
	origin3 = self GetEye();
	if(isDefined(origin3) && isDefined(origin3[0])&& isDefined(origin3[1])&& isDefined(origin3[1]) && origin3 != (0,0,0))
	{
		return origin3 + (0,0,10);
	}
	return self.origin;
}

function bulletTracePassed( localClientNum )
{
	if(isDefined(self.vehicletype) && self.vehicletype == "flinger_vehicle")
	{
		return 0;
	}
    if(isDefined(self.vehicletype) && (self.vehicletype == "veh_bo3_dlc_mil_b17_bomber" || self.vehicletype == "spawner_enemy_boss_vehicle_siegebot_nikolai_dragon" || self.vehicletype == "spawner_enemy_boss_vehicle_siegebot_nikolai") )
    {
        return 1;
    }
	player = GetLocalPlayer(localClientNum);
	if(isDefined(player._nearby_zombie) && player._nearby_zombie == self GetEntityNumber())
	{
		return 1;
	}
	camera_pos = GetLocalClientEyePos(localClientNum);
	v_trace = bulletTrace( camera_pos, camera_pos + AnglesToForward(GetCamAnglesByLocalClientNum(localclientnum)) * 1000, true , player ,true);
    if(isdefined(v_trace["entity"]) && v_trace["entity"] GetEntityNumber() == self GetEntityNumber())
    {
        return 1;
    }
	return 0;
}

function get_ai_icon()
{
    str_ai_icon = "none";

    if(isDefined(self.model))
    {
        if(IsSubStr(self.model,"george"))
        {
			return "uie_ui_icon_minimap_zm_ai_boss";
        }

        if(IsSubStr(self.model,"keeper"))
        {
			return "uie_ui_icon_minimap_zm_ai_special";
        }

        if(IsSubStr(self.model,"sonic"))
        {
            return "uie_ui_icon_minimap_zm_ai_elite";
        }

        if(IsSubStr(self.model,"napalm"))
        {
            return "uie_ui_icon_minimap_zm_ai_elite";
        }

        if(IsSubStr(self.model,"brutus"))
        {
            return "uie_ui_icon_minimap_zm_ai_elite";
        }

        if(IsSubStr(self.model,"warden"))
        {
            return "uie_ui_icon_minimap_zm_ai_elite";
        }
    }

	if ( isDefined( self.vehicletype ) )
	{
		switch ( self.vehicletype )
		{
			case "spawner_bo3_parasite_enemy_tool":
			{
				break;
			}
			case "spawner_bo3_parasite_elite_enemy_tool":
			{
				break;
			}
			case "spawner_enemy_zombie_vehicle_raps_suicide":
			{
				break;
			}
			case "spawner_bo3_spider_enemy":
			{
				break;
			}
			case "spawner_bo3_spider_enemy_red":
			{
				break;
			}
			case "spawner_bo3_spider_friendly":
			{
				break;
			}
			case "spawner_enemy_boss_vehicle_siegebot_nikolai_dragon":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_boss";
				break;
			}
			case "spawner_enemy_boss_vehicle_siegebot_nikolai":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_boss";
				break;
			}
			case "spawner_zm_dlc3_vehicle_raps_nikolai":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_boss";
				break;
			}
			case "veh_bo3_dlc_mil_b17_bomber":
			{
				break;
			}
			case "spawner_bo3_dlc_sentinel_drone":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_special";
				break;
			}
		}
	}
	else
	{
		switch ( self.archetype )
		{
			case "zombie":
			{
				break;
			}
			case "monkey":
			{
				break;
			}
			case "zombie_dog":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_normal";
				break;
			}
			case "zombie_napalm":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_elite";
				break;
			}
			case "astronaut":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_elite";
				break;
			}
			case "zombie_sonic":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_elite";
				break;
			}
			case "thrasher":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_elite";
				break;
			}
			case "zombie_quad":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_normal";
				break;
			}
			case "apothicon_fury":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_special";
				break;
			}
			case "mechz":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_boss";
				break;
			}
			case "margwa":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_boss";
				break;
			}
			case "raz":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_elite";
				break;
			}
			case "cellbreaker":
			{
				str_ai_icon = "uie_ui_icon_minimap_zm_ai_elite";
				break;
			}
		}
	}

    return str_ai_icon;
}

function get_ai_name()
{
    str_ai_name = "MENU_ENEMY";

    if(isDefined(self.model))
    {
        if(IsSubStr(self.model,"george"))
        {
            return "George A. Romero";
        }

        if(IsSubStr(self.model,"keeper"))
        {
            return "Keeper";
        }

        if(IsSubStr(self.model,"sonic"))
        {
            return "Shrieker";
        }

        if(IsSubStr(self.model,"napalm"))
        {
            return "Napalm Zombie";
        }

        if(IsSubStr(self.model,"monkey"))
        {
            return "Monkey";
        }

        if(IsSubStr(self.model,"brutus"))
        {
            return "Brutus";
        }

        if(IsSubStr(self.model,"warden"))
        {
            return "Brutus";
        }

        if(IsSubStr(self.model,"gfl_"))
        {
            return "MENU_ENEMY";
        }
    }

    if ( isDefined( self.str_name ) )
	{
		str_ai_name = self.str_name;
		return str_ai_name;
	}

	if ( isDefined( self.vehicletype ) )
	{
		switch ( self.vehicletype )
		{
			case "spawner_bo3_parasite_enemy_tool":
			{
				str_ai_name =  "Parasite";
				break;
			}
			case "spawner_bo3_parasite_elite_enemy_tool":
			{
				str_ai_name =  "Parasite";
				break;
			}
			case "spawner_enemy_zombie_vehicle_raps_suicide":
			{
				str_ai_name =  "Meatball";
				break;
			}
			case "spawner_bo3_spider_enemy":
			{
				str_ai_name =  "MENU_PLAYER_EMBLEM_8";
				break;
			}
			case "spawner_bo3_spider_enemy_red":
			{
				str_ai_name =  "MENU_PLAYER_EMBLEM_8";
				break;
			}
			case "spawner_bo3_spider_friendly":
			{
				str_ai_name =  "MENU_PLAYER_EMBLEM_8";
				break;
			}
			case "spawner_enemy_boss_vehicle_siegebot_nikolai_dragon":
			{
				str_ai_name =  "AK-12";
				break;
			}
			case "spawner_enemy_boss_vehicle_siegebot_nikolai":
			{
				str_ai_name =  "AK-12";
				break;
			}
			case "spawner_zm_dlc3_vehicle_raps_nikolai":
			{
				str_ai_name =  "KILLSTREAK_RAPS";
				break;
			}
			case "veh_bo3_dlc_mil_b17_bomber":
			{
				str_ai_name =  "Bomber";
				break;
			}
			case "spawner_bo3_dlc_sentinel_drone":
			{
				str_ai_name =  "Drone";
				break;
			}
		}
	}
	else
	{
		switch ( self.archetype )
		{
			case "zombie":
			{
				str_ai_name =  "EM_ZOMBIE01";
				break;
			}
			case "monkey":
			{
				str_ai_name =  "Monkey";
				break;
			}
			case "zombie_dog":
			{
				str_ai_name =  "WEAPON_PISTOL_REVOLVER_UPGRADED";
				break;
			}
			case "zombie_napalm":
			{
				str_ai_name =  "Napalm Zombie";
				break;
			}
			case "astronaut":
			{
				str_ai_name =  "Astronaut";
				break;
			}
			case "zombie_sonic":
			{
				str_ai_name =  "Shrieker";
				break;
			}
			case "thrasher":
			{
				str_ai_name =  "Thrasher";
				break;
			}
			case "zombie_quad":
			{
				str_ai_name =  "Nova Crawler";
				break;
			}
			case "apothicon_fury":
			{
				str_ai_name =  "Apothicon Fury";
				break;
			}
			case "mechz":
			{
				str_ai_name =  "Panzer";
				break;
			}
			case "margwa":
			{
				str_ai_name =  "Margwa";
				break;
			}
			case "raz":
			{
				str_ai_name =  "Mangler";
				break;
			}
			case "cellbreaker":
			{
				str_ai_name =  "Brutus";
				break;
			}
		}
	}

    return str_ai_name;
}