#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#using scripts\shared\array_shared;

#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "model", "powerup_money" );


//REGISTER_SYSTEM( "zm_powerup_money", &__init__, undefined )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function init_zcash_powerup()
{
	zm_powerups::register_powerup( "money", &grab_money );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "money", "powerup_money", "", &func_should_drop_money, POWERUP_ONLY_AFFECTS_GRABBER, !POWERUP_ANY_TEAM, !POWERUP_ZOMBIE_GRABBABLE );
	}

}

function func_should_drop_money()
{
	return true;
}

function grab_money( player )
{
	player PlayLocalSound( "zombie_money_vox" );
	chance = RandomIntRange( 0, 5 ); 
	switch( chance )
	{
		case 0: 
			player zm_score::add_to_player_score( 250 ); 
			break;
		case 1: 
			player zm_score::add_to_player_score( 500 ); 
			break;
		case 2: 
			player zm_score::add_to_player_score( 1000 ); 
			break;
		case 3: 
			player zm_score::add_to_player_score( 1250 ); 
			break;
		case 4: 
			player zm_score::add_to_player_score( 1500 ); 
			break;
		// case 5: 
		// 	player zm_score::minus_to_player_score( 1500 ); 
		// 	break;
		default: 
			player zm_score::add_to_player_score( 250 ); 
			break;
	}
}