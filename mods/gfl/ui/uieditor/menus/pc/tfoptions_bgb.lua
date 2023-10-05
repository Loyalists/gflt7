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

DataSources.TFOptionsBGBCost = DataSourceHelpers.ListSetup("PC.TFOptionsBGBCost", function(f15_arg0)
    local f15_local0 = {}
    table.insert(f15_local0, {
        models = {
            value = 0,
            valueDisplay = "0"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 1,
            valueDisplay = "500"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 2,
            valueDisplay = "1000"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 3,
            valueDisplay = "1500"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 4,
            valueDisplay = "2000"
        }
    })
    return f15_local0
end, true)

DataSources.TFOptionsBGBUses = DataSourceHelpers.ListSetup("PC.TFOptionsBGBUses", function(f15_arg0)
    local f15_local0 = {}
    table.insert(f15_local0, {
        models = {
            value = 0,
            valueDisplay = "MENU_DEFAULT"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 1,
            valueDisplay = "5"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 2,
            valueDisplay = "10"
        }
    })
    table.insert(f15_local0, {
        models = {
            value = 3,
            valueDisplay = "MENU_UNLIMITED"
        }
    })
    return f15_local0
end, true)

DataSources.TFOptionsBGB = DataSourceHelpers.ListSetup("PC.TFOptionsBGB", function(f26_arg0)
    local f26_local0 = {}
    table.insert(f26_local0, {
        models = {
            label = "TF_BGB_LOADOUT",
            description = "TF_BGB_LOADOUT_DESC",
            profileVarName = "bgb_loadout",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_BGB_FIXED_COST",
            description = "TF_BGB_FIXED_COST_DESC",
            profileVarName = "fixed_cost",
            widgetType = "tfcheckbox"
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_BGB_COST",
            description = "TF_BGB_COST_DESC",
            profileVarName = "bgb_cost",
            datasource = "TFOptionsBGBCost",
            widgetType = "dropdown"
        },
        properties = CoD.TFPCUtil.OptionsGenericDropdownProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "TF_BGB_LIMIT",
            description = "TF_BGB_LIMIT_DESC",
            profileVarName = "bgb_uses",
            datasource = "TFOptionsBGBUses",
            widgetType = "dropdown"
        },
        properties = CoD.TFPCUtil.OptionsGenericDropdownProperties
    })
    return f26_local0
end, true)

DataSources.TFOptionsBGB.getWidgetTypeForItem = function(f27_arg0, f27_arg1, f27_arg2)
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

LUI.createMenu.TFOptionsBGBPage = function(InstanceRef)
    local self = CoD.Menu.NewForUIEditor("TFOptionsBGBPage")

    self.soundSet = "ChooseDecal"
    self:setOwner(InstanceRef)
    self:setLeftRight(true, true, 0, 0)
    self:setTopBottom(true, true, 0, 0)
    self:playSound("menu_open", InstanceRef)
    self.buttonModel = Engine.CreateModel(Engine.GetModelForController(InstanceRef), "TFOptionsBGBPage.buttonPrompts")
    local f31_local1 = self
    self.anyChildUsesUpdateState = true

    local f31_local2 = LUI.UIImage.new()
    f31_local2:setLeftRight(true, false, 0, 1280)
    f31_local2:setTopBottom(true, false, 0, 720)
    f31_local2:setRGB(0, 0, 0)
    f31_local2:setAlpha(1);
    self:addElement(f31_local2)
    self.Background = f31_local2

    local title = "GOBBLEGUM OPTIONS"
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

    local widget = CoD.TFOptions_BGB_P1.new(self, InstanceRef)
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
            "TFOptionsBGBPage.buttonPrompts"))
    end)
    if f0_local3 then
        f0_local3(self, InstanceRef)
    end
    return self
end
