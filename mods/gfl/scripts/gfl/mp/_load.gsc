#namespace mp_load;

function main() 
{
	if (level.game_mode_suffix != "_mp")
	{
		return;
	}

	SetDvar( "bot_enableWallrun", true );

	if ( GetDvarInt("tfoption_cheats", 0) )
	{
		SetDvar("sv_cheats", 1);
	}
}