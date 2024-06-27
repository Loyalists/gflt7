#using scripts\codescripts\struct;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\shared\math_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace hb21_zm_hitmarkers;

REGISTER_SYSTEM_EX( "hb21_zm_hitmarkers", &__init__, &__main__, undefined )

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
	level.allowHitMarkers = true; // TO ENABLE / DISABLE THE HITMARKERS TOTALLY
	level.growing_hitmarker = true; // REQUIRED DESPITE THE LATER MENTIONED HARDCODED PLAYER CHECK
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

	if ( !is_enabled() )
	{
		return;
	}
	
	team = self GetTeam();
	if( !isdefined(team) || team != "axis" )
	{
		return;
	}

	if ( !IS_TRUE( self.noHitMarkers ) )
	{
		attacker thread update( willBeKilled, meansofdeath, inflictor, weapon, undefined, undefined, sHitLoc );
		attacker damagefeedback::damage_feedback_growth( self, meansofdeath, weapon ); // THERES A HARD CODED CHECK FOR THE VICTIM BEING A PLAYER RATHER THAN AN AI - SO MANUALLY CALL THIS AFTER
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

	willBeKilled = ( self.health - iDamage ) <= 0;
	if ( !IS_TRUE( self.noHitMarkers ) )
	{
		eAttacker thread update( willBeKilled, sMeansOfDeath, eInflictor, weapon, undefined, undefined, sHitLoc );
		eAttacker damagefeedback::damage_feedback_growth( self, sMeansOfDeath, weapon ); // THERES A HARD CODED CHECK FOR THE VICTIM BEING A PLAYER RATHER THAN AN AI - SO MANUALLY CALL THIS AFTER
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
		self.lastHitMarkerTime = 0;
		self.lastHitMarkerOffsetTime = 0;
	}	
	
	if ( isdefined( psOffsetTime ) )
	{
		victim_id = victim GetEntityNumber();
		
		if ( !IsDefined( self.lastHitMarkerTimes[ victim_id ] ) )
		{
			self.lastHitMarkerTimes[ victim_id ] = 0;
		}
	
		if ( self.lastHitMarkerTime == GetTime() )
		{
			if ( self.lastHitMarkerTimes[ victim_id ] === psOffsetTime )
				return;	
		}
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
		if ( isdefined( victim ) && isdefined( victim.victimSoundMod ) )
		{
			switch( victim.victimSoundMod )
			{
				default:
					hitAlias = "mpl_hit_alert";
					break;
			}
		}
		else if ( isdefined( inflictor ) && isdefined( inflictor.soundMod ))
		{
			//Add sound stuff here for specific inflictor types	
			switch ( inflictor.soundMod )
			{
				case "player":
					if ( mod == "MOD_BURNED" )
					{
						hitAlias = "mpl_hit_alert_burn";
					}
					else
					{
						hitAlias = "mpl_hit_alert";
					}
					break;	
					
				case "heatwave":
					hitAlias = "mpl_hit_alert_heatwave";
					break;
										
				case "default_loud":
					hitAlias = "mpl_hit_heli_gunner";
					break;						
				
				default:
					hitAlias = "mpl_hit_alert";
					break;
			}
		}
		else if ( mod == "MOD_BURNED" )
		{
			hitAlias = "mpl_hit_alert_burn";
		}
		else
		{
			hitAlias = "mpl_hit_alert";
		}
	}
	
	perkFeedback = undefined;
	is_headshot = zm_utility::is_headshot( weapon, sHitLoc, mod );
	custom_sound = get_hitmarkers_sound(death, is_headshot);
	if ( custom_sound != "mpl_hit_alert" )
	{
		hitAlias = custom_sound;
	}

	if( isdefined( victim ) && IS_TRUE( victim.isAiClone ) )
	{
		self PlayHitMarker( hitAlias );
		return;
	}
	
	damageStage = 1; // always show at least stage 1 hit marker, per design
	if ( isdefined(level.growing_hitmarker) && isdefined(victim) && isplayer(victim) )
	{
		damageStage = damagefeedback::damage_feedback_get_stage( victim );
	}
	self PlayHitMarker( hitAlias, damageStage, perkFeedback, damagefeedback::damage_feedback_get_dead( victim, mod, weapon, damageStage ) );
	
	if (isDefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback setShader( "damage_feedback", 24, 48 );
	}
	
	if (isDefined(self.hud_damagefeedback) && isdefined(level.growing_hitmarker) && isdefined(victim) && isplayer(victim) )
	{
		self thread damagefeedback::damage_feedback_growth(victim, mod, weapon);
	}
	else if ( isDefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback.x = -12;
		self.hud_damagefeedback.y = -12;
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}