require("ui.t6.CoDBase_og")

CoD.randomMusicTracks = {
    ["titlescreen"] = {
        "mus_gfl_departure", 
        "mus_gfl_elecwar_h",
        "mus_gfl_autonome",
        "mus_gfl_ev5_intermission", 
        "mus_gfl_greenlight",
        "mus_gfl_nihilism",
        "mus_gfl_safety_first",
        "mus_gfl_synthesis_catalyst",
        "mus_gfl_all_systems_go",
        "mus_gfl_fixed_point_lobby",
        "mus_gfl_move_on",
        "mus_gfl_hope",
    },
    ["cp_frontend"] = {
        "mus_gfl_brain", 
        "mus_gfl_departure", 
        "mus_gfl_autonome",
        "mus_gfl_room",
        "mus_gfl_ev5_intermission", 
        "mus_gfl_greenlight",
        "mus_gfl_nihilism",
        "mus_gfl_safety_first",
        "mus_gfl_synthesis_catalyst",
        "mus_gfl_fixed_point_lobby",
        "mus_gfl_move_on",
        "mus_gfl_hope",
    },
    ["zm_cp_frontend"] = {
        "mus_gfl_brain", 
        "mus_gfl_departure", 
        "mus_gfl_autonome",
        "mus_gfl_room",
        "mus_gfl_ev5_intermission", 
        "mus_gfl_greenlight",
        "mus_gfl_nihilism",
        "mus_gfl_safety_first",
        "mus_gfl_synthesis_catalyst",
        "mus_gfl_fixed_point_lobby",
        "mus_gfl_move_on",
        "mus_gfl_hope",
    },
    ["mp_frontend"] = {
        "mus_gfl_brain", 
        "mus_gfl_departure", 
        "mus_gfl_autonome",
        "mus_gfl_room",
        "mus_gfl_greenlight",
        "mus_gfl_nihilism",
        "mus_gfl_safety_first",
        "mus_gfl_synthesis_catalyst",
        "mus_gfl_all_systems_go",
        "mus_gfl_fixed_point_lobby",
        "mus_gfl_move_on",
        "mus_gfl_hope",
    },
    ["zm_frontend"] = {
        "mus_gfl_brain", 
        "mus_gfl_departure", 
        "mus_gfl_elecwar_h",
        "mus_gfl_autonome",
        "mus_gfl_barbarous_funera", 
        "mus_gfl_ev5_intermission", 
        "mus_gfl_greenlight",
        "mus_gfl_nihilism",
        "mus_gfl_safety_first",
        "mus_gfl_synthesis_catalyst",
        "mus_gfl_all_systems_go",
        "mus_gfl_fixed_point_lobby",
        "mus_gfl_move_on",
        "mus_gfl_hope",
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
