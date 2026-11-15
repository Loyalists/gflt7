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

local setCustomHUD = function (varNameString, newValue)
    CoD.PersonalizationUtil.SetValueForOption(varNameString, newValue)

    if not Engine.IsInGame() then
        return
    end

    local converted = tonumber(newValue)
    SetGlobalModelValue("CustomHUD", newValue)
end

local setThirdperson = function (varNameString, newValue)
    CoD.PersonalizationUtil.SetValueForOption(varNameString, newValue)

    local converted = tonumber(newValue)
    Engine.SetDvar("gfl_thirdperson2", converted)
end

local cameraSliderProperties = {
    sliderRefresh = function(controller, slider)
        CoD.TFPCUtil.OptionsSliderRefresh(controller, slider)
        slider.m_formatString = "%d"
    end,
    sliderUpdated = CoD.TFPCUtil.OptionsSliderUpdated
}

local cameraOptions = {
    { name = "thirdperson_range", text = "THIRDPERSON_RANGE", min = 20, max = 200 },
    { name = "thirdperson_side_offset", text = "THIRDPERSON_SIDE_OFFSET", min = -60, max = 60 },
    { name = "thirdperson_up_offset", text = "THIRDPERSON_UP_OFFSET", min = -60, max = 60 },
}

DataSources.PersonalizationOptionsP1 = DataSourceHelpers.ListSetup("PersonalizationOptionsP1", function(controller)
    local items = {}
    table.insert(items, {
        models = {
            label = "TF_DISABLE_INTRO_MOVIE",
            description = "TF_DISABLE_INTRO_MOVIE_DESC",
            profileVarName = "disable_intro_movie",
            widgetType = "tfcheckbox",
            callbackGetValueForOption = CoD.PersonalizationUtil.GetValueForOption,
            callbackSetValueForOption = CoD.PersonalizationUtil.SetValueForOption,
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_HUD",
            description = "TF_HUD_DESC",
            profileVarName = "hud",
            widgetType = "tfcheckbox",
            callbackGetValueForOption = CoD.PersonalizationUtil.GetValueForOption,
            callbackSetValueForOption = CoD.PersonalizationUtil.SetValueForOption,
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    table.insert(items, {
        models = {
            label = "TF_CUSTOM_HUD",
            description = "TF_CUSTOM_HUD_DESC",
            profileVarName = "custom_hud",
            widgetType = "tfcheckbox",
            callbackGetValueForOption = CoD.PersonalizationUtil.GetValueForOption,
            callbackSetValueForOption = setCustomHUD,
        },
        properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    })
    -- table.insert(f26_local0, {
    --     models = {
    --         label = "TF_THIRDPERSON",
    --         description = "TF_THIRDPERSON_DESC",
    --         profileVarName = "thirdperson",
    --         widgetType = "tfcheckbox",
    --         callbackGetValueForOption = CoD.PersonalizationUtil.GetValueForOption,
    --         callbackSetValueForOption = setThirdperson,
    --     },
    --     properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties
    -- })
    for _, option in ipairs(cameraOptions) do
        table.insert(items, {
            models = {
                label = "TF_" .. option.text,
                description = "TF_" .. option.text .. "_DESC",
                profileVarName = option.name,
                lowValue = option.min,
                highValue = option.max,
                widgetType = "slider",
                callbackGetValueForOption = CoD.PersonalizationUtil.GetValueForOption,
                callbackSetValueForOption = CoD.PersonalizationUtil.SetValueForOption,
            },
            properties = cameraSliderProperties
        })
    end
    return items
end, true)

DataSources.PersonalizationOptionsP1.getWidgetTypeForItem = function(list, model, row)
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
        elseif widgetType == "navbutton" then
            return CoD.TFOptions_NavButton
        end
    end
    return nil
end

DataSources.PersonalizationOptionCategories = DataSourceHelpers.ListSetup("PersonalizationOptionCategories", function(controller)
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
            tabName = "MPUI_STANDARD_CAPS",
            tabWidget = "CoD.PersonalizationOptions_P1"
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

LUI.createMenu.PersonalizationOptions = function(controller)
    local HudRef = CoD.Menu.NewForUIEditor("PersonalizationOptions")

    HudRef.soundSet = "ChooseDecal"
    HudRef:setOwner(controller)
    HudRef:setLeftRight(true, true, 0, 0)
    HudRef:setTopBottom(true, true, 0, 0)
    HudRef:playSound("menu_open", controller)
    HudRef.buttonModel = Engine.CreateModel(Engine.GetModelForController(controller), "PersonalizationOptions.buttonPrompts")
    local f31_local1 = HudRef
    HudRef.anyChildUsesUpdateState = true
    local background = LUI.UIImage.new()
    background:setLeftRight(true, false, 0, 1280)
    background:setTopBottom(true, false, 0, 720)
    background:setRGB(0, 0, 0)
    background:setAlpha(0.7);
    HudRef:addElement(background)
    HudRef.Background = background

    local title = Engine.Localize("GFL_MENU_PERSONALIZATION")
    local menuFrame = CoD.GenericMenuFrame.new(f31_local1, controller)
    menuFrame:setLeftRight(true, true, 0, 0)
    menuFrame:setTopBottom(true, true, 0, 0)
    menuFrame.titleLabel:setText(title)
    menuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(title)
    menuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon:setImage(RegisterImage(
        "uie_t7_mp_icon_header_option"))
    HudRef:addElement(menuFrame)
    HudRef.MenuFrame = menuFrame

    local categoryListLine = LUI.UIImage.new()
    categoryListLine:setLeftRight(true, false, 120, 576)
    categoryListLine:setTopBottom(true, false, 22, 76)
    categoryListLine:setRGB(0.9, 0.9, 0.9)
    -- f31_local4:setImage(RegisterImage("tfzoptions_title"))
    -- HudRef:addElement(f31_local4)
    HudRef.CategoryListLine = categoryListLine

    local startMenulineGraphicsOptions0 = CoD.StartMenu_lineGraphics_Options.new(f31_local1, controller)
    startMenulineGraphicsOptions0:setLeftRight(true, false, 1, 69)
    startMenulineGraphicsOptions0:setTopBottom(true, false, -13, 657)
    HudRef:addElement(startMenulineGraphicsOptions0)
    HudRef.StartMenulineGraphicsOptions0 = startMenulineGraphicsOptions0

    local categoryListLine0 = LUI.UIImage.new()
    categoryListLine0:setLeftRight(true, false, -11, 1293)
    categoryListLine0:setTopBottom(true, false, 80, 88)
    categoryListLine0:setRGB(0.9, 0.9, 0.9)
    categoryListLine0:setImage(RegisterImage("uie_t7_menu_cac_tabline"))
    HudRef:addElement(categoryListLine0)
    HudRef.CategoryListLine0 = categoryListLine0

    local tabs = CoD.basicTabList.new(f31_local1, controller)
    tabs:setLeftRight(true, false, 64, 1216)
    tabs:setTopBottom(true, false, 84, 124)
    tabs.grid:setDataSource("PersonalizationOptionCategories")
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

    HudRef:registerEventHandler("menu_opened", function(element, event)
        local f35_local0 = nil
        -- CoD.TFPCUtil.UnsetDirtyFlag()
        if not f35_local0 then
            f35_local0 = element:dispatchEventToChildren(event)
        end
        return f35_local0
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
            -- CoD.PersonalizationUtil.ApplyChangesInGame(f40_arg2)
            GoBack(HudRef, controller)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK")
            return true
        end, false)
    f31_local1:AddButtonCallbackFunction(HudRef, controller, Enum.LUIButton.LUI_KEY_START, "M",
        function(element, menu, controller, event)
            -- CoD.PersonalizationUtil.ApplyChangesInGame(f42_arg2)
            CloseStartMenu(menu, controller)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_START, "MENU_DISMISS_MENU")
            return true
        end, false)
    f31_local1:AddButtonCallbackFunction(HudRef, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "R",
        function(element, menu, controller, event)
            CoD.PersonalizationUtil.ResetToDefault()
            GoBack(HudRef, controller)
            return true
        end, function(element, menu, controller)
            CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "PLATFORM_RESET_TO_DEFAULT")
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
            "PersonalizationOptions.buttonPrompts"))
    end)
    if configureMouseInput then
        configureMouseInput(HudRef, controller)
    end

    return HudRef
end
