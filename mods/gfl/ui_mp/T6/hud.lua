require("ui_mp.t6.hud_og")
require("ui.uieditor.widgets.GFL.HUD.ThirdpersonCrosshair")

local Preload = function()
    if CoD.isZombie then
        require("ui.uieditor.widgets.HUD.ZM_NotifFactory.ZMNotificationContainer")
        -- require("ui.uieditor.widgets.HUD.ZM_NotifFactory.ZmNotifBGB_ContainerFactory")
    end
end

local function AddCustomHUDElements_Zombie(menu, controller)
    local f6_local1 = menu:getParent()

    local ZMNotificationContainer = CoD.ZMNotificationContainer.new(menu, controller)
    -- if Engine.GetCurrentMap() == "zm_log_kowloon" then
    --     ZMNotificationContainer = CoD.ZMNotificationContainer.new(menu, controller)
    -- else
    --     ZMNotificationContainer = CoD.ZmNotifBGB_ContainerFactory.new(menu, controller)
    -- end

    ZMNotificationContainer:setLeftRight(false, false, -156, 156)
    ZMNotificationContainer:setTopBottom(true, false, -6, 247)
    ZMNotificationContainer:setScale(0.75)
    ZMNotificationContainer:subscribeToGlobalModel(controller, "PerController", "hudItems.CharacterPopup",
        function(model)
            local ModelValue = Engine.GetModelValue(model)
            if ModelValue then
                if ModelValue == "" or ModelValue == "none" then
                    return
                end

                local container = ZMNotificationContainer
                if container and container.id and container.id == "ZMNotificationContainer" then
                    ClearNotificationQueue(container)
                end

                AddCharacterNotification(self, f6_local1, container, ModelValue)
            end
        end)

    ZMNotificationContainer:subscribeToGlobalModel(controller, "PerController", "scriptNotify", function(model)
        local container = ZMNotificationContainer
        if container and container.id and container.id == "ZMNotificationContainer" then
            ClearNotificationQueue(container)
        end

        if IsParamModelEqualToString(model, "gfl_cheats_notification") then
            AddCheatsNotification(self, f6_local1, container, model)
        end
    end)

    f6_local1:addElement(ZMNotificationContainer)
    f6_local1.ZMNotificationContainer = ZMNotificationContainer
end

local function AddCustomHUDElements_Common(menu, controller)
    local f6_local1 = menu:getParent()

    local ThirdpersonCrosshair = CoD.ThirdpersonCrosshair.new(menu, controller)
    f6_local1.ThirdpersonCrosshair = ThirdpersonCrosshair
    f6_local1:addElement(ThirdpersonCrosshair)
end

function HUD_FirstSnapshot_Common(f40_arg0, f40_arg1)
    Preload()

    CoD.CACUtility.ForceStreamAttachmentImages(f40_arg1.controller)
    if not CoD.isMultiplayer then
        f40_arg0.cinematicSubtitles = CoD.MovieSubtitles.new(f40_arg0, f40_arg1.controller)
        f40_arg0.cinematicSubtitles:setLeftRight(false, false, -640, 640)
        f40_arg0.cinematicSubtitles:setTopBottom(false, false, -360, 360)
        f40_arg0:addElement(f40_arg0.cinematicSubtitles)
    end
    local f40_local0 = f40_arg1.controller
    HUD_AddHintTextElements(f40_arg0, f40_local0)
    local f40_local1 = CoD.Menu.NewSafeAreaFromState("hud_safearea", f40_arg1.controller)
    f40_local1:setPriority(100)
    f40_local1:setOwner(f40_arg1.controller)
    f40_arg0:addElement(f40_local1)
    if f40_arg0.safeArea and f40_arg0.safeArea.buttonModel then
        Engine.UnsubscribeAndFreeModel(f40_arg0.safeArea.buttonModel)
        f40_arg0.safeArea:close()
    end
    f40_arg0.safeArea = f40_local1
    f40_arg0.safeArea.buttonModel = Engine.CreateModel(Engine.GetModelForController(f40_local0), "HUD.buttonPrompts")
    local f40_local2 = CoD.GrenadeEffect.new(f40_local0)
    f40_local2:setLeftRight(true, true, 0, 0)
    f40_local2:setTopBottom(true, true, 0, 0)
    f40_arg0:addForceClosedSafeAreaChild(f40_local2)
    if CoD.isZombie == true then
        CoD.Zombie.SoloQuestMode = false
        local f40_local3 = Engine.GetLobbyClientCount(Enum.LobbyType.LOBBY_TYPE_GAME)
        if f40_local3 == 1 and
            (CoD.isOnlineGame() == false or Engine.GameModeIsMode(CoD.GAMEMODE_PRIVATE_MATCH) == false) then
            CoD.Zombie.SoloQuestMode = true
        end
        if Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == true and f40_local3 > 2 then
            CoD.Zombie.LocalSplitscreenMultiplePlayers = true
        end
    end
    HUD_CloseScoreBoard(f40_arg0, f40_arg1)
    if Dvar.ui_gametype:get() ~= "fr" and not CoD.ShowNewScoreboard() then
        f40_arg0.scoreBoard = LUI.createMenu.Scoreboard(f40_arg1.controller)
        f40_arg0.scoreboardUpdateTimer = LUI.UITimer.new(1000, {
            name = "update_scoreboard",
            controller = f40_arg1.controller
        }, false)
    end
    Engine.Durango_CheckPrimaryStolenPopupAfterLoading()

    AddCustomHUDElements_Common(f40_arg0, f40_arg1.controller)
    if CoD.isZombie then
        AddCustomHUDElements_Zombie(f40_arg0, f40_arg1.controller)
    end
end