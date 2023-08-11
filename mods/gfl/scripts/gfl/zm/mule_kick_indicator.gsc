#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_pack_a_punch_util;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\zm\_zm_perks.gsh;

#namespace mule_kick_indicator;

#precache( "material", "specialty_giant_three_guns_zombies");
#precache( "material", "specialty_three_guns_zombies");

function init()
{
	callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	self endon("disconnect");
	
	if(GetDvarInt("tfoption_bigger_mule") == 1) 
	{
		self thread quad_kick_indicator();
	}
	else
	{
		self thread mule_kick_indicator();
	}
}

function quad_kick_indicator()
{
	self endon("disconnect");

	if( !isDefined( self.mulekick_icon ) )
	{
	self.mulekick_icon = newClientHudElem(self);
	self.mulekick_icon.horzAlign = "right";
	self.mulekick_icon.vertAlign = "bottom";
	self.mulekick_icon.x = -150;
	self.mulekick_icon.y = -120;
	self.mulekick_icon.alpha = 0;
	self.mulekick_icon.archived = true;
	self.mulekick_icon.hidewheninmenu = true;
	}
	if(level.script == "zm_zod" )
	{
		self.mulekick_icon setShader( "specialty_three_guns_zombies", 24, 24 ); 
	}
	else
	{
		self.mulekick_icon setShader( "specialty_giant_three_guns_zombies", 24, 24 ); 
	}
	
	while(1)
	{
		if ( self should_hide_indicator() )
		{
			wait 0.1;
			continue;
		}

		if(
			self GetWeaponsListPrimaries().size <= 4 
			&& self GetWeaponsListPrimaries().size != 1 
			&& self hasPerk("specialty_additionalprimaryweapon") 
			&& ((isDefined(self GetWeaponsListPrimaries()[2]) && self GetCurrentWeapon() == self GetWeaponsListPrimaries()[2] )	|| (isDefined(self GetWeaponsListPrimaries()[3]) && self GetCurrentWeapon() == self GetWeaponsListPrimaries()[3] ) )
		)
		{
			self.mulekick_icon FadeOverTime(0.1);
			self.mulekick_icon.alpha = 1;
			wait 1;
			self.mulekick_icon FadeOverTime(0.1);
			self.mulekick_icon.alpha = 0;
		}
		else
		{
			self.mulekick_icon FadeOverTime(0.1);
			self.mulekick_icon.alpha = 0;
		}
		self util::waittill_any_return( "fake_death", "death", "player_downed", "weapon_change", "perk_abort_drinking", "weapon_give" ,"shield_update");//WAIT_SERVER_FRAME;
	}
}

function mule_kick_indicator()
{
	self endon("disconnect");

	if( !isDefined( self.mulekick_icon ) )
	{
	self.mulekick_icon = newClientHudElem(self);
	self.mulekick_icon.horzAlign = "right";
	self.mulekick_icon.vertAlign = "bottom";
	self.mulekick_icon.x = -150;
	self.mulekick_icon.y = -120;
	self.mulekick_icon.alpha = 0;
	self.mulekick_icon.archived = true;
	self.mulekick_icon.hidewheninmenu = true;
	}
	if(level.script == "zm_zod" )
	{
		self.mulekick_icon setShader( "specialty_three_guns_zombies", 24, 24 ); 
	}
	else
	{
		self.mulekick_icon setShader( "specialty_giant_three_guns_zombies", 24, 24 ); 
	}

	while(1)
	{
		if ( self should_hide_indicator() )
		{
			wait 0.1;
			continue;
		}

		if(
			self GetWeaponsListPrimaries().size <= 3 
			&& self GetWeaponsListPrimaries().size != 1 
			&& self hasPerk("specialty_additionalprimaryweapon") 
			&& isDefined(self GetWeaponsListPrimaries()[2]) 
			&& self GetCurrentWeapon() == self GetWeaponsListPrimaries()[2] 
		)
		{
			self.mulekick_icon FadeOverTime(0.1);
			self.mulekick_icon.alpha = 1;
			wait 1;
			self.mulekick_icon FadeOverTime(0.1);
			self.mulekick_icon.alpha = 0;
		}
		else
		{
			self.mulekick_icon FadeOverTime(0.1);
			self.mulekick_icon.alpha = 0;
		}
		self util::waittill_any_return( "fake_death", "death", "player_downed", "weapon_change", "perk_abort_drinking", "weapon_give" ,"shield_update");//WAIT_SERVER_FRAME;
	}
}

function should_hide_indicator()
{
	if ( !isdefined(self) || !isalive(self) )
	{
		return true;
	}

	if(isDefined(self.current_player_scene) || self scene::is_igc_active() || (isdefined(self.dont_show_hud) && self.dont_show_hud) || self flagsys::get("playing_movie_hide_hud") || self laststand::player_is_in_laststand())
	{
		return true;
	} 

	return false;
}