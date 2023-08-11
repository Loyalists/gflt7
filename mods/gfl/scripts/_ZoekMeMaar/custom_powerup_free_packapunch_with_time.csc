#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_powerups;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;


REGISTER_SYSTEM( "free_packapunch", &__init__, undefined )
	
function __init__()
{
	zm_powerups::include_zombie_powerup( "free_packapunch" );
	zm_powerups::add_zombie_powerup( "free_packapunch" );
}
