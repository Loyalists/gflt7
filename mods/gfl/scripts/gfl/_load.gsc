#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

#using scripts\gfl\_clientdvar;
#using scripts\gfl\_chat_notify;
#using scripts\gfl\thirdperson;

#insert scripts\shared\shared.gsh;

#namespace core_load;

REGISTER_SYSTEM_EX( "core_load", &__init__, &__main__, undefined )

function private __init__()
{

}

function private __main__()
{
	// thread lua_iprintbold();
}

function lua_iprintbold()
{
    level flagsys::wait_till("load_main_complete");

	while(1)
	{
		if(GetDvarString("lua_iprintbold") != "")
		{
			IPrintLnBold(GetDvarString("lua_iprintbold"));
			SetDvar("lua_iprintbold","");
		}
		wait 0.05;
	}
}