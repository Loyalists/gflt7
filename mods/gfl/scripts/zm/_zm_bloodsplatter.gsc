// -------------------------------------------------------------------------------
// Player Bloodsplatter for Black Ops III - Bloc Edition
// Copyright (c) 2022 Philip/Scobalula
// -------------------------------------------------------------------------------
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// -------------------------------------------------------------------------------
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// -------------------------------------------------------------------------------
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// -------------------------------------------------------------------------------
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;
// #using scripts\zm\_zm;

#insert scripts\shared\duplicaterender.gsh;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\shared\archetype_shared\archetype_shared.gsh;
#insert scripts\zm\_zm_bloodsplatter.gsh;

#namespace zm_bloodsplatter;

REGISTER_SYSTEM("zm_bloodsplatter", &__init__, undefined)

function private __init__()
{
	// Clientfields
	clientfield::register("allplayers", "bloodsplatter_toggle", VERSION_DLC3, 1, "counter");
	// Spawner Functions
	array::run_all(GetSpawnerArray(), &spawner::add_spawn_function, &bloodsplatter_watcher);
	array::run_all(GetVehicleArray(), &spawner::add_spawn_function, &bloodsplatter_watcher);

	// Default bloodsplatter immunities.
	register_bloodsplatter_immunity(ARCHETYPE_SENTINEL_DRONE);
}

/@
"Name: register_bloodsplatter_immunity(<archetype>)"
"Summary: Registers no blood splatter for the given archetype.
"Module: Bloodsplatter"
"MandatoryArg: <archetype> Archetype to register no blood splatter for.
"Example: zm_bloodsplatter::register_bloodsplatter_immunity(ARCHETYPE_SENTINEL_DRONE);"
"SPMP: both"
@/
function register_bloodsplatter_immunity(archetype)
{
	assert(isdefined(archetype), "zm_bloodsplatter::register_bloodsplatter_immunity(): archetype must be defined");

	DEFAULT(level.bloodsplatter_immunity, []);

	level.bloodsplatter_immunity[archetype] = true;
}

/@
"Name: deregister_bloodsplatter_immunity(<archetype>)"
"Summary: Deregisters no blood splatter for the given archetype.
"Module: Bloodsplatter"
"MandatoryArg: <archetype> Archetype to deregister no blood splatter for.
"Example: zm_bloodsplatter::deregister_bloodsplatter_immunity(ARCHETYPE_SENTINEL_DRONE);"
"SPMP: both"
@/
function deregister_bloodsplatter_immunity(archetype)
{
	assert(isdefined(archetype), "zm_bloodsplatter::register_bloodsplatter_immunity(): archetype must be defined");

	DEFAULT(level.bloodsplatter_immunity, []);

	level.bloodsplatter_immunity[archetype] = false;
}

/@
"Name: is_archetype_immune(<archetype>)"
"Summary: Checks if the given archetype is immune to bloodsplatter.
"Module: Bloodsplatter"
"MandatoryArg: <archetype> Archetype to check.
"Example: zm_bloodsplatter::is_archetype_immune(ARCHETYPE_SENTINEL_DRONE);"
"SPMP: both"
@/
function is_archetype_immune(archetype)
{
	return isdefined(archetype) && isdefined(level.bloodsplatter_immunity) && IS_TRUE(level.bloodsplatter_immunity[archetype]);
}

/@
"Name: splash_blood_on_player()"
"Summary: Splashers blood onto the player's viewmodel and body.
"Module: Bloodsplatter"
"Example: player zm_bloodsplatter::splash_blood_on_player();"
"SPMP: both"
@/
function splash_blood_on_player()
{
	self clientfield::increment("bloodsplatter_toggle", 1);
}

/@
"Name: splash_blood_on_nearby_players()"
"Summary: Splashers blood onto nearby player's viewmodel and body.
"Module: Bloodsplatter"
"Example: player zm_bloodsplatter::splash_blood_on_nearby_players();"
"SPMP: both"
@/
function splash_blood_on_nearby_players(origin, dist)
{
	foreach(player in level.players)
	{
		if(DistanceSquared(player.origin, origin) < dist)
		{
			if(IsFunctionPtr(level.bloodsplatter_callback))
			{
				player [[level.bloodsplatter_callback]](origin, dist);
			}

			player splash_blood_on_player();
		}
	}
}

function private bloodsplatter_watcher()
{
	// self = actor/vehicle
	if(IS_TRUE(level.bloodsplatter_disabled))
		return;
	if(!isdefined(self.archetype))
		return;
	if(is_archetype_immune(self.archetype))
		return;

	level endon("kill_bloodsplatter");

	while(IsAlive(self))
	{
		self waittill("damage");

		if(!isdefined(self))
			return;

		// TODO: Allow per-archetype distance, a bigger enemy should have bigger radius.
		splash_blood_on_nearby_players(self.origin, (BLOOD_SPASH_RADIUS * BLOOD_SPASH_RADIUS));
	}
}