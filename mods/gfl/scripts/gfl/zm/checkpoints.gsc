#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\aat_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\exploder_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_spawner; 
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perks;

#using scripts\zm\gametypes\_globallogic_spawn;

#insert scripts\shared\version.gsh;
#insert scripts\shared\shared.gsh;

#namespace checkpoints;

#define DEBUG false //true to enable iprintlnbold statements

REGISTER_SYSTEM_EX( "checkpoints", &__init__, &__main__, undefined )

function private __init__()
{
	level.respawning_players = false;
	callback::on_spawned(&on_spawned);
	callback::on_laststand(&on_laststand);
}

function private __main__()
{
	thread wait_for_option_changed();
	thread save_checkpoint();
}

function on_spawned()
{
	self.end_game_check = false;
}

function on_laststand()
{
	self endon("bled_out");
	self endon("death");
	self endon("disconnect");
	level endon("end_game");

	if(level.no_end_game_check == true) 
	{
		self thread no_end_game_check();
	}
}

function is_enabled()
{
    if( GetDvarInt("tfoption_checkpoints", 0) )
    {
        return true;
    }

	return false;
}

function wait_for_option_changed()
{
	level endon("game_ended");
	level endon("end_game");
	level flag::wait_till("initial_blackscreen_passed");
	
    while (true)
    {
        if ( is_enabled() )
        {
			level.no_end_game_check = true;
        }
        else
        {
            level.no_end_game_check = false;
        }
        WAIT_SERVER_FRAME;
        level waittill("tfoption_checkpoints_changed");
    }
}

function save_checkpoint()
{
	level endon("end_game");
	level flag::wait_till("initial_blackscreen_passed");

	thread checkpoint();
	num = level.round_number;
	if(num <= 1){num = 0;}
	
	//num = roundnumber at the start of each round check if num is greater than level.roundnumber if it is then we save a checkpoint
	//by default a checkpoint is saved at the start of a new round if the new round is greater than the last saved round
	while(1)	
	{
		level waittill("end_of_round");
		if(DEBUG == true && level.no_end_game_check == true){IPrintLnBold("num = ^3" + num + " ^7round number = ^3" + level.round_number);}
		
		//if num is greater than level.round_number save a new checkpoint
		if(level.round_number > num && level.no_end_game_check == true && level.respawning_players != true)
		{
			num = level.round_number;
			if(level.no_end_game_check == true)
			{
				thread checkpoint();
				if(DEBUG == true){IPrintLnBold("^3Saving Checkpoint^7!");}
			}
		}
		else if(level.no_end_game_check == true){if(DEBUG == true){IPrintLnBold("^1NOT^7 Saving Checkpoint");}}
	}
} 

//call this thread to save the players loadout & score
function checkpoint()
{
	if(level.no_end_game_check == true)
	{
		zombie_utility::set_zombie_var( "spectators_respawn", 				false );		// Respawn in the spectators in between rounds
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i].sessionstate == "spectator")
			{
				client = players[i];
				players[i] thread globallogic_spawn::spawnPlayer();
				wait(.2);
				players[i] notify ("respawned_players");			
			}
		}
		wait(2);
		players = GetPlayers();
		for(i=0;i<players.size;i++)
		{
			//we dont want to update players weapons if their spectating or they'll spawn with nothing on next respawn
			if(players[i].sessionstate != "spectator")
			{
				players[i] notify("checkpoint");
				players[i] thread no_end_game_check_save_weapons();
				// players[i] thread zm_equipment::show_hint_text("^5Checkpoint^7: ^3Saved",4);
			}		
			players[i].ignoreme = false;
		}
		wait(2);
		foreach(player in GetPlayers())
		{
			player.ignoreme = false;
		}
	}
	else{	zombie_utility::set_zombie_var( "spectators_respawn", 				true );}
}

function no_end_game_check()
{
	dead = 0;
	downed = laststand::player_num_in_laststand();
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i].sessionstate == "spectator")//counts all spectators
		{dead++;}
	}
	//count downd + spectators against player size
	total = downed + 1 + dead;
	if(DEBUG == true){IPrintLnBold("there are ^6"+total+ "^7 players dead of ^6" +players.size+" ^7players.");}
	if(total == players.size)//if all players are either spectating or downed
	{
		//if game is solo and player has quick revive don't proceed
		if(players.size == 1)
		{
			for(k = 0; k < players.size; k++)
			{
				players[k].end_game_check = true;
			}	
		}
		level notify("all_players_dead");
		wait(1);
		for(z = 0; z < players.size; z++)
		{
			players[z] thread respawn_players();
		}
		level notify("respawning_players");
	}
}

//if all players are spectating or in laststand respawn them & resest round
function respawn_players()
{
	setdvar( "cg_drawCrosshair",  0);

	level.respawning_players = true;

	if(DEBUG == true){IPrintLnBold("respawning players");}

	//freeze controls and fade out
	self FreezeControls(true);
	self EnableInvulnerability();
	self thread lui::screen_fade_out(.5);

	wait(.7);
	
	//reset round
	thread zombie_goto_round(level.round_number);

	wait(1);

	level.respawning_players = false;

	//if in laststand revive them
	if(self laststand::player_is_in_laststand()){self thread zm_laststand::revive_success(self);}

	//respawn players
	self thread globallogic_spawn::spawnPlayer();
	wait(.2);
	self notify("respawned_players");

	if(DEBUG == true){IPrintLnBold("all players respawned!");}

	wait(2);
	//unfreeze controlls and fade in
	self thread lui::screen_fade_in(3);
	self FreezeControls(false);
	self AllowJump(true);
	self.ignoreme = true;
	self thread zm_equipment::show_hint_text("Returned to start of round!");

	//reset score if its round 1
	if(level.round_number <= 1){self.score = 500;}

	wait(5);
	self DisableInvulnerability();
	self.ignoreme = false;

	setdvar( "cg_drawCrosshair",  1);
}

function no_end_game_check_save_weapons(weapons,score,perk_list,gum)
{
	self endon( "disconnect" );
	level endon ( "end_game" );

	//if a new checkpoint is made this function stops and restarts updating the players score + loadout
	self endon("checkpoint");

	if(!isdefined(weapons))
	{
		//get guns/score/perks/gums quickly
		weapons = self GetWeaponsList(true);
		score = self.score;
		if(!self IsInVehicle()){org = self.origin;}

		players = GetPlayers();
		perk_list = [];
		keys = GetArrayKeys( level._custom_perks );

		if(isdefined(keys))
		{
			for ( i = 0; i < keys.size; i++ )
			{
				perk = keys[ i ];
				if ( self hasPerk( perk ) )
				{	
					perk_list[ perk_list.size ] = perk;
				}	
			}
		}
		for(i=0;i<self.bgb_pack.size;i++)
		{
			if(self bgb::is_enabled(self.bgb_pack[i]))
			{
				gum = self.bgb_pack[i];
			}
		}
		//wait for players to finish using packapunch before getting their weapons 
		while (isdefined(level flag::get("pack_machine_in_use")) && level flag::get("pack_machine_in_use"))
		{wait.05; if(DEBUG == true){IPrintLnBold("PACKAPUNCH MACHINE IS IN USE! NOT GETTING PLAYERS WEAPONS YET.");}}

		//get players guns/score/perks
		weapons = self GetWeaponsList(true);
		score = self.score;
		if(!self IsInVehicle()){org = self.origin;}
		perk_list = [];
		keys = GetArrayKeys( level._custom_perks );

		if(isdefined(keys))
		{
			for ( i = 0; i < keys.size; i++ )
			{
				perk = keys[ i ];
				if ( self hasPerk( perk ) )
				{	
					perk_list[ perk_list.size ] = perk;
					if(DEBUG == true){IPrintLnBold("player has ^6" + perk);}	
				}
				else if(DEBUG == true){IPrintLnBold("player does not have ^6" + perk);}	
			}
		}
		for(i=0;i<self.bgb_pack.size;i++)
		{
			if(self bgb::is_enabled(self.bgb_pack[i]))
			{
				gum = self.bgb_pack[i];
			}
		}
	}
	for(i = 0; i < weapons.size; i++)
	{
		stock[i] = self GetWeaponAmmoStock(weapons[i]);
		clip[i] = self GetWeaponAmmoClip(weapons[i]);
		fuel[i] = self GetWeaponAmmoFuel(weapons[i]);
	}
	if(DEBUG == true){IPrintLnBold(self.name + "'s weapons + score has been saved");}
	//waittill the player is respawned from death
	self waittill("respawned_players");
	
	if(DEBUG == true){IPrintLnBold(self.name + " respawn weapons notified");}

	//reset player score
	self.score = score;

	//reset players perks

	players = GetPlayers();
	for ( i = 0; i < perk_list.size; i++ )
	{
		self zm_perks::give_perk(perk_list[i]);	
		if(DEBUG == true){IPrintLnBold( self.name + " had ^3"+ perk_list[i]);}
	}

	//restore with their gumball
	if(isdefined(gum))
	{self bgb::give(gum);}

	//restore with their weapons
	wait(.05);
	self EnableInvulnerability();
	self.ignoreme = true;

	self TakeAllWeapons();
	for(i=0; i < weapons.size; i++)
	{
		if(zm_weapons::is_weapon_upgraded(weapons[i]))
		{
			weapon_options = self GetBuildKitWeaponOptions( weapons[i], level.pack_a_punch_camo_index); 
			acvi = self GetBuildKitAttachmentCosmeticVariantIndexes( weapons[i], true );
			self GiveWeapon( weapons[i], weapon_options, acvi );
		}	
		else
		{
			self GiveWeapon(weapons[i]);
		}

			self SetWeaponAmmoClip(weapons[i], clip[i]);
			self SetWeaponAmmoStock(weapons[i], stock[i]);
			self SetWeaponAmmoFuel(weapons[i], fuel[i]);
			deathmachine = level.zombie_powerup_weapon[ "minigun" ];
			if(DEBUG == true){IPrintLnBold(deathmachine.name);}
			if(weapons[i].name == deathmachine.name)
			{
				weapons[i] TakeWeapon(weapons[i]);
			}
	}
	
	wait(.1);
	self SwitchToWeapon(weapons[1]);
	wait(.1);
	if(weapons.size <= 1)
	{
		self GiveWeapon(level.start_weapon);
	}
	self DisableInvulnerability();
	self.ignoreme = false;

	if(DEBUG == true){IPrintLnBold(self.name + "'s weapons have been restored from latest checkpoint.");}

	//retains their last updated weapon information and score information
	self thread no_end_game_check_save_weapons(weapons,score,perk_list,gum);
}

/////////////////
// GOTO ROUND  //
/////////////////
function zombie_goto_round(round)
{
	if(	level flag::get("dog_round"))
	{
		return;
	}
	level notify( "restart_round" );

	level.roamer_disabled = true;
	if ( round < 1 )
	{
		level.round_number = 1;
	}
	else 
	{
		level.zombie_total = 0;
		zombie_utility::ai_calculate_health( round );
		wait(0.05);
		zm::set_round_number( round );
	}
	
	// kill all active zombies
	zombies = zombie_utility::get_round_enemy_array();
	if ( isdefined( zombies ) )
	{
		array::run_all( zombies, &Kill );
	}
	
	level.sndGotoRoundOccurred = true;

	level waittill( "between_round_over" );
	level.roamer_disabled = false;
}