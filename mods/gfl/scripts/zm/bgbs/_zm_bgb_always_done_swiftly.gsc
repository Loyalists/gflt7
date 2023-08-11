#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_always_done_swiftly;

function autoexec __init__sytem__()
{
	system::register("zm_bgb_always_done_swiftly", &__init__, undefined, "bgb");
}

function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_always_done_swiftly", "rounds", 3, &enable, &disable, undefined);
}

function enable()
{
	self setperk("specialty_fastads");
	self setperk("specialty_stalker");
}

function disable()
{
	if(!self HasPerk("specialty_fastreload"))
	{
		self unsetperk("specialty_fastads");
	}
	if(!self HasPerk("specialty_staminup"))
	{
		self unsetperk("specialty_stalker");
	}
}

