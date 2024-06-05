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

    LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
        element.CrosshairImage:close()
    end)

    return self
end
