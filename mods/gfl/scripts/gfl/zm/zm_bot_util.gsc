#using scripts\shared\laststand_shared;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;

#namespace zm_bot_util;

#define ZM_BOT_CATCHUP_NAV_MIN_RADIUS 64
#define ZM_BOT_CATCHUP_NAV_MAX_RADIUS 192
#define ZM_BOT_CATCHUP_NAV_HALF_HEIGHT 48
#define ZM_BOT_CATCHUP_NAV_POINT_SPACING 32

function get_bot_players()
{
	bots = [];
	foreach( player in GetPlayers())
	{
		if(player IsTestClient())
		{
			bots[bots.size] = player;
		}
	}
	return bots;
}

function get_real_players()
{
	players = [];
	foreach( player in GetPlayers())
	{
		if(!player IsTestClient())
		{
			players[players.size] = player;
		}
	}
	return players;
}

function get_alive_players()
{
	players = [];
	foreach( player in GetPlayers())
	{
		if(player IsTestClient())
		{
			continue;
		}

		if(!isalive(player))
		{
			continue;
		}

		if(	player.sessionstate == "spectator" )
		{
			continue;
		}

		players[players.size] = player;
	}
	return players;
}

function get_closest_alive_player()
{	
	level endon( "game_ended" );
    players = get_alive_players();
	leader = ArrayGetClosest(self.origin, players);
	if(isDefined(leader))
	{
		return leader;
	}
	else
	{
		return self;
	}
}

function is_player_in_follow_range(player)
{
	return player != self &&
	       DistanceSquared(self.origin, player.origin) <= self.follow_player_distance * self.follow_player_distance;
}

function get_catchup_player(excluded_origin = undefined, excluded_radius = 0)
{
	closest = undefined;
	closest_distance_sq = undefined;
	foreach (player in get_alive_players())
	{
		if (player.sessionstate != "playing" || IS_TRUE(player.is_zombie) ||
		    player laststand::player_is_in_laststand())
		{
			continue;
		}

		if (isdefined(excluded_origin) && DistanceSquared(player.origin, excluded_origin) <= excluded_radius * excluded_radius)
		{
			continue;
		}

		distance_sq = DistanceSquared(self.origin, player.origin);
		if (!isdefined(closest) || distance_sq < closest_distance_sq)
		{
			closest = player;
			closest_distance_sq = distance_sq;
		}
	}
	return closest;
}

function find_catchup_destination(player)
{
	if (!player IsOnGround())
	{
		return undefined;
	}

	// A query centered off the navmesh can return points from a disconnected area.
	query = PositionQuery_Source_Navigation(
		player.origin, ZM_BOT_CATCHUP_NAV_MIN_RADIUS, ZM_BOT_CATCHUP_NAV_MAX_RADIUS,
		ZM_BOT_CATCHUP_NAV_HALF_HEIGHT, ZM_BOT_CATCHUP_NAV_POINT_SPACING, self);
	if (!isdefined(query) || !IS_TRUE(query.centerOnNav) || !isdefined(query.data))
	{
		return undefined;
	}

	volumes = GetEntArray("player_volume", "script_noteworthy");
	has_zones = isdefined(level.zones) && level.zones.size > 0;
	closest = undefined;
	closest_distance_sq = undefined;
	foreach (point in query.data)
	{
		origin = point.origin;
		distance_sq = DistanceSquared(player.origin, origin);
		if (isdefined(closest) && distance_sq >= closest_distance_sq)
		{
			continue;
		}
		if (!IsPointOnNavMesh(origin, self) || PositionWouldTelefrag(origin))
		{
			continue;
		}
		if (has_zones && !zm_utility::check_point_in_enabled_zone(origin, false, volumes))
		{
			continue;
		}
		if (!has_zones && volumes.size > 0 && !zm_utility::check_point_in_playable_area(origin))
		{
			continue;
		}

		closest = origin;
		closest_distance_sq = distance_sq;
	}
	return closest;
}
