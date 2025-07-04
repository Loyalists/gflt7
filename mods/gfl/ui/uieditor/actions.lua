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

function OpenChangeLogs(InstanceRef, arg1, arg2)
    Engine.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/changelog/3019676071")
end

function NavigateToLobby(f355_arg0, f355_arg1, f355_arg2, f355_arg3)
    if f355_arg1 == "ZMLobbyOnlineCustomGame" or f355_arg1 == "ZMLobbyOnline" or f355_arg1 == "ZMLobbyLANGame" then
        CoD.TFPCUtil.CheckForRecentUpdate()
        CoD.TFPCUtil.LoadTFOptions()
    end

	CoD.PersonalizationUtil.CheckForRecentUpdate()
	CoD.PersonalizationUtil.LoadPersonalization()

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

function OpenZMChooseCharacterLoadout_InGame( f427_arg0, f427_arg1, f427_arg2 )
	OpenOverlay( f427_arg0, "ChooseZMCharacterLoadout_InGame", f427_arg2 )
end

function OpenTFOptions( f206_arg0, f206_arg1, f206_arg2, f206_arg3, f206_arg4 )
	CoD.LobbyBase.OpenTFOptions( f206_arg0, f206_arg2 )
end

function OpenTFOptions_InGame( f427_arg0, f427_arg1, f427_arg2 )
	if not (Dvar.tfoption_tf_enabled:exists() and Dvar.tfoption_tf_enabled:get() == 0) then
		CoD.TFPCUtil.CheckForRecentUpdate()
		CoD.TFPCUtil.LoadTFOptions()
	end

	OpenOverlay(f427_arg0, "TFOptions", f427_arg2)
end

function OpenPersonalizationOptions( f206_arg0, f206_arg1, f206_arg2, f206_arg3, f206_arg4 )
	CoD.LobbyBase.OpenPersonalizationOptions( f206_arg0, f206_arg2 )
end

function OpenModInfo( f206_arg0, f206_arg1, f206_arg2, f206_arg3, f206_arg4 )
	OpenOverlay(f206_arg0, "ModInfo", f206_arg2)
end

function OpenModInfo_InGame( f427_arg0, f427_arg1, f427_arg2 )
	OpenOverlay(f427_arg0, "ModInfo", f427_arg2)
end

function OpenZMWelcomeMenu( self, element, controller )
    OpenOverlay( self, "GFLWelcomeMenu", controller )
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

function OpenZMInfoPopupOverlay( self, menu, controller, overlayName, expressionArg )
	CoD.OverlayUtility.AddSystemOverlay( "ZMInfoPopup", {
		menuName = "SystemOverlay_Full",
		title = "GFL_MODINFO_ZM_INFO_TITLE",
		description = "GFL_MODINFO_ZM_INFO_DESC",
		listDatasource = function ()
			DataSources.ZMInfoPopup_List = DataSourceHelpers.ListSetup( "ZMInfoPopup_List", function ( f110_arg0 )
				return {
					{
						models = {
							displayText = Engine.Localize( "MENU_OK_CAPS" )
						},
						properties = {
							action = function ( f30_arg0, f30_arg1, f30_arg2, f30_arg3, f30_arg4 )
								GoBack( f30_arg4, f30_arg2 )
							end
							
						}
					},
				}
			end, true, nil )
			return "ZMInfoPopup_List"
		end,
		[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack,
		categoryType = CoD.OverlayUtility.OverlayTypes.GenericMessage
	} )
	CoD.OverlayUtility.CreateOverlay( controller, self, "ZMInfoPopup" )
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

function FeaturedCardsActionButtonHandler( self, element, controller, param, menu )
	local f726_local0 = self:getParentMenu()
	local f726_local1 = nil
	local f726_local2 = ""
	local f726_local3 = nil
	if FeaturedCards_IsEnabled( element, controller ) == false then
		return 
	end
	local f726_local4 = nil
	if self.LeftContainer.FEFeaturedCardsContainer.CardsList.activeWidget ~= nil then
		f726_local4 = self.LeftContainer.FEFeaturedCardsContainer.CardsList.activeWidget:getModel()
	end
	if f726_local4 then
		f726_local2 = CoD.SafeGetModelValue( f726_local4, "action" )
		f726_local3 = CoD.SafeGetModelValue( f726_local4, "isExperimentPromo" )
	end
	if f726_local2 == "openwelcome" then
		OpenOverlay( f726_local0, "WelcomeMenu", controller )
	elseif f726_local2 ~= nil and LUI.startswith( f726_local2, "store" ) then
		LUI.CoDMetrics.CRMMessageInteraction( self, controller, "crm_featured" )
		if CoD.isPC then
			OpenSteamStore( self, element, controller, "FeaturedWidget", f726_local0 )
		else
			CoD.StoreUtility.SetupFocusCategory( controller, f726_local2 )
			OpenStore( self, element, controller, "FeaturedWidget", f726_local0 )
		end
	elseif f726_local2 == "opengroups" then
		OpenGroups( self, element, controller, param, f726_local0 )
	elseif f726_local2 == "opencrm" then
		LUI.CoDMetrics.CRMMessageInteraction( self, controller, "crm_featured" )
		local f726_local5 = false
		if f726_local4 then
			local f726_local6 = CoD.SafeGetModelValue( f726_local4, "index" )
			if f726_local6 then
				local f726_local7 = Engine.GetMarketingMessage( controller, "crm_featured", f726_local6 )
				if f726_local7 and f726_local7.action == "popup_video" and f726_local7.popup_image then
					Engine.SetModelValue( Engine.GetModel( DataSources.VoDViewer.getModel( controller ), "stream" ), f726_local7.popup_image )
					OpenPopup( f726_local0, "VoDViewer", controller )
					f726_local5 = true
				end
			end
		end
		if not f726_local5 then
			OpenCRMFeaturedPopup( self, element, controller, "Featured", f726_local0 )
		end
	elseif f726_local2 == "openmotd" then
		OpenMOTDPopup( self, element, controller, "FeaturedWidget", f726_local0 )
	elseif f726_local2 == "liveevent" then
		if CoD.isPC then
			local f726_local6 = CoD.SafeGetModelValue( DataSources.LiveEventViewer.getModel( controller ), "stream" )
			if f726_local6 and f726_local6 ~= "" then
				Engine.OpenURL( "http://www.twitch.tv/" .. f726_local6 )
			end
		else
			OpenPopup( f726_local0, "LiveEventViewer", controller )
		end
	elseif f726_local2 == "blackmarket" then
		if f726_local3 then
			LUI.CoDMetrics.ExperimentPromoFeatureCardEvent( controller, Engine.ExperimentsGetVariant( Engine.GetPrimaryController(), "chris_variable_discount" ) )
		else
			LUI.CoDMetrics.CRMMessageInteraction( self, controller, "crm_featured" )
		end
		Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "blackmarketOpenSource" ), Engine.GetCurrentMode() )
		Engine.SwitchMode( controller, "mp" )
		OpenBlackMarket( self, nil, controller )
	elseif f726_local2 == "drmonty" then
		LUI.CoDMetrics.CRMMessageInteraction( self, controller, "crm_featured" )
		CoD.perController[controller].cameFromFeaturedCard = true
		Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "megachewOpenSource" ), Engine.GetCurrentMode() )
		Engine.SwitchMode( controller, "zm" )
		OpenMegaChewFactorymenu( self, element, controller, param, f726_local0 )
	elseif f726_local2 == "contracts" then
		Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "contractsOpenSource" ), Engine.GetCurrentMode() )
		Engine.SwitchMode( controller, "mp" )
		LuaUtils.CycleContracts()
		OpenOverlay( self, "BM_Contracts", controller )
	elseif f726_local2 == "promo" then
		Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "promoOpenSource" ), Engine.GetCurrentMode() )
		Engine.SwitchMode( controller, "mp" )
		OpenOverlay( self, "ZMHD_Community_Theme", controller, "", "" )
	elseif f726_local2 == "open_daily_challenge" then
		Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "dailyChallengeOpenSource" ), Engine.GetCurrentMode() )
		Engine.SwitchMode( controller, "zm" )
		CoD.OverlayUtility.CreateOverlay( controller, self, "InspectDailyChallengeOverlay", controller )
	elseif f726_local2 == "open_cookbook" then
		Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "cookbookRecipeOpenSource" ), Engine.GetCurrentMode() )
		Engine.SwitchMode( controller, "zm" )
		OpenGobbleGumCookbookMenu( self, element, controller, param, f726_local0 )
	elseif f726_local2 == "open_zmhd_thermometer" then
		OpenOverlay( self, "ZMHD_Community_Theme", controller )
	elseif f726_local2 == "gfl_open_zm_intel" then
		-- OpenZMInfoPopupOverlay( self, f726_local0, controller )
		OpenZMInfoPopup( controller )
	elseif f726_local2 == "gfl_open_welcomemenu" then
		OpenZMWelcomeMenu( f726_local0, nil, controller )
	elseif f726_local2 == "gfl_open_changelogs" then
		OpenChangeLogs( controller )
	end
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
	local suffix = ""
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

function SendChatNotifyResponse( controller, sending_Text )
	Engine.SendMenuResponse(controller, "popup_leavegame", "ChatNotify" .. "…" .. string.gsub(tostring(sending_Text), " ", "¨"))
end

function GetMaxScreenRotLeft(rot)
    if Engine.DvarInt(nil, "rot_y_na") == 1 then
        rot = 0 - rot
    end
    local rot_set = Engine.DvarInt(nil, "rot_y")
    if rot > rot_set then
        rot = rot_set
    end
    if rot < 0 - rot_set then
        rot = 0 - rot_set
    end
    return rot
end

function GetMaxScreenRot(rot)
    if Engine.DvarInt(nil, "rot_x_na") == 1 then
        rot = 0 - rot
    end
    local rot_set = Engine.DvarInt(nil, "rot_x")
    if rot > rot_set then
        rot = rot_set
    end
    if rot < 0 - rot_set then
        rot = 0 - rot_set
    end
    return rot
end

function GetMaxScreenOffset(offset)
    if Engine.DvarInt(nil, "offset_y_na") == 1 then
        offset = 0 - offset
    end
    local offset_set = Engine.DvarInt(nil, "offset_y")
    if offset > offset_set then
        offset = offset_set
    end
    if offset < 0 - offset_set then
        offset = 0 - offset_set
    end
    return offset
end

function GetMaxScreenOffsetLeft(offset)    
    if Engine.DvarInt(nil, "offset_x_na") == 1 then
        offset = 0 - offset
    end
    local offset_set = Engine.DvarInt(nil, "offset_x")
    if offset > offset_set then
        offset = offset_set
    end
    if offset < 0 - offset_set then
        offset = 0 - offset_set
    end
    return offset
end