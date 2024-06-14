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

function OpenTFOptions( f206_arg0, f206_arg1, f206_arg2, f206_arg3, f206_arg4 )
	CoD.LobbyBase.OpenTFOptions( f206_arg0, f206_arg2 )
end

function OpenModInfo( f206_arg0, f206_arg1, f206_arg2, f206_arg3, f206_arg4 )
	CoD.LobbyBase.OpenModInfo( f206_arg0, f206_arg2 )
end

function OpenZMInfoPopup( InstanceRef, arg1, arg2 )
    LuaUtils.UI_ShowInfoMessageDialog( InstanceRef, "GFL_MODINFO_ZM_INFO_DESC", "GFL_MODINFO_ZM_INFO_TITLE" )
end

function OpenCPInfoPopup( InstanceRef, arg1, arg2 )
    LuaUtils.UI_ShowInfoMessageDialog( InstanceRef, "GFL_MODINFO_CP_INFO_DESC", "GFL_MODINFO_CP_INFO_TITLE" )
end

function OpenMPInfoPopup( InstanceRef, arg1, arg2 )
    LuaUtils.UI_ShowInfoMessageDialog( InstanceRef, "GFL_MODINFO_MP_INFO_DESC", "GFL_MODINFO_MP_INFO_TITLE" )
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

function OpenConfigureCheatsPopup( f108_arg0, f108_arg1, f108_arg2, f108_arg3, f108_arg4 )
	CoD.OverlayUtility.AddSystemOverlay( "ConfigureCheatsPopup", {
		menuName = "SystemOverlay_Compact",
		title = "GFL_MENU_CONFIGURE_CHEATS",
		description = "TF_CHEATS_DESC",
		listDatasource = function ()
			DataSources.ConfigureCheatsPopup_List = DataSourceHelpers.ListSetup( "ConfigureCheatsPopup_List", function ( f110_arg0 )
				return {
					{
						models = {
							displayText = Engine.Localize( "MENU_DISABLE_CAPS" )
						},
						properties = {
							action = function ( f30_arg0, f30_arg1, f30_arg2, f30_arg3, f30_arg4 )
                                Engine.SetDvar( "tfoption_cheats", 0 )
								GoBack( f30_arg4, f30_arg2 )
							end
							
						}
					},
					{
						models = {
							displayText = Engine.Localize( "MENU_ENABLE_CAPS" )
						},
						properties = {
							action = function ( f31_arg0, f31_arg1, f31_arg2, f31_arg3, f31_arg4 )
                                Engine.SetDvar( "tfoption_cheats", 1 )
                                GoBack( f31_arg4, f31_arg2 )
							end
							
						}
					}
				}
			end, true, nil )
			return "ConfigureCheatsPopup_List"
		end,
		[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack,
		categoryType = CoD.OverlayUtility.OverlayTypes.GenericMessage
	} )
	CoD.OverlayUtility.CreateOverlay( f108_arg2, f108_arg0, "ConfigureCheatsPopup" )
end

function GetCharacterImageName(character)
	local prefix = "t7_gfl_chibi_"
	local suffix = "m16a1"
    if character ~= nil then
        suffix = string.lower(character)
    end

	local fullname = prefix .. suffix
	
    return fullname
end

function ClearNotificationQueue( container )
	container.notificationInProgress = false
	Engine.SetModelValue( container.notificationQueueEmptyModel, true )
end

function AddSimpleNotification( controller, container, image, title, description )
	local localizedTitle = ""
	local localizedDescription = ""
	if title then
		localizedTitle = Engine.Localize( Engine.ToUpper(title) )
	end

	if description then
		localizedDescription = Engine.Localize( Engine.ToUpper(description) )
	end
    
	container:appendNotification( {
		clip = "TextandImageBGB",
		title = localizedTitle,
        description = localizedDescription,
		bgbImage = RegisterImage( image )
	} )
end

function AddCharacterNotification( controller, container, character )
	local ref = "GFL_CHARACTER_"
    local title = Engine.Localize( Engine.ToUpper(ref .. character .. "_NAME") )
    -- local description = Engine.Localize( Engine.ToUpper(ref .. character .. "_DESC") )
    local description = ""
    
	container:appendNotification( {
		clip = "TextandImageBGB",
		title = title,
        description = description,
		bgbImage = RegisterImage( GetCharacterImageName( character ) )
	} )
end

function AddCheatsNotification( controller, container, model )
	container:appendNotification( {
		clip = "TextandImageBasic",
		title = Engine.Localize( "GFL_CHEATS_ENABLED" ),
		description = ""
	} )
end