require("ui.uieditor.widgets.Lobby.Common.T6ButtonListItem")

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
                    displayText = "GFL_MENU_TFOPTIONS_SHORT",
                    action = OpenTFOptions_InGame
                }
            })
        end
        table.insert(f1_local0, {
            models = {
                displayText = "MENU_OPTIONS_CAPS",
                action = function(f2_arg0, f2_arg1, f2_arg2, f2_arg3, f2_arg4)
                    NavigateToMenu(f2_arg4, "T6StartMenu_Options", true, f2_arg2)
                end
            }
        })
        table.insert(f1_local0, {
            models = {
                displayText = "GFL_MENU_CHARACTERS",
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

CoD.T6StartMenu_GameOptions_ZM = InheritFrom(LUI.UIElement)
CoD.T6StartMenu_GameOptions_ZM.new = function(menu, controller)
    local self = LUI.UIElement.new()
    if PreLoadFunc then
        PreLoadFunc(self, controller)
    end
    self:setUseStencil(false)
    self:setClass(CoD.T6StartMenu_GameOptions_ZM)
    self.id = "T6StartMenu_GameOptions_ZM"
    self.soundSet = "ChooseDecal"
    self:setLeftRight(true, false, 0, 1280)
    self:setTopBottom(true, false, 0, 720)
    self:makeFocusable()
    self.onlyChildrenFocusable = true
    self.anyChildUsesUpdateState = true
    self.buttonList = LUI.UIList.new(menu, controller, 0, 0, nil, true, false, 0, 0, false, false)
    self.buttonList:makeFocusable()
    self.buttonList:setLeftRight(true, false, 0, 0)
    self.buttonList:setTopBottom(true, false, 0, 0)
    self.buttonList:setWidgetType(CoD.T6ButtonListItem)
    self.buttonList:setVerticalCount(10)
    self.buttonList:setDataSource("StartMenuGameOptions")
    self.buttonList:registerEventHandler("gain_focus", function(element, event)
        local f4_local0 = nil
        if element.gainFocus then
            f4_local0 = element:gainFocus(event)
        elseif element.super.gainFocus then
            f4_local0 = element.super:gainFocus(event)
        end
        CoD.Menu.UpdateButtonShownState(element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS)
        return f4_local0
    end)
    self.buttonList:registerEventHandler("lose_focus", function(element, event)
        local f5_local0 = nil
        if element.loseFocus then
            f5_local0 = element:loseFocus(event)
        elseif element.super.loseFocus then
            f5_local0 = element.super:loseFocus(event)
        end
        return f5_local0
    end)
    menu:AddButtonCallbackFunction(self.buttonList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER",
        function(f6_arg0, f6_arg1, f6_arg2, f6_arg3)
            ProcessListAction(self, f6_arg0, f6_arg2)
            return true
        end, function(f7_arg0, f7_arg1, f7_arg2)
            CoD.Menu.SetButtonLabel(f7_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT")
            return true
        end, false)
    self:addElement(self.buttonList)
    self.clipsPerState = {
        DefaultState = {
            DefaultClip = function()
                self:setupElementClipCounter(0)
            end
        },
        CP_PauseMenu = {
            DefaultClip = function()
                self:setupElementClipCounter(0)
            end
        }
    }
    self:mergeStateConditions({{
        stateName = "CP_PauseMenu",
        condition = function(menu, element, event)
            return IsCampaign()
        end
    }})
    self:subscribeToModel(Engine.GetModel(Engine.GetGlobalModel(), "lobbyRoot.lobbyNav"), function(model)
        menu:updateElementState(self, {
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue(model),
            modelName = "lobbyRoot.lobbyNav"
        })
    end)
    self.buttonList.id = "buttonList"
    self:registerEventHandler("gain_focus", function(element, event)
        if element.m_focusable and element.buttonList:processEvent(event) then
            return true
        else
            return LUI.UIElement.gainFocus(element, event)
        end
    end)
    LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
        element.buttonList:close()
    end)

    if PostLoadFunc then
        PostLoadFunc(self, controller, menu)
    end

    return self
end

