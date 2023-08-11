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

#precache( "model", "bottomless_clip" );
#precache( "material", "bottomless_clip" );



//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function init_bottomless_clip()
{
	zm_powerups::register_powerup( "bottomless_clip", &grab_bottomless_clip );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "bottomless_clip", "bottomless_clip", "", &func_should_drop_bottomless_clip, !POWERUP_ONLY_AFFECTS_GRABBER, !POWERUP_ANY_TEAM, !POWERUP_ZOMBIE_GRABBABLE );
	}

}

function func_should_drop_bottomless_clip()
{
	return true;
}

function grab_bottomless_clip( player )
{
	players = GetPlayers(); 
	foreach( guy in players )
		give_bottomless_clip( guy ); 
}

function give_bottomless_clip( player )
{
	level notify( "nsz_powerup_grabbed" ); 
	player PlayLocalSound( "bottomless_clip_vox" ); 
	skip = player add_powerup_hud( "bottomless_clip", N_POWERUP_DEFAULT_TIME ); 
	
	if( skip )
		return; 
	
	if( isDefined(player.bottomless_clip_active) && player.bottomless_clip_active )
		return; 
	
	player.bottomless_clip_active = true; 
	player thread bottomless_clip(); 
}

function bottomless_clip()
{
	while(self.bottomless_clip_active)
	{
		gun = self GetCurrentWeapon(); 
		goal = gun.clipsize; 
		self SetWeaponAmmoClip( gun, goal ); 
		wait(0.05); 
	}
}

function wait_til_timeout( player, hud )
{
	if( !isDefined(hud.sound_ent) )
	{
		hud.sound_ent = Spawn("script_origin", (0,0,0));
		hud.sound_ent playloopsound ("zmb_insta_kill_loop");
		hud.sound_ent thread wait_for_another_grab(); 
	}
	while( hud.time > 0 )
	{
		wait(1);
		hud.time--; 		
	}
	
	player.bottomless_clip_active = false; 
	player playsound("zmb_insta_kill_loop_off"); 
	if( isDefined(hud.sound_ent) )
	{
		hud.sound_ent StopLoopSound(2);
		hud.sound_ent delete(); 
	}
	player remove_powerup_hud( "bottomless_clip" ); 
	
}

function wait_for_another_grab()
{
	level waittill( "nsz_powerup_grabbed" ); 
	self StopLoopSound(2); 
	self delete(); 
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