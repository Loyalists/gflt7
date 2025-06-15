require( "ui.widgets.t6HUD.T6Utility.T6ButtonListItem" )
require( "ui.widgets.t6HUD.T6PauseMenu.stats.T6Pause_StatsMenu" )
require( "ui.widgets.t6HUD.T6PauseMenu.support.T6Pause_SupportMenu" )
require( "ui.widgets.t6HUD.T6PauseMenu.options.T6Pause_OptionsMenu" )

DataSources.PauseMenuOptions_List = ListHelper_SetupDataSource("PauseMenuOptions_List", function(f1_arg0)
    local f1_local0 = GetZMStartMenuGameOptions(true, true)
	LocalizeOptions(f1_local0)
	table.insert( f1_local0, 3, {
		models = {
			displayText = "T6_HUD_STATS",
			action = function ( f2_arg0, f2_arg1, f2_arg2, f2_arg3, f2_arg4 )
				NavigateToMenu( f2_arg4, "T6Pause_StatsMenu", true, f2_arg2 )
			end
		}
	} )
	table.insert( f1_local0, 4, {
		models = {
			displayText = "T6_HUD_SUPPORT",
			action = function ( f3_arg0, f3_arg1, f3_arg2, f3_arg3, f3_arg4 )
				NavigateToMenu( f3_arg4, "T6Pause_SupportMenu", true, f3_arg2 )
			end
		}
	} )
    return f1_local0
end, true)

CoD.T6PauseMenuFrame = InheritFrom( LUI.UIElement )
CoD.T6PauseMenuFrame.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.T6PauseMenuFrame )
	self.id = "T6PauseMenuFrame"
	self.soundSet = "ChooseDecal"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self:makeFocusable()
	self.onlyChildrenFocusable = true
	self.anyChildUsesUpdateState = true
	self.buttonList = LUI.UIList.new( menu, controller, 9.5, 0, nil, true, false, 0, 0, false, false )
	self.buttonList:makeFocusable()
	self.buttonList:setLeftRight( true, false, 0, 0 )
	self.buttonList:setTopBottom( true, false, 0, 0 )
	self.buttonList:setWidgetType( CoD.T6ButtonListItem )
	self.buttonList:setVerticalCount( 15 )
	self.buttonList:setSpacing( 3.33 )
	self.buttonList:setDataSource( "PauseMenuOptions_List" )
	self.buttonList:registerEventHandler( "gain_focus", function ( element, event )
		local f6_local0 = nil
		if element.gainFocus then
			f6_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f6_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f6_local0
	end )
	self.buttonList:registerEventHandler( "lose_focus", function ( element, event )
		local f7_local0 = nil
		if element.loseFocus then
			f7_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f7_local0 = element.super:loseFocus( event )
		end
		return f7_local0
	end )
	menu:AddButtonCallbackFunction( self.buttonList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( f8_arg0, f8_arg1, f8_arg2, f8_arg3 )
		ProcessListAction( self, f8_arg0, f8_arg2 )
		return true
	end, function ( f9_arg0, f9_arg1, f9_arg2 )
		CoD.Menu.SetButtonLabel( f9_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( self.buttonList )
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		},
		CP_PauseMenu = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "CP_PauseMenu",
			condition = function ( menu, element, event )
				return IsCampaign()
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNav"
		} )
	end )
	self.buttonList.id = "buttonList"
	self:registerEventHandler( "gain_focus", function ( element, event )
		if element.m_focusable and element.buttonList:processEvent( event ) then
			return true
		else
			return LUI.UIElement.gainFocus( element, event )
		end
	end )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.buttonList:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

