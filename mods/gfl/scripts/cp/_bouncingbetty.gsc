// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
// #using scripts\cp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;

#using scripts\gfl\cp\_load;

#namespace bouncingbetty;

/*
	Name: __init__sytem__
	Namespace: bouncingbetty
	Checksum: 0xF18B0165
	Offset: 0x140
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bouncingbetty", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bouncingbetty
	Checksum: 0x84EA7911
	Offset: 0x180
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

