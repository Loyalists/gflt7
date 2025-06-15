#using scripts\codescripts\struct;

#using scripts\shared\_oob;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\statstable_shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\zmSaveData;
#using scripts\zm\gametypes\_clientids;

#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_blockers;

// NSZ Zombie Money Powerup
#using scripts\_NSZ\nsz_powerup_money;
// //bottomless clip
// #using scripts\_NSZ\nsz_powerup_bottomless_clip;
// // NSZ Zombie Blood Powerup
// #using scripts\_NSZ\nsz_powerup_zombie_blood;

//bo4 max ammo
#using scripts\zm\bo4_full_ammo;

//better nuke
#using scripts\zm\better_nuke;

//hit markers
// #using scripts\zm\zm_damagefeedback;
#using scripts\zm\_hb21_zm_hitmarkers;

//Custom Powerups By ZoekMeMaar
#using scripts\_ZoekMeMaar\custom_powerup_free_packapunch_with_time;

#using scripts\zm\infinityloader;
#using scripts\zm\roamer;

#using scripts\gfl\zm\gameplay;
#using scripts\gfl\zm\bo4_carpenter;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;

#namespace tfoptions;

function autoexec auto_preload()
{
    level.tfoptions_default = [];
    level.tfoptions_default["max_ammo"] = 0;
    level.tfoptions_default["higher_health"] = 100; 
    level.tfoptions_default["no_perk_lim"] = 0; 
    level.tfoptions_default["more_powerups"] = 2;
    level.tfoptions_default["bigger_mule"] = 0;
    level.tfoptions_default["extra_cash"] = 0;
    level.tfoptions_default["weaker_zombs"] = 0;
    level.tfoptions_default["roamer_enabled"] = 0; 
    level.tfoptions_default["roamer_time"] = 0;
    level.tfoptions_default["zcounter_enabled"] = 0; 
    level.tfoptions_default["starting_round"] = 1;
    level.tfoptions_default["perkaholic"] = 0;
    level.tfoptions_default["exo_movement"] = 0;
    level.tfoptions_default["perk_powerup"] = 0;
    level.tfoptions_default["melee_bonus"] = 0;
    level.tfoptions_default["headshot_bonus"] = 0;
    level.tfoptions_default["zombs_always_sprint"] = 0;
    level.tfoptions_default["max_zombies"] = 24;
    level.tfoptions_default["no_delay"] = 0;
    level.tfoptions_default["start_rk5"] = 0;
    level.tfoptions_default["hitmarkers"] = 0;
    level.tfoptions_default["zcash_powerup"] = 0;
    level.tfoptions_default["starting_points"] = 500;
    level.tfoptions_default["no_round_delay"] = 0;
    level.tfoptions_default["bo4_max_ammo"] = 0;
    level.tfoptions_default["better_nuke"] = 0;
    level.tfoptions_default["better_nuke_points"] = 0;
    level.tfoptions_default["packapunch_powerup"] = 0;
    level.tfoptions_default["spawn_with_quick_res"] = 0;
    level.tfoptions_default["bo4_carpenter"] = 0;
    level.tfoptions_default["bottomless_clip_powerup"] = 0;
    level.tfoptions_default["zblood_powerup"] = 0;
    level.tfoptions_default["timed_gameplay"] = 0;
    level.tfoptions_default["move_speed"] = 100;
    level.tfoptions_default["tf_enabled"] = 0;
    level.tfoptions_default["open_all_doors"] = 0;
    level.tfoptions_default["every_box"] = 0;
    level.tfoptions_default["random_weapon"] = 0;
    level.tfoptions_default["start_bowie"] = 0;
    level.tfoptions_default["start_power"] = 0;
    level.tfoptions_default["perkplus"] = 0;
    level.tfoptions_default["bot"] = 0;
    level.tfoptions_default["roundrevive"] = 0;
    level.tfoptions_default["randomize_character"] = 0;
    level.tfoptions_default["perk_lose"] = 0;
    level.tfoptions_default["bot_count"] = 1;
    level.tfoptions_default["boxshare"] = 0;
    level.tfoptions_default["bot_command"] = 0;
    level.tfoptions_default["bgb_loadout"] = 0;
    level.tfoptions_default["cheats"] = 0;
    level.tfoptions_default["fixed_cost"] = 0;
    level.tfoptions_default["bgb_cost"] = 1;
    level.tfoptions_default["modmenu"] = 0;
    level.tfoptions_default["player_determined_character"] = 0;
    level.tfoptions_default["disable_intro_movie"] = 0;
    level.tfoptions_default["bgb_uses"] = 0;
    level.tfoptions_default["friendlyfire"] = 0;
    level.tfoptions_default["tdoll_zombie"] = 0;
    level.tfoptions_default["bgb_off"] = 0;
    level.tfoptions_default["subtitles"] = 0;
    level.tfoptions_default["cw_scoreevent"] = 0;
    level.tfoptions_default["thirdperson"] = 0;
    level.tfoptions_default["zombie_healthbar"] = 0;
    level.tfoptions_default["hud"] = 0;
    level.tfoptions_default["hitmarkers_sound"] = 0;
    level.tfoptions_default["objectives"] = 0;
    level.tfoptions_default["checkpoints"] = 0;

    if( !GetDvarInt("tfoption_tf_enabled", 0) )
    {
        set_default_tfoptions();
    }
    
    level.tfoptions_old = [];
    level.tfoptions_old_zombie_vars = [];
    set_old_tfoptions();
}

function init()
{
    pre_load();
    load_tf_options();
}

function set_default_tfoptions()
{
    options = GetArrayKeys(level.tfoptions_default);
    foreach (option in options)
    {
        value = level.tfoptions_default[option];
        set_tfoption_dvar(option, value);
    }
}

function set_old_tfoptions()
{
    options = GetArrayKeys(level.tfoptions_default);
    foreach (option in options)
    {
        default_value = level.tfoptions_default[option];
        value = GetDvarInt("tfoption_" + option, default_value);
        level.tfoptions_old[option] = value;
    }
}

function set_tfoption_dvar(option, value)
{
    if (!isdefined(option))
    {
        return;
    }

    if (option == "")
    {
        return;
    }

    SetDvar("tfoption_" + option, value);
}

function pre_load()
{
    gameplay::init();

	if ( GetDvarInt("tfoption_modmenu", 0) )
	{
		infinityloader::init();
	}

	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
}

function on_player_connect()
{
	self endon("disconnect");

    self wait_for_tfoptions_changed();
}

function on_player_spawned()
{
	self endon("disconnect");
	self endon("bled_out");

    //perkaholic
    if( GetDvarInt("tfoption_perkaholic", 0) ) 
    {
        self thread give_perkaholic();
    }

    if( !GetDvarInt("tfoption_perkaholic", 0) && GetDvarInt("tfoption_spawn_with_quick_res", 0) ) 
    {
        self thread give_quickrevive();
    }
    
    //start with bowie knife
    if( GetDvarInt("tfoption_start_bowie", 0) )
    {
        self thread give_bowie_knife();
    }

    // exo movement
    if( GetDvarInt("tfoption_exo_movement", 0) ) {
        self thread enable_exo_movement();
    }

    //give random starting weapon
    if( GetDvarInt("tfoption_random_weapon", 0) ) {
        self thread give_random_weapon();
    }

    //start rk5
    if( GetDvarInt("tfoption_start_rk5", 0) ) {
        self thread give_rk5();
    }

    //max ammo
    if ( GetDvarInt("tfoption_max_ammo", 0) ) {
        self thread give_max_ammo();
    }
}

function wait_for_tfoptions_changed()
{
	self endon("disconnect");

    if (self IsTestClient())
    {
        return;
    }

    while (true)
    {
        WAIT_SERVER_FRAME;
		self waittill("menuresponse", menu, response);
        if ( !self IsHost() )
        {
            wait 5;
            continue;
        }

        if ( !(menu == "popup_leavegame" && response == "TFOptionsChanged" ) )
        {
            continue;
        }

        if ( !GetDvarInt("tfoption_tf_enabled", 0) )
        {
            if (level.tfoptions_old["tf_enabled"] != 0)
            {
                set_default_tfoptions();
            }
            else
            {
                continue;
            }
        }

        options = GetArrayKeys(level.tfoptions_old);
        foreach (option in options)
        {
            value = GetDvarInt("tfoption_" + option);
            old_value = level.tfoptions_old[option];
            if (value == old_value)
            {
                continue;
            }

            level.tfoptions_old[option] = value;
            level notify("tfoption_" + option + "_changed", value, old_value);
            // self IPrintLnBold("tfoption_" + option + "_changed");
            WAIT_SERVER_FRAME;
        }
    }
}

function wait_for_player_options_changed()
{
	level endon("game_ended");
	level endon("end_game");

    while (true)
    {
        move_speed = GetDvarInt("tfoption_move_speed", 100);
        if ( move_speed != 0 ) 
        {
            g_speed = int(level._g_speed_old * (move_speed / 100));
            SetDvar("g_speed", g_speed);
        }

        higher_health = GetDvarInt("tfoption_higher_health", 100);
        zombie_utility::set_zombie_var( "player_base_health", higher_health, false);
        foreach(player in level.activeplayers)
        {
            player zm_perks::perk_set_max_health_if_jugg( "health_reboot", true, true );
        }

        WAIT_SERVER_FRAME;
        level util::waittill_any_return("tfoption_move_speed_changed", "tfoption_higher_health_changed");
    }
}

function wait_for_more_powerups_changed()
{
	level endon("game_ended");
	level endon("end_game");

    while (true)
    {
        more_powerups_default = 2;

        increment = 2000;
        maxdrop = 4;
        switch( GetDvarInt("tfoption_more_powerups", more_powerups_default) ) 
        {
            case 0:
                increment = 20000;
                maxdrop = 0;
                break;
            case 1:
                increment = 3000;
                maxdrop = 2;
                break;
            case 2:
                increment = 2000;
                maxdrop = 4;
                break;
            case 3:
                increment = 1700;
                maxdrop = 8;
                break;
            case 4:
                increment = 1000;
                maxdrop = 50;
                break;
            case 5:
                increment = 1;
                maxdrop = 500;
                break;
            default:
                break;
        }
        zombie_utility::set_zombie_var( "zombie_powerup_drop_increment", increment );
        zombie_utility::set_zombie_var( "zombie_powerup_drop_max_per_round", maxdrop );

        WAIT_SERVER_FRAME;
        level util::waittill_any_return("tfoption_more_powerups_changed");
    }
}

function wait_for_perk_options_changed()
{
	level endon("game_ended");
	level endon("end_game");

    while (true)
    {
        //bigger mulekick (4gun)
        if( GetDvarInt("tfoption_bigger_mule", 0) ) 
        {
            level.additionalprimaryweapon_limit = 4;
        }
        else
        {
            level.additionalprimaryweapon_limit = level._additionalprimaryweapon_limit_old;
        }

        no_perk_lim = GetDvarInt("tfoption_no_perk_lim", 0);
        if ( no_perk_lim )
        {
            level.perk_purchase_limit = 50;
        }
        else
        {
            level.perk_purchase_limit = level._perk_purchase_limit_old;
        }

        WAIT_SERVER_FRAME;
        level util::waittill_any_return("tfoption_no_perk_lim_changed", "tfoption_bigger_mule_changed");
    }
}

function wait_for_zombie_bonus_options_changed()
{
	level endon("game_ended");
	level endon("end_game");

    while (true)
    {
        //extra cash
        extra_cash = GetDvarInt("tfoption_extra_cash", 0);
        if( extra_cash ) 
        {
            zombie_utility::set_zombie_var( "zombie_score_kill_4player", 		level.tfoptions_old_zombie_vars["zombie_score_kill_4player"] + extra_cash );
            zombie_utility::set_zombie_var( "zombie_score_kill_3player",		level.tfoptions_old_zombie_vars["zombie_score_kill_3player"] + extra_cash );
            zombie_utility::set_zombie_var( "zombie_score_kill_2player",		level.tfoptions_old_zombie_vars["zombie_score_kill_2player"] + extra_cash );
            zombie_utility::set_zombie_var( "zombie_score_kill_1player",		level.tfoptions_old_zombie_vars["zombie_score_kill_1player"] + extra_cash );
        }
        else
        {
            zombie_utility::set_zombie_var( "zombie_score_kill_4player", 		level.tfoptions_old_zombie_vars["zombie_score_kill_4player"] );
            zombie_utility::set_zombie_var( "zombie_score_kill_3player",		level.tfoptions_old_zombie_vars["zombie_score_kill_3player"] );
            zombie_utility::set_zombie_var( "zombie_score_kill_2player",		level.tfoptions_old_zombie_vars["zombie_score_kill_2player"] );
            zombie_utility::set_zombie_var( "zombie_score_kill_1player",		level.tfoptions_old_zombie_vars["zombie_score_kill_1player"] );
        }

        //melee + headshot bonus
        melee_bonus = GetDvarInt("tfoption_melee_bonus", 0);
        old_melee_bonus = level.tfoptions_old_zombie_vars["zombie_score_bonus_melee"];
        if( melee_bonus )
        {
            zombie_utility::set_zombie_var( "zombie_score_bonus_melee", old_melee_bonus + melee_bonus );
        }
        else
        {
            zombie_utility::set_zombie_var( "zombie_score_bonus_melee", old_melee_bonus );
        }

        headshot_bonus = GetDvarInt("tfoption_headshot_bonus", 0);
        old_headshot_bonus = level.tfoptions_old_zombie_vars["zombie_score_bonus_head"];
        if( headshot_bonus )
        {
            zombie_utility::set_zombie_var( "zombie_score_bonus_head", old_headshot_bonus + headshot_bonus );
        }
        else
        {
            zombie_utility::set_zombie_var( "zombie_score_bonus_head", old_headshot_bonus );
        }

        WAIT_SERVER_FRAME;
        level util::waittill_any_return("tfoption_extra_cash_changed", "tfoption_melee_bonus_changed", "tfoption_headshot_bonus_changed");
    }
}

function wait_for_zombie_options_changed()
{
	level endon("game_ended");
	level endon("end_game");

    while (true)
    {
        //weaker zombs
        if( GetDvarInt("tfoption_weaker_zombs", 0) ) 
        {
            zombie_utility::set_zombie_var( "zombie_health_increase_multiplier", 0.075, true);
        }
        else
        {
            old_multiplier = level.tfoptions_old_zombie_vars["zombie_health_increase_multiplier"];
            zombie_utility::set_zombie_var( "zombie_health_increase_multiplier", old_multiplier, true);
        }

        //no spawn delay
        if( GetDvarInt("tfoption_no_delay", 0) ) 
        {
            zombie_utility::set_zombie_var( "zombie_spawn_delay", 0, true);
        }
        else
        {
            old_spawn_delay = level.tfoptions_old_zombie_vars["zombie_spawn_delay"];
            zombie_utility::set_zombie_var( "zombie_spawn_delay", old_spawn_delay, true);
        }

        WAIT_SERVER_FRAME;
        level util::waittill_any_return("tfoption_weaker_zombs_changed", "tfoption_no_delay_changed");
    }
}

function load_tf_options(){
    
    level endon("game_ended");
    level waittill("initial_blackscreen_passed");

    if ( GetDvarInt("developer") ) {
        IPrintLnBold("Loading TF Options! Please Wait...");
    }

    apply_choices();
    thread wait_for_player_options_changed();
    thread wait_for_perk_options_changed();
    thread wait_for_more_powerups_changed();
    thread wait_for_zombie_options_changed();
    thread wait_for_zombie_bonus_options_changed();

    //notify csc for client side scripts
    foreach(player in level.players){
        player util::clientNotify("choices_applied");
    }

    if ( GetDvarInt("developer") ) {
        IPrintLnBold("Options Loaded!");
    }
    
    level notify("menu_closed");
}

function save_old_zombie_var(zvar, default_value)
{
    if ( !isdefined(level.tfoptions_old_zombie_vars) )
    {
        level.tfoptions_old_zombie_vars = [];
    }

    if ( isdefined(level.zombie_vars[zvar]) )
    {
        level.tfoptions_old_zombie_vars[zvar] = level.zombie_vars[zvar];
    }
    else
    {
        level.tfoptions_old_zombie_vars[zvar] = default_value;
    }
}

function apply_choices() {
    //for upgrade powerup
    level.temp_upgraded_time = 30;

    //move speed
    default_speed = GetDvarInt("g_speed", 190);
    level._g_speed_old = default_speed;
    
    //starting points
    startpoints = GetDvarInt("tfoption_starting_points", 500);
    foreach(player in level.players){
        player zm_score::add_to_player_score(startpoints - 500, false);
    }

    //higher health
    level._player_base_health_old = level.zombie_vars["player_base_health"];
    if ( !isdefined(level._player_base_health_old) )
    {
        level._player_base_health_old = 100;
    }
     
    //no perk limit
    level._perk_purchase_limit_old = level.perk_purchase_limit;
    if ( !isdefined(level._perk_purchase_limit_old) )
    {
        level._perk_purchase_limit_old = 4;
    }

    level._additionalprimaryweapon_limit_old = level.additionalprimaryweapon_limit;
    if ( !isdefined(level._additionalprimaryweapon_limit_old) )
    {
        level._additionalprimaryweapon_limit_old = 3;
    }

    //starting round
    starting_round = GetDvarInt("tfoption_starting_round", 1);
    if( starting_round != 0 && starting_round != 1) 
    {
        zm::set_round_number(starting_round);
        level.zombie_move_speed	= starting_round * level.zombie_vars["zombie_move_speed_multiplier"]; 
    }

    save_old_zombie_var("zombie_score_kill_4player", 50);
    save_old_zombie_var("zombie_score_kill_3player", 50);
    save_old_zombie_var("zombie_score_kill_2player", 50);
    save_old_zombie_var("zombie_score_kill_1player", 50);

    save_old_zombie_var("zombie_health_increase_multiplier", 0.1);

    //zombs always sprint
    if( GetDvarInt("tfoption_zombs_always_sprint", 0)) 
    {
        zombie_utility::set_zombie_var( "zombie_move_speed_multiplier", 75,	false );
	    level.zombie_move_speed	= 1090;
        level thread sprintSetter();
    }

    save_old_zombie_var("zombie_score_bonus_melee", 80);
    save_old_zombie_var("zombie_score_bonus_head", 50);

    //max zombie count 
    zombielimit = GetDvarInt("tfoption_max_zombies", 0);
    if(zombielimit != 0 && zombielimit != 24)
    {
        level.zombie_ai_limit = zombielimit;
        level.zombie_actor_limit = zombielimit;
    }

    save_old_zombie_var("zombie_spawn_delay", 2.0);

    //no round delay
    if( GetDvarInt("tfoption_no_round_delay", 0) ) 
    {
        zombie_utility::set_zombie_var( "zombie_between_round_time", 0);
    }

    //bo4 carpenter
    bo4_carpenter::init();

    if ( isdefined(level._custom_powerups["full_ammo"]) )
    {
        level._custom_powerups[ "full_ammo" ]._grab_powerup_old = level._custom_powerups[ "full_ammo" ].grab_powerup;
        level._custom_powerups[ "full_ammo" ].grab_powerup = &grab_full_ammo_wrapper;
    }

    if ( isdefined(level._custom_powerups["nuke"]) )
    {
        level._custom_powerups[ "nuke" ]._grab_powerup_old = level._custom_powerups[ "nuke" ].grab_powerup;
        level._custom_powerups[ "nuke" ].grab_powerup = &grab_nuke_wrapper;
    }

    if ( isdefined(level.zombie_powerups["free_perk"]) )
    {
        level.zombie_powerups["free_perk"]._func_should_drop_with_regular_powerups_old = level.zombie_powerups["free_perk"].func_should_drop_with_regular_powerups;
        level.zombie_powerups["free_perk"].func_should_drop_with_regular_powerups = &free_perk_wrapper;
    }

    //zombie cash powerup
    if( GetDvarInt("tfoption_zcash_powerup", 0) ) 
	{
        nsz_powerup_money::init_zcash_powerup();
    }

    //packapunch powerup
    if( GetDvarInt("tfoption_packapunch_powerup", 0) ) 
    {
        custom_powerup_free_packapunch_with_time::init_packapunch_powerup();
    }

    //bottomless clip
    // if(GetDvarInt("tfoption_bottomless_clip_powerup") == 1) {
    //     nsz_powerup_bottomless_clip::init_bottomless_clip();
    // }
    
    //zombie blood
    // if(GetDvarInt("tfoption_zblood_powerup") == 1) {
    //     nsz_powerup_zombie_blood::init_zblood();
    // }

    //ROAMER MOD
    roamer::init();

    //open all doors on start
    if( GetDvarInt("tfoption_open_all_doors", 0) )
    {
        thread open_all_doors();
    }
    
    //spawn every mystery box
    if( GetDvarInt("tfoption_every_box", 0) ) 
    {
        level thread every_box();
    }

    //start with the power on
    if( GetDvarInt("tfoption_start_power", 0) ) {
        thread start_with_power();
    }
}

function grab_full_ammo_wrapper( player )
{	
    if( GetDvarInt("tfoption_bo4_max_ammo", 0) ) 
    {
        self bo4_full_ammo::grab_full_ammo( player );
    }
    else
    {
        if ( isdefined(level._custom_powerups[ "full_ammo" ]._grab_powerup_old) )
        {
            self [[level._custom_powerups[ "full_ammo" ]._grab_powerup_old]]( player );
        }
    }
}

function grab_nuke_wrapper( player )
{	
    if( GetDvarInt("tfoption_better_nuke", 0) )
    {
        self better_nuke::grab_nuke( player );
    }
    else
    {
        if ( isdefined(level._custom_powerups[ "nuke" ]._grab_powerup_old) )
        {
            self [[level._custom_powerups[ "nuke" ]._grab_powerup_old]]( player );
        }
    }
}

function free_perk_wrapper()
{	
    if( GetDvarInt("tfoption_perk_powerup", 0) ) 
    {
        return zm_powerups::func_should_always_drop();
    }
    else
    {
        if ( isdefined(level.zombie_powerups["free_perk"]._func_should_drop_with_regular_powerups_old) )
        {
            return [[level.zombie_powerups["free_perk"]._func_should_drop_with_regular_powerups_old]]();
        }
    }
}

function give_perkaholic()
{
    self endon("disconnect");
    self endon("bled_out");
    level flag::wait_till( "initial_blackscreen_passed" );

    self thread zm_utility::give_player_all_perks();
}

function give_quickrevive()
{
    self endon("disconnect");
    self endon("bled_out");
    level flag::wait_till( "initial_blackscreen_passed" );

    self zm_perks::give_perk("specialty_quickrevive");
}

function enable_exo_movement()
{
	level endon("game_ended");
	level endon("end_game");
    self endon("disconnect");
    self endon("bled_out");
    level flag::wait_till( "initial_blackscreen_passed" );

    self AllowWallRun(true);
    self AllowDoubleJump(true);
    SetDvar( "doublejump_enabled", 1 );
    SetDvar( "playerEnergy_enabled", 1 );
    SetDvar( "wallrun_enabled", 1 );
    SetDvar( "slide_forceBaseSlide", 0 );
}

function give_max_ammo()
{
    self endon("disconnect");
    self endon("bled_out");
    level flag::wait_till( "initial_blackscreen_passed" );

    foreach(weapon in self GetWeaponsListPrimaries())
    {
        self GiveMaxAmmo(weapon);
    }
}

function open_all_doors() {
    //open all doors test 
    types = array("zombie_door", "zombie_airlock_buy");
    foreach(type in types)
    {
        zombie_doors = GetEntArray(type, "targetname");
        for(i=0;i<zombie_doors.size;i++)
        {
                if(zombie_doors[i]._door_open == 0)
                zombie_doors[i] thread set_doors_open();
        } 
    }
    //remove death barrier 
    level.player_out_of_playable_area_monitor_callback = &out_of_bounds_callback;

    open_all_debris();
}

function private out_of_bounds_callback() {
    return false;
}

function set_doors_open()
{
    while(isdefined(self.door_is_moving) && self.door_is_moving)
        wait .1;

    self zm_blockers::door_opened(0);
}

function open_all_debris()
{
    if(isDefined(level.OpenAllDebris))
        return;

    level.OpenAllDebris = true;
    zombie_debris = GetEntArray("zombie_debris", "targetname");
    foreach(debris in zombie_debris)
    {
        debris.zombie_cost = 0;
        debris notify("trigger", self, true);
    }
}


function every_box() 
{
    array::thread_all(level.chests, &show_mystery_box);
    array::thread_all(level.chests, &enable_chest);
    array::thread_all(level.chests, &fire_sale_box_fix);

    if(GetDvarString("magic_chest_movable") == "1")
        setDvar("magic_chest_movable", "0");
}
    
function fire_sale_box_fix()
{
    level endon("game_ended");
    while(true)
    {
        wait .1;
        level waittill("fire_sale_off");
        self.was_temp = undefined;
    }
}

function enable_chest()
{
    level endon("game_ended");
    while(true) 
    {
        wait .1;
        self.zbarrier waittill("closed");
        thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think);
    }
}

function get_chest_index()
{
    foreach(index, chest in level.chests)
    {
        if(self == chest)
            return index;
    }
    return undefined;
}

function show_mystery_box()
{
    level endon("game_ended");
    if(self zm_magicbox::is_chest_active() || self get_chest_index() == level.chest_index)
        return;
        
    self thread zm_magicbox::show_chest(); 
}

function give_random_weapon() {
    self endon("disconnect");
    self endon("bled_out");
    level flag::wait_till( "initial_blackscreen_passed" );

    //get list of weapons
    keys = GetArrayKeys( level.zombie_weapons );

    // player zm_weapons::weapon_take(level.start_weapon);
    new_weap = array::random(keys);
    while(true) 
    {
        if ( !should_skip_random_weapon(new_weap) )
        {
            break;
        }

        wait 0.05;
        new_weap = array::random(keys);
    }

    self zm_weapons::weapon_give( new_weap );
}

function should_skip_random_weapon(new_weap)
{
    if ( new_weap.name == "defaultweapon" || new_weap.name == "none" )
    {
        return true;
    }

    if ( isdefined(level.start_weapon) && new_weap.name == level.start_weapon.name )
    {
        return true;
    }

    if ( IS_TRUE(new_weap.isriotshield) )
    {
        return true;
    }

    if ( new_weap.name == "bowie_knife" || new_weap.name == "knife" || new_weap.name == "hero_gravityspikes_melee" )
    {
        return true;
    }

    if ( new_weap.name == "bouncingbetty" || new_weap.name == "cymbal_monkey" || new_weap.name == "frag_grenade" || new_weap.name =="octobomb" )
    {
        return true;
    }

    return false;
}

function give_bowie_knife() 
{
    self endon("disconnect");
    self endon("bled_out");
    level flag::wait_till( "initial_blackscreen_passed" );
    
    self zm_weapons::weapon_give( GetWeapon( "bowie_knife" ) );
}

function give_rk5() 
{
    self endon("disconnect");
    self endon("bled_out");
    level flag::wait_till( "initial_blackscreen_passed" );

    if( GetDvarInt("tfoption_start_rk5", 0) ) 
    {
        self zm_weapons::weapon_give( level.super_ee_weapon, false, false, true );
    }
}

function start_with_power(size = 0) 
{
    if(level flag::get("power_on"))
        return;

    Arrays = array("use_elec_switch", "zombie_vending", "zombie_door");
    presets = array("elec", "power", "master");

    for(e=0;e<3;e++)
        size += Arrays[e].size;
    for(e=0;e<size;e++)
        level flag::set("power_on" + e);
        
    foreach(preset in presets)
    {
        trig = getEnt("use_" + preset + "_switch", "targetname");
        if(isDefined(trig))
        {
            trig notify("trigger", self);
            break;
        }
    }
    level flag::set("power_on");
    //remove death barrier 
    level.player_out_of_playable_area_monitor_callback = &out_of_bounds_callback;
}

function sprintSetter() 
{
    level endon("game_ended");    
    while(1) {
        wait .1;
        zombie_utility::set_zombie_var( "zombie_move_speed_multiplier", 	  75,	false );
	    level.zombie_move_speed			= 1090;
        level waittill( "between_round_over" );
    }
}

