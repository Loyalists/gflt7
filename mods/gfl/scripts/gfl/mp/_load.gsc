#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;

#namespace mp_load;

REGISTER_SYSTEM_EX( "mp_load", &__init__, &__main__, undefined )

function private __init__()
{
	SetDvar( "bot_enableWallrun", true );

	if ( GetDvarInt("tfoption_cheats", 0) || GetDvarInt("developer", 0) )
	{
		SetDvar("sv_cheats", 1);
	}
	else
	{
		SetDvar("sv_cheats", 0);
	}
}

function private __main__()
{

}