require("ui.t6.CoDBase_og")

CoD.randomMusicTracks = {
    ["titlescreen"] = {
        "gfl_departure_loop", 
        "gfl_elecwar_h_loop",
        "gfl_autonome_loop",
        "gfl_ev5_intermission_loop", 
        "gfl_greenlight_loop",
        "gfl_nihilism_loop",
        "gfl_safety_first_loop",
        "gfl_synthesis_catalyst_loop",
        "gfl_all_systems_go_loop",
        "gfl_fixed_point_lobby_loop",
        "gfl_move_on_loop",
        "gfl_hope_loop",
        "gfl_21winter_battle_3_loop",
        "gfl_frontline_loop",
        "gfl_sf_recap_intermission_loop",
        "gfl_the_hunt_loop",
    },
    ["cp_frontend"] = {
        "gfl_brain_loop", 
        "gfl_departure_loop", 
        "gfl_autonome_loop",
        "gfl_room_loop",
        "gfl_ev5_intermission_loop", 
        "gfl_greenlight_loop",
        "gfl_nihilism_loop",
        "gfl_safety_first_loop",
        "gfl_synthesis_catalyst_loop",
        "gfl_fixed_point_lobby_loop",
        "gfl_move_on_loop",
        "gfl_hope_loop",
        "gfl_21winter_battle_3_loop",
        "gfl_frontline_loop",
        "gfl_sf_recap_intermission_loop",
        "gfl_the_hunt_loop",
    },
    ["zm_cp_frontend"] = {
        "gfl_brain_loop", 
        "gfl_departure_loop", 
        "gfl_autonome_loop",
        "gfl_room_loop",
        "gfl_ev5_intermission_loop", 
        "gfl_greenlight_loop",
        "gfl_nihilism_loop",
        "gfl_safety_first_loop",
        "gfl_synthesis_catalyst_loop",
        "gfl_fixed_point_lobby_loop",
        "gfl_move_on_loop",
        "gfl_hope_loop",
        "gfl_21winter_battle_3_loop",
        "gfl_frontline_loop",
        "gfl_sf_recap_intermission_loop",
        "gfl_the_hunt_loop",
    },
    ["mp_frontend"] = {
        "gfl_brain_loop", 
        "gfl_departure_loop", 
        "gfl_autonome_loop",
        "gfl_room_loop",
        "gfl_greenlight_loop",
        "gfl_nihilism_loop",
        "gfl_safety_first_loop",
        "gfl_synthesis_catalyst_loop",
        "gfl_all_systems_go_loop",
        "gfl_fixed_point_lobby_loop",
        "gfl_move_on_loop",
        "gfl_hope_loop",
        "gfl_21winter_battle_3_loop",
        "gfl_frontline_loop",
        "gfl_sf_recap_intermission_loop",
        "gfl_the_hunt_loop",
    },
    ["zm_frontend"] = {
        "gfl_brain_loop", 
        "gfl_departure_loop", 
        "gfl_elecwar_h_loop",
        "gfl_autonome_loop",
        "gfl_barbarous_funera_loop", 
        "gfl_ev5_intermission_loop", 
        "gfl_greenlight_loop",
        "gfl_nihilism_loop",
        "gfl_safety_first_loop",
        "gfl_synthesis_catalyst_loop",
        "gfl_all_systems_go_loop",
        "gfl_fixed_point_lobby_loop",
        "gfl_move_on_loop",
        "gfl_hope_loop",
        "gfl_21winter_battle_3_loop",
        "gfl_frontline_loop",
        "gfl_sf_recap_intermission_loop",
        "gfl_the_hunt_loop",
    },
    ["load_usermaps"] = {
        "gfl_brain", 
        "gfl_room",
        "gfl_hope",
        "gfl_21winter_battle_3",
        "gfl_frontline",
        "gfl_sf_recap_intermission",
        "gfl_the_hunt",
    },
}

CoD.GetRandomMusicTracks = function (menuMusic)
    if CoD.randomMusicTracks == nil or menuMusic == nil then
	    return nil
    end

    local musicTable = CoD.randomMusicTracks[menuMusic]
    if musicTable == nil then
        return nil
    end

    return musicTable[ math.random( #musicTable ) ]
end

CoD.PlayMenuMusic_Internal = function(f25_arg0, f25_arg1, f25_arg2)
    if not f25_arg0 or CoD.curLobbyMusic == f25_arg0 and not f25_arg1 then
        return
    end
    CoD.curLobbyMusic = f25_arg0
    local f25_local0 = Engine.GetPrimaryController()
    local f25_local1 = Enum.FrontendMusicTrackStates.FRONTEND_MUSIC_STATE_DEFAULT
    local f25_local2 = LuaUtils.FindItemInArray(CoD.musicTracks.allowInLobbies, CoD.curLobbyMusic) ~= nil
    local f25_local3 = Engine.StorageGetBuffer(f25_local0, Enum.StorageFileType.STORAGE_COMMON_SETTINGS)
    if f25_local3 then
        f25_local1 = f25_local3.snd_frontendTracksState:get()
        if f25_local1 == Enum.FrontendMusicTrackStates.FRONTEND_MUSIC_STATE_ON and CoD.curLobbyTrack and f25_local2 and
            not f25_arg1 then
            return
        end
    end
    if f25_local1 == Enum.FrontendMusicTrackStates.FRONTEND_MUSIC_STATE_DEFAULT or not f25_local2 then
        CoD.EndCurrentTrack()
        local randomMusic = CoD.GetRandomMusicTracks(CoD.curLobbyMusic)
        if randomMusic ~= nil then
            Engine.PlayMenuMusic(randomMusic)
        else
            Engine.PlayMenuMusic(CoD.curLobbyMusic)
        end
    elseif f25_local1 == Enum.FrontendMusicTrackStates.FRONTEND_MUSIC_STATE_ON then
        CoD.SetupMusicTracks(f25_arg2)
        Engine.PlayMenuMusic("")
        if not f25_arg2 then
            CoD.EndCurrentTrack()
        end
        if not CoD.curLobbyTrack then
            CoD.NextMenuTrack(f25_arg1, not f25_arg1)
        end
    else
        Engine.PlayMenuMusic("")
        CoD.EndCurrentTrack()
    end
end
