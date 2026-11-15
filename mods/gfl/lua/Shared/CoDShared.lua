-- 77891a2587059a2dcc4d7fd161129330
-- This hash is used for caching, delete to decompile the file again

require( "lua.Shared.LuaReadOnlyTables" )

local shared = {
	gametypesStructTable = "game_types"
}
local cachedGameType, cachedIsTeamBased = nil
shared.IsGametypeTeamBased = function ( gameType, infectTeamBased )
	if not gameType then
		gameType = Dvar.ui_gametype:get()
	end
	if gameType == "infect" then
		return infectTeamBased
	elseif gameType == cachedGameType then
		return cachedIsTeamBased
	else
		local teamBasedSetting = Engine.StructTableLookupString( shared.gametypesStructTable, "name", gameType, "is_team_based" )
		if teamBasedSetting == nil then
			return false
		else
			cachedGameType = gameType
			if Engine.ToUpper( teamBasedSetting ) == "NO" then
				cachedIsTeamBased = false
				return false
			else
				cachedIsTeamBased = true
				return true
			end
		end
	end
end

shared.IsHardcoreGametypeAvailable = function ( gameType )
	if not gameType then
		gameType = Dvar.ui_gametype:get()
	end
	local hardcoreAvailable = Engine.StructTableLookupString( shared.gametypesStructTable, "name", gameType, "hardcore_available" )
	if hardcoreAvailable and hardcoreAvailable == "YES" then
		return true
	else
		return false
	end
end

shared.ChunkAnyDownloading = function ()
	if (LuaUtils.isPS4 or LuaUtils.isXbox) and (Engine.IsMpStillDownloading() or Engine.IsZmStillDownloading() or Engine.IsCpStillDownloading() or Engine.IsZmInitialStillDownloading() or Engine.IsMpInitialStillDownloading()) then
		return true
	else
		return false
	end
end

shared.IsTeamBasedGame = function ()
	if Engine.IsDedicatedServer() then
		return Engine.GetGametypeSetting( "teamCount" ) > 1
	elseif Engine.IsInGame() then
		return CoDShared.IsGametypeTeamBased()
	else
		return CoDShared.IsGametypeTeamBased( Engine.GetCurrentGameType() )
	end
end

shared.IsLobbyMode = function ( lobbyMode )
	local modelValue = Engine.GetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ) )
	if modelValue then
		local lobbyTarget = LobbyData:UITargetFromId( modelValue )
		return lobbyTarget.lobbyMode == lobbyMode
	else
		
	end
end

shared.IsOnlineGame = function ()
	if Engine.SessionMode_IsOnlineGame() then
		return true
	else
		return false
	end
end

shared.IsRankedGame = function ()
	local isRanked
	if shared.IsOnlineGame() == true and not Engine.GameModeIsMode( Enum.eGameModes.MODE_GAME_MATCHMAKING_MANUAL ) then
		isRanked = not Engine.GameModeIsMode( Enum.eGameModes.MODE_GAME_MANUAL_PLAYLIST )
	else
		isRanked = false
	end
	return isRanked
end

shared.IsHost = function ()
	return Engine.DvarBool( nil, "sv_running" )
end

shared.GetTeamDifference = function ( team )
	if team ~= Enum.team_t.TEAM_ALLIES and team ~= Enum.team_t.TEAM_AXIS then
		return 0
	end
	local sessionClients = Engine.LobbyGetSessionClients( Enum.LobbyModule.LOBBY_MODULE_CLIENT, Enum.LobbyType.LOBBY_TYPE_GAME )
	local sessionClients = sessionClients.sessionClients
	local alliesCount = 0
	local axisCount = 0
	for index, client in ipairs( sessionClients ) do
		if client.team == Enum.team_t.TEAM_ALLIES then
			alliesCount = alliesCount + 1
		end
		if client.team == Enum.team_t.TEAM_AXIS then
			axisCount = axisCount + 1
		end
	end
	if team == Enum.team_t.TEAM_ALLIES then
		return alliesCount - axisCount
	end
	return axisCount - alliesCount
end

shared.IsTeamOverwhelmed = function ( controller )
	local team = Engine.GetTeamForXUID( Engine.GetXUID64( controller ) )
	local unfairTeamGap = Dvar.arena_unfairTeamGap:get() * -1
	if unfairTeamGap == 0 or unfairTeamGap < shared.GetTeamDifference( team ) then
		return false
	else
		return true
	end
end

shared.QuitGame = function ( controller, f11_arg1 )
	if Engine.IsRunningUILevel() then
		return true
	end
	local clientCount = Engine.GetLobbyClientCount( Enum.LobbyModule.LOBBY_MODULE_HOST, Enum.LobbyType.LOBBY_TYPE_GAME, Enum.LobbyClientType.LOBBY_CLIENT_TYPE_ALL )
	local clientCount2 = Engine.GetLobbyClientCount( Enum.LobbyModule.LOBBY_MODULE_HOST, Enum.LobbyType.LOBBY_TYPE_GAME, Enum.LobbyClientType.LOBBY_CLIENT_TYPE_LOCAL )
	local hostInfo = Engine.GetLobbyHostInfo( Enum.LobbyModule.LOBBY_MODULE_CLIENT, Enum.LobbyType.LOBBY_TYPE_GAME )
	if hostInfo ~= nil then
		if nil ~= LobbyVM then
			LobbyVM.MatchmakingPriorityQuit( {
				hostSecId = hostInfo.secIdint
			} )
		else
			Engine.LobbyVM_CallFunc( "MatchmakingPriorityQuit", {
				hostSecId = hostInfo.secIdint
			} )
		end
	end
	if shared.IsLobbyMode( Enum.LobbyMode.LOBBY_MODE_THEATER ) == true then
		if not Engine.IsLobbyHost( Enum.LobbyType.LOBBY_TYPE_GAME ) then
			Engine.GameModeResetModes()
			Engine.SessionModeResetModes()
			Engine.Exec( controller, "disconnect" )
		else
			Engine.Exec( controller, "xpartystopdemo" )
		end
		return true
	elseif not shared.IsRankedGame() and shared.IsHost() and Engine.DvarInt( nil, "g_gameEnded" ) ~= 1 then
		Engine.SendMenuResponse( controller, "popup_leavegame", "endround" )
	elseif not shared.IsHost() then
		if f11_arg1 then
			Engine.UpdateStatsForQuitUnbalancedTeam( controller, false )
		else
			Engine.UpdateStatsForQuit( controller, false )
		end
		if Engine.IsZombiesGame() then
			shared.IncrementZMDashboardQuitType( controller, "quit", 1 )
		end
		Engine.Exec( controller, "disconnect" )
	elseif shared.IsRankedGame() and shared.IsHost() and not Engine.HostMigrationWaitingForPlayers() and Engine.DvarInt( nil, "g_gameEnded" ) ~= 1 then
		Engine.UpdateStatsForQuit( controller, true )
		if (Engine.IsZombiesGame() or shared.IsGameTypeDOA() or Engine.GameModeIsMode( Enum.eGameModes.MODE_GAME_FREERUN )) and (clientCount < Dvar.migration_minclientcount:get() or clientCount == clientCount2) then
			Engine.SendMenuResponse( controller, "popup_leavegame", "endround" )
		else
			if Engine.IsMultiplayerGame() or Engine.IsZombiesGame() or shared.IsGameTypeDOA() then
				if Engine.IsZombiesGame() then
					shared.IncrementZMDashboardQuitType( controller, "quit", 1 )
				end
				Engine.Exec( controller, "hostmigration_start" )
				return false
			end
			Engine.SendMenuResponse( controller, "popup_leavegame", "endround" )
		end
	end
	return true
end

shared.IsGameTypeDOA = function ()
	local f12_local0
	if (Dvar.ui_gametype == nil or Dvar.ui_gametype:get() ~= "doa") and (nil == Engine.GetCurrentMap() or Engine.GetCurrentMap() ~= "cp_doa_bo3") then
		f12_local0 = LuaUtils.IsDOATarget( Engine.GetLobbyUIScreen() )
	else
		f12_local0 = true
	end
	return f12_local0
end

shared.IsLootHero = function ( hero )
	return false
end

shared.GetLootItemVersion = function ( itemName )
	local lootTable = "gamedata/loot/mplootitems.csv"
	local nameColumn = 1
	local versionColumn = 6
	local matchingRows = Engine.TableFindRows( lootTable, nameColumn, itemName )
	if matchingRows == nil or #matchingRows == 0 then
		return -1
	else
		local version = Engine.TableLookupGetColumnValueForRow( lootTable, matchingRows[1], versionColumn )
		if version == nil or version == "" then
			return -1
		else
			return tonumber( version )
		end
	end
end

shared.GetLootItemCategory = function ( itemName )
	local lootTable = "gamedata/loot/mplootitems.csv"
	local nameColumn = 1
	local categoryColumn = 2
	local matchingRows = Engine.TableFindRows( lootTable, nameColumn, itemName )
	if matchingRows == nil or #matchingRows == 0 then
		return -1
	else
		local category = Engine.TableLookupGetColumnValueForRow( lootTable, matchingRows[1], categoryColumn )
		if category == nil then
			return -1
		else
			return category
		end
	end
end

shared.IsInExperiment = function ( experimentName, allowedVariants )
	local controller = Engine.GetPrimaryController()
	local autoeventsModel = Engine.GetModel( Engine.GetGlobalModel(), "autoevents" )
	if autoeventsModel ~= nil then
		local targetControllerModel = Engine.GetModel( autoeventsModel, "targetController" )
		if targetControllerModel ~= nil then
			controller = Engine.GetModelValue( targetControllerModel )
		end
	end
	local experimentVariant = Engine.ExperimentsGetVariant( controller, experimentName )
	if experimentVariant == nil or experimentVariant == "" or experimentVariant == -1 then
		return false
	end
	experimentVariant = tonumber( experimentVariant )
	for allowedVariant in string.gmatch( allowedVariants, "([^;]+)" ) do
		if allowedVariant ~= nil and allowedVariant ~= "" and experimentVariant == tonumber( allowedVariant ) then
			return true
		end
	end
	return false
end

shared.zmDashboardStatsQuitTypes = {
	dashboard = 0,
	timeout = 1,
	quit = 3,
	completed = 4
}
local f0_local3 = function ( f17_arg0 )
	return {
		hosted = f17_arg0.lastGameWasHosted:get() and "HOSTED" or "PLAYED",
		usedConsumable = f17_arg0.lastGameUsedConsumable:get() and "USED" or "UNUSED",
		wasCoop = f17_arg0.lastGameWasCoop:get() and "SOLO" or "COOP"
	}
end

local f0_local4 = function ( f18_arg0, f18_arg1, f18_arg2 )
	return f18_arg0.gameSizeHistory[f18_arg1.wasCoop].consumablesHistory[f18_arg1.usedConsumable].periodHistory[f18_arg1.hosted][f18_arg2]:get()
end

local f0_local5 = function ( f19_arg0, f19_arg1, f19_arg2, f19_arg3 )
	f19_arg0.gameSizeHistory[f19_arg1.wasCoop].consumablesHistory[f19_arg1.usedConsumable].periodHistory[f19_arg1.hosted][f19_arg2]:set( f0_local4( f19_arg0, f19_arg1, f19_arg2 ) + f19_arg3 )
	f19_arg0.statsSinceLastComscoreEvent[f19_arg2]:set( f19_arg0.statsSinceLastComscoreEvent[f19_arg2]:get() + f19_arg3 )
end

local f0_local6 = function ( f20_arg0, f20_arg1 )
	local f20_local0 = 32
	local f20_local1 = f20_arg0.currentDashboardingTrackingHistoryIndex:get()
	f20_arg0.quitType[f20_local1]:set( shared.zmDashboardStatsQuitTypes[f20_arg1] )
	f20_local1 = (f20_local1 + 1) % f20_local0
	if f20_local1 == 0 then
		f20_arg0.bufferFull:set( 1 )
	end
	f20_arg0.currentDashboardingTrackingHistoryIndex:set( f20_local1 )
end

local f0_local7 = function ( f21_arg0, f21_arg1 )
	local f21_local0 = f0_local4( f21_arg0, f21_arg1, "started" )
	local f21_local1 = 0
	for key, f21_local6 in pairs( shared.zmDashboardStatsQuitTypes ) do
		f21_local1 = f21_local1 + f0_local4( f21_arg0, f21_arg1, key )
	end
	return f21_local0 - f21_local1
end

local f0_local8 = function ( controller )
	local f22_local0 = {}
	for f22_local1 = 0, 255, 1 do
		if Engine.GetItemGroup( f22_local1, Enum.eModes.MODE_ZOMBIES ) == "bubblegum_consumable" then
			local f22_local4 = tonumber( Engine.GetItemMomentumCost( f22_local1, Enum.eModes.MODE_ZOMBIES ) )
			if not f22_local0[f22_local4] then
				f22_local0[f22_local4] = 0
			end
			if Engine.IsLootReady( controller ) and not Engine.IsInventoryBusy( controller ) then
				f22_local0[f22_local4] = f22_local0[f22_local4] + Engine.GetLootItemQuantity( controller, Engine.GetItemRef( f22_local1, Enum.eModes.MODE_ZOMBIES ), Enum.eModes.MODE_ZOMBIES )
			end
		end
	end
	return f22_local0
end

local f0_local9 = function ( controller )
	local sTORAGE_ZM_STATS_ONLINEBuffer = Engine.StorageGetBuffer( controller, Enum.StorageFileType.STORAGE_ZM_STATS_ONLINE )
	if not sTORAGE_ZM_STATS_ONLINEBuffer then
		return 
	end
	local f23_local1 = 1
	local f23_local2 = 2
	local f23_local3 = 3
	local xuid = Engine.GetXUID64( controller )
	local f23_local5 = sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.started:get()
	local f23_local6 = sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.quit:get()
	local f23_local7 = sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.dashboard:get()
	local f23_local8 = sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.timeout:get()
	local f23_local9 = sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.completed:get()
	local f23_local10 = sTORAGE_ZM_STATS_ONLINEBuffer.PlayerStatsList.TOTAL_GAMES_PLAYED.statValue:get()
	local f23_local11 = sTORAGE_ZM_STATS_ONLINEBuffer.PlayerStatsList.TIME_PLAYED_TOTAL.statValue:get()
	local f23_local12 = Engine.IsLootReady( controller ) and Engine.GetZMVials( controller ) or -1
	local f23_local13 = f0_local8( controller )
	local f23_local14
	if Dvar.zm_dash_stats_use_aggregated_comscore:exists() and tonumber( Dvar.zm_dash_stats_use_aggregated_comscore:get() ) > 0 then
		f23_local14 = "zm_dash_quit_types_aggregated"
		if not f23_local14 then
		
		else
			Engine.RecordComScoreEvent( controller, f23_local14, "xuid", xuid, "started", f23_local5, "quit", f23_local6, "dashboard", f23_local7, "timeout", f23_local8, "gamesPlayed", f23_local10, "timePlayed", f23_local11, "vialsCount", f23_local12, "megaCount", f23_local13[f23_local1], "rareCount", f23_local13[f23_local2], "ultraCount", f23_local13[f23_local3] )
			sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.started:set( 0 )
			sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.quit:set( 0 )
			sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.dashboard:set( 0 )
			sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.timeout:set( 0 )
			sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory.statsSinceLastComscoreEvent.completed:set( 0 )
		end
	end
	f23_local14 = "zm_dash_quit_types"
end

shared.IncrementZMDashboardQuitType = function ( controller, f24_arg1, f24_arg2 )
	if shared.IsOnlineGame() and Engine.IsZombiesGame() and Engine.IsSignedInToDemonware( controller ) and Dvar.zm_dash_stats_enable_tracking:exists() and tonumber( Dvar.zm_dash_stats_enable_tracking:get() ) == 1 then
		local sTORAGE_ZM_STATS_ONLINEBuffer = Engine.StorageGetBuffer( controller, Enum.StorageFileType.STORAGE_ZM_STATS_ONLINE )
		sTORAGE_ZM_STATS_ONLINEBuffer = sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory
		if sTORAGE_ZM_STATS_ONLINEBuffer == nil then
			return 
		end
		local f24_local1 = f0_local3( sTORAGE_ZM_STATS_ONLINEBuffer )
		if f0_local7( sTORAGE_ZM_STATS_ONLINEBuffer, f24_local1 ) == 0 then
			return 
		end
		f0_local5( sTORAGE_ZM_STATS_ONLINEBuffer, f24_local1, f24_arg1, f24_arg2 )
		f0_local6( sTORAGE_ZM_STATS_ONLINEBuffer, f24_arg1 )
	end
end

shared.UpdateZMDashboardStat = function ( controller )
	if shared.IsOnlineGame() and Engine.IsZombiesGame() and Engine.IsSignedInToDemonware( controller ) and Dvar.zm_dash_stats_enable_tracking:exists() and tonumber( Dvar.zm_dash_stats_enable_tracking:get() ) == 1 then
		local sTORAGE_ZM_STATS_ONLINEBuffer = Engine.StorageGetBuffer( controller, Enum.StorageFileType.STORAGE_ZM_STATS_ONLINE )
		sTORAGE_ZM_STATS_ONLINEBuffer = sTORAGE_ZM_STATS_ONLINEBuffer.dashboardingTrackingHistory
		if sTORAGE_ZM_STATS_ONLINEBuffer == nil then
			return 
		elseif sTORAGE_ZM_STATS_ONLINEBuffer.trackedFirstGame:get() == 0 then
			return 
		end
		local f25_local1 = f0_local7( sTORAGE_ZM_STATS_ONLINEBuffer, f0_local3( sTORAGE_ZM_STATS_ONLINEBuffer ) )
		for f25_local2 = 1, f25_local1, 1 do
			local f25_local5 = f25_local2
			shared.IncrementZMDashboardQuitType( controller, "dashboard", 1 )
		end
		f0_local9( controller )
	end
end

CoDShared = LuaReadOnlyTables.ReadOnlyTable( shared )