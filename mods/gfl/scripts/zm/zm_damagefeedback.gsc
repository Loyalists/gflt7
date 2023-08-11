#using scripts\zm\_zm_spawner; 

// Created by Vertasea
// Thanks to Treyarch/activision

/* =============== ZOMBIE MODE HITMARKERS =============== */
function init_hitmarkers()
{
	zm_spawner::register_zombie_damage_callback(&monitor_damage); 
	zm_spawner::register_zombie_death_event_callback(&update_damage_feedback);
}

function monitor_damage(mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
	if (!isdefined(player))
	{
		return false; 
	}

	player PlayLocalSound("v7_mpl_hit_alert");
	size_x = 24;
	size_y = size_x * 2;
	if( !isdefined(player.hud_damagefeedback) )
	{
		player.hud_damagefeedback = newdamageindicatorhudelem(player);
		player.hud_damagefeedback.horzAlign = "center";
		player.hud_damagefeedback.vertAlign = "middle";
		player.hud_damagefeedback.x = -11;
		player.hud_damagefeedback.y = -11;
		player.hud_damagefeedback.alpha = 0;
		player.hud_damagefeedback.archived = true;
		player.hud_damagefeedback setShader( "damage_feedback", size_x, size_y );
	}

	if( isdefined(player.hud_damagefeedback) )
	{
		player.hud_damagefeedback SetShader( "damage_feedback", size_x, size_y );
		player.hud_damagefeedback.alpha = 1; 
		player.hud_damagefeedback fadeOverTime(1);
		player.hud_damagefeedback.alpha = 0; 
	}
	return false; 
}

function update_damage_feedback(player)
{
	if (!isdefined(player))
	{
		return false; 
	}

	player PlayLocalSound("v7_mpl_hit_alert");
	size_x = 24;
	size_y = size_x * 2;
	if(!isdefined(player.hud_damagefeedback_additional))
	{
		player.hud_damagefeedback_additional = newdamageindicatorhudelem(player);
		player.hud_damagefeedback_additional.horzAlign = "center";
		player.hud_damagefeedback_additional.vertAlign = "middle";
		player.hud_damagefeedback_additional.x = -12;
		player.hud_damagefeedback_additional.y = -12;
		player.hud_damagefeedback_additional.alpha = 0;
		player.hud_damagefeedback_additional.archived = true;
		player.hud_damagefeedback_additional setShader( "damage_feedback_glow_orange", size_x, size_y );
	}

	if( isdefined(player.hud_damagefeedback_additional) )
	{
		player.hud_damagefeedback_additional SetShader( "damage_feedback_glow_orange", size_x, size_y );
		player.hud_damagefeedback_additional.alpha = 1; 
		player.hud_damagefeedback_additional fadeOverTime(1);
		player.hud_damagefeedback_additional.alpha = 0; 
	}
	return false; 
}