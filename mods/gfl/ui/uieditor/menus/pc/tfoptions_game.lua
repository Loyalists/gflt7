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

local f0_local3 = function(f30_arg0, f30_arg1)
    f30_arg0.categoryFrame:setForceMouseEventDispatch(true)
end

DataSources.TFOptionsFriendlyFire = DataSourceHelpers.ListSetup("PC.TFOptionsFriendlyFire", function(f15_arg0)
    local f15_local0 = {}
    table.insert(f15_local0, {
        models = {
            value = 0,
            valueDisplay = "MENU_DISABLED"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 1,
            valueDisplay = "MENU_ENABLED"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 2,
            valueDisplay = "MENU_SHARED"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 3,
            valueDisplay = "MPUI_REFLECT"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 4,
            valueDisplay = "TF_KNOCK_BACK"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 5,
            valueDisplay = "TF_NON_LETHAL"
        }
    })
    return f15_local0
end, true)

DataSources.TFOptionsHitmarkersSound = DataSourceHelpers.ListSetup("PC.TFOptionsHitmarkersSound", function(f15_arg0)
    local f15_local0 = {}
    table.insert(f15_local0, {
        models = {
            value = 0,
            valueDisplay = "Black Ops 3"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 1,
            valueDisplay = "Classic"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 2,
            valueDisplay = "Modern Warfare"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 3,
            valueDisplay = "Modern Warfare III"
        }
    })
    return f15_local0
end, true)

DataSources.TFOptionsGameP1 = DataSourceHelpers.ListSetup("PC.TFOptionsGameP1", function(f26_arg0)
    local f26_local0 = {}
    table.insert(f26_local0, {
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
    table.insert(f26_local0, {
        models = {
            label = "MENU_FRIENDLYFIRE",
            description = "TF_FRIENDLYFIRE_DESC",
            profileVarName = "friendlyfire",
            datasource = "TFOptionsFriendlyFire",
            widgetType = "dropdown"
        },
        properties = CoD.TFPCUtil.OptionsGenericDropdownProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_ZCOUNTER",
            description = "TF_ZCOUNTER_DESC",
            profileVarName = "zcounter_enabled",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_HITMARKERS",
            description = "TF_HITMARKERS_DESC",
            profileVarName = "hitmarkers",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_HITMARKERS_SOUND",
            description = "TF_HITMARKERS_SOUND_DESC",
            profileVarName = "hitmarkers_sound",
            datasource = "TFOptionsHitmarkersSound",
            widgetType = "dropdown"
        },
        properties = CoD.TFPCUtil.OptionsGenericDropdownProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_NO_ROUND_DELAY",
            description = "TF_NO_ROUND_DELAY_DESC",
            profileVarName = "no_round_delay",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_TIMED_GAMEPLAY",
            description = "TF_TIMED_GAMEPLAY_DESC",
            profileVarName = "timed_gameplay",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_EVERY_BOX",
            description = "TF_EVERY_BOX_DESC",
            profileVarName = "every_box",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_OPEN_ALL_DOORS",
            description = "TF_OPEN_ALL_DOORS_DESC",
            profileVarName = "open_all_doors",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_START_POWER",
            description = "TF_START_POWER_DESC",
            profileVarName = "start_power",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_ROUND_REVIVE",
            description = "TF_ROUND_REVIVE_DESC",
            profileVarName = "roundrevive",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_THIRDPERSON",
            description = "TF_THIRDPERSON_DESC",
            profileVarName = "thirdperson",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    return f26_local0
end, true)

DataSources.TFOptionsGameP1.getWidgetTypeForItem = function(f27_arg0, f27_arg1, f27_arg2)
    if f27_arg1 then
        local f27_local0 = Engine.GetModelValue(Engine.GetModel(f27_arg1, "widgetType"))
        if f27_local0 == "dropdown" then
            return CoD.OptionDropdown
        elseif f27_local0 == "checkbox" then
            return CoD.StartMenu_Options_CheckBoxOption
        elseif f27_local0 == "tfcheckbox" then
            return CoD.TFOptions_CheckBoxOption
        elseif f27_local0 == "slider" then
            return CoD.StartMenu_Options_SliderBar
        elseif f27_local0 == "spacer" then
            return CoD.VerticalListSpacer
        end
    end
    return nil
end

LUI.createMenu.TFOptionsGamePage = function(InstanceRef)
    local self = CoD.Menu.NewForUIEditor("TFOptionsGamePage")

    self.soundSet = "ChooseDecal"
    self:setOwner(InstanceRef)
    self:setLeftRight(true, true, 0, 0)
    self:setTopBottom(true, true, 0, 0)
    self:playSound("menu_open", InstanceRef)
    self.buttonModel = Engine.CreateModel(Engine.GetModelForController(InstanceRef), "TFOptionsGamePage.buttonPrompts")
    local f31_local1 = self
    self.anyChildUsesUpdateState = true

    local Background = LUI.UIImage.new()
    Background:setLeftRight(true, false, 0, 1280)
    Background:setTopBottom(true, false, 0, 720)
    Background:setRGB(0, 0, 0)
    Background:setAlpha(1);
    self:addElement(Background)
    self.Background = Background

    local title = "GAME OPTIONS"
    local MenuFrame = CoD.GenericMenuFrame.new(f31_local1, InstanceRef)
    MenuFrame:setLeftRight(true, true, 0, 0)
    MenuFrame:setTopBottom(true, true, 0, 0)
    MenuFrame.titleLabel:setText(title)
    MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(title)
    MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon:setImage(RegisterImage(
        "uie_t7_mp_icon_header_option"))
    self:addElement(MenuFrame)
    self.MenuFrame = MenuFrame

    local StartMenulineGraphicsOptions0 = CoD.StartMenu_lineGraphics_Options.new(f31_local1, InstanceRef)
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

    local categoryFrame = LUI.UIFrame.new(f31_local1, InstanceRef, 0, 0, false)
    categoryFrame:setLeftRight(true, false, 64, 1216)
    categoryFrame:setTopBottom(true, false, 134.22, 657)
    self:addElement(categoryFrame)
    self.categoryFrame = categoryFrame

    local widget = CoD.TFOptions_Game_P1.new(self, InstanceRef)
    categoryFrame:changeFrameWidget(widget)

    self:registerEventHandler("menu_loaded", function(Sender, Event)
        local f39_local0 = nil
        ShowHeaderIconOnly(f31_local1)
        if not f39_local0 then
            f39_local0 = Sender:dispatchEventToChildren(Event)
        end
        return f39_local0
    end)

    f31_local1:AddButtonCallbackFunction(self, InstanceRef, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil,
        function(f40_arg0, f40_arg1, f40_arg2, f40_arg3)
            GoBack(self, f40_arg2)
            return true
        end, function(f41_arg0, f41_arg1, f41_arg2)
            CoD.Menu.SetButtonLabel(f41_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK")
            return true
        end, false)

    f31_local1:AddButtonCallbackFunction(self, InstanceRef, Enum.LUIButton.LUI_KEY_START, "M",
        function(f42_arg0, f42_arg1, f42_arg2, f42_arg3)
            CloseStartMenu(f42_arg1, f42_arg2)
            return true
        end, function(f43_arg0, f43_arg1, f43_arg2)
            CoD.Menu.SetButtonLabel(f43_arg1, Enum.LUIButton.LUI_KEY_START, "MENU_DISMISS_MENU")
            return true
        end, false)

    f31_local1:AddButtonCallbackFunction(self, InstanceRef, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "R",
        function(f46_arg0, f46_arg1, f46_arg2, f46_arg3)
            CoD.TFPCUtil.ResetToDefault()
            GoBack(self, f46_arg2)
            return true
        end, function(f47_arg0, f47_arg1, f47_arg2)
            CoD.Menu.SetButtonLabel(f47_arg1, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "PLATFORM_RESET_TO_DEFAULT")
            return true
        end, false)

    f31_local1:AddButtonCallbackFunction(self, InstanceRef, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil,
        function(f48_arg0, f48_arg1, f48_arg2, f48_arg3)
            return true
        end, function(f49_arg0, f49_arg1, f49_arg2)
            CoD.Menu.SetButtonLabel(f49_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT")
            return true
        end, false)

    MenuFrame:setModel(self.buttonModel, InstanceRef)
    categoryFrame.id = "categoryFrame"
    self:processEvent({
        name = "menu_loaded",
        controller = InstanceRef
    })
    self:processEvent({
        name = "update_state",
        menu = f31_local1
    })
    if not self:restoreState() then
        self.categoryFrame:processEvent({
            name = "gain_focus",
            controller = InstanceRef
        })
    end
    LUI.OverrideFunction_CallOriginalSecond(self, "close", function(Sender)
        Sender.MenuFrame:close()
        Sender.StartMenulineGraphicsOptions0:close()
        Sender.categoryFrame:close()
        Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "TFOptionsGamePage.buttonPrompts"))
    end)
    if f0_local3 then
        f0_local3(self, InstanceRef)
    end
    return self
end

