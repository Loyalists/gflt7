#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;

#using scripts\zm\_zm_mod;

#insert scripts\shared\shared.gsh;

#namespace zm_ffotd;

function main_start()
{
	zm_mod::init();
}

function main_end() {}

function optimize_for_splitscreen() {}