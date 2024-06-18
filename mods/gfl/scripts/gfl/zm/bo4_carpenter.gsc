//
//BO4 STYLE CARPENTER v1.0: REPAIRS SHIELD ON GRAB
//CREATED BY FROST ICEFORGE
//ADDITIONAL CREDIT TO MADGAZ FOR CRUSADER ALE SCRIPTS WHICH I MODIFIED
//
// ported from AAE

#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\clientfield_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_equipment;

function init()
{
    level._custom_powerups[ "carpenter" ].grab_powerup_old = level._custom_powerups[ "carpenter" ].grab_powerup;
    level._custom_powerups[ "carpenter" ].grab_powerup = &grab_carpenter;
}

function is_enabled()
{
    if( GetDvarInt("tfoption_bo4_carpenter", 0) )
    {
        return true;
    }

	return false;
}

function grab_carpenter( player )
{
	if ( is_enabled() )
	{
		foreach(player in GetPlayers()) 
		{
			player thread fixshield();
		}
	}

	if(isDefined(level._custom_powerups[ "carpenter" ].grab_powerup_old))
	{
		self thread [[ level._custom_powerups[ "carpenter" ].grab_powerup_old ]]( player );
	}
}

function fixshield()
{
	wait 0.2;
	foreach ( weapon in self GetWeaponsList( true ) )
	{
		if ( weapon.isriotshield && self clientfield::get_player_uimodel( "zmInventory.shield_health" ) != 1)  
		{
			if(weapon == self getCurrentWeapon())
			{
				self zm_equipment::take(weapon);
				self.hasRiotShield = false;
				self.hasRiotShieldEquipped = false;
				self zm_weapons::weapon_give( weapon, false, false, true, false );
				self SwitchToWeaponImmediate(weapon);
			}
			else
			{
				self zm_equipment::take(weapon);
				self.hasRiotShield = false;
				self.hasRiotShieldEquipped = false;
				self zm_weapons::weapon_give( weapon, false, false, true, false );
			}
			scoreevents::processScoreEvent( "shield_fix", self  );
		}
	}
}