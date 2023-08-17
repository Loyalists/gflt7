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
require("ui.t7.utility.SavingDataUtility")
require("ui.uieditor.widgets.Scrollbars.verticalCounter")

local f0_local3 = function(f30_arg0, f30_arg1)
    f30_arg0.categoryFrame:setForceMouseEventDispatch(true)
end

DataSources.TFOptionsPlayerHealth = DataSourceHelpers.ListSetup("PC.TFOptionsPlayerHealth", function(f15_arg0)
    local f15_local0 = {}
    table.insert(f15_local0, {
        models = {
            value = 35,
            valueDisplay = "1 Hit (35%)"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 75,
            valueDisplay = "2 Hits (75%)"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 100,
            valueDisplay = "3 Hits (100%)"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 150,
            valueDisplay = "4 Hits (150%)"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 200,
            valueDisplay = "5 Hits (200%)"
        }
    })
    return f15_local0
end, true)

DataSources.TFOptionsStartingPoints = DataSourceHelpers.ListSetup("PC.TFOptionsStartingPoints", function(f15_arg0)
    local f15_local0 = {}
    table.insert(f15_local0, {
        models = {
            value = 0,
            valueDisplay = "0"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 250,
            valueDisplay = "250"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 500,
            valueDisplay = "500"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 750,
            valueDisplay = "750"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 1000,
            valueDisplay = "1000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 1500,
            valueDisplay = "1500"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 2000,
            valueDisplay = "2000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 2500,
            valueDisplay = "2500"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 3000,
            valueDisplay = "3000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 4000,
            valueDisplay = "4000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 5000,
            valueDisplay = "5000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 7500,
            valueDisplay = "7500"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 10000,
            valueDisplay = "10000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 15000,
            valueDisplay = "15000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 20000,
            valueDisplay = "20000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 30000,
            valueDisplay = "30000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 50000,
            valueDisplay = "50000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 100000,
            valueDisplay = "100000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 500000,
            valueDisplay = "500000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 1000000,
            valueDisplay = "1000000"
        }
    })
    return f15_local0
end, true)

DataSources.TFOptionsPlayerP1 = DataSourceHelpers.ListSetup("PC.TFOptionsPlayerP1", function(f26_arg0)
    local f26_local0 = {}
    table.insert(f26_local0, {
        models = {
            label = "Starting Points",
            description = "Choose how many points to start a game with.",
            profileVarName = "starting_points",
            datasource = "TFOptionsStartingPoints",
            widgetType = "dropdown"
        },
        properties = CoD.TFPCUtil.OptionsGenericDropdownProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "Move Speed Multiplier",
            description = "Tweak the player speed. 1 is default.",
            profileVarName = "move_speed",
            lowValue = 0.1,
            highValue = 2,
            isFloat = 1,
            widgetType = "slider"
        },
        properties = CoD.TFPCUtil.OptionsGenericSliderProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "Player Health",
            description = "Choose how many hits from a zombie it takes to down the player.",
            profileVarName = "higher_health",
            datasource = "TFOptionsPlayerHealth",
            widgetType = "dropdown"
        },
        properties = CoD.TFPCUtil.OptionsGenericDropdownProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "EXO Movement",
            description = "Enable EXO movement. (Probably won't work on any maps that use EXO movement, such as SoE or Der Eisendrache)",
            profileVarName = "exo_movement",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "Player-Determined Playermodel",
            description = "Uses the currently selected playermodel from Characters Menu. \nDoesn't work on Moon and Origins.",
            profileVarName = "player_determined_character",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "Randomized Playermodel",
            description = "Randomizes the model of each player so that more GFL characters can be chosen, adding additional variety to the gameplay. \nIf both 'Player-Determined Playermodel' and 'Randomized Playermodel' are enabled the playermodel will only be randomized for Bots. \nDoesn't work on Moon and Origins.",
            profileVarName = "randomize_character",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    return f26_local0
end, true)

DataSources.TFOptionsPlayerP1.getWidgetTypeForItem = function(f27_arg0, f27_arg1, f27_arg2)
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

LUI.createMenu.TFOptionsPlayerPage = function(InstanceRef)
    local self = CoD.Menu.NewForUIEditor("TFOptionsPlayerPage")

    self.soundSet = "ChooseDecal"
    self:setOwner(InstanceRef)
    self:setLeftRight(true, true, 0, 0)
    self:setTopBottom(true, true, 0, 0)
    self:playSound("menu_open", InstanceRef)
    self.buttonModel = Engine.CreateModel(Engine.GetModelForController(InstanceRef),
        "TFOptionsPlayerPage.buttonPrompts")
    local f31_local1 = self
    self.anyChildUsesUpdateState = true

    local f31_local2 = LUI.UIImage.new()
    f31_local2:setLeftRight(true, false, 0, 1280)
    f31_local2:setTopBottom(true, false, 0, 720)
    f31_local2:setRGB(0, 0, 0)
    f31_local2:setAlpha(1)
    self:addElement(f31_local2)
    self.Background = f31_local2

    local title = "PLAYER OPTIONS"
    local f31_local3 = CoD.GenericMenuFrame.new(f31_local1, InstanceRef)
    f31_local3:setLeftRight(true, true, 0, 0)
    f31_local3:setTopBottom(true, true, 0, 0)
    f31_local3.titleLabel:setText(title)
    f31_local3.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(title)
    f31_local3.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon:setImage(RegisterImage(
        "uie_t7_mp_icon_header_option"))
    self:addElement(f31_local3)
    self.MenuFrame = f31_local3

    local f31_local5 = CoD.StartMenu_lineGraphics_Options.new(f31_local1, InstanceRef)
    f31_local5:setLeftRight(true, false, 1, 69)
    f31_local5:setTopBottom(true, false, -13, 657)
    self:addElement(f31_local5)
    self.StartMenulineGraphicsOptions0 = f31_local5

    local f31_local6 = LUI.UIImage.new()
    f31_local6:setLeftRight(true, false, -11, 1293)
    f31_local6:setTopBottom(true, false, 80, 88)
    f31_local6:setRGB(0.9, 0.9, 0.9)
    f31_local6:setImage(RegisterImage("uie_t7_menu_cac_tabline"))
    self:addElement(f31_local6)
    self.CategoryListLine = f31_local6

    local categoryFrame = LUI.UIFrame.new(f31_local1, InstanceRef, 0, 0, false)
    categoryFrame:setLeftRight(true, false, 64, 1216)
    categoryFrame:setTopBottom(true, false, 134.22, 657)
    self:addElement(categoryFrame)
    self.categoryFrame = categoryFrame

    local widget = CoD.TFOptions_Player_P1.new(self, InstanceRef)
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

    f31_local3:setModel(self.buttonModel, InstanceRef)
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
            "TFOptionsPlayerPage.buttonPrompts"))
    end)
    if f0_local3 then
        f0_local3(self, InstanceRef)
    end
    return self
end

