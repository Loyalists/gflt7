#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_weapons;

#namespace zm_equip_shield;

#define RIOTSHIELD_HEALTH_CLIENTFIELD			"zmInventory.shield_health"

REGISTER_SYSTEM( "zm_equip_shield", &__init__, undefined )

function __init__()
{
	callback::on_spawned( &player_on_spawned );
	
	clientfield::register( "clientuimodel", 	RIOTSHIELD_HEALTH_CLIENTFIELD, VERSION_TU11, 4,	"float",  undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	
}

function player_on_spawned( localClientNum )
{
	self thread watch_weapon_changes( localClientNum ); 
}

function watch_weapon_changes( localClientNum )
{
	self endon("disconnect");
	self endon("entityshutdown");

	while( IsDefined( self ) )
	{
		self waittill( "weapon_change", weapon );
		if ( weapon.isriotshield )
		{
			self thread lock_weapon_models( localClientNum, weapon );
		}
	}
	
}

function lock_weapon_model( model )
{
	if ( IsDefined(model) )
	{
		DEFAULT(level.model_locks,[]);
		DEFAULT(level.model_locks[model],0);
		if ( level.model_locks[model] < 1 )
			ForceStreamXModel( model ); //, -1, -1 );
		level.model_locks[model]++;
	}
}

function unlock_weapon_model( model )
{
	if ( IsDefined(model) )
	{
		DEFAULT(level.model_locks,[]);
		DEFAULT(level.model_locks[model],0);
		level.model_locks[model]--;
		if ( level.model_locks[model] < 1 )
			StopForceStreamingXModel( model ); 
	}
}


function lock_weapon_models( localClientNum, weapon )
{
	lock_weapon_model( weapon.worlddamagedmodel1 );
	lock_weapon_model( weapon.worlddamagedmodel2 );
	lock_weapon_model( weapon.worlddamagedmodel3 );
	self util::waittill_any( "weapon_change", "disconnect", "entityshutdown" );
	unlock_weapon_model( weapon.worlddamagedmodel1 );
	unlock_weapon_model( weapon.worlddamagedmodel2 );
	unlock_weapon_model( weapon.worlddamagedmodel3 );
}
