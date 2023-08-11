#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;


#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\array_shared;

#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "model", "zombie_blood" );
#precache( "material", "zombie_blood" );



//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function init_zblood()
{
	zm_powerups::register_powerup( "zombie_blood", &grab_zombie_blood );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "zombie_blood", "zombie_blood", "", &func_should_drop_zombie_blood, POWERUP_ONLY_AFFECTS_GRABBER, !POWERUP_ANY_TEAM, !POWERUP_ZOMBIE_GRABBABLE );
	}
	level.enemy_location_override_func = &check_for_in_blood; 

}

function func_should_drop_zombie_blood()
{
	return true;
}

function grab_zombie_blood( player )
{
	player PlayLocalSound( "zombie_blood_vox" ); 
	
	player.has_zombie_blood = true; 
	skip = player add_powerup_hud( "zombie_blood", N_POWERUP_DEFAULT_TIME ); 
	if( skip )
		return; 
	
	visionset_mgr::activate( "overlay", "zm_bgb_in_plain_sight", player, 2, 15, 2 );
	visionset_mgr::activate( "visionset", "zm_bgb_in_plain_sight", player, 2 );
	player.is_in_blood = true;
	player EnableInvulnerability(); 
}

function wait_til_timeout( player, hud )
{
	while( hud.time > 0 )
	{
		wait(1);
		hud.time--; 		
	}
	visionset_mgr::deactivate( "overlay", "zm_bgb_in_plain_sight", player );
	visionset_mgr::deactivate( "visionset", "zm_bgb_in_plain_sight", player );
	player.is_in_blood = undefined;	
	player DisableInvulnerability(); 
	player.has_zombie_blood = undefined; 
	player remove_powerup_hud( "zombie_blood" ); 
	player PlayLocalSound("zmb_insta_kill_loop_off");
}

function check_for_in_blood( zom, enemy )
{
	if( isDefined(enemy.is_in_blood) && enemy.is_in_blood )
	{
		// iprintlnbold( "^2Player in Zombie Blood" ); 
		players = GetPlayers(); 
		
		options = array::get_all_closest( zom.origin, players, enemy ); 
		for( i=0;i<options.size;i++ )
			if( zm_utility::is_player_valid(options[i]) && !isDefined(options[i].is_in_blood) )
				return options[i]; 
			
		if( all_players_in_blood() )
		{
			distractions = struct::get_array( "player_respawn_point", "targetname");
			origin = distractions[0].origin; 
			return origin; 
		}
	}
	
	return undefined; 
}

function all_players_in_blood()
{
	count = 0; 
	players = GetPlayers(); 
	foreach( player in players )
	{
		if( isDefined(player.is_in_blood) )
			count++; 
	}
	if( count == players.size )
		return true; 
	return false; 
}

function add_powerup_hud( powerup, timer )
{
	if ( !isDefined( self.powerup_hud ) )
		self.powerup_hud = [];
	
	if( isDefined( self.powerup_hud[powerup] ) )
	{
		self.powerup_hud[powerup].time = timer; 
		return true; // tells to skip because powerup is already active 
	}
	
	self endon( "disconnect" );
	hud = NewClientHudElem( self );
	hud.powerup = powerup;
	hud.foreground = true;
	hud.hidewheninmenu = false;
	hud.alignX = "center";
	hud.alignY = "bottom";
	hud.horzAlign = "center";
	hud.vertAlign = "bottom";
	hud.x = hud.x;
	hud.y = hud.y - 50;
	hud.alpha = 1;
	hud SetShader( powerup , 64, 64 );
	hud scaleOverTime( .5, 32, 32 );
	hud.time = timer;
	hud thread harrybo21_blink_powerup_hud();
	thread wait_til_timeout( self, hud ); 
	
	self.powerup_hud[ powerup ] = hud;
	
	a_keys = GetArrayKeys( self.powerup_hud );
	for ( i = 0; i < a_keys.size; i++ )
	 	self.powerup_hud[ a_keys[i] ] thread move_hud( .5, 0 - ( 24 * ( self.powerup_hud.size ) ) + ( i * 37.5 ) + 25, self.powerup_hud[ a_keys[i] ].y );
	
	return false; // powerup is not already active
}

function move_hud( time, x, y )
{
	self moveOverTime( time );
	self.x = x;
	self.y = y;
}

function harrybo21_blink_powerup_hud()
{
	self endon( "delete" );
	self endon( "stop_fade" );
	while( isDefined( self ) )
	{
		if ( self.time >= 20 )
		{
			self.alpha = 1; 
			wait .1;
			continue;
		}
		fade_time = 1;
		if ( self.time < 10 )
			fade_time = .5;
		if ( self.time < 5 )
			fade_time = .25;
			
		self fadeOverTime( fade_time );
		self.alpha = !self.alpha;
		
		wait( fade_time );
	}
}

function remove_powerup_hud( powerup )
{
	self.powerup_hud[ powerup ] destroy();
	self.powerup_hud[ powerup ] notify( "stop_fade" );
	self.powerup_hud[ powerup ] fadeOverTime( .2 );
	self.alpha = 0;
	wait .2;
	self.powerup_hud[ powerup ] delete();
	self.powerup_hud[ powerup ] = undefined;
	self.powerup_hud = array::remove_index( self.powerup_hud, self.powerup_hud[ powerup ], true );
	
	a_keys = GetArrayKeys( self.powerup_hud );
	for ( i = 0; i < a_keys.size; i++ )
	 	self.powerup_hud[ a_keys[i] ] thread move_hud( .5, 0 - ( 24 * ( self.powerup_hud.size ) ) + ( i * 37.5 ) + 25, self.powerup_hud[ a_keys[i] ].y );
}