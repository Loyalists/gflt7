require("ui.uieditor.actions_og")

function OpenWorkshop(InstanceRef, arg1, arg2)
    Engine.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3019676071")
end

function OpenIOPWiki(InstanceRef, arg1, arg2)
    Engine.OpenURL("https://iopwiki.com")
end

function OpenZMChangeLobby(InstanceRef, arg1, arg2)
    Engine.SendClientScriptNotify( InstanceRef, "lobby_room_changed", "" )
    PlaySoundSetSound( InstanceRef, "action" )
end

function NavigateToLobby(f355_arg0, f355_arg1, f355_arg2, f355_arg3)
    if f355_arg1 == "ZMLobbyOnlineCustomGame" or f355_arg1 == "ZMLobbyOnline" or f355_arg1 == "ZMLobbyLANGame" then
        CoD.TFPCUtil.CheckForRecentUpdate()
        CoD.TFPCUtil.LoadTFOptions()
    end

    CoD.LobbyBase.NavigateToLobby(f355_arg0, f355_arg1, f355_arg2, f355_arg3)
end

function OpenZMChooseCharacterLoadout( f1122_arg0, f1122_arg1, f1122_arg2, f1122_arg3, f1122_arg4 )
	CoD.CCUtility.customizationMode = Enum.eModes.MODE_ZOMBIES
	OpenZMChooseCharacterLoadout_Override( f1122_arg4, f1122_arg2, f1122_arg3 )
end

function OpenZMChooseCharacterLoadout_Override( f77_arg0, f77_arg1, f77_arg2 )
	CoD.LobbyBase.SetLeaderActivity( f77_arg1, CoD.LobbyBase.LeaderActivity.MODIFYING_HERO )
	local f77_local0 = OpenOverlay( f77_arg0, "ChooseZMCharacterLoadout", f77_arg1, f77_arg2 )
	LUI.OverrideFunction_CallOriginalFirst( f77_local0, "close", function ()
		CoD.LobbyBase.ResetLeaderActivity( f77_arg1 )
	end )
	return f77_local0
end

function splitString(inputstr, sep)
    if sep == nil or inputstr == nil then
        return nil
    end
    local t={}
    for str in string.gmatch(tostring(inputstr,""), "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
