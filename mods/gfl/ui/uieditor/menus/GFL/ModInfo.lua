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

local function getWidgetType(f27_arg0, f27_arg1, f27_arg2)
    if f27_arg1 then
        local f27_local0 = Engine.GetModelValue(Engine.GetModel(f27_arg1, "widgetType"))
        if f27_local0 == "dropdown" then
            return CoD.OptionDropdown
        elseif f27_local0 == "checkbox" then
            return CoD.StartMenu_Options_CheckBoxOption
        elseif f27_local0 == "slider" then
            return CoD.StartMenu_Options_SliderBar
        elseif f27_local0 == "spacer" then
            return CoD.VerticalListSpacer
        elseif f27_local0 == "navbutton" then
            return CoD.TFOptions_NavButton
        end
    end
    return nil
end

DataSources.ModInfoUsefulLinks = DataSourceHelpers.ListSetup("ModInfoUsefulLinks", function(f26_arg0)
    local f26_local0 = {}
    table.insert(f26_local0, {
        models = {
            label = "GFL_MENU_WORKSHOP",
            description = "",
            url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3019676071",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "GFL_MENU_IOP_WIKI",
            description = "",
            url = "https://iopwiki.com",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "Github Repo",
            description = "",
            url = "https://github.com/Loyalists/gflt7",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "MENU_CREDITS_CAPS",
            description = "",
            url = "https://github.com/Loyalists/gflt7/wiki/Credits",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "t7patch",
            description = "",
            url = "https://github.com/shiversoftdev/t7patch",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "Discord Server",
            description = "",
            url = "https://discord.com/invite/yYQDxkUtkV",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "Twitter",
            description = "",
            url = "https://twitter.com/loyalists_dev",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    return f26_local0
end, true)

DataSources.ModInfoUsefulLinks.getWidgetTypeForItem = getWidgetType

DataSources.ModInfoFAQ = DataSourceHelpers.ListSetup("ModInfoFAQ", function(f26_arg0)
    local f26_local0 = {}
    table.insert(f26_local0, {
        models = {
            label = "GFL_MODINFO_FAQ_EYES_BAD_RENDER",
            description = "GFL_MODINFO_FAQ_EYES_BAD_RENDER_DESC",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsEmptyButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "GFL_MODINFO_FAQ_SAVE_RESET",
            description = "GFL_MODINFO_FAQ_SAVE_RESET_DESC",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsEmptyButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "GFL_MODINFO_FAQ_CUSTOM_MAPS",
            description = "GFL_MODINFO_FAQ_CUSTOM_MAPS_DESC",
            url = "steam://openurl/https://steamcommunity.com/workshop/filedetails/discussion/3019676071/6490302633991603070/",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "GFL_MODINFO_FAQ_CP_LOADING",
            description = "GFL_MODINFO_FAQ_CP_LOADING_DESC",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsEmptyButtonProperties
    })
    table.insert(f26_local0, {
        models = {
            label = "GFL_MODINFO_FAQ_CHAT_CMD",
            description = "GFL_MODINFO_FAQ_CHAT_CMD_DESC",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsEmptyButtonProperties
    })
    return f26_local0
end, true)

DataSources.ModInfoFAQ.getWidgetTypeForItem = getWidgetType

DataSources.ModInfoCategories = DataSourceHelpers.ListSetup("ModInfoCategories", function(f28_arg0)
    local f28_local0 = {}
    table.insert(f28_local0, {
        models = {
            tabIcon = CoD.buttonStrings.shoulderl
        },
        properties = {
            m_mouseDisabled = true
        }
    })
    table.insert(f28_local0, {
        models = {
            tabName = "GFL_MODINFO_HOMEPAGE",
            tabWidget = "CoD.ModInfoP1"
        }
    })
    table.insert(f28_local0, {
        models = {
            tabName = "FAQ",
            tabWidget = "CoD.ModInfoFAQPage"
        }
    })
    table.insert(f28_local0, {
        models = {
            tabName = "USEFUL LINKS",
            tabWidget = "CoD.ModInfoUsefulLinksPage"
        }
    })
    table.insert(f28_local0, {
        models = {
            tabIcon = CoD.buttonStrings.shoulderr
        },
        properties = {
            m_mouseDisabled = true
        }
    })
    return f28_local0
end, true)

LUI.createMenu.ModInfo = function(InstanceRef)
    local HudRef = CoD.Menu.NewForUIEditor("ModInfo")

    HudRef.soundSet = "ChooseDecal"
    HudRef:setOwner(InstanceRef)
    HudRef:setLeftRight(true, true, 0, 0)
    HudRef:setTopBottom(true, true, 0, 0)
    HudRef:playSound("menu_open", InstanceRef)
    HudRef.buttonModel = Engine.CreateModel(Engine.GetModelForController(InstanceRef), "ModInfo.buttonPrompts")
    local f31_local1 = HudRef
    HudRef.anyChildUsesUpdateState = true
    local f31_local2 = LUI.UIImage.new()
    f31_local2:setLeftRight(true, false, 0, 1280)
    f31_local2:setTopBottom(true, false, 0, 720)
    f31_local2:setRGB(0, 0, 0)
    -- f31_local2:setAlpha(0.7);
    HudRef:addElement(f31_local2)
    HudRef.Background = f31_local2

    local f31_local3 = CoD.GenericMenuFrame.new(f31_local1, InstanceRef)
    f31_local3:setLeftRight(true, true, 0, 0)
    f31_local3:setTopBottom(true, true, 0, 0)
    f31_local3.titleLabel:setText(" ")
    f31_local3.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(Engine.Localize("GFL_MODINFO_TITLE"))
    f31_local3.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon:setImage(RegisterImage(
        "uie_t7_mp_icon_header_option"))
    HudRef:addElement(f31_local3)
    HudRef.MenuFrame = f31_local3

    local f31_local5 = CoD.StartMenu_lineGraphics_Options.new(f31_local1, InstanceRef)
    f31_local5:setLeftRight(true, false, 1, 69)
    f31_local5:setTopBottom(true, false, -13, 657)
    HudRef:addElement(f31_local5)
    HudRef.StartMenulineGraphicsOptions0 = f31_local5

    local f31_local7 = CoD.basicTabList.new(f31_local1, InstanceRef)
    f31_local7:setLeftRight(true, false, 64, 1216)
    f31_local7:setTopBottom(true, false, 84, 124)
    f31_local7.grid:setDataSource("ModInfoCategories")
    f31_local7.grid:setWidgetType(CoD.paintshopTabWidget)
    f31_local7.grid:setHorizontalCount(11)
    HudRef:addElement(f31_local7)
    HudRef.Tabs = f31_local7

    local f31_local8 = LUI.UIFrame.new(f31_local1, InstanceRef, 0, 0, false)
    f31_local8:setLeftRight(true, false, 64, 1216)
    f31_local8:setTopBottom(true, false, 134.22, 657)
    HudRef:addElement(f31_local8)
    HudRef.categoryFrame = f31_local8

    --[[ 	CoD.TFOptionDebugText = CoD.TextWithBg.new(HudRef, InstanceRef)
    CoD.TFOptionDebugText:setLeftRight(true, true, 240, -240)
    CoD.TFOptionDebugText:setTopBottom(true, false, 20, 50)
    CoD.TFOptionDebugText.Text:setText("HUD Inject")
    CoD.TFOptionDebugText.Bg:setRGB(0.098, 0.098, 0.098)
    CoD.TFOptionDebugText.Bg:setAlpha(0.8)
	HudRef:addElement(CoD.TFOptionDebugText) ]]

    f31_local8:linkToElementModel(f31_local7.grid, "tabWidget", true, function(ModelRef)
        local ModelValue = Engine.GetModelValue(ModelRef)
        if ModelValue then
            f31_local8:changeFrameWidget(ModelValue)
        end
    end)
    HudRef:registerEventHandler("menu_loaded", function(Sender, Event)
        local f39_local0 = nil
        ShowHeaderIconOnly(f31_local1)
        if not f39_local0 then
            f39_local0 = Sender:dispatchEventToChildren(Event)
        end
        return f39_local0
    end)
    f31_local1:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil,
        function(f40_arg0, f40_arg1, f40_arg2, f40_arg3)
            GoBack(HudRef, f40_arg2)
            return true
        end, function(f41_arg0, f41_arg1, f41_arg2)
            CoD.Menu.SetButtonLabel(f41_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK")
            return true
        end, false)
    f31_local1:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_START, "M",
        function(f42_arg0, f42_arg1, f42_arg2, f42_arg3)
            CloseStartMenu(f42_arg1, f42_arg2)
            return true
        end, function(f43_arg0, f43_arg1, f43_arg2)
            CoD.Menu.SetButtonLabel(f43_arg1, Enum.LUIButton.LUI_KEY_START, "MENU_DISMISS_MENU")
            return true
        end, false)
    f31_local1:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil,
        function(f48_arg0, f48_arg1, f48_arg2, f48_arg3)
            return true
        end, function(f49_arg0, f49_arg1, f49_arg2)
            CoD.Menu.SetButtonLabel(f49_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT")
            return true
        end, false)
    f31_local3:setModel(HudRef.buttonModel, InstanceRef)
    f31_local8.id = "categoryFrame"
    HudRef:processEvent({
        name = "menu_loaded",
        controller = InstanceRef
    })
    HudRef:processEvent({
        name = "update_state",
        menu = f31_local1
    })
    if not HudRef:restoreState() then
        HudRef.categoryFrame:processEvent({
            name = "gain_focus",
            controller = InstanceRef
        })
    end
    LUI.OverrideFunction_CallOriginalSecond(HudRef, "close", function(Sender)
        Sender.MenuFrame:close()
        Sender.StartMenulineGraphicsOptions0:close()
        Sender.Tabs:close()
        Sender.categoryFrame:close()
        Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "ModInfo.buttonPrompts"))
    end)
    if f0_local3 then
        f0_local3(HudRef, InstanceRef)
    end

    return HudRef
end
