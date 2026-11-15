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

function NavigateToLobby(menu, lobbyName, addToHistory, controller)
    if lobbyName == "ZMLobbyOnlineCustomGame" or lobbyName == "ZMLobbyOnline" or lobbyName == "ZMLobbyLANGame" then
        CoD.TFPCUtil.CheckForRecentUpdate()
        CoD.TFPCUtil.LoadTFOptions()
    end

	CoD.PersonalizationUtil.CheckForRecentUpdate()
	CoD.PersonalizationUtil.LoadPersonalization()

    CoD.LobbyBase.NavigateToLobby(menu, lobbyName, addToHistory, controller)
end

function OpenZMChooseCharacterLoadout( self, element, controller, actionParam, menu )
	CoD.CCUtility.customizationMode = Enum.eModes.MODE_ZOMBIES
	OpenZMChooseCharacterLoadout_Override( menu, controller, actionParam )
end

function OpenZMChooseCharacterLoadout_Override( menu, controller, openParams )
	CoD.LobbyBase.SetLeaderActivity( controller, CoD.LobbyBase.LeaderActivity.MODIFYING_HERO )
	local overlay = OpenOverlay( menu, "ChooseZMCharacterLoadout", controller, openParams )
	LUI.OverrideFunction_CallOriginalFirst( overlay, "close", function ()
		CoD.LobbyBase.ResetLeaderActivity( controller )
	end )
	return overlay
end

function OpenZMChooseCharacterLoadout_InGame( menu, element, controller )
	OpenOverlay( menu, "ChooseZMCharacterLoadout_InGame", controller )
end

function OpenTFOptions( menu, element, controller, actionParam, parentMenu )
	CoD.LobbyBase.OpenTFOptions( menu, controller )
end

function OpenTFOptions_InGame( menu, element, controller )
	if not (Dvar.tfoption_tf_enabled:exists() and Dvar.tfoption_tf_enabled:get() == 0) then
		CoD.TFPCUtil.CheckForRecentUpdate()
		CoD.TFPCUtil.LoadTFOptions()
	end

	OpenOverlay(menu, "TFOptions", controller)
end

function OpenPersonalizationOptions( menu, element, controller, actionParam, parentMenu )
	CoD.LobbyBase.OpenPersonalizationOptions( menu, controller )
end

function OpenModInfo( menu, element, controller, actionParam, parentMenu )
	OpenOverlay(menu, "ModInfo", controller)
end

function OpenModInfo_InGame( menu, element, controller )
	OpenOverlay(menu, "ModInfo", controller)
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
			DataSources.ZMInfoPopup_List = DataSourceHelpers.ListSetup( "ZMInfoPopup_List", function ( controller )
				return {
					{
						models = {
							displayText = Engine.Localize( "MENU_OK_CAPS" )
						},
						properties = {
							action = function ( self, element, controller, actionParam, menu )
								GoBack( menu, controller )
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
	local parentMenu = self:getParentMenu()
	local f726_local1 = nil
	local f726_local2 = ""
	local f726_local3 = nil
	if FeaturedCards_IsEnabled( element, controller ) == false then
		return 
	end
	local model = nil
	if self.LeftContainer.FEFeaturedCardsContainer.CardsList.activeWidget ~= nil then
		model = self.LeftContainer.FEFeaturedCardsContainer.CardsList.activeWidget:getModel()
	end
	if model then
		f726_local2 = CoD.SafeGetModelValue( model, "action" )
		f726_local3 = CoD.SafeGetModelValue( model, "isExperimentPromo" )
	end
	if f726_local2 == "openwelcome" then
		OpenOverlay( parentMenu, "WelcomeMenu", controller )
	elseif f726_local2 ~= nil and LUI.startswith( f726_local2, "store" ) then
		LUI.CoDMetrics.CRMMessageInteraction( self, controller, "crm_featured" )
		if CoD.isPC then
			OpenSteamStore( self, element, controller, "FeaturedWidget", parentMenu )
		else
			CoD.StoreUtility.SetupFocusCategory( controller, f726_local2 )
			OpenStore( self, element, controller, "FeaturedWidget", parentMenu )
		end
	elseif f726_local2 == "opengroups" then
		OpenGroups( self, element, controller, param, parentMenu )
	elseif f726_local2 == "opencrm" then
		LUI.CoDMetrics.CRMMessageInteraction( self, controller, "crm_featured" )
		local f726_local5 = false
		if model then
			local index = CoD.SafeGetModelValue( model, "index" )
			if index then
				local marketingMessage = Engine.GetMarketingMessage( controller, "crm_featured", index )
				if marketingMessage and marketingMessage.action == "popup_video" and marketingMessage.popup_image then
					Engine.SetModelValue( Engine.GetModel( DataSources.VoDViewer.getModel( controller ), "stream" ), marketingMessage.popup_image )
					OpenPopup( parentMenu, "VoDViewer", controller )
					f726_local5 = true
				end
			end
		end
		if not f726_local5 then
			OpenCRMFeaturedPopup( self, element, controller, "Featured", parentMenu )
		end
	elseif f726_local2 == "openmotd" then
		OpenMOTDPopup( self, element, controller, "FeaturedWidget", parentMenu )
	elseif f726_local2 == "liveevent" then
		if CoD.isPC then
			local stream = CoD.SafeGetModelValue( DataSources.LiveEventViewer.getModel( controller ), "stream" )
			if stream and stream ~= "" then
				Engine.OpenURL( "http://www.twitch.tv/" .. stream )
			end
		else
			OpenPopup( parentMenu, "LiveEventViewer", controller )
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
		OpenMegaChewFactorymenu( self, element, controller, param, parentMenu )
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
		OpenGobbleGumCookbookMenu( self, element, controller, param, parentMenu )
	elseif f726_local2 == "open_zmhd_thermometer" then
		OpenOverlay( self, "ZMHD_Community_Theme", controller )
	elseif f726_local2 == "gfl_open_zm_intel" then
		-- OpenZMInfoPopupOverlay( self, f726_local0, controller )
		OpenZMInfoPopup( controller )
	elseif f726_local2 == "gfl_open_welcomemenu" then
		OpenZMWelcomeMenu( parentMenu, nil, controller )
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
			DataSources.ConfigureCheatsPopup_List = DataSourceHelpers.ListSetup( "ConfigureCheatsPopup_List", function ( controller )
				return {
					{
						models = {
							displayText = Engine.Localize( "MENU_DISABLE_CAPS" )
						},
						properties = {
							action = function ( self, element, controller, actionParam, menu )
                                Engine.SetDvar( "tfoption_cheats", 0 )
								GoBack( menu, controller )
							end
							
						}
					},
					{
						models = {
							displayText = Engine.Localize( "MENU_ENABLE_CAPS" )
						},
						properties = {
							action = function ( self, element, controller, actionParam, menu )
                                Engine.SetDvar( "tfoption_cheats", 1 )
                                GoBack( menu, controller )
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

function HandleToggleThirdPersonButton( self, element, controller )
	Engine.SendMenuResponse(controller, "popup_leavegame", "ThirdPerson")
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