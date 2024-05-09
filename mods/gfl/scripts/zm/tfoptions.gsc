#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\util_shared;
#using scripts\shared\_oob;

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

//bo4 carpenter
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\bo4_carpenter;

//better nuke
#using scripts\zm\better_nuke;

//hit markers
#using scripts\zm\zm_damagefeedback;

//Custom Powerups By ZoekMeMaar
#using scripts\_ZoekMeMaar\custom_powerup_free_packapunch_with_time;

//timed gameplay
#using scripts\zm\ugxmods_timedgp;

#using scripts\zm\infinityloader;

#using scripts\gfl\zm\gameplay;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;

#namespace tfoptions;

function init() {
    level.roamer_data = [];
    if( !GetDvarInt("tfoption_tf_enabled", 0) )
    {
        create_tf_options_defaults();
    }
    pre_load();
    load_tf_options();
}

function create_tf_options_defaults() {
    SetDvar("tfoption_max_ammo", 0);
    SetDvar("tfoption_higher_health", 100); 
    SetDvar("tfoption_no_perk_lim", 0); 
    SetDvar("tfoption_more_powerups", 2);
    SetDvar("tfoption_bigger_mule", 0);
    SetDvar("tfoption_extra_cash", 0);
    SetDvar("tfoption_weaker_zombs", 0);
	SetDvar("tfoption_roamer_enabled", 0); 
    SetDvar("tfoption_roamer_time", 0);
    SetDvar("tfoption_zcounter_enabled", 0); 
    SetDvar("tfoption_starting_round", 1);
    SetDvar("tfoption_perkaholic", 0);
    SetDvar("tfoption_exo_movement", 0);
    SetDvar("tfoption_perk_powerup", 0);
    SetDvar("tfoption_melee_bonus", 0);
    SetDvar("tfoption_headshot_bonus", 0);
    SetDvar("tfoption_zombs_always_sprint", 0);
    SetDvar("tfoption_max_zombies", 24);
    SetDvar("tfoption_no_delay", 0);
    SetDvar("tfoption_start_rk5", 0);
    SetDvar("tfoption_hitmarkers", 0);
    SetDvar("tfoption_zcash_powerup", 0);
    SetDvar("tfoption_starting_points", 500);
    SetDvar("tfoption_no_round_delay", 0);
    SetDvar("tfoption_bo4_max_ammo", 0);
    SetDvar("tfoption_better_nuke", 0);
    SetDvar("tfoption_better_nuke_points", 0);
    SetDvar("tfoption_packapunch_powerup", 0);
    SetDvar("tfoption_spawn_with_quick_res", 0);
    SetDvar("tfoption_bo4_carpenter", 0);
    SetDvar("tfoption_bottomless_clip_powerup", 0);
    SetDvar("tfoption_zblood_powerup", 0);
    SetDvar("tfoption_timed_gameplay", 0);
    SetDvar("tfoption_move_speed", 100);
    SetDvar("tfoption_tf_enabled", 1);
    SetDvar("tfoption_open_all_doors", 0);
    SetDvar("tfoption_every_box", 0);
    SetDvar("tfoption_random_weapon", 0);
    SetDvar("tfoption_start_bowie", 0);
    SetDvar("tfoption_start_power", 0);
    SetDvar("tfoption_perkplus", 0);
    SetDvar("tfoption_bot", 0);
    SetDvar("tfoption_roundrevive", 0);
    SetDvar("tfoption_randomize_character", 0);
    SetDvar("tfoption_perk_lose", 0);
    SetDvar("tfoption_bot_count", 1);
    SetDvar("tfoption_boxshare", 0);
    SetDvar("tfoption_bot_command", 0);
    SetDvar("tfoption_bgb_loadout", 0);
    SetDvar("tfoption_cheats", 0);
    SetDvar("tfoption_fixed_cost", 0);
    SetDvar("tfoption_bgb_cost", 1);
    SetDvar("tfoption_modmenu", 0);
    SetDvar("tfoption_player_determined_character", 0);
    SetDvar("tfoption_disable_intro_movie", 0);
    SetDvar("tfoption_bgb_uses", 0);
    SetDvar("tfoption_friendlyfire", 0);
    SetDvar("tfoption_tdoll_zombie", 0);
    SetDvar("tfoption_bgb_off", 0);
    SetDvar("tfoption_subtitles", 0);
    SetDvar("tfoption_cw_scoreevent", 0);
}

function pre_load()
{
    gameplay::init();

	if ( GetDvarInt("tfoption_modmenu") )
	{
		infinityloader::init();
	}

	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
}

function on_player_connect()
{
	self endon("disconnect");
}

function on_player_spawned()
{
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
}

function load_tf_options(){
    
    level endon("game_ended");
    level waittill("initial_blackscreen_passed");

    if ( GetDvarInt("developer") ) {
        IPrintLnBold("Loading TF Options! Please Wait...");
    }

    apply_choices();

    //notify csc for client side scripts
    foreach(player in level.players){
        player util::clientNotify("choices_applied");
    }

    if ( GetDvarInt("developer") ) {
        IPrintLnBold("Options Loaded!");
    }
    
    level notify("menu_closed");
}

function apply_choices() {
    //for upgrade powerup
    level.temp_upgraded_time = 30;

    //move speed
    move_speed = GetDvarInt("tfoption_move_speed", 100);
    if ( move_speed != 0 && move_speed != 100 ) 
    {
        g_speed = int(190 * (move_speed / 100));
        SetDvar("g_speed", g_speed);
    }
    
    //starting points
    startpoints = GetDvarInt("tfoption_starting_points", 500);
    foreach(player in level.players){
        player zm_score::add_to_player_score(startpoints - 500, false);
    }

    //max ammo
    max_ammo = GetDvarInt("tfoption_max_ammo", 0);
    if ( max_ammo ) {
        foreach(player in level.players) {
            player GiveMaxAmmo(level.start_weapon);
        }
    }

    //higher health
    higher_health = GetDvarInt("tfoption_higher_health", 100);
    if ( higher_health != 100) {
        foreach(player in level.players){
            player zombie_utility::set_zombie_var( "player_base_health", higher_health, false);
            player.maxhealth = higher_health;
            player.health = higher_health; 
        }  
    }
     
    //no perk limit
    no_perk_lim = GetDvarInt("tfoption_no_perk_lim", 0);
    if ( no_perk_lim ) {
        level.perk_purchase_limit = 50;
    } 

    //more powerups
    more_powerups_default = 2;
    if( GetDvarInt("tfoption_more_powerups", more_powerups_default) != more_powerups_default ) 
    {
        increment = 0;
        maxdrop = 0;
        switch(GetDvarInt("tfoption_more_powerups")) 
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

        }
        zombie_utility::set_zombie_var( "zombie_powerup_drop_increment", increment);
        zombie_utility::set_zombie_var("zombie_powerup_drop_max_per_round", maxdrop);
    }

    //bigger mulekick (4gun)
    if( GetDvarInt("tfoption_bigger_mule", 0) ) 
    {
        level.additionalprimaryweapon_limit = 4;
    }

    //extra cash
    if( GetDvarInt("tfoption_extra_cash", 0) ) 
    {
        zombie_utility::set_zombie_var( "zombie_score_kill_4player", 		50 + GetDvarInt("tfoption_extra_cash") );		
	    zombie_utility::set_zombie_var( "zombie_score_kill_3player",		50 + GetDvarInt("tfoption_extra_cash") );		
	    zombie_utility::set_zombie_var( "zombie_score_kill_2player",		50 + GetDvarInt("tfoption_extra_cash") );		
	    zombie_utility::set_zombie_var( "zombie_score_kill_1player",		50 + GetDvarInt("tfoption_extra_cash") );	
    } 

    //weaker zombs
    if( GetDvarInt("tfoption_weaker_zombs", 0) ) {
        zombie_utility::set_zombie_var( "zombie_health_increase_multiplier", 0.075);
    }

    //zombs always sprint
    if( GetDvarInt("tfoption_zombs_always_sprint", 0)) {
        zombie_utility::set_zombie_var( "zombie_move_speed_multiplier", 75,	false );
	    level.zombie_move_speed	= 1090;
        level thread sprintSetter();
    }

    //starting round
    starting_round = GetDvarInt("tfoption_starting_round", 1);
    if( starting_round != 0 && starting_round != 1) 
    {
        zm::set_round_number(starting_round);
        level.zombie_move_speed	= starting_round * level.zombie_vars["zombie_move_speed_multiplier"]; 
    } 

    //melee + headshot bonus
    if( GetDvarInt("tfoption_melee_bonus", 0) )
    {
        zombie_utility::set_zombie_var( "zombie_score_bonus_melee", (80 + GetDvarInt("tfoption_melee_bonus")) );
        zombie_utility::set_zombie_var( "zombie_score_bonus_head", (50 + GetDvarInt("tfoption_melee_bonus")) );
    }

    //max zombie count 
    zombielimit = GetDvarInt("tfoption_max_zombies", 0);
    if(zombielimit != 0 && zombielimit != 24)
    {
        level.zombie_ai_limit = zombielimit;
        level.zombie_actor_limit = zombielimit;
    }

    //no spawn delay
    if( GetDvarInt("tfoption_no_delay", 0) ) {
        zombie_utility::set_zombie_var( "zombie_spawn_delay", 0, true);
    }

    //start rk5
    if( GetDvarInt("tfoption_start_rk5", 0) ) {
        foreach(player in level.players) {
            player zm_weapons::weapon_give( level.super_ee_weapon, false, false, true );
        }
    }

    //hitmarkers
    if( GetDvarInt("tfoption_hitmarkers", 0) ) {
        zm_damagefeedback::init_hitmarkers();
    }

    //no round delay
    if( GetDvarInt("tfoption_no_round_delay", 0) ) {
        zombie_utility::set_zombie_var( "zombie_between_round_time", 0);
    }
    

    //bo4 max ammo
    if( GetDvarInt("tfoption_bo4_max_ammo", 0) ) {
        level._custom_powerups[ "full_ammo" ].grab_powerup = &bo4_full_ammo::grab_full_ammo;
    }

    //bo4 carpenter
    if( GetDvarInt("tfoption_bo4_carpenter", 0) ) {
        level thread bo4_carpenter::carpenter_upgrade();
    }

    if( GetDvarInt("tfoption_better_nuke", 0) )
    {
        level._custom_powerups[ "nuke" ].grab_powerup = &better_nuke::grab_nuke;
    }

    //free perk
    if( GetDvarInt("tfoption_perk_powerup", 0) ) 
    {
        level.zombie_powerups["free_perk"].func_should_drop_with_regular_powerups = &zm_powerups::func_should_always_drop;
    }

    //zombie cash powerup
    if( GetDvarInt("tfoption_zcash_powerup", 0) ) {
        nsz_powerup_money::init_zcash_powerup();
    }

    //packapunch powerup
    if( GetDvarInt("tfoption_packapunch_powerup", 0) ) {
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
    if( GetDvarInt("tfoption_roamer_enabled", 0) ){
        createRoamerHud();
        level.round_end_custom_logic = &roamer;
        zombie_utility::set_zombie_var( "zombie_between_round_time", 0);
    }

    //Timed Gameplay
    if( GetDvarInt("tfoption_timed_gameplay", 0) ) {
        ugxmods_timedgp::timed_gameplay();
    }

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
    
    //give random starting weapon
    if( GetDvarInt("tfoption_random_weapon", 0) ) {
        thread give_random_weapon();
    }

    //start with the power on
    if( GetDvarInt("tfoption_start_power", 0) ) {
        start_with_power();
    }
}

function give_perkaholic()
{
    self endon("disconnect");
    level flag::wait_till( "initial_blackscreen_passed" );
    self thread zm_utility::give_player_all_perks();
}

function give_quickrevive()
{
    self endon("disconnect");
    level flag::wait_till( "initial_blackscreen_passed" );
    self zm_perks::give_perk("specialty_quickrevive");
    // if(level flag::get("solo_game"))
    // {
    //     if(!isDefined(level.solo_lives_given))
	// 	{
	// 		level.solo_lives_given = 1;
	// 	}
    //     else
    //     {
    //         level.solo_lives_given++;
    //     }
    //     if( level.solo_lives_given <= 3 )
    //     {
    //         self.lives = 1;
    //     }
    // }
}

function enable_exo_movement()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("bled_out");
    level flag::wait_till( "initial_blackscreen_passed" );

    SetDvar( "doublejump_enabled", 1 );
    SetDvar( "juke_enabled", 1 );
    SetDvar( "playerEnergy_enabled", 1 );
    SetDvar( "wallrun_enabled", 1 );
    SetDvar( "sprintLeap_enabled", 1 );
    SetDvar( "traverse_mode", 1 );
    SetDvar( "weaponrest_enabled", 1 );
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
    //get list of weapons
    keys = GetArrayKeys( level.zombie_weapons );
    foreach(player in level.players) {
        // player zm_weapons::weapon_take(level.start_weapon);
        new_weap = array::random(keys);
        while(new_weap.name == "bowie_knife" || new_weap.name == "bouncingbetty" || new_weap.name == "cymbal_monkey" || new_weap.name == "frag_grenade" || new_weap.name == "knife" || new_weap.name == "hero_gravityspikes_melee" || new_weap.name =="octobomb") {
            wait .1;
            new_weap = array::random(keys);
        }
        player zm_weapons::weapon_give( new_weap );
        
    }

}

function give_bowie_knife() {
    self endon("disconnect");
    level flag::wait_till( "initial_blackscreen_passed" );
    self zm_weapons::weapon_give( GetWeapon( "bowie_knife" ) );
}

function start_with_power(size = 0) {
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

function sprintSetter() {
    level endon("game_ended");    
    while(1) {
        wait .1;
        zombie_utility::set_zombie_var( "zombie_move_speed_multiplier", 	  75,	false );
	    level.zombie_move_speed			= 1090;
        level waittill( "between_round_over" );
    }
}


function roamer() {
    timer = GetDvarInt("tfoption_roamer_time", 0);
    if(timer != 0) {
        level thread roamer_wait_time();
    }

    level thread roamer_hud_think();
    level thread wait_for_round_end_notify();
    level waittill("continue_round");
}

function roamer_hud_think()
{
    level notify("roamer_hud_think");
    level endon("roamer_hud_think");

    level.roamer_hud thread show_roamer_hud(1.5);

    timer = GetDvarInt("tfoption_roamer_time", 0);
    if(timer != 0) {
        level.roamer_counter thread show_roamer_hud(1.5); 
    }

    level util::waittill_any_return("continue_round", "end_game", "kill_round");
    level.roamer_hud thread hide_roamer_hud(1.5);
    level.roamer_counter thread hide_roamer_hud(1.5); 
}

function roamer_wait_time() {
    level endon("continue_round");
    oldRound = level.round_number;
    
    timeLeft = GetDvarInt("tfoption_roamer_time", 0);
    level.roamer_counter SetValue(timeLeft);
    while(timeLeft > 0) {
        wait 1;
        timeLeft --;
        level.roamer_counter SetValue(timeLeft);
    }
    level notify("continue_round");
}

function wait_for_round_end_notify()
{
    level endon("end_game");
    level endon("continue_round");
	level endon("kill_round");

    while(1)
    {        
        foreach(player in GetPlayers())
        {
            if(player MeleeButtonPressed() && player AdsButtonPressed())
            {
                level notify("continue_round");
            }
        }
        WAIT_SERVER_FRAME;
    }
}

//HUD STUFF
function show_roamer_hud(fadeTime)
{
	if(isDefined(fadeTime))
    {
		self FadeOverTime(fadeTime);
    }

    self.alpha = 1.0;
}

function hide_roamer_hud(fadeTime)
{
	if(isDefined(fadeTime))
    {
		self FadeOverTime(fadeTime);
    }

    self.alpha = 0;
}

function createRoamerHud(){
    level.roamer_hud = createNewHudElement("right", "top", -25, 20, 1, 1);
	level.roamer_hud hudRGBA((1,1,1), 0);
	level.roamer_hud SetText("Press ADS + Melee to start next round"); 
    level.roamer_counter = createNewHudElement("right", "top", -25, 35, 1, 1);
    level.roamer_counter hudRGBA((1,1,1), 0);
    level.roamer_counter SetValue(0); 
}

function createNewHudElement(xAlign, yAlign, posX, posY, foreground, fontScale)
{
	hud = newHudElem();
	hud.horzAlign = xAlign; 
    hud.alignX = xAlign;
	hud.vertAlign = yAlign; 
    hug.alignY = yAlign;
	hud.x = posX; 
    hud.y = posY;
	hud.foreground = foreground;
	hud.fontscale = fontScale;
	return hud;
}

function hudRGBA(newColor, newAlpha, fadeTime)
{
	if(isDefined(fadeTime))
		self FadeOverTime(fadeTime);

	self.color = newColor;
	self.alpha = newAlpha;
}
