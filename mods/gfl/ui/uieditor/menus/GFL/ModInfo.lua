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

local configureMouseInput = function(menu, controller)
    menu.categoryFrame:setForceMouseEventDispatch(true)
end

local function getWidgetType(f27_arg0, parentModel, f27_arg2)
    if parentModel then
        local widgetType = Engine.GetModelValue(Engine.GetModel(parentModel, "widgetType"))
        if widgetType == "dropdown" then
            return CoD.OptionDropdown
        elseif widgetType == "checkbox" then
            return CoD.StartMenu_Options_CheckBoxOption
        elseif widgetType == "slider" then
            return CoD.StartMenu_Options_SliderBar
        elseif widgetType == "spacer" then
            return CoD.VerticalListSpacer
        elseif widgetType == "navbutton" then
            return CoD.TFOptions_NavButton
        end
    end
    return nil
end

DataSources.ModInfoUsefulLinks = DataSourceHelpers.ListSetup("ModInfoUsefulLinks", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            label = "GFL_MENU_WORKSHOP",
            description = "",
            url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3019676071",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(items, {
        models = {
            label = "GFL_MENU_IOP_WIKI",
            description = "",
            url = "https://iopwiki.com",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(items, {
        models = {
            label = "Github Repo",
            description = "",
            url = "https://github.com/Loyalists/gflt7",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(items, {
        models = {
            label = "MENU_CREDITS_CAPS",
            description = "",
            url = "https://github.com/Loyalists/gflt7/wiki/Credits",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(items, {
        models = {
            label = "t7patch",
            description = "",
            url = "https://github.com/shiversoftdev/t7patch",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(items, {
        models = {
            label = "Discord Server",
            description = "",
            url = "https://discord.com/invite/yYQDxkUtkV",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(items, {
        models = {
            label = "Twitter",
            description = "",
            url = "https://twitter.com/loyalists_dev",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    return items
end, true)

DataSources.ModInfoUsefulLinks.getWidgetTypeForItem = getWidgetType

DataSources.ModInfoFAQ = DataSourceHelpers.ListSetup("ModInfoFAQ", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            label = "GFL_MODINFO_FAQ_EYES_BAD_RENDER",
            description = "GFL_MODINFO_FAQ_EYES_BAD_RENDER_DESC",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsEmptyButtonProperties
    })
    table.insert(items, {
        models = {
            label = "GFL_MODINFO_FAQ_SAVE_RESET",
            description = "GFL_MODINFO_FAQ_SAVE_RESET_DESC",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsEmptyButtonProperties
    })
    table.insert(items, {
        models = {
            label = "GFL_MODINFO_FAQ_CUSTOM_MAPS",
            description = "GFL_MODINFO_FAQ_CUSTOM_MAPS_DESC",
            url = "steam://openurl/https://steamcommunity.com/workshop/filedetails/discussion/3019676071/6490302633991603070/",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsUrlButtonProperties
    })
    table.insert(items, {
        models = {
            label = "GFL_MODINFO_FAQ_CP_LOADING",
            description = "GFL_MODINFO_FAQ_CP_LOADING_DESC",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsEmptyButtonProperties
    })
    table.insert(items, {
        models = {
            label = "GFL_MODINFO_FAQ_CHAT_CMD",
            description = "GFL_MODINFO_FAQ_CHAT_CMD_DESC",
            widgetType = "navbutton"
        },
        properties = CoD.TFPCUtil.OptionsEmptyButtonProperties
    })
    return items
end, true)

DataSources.ModInfoFAQ.getWidgetTypeForItem = getWidgetType

DataSources.ModInfoCategories = DataSourceHelpers.ListSetup("ModInfoCategories", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            tabIcon = CoD.buttonStrings.shoulderl
        },
        properties = {
            m_mouseDisabled = true
        }
    })
    table.insert(items, {
        models = {
            tabName = "GFL_MODINFO_HOMEPAGE",
            tabWidget = "CoD.ModInfoP1"
        }
    })
    table.insert(items, {
        models = {
            tabName = "FAQ",
            tabWidget = "CoD.ModInfoFAQPage"
        }
    })
    table.insert(items, {
        models = {
            tabName = "USEFUL LINKS",
            tabWidget = "CoD.ModInfoUsefulLinksPage"
        }
    })
    table.insert(items, {
        models = {
            tabIcon = CoD.buttonStrings.shoulderr
        },
        properties = {
            m_mouseDisabled = true
        }
    })
    return items
end, true)

LUI.createMenu.ModInfo = function(controller)
    local HudRef = CoD.Menu.NewForUIEditor("ModInfo")

    HudRef.soundSet = "ChooseDecal"
    HudRef:setOwner(controller)
    HudRef:setLeftRight(true, true, 0, 0)
    HudRef:setTopBottom(true, true, 0, 0)
    HudRef:playSound("menu_open", controller)
    HudRef.buttonModel = Engine.CreateModel(Engine.GetModelForController(controller), "ModInfo.buttonPrompts")
    local f31_local1 = HudRef
    HudRef.anyChildUsesUpdateState = true
    local background = LUI.UIImage.new()
    background:setLeftRight(true, false, 0, 1280)
    background:setTopBottom(true, false, 0, 720)
    background:setRGB(0, 0, 0)
    -- f31_local2:setAlpha(0.7);
    HudRef:addElement(background)
    HudRef.Background = background

    local menuFrame = CoD.GenericMenuFrame.new(f31_local1, controller)
    menuFrame:setLeftRight(true, true, 0, 0)
    menuFrame:setTopBottom(true, true, 0, 0)
    menuFrame.titleLabel:setText(" ")
    menuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(Engine.Localize("GFL_MODINFO_TITLE"))
    menuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon:setImage(RegisterImage(
        "uie_t7_mp_icon_header_option"))
    HudRef:addElement(menuFrame)
    HudRef.MenuFrame = menuFrame

    local startMenulineGraphicsOptions0 = CoD.StartMenu_lineGraphics_Options.new(f31_local1, controller)
    startMenulineGraphicsOptions0:setLeftRight(true, false, 1, 69)
    startMenulineGraphicsOptions0:setTopBottom(true, false, -13, 657)
    HudRef:addElement(startMenulineGraphicsOptions0)
    HudRef.StartMenulineGraphicsOptions0 = startMenulineGraphicsOptions0

    local tabs = CoD.basicTabList.new(f31_local1, controller)
    tabs:setLeftRight(true, false, 64, 1216)
    tabs:setTopBottom(true, false, 84, 124)
    tabs.grid:setDataSource("ModInfoCategories")
    tabs.grid:setWidgetType(CoD.paintshopTabWidget)
    tabs.grid:setHorizontalCount(11)
    HudRef:addElement(tabs)
    HudRef.Tabs = tabs

    local categoryFrame = LUI.UIFrame.new(f31_local1, controller, 0, 0, false)
    categoryFrame:setLeftRight(true, false, 64, 1216)
    categoryFrame:setTopBottom(true, false, 134.22, 657)
    HudRef:addElement(categoryFrame)
    HudRef.categoryFrame = categoryFrame

    --[[ 	CoD.TFOptionDebugText = CoD.TextWithBg.new(HudRef, InstanceRef)
    CoD.TFOptionDebugText:setLeftRight(true, true, 240, -240)
    CoD.TFOptionDebugText:setTopBottom(true, false, 20, 50)
    CoD.TFOptionDebugText.Text:setText("HUD Inject")
    CoD.TFOptionDebugText.Bg:setRGB(0.098, 0.098, 0.098)
    CoD.TFOptionDebugText.Bg:setAlpha(0.8)
	HudRef:addElement(CoD.TFOptionDebugText) ]]

    categoryFrame:linkToElementModel(tabs.grid, "tabWidget", true, function(ModelRef)
        local ModelValue = Engine.GetModelValue(ModelRef)
        if ModelValue then
            categoryFrame:changeFrameWidget(ModelValue)
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
    f31_local1:AddButtonCallbackFunction(HudRef, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil,
        function(element, menu, controller, event)
            GoBack(HudRef, controller)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK")
            return true
        end, false)
    f31_local1:AddButtonCallbackFunction(HudRef, controller, Enum.LUIButton.LUI_KEY_START, "M",
        function(element, menu, controller, event)
            CloseStartMenu(menu, controller)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_START, "MENU_DISMISS_MENU")
            return true
        end, false)
    f31_local1:AddButtonCallbackFunction(HudRef, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil,
        function(element, menu, controller, event)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT")
            return true
        end, false)
    menuFrame:setModel(HudRef.buttonModel, controller)
    categoryFrame.id = "categoryFrame"
    HudRef:processEvent({
        name = "menu_loaded",
        controller = controller
    })
    HudRef:processEvent({
        name = "update_state",
        menu = f31_local1
    })
    if not HudRef:restoreState() then
        HudRef.categoryFrame:processEvent({
            name = "gain_focus",
            controller = controller
        })
    end
    LUI.OverrideFunction_CallOriginalSecond(HudRef, "close", function(Sender)
        Sender.MenuFrame:close()
        Sender.StartMenulineGraphicsOptions0:close()
        Sender.Tabs:close()
        Sender.categoryFrame:close()
        Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(controller),
            "ModInfo.buttonPrompts"))
    end)
    if configureMouseInput then
        configureMouseInput(HudRef, controller)
    end

    return HudRef
end
