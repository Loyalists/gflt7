#using scripts\shared\system_shared;

//REGISTER SHARED SYSTEMS - DO NOT REMOVE
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\player_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\water_surface;
#using scripts\shared\postfx_shared;
#using scripts\shared\blood;
#using scripts\shared\drown;
#using scripts\shared\_explode;

//Weapons
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_empgrenade;

#insert scripts\shared\shared.gsh;

#using scripts\gfl\cp\_load;

// Bloodsplatter
// #using scripts\zm\_zm_bloodsplatter;

#namespace load;

REGISTER_SYSTEM( "load", &__init__, undefined )

function __init__()
{
}

function art_review()
{
}

