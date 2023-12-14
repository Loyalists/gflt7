require("ui.t7.utility.LobbyUtility_og")

CoD.LobbyUtility.GetMaxClientCount = function ()
	if Dvar.fs_game_saved:exists() and Dvar.sv_hostname:exists() and Dvar.sv_hostname:get() ~= "BlackOpsPublic" and Dvar.sv_hostname:get() ~= "Dedicated - dedicatedpc" and Dvar.sv_hostname:get() ~= "" then
		Engine.SetDvar("fs_game", Dvar.fs_game_saved:get())
	end

	if Engine.IsLobbyActive( Enum.LobbyType.LOBBY_TYPE_GAME ) then
		return Engine.GetLobbyMaxClients( Enum.LobbyModule.LOBBY_MODULE_CLIENT, Enum.LobbyType.LOBBY_TYPE_GAME )
	else
		return Engine.GetLobbyMaxClients( Enum.LobbyModule.LOBBY_MODULE_CLIENT, Enum.LobbyType.LOBBY_TYPE_PRIVATE )
	end
end