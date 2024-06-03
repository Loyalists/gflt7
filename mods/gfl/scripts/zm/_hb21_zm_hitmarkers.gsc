#using scripts\codescripts\struct;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_spawner;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace hb21_zm_hitmarkers;

REGISTER_SYSTEM_EX( "hb21_zm_hitmarkers", &__init__, &__main__, undefined )

//*****************************************************************************
// MAIN
//*****************************************************************************

function __init__()
{
    if( !GetDvarInt("tfoption_hitmarkers", 0) ) 
	{
		return;
    }

	zm::register_zombie_damage_override_callback( &zombie_damage_event );
	zm_spawner::register_zombie_death_event_callback( &zombie_death_event );
}

function __main__()
{
    if( !GetDvarInt("tfoption_hitmarkers", 0) ) 
	{
		return;
    }
	
	level.allowHitMarkers = true; // TO ENABLE / DISABLE THE HITMARKERS TOTALLY
	level.growing_hitmarker = true; // REQUIRED DESPITE THE LATER MENTIONED HARDCODED PLAYER CHECK
}

function zombie_damage_event( willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType )
{
	if ( isDefined( attacker ) && isPlayer( attacker ) && !willBeKilled && !IS_TRUE( self.noHitMarkers ) )
	{
		attacker thread damagefeedback::update( meansofdeath, inflictor, undefined, weapon );
		attacker damagefeedback::damage_feedback_growth( self, meansofdeath, weapon ); // THERES A HARD CODED CHECK FOR THE VICTIM BEING A PLAYER RATHER THAN AN AI - SO MANUALLY CALL THIS AFTER
	}
	return;
}

function zombie_death_event( e_player )
{
	if ( isDefined( e_player ) && isPlayer( e_player ) && !IS_TRUE( self.noHitMarkers ) )
	{
		e_player thread damagefeedback::update( self.damagemod, self.damageinflictor, undefined, self.damageweapon );
		e_player damagefeedback::damage_feedback_growth( self, self.damagemod, self.damageweapon ); // THERES A HARD CODED CHECK FOR THE VICTIM BEING A PLAYER RATHER THAN AN AI - SO MANUALLY CALL THIS AFTER
	}
}