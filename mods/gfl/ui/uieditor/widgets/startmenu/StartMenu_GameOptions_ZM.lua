require( "ui.uieditor.widgets.Lobby.Common.List1ButtonLarge_PH" )
require( "ui.uieditor.widgets.Utilities.ProgressBar_Rank" )
require( "ui.uieditor.widgets.ZMPromotional.ZM_PromoIconList" )

DataSources.StartMenuGameOptions_ZM = ListHelper_SetupDataSource("StartMenuGameOptions_ZM", function(f89_arg0)
    local f89_local0 = {}
	table.insert(f89_local0, {
		models = {
			displayText = "MENU_RESUMEGAME_CAPS",
			action = StartMenuGoBack_ListElement
		}
	})
	if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) == true then
		table.insert(f89_local0, {
			models = {
				displayText = "MENU_RESTART_LEVEL_CAPS",
				action = RestartGame
			}
		})
		table.insert(f89_local0, {
			models = {
				displayText = "GFL_MENU_TFOPTIONS",
				action = OpenTFOptions_InGame
			}
		})
	end
	table.insert(f89_local0, {
		models = {
			displayText = "CPUI_CHOOSE_CHARACTER_CAPS",
			action = OpenZMChooseCharacterLoadout_InGame
		}
	})
	table.insert(f89_local0, {
		models = {
			displayText = "GFL_MENU_MOD_INFO",
			action = OpenModInfo_InGame
		}
	})
	if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) == true then
		table.insert(f89_local0, {
			models = {
				displayText = "MENU_END_GAME_CAPS",
				action = QuitGame_MP
			}
		})
	else
		table.insert(f89_local0, {
			models = {
				displayText = "MENU_QUIT_GAME_CAPS",
				action = QuitGame_MP
			}
		})
	end
    table.insert(f89_local0, {
        models = {
            displayText = "QUIT TO DESKTOP",
            action = OpenPCQuit
        }
    })
    return f89_local0
end, true)

CoD.StartMenu_GameOptions_ZM = InheritFrom( LUI.UIElement )
CoD.StartMenu_GameOptions_ZM.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.StartMenu_GameOptions_ZM )
	self.id = "StartMenu_GameOptions_ZM"
	self.soundSet = "ChooseDecal"
	self:setLeftRight( true, false, 0, 1150 )
	self:setTopBottom( true, false, 0, 520 )
	self:makeFocusable()
	self.onlyChildrenFocusable = true
	self.anyChildUsesUpdateState = true
	
	local buttonList = LUI.UIList.new( menu, controller, 2, 0, nil, true, false, 0, 0, false, false )
	buttonList:makeFocusable()
	buttonList:setLeftRight( true, false, 12, 292 )
	buttonList:setTopBottom( true, false, 4.91, 172.91 )
	buttonList:setWidgetType( CoD.List1ButtonLarge_PH )
	buttonList:setVerticalCount( 10 )
	buttonList:setDataSource( "StartMenuGameOptions_ZM" )
	buttonList:registerEventHandler( "gain_focus", function ( element, event )
		local f2_local0 = nil
		if element.gainFocus then
			f2_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f2_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f2_local0
	end )
	buttonList:registerEventHandler( "lose_focus", function ( element, event )
		local f3_local0 = nil
		if element.loseFocus then
			f3_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f3_local0 = element.super:loseFocus( event )
		end
		return f3_local0
	end )
	menu:AddButtonCallbackFunction( buttonList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( f4_arg0, f4_arg1, f4_arg2, f4_arg3 )
		ProcessListAction( self, f4_arg0, f4_arg2 )
		return true
	end, function ( f5_arg0, f5_arg1, f5_arg2 )
		CoD.Menu.SetButtonLabel( f5_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( buttonList )
	self.buttonList = buttonList
	
	local Pixel2001 = LUI.UIImage.new()
	Pixel2001:setLeftRight( true, false, -36, 0 )
	Pixel2001:setTopBottom( true, false, 106, 110 )
	Pixel2001:setYRot( -180 )
	Pixel2001:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Pixel2001:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( Pixel2001 )
	self.Pixel2001 = Pixel2001
	
	local Pixel20 = LUI.UIImage.new()
	Pixel20:setLeftRight( true, false, -36.13, -0.13 )
	Pixel20:setTopBottom( true, false, 486, 490 )
	Pixel20:setYRot( -180 )
	Pixel20:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Pixel20:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( Pixel20 )
	self.Pixel20 = Pixel20
	
	local Pixel200 = LUI.UIImage.new()
	Pixel200:setLeftRight( true, false, 1146.87, 1182.87 )
	Pixel200:setTopBottom( true, false, 486, 490 )
	Pixel200:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Pixel200:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( Pixel200 )
	self.Pixel200 = Pixel200
	
	local Pixel2000 = LUI.UIImage.new()
	Pixel2000:setLeftRight( true, false, 1145.87, 1181.87 )
	Pixel2000:setTopBottom( true, false, 34, 38 )
	Pixel2000:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Pixel2000:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( Pixel2000 )
	self.Pixel2000 = Pixel2000
	
	local Pixel2002 = LUI.UIImage.new()
	Pixel2002:setLeftRight( true, false, 1146.87, 1182.87 )
	Pixel2002:setTopBottom( true, false, 386, 390 )
	Pixel2002:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Pixel2002:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( Pixel2002 )
	self.Pixel2002 = Pixel2002
	
	local ZMPromoIconList = CoD.ZM_PromoIconList.new( menu, controller )
	ZMPromoIconList:setLeftRight( true, false, 12, 214 )
	ZMPromoIconList:setTopBottom( true, false, 386, 441 )
	ZMPromoIconList:mergeStateConditions( {
		{
			stateName = "ShowLines",
			condition = function ( menu, element, event )
				return AlwaysTrue()
			end
		}
	} )
	self:addElement( ZMPromoIconList )
	self.ZMPromoIconList = ZMPromoIconList
	
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
	buttonList.id = "buttonList"
	self:registerEventHandler( "gain_focus", function ( element, event )
		if element.m_focusable and element.buttonList:processEvent( event ) then
			return true
		else
			return LUI.UIElement.gainFocus( element, event )
		end
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.buttonList:close()
		element.ZMPromoIconList:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
