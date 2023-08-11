#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#using scripts\gfl\zm\character_randomizer;

#insert scripts\shared\shared.gsh;

#namespace gameplay;

function init()
{
	character_randomizer::init();

	// callback::on_connect( &on_player_connect );
	// callback::on_spawned( &on_player_spawned );
}

function on_player_connect()
{
	self endon("disconnect");
}

function on_player_spawned()
{
	self endon("disconnect");
}