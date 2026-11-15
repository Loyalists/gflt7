require("ui.uieditor.widgets.GFL.HUD.IW8DamageFeedback")

CoD.IW8DamageFeedbackContainer = InheritFrom(LUI.UIElement)
CoD.IW8DamageFeedbackContainer.new = function(menu, controller)
    local self = LUI.UIElement.new()
    self:setClass(CoD.IW8DamageFeedbackContainer)
    self.id = "IW8DamageFeedbackContainer"
    self:setLeftRight(true, true, 0, 0)
    self:setTopBottom(true, true, 0, 0)

    local center = LUI.UIElement.new()
    center:setLeftRight(false, false, 0, 0)
    center:setTopBottom(false, false, 0, 0)
    self:addElement(center)

    local world = LUI.UIElement.new()
    world:setLeftRight(true, false, 0, 0)
    world:setTopBottom(true, false, 0, 0)
    self:addElement(world)

    local marker = CoD.IW8DamageFeedback.new(menu, controller)
    center:addElement(marker)
    local markerParent = center
    marker:subscribeToGlobalModel(controller, "CurrentWeapon", nil, function(model)
        marker:setModel(model, controller)
    end)

    local controllerModel = Engine.GetModelForController(controller)
    local function UpdateVisibility()
        local function Bit(bit)
            local model = Engine.GetModel(controllerModel, "UIVisibilityBit." .. bit)
            return model and Engine.GetModelValue(model)
        end
        local visible = Bit(Enum.UIVisibilityBit.BIT_HUD_VISIBLE) == 1
            and Bit(Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) == 1
            and Bit(Enum.UIVisibilityBit.BIT_UI_ACTIVE) == 0
        self:setAlpha(visible and 1 or 0)
    end

    -- Reparent the single marker so model resets and animations have one owner.
    self:subscribeToGlobalModel(controller, "PerController", "hudItems.ThirdpersonCrosshair", function(model)
        local value = Engine.GetModelValue(model)
        local data = value and splitString(value, ",")
        local x = data and tonumber(data[1])
        local y = data and tonumber(data[2])
        local z = data and tonumber(data[3])
        local nextParent = center
        if x and y and z then
            world:setupGeneric3DWidget(x, y, z)
            nextParent = world
        end
        if nextParent ~= markerParent then
            markerParent:removeElement(marker)
            nextParent:addElement(marker)
            markerParent = nextParent
        end
    end)

    for _, bit in ipairs({Enum.UIVisibilityBit.BIT_HUD_VISIBLE,
        Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE, Enum.UIVisibilityBit.BIT_UI_ACTIVE}) do
        self:subscribeToModel(Engine.GetModel(controllerModel, "UIVisibilityBit." .. bit), UpdateVisibility)
    end
    UpdateVisibility()

    LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
        marker:close()
        center:close()
        world:close()
    end)
    return self
end
