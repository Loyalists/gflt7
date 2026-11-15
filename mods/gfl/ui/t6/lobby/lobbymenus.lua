require("lua.Shared.LobbyData")
require("ui.T6.lobby.lobbymenubuttons")
CoD.LobbyMenus = {}
CoD.LobbyMenus.History = {}
CoD.LobbyMenus.AddButtons = function(controller, modelName, buttons, buildButtons)
    local model = Engine.GetModel(DataSources.LobbyRoot.getModel(controller), modelName)
    local modelValue = nil
    if model ~= nil then
        modelValue = Engine.GetModelValue(model)
    end
    if buildButtons ~= nil then
        buildButtons(controller, buttons, modelValue)
    else
        print("Error: No function provided to CoD.LobbyMenus.AddButtons")
    end
end

CoD.LobbyMenus.AddButtonsMPCPZM = function(controller, modelName, buttons, buildMPButtons, buildCPButtons, buildZMButtons)
    if Engine.GetModeName() == "CP" then
        CoD.LobbyMenus.AddButtons(controller, modelName, buttons, buildCPButtons)
    elseif Engine.GetModeName() == "MP" then
        CoD.LobbyMenus.AddButtons(controller, modelName, buttons, buildMPButtons)
    elseif Engine.GetModeName() == "ZM" then
        CoD.LobbyMenus.AddButtons(controller, modelName, buttons, buildZMButtons)
    else
        print("Error: no mode name set but AddButtonsMPCPZM called.")
    end
end

CoD.LobbyMenus.UpdateHistory = function(controller, buttonId)
    CoD.LobbyMenus.History[LobbyData.GetLobbyNav()] = buttonId
end

local isCampaignDemo = function()
    local ui_execdemo_cp = Dvar.ui_execdemo_cp
    return ui_execdemo_cp:get()
end

local isGamescomDemo = function()
    local ui_execdemo_gamescom = Dvar.ui_execdemo_gamescom
    return ui_execdemo_gamescom:get()
end

local isBetaDemo = function()
    local ui_execdemo_beta = Dvar.ui_execdemo_beta
    return ui_execdemo_beta:get()
end

local applyButtonState = function(button, state)
    if state == nil then
        return
    elseif state == CoD.LobbyButtons.DISABLED then
        button.disabled = true
    elseif state == CoD.LobbyButtons.HIDDEN then
        button.hidden = true
    end
end

local addButton = function(controller, buttons, button, isLargeButton)
    button.disabled = false
    button.hidden = false
    button.selected = false
    button.warning = false
    if button.defaultState ~= nil then
        if button.defaultState == CoD.LobbyButtons.DISABLED then
            button.disabled = true
        elseif button.defaultState == CoD.LobbyButtons.HIDDEN then
            button.hidden = true
        end
    end
    if button.disabledFunc ~= nil then
        button.disabled = button.disabledFunc(controller)
    end
    if button.visibleFunc ~= nil then
        button.hidden = not button.visibleFunc(controller)
    end
    if isBetaDemo() then
        applyButtonState(button, button.demo_beta)
    elseif isGamescomDemo() then
        applyButtonState(button, button.demo_gamescom)
    end
    if button.hidden then
        return
    end
    local lobbyNav = LobbyData.GetLobbyNav()
    if button.selectedFunc ~= nil then
        button.selected = button.selectedFunc(button.selectedParam)
    elseif CoD.LobbyMenus.History[lobbyNav] ~= nil then
        button.selected = CoD.LobbyMenus.History[lobbyNav] == button.customId
    end
    if button.newBreadcrumbFunc then
        local newBreadcrumbFunc = button.newBreadcrumbFunc
        if type(newBreadcrumbFunc) == "string" then
            newBreadcrumbFunc = LUI.getTableFromPath(newBreadcrumbFunc)
        end
        if newBreadcrumbFunc then
            button.isBreadcrumbNew = newBreadcrumbFunc(controller)
        end
    end
    if button.warningFunc ~= nil then
        button.warning = button.warningFunc(controller)
    end
    if button.starterPack == CoD.LobbyButtons.STARTERPACK_UPGRADE then
        button.starterPackUpgrade = true
        if IsStarterPack() then
            button.disabled = false
        end
    end
    table.insert(buttons, {
        optionDisplay = button.stringRef,
        action = button.action,
        param = button.param,
        customId = button.customId,
        isLargeButton = isLargeButton,
        isLastButtonInGroup = false,
        disabled = button.disabled,
        selected = button.selected,
        isBreadcrumbNew = button.isBreadcrumbNew,
        warning = button.warning,
        requiredChunk = button.selectedParam,
        starterPackUpgrade = button.starterPackUpgrade,
        unloadMod = button.unloadMod
    })
end

local addLargeButton = function(controller, buttons, button)
    addButton(controller, buttons, button, true)
end

local addSmallButton = function(controller, buttons, button)
    addButton(controller, buttons, button, false)
end

local endButtonGroup = function(buttons)
    if 0 < #buttons then
        buttons[#buttons].isLastButtonInGroup = true
    end
end

CoD.LobbyMenus.ModeSelect = function(controller, buttons, isHost)
    if Engine.GetLobbyNetworkMode() == Enum.LobbyNetworkMode.LOBBY_NETWORKMODE_LIVE then
        if isHost == 1 then
            if LuaUtils.IsGamescomBuild() then
                endButtonGroup(buttons)
                addSmallButton(controller, buttons, CoD.LobbyButtons.PLAY_LOCAL)
                endButtonGroup(buttons)
            else
                Lobby_SetMaxLocalPlayers(2)
                addLargeButton(controller, buttons, CoD.LobbyButtons.CP_ONLINE)
                addLargeButton(controller, buttons, CoD.LobbyButtons.MP_ONLINE)
                addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_ONLINE)
                addLargeButton(controller, buttons, CoD.LobbyButtons.BONUSMODES_ONLINE)
                endButtonGroup(buttons)
                addSmallButton(controller, buttons, CoD.LobbyButtons.PLAY_LOCAL)
                endButtonGroup(buttons)
            end
        end
        -- if CoD.isPC then
        -- 	f0_local6(f12_arg0, f12_arg1, CoD.LobbyButtons.STEAM_STORE)
        -- else
        -- 	f0_local6(f12_arg0, f12_arg1, CoD.LobbyButtons.STORE)
        -- end
    else
        if isHost == 1 then
            if LuaUtils.IsGamescomBuild() then
                local ui_disable_lan = Dvar.ui_disable_lan
                if not ui_disable_lan:get() then
                    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_LAN)
                    addSmallButton(controller, buttons, CoD.LobbyButtons.FIND_LAN_GAME)
                    endButtonGroup(buttons)
                else
                    Lobby_SetMaxLocalPlayers(4)
                    addLargeButton(controller, buttons, CoD.LobbyButtons.CP_LAN)
                    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_LAN)
                    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_LAN)
                    addLargeButton(controller, buttons, CoD.LobbyButtons.BONUSMODES_LAN)
                    endButtonGroup(buttons)
                    local ui_disable_lan = Dvar.ui_disable_lan
                    if not ui_disable_lan:get() then
                        addSmallButton(controller, buttons, CoD.LobbyButtons.FIND_LAN_GAME)
                        endButtonGroup(buttons)
                    end
                    addSmallButton(controller, buttons, CoD.LobbyButtons.PLAY_ONLINE)
                    endButtonGroup(buttons)
                end
            end
            Lobby_SetMaxLocalPlayers(4)
            addLargeButton(controller, buttons, CoD.LobbyButtons.CP_LAN)
            addLargeButton(controller, buttons, CoD.LobbyButtons.MP_LAN)
            addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_LAN)
            addLargeButton(controller, buttons, CoD.LobbyButtons.BONUSMODES_LAN)
            endButtonGroup(buttons)
            local ui_disable_lan = Dvar.ui_disable_lan
            if not ui_disable_lan:get() then
                addSmallButton(controller, buttons, CoD.LobbyButtons.FIND_LAN_GAME)
                endButtonGroup(buttons)
            end
            addSmallButton(controller, buttons, CoD.LobbyButtons.PLAY_ONLINE)
            endButtonGroup(buttons)
        end
        -- if CoD.isPC then
        -- 	f0_local6(f12_arg0, f12_arg1, CoD.LobbyButtons.STEAM_STORE)
        -- end
    end

    addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_MODINFO)
    if CoD.isPC then
        if Mods_Enabled() and isHost == 1 then
            addLargeButton(controller, buttons, CoD.LobbyButtons.MODS_LOAD)
        end
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
    end
end

CoD.LobbyMenus.DOAButtonsOnline = function(controller, buttons, isHost)
    if isHost == 1 then
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_DOA_START_GAME)
        -- f0_local5(f13_arg0, f13_arg1, CoD.LobbyButtons.CP_DOA_JOIN_PUBLIC_GAME)
        -- f0_local5(f13_arg0, f13_arg1, CoD.LobbyButtons.CP_DOA_CREATE_PUBLIC_GAME)
        endButtonGroup(buttons)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_DOA_LEADERBOARD)
    else
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_DOA_LEADERBOARD)
    end
end

CoD.LobbyMenus.DOAButtonsPublicGame = function(controller, buttons, isHost)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_READY_UP)
    addLargeButton(controller, buttons, CoD.LobbyButtons.CP_DOA_LEADERBOARD)
end

CoD.LobbyMenus.DOAButtonsLAN = function(controller, buttons, isHost)
    if isHost == 1 then
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_DOA_START_GAME)
    end
end

CoD.LobbyMenus.CPZMButtonsOnline = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        if Engine.IsCPInProgress() then
            addLargeButton(controller, buttons, CoD.LobbyButtons.CP_RESUME_GAME)
        else
            -- f0_local5(f16_arg0, f16_arg1, CoD.LobbyButtons.CP_START_GAME)
        end
        -- f0_local5(f16_arg0, f16_arg1, CoD.LobbyButtons.CP_JOIN_PUBLIC_GAME)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_SELECT_MISSION)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CONFIGURE_CHEATS)
    else
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
    end
end

CoD.LobbyMenus.CPZMButtonsPublicGame = function(controller, buttons, isHost)
    addSmallButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
end

CoD.LobbyMenus.CPZMButtonsLAN = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        if Engine.IsCPInProgress() then
            addLargeButton(controller, buttons, CoD.LobbyButtons.CP_RESUME_GAME)
        else
            -- f0_local5(f18_arg0, f18_arg1, CoD.LobbyButtons.CP_START_GAME)
        end
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_SELECT_MISSION)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CONFIGURE_CHEATS)
    end
end

CoD.LobbyMenus.CP2ButtonsLANCUSTOM = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_CUSTOM_START_GAME)
        endButtonGroup(buttons)
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_SELECT_MISSION)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CONFIGURE_CHEATS)
    else
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
    end
end

CoD.LobbyMenus.CPButtonsOnline = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        if Engine.IsCPInProgress() then
            addLargeButton(controller, buttons, CoD.LobbyButtons.CP_RESUME_GAME)
        else
            -- f0_local5(f20_arg0, f20_arg1, CoD.LobbyButtons.CP_START_GAME)
        end
        endButtonGroup(buttons)
        -- f0_local5(f20_arg0, f20_arg1, CoD.LobbyButtons.CP_JOIN_PUBLIC_GAME)
        -- if HighestMapReachedGreaterThan(f20_arg0, 1) then
        -- 	f0_local5(f20_arg0, f20_arg1, CoD.LobbyButtons.CP_GOTO_SAFEHOUSE)
        -- end
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_GOTO_SAFEHOUSE)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_SELECT_MISSION)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CONFIGURE_CHEATS)
        addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_CP_INFO_POPUP)
    else
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
    end
end

CoD.LobbyMenus.CPButtonsPublicGame = function(controller, buttons, isHost)
    addSmallButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
end

CoD.LobbyMenus.CPButtonsCustomGame = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_CUSTOM_START_GAME)
        endButtonGroup(buttons)
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_SELECT_MISSION)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CONFIGURE_CHEATS)
        addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_CP_INFO_POPUP)
    else
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
    end
end

CoD.LobbyMenus.CPButtonsLAN = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        if Engine.IsCPInProgress() then
            addLargeButton(controller, buttons, CoD.LobbyButtons.CP_RESUME_GAME_LAN)
        else
            -- f0_local5(f23_arg0, f23_arg1, CoD.LobbyButtons.CP_LAN_START_GAME)
        end
        endButtonGroup(buttons)
        -- if HighestMapReachedGreaterThan(f23_arg0, 1) then
        -- 	f0_local5(f23_arg0, f23_arg1, CoD.LobbyButtons.CP_GOTO_SAFEHOUSE)
        -- end
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_GOTO_SAFEHOUSE)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_SELECT_MISSION)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CONFIGURE_CHEATS)
        addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_CP_INFO_POPUP)
    else
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
    end
end

CoD.LobbyMenus.CPButtonsLANCUSTOM = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_CUSTOM_START_GAME)
        endButtonGroup(buttons)
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_SELECT_MISSION)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY)
        addLargeButton(controller, buttons, CoD.LobbyButtons.CONFIGURE_CHEATS)
        addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_CP_INFO_POPUP)
    else
        addSmallButton(controller, buttons, CoD.LobbyButtons.CP_MISSION_OVERVIEW)
    end
end

CoD.LobbyMenus.MPButtonsMain = function(controller, buttons, isHost)
    if isHost == 1 then
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_PUBLIC_MATCH)
        -- f0_local5(f25_arg0, f25_arg1, CoD.LobbyButtons.MP_ARENA)
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CUSTOM_GAMES)
        addLargeButton(controller, buttons, CoD.LobbyButtons.THEATER_MP)
        addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_MP_INFO_POPUP)
    end
    endButtonGroup(buttons)
    -- if CoD.isPC then
    -- 	f0_local5(f25_arg0, f25_arg1, CoD.LobbyButtons.STEAM_STORE)
    -- else
    -- 	f0_local5(f25_arg0, f25_arg1, CoD.LobbyButtons.STORE)
    -- end
end

CoD.LobbyMenus.MPButtonsOnline = function(controller, buttons, isHost)
    if isHost == 1 then
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_FIND_MATCH)
        endButtonGroup(buttons)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CAC_NO_WARNING)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SPECIALISTS_NO_WARNING)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SCORESTREAKS)
    local ui_execdemo_beta = Dvar.ui_execdemo_beta
    if (not not ui_execdemo_beta:get() or IsStarterPack()) and IsStoreAvailable() then
        if CoD.isPC then
            addLargeButton(controller, buttons, CoD.LobbyButtons.STEAM_STORE)
        else
            addLargeButton(controller, buttons, CoD.LobbyButtons.STORE)
        end
    end
    if Engine.DvarBool(nil, "inventory_test_button_visible") then
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_INVENTORY_TEST)
    end
    endButtonGroup(buttons)
    if not DisableBlackMarket() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.BLACK_MARKET)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_MP_INFO_POPUP)
end

CoD.LobbyMenus.MPButtonsOnlinePublic = function(controller, buttons, isHost)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CAC)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SPECIALISTS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SCORESTREAKS)
    if Engine.DvarBool(nil, "inventory_test_button_visible") then
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_INVENTORY_TEST)
    end
    local playlistInfo = Engine.GetPlaylistInfoByID(Engine.GetPlaylistID())
    if playlistInfo then
        local category = playlistInfo.playlist.category
        if category == Engine.GetPlaylistCategoryIdByName("core") or category ==
            Engine.GetPlaylistCategoryIdByName("hardcore") then
            endButtonGroup(buttons)
            addSmallButton(controller, buttons, CoD.LobbyButtons.MP_PUBLIC_LOBBY_LEADERBOARD)
        end
    end
    if not DisableBlackMarket() then
        endButtonGroup(buttons)
        addSmallButton(controller, buttons, CoD.LobbyButtons.BLACK_MARKET)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_MP_INFO_POPUP)
end

CoD.LobbyMenus.MPButtonsModGame = function(controller, buttons, isHost)
    if Engine.IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    else
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CAC)
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SPECIALISTS)
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SCORESTREAKS)
        addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_MP_INFO_POPUP)
    end
end

CoD.LobbyMenus.MPButtonsCustomGame = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        addSmallButton(controller, buttons, CoD.LobbyButtons.MP_CUSTOM_START_GAME)
        addSmallButton(controller, buttons, CoD.LobbyButtons.MP_CUSTOM_SETUP_GAME)
        endButtonGroup(buttons)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CAC)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SPECIALISTS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SCORESTREAKS)
    endButtonGroup(buttons)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CODCASTER_SETTINGS)
    if Engine.DvarBool(nil, "inventory_test_button_visible") then
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_INVENTORY_TEST)
    end
    endButtonGroup(buttons)
    addSmallButton(controller, buttons, CoD.LobbyButtons.MP_CUSTOM_LOBBY_LEADERBOARD)

    if not DisableBlackMarket() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.BLACK_MARKET)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_MP_INFO_POPUP)
end

CoD.LobbyMenus.MPButtonsArena = function(controller, buttons, isHost)
    if isHost == 1 then
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_ARENA_FIND_MATCH)
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_ARENA_SELECT_ARENA)
        endButtonGroup(buttons)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CAC)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SPECIALISTS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SCORESTREAKS)
    if not DisableBlackMarket() then
        endButtonGroup(buttons)
        addSmallButton(controller, buttons, CoD.LobbyButtons.BLACK_MARKET)
    end
end

CoD.LobbyMenus.MPButtonsArenaGame = function(controller, buttons, isHost)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CAC)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SPECIALISTS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SCORESTREAKS)
    if not DisableBlackMarket() then
        endButtonGroup(buttons)
        addSmallButton(controller, buttons, CoD.LobbyButtons.BLACK_MARKET)
    end
end

CoD.LobbyMenus.MPButtonsLAN = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        addSmallButton(controller, buttons, CoD.LobbyButtons.MP_CUSTOM_START_GAME)
        addSmallButton(controller, buttons, CoD.LobbyButtons.MP_CUSTOM_SETUP_GAME)
        endButtonGroup(buttons)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CAC)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SPECIALISTS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_SCORESTREAKS)
    endButtonGroup(buttons)
    addLargeButton(controller, buttons, CoD.LobbyButtons.MP_CODCASTER_SETTINGS)
    if Engine.DvarBool(nil, "inventory_test_button_visible") then
        addLargeButton(controller, buttons, CoD.LobbyButtons.MP_INVENTORY_TEST)
    end
    if not DisableBlackMarket() then
        endButtonGroup(buttons)
        addSmallButton(controller, buttons, CoD.LobbyButtons.BLACK_MARKET)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_MP_INFO_POPUP)
end

CoD.LobbyMenus.ZMButtonsOnline = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_SOLO_GAME)
        -- f0_local5(f33_arg0, f33_arg1, CoD.LobbyButtons.ZM_FIND_MATCH)
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_CUSTOM_GAMES)
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_TFOPTIONS)
        -- f0_local5(f33_arg0, f33_arg1, CoD.LobbyButtons.THEATER_ZM)
        endButtonGroup(buttons)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_CHARACTERS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_PERSONALIZATION_OPTIONS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_CHANGE_LOBBY)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_BUBBLEGUM_BUFFS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_BUILD_KITS)
    -- f0_local5(f33_arg0, f33_arg1, CoD.LobbyButtons.ZM_MEGACHEW_FACTORY)
    -- f0_local5(f33_arg0, f33_arg1, CoD.LobbyButtons.ZM_GOBBLEGUM_RECIPES)
    -- f0_local5(f33_arg0, f33_arg1, CoD.LobbyButtons.OPEN_ZM_INFO_POPUP)
end

CoD.LobbyMenus.ZMButtonsPublicGame = function(controller, buttons)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    else
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_READY_UP)
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_CHARACTERS)
        addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_PERSONALIZATION_OPTIONS)
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_CHANGE_LOBBY)
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_BUBBLEGUM_BUFFS)
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_BUILD_KITS)
        -- f0_local5(f34_arg0, f34_arg1, CoD.LobbyButtons.OPEN_ZM_INFO_POPUP)
    end
end

CoD.LobbyMenus.ZMButtonsCustomGame = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_START_CUSTOM_GAME)
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_SETUP_GAME)
        endButtonGroup(buttons)
        -- f0_local5(f35_arg0, f35_arg1, CoD.LobbyButtons.ZM_CHANGE_RANKED_SETTTINGS)
        -- f0_local7(f35_arg1)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_CHARACTERS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_PERSONALIZATION_OPTIONS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_CHANGE_LOBBY)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_BUBBLEGUM_BUFFS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_BUILD_KITS)
    -- f0_local5(f35_arg0, f35_arg1, CoD.LobbyButtons.OPEN_ZM_INFO_POPUP)
end

CoD.LobbyMenus.ZMButtonsLAN = function(controller, buttons, isHost)
    if IsStarterPack() then
        addSmallButton(controller, buttons, CoD.LobbyButtons.QUIT)
        return
    elseif isHost == 1 then
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_START_LAN_GAME)
        addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_SETUP_GAME)
        endButtonGroup(buttons)
    end
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_CHARACTERS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_PERSONALIZATION_OPTIONS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_CHANGE_LOBBY)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_BUBBLEGUM_BUFFS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.ZM_BUILD_KITS)
    addLargeButton(controller, buttons, CoD.LobbyButtons.OPEN_ZM_INFO_POPUP)
end

CoD.LobbyMenus.FRButtonsOnlineGame = function(controller, buttons, isHost)
    addLargeButton(controller, buttons, CoD.LobbyButtons.FR_START_RUN_ONLINE)
    addLargeButton(controller, buttons, CoD.LobbyButtons.FR_CHANGE_MAP)
    endButtonGroup(buttons)
    addLargeButton(controller, buttons, CoD.LobbyButtons.FR_LEADERBOARD)
end

CoD.LobbyMenus.FRButtonsLANGame = function(controller, buttons, isHost)
    addLargeButton(controller, buttons, CoD.LobbyButtons.FR_START_RUN_LAN)
    addLargeButton(controller, buttons, CoD.LobbyButtons.FR_CHANGE_MAP)
end

CoD.LobbyMenus.ButtonsTheaterGame = function(controller, buttons, isHost)
    if isHost == 1 then
        addSmallButton(controller, buttons, CoD.LobbyButtons.TH_START_FILM)
        addSmallButton(controller, buttons, CoD.LobbyButtons.TH_SELECT_FILM)
        addSmallButton(controller, buttons, CoD.LobbyButtons.TH_CREATE_HIGHLIGHT)
    end
end

local buttonBuilders = {
    [LobbyData.UITargets.UI_MAIN.id] = CoD.LobbyMenus.ModeSelect,
    [LobbyData.UITargets.UI_MODESELECT.id] = CoD.LobbyMenus.ModeSelect,
    [LobbyData.UITargets.UI_CPLOBBYLANGAME.id] = CoD.LobbyMenus.CPButtonsLAN,
    [LobbyData.UITargets.UI_CPLOBBYLANCUSTOMGAME.id] = CoD.LobbyMenus.CPButtonsLANCUSTOM,
    [LobbyData.UITargets.UI_CPLOBBYONLINE.id] = CoD.LobbyMenus.CPButtonsOnline,
    [LobbyData.UITargets.UI_CPLOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.CPButtonsPublicGame,
    [LobbyData.UITargets.UI_CPLOBBYONLINECUSTOMGAME.id] = CoD.LobbyMenus.CPButtonsCustomGame,
    [LobbyData.UITargets.UI_CP2LOBBYLANGAME.id] = CoD.LobbyMenus.CPZMButtonsLAN,
    [LobbyData.UITargets.UI_CP2LOBBYLANCUSTOMGAME.id] = CoD.LobbyMenus.CPButtonsLANCUSTOM,
    [LobbyData.UITargets.UI_CP2LOBBYONLINE.id] = CoD.LobbyMenus.CPZMButtonsOnline,
    [LobbyData.UITargets.UI_CP2LOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.CPZMButtonsPublicGame,
    [LobbyData.UITargets.UI_CP2LOBBYONLINECUSTOMGAME.id] = CoD.LobbyMenus.CPButtonsCustomGame,
    [LobbyData.UITargets.UI_DOALOBBYLANGAME.id] = CoD.LobbyMenus.DOAButtonsLAN,
    [LobbyData.UITargets.UI_DOALOBBYONLINE.id] = CoD.LobbyMenus.DOAButtonsOnline,
    [LobbyData.UITargets.UI_DOALOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.DOAButtonsPublicGame,
    [LobbyData.UITargets.UI_MPLOBBYLANGAME.id] = CoD.LobbyMenus.MPButtonsLAN,
    [LobbyData.UITargets.UI_MPLOBBYMAIN.id] = CoD.LobbyMenus.MPButtonsMain,
    [LobbyData.UITargets.UI_MPLOBBYONLINE.id] = CoD.LobbyMenus.MPButtonsOnline,
    [LobbyData.UITargets.UI_MPLOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.MPButtonsOnlinePublic,
    [LobbyData.UITargets.UI_MPLOBBYONLINEMODGAME.id] = CoD.LobbyMenus.MPButtonsModGame,
    [LobbyData.UITargets.UI_MPLOBBYONLINECUSTOMGAME.id] = CoD.LobbyMenus.MPButtonsCustomGame,
    [LobbyData.UITargets.UI_MPLOBBYONLINEARENA.id] = CoD.LobbyMenus.MPButtonsArena,
    [LobbyData.UITargets.UI_MPLOBBYONLINEARENAGAME.id] = CoD.LobbyMenus.MPButtonsArenaGame,
    [LobbyData.UITargets.UI_FRLOBBYONLINEGAME.id] = CoD.LobbyMenus.FRButtonsOnlineGame,
    [LobbyData.UITargets.UI_FRLOBBYLANGAME.id] = CoD.LobbyMenus.FRButtonsLANGame,
    [LobbyData.UITargets.UI_ZMLOBBYLANGAME.id] = CoD.LobbyMenus.ZMButtonsLAN,
    [LobbyData.UITargets.UI_ZMLOBBYONLINE.id] = CoD.LobbyMenus.ZMButtonsOnline,
    [LobbyData.UITargets.UI_ZMLOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.ZMButtonsPublicGame,
    [LobbyData.UITargets.UI_ZMLOBBYONLINECUSTOMGAME.id] = CoD.LobbyMenus.ZMButtonsCustomGame,
    [LobbyData.UITargets.UI_MPLOBBYONLINETHEATER.id] = CoD.LobbyMenus.ButtonsTheaterGame,
    [LobbyData.UITargets.UI_ZMLOBBYONLINETHEATER.id] = CoD.LobbyMenus.ButtonsTheaterGame
}
CoD.LobbyMenus.AddButtonsForTarget = function(controller, targetId)
    local isHostModel = nil
    if Engine.IsLobbyActive(Enum.LobbyType.LOBBY_TYPE_GAME) then
        isHostModel = Engine.GetModel(DataSources.LobbyRoot.getModel(controller), "gameClient.isHost")
    else
        isHostModel = Engine.GetModel(DataSources.LobbyRoot.getModel(controller), "privateClient.isHost")
    end
    local isHost = nil
    if isHostModel ~= nil then
        isHost = Engine.GetModelValue(isHostModel)
    else
        isHost = 1
    end
    local buttons = {}
    buttonBuilders[targetId](controller, buttons, isHost)
    return buttons
end