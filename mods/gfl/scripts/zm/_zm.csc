#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#insert scripts\shared\aat_shared.gsh;
#insert scripts\shared\duplicaterender.gsh;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_load;
#using scripts\zm\_sticky_grenade;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_demo;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_ffotd;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zdraw;

// AATs
#insert scripts\shared\aat_zm.gsh;
#using scripts\zm\aats\_zm_aat_blast_furnace;
#using scripts\zm\aats\_zm_aat_dead_wire;
#using scripts\zm\aats\_zm_aat_fire_works;
#using scripts\zm\aats\_zm_aat_thunder_wall;
#using scripts\zm\aats\_zm_aat_turned;

#precache( "client_fx", "_t6/maps/zombie/fx_mp_zombie_hand_water_burst" );
#precache( "client_fx", "_t6/maps/zombie/fx_mp_zombie_body_water_billowing" );
#precache( "client_fx", "_t6/maps/zombie/fx_zombie_body_wtr_falling" );
#precache( "client_fx", "zombie/fx_spawn_dirt_hand_burst_zmb" );
#precache( "client_fx", "zombie/fx_spawn_dirt_body_billowing_zmb" );
#precache( "client_fx", "zombie/fx_spawn_dirt_body_dustfalling_zmb" );	
#precache( "client_fx", "_t6/maps/zombie/fx_mp_zombie_hand_snow_burst" );
#precache( "client_fx", "_t6/maps/zombie/fx_mp_zombie_body_snow_falling" );
#precache( "client_fx", "zombie/fx_blood_torso_explo_zmb" );
#precache( "client_fx", "zombie/fx_blood_torso_explo_lg_zmb" );

#namespace zm;

function autoexec ignore_systems()
{
	//shutdown unwanted systems
	system::ignore("gadget_clone");
	system::ignore("gadget_heat_wave");
	system::ignore("gadget_resurrect");
	system::ignore("gadget_shock_field");
	system::ignore("gadget_es_strike");
	system::ignore("gadget_misdirection");
	system::ignore("gadget_smokescreen");
	system::ignore("gadget_firefly_swarm");
	system::ignore("gadget_immolation");
	system::ignore("gadget_forced_malfunction");
	system::ignore("gadget_sensory_overload");
	system::ignore("gadget_rapid_strike");
	system::ignore("gadget_camo_render");
	system::ignore("gadget_unstoppable_force");
	system::ignore("gadget_overdrive");
	system::ignore("gadget_concussive_wave");
	system::ignore("gadget_ravage_core");
	system::ignore("gadget_cacophany");
	system::ignore("gadget_iff_override");
	system::ignore("gadget_security_breach");
	system::ignore("gadget_surge");
	system::ignore("gadget_exo_breakdown");
	system::ignore("gadget_servo_shortout");
	system::ignore("gadget_system_overload");
	system::ignore("gadget_cleanse");
	system::ignore("gadget_flashback");
	system::ignore("gadget_combat_efficiency");
	system::ignore("gadget_other");
	system::ignore("gadget_vision_pulse");
	system::ignore("gadget_camo");
	system::ignore("gadget_speed_burst");
	system::ignore("gadget_armor");
	system::ignore("gadget_thief");
	system::ignore("replay_gun");
	system::ignore("spike_charge_siegebot");
	system::ignore("end_game_taunts");

	if ( GetDvarInt( "splitscreen_playerCount" ) > 2 )
	{
		system::ignore("footsteps");
		system::ignore("ambient");
	}
	
}

function init()
{
	level thread zm_ffotd::main_start();

	level.onlineGame = SessionModeIsOnlineGame();
	level.swimmingFeature = false;

//	level.scr_zm_game_module = getZMGameModule(GetDvarString( "ui_gametype" ));
	level.scr_zm_ui_gametype = GetDvarString( "ui_gametype" );
	level.scr_zm_map_start_location = "";//GetDvarString( "ui_zm_mapstartlocation" );
	level.gamedifficulty = GetGametypeSetting( "zmDifficulty" );
	level.enable_magic	= GetGametypeSetting( "magic" );
	level.headshots_only = GetGametypeSetting( "headshotsonly" );

	level.disable_equipment_team_object = true;

	util::register_system("lsm", &last_stand_monitor);

	level.clientVoiceSetup = &zm_audio::clientVoiceSetup;
	level.playerFallDamageSound = &zm_audio::playerFallDamageSound;
	
	init_clientfields();
	
	zm_perks::init();
	zm_powerups::init();

	zm_weapons::init();
	
	init_blocker_fx();
	init_riser_fx();
	init_zombie_explode_fx();

	level.gibResetTime = 0.5;
	level.gibMaxCount = 3;
	level.gibTimer = 0;
	level.gibCount = 0;
	level._gibEventCBFunc	= &on_gib_event;
	level thread resetGibCounter();

	level thread ZPO_listener();
	level thread ZPOff_listener();
	
	level._BOX_INDICATOR_NO_LIGHTS = -1;
	level._BOX_INDICATOR_FLASH_LIGHTS_MOVING = 99;
	
	level._box_indicator = level._BOX_INDICATOR_NO_LIGHTS;	// No lights showing.

	util::register_system("box_indicator", &box_monitor);

	level._ZOMBIE_GIB_PIECE_INDEX_ALL = 0;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM = 1;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM = 2;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG = 3;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG = 4;
	level._ZOMBIE_GIB_PIECE_INDEX_HEAD = 5;
	level._ZOMBIE_GIB_PIECE_INDEX_GUTS = 6;
	level._ZOMBIE_GIB_PIECE_INDEX_HAT = 7;

	callback::add_callback( #"on_localclient_connect", &basic_player_connect);
	callback::on_spawned( &player_duplicaterender );
	callback::on_spawned( &player_umbrahotfixes );
	
	level.update_aat_hud = &update_aat_hud;
	
	// custom character exerts - most of the exert sounds will be set up here
	if (isdefined(level.setupCustomCharacterExerts))
		[[level.setupCustomCharacterExerts]]();
	
	
	level thread zm_ffotd::main_end();
}

function delay_for_clients_then_execute(func)
{
	wait(0.1);
	
	players = GetLocalPlayers();

	for(x=0;x<players.size;x++)
	{
		while( !ClientHasSnapshot( x ) )
		{
			wait( 0.05 );
		}			
	}

	wait(0.1);
	
	level thread [[func]]();
}


#define PLAYER_KEYLINE_MATERIAL					"mc/hud_keyline_zm_player"
#define PLAYER_KEYLINE_MATERIAL_LASTSTAND		"mc/hud_keyline_zm_player_ls"

#define PLAYER_KEYLINE_DVAR						"scr_hide_player_keyline"

#define SITREP_FRIENDLY_ONLY 			4	
#define SITREP_BEAST_MODE_AND_FRIENDLY  3	
	
function init_duplicaterender_settings()
{
	self oed_sitrepscan_enable( SITREP_FRIENDLY_ONLY );
	self oed_sitrepscan_setoutline( 1 );
	self oed_sitrepscan_setlinewidth( 2 );
	self oed_sitrepscan_setsolid( 1 );
	self oed_sitrepscan_setradius( 800 );
	self oed_sitrepscan_setfalloff( 0.1 );

	duplicate_render::set_dr_filter_offscreen( "player_keyline", 25, "keyline_active", "keyline_disabled", DR_TYPE_OFFSCREEN, PLAYER_KEYLINE_MATERIAL, DR_CULL_NEVER );
	duplicate_render::set_dr_filter_offscreen( "player_keyline_ls", 30, "keyline_active,keyline_ls", "keyline_disabled", DR_TYPE_OFFSCREEN, PLAYER_KEYLINE_MATERIAL_LASTSTAND, DR_CULL_NEVER );

}

function player_duplicaterender( localClientNum )
{
	if( self == GetLocalPlayer( localClientNum ) )
	{
		self init_duplicaterender_settings(); 
		self thread force_update_player_clientfields(localClientNum);
	}
	if( self IsPlayer() && self IsLocalPlayer() )
	{
		if( !IsDefined(self GetLocalClientNumber()) || localClientNum == self GetLocalClientNumber() )
			return;
	}
	
	dvar_value = GetDvarInt( PLAYER_KEYLINE_DVAR );
	
	self duplicate_render::set_dr_flag( "keyline_active", !dvar_value );
	self duplicate_render::update_dr_filters(localClientNum);
}

function player_umbrahotfixes( localClientNum )
{
	if ( !self IsLocalPlayer() || !IsDefined( self GetLocalClientNumber() ) || localClientNum != self GetLocalClientNumber() )
	{
		return;
	}

	self thread zm_utility::umbra_fix_logic( localClientNum );
}

function basic_player_connect( localClientNum )
{
	
	if ( !isdefined( level._laststand ) )
	{
		level._laststand = [];
	}
	
	level._laststand[localClientNum] = false;

}

function force_update_player_clientfields( localClientNum )
{
	self endon( "entityshutdown" );
	
	while(!ClientHasSnapshot(localClientNum))
	{
		wait(0.25);
	}
	
	wait(0.25);
	
	self ProcessClientFieldsAsIfNew();
}

function init_blocker_fx()
{
//	level._effect["wood_chunk_destory"]	 		= "_t6/impacts/fx_large_woodhit";
}

function init_riser_fx()
{

	
	// NEW riser effects in water
	if(isDefined(level.use_new_riser_water) && level.use_new_riser_water)
	{
		level._effect["rise_burst_water"]			  = "_t6/maps/zombie/fx_mp_zombie_hand_water_burst";
		level._effect["rise_billow_water"]			= "_t6/maps/zombie/fx_mp_zombie_body_water_billowing";	
		level._effect["rise_dust_water"]			= "_t6/maps/zombie/fx_zombie_body_wtr_falling";
	}

	level._effect["rise_burst"]					= "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow"]				= "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust"]					= "zombie/fx_spawn_dirt_body_dustfalling_zmb";	
	
	if(isDefined(level.riser_type) && level.riser_type == "snow")
	{
		level._effect["rise_burst_snow"]        = "_t6/maps/zombie/fx_mp_zombie_hand_snow_burst";
		level._effect["rise_billow_snow"]       = "_t6/maps/zombie/fx_mp_zombie_body_snow_billowing";
		level._effect["rise_dust_snow"]					= "_t6/maps/zombie/fx_mp_zombie_body_snow_falling";	
	}

}

function init_clientfields()
{
	// Callbacks for actors
	
	clientfield::register("actor", "zombie_riser_fx", VERSION_SHIP, 1, "int", &handle_zombie_risers, CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	
	if ( IS_TRUE( level.use_water_risers ) )
	{
		clientfield::register("actor", "zombie_riser_fx_water", VERSION_SHIP, 1, "int", &handle_zombie_risers_water, CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	}
	
	if ( IS_TRUE( level.use_foliage_risers ) )
	{
		clientfield::register("actor", "zombie_riser_fx_foliage", VERSION_SHIP, 1, "int", &handle_zombie_risers_foliage, CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	}
	
	if ( IS_TRUE( level.use_low_gravity_risers ) )
	{
		clientfield::register("actor", "zombie_riser_fx_lowg", VERSION_SHIP, 1, "int", &handle_zombie_risers_lowg, CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
	}
	
	clientfield::register("actor", "zombie_has_eyes", VERSION_SHIP, 1, "int", &zombie_eyes_clientfield_cb, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("actor", "zombie_ragdoll_explode", VERSION_SHIP, 1, "int", &zombie_ragdoll_explode_cb, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("actor", "zombie_gut_explosion", VERSION_SHIP, 1, "int", &zombie_gut_explosion_cb, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("actor", "sndZombieContext", VERSION_SHIP_OBSOLETE, 1, "int", &zm_audio::sndSetZombieContext, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("actor", "zombie_keyline_render", VERSION_SHIP, 1, "int", &zombie_zombie_keyline_render_clientfield_cb, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);

	bits = 4;
	power = struct::get_array("elec_switch_fx","script_noteworthy");
	if ( IsDefined( power ) )
	{
		bits = GetMinBitCountForNum( power.size + 1 );
	}
	clientfield::register("world", "zombie_power_on", VERSION_SHIP, bits, "int", &zombie_power_clientfield_on, CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("world", "zombie_power_off", VERSION_SHIP, bits, "int", &zombie_power_clientfield_off, CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	
	clientfield::register("world", "round_complete_time", VERSION_SHIP, 20, "int", &round_complete_time, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("world", "round_complete_num", VERSION_SHIP, 8, "int", &round_complete_num, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("world", "game_end_time", VERSION_SHIP, 20, "int", &game_end_time, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("world", "quest_complete_time", VERSION_SHIP, 20, "int", &quest_complete_time, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("world", "game_start_time", VERSION_TU15_FFOTD_090816_0, 20, "int", &game_start_time, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
}

function box_monitor(clientNum, state, oldState)
{
	if(IsDefined(level._custom_box_monitor))
	{
		[[level._custom_box_monitor]](clientNum, state, oldState);
	}
}

function ZPO_listener()
{
	while(1)
	{
		int = undefined;
		level waittill("ZPO", int);	// Zombie power on.

		if(IsDefined(int))
		{
			level notify("power_on", int );
		}
		else
		{
			level notify("power_on" );
		}	
		//level notify("middle_door_open");
	}
}

function ZPOff_listener()
{
	while(1)
	{
		int = undefined;
		level waittill("ZPOff", int);

		if(IsDefined(int))
		{
			level notify("power_off", int );
		}
		else
		{
			level notify("power_off" );
		}	
	}
}

function zombie_power_clientfield_on(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level notify("ZPO", newVal);
	}
}

function zombie_power_clientfield_off(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level notify("ZPOff", newVal);
	}
}

function round_complete_time(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.time.round_complete_time" );
	SetUIModelValue( model, newVal );
}

function round_complete_num(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.time.round_complete_num" );
	SetUIModelValue( model, newVal );
}

function game_end_time(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.time.game_end_time" );
	SetUIModelValue( model, newVal );
}

function quest_complete_time(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.time.quest_complete_time" );
	SetUIModelValue( model, newVal );
}

function game_start_time(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.time.game_start_time" );
	SetUIModelValue( model, newVal );
}

//
//
function createZombieEyesInternal(localClientNum)
{
	self endon("entityshutdown");
	
	self util::waittill_dobj( localClientNum );	

	if ( !isdefined( self._eyeArray ) )
	{
		self._eyeArray = [];
	}

	if ( !isdefined( self._eyeArray[localClientNum] ) )
	{
		linkTag = "j_eyeball_le";

		effect = level._effect["eye_glow"];

		// will handle level wide eye fx change
		if(IsDefined(level._override_eye_fx))
		{
			effect = level._override_eye_fx;
		}
		// will handle individual spawner or type eye fx change
		if(IsDefined(self._eyeglow_fx_override))
		{
			effect = self._eyeglow_fx_override;
		}

		if(IsDefined(self._eyeglow_tag_override))
		{
			linkTag = self._eyeglow_tag_override;
		}

		self._eyeArray[localClientNum] = PlayFxOnTag( localClientNum, effect, self, linkTag );
	}
}

function createZombieEyes( localClientNum )
{
	self thread createZombieEyesInternal(localClientNum);
}

	
function deleteZombieEyes(localClientNum)
{
	if ( isdefined( self._eyeArray ) )
	{
		if ( isdefined( self._eyeArray[localClientNum] ) )
		{
			DeleteFx( localClientNum, self._eyeArray[localClientNum], true );
			self._eyeArray[localClientNum] = undefined;
		}
	}
}

function player_eyes_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if ( self IsPlayer() )
	{
		self.zombie_face = newVal;
		self notify( "face", "face_advance" );
		
		if ( IS_TRUE(self.special_eyes) )
		{
//			self._eyeglow_fx_override = level._effect["player_eye_glow_blue"];
		}
		else
		{
//			self._eyeglow_fx_override = level._effect["player_eye_glow_orng"];
		}
	}

	if( self IsPlayer() && self IsLocalPlayer() && !IsDemoPlaying() )
	{
		if( localClientNum == self GetLocalClientNumber() )
			return;
	}
	
	if( !IsDemoPlaying() )
		zombie_eyes_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	else
		zombie_eyes_demo_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
}

function player_eye_color_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if( self IsPlayer() && self IsLocalPlayer() && !IsDemoPlaying() )
	{
		if( localClientNum == self GetLocalClientNumber() )
			return;
	}

	if ( !IsDefined(self.special_eyes) || self.special_eyes != newVal )
	{
		self.special_eyes = newVal;

		if ( IS_TRUE(self.special_eyes) )
		{
			self._eyeglow_fx_override = level._effect["player_eye_glow_blue"];
		}
		else
		{
			self._eyeglow_fx_override = level._effect["player_eye_glow_orng"];
		}
		
		if( !IsDemoPlaying() )
			zombie_eyes_clientfield_cb(localClientNum, false, IS_TRUE(self.zombie_face), bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
		else
			zombie_eyes_demo_clientfield_cb(localClientNum, false, IS_TRUE(self.zombie_face), bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
}

function zombie_eyes_handle_demo_jump( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "death_or_disconnect" );
	self endon( "new_zombie_eye_cb" );
	
	while( true )
	{
		level util::waittill_any( "demo_jump", "demo_player_switch" );
		
		self deleteZombieEyes(localClientNum);
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color() );
		self.eyes_spawned = false;
	}
}

function zombie_eyes_demo_watcher( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	self endon( "entityshutdown" );
	self endon( "death_or_disconnect" );
	self endon( "new_zombie_eye_cb" );
	
	self thread zombie_eyes_handle_demo_jump( localClientNum );
	
	if( newVal )
	{
		while( true )
		{
			if( !self IsLocalPlayer() || IsSpectating( localClientNum, true ) || localClientNum != self GetLocalClientNumber() )
			{
				if( !IS_TRUE( self.eyes_spawned ) )
				{
					self createZombieEyes( localClientNum );
					self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color() );
					self.eyes_spawned = true;
				}
			}
			else
			{
				if( IS_TRUE( self.eyes_spawned ) )
				{
					self deleteZombieEyes(localClientNum);
					self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color() );
					self.eyes_spawned = false;
				}
			}
			
			wait( 0.016 );
		}
	}
	else
	{
		self deleteZombieEyes(localClientNum);
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color() );
		self.eyes_spawned = false;
	}
}

function zombie_eyes_demo_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{	
	self notify( "new_zombie_eye_cb" );
	self thread zombie_eyes_demo_watcher(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
}

function zombie_eyes_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)  // self = actor
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if(newVal)
	{
		self createZombieEyes( localClientNum );
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color() );
	}
	else
	{
		self deleteZombieEyes(localClientNum);
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color() );
	}
	
	// optional callback for handling zombie eyes
	if ( IsDefined( level.zombie_eyes_clientfield_cb_additional ) )
	{
		self [[ level.zombie_eyes_clientfield_cb_additional ]]( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump );
	}	
}

function zombie_zombie_keyline_render_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)  // self = actor
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if( IS_TRUE(level.debug_keyline_zombies) )
	{
		if( newVal )
		{
			self duplicate_render::set_dr_flag( "keyline_active", 1 );
			self duplicate_render::update_dr_filters(localClientNum);
		}
		else
		{
			self duplicate_render::set_dr_flag( "keyline_active", 0 );
			self duplicate_render::update_dr_filters(localClientNum);
		}
	}
}

function get_eyeball_on_luminance()
{
	if( IsDefined( level.eyeball_on_luminance_override ) )
	{
		return level.eyeball_on_luminance_override;
	}
	
	return 1;
}

function get_eyeball_off_luminance()
{
	if( IsDefined( level.eyeball_off_luminance_override ) )
	{
		return level.eyeball_off_luminance_override;
	}
	
	return 0;
}

function get_eyeball_color()  // self = zombie
{
	val = 0;
	
	if ( IsDefined( level.zombie_eyeball_color_override ) )
	{
		val = level.zombie_eyeball_color_override;
	}
	
	if ( IsDefined( self.zombie_eyeball_color_override ) )
	{
		val = self.zombie_eyeball_color_override;
	}
	
	return val;
}

function zombie_ragdoll_explode_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self zombie_wait_explode( localClientNum );
	}
}

function zombie_gut_explosion_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(level._effect["zombie_guts_explosion"]))
		{
			org = self GetTagOrigin("J_SpineLower");
			
			if(isdefined(org))
			{
				playfx( localClientNum, level._effect["zombie_guts_explosion"], org ); 	 
			}
		}
	}
}

function init_zombie_explode_fx()
{
	level._effect["zombie_guts_explosion"]      = "zombie/fx_blood_torso_explo_lg_zmb";
}


function zombie_wait_explode( localClientNum )
{
	where = self GetTagOrigin( "J_SpineLower" );
	if (!isdefined(where))
		where = self.origin;

	start = GetTime();
	while ( GetTime() - start < 2000 )
	{
		if (isdefined(self))
		{
			where = self GetTagOrigin( "J_SpineLower" );
			if (!isdefined(where))
				where = self.origin;
		}
		wait 0.05;
	}

	if ( IsDefined( level._effect[ "zombie_guts_explosion" ] ) && util::is_mature() )
	{
		Playfx( localClientNum, level._effect["zombie_guts_explosion"], where );
	}
	
}

function mark_piece_gibbed( piece_index )
{
	if ( !isdefined( self.gibbed_pieces ) )
	{
		self.gibbed_pieces = [];
	}

	self.gibbed_pieces[self.gibbed_pieces.size] = piece_index;
}


function has_gibbed_piece( piece_index )
{
	if ( !isdefined( self.gibbed_pieces ) )
	{
		return false;
	}

	for ( i = 0; i < self.gibbed_pieces.size; i++ )
	{
		if ( self.gibbed_pieces[i] == piece_index )
		{
			return true;
		}
	}

	return false;
}


function do_headshot_gib_fx()
{
	fxTag = "j_neck";
	fxOrigin = self GetTagOrigin( fxTag );
	upVec = AnglesToUp( self GetTagAngles( fxTag ) );
	forwardVec = AnglesToForward( self GetTagAngles( fxTag ) );

	players = level.localPlayers;

	for ( i = 0; i < players.size; i++ )
	{
		// main head pop fx
		PlayFX( i, level._effect["headshot"], fxOrigin, forwardVec, upVec );
		PlayFX( i, level._effect["headshot_nochunks"], fxOrigin, forwardVec, upVec );
	}

	PlaySound( 0, "zmb_zombie_head_gib", fxOrigin );	// Brought over from _zm_spawner.gsc by DSL 03/15/13
	
	wait( 0.3 );
	if ( IsDefined( self ) )
	{
		players = level.localPlayers;

		for ( i = 0; i < players.size; i++ )
		{
			PlayFxOnTag( i, level._effect["bloodspurt"], self, fxTag );
		}
	}
}

function do_gib_fx( tag )
{
	players = level.localPlayers;
	
	for ( i = 0; i < players.size; i++ )
	{
		PlayFxOnTag( i, level._effect["animscript_gib_fx"], self, tag ); 
	}
	PlaySound( 0, "zmb_death_gibs", self gettagorigin( tag ) );
}


function do_gib( model, tag )
{
	//PrintLn( "*** Generating gib " + model + " from tag " + tag );

	start_pos = self gettagorigin( tag );
	start_angles = self gettagangles(tag);
	
	wait( 0.016 );
	
	end_pos = undefined;
	angles = undefined;
	
	if(!IsDefined(self))
	{
		end_pos = start_pos + (AnglesToForward(start_angles) * 10);
		angles = start_angles;
	}	
	else
	{
		end_pos = self gettagorigin( tag );
		angles = self gettagangles(tag);
	}

	if ( IsDefined( self._gib_vel ) )
	{
		forward = self._gib_vel;
		self._gib_vel = undefined;
	}
	else
	{
		forward = VectorNormalize( end_pos - start_pos ); 
		forward *= RandomFloatRange( 0.6, 1.0 );      
		forward += (0, 0, RandomFloatRange( 0.4, 0.7 )); 
//		forward *= 2.0;
	}

	CreateDynEntAndLaunch( 0, model, end_pos, angles, start_pos, forward, level._effect["animscript_gibtrail_fx"], 1 );

	if(IsDefined(self))
	{
		self do_gib_fx( tag );
	}
	else
	{
		PlaySound( 0, "zmb_death_gibs", end_pos);
	}
}

// hat gibs look better when they pop off almost straight up
function do_hat_gib( model, tag )
{
	//PrintLn( "*** Generating gib " + model + " from tag " + tag );

	start_pos = self gettagorigin( tag );
	start_angles = self gettagangles( tag );
	up_angles = (0, 0, 1);

	force = (0, 0, RandomFloatRange( 1.4, 1.7 ));

	CreateDynEntAndLaunch( 0, model, start_pos, up_angles, start_pos, force );
}

function check_should_gib()
{
	if( level.gibCount<=level.gibMaxCount )
	{
		return true;
	}
	return false;
}

function resetGibCounter()
{
	self endon( "disconnect" );
	
	while(1)
	{	
		wait( level.gibResetTime );
		level.gibTimer = 0;
		level.gibCount = 0;
	}
}

function on_gib_event( localClientNum, type, locations )
{
	if ( localClientNum != 0 )
	{
		return;
	}

	if( !util::is_mature() )
	{
		return;
	}

	if ( !isDefined( self._gib_def ) )
	{
		return;
	}

	if ( IsDefined( level._gib_overload_func ) )
	{
		if ( self [[level._gib_overload_func]]( type, locations ) )
		{
			return;	// if overload func returns true - do more more processing.
		}
	}

	if( !check_should_gib() )
	{
		return;
	}
	level.gibCount++;

	for ( i = 0; i < locations.size; i++ )
	{
		// only the head can gib after already gibbing
		if ( IsDefined( self.gibbed ) && level._ZOMBIE_GIB_PIECE_INDEX_HEAD != locations[i] )
		{
			continue;
		}

		switch( locations[i] )
		{
			case 0: // level._ZOMBIE_GIB_PIECE_INDEX_ALL
				if ( IsDefined( self._gib_def.gibSpawn1 ) && IsDefined( self._gib_def.gibSpawnTag1 ) )
				{
					self thread do_gib( self._gib_def.gibSpawn1, self._gib_def.gibSpawnTag1 );
				}
				if ( IsDefined( self._gib_def.gibSpawn2 ) && IsDefined( self._gib_def.gibSpawnTag2 ) )
				{
					self thread do_gib( self._gib_def.gibSpawn2, self._gib_def.gibSpawnTag2 );
				}
				if ( IsDefined( self._gib_def.gibSpawn3 ) && IsDefined( self._gib_def.gibSpawnTag3 ) )
				{
					self thread do_gib( self._gib_def.gibSpawn3, self._gib_def.gibSpawnTag3 );
				}
				if ( IsDefined( self._gib_def.gibSpawn4 ) && IsDefined( self._gib_def.gibSpawnTag4 ) )
				{
					self thread do_gib( self._gib_def.gibSpawn4, self._gib_def.gibSpawnTag4 );
				}
				if ( IsDefined( self._gib_def.gibSpawn5 ) && IsDefined( self._gib_def.gibSpawnTag5 ) )
				{
					self thread do_hat_gib( self._gib_def.gibSpawn5, self._gib_def.gibSpawnTag5 );
				}

				self thread do_headshot_gib_fx(); // head
				self thread do_gib_fx( "J_SpineLower" ); //guts

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM );
				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM );
				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG );
				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG );
				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_HEAD );
				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_HAT );
				break;

			case 1: // level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM
				if ( IsDefined( self._gib_def.gibSpawn1 ) && IsDefined( self._gib_def.gibSpawnTag1 ) )
				{
					self thread do_gib( self._gib_def.gibSpawn1, self._gib_def.gibSpawnTag1 );
				}
				else
				{
					if ( !IsDefined( self._gib_def.gibSpawn1 ) )
					{
					}
					if ( !IsDefined( self._gib_def.gibSpawnTag1 ) )
					{
					}
				}

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM );
				break;

			case 2: // level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM
				if ( IsDefined( self._gib_def.gibSpawn2 ) && IsDefined(self._gib_def.gibSpawnTag2 ) )
				{
					self thread do_gib( self._gib_def.gibSpawn2, self._gib_def.gibSpawnTag2 );
				}
				else
				{
					if ( !IsDefined( self._gib_def.gibSpawn2 ) )
					{
					}
					if ( !IsDefined( self._gib_def.gibSpawnTag2 ) )
					{
					}
				}

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM );
				break;

			case 3: // level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG
				if ( IsDefined( self._gib_def.gibSpawn3 ) && IsDefined( self._gib_def.gibSpawnTag3 ) )
				{
					self thread do_gib( self._gib_def.gibSpawn3, self._gib_def.gibSpawnTag3 );
				}

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG );
				break;

			case 4: // level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG
				if ( IsDefined( self._gib_def.gibSpawn4 ) && IsDefined( self._gib_def.gibSpawnTag4 ) )
				{
					self thread do_gib( self._gib_def.gibSpawn4, self._gib_def.gibSpawnTag4 );
				}

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG );
				break;

			case 5: // level._ZOMBIE_GIB_PIECE_INDEX_HEAD, fx only
				self thread do_headshot_gib_fx();

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_HEAD );
				break;

			case 6: // level._ZOMBIE_GIB_PIECE_INDEX_GUTS, fx only
				self thread do_gib_fx( "J_SpineLower" );
				break;

			case 7: // level._ZOMBIE_GIB_PIECE_INDEX_HAT, hat launch only, no fx
				if ( IsDefined( self._gib_def.gibSpawn5 ) && IsDefined( self._gib_def.gibSpawnTag5 ) )
				{
					self thread do_hat_gib( self._gib_def.gibSpawn5, self._gib_def.gibSpawnTag5 );
				}

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_HAT );
				break;
		} 
	}

	self.gibbed = true;
}


// ww: function stores the vision set passed in and then applies it to the local player the function is threaded
// on. visionsets will be set up in a priority queue, whichever is the highest scoring vision set will be applied
// priorities should not go over ten! ten is only reserved for sets that must trump any and all (e.g. black hole bomb )
// SELF == PLAYER
function zombie_vision_set_apply( str_visionset, int_priority, flt_transition_time, int_clientnum )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	// make sure the vision set list is on the player
	if( !IsDefined( self._zombie_visionset_list ) )
	{
		// if not create it
		self._zombie_visionset_list = [];
	}
	
	// make sure the variables passed in are valid
	if( !IsDefined( str_visionset ) || !IsDefined( int_priority ) )
	{
		return;
	}
	
	// default flt_transition_time
	if( !IsDefined( flt_transition_time ) )
	{
		flt_transition_time = 1;
	}
	
	if( !IsDefined( int_clientnum ) )
	{
		if ( self IsLocalPlayer() )
		{
			int_clientnum = self GetLocalClientNumber();
		}
		
		if(!IsDefined(int_clientnum))
		{
			return;	// GetLocalClientNumber fails for spectators - get out.
		}
	}
	
	// make sure there isn't already one of the vision set in the array
	already_in_array = false;
	
	// if the array already has items in it check for duplictes
	if( self._zombie_visionset_list.size != 0 )
	{
		for( i = 0; i < self._zombie_visionset_list.size; i++ )
		{
			if( IsDefined( self._zombie_visionset_list[i].vision_set ) && self._zombie_visionset_list[i].vision_set == str_visionset )
			{
				already_in_array = true;
				
				// if the priority is different change it and 
				if( self._zombie_visionset_list[i].priority != int_priority )
				{
					// reset the priority based on the new int_priority
					self._zombie_visionset_list[i].priority = int_priority;
				}
				
				break;
				
			}
			
			// check to see if there is a visionset with this priority
		}
	}

	
	// if it isn't in the array add it
	if( !already_in_array )
	{
		// add the new vision set to the array
		temp_struct = spawnStruct();
		temp_struct.vision_set = str_visionset;
		temp_struct.priority = int_priority;
		array::add( self._zombie_visionset_list, temp_struct, false );
	}
	
	// now go through the player's list and find the one with highest priority	
	vision_to_set = self zombie_highest_vision_set_apply();
	
	if( IsDefined( vision_to_set ) )
	{
		// now you have the highest scoring vision set, apply to player
		VisionSetNaked( int_clientnum, vision_to_set, flt_transition_time );
	}
	else
	{
		// now you have the highest scoring vision set, apply to player
		VisionSetNaked( int_clientnum, "undefined", flt_transition_time );
	}
	
}

// ww: removes the vision set from the vision set array, goes through the array and sets the next highest priority
// SELF == PLAYER
function zombie_vision_set_remove( str_visionset, flt_transition_time, int_clientnum )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	// make sure hte vision set is passed in
	if( !IsDefined( str_visionset ) )
	{
		return;
	}
	
	// default transition time
	if( !IsDefined( flt_transition_time ) )
	{
		flt_transition_time = 1;
	}
	
	// can't call this before the array has been set up through apply
	if( !IsDefined( self._zombie_visionset_list ) )
	{
		self._zombie_visionset_list = [];
	}
	
	// get the player's client number if it wasn't passed in
	if( !IsDefined( int_clientnum ) )
	{
		if ( self IsLocalPlayer() )
		{
			int_clientnum = self GetLocalClientNumber();
		}
		
		if(!IsDefined(int_clientnum))
		{
			return;	// GetLocalClientNumber fails for spectators - get out.
		}
	}
	
	// remove the vision set from the array
	temp_struct = undefined;
	for( i = 0; i < self._zombie_visionset_list.size; i++ )
	{
		if( IsDefined( self._zombie_visionset_list[i].vision_set ) && self._zombie_visionset_list[i].vision_set == str_visionset )
		{
			temp_struct = self._zombie_visionset_list[i];
		}
	}
	
	if( IsDefined( temp_struct ) )
	{
		ArrayRemoveValue( self._zombie_visionset_list, temp_struct );
	}
	
	// set the next highest priority	
	vision_to_set = self zombie_highest_vision_set_apply();
	
	if( IsDefined( vision_to_set ) )
	{
		// now you have the highest scoring vision set, apply to player
		VisionSetNaked( int_clientnum, vision_to_set, flt_transition_time );
	}
	else
	{
		// now you have the highest scoring vision set, apply to player
		VisionSetNaked( int_clientnum, "undefined", flt_transition_time );
	}
}

// ww: apply the highest score vision set
function zombie_highest_vision_set_apply()
{
	if( !IsDefined( self._zombie_visionset_list ) )
	{
		return;
	}
	
	highest_score = 0;
	highest_score_vision = undefined;
	
	//PrintLn( "******************************* " + self GetLocalClientNumber() + " ******************************" );
	//PrintLn( "******************************* " + self._zombie_visionset_list.size + " ******************************" );
	
	for( i = 0; i < self._zombie_visionset_list.size; i++ )
	{
		if( IsDefined( self._zombie_visionset_list[i].priority ) && self._zombie_visionset_list[i].priority > highest_score )
		{
			highest_score = self._zombie_visionset_list[i].priority;
			highest_score_vision = self._zombie_visionset_list[i].vision_set;
			//PrintLn( "******************************* " + self._zombie_visionset_list[i].priority + " ******************************" );
			//PrintLn( "******************************* " + self._zombie_visionset_list[i].vision_set + " ******************************" );
		}
	}
	
	return highest_score_vision;
}

function handle_zombie_risers_foliage(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	
	if ( !oldVal && newVal )
	{
		localPlayers = level.localPlayers;
  		playsound(0,"zmb_zombie_spawn", self.origin); // TODO: foliage spawn sound?

		burst_fx = level._effect["rise_burst_foliage"];
		billow_fx = level._effect["rise_billow_foliage"];
		type = "foliage";

  		for(i = 0; i < localPlayers.size; i ++)
		{
			self thread rise_dust_fx(i,type,billow_fx,burst_fx);
		}
	}
}

function handle_zombie_risers_water(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	
	if ( !oldVal && newVal )
	{
		localPlayers = level.localPlayers;
  		playsound(0,"zmb_zombie_spawn_water", self.origin);		

		burst_fx = level._effect["rise_burst_water"];
		billow_fx = level._effect["rise_billow_water"];
		type = "water";
  		
  		for(i = 0; i < localPlayers.size; i ++)
		{
			self thread rise_dust_fx(i,type,billow_fx,burst_fx);
		}
	}
}


function handle_zombie_risers(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	
	if ( !oldVal && newVal )
	{
		localPlayers = level.localPlayers;
		
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst"];
		billow_fx = level._effect["rise_billow"];
		type = "dirt";
		
		if(isdefined(level.riser_type) && level.riser_type == "snow" )
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}		

  		playsound (0,sound, self.origin);
		
		for(i = 0; i < localPlayers.size; i ++)
		{
			self thread rise_dust_fx(i,type,billow_fx,burst_fx);
		}
	}

}

function handle_zombie_risers_lowg(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	
	if ( !oldVal && newVal )
	{
		localPlayers = level.localPlayers;
		
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst_lg"];
		billow_fx = level._effect["rise_billow_lg"];
		type = "dirt";
		
		if(isdefined(level.riser_type) && level.riser_type == "snow" )
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}

  		playsound (0,sound, self.origin);
		
		for(i = 0; i < localPlayers.size; i ++)
		{
			self thread rise_dust_fx(i,type,billow_fx,burst_fx);
		}
	}

}

function rise_dust_fx( clientnum, type, billow_fx, burst_fx )
{
	dust_tag = "J_SpineUpper";
	
	self endon("entityshutdown");
	level endon("demo_jump");
	
	if ( IsDefined( level.zombie_custom_riser_fx_handler ) )
	{
		s_info = self [[ level.zombie_custom_riser_fx_handler ]]();
		
		if ( IsDefined( s_info ) )
		{
			if ( IsDefined( s_info.burst_fx ) )
			{
				burst_fx = s_info.burst_fx;
			}
			
			if ( IsDefined( s_info.billow_fx ) )
			{
				billow_fx = s_info.billow_fx;
			}
			
			if ( IsDefined( s_info.type ) )
			{
				type = s_info.type;
			}
		}
	}	
	
	if ( IsDefined( burst_fx ) )
	{
		playfx(clientnum,burst_fx,self.origin + ( 0,0,randomintrange(5,10) ) );
	}
	
	wait(.25);
	
	if ( IsDefined( billow_fx ) )
	{
		playfx(clientnum,billow_fx,self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
	}
	
	wait(2);	//wait a bit to start playing the falling dust 
	dust_time = 5.5; // play dust fx for a max time
	dust_interval = .3; //randomfloatrange(.1,.25); // wait this time in between playing the effect
	
	player = level.localPlayers[clientnum];
	
	effect = level._effect["rise_dust"];
	
	if(type == "water")
	{
		effect = level._effect["rise_dust_water"];
	}
	else if ( type == "snow")
	{
		effect = level._effect["rise_dust_snow"];
	}
	else if ( type == "foliage" )
	{
		effect = level._effect["rise_dust_foliage"];
	}
	else if ( type == "none" )
	{
		return;
	}
		
	for (t = 0; t < dust_time; t += dust_interval)
	{
		if (!isdefined(self))
			return; 
		PlayfxOnTag(clientnum,effect, self, dust_tag);
		wait dust_interval;
	}

}

function end_last_stand(clientNum)
{
	self waittill("lastStandEnd");

	waitrealtime(0.7);
	
	playsound(clientNum, "revive_gasp");
}

function last_stand_thread(clientNum)
{
	self thread end_last_stand(clientNum);
	
	self endon("lastStandEnd");
	
	const startVol = 0.5;
	const maxVol = 1.0;
	
	const startPause = 0.5;
	const maxPause = 2.0;
	
	pause = startPause;
	vol = startVol;
	
	while(1)
	{
		id = playsound(clientNum, "chr_heart_beat");
		setSoundVolume(id, vol);
		//iprintlnbold( "LASTSTAND ON CLIENT " + clientNum );
		
		waitrealtime(pause);
		
		if(pause < maxPause)
		{
			pause *= 1.05;
			
			if(pause > maxPause)
			{
				pause = maxPause;
			}
		}
		
		if(vol < maxVol)
		{
			vol *= 1.05;
			
			if(vol > maxVol)
			{
				vol = maxVol;
			}
		}
	}
}

function last_stand_monitor(clientNum, state, oldState)
{
	player = level.localPlayers[clientNum];
	players = level.localPlayers;
	
	if(!isdefined(player))
	{
		return;
	}
	
	if(state == "1")
	{
		if(!level._laststand[clientNum])
		{
			if(!isdefined(level.lslooper))
			{
				level.lslooper = spawn(0, player.origin, "script.origin");
			}	
			player thread last_stand_thread(clientNum);
			
			//Check to make sure this sound doesn't play during a splitscreen game
			if( players.size <= 1 )
			{
			    level.lslooper playloopsound("evt_laststand_loop", 0.3);
			}
			
			level._laststand[clientNum] = true;
		}
	}
	else
	{
		if(level._laststand[clientNum])
		{
			if(isdefined(level.lslooper))
			{
				level.lslooper StopAllLoopSounds(0.7);
				
				playsound (0, "evt_laststand_in", (0,0,0));
			}	
			player notify("lastStandEnd");
			level._laststand[clientNum] = false;
		}
	}
}

function Laststand(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if( !( self IsPlayer() && self IsLocalPlayer() && IsDemoPlaying() ) )
		{
			self duplicate_render::set_dr_flag( "keyline_ls", 1 );
			self duplicate_render::update_dr_filters(localClientNum);
		}
	}
	else
	{
		self duplicate_render::set_dr_flag( "keyline_ls", 0 );
		self duplicate_render::update_dr_filters(localClientNum);
	}
	if( self IsPlayer() && self IsLocalPlayer() && !IsDemoPlaying() )
	{
		if( IsDefined(self GetLocalClientNumber()) && localClientNum == self GetLocalClientNumber() )
			self zm_audio::sndZmbLaststand(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump); 
	}
}

function update_aat_hud( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{           
	str_localized = aat::get_string( newVal );
	icon = aat::get_icon( newVal );

	if( str_localized == AAT_RESERVED_NAME )
		str_localized = "";

	controllerModel = GetUIModelForController( localClientNum );
	AATModel = CreateUIModel( controllerModel, "CurrentWeapon.aat" );
	SetUIModelValue( AATModel, str_localized );

	AATIconModel = CreateUIModel( controllerModel, "CurrentWeapon.aatIcon" );
	SetUIModelValue( AATIconModel, icon );
}
