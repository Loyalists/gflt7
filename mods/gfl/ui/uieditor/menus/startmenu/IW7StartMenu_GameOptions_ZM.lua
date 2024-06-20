require( "ui.uieditor.widgets.Lobby.Common.IW7ButtonListItem" )

DataSources.StartMenuGameOptions = ListHelper_SetupDataSource("StartMenuGameOptions", function(f1_arg0)
    local f1_local0 = {}
    if CoD.isZombie then
        table.insert(f1_local0, {
            models = {
                displayText = "MENU_RESUMEGAME_CAPS",
                action = StartMenuGoBack_ListElement
            }
        })
        if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) then
            table.insert(f1_local0, {
                models = {
                    displayText = "MENU_RESTART_LEVEL_CAPS",
                    action = RestartGame
                }
            })
            table.insert(f1_local0, {
                models = {
                    displayText = "GFL_MENU_TFOPTIONS",
                    action = OpenTFOptions_InGame
                }
            })
        end
        table.insert(f1_local0, {
            models = {
                displayText = "MENU_OPTIONS_CONTROLS_CAPS",
                action = function(f2_arg0, f2_arg1, f2_arg2, f2_arg3, f2_arg4)
                    NavigateToMenu(f2_arg4, "IW7StartMenu_Options", true, f2_arg2)
                end
            }
        })
        table.insert(f1_local0, {
            models = {
                displayText = "CPUI_CHOOSE_CHARACTER_CAPS",
                action = OpenZMChooseCharacterLoadout_InGame
            }
        })
        table.insert(f1_local0, {
            models = {
                displayText = "GFL_MENU_MOD_INFO",
                action = OpenModInfo_InGame
            }
        })
        if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) then
            table.insert(f1_local0, {
                models = {
                    displayText = "MENU_END_GAME_CAPS",
                    action = QuitGame_MP
                }
            })
        else
            table.insert(f1_local0, {
                models = {
                    displayText = "MENU_QUIT_GAME_CAPS",
                    action = QuitGame_MP
                }
            })
        end
        table.insert(f1_local0, {
            models = {
                displayText = "QUIT TO DESKTOP",
                action = OpenPCQuit
            }
        })
    end
    return f1_local0
end, true)

CoD.IW7StartMenu_GameOptions_ZM = InheritFrom( LUI.UIElement )
CoD.IW7StartMenu_GameOptions_ZM.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.IW7StartMenu_GameOptions_ZM )
	self.id = "IW7StartMenu_GameOptions_ZM"
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
	self.buttonList:setWidgetType( CoD.IW7ButtonListItem )
	self.buttonList:setVerticalCount( 10 )
	self.buttonList:setDataSource( "StartMenuGameOptions" )
	self.buttonList:registerEventHandler( "gain_focus", function ( element, event )
		local retVal = nil

		if element.gainFocus then
			retVal = element:gainFocus( event )
		elseif element.super.gainFocus then
			retVal = element.super:gainFocus( event )
		end

		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )

		return retVal
	end )
	self.buttonList:registerEventHandler( "lose_focus", function ( element, event )
		local retVal = nil

		if element.loseFocus then
			retVal = element:loseFocus( event )
		elseif element.super.loseFocus then
			retVal = element.super:loseFocus( event )
		end

		return retVal
	end )
	menu:AddButtonCallbackFunction( self.buttonList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, model )
		ProcessListAction( self, element, controller )

		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )

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
