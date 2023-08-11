#using scripts\codescripts\struct;

#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm_powerups;

#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;


REGISTER_SYSTEM( "zm_powerup_money", &__init__, undefined )
	
function __init__()
{
	zm_powerups::include_zombie_powerup( "money" );
	zm_powerups::add_zombie_powerup( "money" );
}
