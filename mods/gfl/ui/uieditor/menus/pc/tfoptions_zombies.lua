require("ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame")
require("ui.uieditor.widgets.StartMenu.StartMenu_lineGraphics_Options")
require("ui.uieditor.widgets.TabbedWidgets.basicTabList")
require("ui.uieditor.widgets.TabbedWidgets.paintshopTabWidget")
require("ui.uieditor.widgets.PC.StartMenu.GraphicsOptions.StartMenu_Options_PC_Graphics_Game")
require("ui.uieditor.widgets.PC.StartMenu.GraphicsOptions.StartMenu_Options_PC_Graphics_Video")
require("ui.uieditor.widgets.PC.StartMenu.GraphicsOptions.StartMenu_Options_PC_Graphics_Advanced")
require("ui.uieditor.widgets.PC.StartMenu.Dropdown.OptionDropdown")
require("ui.uieditor.widgets.PC.StartMenu.Dropdown.TFOptionDropdown")
require("ui.uieditor.widgets.StartMenu.StartMenu_Options_CheckBoxOption")
require("ui.uieditor.widgets.StartMenu.TFOptions_CheckBoxOption")
require("ui.uieditor.widgets.StartMenu.StartMenu_Options_SliderBar")
require("ui.uieditor.widgets.PC.Utility.VerticalListSpacer")
require("ui.uieditor.widgets.Scrollbars.verticalCounter")

local configureMouseInput = function(self, controller)
    self.categoryFrame:setForceMouseEventDispatch(true)
end

DataSources.TFOptionsExtraPoints = DataSourceHelpers.ListSetup("PC.TFOptionsExtraPoints", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            value = 0,
            valueDisplay = "0"
        }
    })
    table.insert(items, {
        models = {
            value = 10,
            valueDisplay = "+10"
        }
    })
    table.insert(items, {
        models = {
            value = 20,
            valueDisplay = "+20"
        }
    })
    table.insert(items, {
        models = {
            value = 30,
            valueDisplay = "+30"
        }
    })
    table.insert(items, {
        models = {
            value = 40,
            valueDisplay = "+40"
        }
    })
    table.insert(items, {
        models = {
            value = 50,
            valueDisplay = "+50"
        }
    })
    table.insert(items, {
        models = {
            value = 60,
            valueDisplay = "+60"
        }
    })
    table.insert(items, {
        models = {
            value = 70,
            valueDisplay = "+70"
        }
    })
    table.insert(items, {
        models = {
            value = 80,
            valueDisplay = "+80"
        }
    })
    table.insert(items, {
        models = {
            value = 90,
            valueDisplay = "+90"
        }
    })
    table.insert(items, {
        models = {
            value = 100,
            valueDisplay = "+100"
        }
    })
    return items
end, true)

DataSources.TFOptionsTDollZombie = DataSourceHelpers.ListSetup("PC.TFOptionsTDollZombie", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            value = 0,
            valueDisplay = "MENU_DISABLED"
        }
    })
    table.insert(items, {
        models = {
            value = 1,
            valueDisplay = "TF_TDOLL"
        }
    })
    table.insert(items, {
        models = {
            value = 2,
            valueDisplay = "TF_SF"
        }
    })
    table.insert(items, {
        models = {
            value = 3,
            valueDisplay = "TF_TDOLL_AND_SF"
        }
    })
    return items
end, true)

DataSources.TFOptionsZombiesP1 = DataSourceHelpers.ListSetup("PC.TFOptionsZombiesP1", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            label = "TF_KILL_BONUS",
            description = "TF_KILL_BONUS_DESC",
            profileVarName = "extra_cash",
            lowValue = 0,
            highValue = 100,
            useMultipleOf10Display = 1,
            widgetType = "slider"
        },
        properties = CoD.TFPCUtil.OptionsGenericSliderProperties
    })
    table.insert(items, {
        models = {
            label = "TF_MELEE_BONUS",
            description = "TF_MELEE_BONUS_DESC",
            profileVarName = "melee_bonus",
            lowValue = 0,
            highValue = 100,
            useMultipleOf10Display = 1,
            widgetType = "slider"
        },
        properties = CoD.TFPCUtil.OptionsGenericSliderProperties
    })
    table.insert(items, {
        models = {
            label = "TF_HEADSHOT_BONUS",
            description = "TF_HEADSHOT_BONUS_DESC",
            profileVarName = "headshot_bonus",
            lowValue = 0,
            highValue = 100,
            useMultipleOf10Display = 1,
            widgetType = "slider"
        },
        properties = CoD.TFPCUtil.OptionsGenericSliderProperties
    })
    table.insert(items, {
        models = {
            label = "TF_MAX_ZOMBIES",
            description = "TF_MAX_ZOMBIES_DESC",
            profileVarName = "max_zombies",
            lowValue = 1,
            highValue = 64,
            useIntegerDisplay = 1,
            widgetType = "slider"
        },
        properties = CoD.TFPCUtil.OptionsGenericSliderProperties
    })
    table.insert(items, {
        models = {
            label = "TF_TDOLL_ZOMBIE",
            description = "TF_TDOLL_ZOMBIE_DESC",
            profileVarName = "tdoll_zombie",
            datasource = "TFOptionsTDollZombie",
            widgetType = "dropdown"
        },
        properties = CoD.TFPCUtil.OptionsGenericDropdownProperties
    })
    table.insert(items, {
        models = {
            label = "TF_WEAKER_ZOMBIES",
            description = "TF_WEAKER_ZOMBIES_DESC",
            profileVarName = "weaker_zombs",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_ZOMBS_ALWAYS_SPRINT",
            description = "TF_ZOMBS_ALWAYS_SPRINT_DESC",
            profileVarName = "zombs_always_sprint",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_NO_DELAY",
            description = "TF_NO_DELAY_DESC",
            profileVarName = "no_delay",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_ZOMBIE_HEALTHBAR",
            description = "TF_ZOMBIE_HEALTHBAR_DESC",
            profileVarName = "zombie_healthbar",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    return items
end, true)

DataSources.TFOptionsZombiesP1.getWidgetTypeForItem = function(list, model, row)
    if model then
        local widgetType = Engine.GetModelValue(Engine.GetModel(model, "widgetType"))
        if widgetType == "dropdown" then
            return CoD.OptionDropdown
        elseif widgetType == "checkbox" then
            return CoD.StartMenu_Options_CheckBoxOption
        elseif widgetType == "tfcheckbox" then
            return CoD.TFOptions_CheckBoxOption
        elseif widgetType == "slider" then
            return CoD.StartMenu_Options_SliderBar
        elseif widgetType == "spacer" then
            return CoD.VerticalListSpacer
        end
    end
    return nil
end

LUI.createMenu.TFOptionsZombiesPage = function(controller)
    local self = CoD.Menu.NewForUIEditor("TFOptionsZombiesPage")

    self.soundSet = "ChooseDecal"
    self:setOwner(controller)
    self:setLeftRight(true, true, 0, 0)
    self:setTopBottom(true, true, 0, 0)
    self:playSound("menu_open", controller)
    self.buttonModel = Engine.CreateModel(Engine.GetModelForController(controller),
        "TFOptionsZombiesPage.buttonPrompts")
    local menu = self
    self.anyChildUsesUpdateState = true

    local background = LUI.UIImage.new()
    background:setLeftRight(true, false, 0, 1280)
    background:setTopBottom(true, false, 0, 720)
    background:setRGB(0, 0, 0)
    background:setAlpha(1);
    self:addElement(background)
    self.Background = background

    local title = "ZOMBIES OPTIONS"
    local menuFrame = CoD.GenericMenuFrame.new(menu, controller)
    menuFrame:setLeftRight(true, true, 0, 0)
    menuFrame:setTopBottom(true, true, 0, 0)
    menuFrame.titleLabel:setText(title)
    menuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(title)
    menuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon:setImage(RegisterImage(
        "uie_t7_mp_icon_header_option"))
    self:addElement(menuFrame)
    self.MenuFrame = menuFrame

    local startMenulineGraphicsOptions0 = CoD.StartMenu_lineGraphics_Options.new(menu, controller)
    startMenulineGraphicsOptions0:setLeftRight(true, false, 1, 69)
    startMenulineGraphicsOptions0:setTopBottom(true, false, -13, 657)
    self:addElement(startMenulineGraphicsOptions0)
    self.StartMenulineGraphicsOptions0 = startMenulineGraphicsOptions0

    local categoryListLine = LUI.UIImage.new()
    categoryListLine:setLeftRight(true, false, -11, 1293)
    categoryListLine:setTopBottom(true, false, 80, 88)
    categoryListLine:setRGB(0.9, 0.9, 0.9)
    categoryListLine:setImage(RegisterImage("uie_t7_menu_cac_tabline"))
    self:addElement(categoryListLine)
    self.CategoryListLine = categoryListLine

    local categoryFrame = LUI.UIFrame.new(menu, controller, 0, 0, false)
    categoryFrame:setLeftRight(true, false, 64, 1216)
    categoryFrame:setTopBottom(true, false, 134.22, 657)
    self:addElement(categoryFrame)
    self.categoryFrame = categoryFrame

    local widget = CoD.TFOptions_Zombies_P1.new(self, controller)
    categoryFrame:changeFrameWidget(widget)

    self:registerEventHandler("menu_loaded", function(Sender, Event)
        local f39_local0 = nil
        ShowHeaderIconOnly(menu)
        if not f39_local0 then
            f39_local0 = Sender:dispatchEventToChildren(Event)
        end
        return f39_local0
    end)

    menu:AddButtonCallbackFunction(self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil,
        function(element, menu, controller, event)
            GoBack(self, controller)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK")
            return true
        end, false)

    menu:AddButtonCallbackFunction(self, controller, Enum.LUIButton.LUI_KEY_START, "M",
        function(element, menu, controller, event)
            CloseStartMenu(menu, controller)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_START, "MENU_DISMISS_MENU")
            return true
        end, false)

    menu:AddButtonCallbackFunction(self, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "R",
        function(element, menu, controller, event)
            CoD.TFPCUtil.ResetToDefault()
            GoBack(self, controller)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "PLATFORM_RESET_TO_DEFAULT")
            return true
        end, false)

    menu:AddButtonCallbackFunction(self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil,
        function(element, menu, controller, event)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT")
            return true
        end, false)

    menuFrame:setModel(self.buttonModel, controller)
    categoryFrame.id = "categoryFrame"
    self:processEvent({
        name = "menu_loaded",
        controller = controller
    })
    self:processEvent({
        name = "update_state",
        menu = menu
    })
    if not self:restoreState() then
        self.categoryFrame:processEvent({
            name = "gain_focus",
            controller = controller
        })
    end
    LUI.OverrideFunction_CallOriginalSecond(self, "close", function(Sender)
        Sender.MenuFrame:close()
        Sender.StartMenulineGraphicsOptions0:close()
        Sender.categoryFrame:close()
        Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(controller),
            "TFOptionsZombiesPage.buttonPrompts"))
    end)
    if configureMouseInput then
        configureMouseInput(self, controller)
    end
    return self
end

