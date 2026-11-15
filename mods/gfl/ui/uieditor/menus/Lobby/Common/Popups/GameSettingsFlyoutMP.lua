-- 03b233c817e994b4ef203215a56b98e3
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
	Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "GameSettingsFlyoutOpen" ), true )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "GameSettingsFlyoutOpen" ), false )
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
	self:subscribeToModel( Engine.CreateModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav", true ), function ( model )
		local occludedBy = self.occludedBy
		while occludedBy do
			if occludedBy.occludedBy ~= nil then
				occludedBy = occludedBy.occludedBy
			end
			while occludedBy and occludedBy.menuName ~= "Lobby" do
				occludedBy = GoBack( occludedBy, controller )
			end
			Engine.SendClientScriptNotify( controller, "menu_change" .. Engine.GetLocalClientNum( controller ), "Main", "closeToMenu" )
			return 
		end
		GoBack( self, controller )
	end, false )
end

DataSources.GameSettingsFlyoutButtons = DataSourceHelpers.ListSetup( "GameSettingsFlyoutButtons", function ( controller )
	local options = {
		{
			optionDisplay = "MPUI_CHANGE_MAP_CAPS",
			customId = "btnChangeMap",
			action = OpenChangeMap
		},
		{
			optionDisplay = "MPUI_CHANGE_GAME_MODE_CAPS",
			customId = "btnChangeGameMode",
			action = OpenChangeGameMode
		},
		{
			optionDisplay = "MPUI_EDIT_GAME_RULES_CAPS",
			customId = "btnEditGameRules",
			action = OpenEditGameRules
		},
		{
			optionDisplay = "MENU_SETUP_BOTS_CAPS",
			customId = "btnSetupBots",
			action = OpenBotSettings
		},
		{
			optionDisplay = "GFL_MENU_CONFIGURE_CHEATS",
			customId = "btnConfigureCheatsPopup",
			action = OpenConfigureCheatsPopup
		}
	}
	if CoD.isPC and IsServerBrowserEnabled() then
		table.insert( options, {
			optionDisplay = "PLATFORM_SERVER_SETTINGS_CAPS",
			customID = "btnServerSettings",
			action = OpenServerSettings
		} )
	end
	local items = {}
	for index, option in ipairs( options ) do
		table.insert( items, {
			models = {
				displayText = Engine.Localize( option.optionDisplay ),
				customId = option.customId,
				disabled = option.disabled
			},
			properties = {
				title = option.optionDisplay,
				desc = option.desc,
				action = option.action,
				actionParam = option.actionParam
			}
		} )
	end
	return items
end, nil, nil, nil )

LUI.createMenu.GameSettingsFlyoutMP = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "GameSettingsFlyoutMP" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "default"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "GameSettingsFlyoutMP.buttonPrompts" )
	local self2 = self
	self.anyChildUsesUpdateState = true
	
	local Options = LUI.UIList.new( self2, controller, -2, 0, nil, false, false, 0, 0, false, false )
	Options:makeFocusable()
	Options:setLeftRight( true, false, 243.43, 523.43 )
	Options:setTopBottom( true, false, 177.56, 329.56 )
	Options:setYRot( 25 )
	Options:setWidgetType( CoD.FE_List1ButtonLarge_PH )
	Options:setVerticalCount( 6 )
	Options:setSpacing( -2 )
	Options:setDataSource( "GameSettingsFlyoutButtons" )
	Options:registerEventHandler( "gain_focus", function ( element, event )
		local focusResult = nil
		if element.gainFocus then
			focusResult = element:gainFocus( event )
		elseif element.super.gainFocus then
			focusResult = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, self2, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
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
	self2:AddButtonCallbackFunction( Options, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, event )
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
		local menu = self
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNetworkMode"
		}
		CoD.Menu.UpdateButtonShownState( menu, self2, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ), function ( model )
		local menu = self
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNav"
		}
		CoD.Menu.UpdateButtonShownState( menu, self2, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
	end )
	self2:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, model )
		GoBack( self, controller )
		ClearMenuSavedState( menu )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "" )
		return false
	end, false )
	self2:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_START, "M", function ( element, menu, controller, model )
		GoBackAndOpenOverlayOnParent( self, "StartMenu_Main", controller )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_START, "MENU_MENU" )
		return true
	end, false )
	self2:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "S", function ( element, menu, controller, event )
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
	self2:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_LB, nil, function ( element, menu, controller, event )
		SendButtonPressToOccludedMenu( menu, controller, event, Enum.LUIButton.LUI_KEY_LB )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_LB, "" )
		return false
	end, false )
	self2:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_RB, nil, function ( element, menu, controller, event )
		SendButtonPressToOccludedMenu( menu, controller, event, Enum.LUIButton.LUI_KEY_RB )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_RB, "" )
		return false
	end, false )
	Options.id = "Options"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = self2
	} )
	if not self:restoreState() then
		self.Options:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Options:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "GameSettingsFlyoutMP.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

