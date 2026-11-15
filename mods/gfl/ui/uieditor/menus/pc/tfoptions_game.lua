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

DataSources.TFOptionsFriendlyFire = DataSourceHelpers.ListSetup("PC.TFOptionsFriendlyFire", function(controller)
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
            valueDisplay = "MENU_ENABLED"
        }
    })
    table.insert(items, {
        models = {
            value = 2,
            valueDisplay = "MENU_SHARED"
        }
    })
    table.insert(items, {
        models = {
            value = 3,
            valueDisplay = "MPUI_REFLECT"
        }
    })
    table.insert(items, {
        models = {
            value = 4,
            valueDisplay = "TF_KNOCK_BACK"
        }
    })
    table.insert(items, {
        models = {
            value = 5,
            valueDisplay = "TF_NON_LETHAL"
        }
    })
    return items
end, true)

DataSources.TFOptionsGameP1 = DataSourceHelpers.ListSetup("PC.TFOptionsGameP1", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            label = "TF_ROUND",
            description = "TF_ROUND_DESC",
            profileVarName = "starting_round",
            lowValue = 1,
            highValue = 255,
            useIntegerDisplay = 1,
            widgetType = "slider"
        },
        properties = CoD.TFPCUtil.OptionsGenericSliderProperties
    })
    table.insert(items, {
        models = {
            label = "MENU_FRIENDLYFIRE",
            description = "TF_FRIENDLYFIRE_DESC",
            profileVarName = "friendlyfire",
            datasource = "TFOptionsFriendlyFire",
            widgetType = "dropdown"
        },
        properties = CoD.TFPCUtil.OptionsGenericDropdownProperties
    })
    table.insert(items, {
        models = {
            label = "TF_ZCOUNTER",
            description = "TF_ZCOUNTER_DESC",
            profileVarName = "zcounter_enabled",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_NO_ROUND_DELAY",
            description = "TF_NO_ROUND_DELAY_DESC",
            profileVarName = "no_round_delay",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_TIMED_GAMEPLAY",
            description = "TF_TIMED_GAMEPLAY_DESC",
            profileVarName = "timed_gameplay",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_EVERY_BOX",
            description = "TF_EVERY_BOX_DESC",
            profileVarName = "every_box",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_OPEN_ALL_DOORS",
            description = "TF_OPEN_ALL_DOORS_DESC",
            profileVarName = "open_all_doors",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_START_POWER",
            description = "TF_START_POWER_DESC",
            profileVarName = "start_power",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_ROUND_REVIVE",
            description = "TF_ROUND_REVIVE_DESC",
            profileVarName = "roundrevive",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_OBJECTIVES",
            description = "TF_OBJECTIVES_DESC",
            profileVarName = "objectives",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_CHECKPOINTS",
            description = "TF_CHECKPOINTS_DESC",
            profileVarName = "checkpoints",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_MW3_INTRO",
            description = "TF_MW3_INTRO_DESC",
            profileVarName = "mw3_intro",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    return items
end, true)

DataSources.TFOptionsGameP1.getWidgetTypeForItem = function(list, model, row)
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

LUI.createMenu.TFOptionsGamePage = function(controller)
    local self = CoD.Menu.NewForUIEditor("TFOptionsGamePage")

    self.soundSet = "ChooseDecal"
    self:setOwner(controller)
    self:setLeftRight(true, true, 0, 0)
    self:setTopBottom(true, true, 0, 0)
    self:playSound("menu_open", controller)
    self.buttonModel = Engine.CreateModel(Engine.GetModelForController(controller), "TFOptionsGamePage.buttonPrompts")
    local menu = self
    self.anyChildUsesUpdateState = true

    local Background = LUI.UIImage.new()
    Background:setLeftRight(true, false, 0, 1280)
    Background:setTopBottom(true, false, 0, 720)
    Background:setRGB(0, 0, 0)
    Background:setAlpha(1);
    self:addElement(Background)
    self.Background = Background

    local title = "GAME OPTIONS"
    local MenuFrame = CoD.GenericMenuFrame.new(menu, controller)
    MenuFrame:setLeftRight(true, true, 0, 0)
    MenuFrame:setTopBottom(true, true, 0, 0)
    MenuFrame.titleLabel:setText(title)
    MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(title)
    MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon:setImage(RegisterImage(
        "uie_t7_mp_icon_header_option"))
    self:addElement(MenuFrame)
    self.MenuFrame = MenuFrame

    local StartMenulineGraphicsOptions0 = CoD.StartMenu_lineGraphics_Options.new(menu, controller)
    StartMenulineGraphicsOptions0:setLeftRight(true, false, 1, 69)
    StartMenulineGraphicsOptions0:setTopBottom(true, false, -13, 657)
    self:addElement(StartMenulineGraphicsOptions0)
    self.StartMenulineGraphicsOptions0 = StartMenulineGraphicsOptions0

    local CategoryListLine = LUI.UIImage.new()
    CategoryListLine:setLeftRight(true, false, -11, 1293)
    CategoryListLine:setTopBottom(true, false, 80, 88)
    CategoryListLine:setRGB(0.9, 0.9, 0.9)
    CategoryListLine:setImage(RegisterImage("uie_t7_menu_cac_tabline"))
    self:addElement(CategoryListLine)
    self.CategoryListLine = CategoryListLine

    local categoryFrame = LUI.UIFrame.new(menu, controller, 0, 0, false)
    categoryFrame:setLeftRight(true, false, 64, 1216)
    categoryFrame:setTopBottom(true, false, 134.22, 657)
    self:addElement(categoryFrame)
    self.categoryFrame = categoryFrame

    local widget = CoD.TFOptions_Game_P1.new(self, controller)
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

    MenuFrame:setModel(self.buttonModel, controller)
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
            "TFOptionsGamePage.buttonPrompts"))
    end)
    if configureMouseInput then
        configureMouseInput(self, controller)
    end
    return self
end

