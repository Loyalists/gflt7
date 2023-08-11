#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\archetype_shared\archetype_shared.gsh;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\zm\_zm_buildables.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\shared\version.gsh;

#define HINT_ICON	"riotshield_zm_icon"
#define GROUND_LEVEL 0

#define RIOTSHIELD_HEALTH_CLIENTFIELD			"zmInventory.shield_health"
	
	
#precache( "material", HINT_ICON );
#precache( "string", "ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING" );

#namespace riotshield;

REGISTER_SYSTEM_EX( "zm_equip_riotshield", &__init__, &__main__, undefined )

function __init__()
{
	DEFAULT(level.weaponRiotshield,GetWeapon( "riotshield" ));

	clientfield::register( "clientuimodel", 	RIOTSHIELD_HEALTH_CLIENTFIELD, VERSION_TU11,	4,		"float" );
	
	zombie_utility::set_zombie_var( "riotshield_cylinder_radius",		360 );
	zombie_utility::set_zombie_var( "riotshield_fling_range",			90 ); 
	zombie_utility::set_zombie_var( "riotshield_gib_range",				90 ); 
	zombie_utility::set_zombie_var( "riotshield_gib_damage",			75 );
	zombie_utility::set_zombie_var( "riotshield_knockdown_range",		90 ); 
	zombie_utility::set_zombie_var( "riotshield_knockdown_damage",		15 );
	
	zombie_utility::set_zombie_var( "riotshield_fling_force_melee",		100 ); 

	zombie_utility::set_zombie_var( "riotshield_hit_points",			1850 );		

	//damage applied to shield on melee
	zombie_utility::set_zombie_var( "riotshield_fling_damage_shield",			100 ); 
	zombie_utility::set_zombie_var( "riotshield_knockdown_damage_shield",		15 );
	zombie_utility::set_zombie_var( "riotshield_juke_damage_shield",			100 ); 

	zombie_utility::set_zombie_var( "riotshield_stowed_block_fraction",			1.0 );
	
	level.riotshield_network_choke_count=0;
	level.riotshield_gib_refs = []; 
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "guts"; 
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "right_arm"; 
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "left_arm"; 
	
	zm::register_player_damage_callback( &player_damage_override_callback );
	
	DEFAULT(level.riotshield_melee,&riotshield_melee);
	DEFAULT(level.riotshield_melee_power,&riotshield_melee);
	DEFAULT(level.riotshield_damage_callback,&player_damage_shield);
	DEFAULT(level.should_shield_absorb_damage,&should_shield_absorb_damage);
	
	callback::on_connect( &on_player_connect);
}

function __main__()
{
}

function on_player_connect()
{
	self.player_shield_reset_health = &player_init_shield_health;
	DEFAULT(self.player_shield_apply_damage,&player_damage_shield);
	self thread player_watch_weapon_change();
	self thread player_watch_shield_melee();
	self thread player_watch_shield_melee_power();
}

function player_init_shield_health()
{
	self UpdateRiotShieldModel();
	self clientfield::set_player_uimodel( RIOTSHIELD_HEALTH_CLIENTFIELD, 1.0 );
	return 1;
}

function player_set_shield_health( damage, max_damage )
{
	self UpdateRiotShieldModel();
	self clientfield::set_player_uimodel( RIOTSHIELD_HEALTH_CLIENTFIELD, damage / max_damage );
}

// self = player
// attacker = zombie
function player_shield_absorb_damage( eAttacker, iDamage, sHitLoc, sMeansOfDeath )
{
}

function player_shield_facing_attacker( vDir, limit )
{
	orientation = self getPlayerAngles();
	forwardVec = anglesToForward( orientation );
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );

	toFaceeVec = -vDir;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	return ( dotProduct > limit ); // more or less in front
}

// returns fraction of damage absorbed by the shield -- 1.0 == block all damage -- 0.0 == block none 
function should_shield_absorb_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( IS_TRUE(self.hasRiotShield) && IsDefined(vDir) )
	{
		if ( isDefined( eAttacker ) && (IS_TRUE(eAttacker.is_zombie) || IsPlayer(eAttacker)) )
		{ 
			if ( IS_TRUE(self.hasRiotShieldEquipped) )
			{
				// shield held - block all damage in front
				if ( self player_shield_facing_attacker(vDir, 0.2) )
				{
					return 1.0;
				}
			}
			else if ( !IsDefined( self.riotshieldEntity )) 
			{
				// shield on back - block all damage from behind - used to be half damage to player, half to shield
				if ( !self player_shield_facing_attacker(vDir, -0.2) )
				{
					return level.zombie_vars["riotshield_stowed_block_fraction"];
				}
			}
			else
			{
				Assert(!IsDefined( self.riotshieldEntity ), "Planted riotshield no longer supported.");
			}
		}
	}
	return 0.0; 
}



function player_damage_override_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	friendly_fire = ( IsDefined( eAttacker ) && eAttacker.team === self.team );
	if ( IS_TRUE(self.hasRiotShield) && !friendly_fire )
	{
		fBlockFraction = self [[level.should_shield_absorb_damage]] ( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
		if ( fBlockFraction > 0.0 && isdefined(self.player_shield_apply_damage) )
		{
			iBlocked = int( fBlockFraction * iDamage ); 
			iUnblocked = iDamage-iBlocked; 
			if ( isdefined(self.player_shield_apply_damage) )
			{
				self [[self.player_shield_apply_damage]]( iBlocked, false, sHitLoc=="riotshield", sMeansOfDeath );
				if( isdefined( self.riotshield_damage_absorb_callback ) )
				{
					self [[self.riotshield_damage_absorb_callback]]( eAttacker, iBlocked, sHitLoc, sMeansOfDeath );	
				}
			}
			return iUnblocked;
		}
	}
	return -1;
}


function player_damage_shield( iDamage, bHeld, fromCode = false, smod = "MOD_UNKNOWN" )
{
	damageMax = level.weaponRiotshield.weaponstarthitpoints; 
	if ( IsDefined(self.weaponRiotshield) )
		damageMax = self.weaponRiotshield.weaponstarthitpoints; 
	shieldHealth = damageMax; 
	shieldDamage = iDamage; 
	rumbled = false; 
	if ( fromCode )
		shieldDamage = 0; 
	shieldHealth = self DamageRiotShield(shieldDamage); 

	if( shieldHealth <= 0 )
	{
		if( !rumbled )
		{
			self PlayRumbleOnEntity( "damage_heavy" );
			Earthquake( 1.0, 0.75, self.origin, 100 );
		}
		self thread player_take_riotshield();
	}
	else
	{
		if( !rumbled )
		{
			self PlayRumbleOnEntity( "damage_light" );
			Earthquake( 0.5, 0.5, self.origin, 100 );
		}
		self PlaySound( "fly_riotshield_zm_impact_zombies" );//sound for zombie attacks hitting the shield while held
	}
	self UpdateRiotShieldModel();
	self clientfield::set_player_uimodel( RIOTSHIELD_HEALTH_CLIENTFIELD, shieldHealth / damageMax );

}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************

function player_watch_weapon_change()
{
	for ( ;; )
	{
		self waittill( "weapon_change", weapon );
		self UpdateRiotShieldModel();
	}

}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************

function player_watch_shield_melee() // self == player
{
	for ( ;; )
	{
		self waittill( "weapon_melee", weapon );
		if ( weapon.isriotshield )
			self [[level.riotshield_melee]]( weapon );
	}
}

function player_watch_shield_melee_power() // self == player
{
	for ( ;; )
	{
		self waittill( "weapon_melee_power", weapon );
		if ( weapon.isriotshield )
			self [[level.riotshield_melee_power]]( weapon );
	}
}

function riotshield_fling_zombie( player, fling_vec, index )
{
	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	if (IS_TRUE(self.ignore_riotshield))
		return;
	
	if ( IsDefined( self.riotshield_fling_func ) )
	{
		self [[ self.riotshield_fling_func ]]( player );
		return;
	}
	
	damage = 2500;
	
//	self playsound( "fly_rocketshield_hit_zombie" );
	self DoDamage( damage, player.origin, player, player, "", "MOD_IMPACT" );
	if ( self.health < 1 )
	{
		self.riotshield_death = true;
		self StartRagdoll( true );
		self LaunchRagdoll( fling_vec );
	}
	//self.ignore_riotshield=1;
}


function zombie_knockdown( player, gib )
{
	damage = level.zombie_vars["riotshield_knockdown_damage"];
	if(isDefined(level.override_riotshield_damage_func))
	{
		self[[level.override_riotshield_damage_func]](player,gib);
	}
	else
	{
		if ( gib )
		{
			self.a.gib_ref = array::random( level.riotshield_gib_refs );
			self thread zombie_death::do_gib();
		}

		self DoDamage( damage, player.origin, player );
	}

}



function riotshield_knockdown_zombie( player, gib )
{
	self endon( "death" );
	playsoundatposition ("vox_riotshield_forcehit", self.origin);
	playsoundatposition ("wpn_riotshield_proj_impact", self.origin);


	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	if ( IsDefined( self.riotshield_knockdown_func ) )
	{
		self [[ self.riotshield_knockdown_func ]]( player, gib );
	}
	else
	{
		 self zombie_knockdown(player, gib);
		//self DoDamage( level.zombie_vars["riotshield_knockdown_damage"], player.origin, player );
	}
	
//	self playsound( "riotshield_impact" );
//	self.riotshield_handle_pain_notetracks = &handle_riotshield_pain_notetracks;
	self DoDamage( level.zombie_vars["riotshield_knockdown_damage"], player.origin, player );
	self playsound( "fly_riotshield_forcehit" );
	
}

function riotshield_get_enemies_in_range()
{
	view_pos = self geteye(); // GetViewPos(); //GetWeaponMuzzlePoint();
	zombies = array::get_all_closest( view_pos, GetAITeamArray( level.zombie_team ), undefined, undefined, 2 * level.zombie_vars["riotshield_knockdown_range"] );
	if ( !isDefined( zombies ) )
	{
		return;
	}

	knockdown_range_squared = level.zombie_vars["riotshield_knockdown_range"] * level.zombie_vars["riotshield_knockdown_range"];
	gib_range_squared = level.zombie_vars["riotshield_gib_range"] * level.zombie_vars["riotshield_gib_range"];
	fling_range_squared = level.zombie_vars["riotshield_fling_range"] * level.zombie_vars["riotshield_fling_range"];
	cylinder_radius_squared = level.zombie_vars["riotshield_cylinder_radius"] * level.zombie_vars["riotshield_cylinder_radius"];

	fling_force = level.zombie_vars["riotshield_fling_force_melee"]; 
	fling_force_v = 0.5; 
	
	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + VectorScale( forward_view_angles, level.zombie_vars["riotshield_knockdown_range"] );

	for ( i = 0; i < zombies.size; i++ )
	{
		if ( !IsDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
		{
			// guy died on us
			continue;
		}

		if ( zombies[i].archetype == ARCHETYPE_MARGWA )
		{
			continue;
		}

		test_origin = zombies[i] getcentroid();
		//test_origin = (test_origin[0], test_origin[1], view_pos[2] );
		test_range_squared = DistanceSquared( view_pos, test_origin );
		if ( test_range_squared > knockdown_range_squared )
		{
			//zombies[i] riotshield_debug_print( "range", (1, 0, 0) );
			return; // everything else in the list will be out of range
		}

		normal = VectorNormalize( test_origin - view_pos );
		dot = VectorDot( forward_view_angles, normal );
		if ( 0 > dot )
		{
			// guy's behind us
			//zombies[i] riotshield_debug_print( "dot", (1, 0, 0) );
			continue;
		}

		radial_origin = PointOnSegmentNearestToPoint( view_pos, end_pos, test_origin );
		if ( DistanceSquared( test_origin, radial_origin ) > cylinder_radius_squared )
		{
			// guy's outside the range of the cylinder of effect
			//zombies[i] riotshield_debug_print( "cylinder", (1, 0, 0) );
			continue;
		}

		if ( 0 == zombies[i] DamageConeTrace( view_pos, self ) )
		{
			// guy can't actually be hit from where we are
			//zombies[i] riotshield_debug_print( "cone", (1, 0, 0) );
			continue;
		}

		if ( test_range_squared < fling_range_squared )
		{
			level.riotshield_fling_enemies[level.riotshield_fling_enemies.size] = zombies[i];

			// the closer they are, the harder they get flung
			dist_mult = (fling_range_squared - test_range_squared) / fling_range_squared;
			fling_vec = VectorNormalize( test_origin - view_pos );

			// within 6 feet, just push them straight away from the player, ignoring radial motion
			if ( 5000 < test_range_squared )
			{
				fling_vec = fling_vec + VectorNormalize( test_origin - radial_origin );
			}
			fling_vec = (fling_vec[0], fling_vec[1], fling_force_v * abs( fling_vec[2] ));
			fling_vec = VectorScale( fling_vec, fling_force + fling_force * dist_mult );
			level.riotshield_fling_vecs[level.riotshield_fling_vecs.size] = fling_vec;

			//zombies[i] riotshield_debug_print( "fling", (0, 1, 0) );
//			zombies[i] thread setup_riotshield_vox( self, true, false, false );
		}
/*
		else if ( test_range_squared < gib_range_squared )
		{
			level.riotshield_knockdown_enemies[level.riotshield_knockdown_enemies.size] = zombies[i];
			level.riotshield_knockdown_gib[level.riotshield_knockdown_gib.size] = true;

//			zombies[i] thread setup_riotshield_vox( self, false, true, false );
		}
*/
		else
		{
			level.riotshield_knockdown_enemies[level.riotshield_knockdown_enemies.size] = zombies[i];
			level.riotshield_knockdown_gib[level.riotshield_knockdown_gib.size] = false;

//			zombies[i] thread setup_riotshield_vox( self, false, false, true );
			//zombies[i] riotshield_debug_print( "knockdown", (1, 1, 0) );
		}
	}
}


function riotshield_network_choke()
{
	level.riotshield_network_choke_count++;
	
	if ( !(level.riotshield_network_choke_count % 10) )
	{
		util::wait_network_frame();
		util::wait_network_frame();
		util::wait_network_frame();
	}
}


function riotshield_melee( weapon )
{
	// ww: physics hit when firing
	//PhysicsExplosionCylinder( self.origin, 600, 240, 1 );
	
	if ( !IsDefined( level.riotshield_knockdown_enemies ) )
	{
		level.riotshield_knockdown_enemies = [];
		level.riotshield_knockdown_gib = [];
		level.riotshield_fling_enemies = [];
		level.riotshield_fling_vecs = [];
	}

	self riotshield_get_enemies_in_range();

	//iprintlnbold( "flg: " + level.riotshield_fling_enemies.size + " gib: " + level.riotshield_gib_enemies.size + " kno: " + level.riotshield_knockdown_enemies.size );

	shield_damage = 0;

	level.riotshield_network_choke_count = 0;
	for ( i = 0; i < level.riotshield_fling_enemies.size; i++ )
	{
		riotshield_network_choke();
		if (isdefined(level.riotshield_fling_enemies[i]))
		{
			level.riotshield_fling_enemies[i] thread riotshield_fling_zombie( self, level.riotshield_fling_vecs[i], i );
			shield_damage += level.zombie_vars["riotshield_fling_damage_shield"];
		}
	}

	for ( i = 0; i < level.riotshield_knockdown_enemies.size; i++ )
	{
		riotshield_network_choke();
		level.riotshield_knockdown_enemies[i] thread riotshield_knockdown_zombie( self, level.riotshield_knockdown_gib[i] );
		shield_damage += level.zombie_vars["riotshield_knockdown_damage_shield"];
	}

	level.riotshield_knockdown_enemies = [];
	level.riotshield_knockdown_gib = [];
	level.riotshield_fling_enemies = [];
	level.riotshield_fling_vecs = [];

	if (shield_damage)
		self player_damage_shield( shield_damage, false );
}


//******************************************************************
// 
// Riot shield damage states
//   0 undamaged
//   1 SPECIAL bright red version used to indicate the shield cannot be planted
//   2 partially damaged t6_wpn_zmb_shield_dmg1_view
//   3 heavily damaged t6_wpn_zmb_shield_dmg2_view
// 
// Riot shield placement   
//   0 disabled/destroyed
//   1 wielded
//   2 stowed
//   3 deployed 
//
//******************************************************************

function UpdateRiotShieldModel()
{
	WAIT_SERVER_FRAME; 
	self.hasRiotShield = false;
	self.weaponRiotshield = level.weaponNone; 
	foreach ( weapon in self GetWeaponsList( true ) )
	{
		if ( weapon.isriotshield )  
		{
			self.hasRiotShield = true;
			self.weaponRiotshield = weapon;
		}
	}
	current = self getCurrentWeapon();
	self.hasRiotShieldEquipped = (current.isriotshield);
	if ( self.hasRiotShield )
	{
		self clientfield::set_player_uimodel( "hudItems.showDpadDown", 1 );
		if ( self.hasRiotShieldEquipped )
		{
			self zm_weapons::clear_stowed_weapon();
		}
		else
		{
			self zm_weapons::set_stowed_weapon( self.weaponRiotshield );
		}
	}
	else
	{
		self clientfield::set_player_uimodel( "hudItems.showDpadDown", 0 );
		self SetStowedWeapon( level.weaponNone );
	}
	self RefreshShieldAttachment();
	
}

function player_take_riotshield()
{
//iprintlnbold( "riot shield destroyed" );
	self notify( "destroy_riotshield" );

	// is the shield currently being wielded?
	current = self getCurrentWeapon();
	if ( current.isriotshield )
	{
		if ( !( self laststand::player_is_in_laststand() ) )
		{
			new_primary = level.weaponNone;
			primaryWeapons = self GetWeaponsListPrimaries();
			for ( i = 0; i < primaryWeapons.size; i++ )
			{
				if ( !primaryWeapons[i].isriotshield )
				{
					new_primary = primaryWeapons[i];
					break;
				}
			}
			
			if (new_primary == level.weaponNone )
			{
				self zm_weapons::give_fallback_weapon();
				self SwitchToWeaponImmediate();
				self PlaySound( "wpn_riotshield_zm_destroy" );//when zombies destroy the shield while you are holding it
				// don't wait for "weapon_change", as a weird timing issue prevents it from being received in only this case (no primary weapon)
			}
			else
			{
				self SwitchToWeaponImmediate();
				self PlaySound( "wpn_riotshield_zm_destroy" );//when zombies destroy the shield while you are holding it
				self waittill ( "weapon_change" );
			}
		}
	}

	self playsound( "zmb_rocketshield_break" );

	if ( IsDefined(self.weaponRiotshield) )
		self zm_equipment::take(self.weaponRiotshield);
	else
		self zm_equipment::take(level.weaponRiotshield);

	self.hasRiotShield = false;
	self.hasRiotShieldEquipped = false;
}

