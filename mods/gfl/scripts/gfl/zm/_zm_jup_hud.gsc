#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

REGISTER_SYSTEM_EX( "zm_jup_hud", &__init__, &__main__, undefined )

function __init__()
{
	for( i = 0; i < GetDvarInt( "com_maxclients" ); i++ )
	{
		clientfield::register( "world", "jup_health_" + i, VERSION_SHIP, 7, "float" );
		clientfield::register( "world", "jup_shield_" + i, VERSION_SHIP, 1, "int" );
		clientfield::register( "world", "jup_shield_health_" + i, VERSION_SHIP, 7, "float" );
	}
}

function __main__()
{
    callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	self thread ui_health_monitor();

	if (!isdefined(self.player_shield_reset_health) || !isdefined(self.player_shield_apply_damage))
	{
		return;
	}

	self thread ui_shield_monitor();

	if ( !isdefined(self._player_shield_reset_health_old) )
	{
		self._player_shield_reset_health_old = self.player_shield_reset_health;
	}

	if ( !isdefined(self._player_shield_apply_damage_old) )
	{
		self._player_shield_apply_damage_old = self.player_shield_apply_damage;
	}

	self.player_shield_reset_health = &player_init_shield_health;
	self.player_shield_apply_damage = &player_damage_shield;
}

function ui_health_monitor()
{
    self endon( "bled_out" );
    self endon( "disconnect" );
    self endon( "spawned_player" );

	while( true )
	{
		if( isdefined( self ) )
		{
			health_cf = "jup_health_" + self GetEntityNumber();
			health = ( zm_utility::is_player_valid( self ) ? Float( self.health / self.maxhealth ) : 0 );

			if( !IS_EQUAL( level clientfield::get( health_cf ), health ) )
			{
				level clientfield::set( health_cf, health );
			}
		}

		wait 0.2;
	}
}

function ui_shield_monitor()
{
    self endon( "bled_out" );
    self endon( "disconnect" );
    self endon( "spawned_player" );

	while( true )
	{
		if( isdefined( self ) )
		{
			shield_cf = "jup_shield_" + self GetEntityNumber();
			shield = IS_TRUE( self.hasRiotShield );

			if( !IS_EQUAL( level clientfield::get( shield_cf ), shield ) )
			{
				level clientfield::set( shield_cf, shield );
			}

		}

		wait 0.2;
	}
}

function player_init_shield_health()
{
	result = 1;
	func = self._player_shield_reset_health_old;
	if (IsFunctionPtr(func))
	{
		result = self [[func]]();
	}

	level clientfield::set( "jup_shield_health_" + self GetEntityNumber(), 1.0 );
	return result;
}

function player_damage_shield( iDamage, bHeld, fromCode = false, smod = "MOD_UNKNOWN" )
{
	func = self._player_shield_apply_damage_old;
	if (IsFunctionPtr(func))
	{
		self [[func]]( iDamage, bHeld, fromCode, smod );
	}

	if ( !isdefined(level.weaponRiotshield) || !isdefined(level.weaponRiotshield.weaponstarthitpoints) )
	{
		level clientfield::set( "jup_shield_health_" + self GetEntityNumber(), 0.0 );
		return;
	}

	damageMax = level.weaponRiotshield.weaponstarthitpoints;

	if( isdefined( self.weaponRiotshield ) )
	{
		damageMax = self.weaponRiotshield.weaponstarthitpoints;
	}

	shieldDamage = 0;
	shieldHealth = self DamageRiotShield( shieldDamage );
	if( shieldHealth < 0 )
	{
		shieldHealth = 0;
	}

	level clientfield::set( "jup_shield_health_" + self GetEntityNumber(), shieldHealth / damageMax );
}