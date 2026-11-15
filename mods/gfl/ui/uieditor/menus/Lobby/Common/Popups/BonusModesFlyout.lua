-- 45509ae2f8c1bb8ba97ea9345c77df7d
-- This hash is used for caching, delete to decompile the file again

require( "ui.uieditor.menus.StartMenu.StartMenu_Main" )
require( "ui.uieditor.menus.Social.Social_Main" )
require( "ui.uieditor.widgets.Lobby.Common.FE_List1ButtonLarge_PH" )

local configureMouseInput = function ( self, controller )
	if not CoD.useMouse then
		return 
	else
		self.Options:setHandleMouse( true )
		self.Options:registerEventHandler( "leftclick_outside", function ( element, event )
			CoD.PCUtil.SimulateButtonPress( event.controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE )
			return true
		end )
	end
end

local PostLoadFunc = function ( self, controller )
	configureMouseInput( self, controller )
	self.disableBlur = true
	self.disablePopupOpenCloseAnim = true
	Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "BonusModesFlyoutOpen" ), true )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "BonusModesFlyoutOpen" ), false )
	end )
	self:registerEventHandler( "occlusion_change", function ( element, event )
		local parentElement = element:getParent()
		if parentElement then
			local firstChild = parentElement:getFirstChild()
			while firstChild ~= nil do
				if firstChild.menuName == "Lobby" then
					break
				end
				firstChild = firstChild:getNextSibling()
			end
			if firstChild then
				if event.occluded == true then
					firstChild:setAlpha( 0 )
				end
				firstChild:setAlpha( 1 )
			end
		end
		element:OcclusionChange( event )
	end )
end

DataSources.BonusModesFlyoutButtons = DataSourceHelpers.ListSetup( "BonusModesFlyoutButtons", function ( controller )
	local onlineOptions = {
		{
			optionDisplay = "MENU_SINGLEPLAYER_NIGHTMARES_CAPS",
			customId = "btnCPZM",
			action = function ( self, element, controller, actionParam, menu )
				NavigateToLobby_SelectionListCampaignZombies( self, element, controller, actionParam, menu )
				Close( menu, controller )
			end,
			actionParam = {
				targetName = "CP2LobbyOnline",
				mode = Enum.eModes.MODE_CAMPAIGN,
				firstTimeFlowAction = OpenCPFirstTimeFlow
			},
			disabledFunc = IsCpUnavailable,
			selectedParam = Enum.eModes.MODE_CAMPAIGN,
			starterPackUpgrade = true
		},
		{
			optionDisplay = "MENU_FREERUN_CAPS",
			customId = "btnFROnline",
			action = function ( self, element, controller, actionParam, menu )
				NavigateToLobby_SelectionList( self, element, controller, actionParam, menu )
				Close( menu, controller )
			end,
			actionParam = "FRLobbyOnlineGame",
			selectedFunc = IsMostRecentSessionMode,
			selectedParam = Enum.eModes.MODE_MULTIPLAYER,
			disabledFunc = IsMpUnavailable,
			starterPackUpgrade = false
		},
		{
			optionDisplay = "MENU_DOA2_TITLE",
			customId = "btnDOA",
			action = function ( self, element, controller, actionParam, menu )
				NavigateToLobby_SelectionListDOA( self, element, controller, actionParam, menu )
				Close( menu, controller )
			end,
			actionParam = {
				targetName = "CPDOALobbyOnline",
				mode = Enum.eModes.MODE_CAMPAIGN,
				firstTimeFlowAction = OpenCPFirstTimeFlow
			},
			disabledFunc = IsCpUnavailable,
			selectedParam = Enum.eModes.MODE_CAMPAIGN,
			starterPackUpgrade = true
		},
		-- {
		-- 	optionDisplay = "GFL_MENU_IOP_WIKI",
		-- 	customId = "btnIOPWIKI",
		-- 	action = function ( f9_arg0, f9_arg1, f9_arg2, f9_arg3, f9_arg4 )
		-- 		OpenIOPWiki()
		-- 		Close( f9_arg4, f9_arg2 )
		-- 	end,
		-- 	starterPackUpgrade = false
		-- },
		{
			optionDisplay = "GFL_MENU_WORKSHOP_CAPS",
			customId = "btnOpenWorkshopInBonus",
			action = function ( self, element, controller, actionParam, menu )
				OpenWorkshop()
				Close( menu, controller )
			end,
			starterPackUpgrade = false
		}
	}
	local localOptions = {
		{
			optionDisplay = "MENU_SINGLEPLAYER_NIGHTMARES_CAPS",
			customId = "btnCPZM",
			action = function ( self, element, controller, actionParam, menu )
				NavigateToLobby_SelectionListCampaignZombies( self, element, controller, actionParam, menu )
				Close( menu, controller )
			end,
			actionParam = {
				targetName = "CP2LobbyLANGame",
				mode = Enum.eModes.MODE_CAMPAIGN,
				firstTimeFlowAction = OpenCPFirstTimeFlow
			},
			disabledFunc = IsCpUnavailable,
			selectedParam = Enum.eModes.MODE_CAMPAIGN,
			starterPackUpgrade = true
		},
		{
			optionDisplay = "MENU_FREERUN_CAPS",
			customId = "btnFRLan",
			action = function ( self, element, controller, actionParam, menu )
				NavigateToLobby_SelectionList( self, element, controller, actionParam, menu )
				Close( menu, controller )
			end,
			actionParam = "FRLobbyLANGame",
			selectedFunc = IsMostRecentSessionMode,
			selectedParam = Enum.eModes.MODE_MULTIPLAYER,
			disabledFunc = IsMpUnavailable,
			starterPackUpgrade = false
		},
		{
			optionDisplay = "MENU_DOA2_TITLE",
			customId = "btnDOA",
			action = function ( self, element, controller, actionParam, menu )
				NavigateToLobby_SelectionListDOA( self, element, controller, actionParam, menu )
				Close( menu, controller )
			end,
			actionParam = {
				targetName = "CPDOALobbyLANGame",
				mode = Enum.eModes.MODE_CAMPAIGN,
				firstTimeFlowAction = OpenCPFirstTimeFlow
			},
			disabledFunc = IsCpUnavailable,
			selectedParam = Enum.eModes.MODE_CAMPAIGN,
			starterPackUpgrade = true
		},
		-- {
		-- 	optionDisplay = "GFL_MENU_IOP_WIKI",
		-- 	customId = "btnIOPWIKI",
		-- 	action = function ( f9_arg0, f9_arg1, f9_arg2, f9_arg3, f9_arg4 )
		-- 		OpenIOPWiki()
		-- 		Close( f9_arg4, f9_arg2 )
		-- 	end,
		-- 	starterPackUpgrade = false
		-- },
		{
			optionDisplay = "GFL_MENU_WORKSHOP_CAPS",
			customId = "btnOpenWorkshopInBonus",
			action = function ( self, element, controller, actionParam, menu )
				OpenWorkshop()
				Close( menu, controller )
			end,
			starterPackUpgrade = false
		}
	}
	local items = {}
	local selectedOptions = localOptions
	if Enum.LobbyNetworkMode.LOBBY_NETWORKMODE_LIVE == Engine.GetLobbyNetworkMode() then
		selectedOptions = onlineOptions
	end
	for index, option in ipairs( selectedOptions ) do
		table.insert( items, {
			models = {
				displayText = Engine.Localize( option.optionDisplay ),
				customId = option.customId,
				selectedFunc = option.selectedFunc
			},
			properties = {
				title = option.optionDisplay,
				desc = option.desc,
				action = option.action,
				actionParam = option.actionParam,
				selectedParam = option.selectedParam,
				requiredChunk = option.selectedParam,
				starterPackUpgrade = option.starterPackUpgrade,
				disabled = false
			}
		} )
	end
	return items
end, nil, nil, nil )
LUI.createMenu.BonusModesFlyout = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "BonusModesFlyout" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "default"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "BonusModesFlyout.buttonPrompts" )
	local menu = self
	self.anyChildUsesUpdateState = true
	
	local Options = LUI.UIList.new( menu, controller, -2, 0, nil, false, false, 0, 0, false, false )
	Options:makeFocusable()
	Options:setLeftRight( true, false, 232.43, 512.43 )
	Options:setTopBottom( true, false, 409.56, 501.56 )
	Options:setXRot( -2 )
	Options:setYRot( 25 )
	Options:setWidgetType( CoD.FE_List1ButtonLarge_PH )
	Options:setVerticalCount( 5 )
	Options:setSpacing( -2 )
	Options:setDataSource( "BonusModesFlyoutButtons" )
	Options:registerEventHandler( "gain_focus", function ( element, event )
		local focusResult = nil
		if element.gainFocus then
			focusResult = element:gainFocus( event )
		elseif element.super.gainFocus then
			focusResult = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return focusResult
	end )
	Options:registerEventHandler( "lose_focus", function ( element, event )
		local focusResult = nil
		if element.loseFocus then
			focusResult = element:loseFocus( event )
		elseif element.super.loseFocus then
			focusResult = element.super:loseFocus( event )
		end
		return focusResult
	end )
	menu:AddButtonCallbackFunction( Options, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, event )
		ProcessListAction( self, element, controller )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( Options )
	self.Options = Options
	
	self:mergeStateConditions( {
		{
			stateName = "Local",
			condition = function ( menu, element, event )
				return IsLobbyNetworkModeLAN()
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNetworkMode" ), function ( model )
		local menu2 = self
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNetworkMode"
		}
		CoD.Menu.UpdateButtonShownState( menu2, menu, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ), function ( model )
		local menu2 = self
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNav"
		}
		CoD.Menu.UpdateButtonShownState( menu2, menu, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
	end )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, event )
		GoBack( self, controller )
		ClearMenuSavedState( menu )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "" )
		return false
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_START, "M", function ( element, menu, controller, event )
		GoBackAndOpenOverlayOnParent( self, "StartMenu_Main", controller )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_START, "MENU_MENU" )
		return true
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "S", function ( element, menu, controller, event )
		if not IsLAN() and not IsPlayerAGuest( controller ) and IsPlayerAllowedToPlayOnline( controller ) then
			GoBackAndOpenOverlayOnParent( self, "Social_Main", controller )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if not IsLAN() and not IsPlayerAGuest( controller ) and IsPlayerAllowedToPlayOnline( controller ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "" )
			return false
		else
			return false
		end
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_LB, nil, function ( element, menu, controller, event )
		SendButtonPressToOccludedMenu( menu, controller, event, Enum.LUIButton.LUI_KEY_LB )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_LB, "" )
		return false
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_RB, nil, function ( element, menu, controller, event )
		SendButtonPressToOccludedMenu( menu, controller, event, Enum.LUIButton.LUI_KEY_RB )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_RB, "" )
		return false
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, nil, function ( element, menu, controller, event )
		SendButtonPressToOccludedMenu( menu, controller, event, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "" )
		return true
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_LTRIG, "U", function ( element, menu, controller, event )
		if IsStarterPack( controller ) then
			StarterParckPurchase( self, controller, menu )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if IsStarterPack( controller ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_LTRIG, "PLATFORM_STARTER_PACK_UPGRADE_TITLE" )
			return true
		else
			return false
		end
	end, false )
	Options.id = "Options"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = menu
	} )
	if not self:restoreState() then
		self.Options:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Options:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "BonusModesFlyout.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

