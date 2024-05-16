require("ui_mp.t6.hud_og")

CoD.ThirdpersonCrosshair = InheritFrom(LUI.UIElement)
CoD.ThirdpersonCrosshair.new = function(menu, controller)
    local self = LUI.UIElement.new()
    self:setUseStencil(false)
    self:setClass(CoD.ThirdpersonCrosshair)
    self.id = "ThirdpersonCrosshair"
    self.soundSet = "HUD"
    self:setLeftRight(true, false, 0, 0)
    self:setTopBottom(true, false, 0, 0)
    self:setAlpha(0)
    self.thirdpersonActive = false
    self.anyChildUsesUpdateState = true

    local CrosshairImage = LUI.UIImage.new()
    CrosshairImage:setLeftRight(false, false, -20, 20)
    CrosshairImage:setTopBottom(false, false, -20, 20)
    CrosshairImage:setAlpha(1)
    CrosshairImage:setImage(RegisterImage("reticle_center_cross"))
    CrosshairImage:setPriority(1)

    self:addElement(CrosshairImage)
    self.CrosshairImage = CrosshairImage

    local function UpdateCrosshairVisiblility(ModelRef)
        local hudVisible = Engine.GetModelValue(Engine.GetModel(Engine.GetModelForController(controller),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE)) or 0
        local uiActive = Engine.GetModelValue(Engine.GetModel(Engine.GetModelForController(controller),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE)) or 1
        local weaponHudVisible = Engine.GetModelValue(Engine.GetModel(Engine.GetModelForController(controller),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE)) or 0

        if hudVisible == 0 or uiActive == 1 or weaponHudVisible == 0 then
            self:setAlpha(0)
        else
            if self.thirdpersonActive then
                self:setAlpha(1)
            else
                self:setAlpha(0)
            end
        end
    end

    self:subscribeToGlobalModel(controller, "PerController", "hudItems.ThirdpersonCrosshair", function(model)
        local ModelValue = Engine.GetModelValue(model)
        if ModelValue then
            local data = splitString(ModelValue, ",")
            if data and #data == 3 then
                local origin_x = tonumber(data[1])
                local origin_y = tonumber(data[2])
                local origin_z = tonumber(data[3])
                self.thirdpersonActive = true
                self:setupGeneric3DWidget(origin_x, origin_y, origin_z)
            else
                self.thirdpersonActive = false
            end
            UpdateCrosshairVisiblility(model)
        end
    end)

    -- self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller),
    --     "forceScoreboard"), UpdateCrosshairVisiblility)
    self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller),
        "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE), UpdateCrosshairVisiblility)
    self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller),
        "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), UpdateCrosshairVisiblility)
    self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller),
        "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE), UpdateCrosshairVisiblility)

    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
        element.CrosshairImage:close()
    end )

    return self
end

local function AddCustomElements(menu, controller)
    local f6_local1 = menu:getParent()
    if f6_local1.subtitle == nil then
        local subtitle = LUI.UIElement.new(controller)
        subtitle:setupGameMessages(CoD.GameMessages.SubtitlesWindowIndex)
        subtitle:setAlignment(LUI.Alignment.Center)
        subtitle:setFont(CoD.fonts.Default)
        subtitle:setPriority(100001)

        f6_local1.subtitle = subtitle
        f6_local1:addElement(subtitle)

        local ThirdpersonCrosshair = CoD.ThirdpersonCrosshair.new(menu, controller)
        f6_local1.ThirdpersonCrosshair = ThirdpersonCrosshair
        f6_local1:addElement(ThirdpersonCrosshair)
    else
        f6_local1.ThirdpersonCrosshair:setAlpha(0)
    end
end

function HUD_FirstSnapshot_Common(f40_arg0, f40_arg1)
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
    AddCustomElements(f40_arg0, f40_arg1.controller)
end
