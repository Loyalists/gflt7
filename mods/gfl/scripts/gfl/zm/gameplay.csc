#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#using scripts\gfl\zm\character_mgr;
#using scripts\gfl\zm\zm_sub;
#using scripts\gfl\zm\_aae_zombie_health_bar;
#using scripts\gfl\zm\_zm_jup_hud;

#insert scripts\shared\shared.gsh;

#namespace gameplay;

function init()
{
	// callback::on_connect( &on_player_connect );
	// callback::on_spawned( &on_player_spawned );
	level.elmg_enemies = [];
	ai::add_ai_spawn_function( &on_ai_spawned );
}

function on_player_connect()
{
	self endon("disconnect");
}

function on_player_spawned()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");
	self endon("entityshutdown");
}

function on_ai_spawned( localClientNum )
{
	self endon("death");
	self endon("entityshutdown");

	ArrayInsert(level.elmg_enemies, self, level.elmg_enemies.size);
	self thread remove_on_death();
}

function remove_on_death()
{
	self util::waittill_any("death", "entityshutdown");
	ArrayRemoveValue(level.elmg_enemies,self);
}