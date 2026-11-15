// GFL adapter: HB21 callback/sound handling with AAE hit categories.
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\shared\math_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace elmg_hitmarker;

REGISTER_SYSTEM_EX( "elmg_hitmarker", &__init__, &__main__, undefined )

//*****************************************************************************
// MAIN
//*****************************************************************************

function __init__()
{
	zm::register_zombie_damage_override_callback( &zombie_damage_event );
	zm::register_vehicle_damage_callback( &vehicle_damage_event );
}

function __main__()
{
	level.allowHitMarkers = true;
	level.growing_hitmarker = false;
}

function is_enabled()
{
    if( GetDvarInt("tfoption_hitmarkers", 0) )
    {
        return true;
    }

	return false;
}

function zombie_damage_event( willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType )
{
	if ( !isDefined( attacker ) || !isPlayer( attacker ) )
	{
		return;
	}

	if ( !is_enabled() || damage <= 0 )
	{
		return;
	}
	
	team = self GetTeam();
	if( !isdefined(team) || team != "axis" )
	{
		return;
	}

	if ( !IS_TRUE( self.noHitMarkers ) && !IS_TRUE( self.disablehitmarkers ) )
	{
		if ( IS_TRUE( self.dont_die_on_me ) )
			willBeKilled = false;
		attacker update( willBeKilled, meansofdeath, inflictor, weapon, self, psOffsetTime, sHitLoc );
	}
	return;
}

function vehicle_damage_event( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if ( !isDefined( eAttacker ) || !isPlayer( eAttacker ) )
	{
		return iDamage;
	}

	if ( !is_enabled() )
	{
		return iDamage;
	}
	
	team = self GetTeam();
	if( !isdefined(team) || team != "axis" )
	{
		return iDamage;
	}

	if ( iDamage <= 0 )
		return iDamage;
	if ( self IsVehicleImmuneToDamage( iDFlags, sMeansOfDeath, weapon ) )
		return iDamage;

	willBeKilled = ( self.health - iDamage ) <= 0;
	if ( !IS_TRUE( self.noHitMarkers ) && !IS_TRUE( self.disablehitmarkers ) )
	{
		eAttacker update( willBeKilled, sMeansOfDeath, eInflictor, weapon, self, psOffsetTime, sHitLoc );
	}
	return iDamage;
}

function get_hitmarkers_sound( death, is_headshot )
{
	dvar = GetDvarInt("tfoption_hitmarkers_sound", 0);

	hitAlias = "mpl_hit_alert";
	switch( dvar )
	{
		case 1:
			hitAlias = "iw3_hitmarkers";
			break;
		case 2:
			hitAlias = "iw8_hitmarkers";
			if ( IS_TRUE(death) )
			{
				if ( IS_TRUE(is_headshot) && math::cointoss() )
				{
					hitAlias = "iw8_hitmarkers_headshot_kill";
				}
				else
				{
					hitAlias = "iw8_hitmarkers_kill";
				}
			}
			break;
		case 3:
			hitAlias = "s5_hitmarkers";
			if ( IS_TRUE(death) )
			{
				if ( IS_TRUE(is_headshot) )
				{
					hitAlias = "s5_hitmarkers_headshot_kill";
				}
				else
				{
					hitAlias = "s5_hitmarkers_kill";
				}
			}
			break;
		default:
			break;
	}

	return hitAlias;
}

function update( death, mod, inflictor, weapon, victim, psOffsetTime, sHitLoc )
{
	if ( !isPlayer( self ) )
		return;
	if ( IS_TRUE(self.noHitMarkers) )
		return false;

	if (isDefined(weapon) && IS_TRUE(weapon.nohitmarker) )
		return;
	
	if ( !isDefined( self.lastHitMarkerTime ) )
	{
		self.lastHitMarkerTimes = [];
		self.lastHitMarkerTime = -1;
		self.lastHitMarkerOffsetTime = 0;
	}	
	
	if ( isdefined( psOffsetTime ) && isdefined( victim ) )
	{
		victim_id = victim GetEntityNumber();
		
		if ( self.lastHitMarkerTime != GetTime() )
			self.lastHitMarkerTimes = [];
		if ( isdefined( self.lastHitMarkerTimes[ victim_id ] ) && self.lastHitMarkerTimes[ victim_id ] === psOffsetTime )
			return;
		self.lastHitMarkerOffsetTime = psOffsetTime;
		self.lastHitMarkerTimes[ victim_id ] = psOffsetTime;
	}
	else
	{
		if ( self.lastHitMarkerTime == GetTime() )
			return;
	}
		
	self.lastHitMarkerTime = GetTime();
	hitAlias = undefined;
	
	if ( damagefeedback::should_play_sound( mod ) )
	{	
		hitAlias = "mpl_hit_alert";
	}
	
	perkFeedback = undefined;
	is_headshot = false;
	if ( isdefined( weapon ) )
		is_headshot = zm_utility::is_headshot( weapon, sHitLoc, mod );
	custom_sound = get_hitmarkers_sound(death, is_headshot);
	if ( custom_sound != "mpl_hit_alert" )
	{
		hitAlias = custom_sound;
	}

	damageStage = 1;
	if ( is_headshot )
		damageStage = 2;
	if ( is_splash( mod, weapon ) )
		damageStage = 3;
	self PlayHitMarker( hitAlias, damageStage, perkFeedback, IS_TRUE( death ) );

	if ( isdefined( self.hud_damagefeedback ) )
		self.hud_damagefeedback.alpha = 0;
}

function is_splash( mod, weapon )
{
	switch ( mod )
	{
		case "MOD_PROJECTILE_SPLASH":
		case "MOD_GRENADE_SPLASH":
		case "MOD_GAS":
		case "MOD_HIT_BY_OBJECT":
		case "MOD_FALLING":
		case "MOD_CRUSH":
		case "MOD_SUICIDE":
		case "MOD_DROWN":
			return true;
	}
	return isdefined( weapon ) && ( weapon.name == "hero_gravityspikes_melee" || weapon.name == "octobomb" || weapon.name == "octobomb_upgraded" );
}
