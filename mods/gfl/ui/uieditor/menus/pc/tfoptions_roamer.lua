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

DataSources.TFOptionsRoamerTime = DataSourceHelpers.ListSetup("PC.TFOptionsRoamerTime", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            value = 0,
            valueDisplay = "Infinite"
        }
    })
    table.insert(items, {
        models = {
            value = 30,
            valueDisplay = "30 Seconds"
        }
    })
    table.insert(items, {
        models = {
            value = 60,
            valueDisplay = "1 Minute"
        }
    })
    table.insert(items, {
        models = {
            value = 120,
            valueDisplay = "2 Minutes"
        }
    })
    table.insert(items, {
        models = {
            value = 300,
            valueDisplay = "5 Minutes"
        }
    })
    return items
end, true)


DataSources.TFOptionsRoamerP1 = DataSourceHelpers.ListSetup("PC.TFOptionsRoamerP1", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            label = "TF_ROAMER_ENABLED",
            description = "TF_ROAMER_ENABLED_DESC",
            profileVarName = "roamer_enabled",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_ROAMER_TIME",
            description = "TF_ROAMER_TIME_DESC",
            profileVarName = "roamer_time",
            datasource = "TFOptionsRoamerTime",
            widgetType = "dropdown"
        },
        properties = CoD.TFPCUtil.OptionsGenericDropdownProperties
    })
    return items
end, true)

DataSources.TFOptionsRoamerP1.getWidgetTypeForItem = function(list, model, row)
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

LUI.createMenu.TFOptionsRoamerPage = function(controller)
    local self = CoD.Menu.NewForUIEditor("TFOptionsRoamerPage")

    self.soundSet = "ChooseDecal"
    self:setOwner(controller)
    self:setLeftRight(true, true, 0, 0)
    self:setTopBottom(true, true, 0, 0)
    self:playSound("menu_open", controller)
    self.buttonModel = Engine.CreateModel(Engine.GetModelForController(controller),
        "TFOptionsRoamerPage.buttonPrompts")
    local menu = self
    self.anyChildUsesUpdateState = true

    local background = LUI.UIImage.new()
    background:setLeftRight(true, false, 0, 1280)
    background:setTopBottom(true, false, 0, 720)
    background:setRGB(0, 0, 0)
    background:setAlpha(1);
    self:addElement(background)
    self.Background = background

    local title = "ROAMER OPTIONS"
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

    local widget = CoD.TFOptions_Roamer_P1.new(self, controller)
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
            "TFOptionsRoamerPage.buttonPrompts"))
    end)
    if configureMouseInput then
        configureMouseInput(self, controller)
    end
    return self
end

