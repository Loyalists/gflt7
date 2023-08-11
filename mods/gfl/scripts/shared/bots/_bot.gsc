#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\bots\_bot.gsh;

#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\bots\bot_traversals;

#namespace bot;

#define BOT_MAX_STUCK_CYCLES	3
#define BOT_STUCK_DISTANCE 128
#define BOT_POSITION_HISTORY_SIZE	5

#define BOT_STUCK_RESOLUTION_S 1.5
	
#define BOT_DIVE_RADIUS		128
#define BOT_SWIM_HEIGHT_MIN		25
#define BOT_SWIM_HEIGHT_MAX		45

REGISTER_SYSTEM( "bot", &__init__, undefined )
	
function __init__()
{
	callback::on_start_gametype( &init );
	
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned);
	callback::on_player_killed( &on_player_killed );
	
	// Setup Methods
	DEFAULT( level.getBotSettings, &get_bot_default_settings );
	
	// Lifecycle events
	DEFAULT( level.onBotRemove, &bot_void );
	DEFAULT( level.onBotConnect, &bot_void );
	DEFAULT( level.onBotSpawned, &bot_void );
	DEFAULT( level.onBotKilled, &bot_void );
	
	// Outside events
	DEFAULT( level.onBotDamage, &bot_void );
	
	// Think Events
	DEFAULT( level.botUpdate, &bot_update );
	DEFAULT( level.botPreCombat, &bot_void );
	DEFAULT( level.botCombat, &bot_combat::combat_think );
	DEFAULT( level.botPostCombat, &bot_void );
	DEFAULT( level.botIdle, &bot_void );
	
	// Combat Events
	DEFAULT( level.botThreatDead, &bot_combat::clear_threat );
	DEFAULT( level.botThreatEngage, &bot_combat::engage_threat );
	DEFAULT( level.botUpdateThreatGoal, &bot_combat::update_threat_goal );
	DEFAULT( level.botThreatLost, &bot_combat::clear_threat );

	// Combat Queries
	//level.botThreatIsAlive
	DEFAULT( level.botGetThreats, &bot_combat::get_bot_threats );
	DEFAULT( level.botIgnoreThreat, &bot_combat::ignore_non_sentient );
	
	SetDvar( "bot_maxMantleHeight", 200 );
	//SetDvar( "bot_enableWallrun", true );
/#
	level thread bot_devgui_think();
#/
}

function init()
{
	init_bot_settings();
}

function is_bot_ranked_match()
{
	return false;
}

function bot_void()
{
}

function bot_unhandled()
{
	return false;
}

// Add Bots
//========================================

function add_bots( count, team )
{
	for ( i = 0; i < count; i++ )
	{
		add_bot( team );
	}
}

function add_bot( team )
{
	botEnt = AddTestClient();
	
	if ( !isdefined( botEnt ) )
	{
		return undefined;
	}

	botEnt BotSetRandomCharacterCustomization();
	
	if ( IS_TRUE( level.disableClassSelection ) )
	{
		botEnt.pers["class"] = level.defaultClass;
		botEnt.curClass = level.defaultClass;
	}
	
	if ( level.teamBased && team !== "autoassign" )
	{
		botEnt.pers[ "team" ] = team;
	}
	
	return botEnt;
}

// Remove Bots
//========================================

function remove_bots( count, team )
{
	players = GetPlayers();

	foreach( player in players )
	{
		if ( !player IsTestClient() )
		{
			continue;
		}
		
		if ( isdefined( team ) && player.team != team )
		{
			continue;
		}

		remove_bot( player );
		
		if ( isdefined( count ) )
		{
			count--;
			if ( count <= 0 )
			{
				break;
			}
		}
	}
}

function remove_bot( bot )
{
	if ( !bot IsTestClient() )
	{
		return;
	}
	
	bot [[level.onBotRemove]]();
		
	bot BotDropClient();
}

// Utils
//========================================

function filter_bots( players )
{
	bots = [];
		
	foreach( player in players )
	{
		if ( player util::is_bot() )
		{
			bots[bots.size] = player;
		}
	}
	
	return bots;
}


// Events
//========================================

function on_player_connect()
{
	if ( !self IsTestClient() )
	{
		return;
	}

	self endon ( "disconnect" );	
	
	// Do the bot initialization on connect so it gets called after skiptos
	self.bot = SpawnStruct();
	self.bot.threat = SpawnStruct();
	self.bot.damage = SpawnStruct();
	
	self.pers["isBot"] = true;
	
	if ( level.teambased )
	{
		self notify( "menuresponse", game["menu_team"], self.team );
		wait 0.5;
	}

	self notify( "joined_team" );
	callback::callback( #"on_joined_team" );
	
	self thread [[level.onBotConnect]]();
}

function on_player_spawned()
{
	if ( !self util::is_bot() )
	{
		return;
	}
	
	self clear_stuck();
	self bot_combat::clear_threat();
	self.bot.prevWeapon = undefined;
	
	self BotLookForward();
	
	self thread [[level.onBotSpawned]]();
	
	self thread bot_combat::wait_damage_loop();
	self thread wait_bot_path_failed_loop();
	self thread wait_bot_goal_reached_loop();
	self thread bot_think_loop();
}

function on_player_killed()
{
	if ( !self util::is_bot() )
	{
		return;
	}

	self thread [[level.onBotKilled]]();
	
	self BotReleaseManualControl();
}


// Think
//========================================

function bot_think_loop()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	while(1)
	{
		self bot_think();
		
		wait level.botSettings.thinkInterval;
	}
}

function bot_think()
{
	self BotReleaseButtons();
	
	if ( level.inprematchperiod ||
	     level.gameEnded ||
	     !IsAlive( self ) )
	{
		return;
	}
	
	self check_stuck();
		
	self sprint_think();
	
	self update_swim();
	
	self thread [[level.botUpdate]]();
	
	self thread [[level.botPreCombat]]();
	
	self thread [[level.botCombat]]();
	
	self thread [[level.botPostCombat]]();
	
	// No threat and no goal means the bot is idle
	if ( !self bot_combat::has_threat() && !self BotGoalSet() )
	{
		self thread [[level.botIdle]]();
	}
}

function bot_update()
{

	// TODO: Cache things that get checked frequently
}

function update_swim()
{
	if ( !self IsPlayerSwimming() )
	{
		self.bot.resurfaceTime = undefined;
		return;
	}
	
	if ( self IsPlayerUnderwater() )
	{
		if ( !isdefined( self.bot.resurfaceTime ) )
		{
			self.bot.resurfaceTime = GetTime() + level.botSettings.swimTime;
		}
	}
	else
	{
		self.bot.resurfaceTime = undefined;
	}
	
	if ( self BotUnderManualControl() )
	{
		return;
	}
	
	goalPosition = self BotGetGoalPosition();
	
	// Swim down to a navmesh goal under the water
	if ( Distance2DSquared( goalPosition, self.origin ) <= ( BOT_DIVE_RADIUS * BOT_DIVE_RADIUS ) &&
	     GetWaterHeight( goalPosition ) > 0 )
	{
		self bot::press_swim_down();
		return;
	}
	
	if ( isdefined( self.bot.resurfaceTime ) && self.bot.resurfaceTime <= GetTime() )
	{
		{
			bot::press_swim_up();
			return;
		}
	}
	
	bottomTrace = GroundTrace( self.origin, self.origin + ( 0, 0, -1000 ), false, self, true );
	swimHeight = self.origin[2] - bottomTrace[ "position" ][2];
	
	if ( swimHeight < BOT_SWIM_HEIGHT_MIN )
	{
		self bot::press_swim_up();
		
		vertDist = BOT_SWIM_HEIGHT_MIN - swimHeight;
	}
	else if ( swimHeight > BOT_SWIM_HEIGHT_MAX )
	{
		self bot::press_swim_down();
		
		vertDist = swimHeight - BOT_SWIM_HEIGHT_MAX;
	}

	if ( isdefined( vertDist ) )
	{
		intervalDist = level.botSettings.swimVerticalSpeed * level.botSettings.thinkInterval;
		
		if ( intervalDist > vertDist )
		{
			self wait_release_swim_buttons( level.botSettings.thinkInterval * vertDist / intervalDist );
		}	
	}
}

function wait_release_swim_buttons( waitTime )
{
	self endon( "death" );
	level endon( "game_ended" );
	
	wait waitTime;
	
	self bot::release_swim_up();
	self bot::release_swim_down();
}

// Settings
//========================================

function init_bot_settings()
{
	level.botSettings = [[level.getBotSettings]]();
	
	// Dvar Settings
	SetDvar( "bot_AllowMelee", VAL( level.botSettings.allowMelee, 0 ) );
	SetDvar( "bot_AllowGrenades", VAL( level.botSettings.allowGrenades, 0 ) );
	SetDvar( "bot_AllowKillstreaks", VAL( level.botSettings.allowKillstreaks, 0 ) );
	SetDvar( "bot_AllowHeroGadgets", VAL( level.botSettings.allowHeroGadgets, 0 ) );
	
	SetDvar( "bot_Fov", VAL( level.botSettings.fov, 0 ) );
	SetDvar( "bot_FovAds", VAL( level.botSettings.fovAds, 0 ) );
	SetDvar( "bot_PitchSensitivity", level.botSettings.pitchSensitivity );
	SetDvar( "bot_YawSensitivity", level.botSettings.yawSensitivity );

	SetDvar( "bot_PitchSpeed", VAL( level.botSettings.pitchSpeed, 0 ) );
	SetDvar( "bot_PitchSpeedAds", VAL( level.botSettings.pitchSpeedAds, 0 ) );
	SetDvar( "bot_YawSpeed", VAL( level.botSettings.yawSpeed, 0 ) );
	SetDvar( "bot_YawSpeedAds", VAL( level.botSettings.yawSpeedAds, 0 ) );
	
	SetDvar( "pitchAccelerationTime", VAL( level.botSettings.pitchAccelerationTime, 0 ) );
	SetDvar( "yawAccelerationTime", VAL( level.botSettings.yawAccelerationTime, 0 ) );

	SetDvar( "pitchDecelerationThreshold", VAL( level.botSettings.pitchDecelerationThreshold, 0 ) );
	SetDvar( "yawDecelerationThreshold", VAL( level.botSettings.yawDecelerationThreshold, 0 ) );
	
	// Cached Settings
	meleeRange = GetDvarInt( "player_meleeRangeDefault" ) * VAL( level.botSettings.meleeRangeMultiplier, 0 );
	level.botSettings.meleeRange = Int( meleeRange );
	level.botSettings.meleeRangeSq = meleeRange * meleeRange;
	
	level.botSettings.threatRadiusMinSq = level.botsettings.threatRadiusMin * level.botsettings.threatRadiusMin;
	level.botSettings.threatRadiusMaxSq = level.botSettings.threatRadiusMax * level.botSettings.threatRadiusMax;
	
	lethalDistanceMin = VAL( level.botSettings.lethalDistanceMin, 0 );
	level.botSettings.lethalDistanceMinSq  = lethalDistanceMin * lethalDistanceMin;
	
	lethalDistanceMax = VAL( level.botSettings.lethalDistanceMax, 1024 );
	level.botSettings.lethalDistanceMaxSq  = lethalDistanceMax * lethalDistanceMax;
	
	tacticalDistanceMin = VAL( level.botSettings.tacticalDistanceMin, 0 );
	level.botSettings.tacticalDistanceMinSq  = tacticalDistanceMin * tacticalDistanceMin;
	
	tacticalDistanceMax = VAL( level.botSettings.tacticalDistanceMax, 1024 );
	level.botSettings.tacticalDistanceMaxSq  = tacticalDistanceMax * tacticalDistanceMax;
	
	level.botSettings.swimVerticalSpeed = GetDvarFloat( "player_swimVerticalSpeedMax" );
	level.botSettings.swimTime = GetDvarFloat( "player_swimTime", 5 ) * 1000;
}

function get_bot_default_settings( )
{
	return struct::get_script_bundle( "botsettings", "bot_default" );
}

// Movement
//========================================

function sprint_to_goal()
{
	self.bot.sprintToGoal = true;
}

function end_sprint_to_goal()
{
	self.bot.sprintToGoal = false;
}

function sprint_think()
{
	if ( IS_TRUE( self.bot.sprintToGoal ) )
	{
		if ( self BotGoalReached() )
		{
			self end_sprint_to_goal();
			return;
		}
		
		self press_sprint_button();
		return;
	}
}

function goal_in_trigger( trigger )
{
	radius = self get_trigger_radius( trigger );
	
	return distanceSquared( trigger.origin, self BotGetGoalPosition() ) <= radius * radius;
}

function point_in_goal( point )
{
	deltaSq = Distance2DSquared( self BotGetGoalPosition(), point );
	goalRadius = self BotGetGoalRadius();
	
	return deltaSq <= goalRadius * goalRadius;
}

function path_to_trigger( trigger, radius )
{
	// These usually have something inside them, possibly cutting the navmesh
	if ( trigger.className == "trigger_use" || 
	     trigger.className == "trigger_use_touch" )
	{
		DEFAULT( radius, get_trigger_radius( trigger ) );
		
		randomAngle = ( 0, RandomInt( 360 ), 0 );
		randomVec = AnglesToForward( randomAngle );
		
		point = trigger.origin + randomVec * radius;

		self BotSetGoal( point );
	}
	
	DEFAULT( radius, 0 );
	
	self BotSetGoal( trigger.origin, Int( radius ) );
}

function path_to_point_in_trigger( trigger )
{
	mins = trigger GetMins();
	maxs = trigger GetMaxs();
	
	radius = Min( maxs[0], maxs[1] );
	height = maxs[2] - mins[2];
	             
	minOrigin = trigger.origin + ( 0, 0, mins[2] );
		
	queryHeight = height / 4;
	
	queryOrigin = minOrigin + ( 0, 0, queryHeight );
	
/#	
	if ( GetDvarInt( "bot_drawtriggerquery", 0 ) )
	{
		drawS = 10;
		Circle( queryOrigin, radius, (0,1,0), false, true, 20*drawS );
		Circle( queryOrigin + (0,0,queryHeight), radius, (0,1,0), false, true, 20*drawS );
		Circle( queryOrigin - (0,0,queryHeight), radius, (0,1,0), false, true, 20*drawS );
	}
#/	
	queryResult = PositionQuery_Source_Navigation( queryOrigin, 0, radius, queryHeight, 17, self );
	
	best_point = undefined;
	
	foreach ( point in queryResult.data )
	{
		point.score = randomFloatRange( 0, 100 );
		
		if ( !isdefined( best_point ) || point.score > best_point.score )
		{
			best_point = point;
		}
	}
	
	if ( isdefined( best_point ) )
	{
		self BotSetGoal( best_point.origin, BOT_DEFAULT_GOAL_RADIUS );
		return;
	}
	
	self bot::path_to_trigger( trigger, radius );
}

function get_trigger_radius( trigger )
{
	maxs = trigger GetMaxs();
	
	if ( trigger.classname == "trigger_radius" )
	{
		return maxs[0];
	}
	
	return Min( maxs[0], maxs[1] );
}

function get_trigger_height( trigger )
{	
	maxs = trigger GetMaxs();
	
	if ( trigger.classname == "trigger_radius" )
	{
		return maxs[2];
	}
	
	return maxs[2] * 2;
}

// Path Failure
//========================================

function check_stuck()
{
/#
	if ( !GetDvarInt( "bot_AllowMovement" ) )
	{
		return;
	}
#/
		
	if ( self BotUnderManualControl() ||
		 self BotGoalReached() ||
		 self util::isstunned() ||
		 self IsMeleeing() ||
		 self MeleeButtonPressed() ||
		 // Target is within 128 units, probably meleeing
		 ( self bot_combat::has_threat() && self.bot.threat.lastDistanceSq < 16384 ) )
	{
		return;
	}
	
	velocity = self GetVelocity();
	
	if ( velocity[0] == 0 &&
		 velocity[1] == 0 &&
		 ( velocity[2] == 0 || self IsPlayerSwimming() ) )
	{	
		DEFAULT( self.bot.stuckCycles, 0 );
		
		self.bot.stuckCycles++;
		
		if ( self.bot.stuckCycles >= BOT_MAX_STUCK_CYCLES )
		{
/#		
			if ( GetDvarInt( "bot_debugStuck" , 0 ) )
			{				
				Sphere( self.origin, 16, ( 1, 0, 0 ), 0.25, false, 16, 1200 );
				iprintln( "Bot " + self.name + " not moving at: "+ self.origin );
			}
#/			
			self thread stuck_resolution();
		}
	}
	else
	{
		self.bot.stuckCycles = 0;
	}
	
	// Only do this check if we're moving and don't have a visible
	// Bots could be adsing or meleeing or all kinds of things
	if ( !self bot_combat::threat_visible() )
	{
		self check_stuck_position();
	}
}

function check_stuck_position()
{	
	if ( GetTime() < self.bot.checkPositionTime )
		return;
	
	self.bot.checkPositionTime = GetTime() + 500;
	
	self.bot.positionHistory[self.bot.positionHistoryIndex] = self.origin;
	self.bot.positionHistoryIndex = ( self.bot.positionHistoryIndex + 1 ) % BOT_POSITION_HISTORY_SIZE;
	
	if ( self.bot.positionHistory.size < BOT_POSITION_HISTORY_SIZE )
		return;
	
	maxDistSq = undefined;
	
	for( i = 0; i < self.bot.positionHistory.size; i++ )
	{
/#			
		if ( GetDvarInt( "bot_debugStuck" , 0 ) )
		{	
			Line( self.bot.positionHistory[i], self.bot.positionHistory[i] + ( 0, 0, 72 ), ( 0, 1, 0 ), 1, false, 10 );
		}
#/		
		for ( j = i + 1; j < self.bot.positionHistory.size; j++ )
		{
			distSq = DistanceSquared( self.bot.positionHistory[i], self.bot.positionHistory[j] );
			
			// Early out if we find evidence of enough movement
			if ( distSq > BOT_STUCK_DISTANCE * BOT_STUCK_DISTANCE )
			{
				return;
			}
		}
	}

/#	
	if ( GetDvarInt( "bot_debugStuck" , 0 ) )
	{
		Sphere( self.origin, BOT_STUCK_DISTANCE, ( 1, 0, 0 ), 0.25, false, 16, 1200 );
		iprintln( "Bot " + self.name + " hanging out at: "+ self.origin );
	}
#/	
	self thread stuck_resolution();
}

function stuck_resolution()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	self clear_stuck();
	
	self BotTakeManualControl();
	
	escapeAngle = self GetAngles()[1] + 180 + RandomIntRange( -60, 60 );;
	escapeDir = AnglesToForward( ( 0, escapeAngle, 0 ) );
	
	self BotSetMoveAngle( escapeDir );
	self BotSetMoveMagnitude( 1 );
	
	wait( BOT_STUCK_RESOLUTION_S );
	
	self BotReleaseManualControl();
}

function clear_stuck()
{
	self.bot.stuckCycles = 0;
	self.bot.positionHistory = [];
	self.bot.positionHistoryIndex = 0;
	self.bot.checkPositionTime = 0;
}

function camp()
{
	self BotSetGoal( self.origin );
	
	self bot::press_crouch_button();
}

// 0 - Unknown
// 1 - Invalid Start ( Bot off navmesh )
// 2 - Invalid End ( Can't get desination point on navmesh )
// 3 - Unreachable ( Can't get path )

function wait_bot_path_failed_loop()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	while( 1 )
	{
		self waittill( "bot_path_failed", reason );
		
/#
		if ( GetDvarInt( "bot_debugStuck" , 0 ) )
		{
			goalPosition = self BotGetGoalPosition();
			Box( self.origin, ( -15, -15, 0 ), ( 15, 15, 72 ), 0, ( 0, 1, 0 ), 0.25, false, 1200 );
			Box( goalPosition, ( -15, -15, 0 ), ( 15, 15, 72 ), 0, ( 1, 0, 0 ), 0.25, false, 1200 );
			Line( self.origin, goalPosition, ( 1, 1, 1 ), 1, false, 1200 );
			iprintln( "Bot " + self.name + " path failed from: " + self.origin + " to: " + goalPosition );
		}
#/
	
		self thread stuck_resolution();
	}
}

function wait_bot_goal_reached_loop()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	while( 1 )
	{
		self waittill( "bot_goal_reached", reason );
		
		self clear_stuck();
	}
}

// Hero Stuff
//========================================

function stow_gun_gadget()
{
	currentWeapon = self GetCurrentWeapon();
	
	if ( self GetWeaponAmmoClip( currentWeapon ) ||
	     !currentWeapon.isheroweapon)
	{
		return;
	}
	
	if ( isdefined( self.lastDroppableWeapon ) && self hasWeapon(self.lastDroppableWeapon) )
	{
		self SwitchToWeapon( self.lastDroppableWeapon );
	}
}

function get_ready_gadget( )
{
	weapons = self GetWeaponsList();
	
	foreach( weapon in weapons )
	{
		slot = self GadgetGetSlot( weapon );
		
		if ( slot < 0 ||
		     !self GadgetIsReady( slot ) || 
		     self GadgetIsActive( slot ) )
		{
			continue;
		}
		
		return weapon;
	}
	
	return level.weaponNone;
}

function get_ready_gun_gadget()
{
	weapons = self GetWeaponsList();
	
	foreach( weapon in weapons )
	{
		if ( !is_gun_gadget( weapon ) )
		{
			continue;
		}
		
		slot = self GadgetGetSlot( weapon );
		
		if ( slot < 0 ||
		     !self GadgetIsReady( slot ) || 
		     self GadgetIsActive( slot ) )
		{
			continue;
		}
		
		return weapon;
	}
	
	return level.weaponNone;
}

function is_gun_gadget( weapon )
{
	if ( !isdefined( weapon ) ||
	     weapon == level.weaponNone ||
	     !weapon.isHeroWeapon )
	{
		return false;
	}
	
	// TODO: May need to add more of these
	return weapon.isBulletWeapon ||
		   weapon.isProjectileWeapon ||
		   weapon.isLauncher ||
		   weapon.isGasWeapon;
}

function activate_hero_gadget( weapon )
{
	if ( !isdefined( weapon ) ||
	     weapon == level.weaponNone ||
	     !weapon.isgadget )
	{
		return;
	}
	
	if ( is_gun_gadget( weapon ) )
	{
		self SwitchToWeapon( weapon );
	}	
	else if ( weapon.isHeroWeapon )
	{
		self bot::tap_offhand_special_button();
	}
	else
	{
		self BotPressButtonForGadget( weapon );
	}
}


//  Coop Methods
//========================================

function coop_pre_combat()
{
	self bot_combat::bot_pre_combat();
	
	if ( self bot_combat::has_threat() )
	{		
		return;
	}	
	
	if ( self IsReloading() ||
	     self IsSwitchingWeapons() ||
	     self IsThrowingGrenade() ||
 	     self FragButtonPressed() ||
	     self SecondaryOffhandButtonPressed() ||
	     self IsMeleeing() ||
	     self IsRemoteControlling() ||
	     self IsInVehicle() ||
	     self IsWeaponViewOnlyLinked() )
	{
		return;
	}
	
	if ( self bot_combat::switch_weapon() )
	{
		return;
	}
	
	if ( self bot_combat::reload_weapon() )
	{
		return;
	}
}

function coop_post_combat()
{
	if ( self revive_players() )
	{
		if ( self bot_combat::has_threat() )
		{
			self bot_combat::clear_threat();
			self BotSetGoal( self.origin );
		}
		
		return;
	}
	
	self bot_combat::bot_post_combat();
}

// Following
//========================================

#define COOP_FOLLOW_RADIUS_MIN	150
#define COOP_FOLLOW_RADIUS_MAX	300

function follow_coop_players()
{
	// Favor the host
	host = bot::get_host_player();
	
	if ( !IsAlive( host ) )
	{
		players = ArraySort( level.players, self.origin );
		
		foreach( player in players )
		{
			if ( !player util::is_bot() &&
			     player.team == self.team && 
				 IsAlive( player ) )
			{
				break;
			}
		}
	}
	else
	{
		player = host;
	}
	
	if ( isdefined( player ) )
	{
		//self thread follow_entity( player, COOP_FOLLOW_RADIUS_MIN, COOP_FOLLOW_RADIUS_MAX );
		
		fwd = AnglesToForward( player.angles );
		botDir = self.origin - player.origin;
		
		if ( VectorDot( botDir, fwd ) < 0 )
			self thread lead_player( player, COOP_FOLLOW_RADIUS_MIN );			
	}
}

function lead_player( player, followMin )
{	
	radiusMin = followMin - 32;
	radiusMax = followMin;
	
	dotMin = 0.85;
	dotMax = 0.92;
	
	queryResult = PositionQuery_Source_Navigation( player.origin, radiusMin, radiusMax, 150, 32, self );
	
	fwd = AnglesToForward( player.angles );
	
	point = player.origin + fwd * 72;
	
	self BotSetGoal( point, 42 );
	self sprint_to_goal();
}

function follow_entity( entity, radiusMin, radiusMax )
{
	DEFAULT( radiusMin, BOT_DEFAULT_GOAL_RADIUS );
	DEFAULT( radiusMax, radiusMin + 1 );
	
	if ( !point_in_goal( entity.origin ) )
	{
		radius = RandomIntRange( radiusMin, radiusMax );
		self BotSetGoal( entity.origin, radius );
		self sprint_to_goal();
	}
}


// Navmesh Wander
//========================================

function navmesh_wander( fwd, radiusMin, radiusMax, spacing, fwdDot )
{
	DEFAULT( radiusMin, VAL( level.botSettings.wanderMin, 0 ) );
	DEFAULT( radiusMax, VAL( level.botSettings.wanderMax, 0 ) );
	DEFAULT( spacing, VAL( level.botSettings.wanderSpacing, 0 ) );
	DEFAULT( fwdDot, VAL( level.botSettings.wanderFwdDot, 0 ) );
	
	DEFAULT( fwd, AnglesToForward( self.angles ) );
	
	// Don't factor in pitch or elevation
	fwd = VectorNormalize( ( fwd[0], fwd[1], 0 ) );
	queryResult = PositionQuery_Source_Navigation( self.origin, radiusMin, radiusMax, 150, spacing, self );	
	
	best_point = undefined;
	
	origin = ( self.origin[0], self.origin[1], 0 );
	
	foreach ( point in queryResult.data )
	{
		movePoint = ( point.origin[0], point.origin[1], 0 );
		moveDir = VectorNormalize( movePoint - origin );
		dot = VectorDot( moveDir, fwd );
		
		point.score = MapFloat( radiusMin, radiusMax, 0, 50, point.distToOrigin2D );
		
		if ( dot > fwdDot )
		{
			point.score += randomFloatRange( 30, 50 );
		}
		else if ( dot > 0 )
		{
			point.score += randomFloatRange( 10, 35 );
		}
		else
		{
			point.score += randomFloatRange( 0, 15 );
		}
		if ( !isdefined( best_point ) || point.score > best_point.score )
		{
			best_point = point;
		}
	}
	
	if( isdefined( best_point ) )
	{
		self BotSetGoal( best_point.origin, radiusMin );
	}
	else
	{
/#		
		if ( GetDvarInt( "bot_debugStuck" , 0 ) )
		{	
			Circle( self.origin, radiusMin, ( 1, 0, 0 ), false, true, 1200 );
			Circle( self.origin, radiusMax, ( 1, 0, 0 ), false, true, 1200 );			
			Sphere( self.origin, 16, ( 0, 1, 0 ), 0.25, false, 16, 1200 );
			iprintln( "Bot " + self.name + " can't find wander point at: "+ self.origin );
		}
#/			
		self thread stuck_resolution();
	}
}

// Goal Approach Pathing
//========================================

#define APPROACH_GOAL_RADIUS_MAX	1500
#define APPROACH_GOAL_SPACING		128

function approach_goal_trigger( trigger, radiusMax, spacing )
{
	DEFAULT( radiusMax, APPROACH_GOAL_RADIUS_MAX );
	DEFAULT( spacing, APPROACH_GOAL_SPACING );
	
	distSq = DistanceSquared( self.origin, trigger.origin );
	
	if ( distSq < radiusMax * radiusMax )
	{
		self path_to_point_in_trigger( trigger );
		return;
	}
	
	radiusMin = self get_trigger_radius( trigger );
	
	self approach_point( trigger.origin, radiusMin, radiusMax, spacing );
}

function approach_point( point, radiusMin, radiusMax, spacing )
{
	DEFAULT( radiusMin, 0 );
	DEFAULT( radiusMax, APPROACH_GOAL_RADIUS_MAX );
	DEFAULT( spacing, APPROACH_GOAL_SPACING );
	
	distSq = DistanceSquared( self.origin, point );
	
	if ( distSq < radiusMax * radiusMax )
	{
		self BotSetGoal( point, BOT_DEFAULT_GOAL_RADIUS );
		return;
	}
	
	queryResult = PositionQuery_Source_Navigation( point, radiusMin, radiusMax, 150, spacing, self );

	fwd = AnglesToForward( self.angles );
	
	// Don't factor in pitch or elevation
	fwd = ( fwd[0], fwd[1], 0 );
	origin = ( self.origin[0], self.origin[1], 0 );
	
	best_point = undefined;
	
	foreach ( point in queryResult.data )
	{
		movePoint = ( point.origin[0], point.origin[1], 0 );
		moveDir = VectorNormalize( movePoint - origin );
		dot = VectorDot( moveDir, fwd );
		
		point.score = randomFloatRange( 0, 50 );
		
		if ( dot < .5 )	// Favor points in the 240 degree arc towards the bot
		{
			point.score += randomFloatRange( 30, 50 );
		}
		else
		{
			point.score += randomFloatRange( 0, 15 );
		}
		
		if ( !isdefined( best_point ) || point.score > best_point.score )
		{
			best_point = point;
		}
	}
	
	if ( isdefined( best_point ) )
	{
		self BotSetGoal( best_point.origin, BOT_DEFAULT_GOAL_RADIUS );
	}
}
	

// Revive
//========================================

function revive_players()
{
	players = self get_team_players_in_laststand();
	
	if ( players.size > 0 )
	{
		revive_player( players[0] );
		return true;
	}
	
	return false;
}

function get_team_players_in_laststand()
{
	players = [];
	
	foreach( player in level.players )
	{
		if ( player != self && player laststand::player_is_in_laststand() && player.team == self.team )
		{
			players[players.size] = player;
		}
	}
	
	players = ArraySort( players, self.origin );
	
	return players;
}

function revive_player( player )
{
	if ( !point_in_goal( player.origin ) )
	{
		self BotSetGoal( player.origin, 64 );
		self sprint_to_goal();
		return;
	}
	
	if ( self BotGoalReached() )
	{
		self BotSetLookAnglesFromPoint( player GetCentroid() );
		self tap_use_button();
	}
}


// Cornering
//========================================

#define DEFAULT_START_CORNER_DIST 	64
#define DEFAULT_CORNER_DIST			128

function watch_bot_corner( startCornerDist, cornerDist )
{
	self endon( "death" );
	self endon( "bot_combat_target" );
	level endon( "game_ended" );
	
	DEFAULT( startCornerDist, DEFAULT_START_CORNER_DIST );
	DEFAULT( cornerDist, DEFAULT_CORNER_DIST );
	
	startCornerDistSq = cornerDist * cornerDist;
	cornerDistSq = cornerDist * cornerDist;
	
	while ( 1 )
	{		
		self waittill( "bot_corner", centerPoint, enterPoint, leavePoint, angle, nextEnterPoint );
		
		if ( self bot_combat::has_threat() )
		{
			continue;
		}
		
		if( Distance2DSquared( self.origin, enterPoint ) < startCornerDistSq ||
		    Distance2DSquared( leavePoint, nextEnterPoint ) < cornerDistSq )
		{
			continue;
		}
		
		self thread wait_corner_radius( startCornerDistSq, centerPoint, enterPoint, leavePoint, angle, nextEnterPoint );
	}
}

function wait_corner_radius( startCornerDistSq, centerPoint, enterPoint, leavePoint, angle, nextEnterPoint )
{
	self endon( "death" );
	self endon( "bot_corner" );
	self endon( "bot_goal_reached" );
	self endon( "bot_combat_target" );
	level endon( "game_ended" );
	
	while( Distance2DSquared( self.origin, enterPoint ) > startCornerDistSq )
	{
		if ( self bot_combat::has_threat() )
		{
			return;
		}
		
		WAIT_SERVER_FRAME;
	}
			
	// + standing viewheight
	self BotLookAtPoint( ( nextEnterPoint[0], nextEnterPoint[1], nextEnterPoint[1] + 60 ) );
	
	self thread finish_corner();
}

function finish_corner()
{
	self endon( "death" );
	self endon( "combat_target" );
	level endon( "game_ended" );
	
	self util::waittill_any( "bot_corner", "bot_goal_reached" );
	
	self BotLookForward();
}


// Utilities
//========================================

function get_host_player()
{
	players = GetPlayers();

	foreach( player in players )
	{
		if ( player IsHost() )
		{
			return player;
		}
	}

	return undefined;
}

function fwd_dot( point )
{
	angles = self GetPlayerAngles();
	fwd = AnglesToForward( angles );

	delta = point - self GetEye();
	delta = VectorNormalize( delta );

	dot = VectorDot( fwd, delta );
	return dot;
}

// TODO: fwd_dot2d ?

function has_launcher()
{
	weapons = self GetWeaponsList();
	
	foreach( weapon in weapons )
	{
		if ( weapon.isRocketLauncher )
		{
			return true;
		}
	}
	
	return false;
}

function kill_bot()
{
	self DoDamage( self.health, self.origin );
}

/#
	
// Debugging
//========================================

function kill_bots()
{
	foreach( player in level.players )
	{
		if ( player util::is_bot() )
		{
			player kill_bot();
		}
	}
}
	
function add_bot_at_eye_trace( team )	
{
	host = util::getHostPlayer();
	
	trace = host eye_trace();
	
	direction_vec = host.origin - trace["position"];
	direction = VectorToAngles( direction_vec );
	
	yaw = direction[1];
	bot = add_bot( team );
	
	if ( isdefined( bot ) )
	{
		bot waittill( "spawned_player" );
		
		bot SetOrigin( trace[ "position" ] );
		bot SetPlayerAngles( ( bot.angles[0], yaw, bot.angles[2] ) );
	}
	
	return bot;
}

function eye_trace()
{
	direction = self GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = self GetEye();

	scale = 8000;
	direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
	
	return bullettrace( eye, eye + direction_vec, 0, undefined );
}

// Route Debugging
//========================================

function devgui_debug_route()
{
	iprintln( "Debug Patrol:" );
	points = self get_nav_points();

	if ( !isdefined( points ) || points.size == 0 )
	{
		iprintln( "Route Debug Cancelled" );
		return;
	}

	iprintln( "Sending bots to chosen points" );

	players = GetPlayers();
	foreach( player in players )
	{
		if ( !player util::is_bot() )
		{
			continue;
		}

		player thread debug_patrol( points );
	}
}

function get_nav_points()
{
	iprintln( "Square (X) - Add Point" );
	iprintln( "Cross (A) - Done" );
	iprintln( "Circle (B) - Cancel" );
	
	points = [];
	while ( 1 )
	{
		WAIT_SERVER_FRAME;
	
		point = self eye_trace()["position"];
		if ( isdefined( point ) )
		{
			point = GetClosestPointOnNavMesh( point, 128 );
			
			if ( isdefined( point ) )
			{
				Sphere( point, 16, ( 0, 0, 1 ), 0.25, false, 16, 1 );
			}
		}
		
		if ( self ButtonPressed( "BUTTON_X" ) )
		{
			if ( isdefined( point ) && ( points.size == 0 || Distance2D( point, points[points.size-1] ) > 16 ) )
			{
				points[points.size] = point;
			}
		}
		else if ( self ButtonPressed( "BUTTON_A" ) )
		{
			return points;
		}
		else if ( self ButtonPressed( "BUTTON_B" ) )
		{
			return undefined;
		}

		for ( i = 0; i < points.size; i++ )
		{
			Sphere( points[i], 16, ( 0, 1, 0 ), 0.25, false, 16, 1 );
		}
	}
}

function debug_patrol( points )
{
	self notify( "debug_patrol" );
	self endon( "death" );
	self endon( "debug_patrol" );
	
	i = 0;
	
	//self end_sprint_to_goal();
	
	while( 1 )
	{
		self BotSetGoal( points[i], BOT_DEFAULT_GOAL_RADIUS );
		self bot::sprint_to_goal();
		self waittill( "bot_goal_reached" );
		
		i = ( i + 1 ) % points.size;
	}
}


// Devgui
//========================================

function bot_devgui_think()
{
	while( 1 )
	{
		wait( 0.25 );

		cmd = GetDvarString( "devgui_bot", "" );
		
		if ( !isdefined( level.botDevguiCmd ) || ![[level.botDevguiCmd]](cmd) )
		{
			host = util::getHostPlayer();
			
			switch( cmd )
			{
			case "remove_all":
				remove_bots();
				break;
			case "laststand":
				kill_bots();
				break;
			case "routes":
				host devgui_debug_route();
				break;
			default:
				break;			
			}
		}
		
		SetDvar( "devgui_bot", "" );
	}
}

function coop_bot_devgui_cmd( cmd )
{
	host = get_host_player();
	
	switch( cmd )
	{
		case "add":
			add_bot( host.team );
			return true;
		case "add_3":
			add_bots( 3, host.team );
			return true;
		case "add_crosshair":
			add_bot_at_eye_trace();
			return true;
		case "remove":
			remove_bots( 1 );
			return true;
		break;
	}
	
	return false;
}

// Debug Drawing
//========================================

function debug_star( origin, seconds, color )
{
	if ( !isdefined( seconds ) )
	{
		seconds = 1;
	}
	
	if ( !isdefined( color ) )
	{
		color = ( 1, 0, 0 );
	}

	frames = Int( 20 * seconds );
	DebugStar( origin, frames, color );
}

#/