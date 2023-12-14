#using scripts\codescripts\struct;

#insert scripts\shared\shared.gsh;

#namespace core_frontend_fx;

function autoexec init()
{
	setdvar("tu4_enableCodPoints",0);
	thread apply_settings();
	// thread dvar_tester();
	// thread lua_iprintbold();
}

function main()
{}

function apply_settings()
{
	while (1) 
	{
		setdvar("tu4_enableCodPoints", 0); 

		if(GetDvarString("fs_game") != "usermaps")
		{
			SetDvar("fs_game_saved", GetDvarString("fs_game") );
		}

		wait 0.05;
	}
}

function dvar_tester()
{
	modvar("d" , "");
    while(1)
    {
        if(GetDvarString("d") != "")
        {
            string = GetDvarString("d");
            tokenized = StrTok(string, " ");
            string = ToLower(tokenized[1]);
            dvar = ToLower(tokenized[0]);
			Setdvar(dvar,String);
			IPrintLnBold("^5Dvar Set^7: " + dvar + " " + GetDvarString(dvar));
            SetDvar("d", "");
        } 
        wait 0.05;
    }
}

function lua_iprintbold()
{
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