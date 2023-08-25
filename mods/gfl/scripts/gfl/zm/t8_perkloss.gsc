#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;

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

#namespace t8_perkloss;

function init()
{
	callback::on_connect( &on_player_connect );
	thread main();
}

function on_player_connect()
{
	self endon("disconnect");
	
	self.elmgperks = [];
	self thread perkrestore();
}

function main()
{
    level endon("end_game");
    level endon("game_ended");
    level waittill( "initial_blackscreen_passed" );
	
	thread lockrevivefunc();
}

function lockrevivefunc()
{
    level endon("end_game");
    level endon("game_ended");

    while(1)
    {
        level.callbackplayerlaststand = &ELMG_playerlaststand;
        wait(1);
    }
}

function ELMG_playerlaststand( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self endon( "disconnect" );	

    if(isdefined(self) && isplayer(self) && isdefined(self.perks_active) && self.perks_active.size > 0)
	{
		self thread perklosing(self.perks_active);
	}
    
	zm_laststand::PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ); 
}

function check_to_cant_save_perks()
{
	if( self bgb::is_enabled( "zm_bgb_near_death_experience" ) || self bgb::is_enabled( "zm_bgb_aftertaste" ) || self bgb::is_enabled( "zm_bgb_self_medication" ) )
	{
		return true;
	}

	nde_count = 0;
	foreach( player in GetPlayers())
	{
		if( ( player bgb::is_enabled( "zm_bgb_near_death_experience" ) ||  player bgb::is_enabled( "zm_bgb_phoenix_up" ) ) && player != self)
		{
			nde_count++;
		}
	}

	if(GetPlayers().size >= 2 && GetPlayers().size == (nde_count + 1) )
	{
		return true;
	}

	return false;
}

function get_player_perk_size()
{
	num = 0;
	a_str_perks = GetArrayKeys( level._custom_perks );
	
	foreach( str_perk in a_str_perks )
	{
		if( self HasPerk( str_perk ) )
		{
			num++;
		}
	}
	return num;
}

function perkrestore()
{
	self endon("disconnect");

	while (1) 
	{
		self waittill("player_revived");
		wait 0.3;
		if(self get_player_perk_size() == 0)
		{
			a_keys = GetArrayKeys( level._custom_perks );
			for ( i = 0; i < a_keys.size; i++ )
			{
				self zm_perks::set_perk_clientfield( a_keys[i], PERK_STATE_NOT_OWNED );
			}

			if(isdefined(self.elmgperks) && self.elmgperks.size != 0 )
			{
				foreach( perk in self.elmgperks)
				{
					WAIT_SERVER_FRAME;
					self zm_perks::give_perk( perk, false );
				}
			}
		}
		else
		{	
			a_str_perks = GetArrayKeys( level._custom_perks );
	
			foreach( str_perk in a_str_perks )
			{
				if( !self HasPerk( str_perk ) )
				{
					self zm_perks::set_perk_clientfield( a_keys[i], PERK_STATE_NOT_OWNED );
				}
			}

		}
		self notify("t8_perkloss_perk_restored");
	}
}

function perklosing(perks)
{
	self notify("nomoreperks");
	self endon ("nomoreperks");

	self endon ("disconnect");
	self endon ("death");
	self endon ("player_revived");
	self endon ("player_suicide");
	self endon ("zombified");
	self endon ("bled_out");
	self endon ("spawned_player");
	self endon ("death_or_disconnect");

	//perks = self.perks_active;
	if ( !isdefined(perks) || perks.size == 0 || isdefined(self._retain_perks) || self check_to_cant_save_perks() )
	{
		break;
	}
	self util::waittill_any( "player_downed", "weapons_taken_for_last_stand", "entering_last_stand");

	bleedout_time = GetDvarfloat( "player_lastStandBleedoutTime" );
	bleedout_time -= 2;
	if( isdefined( self.n_bleedout_time_multiplier ) )
	{
		bleedout_time *= self.n_bleedout_time_multiplier;
	}

	loop = true;

	self.elmgperks = perks;
	for( i = 0; i < self.elmgperks.size; i++ )
	{
		if(self.elmgperks[i] == "specialty_whoswho" || self.elmgperks[i] == "specialty_tombstone" || self.elmgperks[i] == "specialty_jetquiet")
		{
			ArrayRemoveIndex(self.elmgperks, i);
		}
		if(GetPlayers().size == 1 && self.elmgperks[i] == "specialty_quickrevive")
		{
			ArrayRemoveIndex(self.elmgperks, i);
		}
	}

	for( i = 0; i < perks.size; i++ )
	{
		self zm_perks::set_perk_clientfield(perks[i], PERK_STATE_NOT_OWNED);
	}

	for( i = 0; i < self.elmgperks.size; i++ )
	{
		wait 0.0000001;
		self zm_perks::set_perk_clientfield(self.elmgperks[i], PERK_STATE_OWNED);
	}
	wait 0.0000001;
	//self.health = self.maxhealth;
	while (loop && isdefined(self)) 
	{	
		if(self.elmgperks.size <= 0 || !isdefined(self.elmgperks))
		{
			loop = false;
		}
		perks = self.elmgperks;
		i = perks.size - 1;
		self thread flash_perk_icon(perks[i]);
		lose_time = bleedout_time / perks.size;
		lose_time *= 100;
		lose_time = int(lose_time);
		lose_time /= 100;
		lose_time2 = lose_time / 2;
		while( isdefined(self) && isdefined( self.revivetrigger ) && isdefined( self.revivetrigger.beingRevived ) && self.revivetrigger.beingRevived == 1 )
		{
			WAIT_SERVER_FRAME;
			self zm_perks::set_perk_clientfield(perks[i], PERK_STATE_OWNED);
		}
		wait lose_time2;
		while( isdefined(self) && isdefined( self.revivetrigger ) && isdefined( self.revivetrigger.beingRevived ) && self.revivetrigger.beingRevived == 1 )
		{
			WAIT_SERVER_FRAME;
			self zm_perks::set_perk_clientfield(perks[i], PERK_STATE_OWNED);
		}
		self notify(perks[i] + "_nomore");
		self zm_perks::set_perk_clientfield(perks[i], PERK_STATE_NOT_OWNED);
		if(isdefined(self.elmgperks) && self.elmgperks.size > 0)
		{
			ArrayRemoveIndex(self.elmgperks, i);
		}		
		if(self.elmgperks.size <= 0 || !isdefined(self.elmgperks))
		{
			loop = false;
		}
		wait lose_time2;
	}
}

function flash_perk_icon(perk)
{
	self endon ("disconnect");
	self endon ("death");
	self endon ("player_revived");
	self endon ("player_suicide");
	self endon ("zombified");
	self endon ("bled_out");
	self endon ("spawned_player");
	self endon ("death_or_disconnect");
	self endon(perk + "_nomore");
	
	if(level.script == "zm_basement" || level.script == "zm_der_hafen")
	{
		return;
	}

	while (isdefined(self)) 
	{
		self zm_perks::set_perk_clientfield(perk, PERK_STATE_NOT_OWNED);
		wait 0.7;
		self zm_perks::set_perk_clientfield(perk, PERK_STATE_OWNED);
		wait 0.7;
	}
}
