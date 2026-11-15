require("lua.Shared.LuaUtils")
require("ui.uieditor.modifyFunctions")

local version = 1

CoD.TFOptionIndexes = {
    temp = 0,
    max_ammo = 1,
    higher_health = 2,
    no_perk_lim = 3,
    more_powerups = 4,
    bigger_mule = 5,
    extra_cash = 6,
    weaker_zombs = 7,
    roamer_enabled = 8,
    roamer_time = 9,
    zcounter_enabled = 10,
    starting_round = 11,
    perkaholic = 12,
    exo_movement = 13,
    perk_powerup = 14,
    melee_bonus = 15,
    headshot_bonus = 16,
    zombs_always_sprint = 17,
    max_zombies = 18,
    no_delay = 19,
    start_rk5 = 20,
    hitmarkers = 21,
    zcash_powerup = 22,
    starting_points = 300,  -- unique case, needs to save to 3 values for values higher than 65k
    no_round_delay = 24,
    bo4_max_ammo = 25,
    better_nuke = 26,
    better_nuke_points = 27,
    packapunch_powerup = 28,
    spawn_with_quick_res = 29,
    bo4_carpenter = 30,
    bottomless_clip_powerup = 31,
    zblood_powerup = 32,
    timed_gameplay = 33,
    move_speed = 34,
    tf_enabled = 35,
    open_all_doors = 36,
    every_box = 37,
    random_weapon = 38,
    start_bowie = 39,
    start_power = 40,
    perkplus = 41,
    bot = 42,
    roundrevive = 43,
    randomize_character = 44,
    perk_lose = 45,
    bot_count = 46,
    boxshare = 47,
    bgb_loadout = 53,
    cheats = 54,
    fixed_cost = 55,
    bgb_cost = 56,
    bot_command = 57,
    modmenu = 58,
    player_determined_character = 59,
    disable_intro_movie = 60,
    bgb_uses = 61,
    friendlyfire = 62,
    tdoll_zombie = 63,
    bgb_off = 64,
    version = 65,
    subtitles = 66,
    cw_scoreevent = 67,
    thirdperson = 68,
    zombie_healthbar = 69,
    hud = 70,
    hitmarkers_sound = 71,
    objectives = 72,
    checkpoints = 73,
    bot_health = 74,
    mw3_intro = 75,
}

CoD.TFOptionsDefault = {
    starting_points = 500,
    max_ammo = 0,
    higher_health = 100,
    no_perk_lim = 1,
    more_powerups = 2,
    bigger_mule = 0,
    extra_cash = 0,
    weaker_zombs = 0,
    roamer_enabled = 0,
    roamer_time = 0,
    zcounter_enabled = 1,
    starting_round = 1,
    perkaholic = 0,
    exo_movement = 0,
    perk_powerup = 0,
    melee_bonus = 0,
    headshot_bonus = 0,
    zombs_always_sprint = 0,
    max_zombies = 24,
    no_delay = 0,
    start_rk5 = 0,
    hitmarkers = 1,
    zcash_powerup = 0,
    no_round_delay = 0,
    bo4_max_ammo = 1,
    better_nuke = 1,
    better_nuke_points = 100,
    packapunch_powerup = 0,
    spawn_with_quick_res = 0,
    bo4_carpenter = 1,
    bottomless_clip_powerup = 0,
    zblood_powerup = 0,
    timed_gameplay = 0,
    move_speed = 100,
    tf_enabled = 1,
    open_all_doors = 0,
    every_box = 0,
    random_weapon = 0,
    start_bowie = 0,
    start_power = 0,
    perkplus = 1,
    bot = 0,
    roundrevive = 1,
    randomize_character = 1,
    perk_lose = 1,
    bot_count = 1,
    boxshare = 1,
    bot_command = 0,
    bgb_loadout = 0,
    cheats = 0,
    fixed_cost = 0,
    bgb_cost = 1,
    modmenu = 0,
    player_determined_character = 1,
    disable_intro_movie = 1,
    bgb_uses = 0,
    friendlyfire = 0,
    tdoll_zombie = 0,
    bgb_off = 0,
    version = version,
    subtitles = 1,
    cw_scoreevent = 1,
    thirdperson = 0,
    zombie_healthbar = 1,
    hud = 1,
    hitmarkers_sound = 2,
    objectives = 0,
    checkpoints = 0,
    bot_health = 3,
    mw3_intro = 1,
}

CoD.TFOptionsDirtyFlag = false

if not CoD.TFPCUtil then
    CoD.TFPCUtil = {}
end
CoD.TFPCUtil.GetModelValues = function(model, modelNames)
    local values = {}
    if type(modelNames) == "string" then
        return CoD.SafeGetModelValue(model, modelNames)
    elseif type(modelNames) == "table" then
        for index, modelName in ipairs(modelNames) do
            values[modelName] = CoD.SafeGetModelValue(model, modelName)
        end
        return values
    end
    return nil
end

CoD.TFPCUtil.GetElementModelValues = function(element, modelNames)
    local model = element:getModel()
    if model then
        return CoD.TFPCUtil.GetModelValues(model, modelNames)
    else
        return nil
    end
end

CoD.TFPCUtil.TrimString = function(text)
    return string.gsub(text, "^%s*(.-)%s*$", "%1")
end

CoD.TFPCUtil.TokenizeString = function(text, separator)
    local tokens = {}
    local token = text
    local startIndex = 0
    local separatorIndex = string.find(text, separator)
    while separatorIndex do
        token = CoD.TFPCUtil.TrimString(string.sub(text, startIndex, separatorIndex - 1))
        if token ~= "" then
            table.insert(tokens, token)
        end
        startIndex = separatorIndex + 1
        separatorIndex = string.find(text, separator, startIndex)
    end
    token = CoD.TFPCUtil.TrimString(string.sub(text, startIndex, string.len(text)))
    if token ~= "" then
        table.insert(tokens, token)
    end
    return tokens
end

CoD.TFPCUtil.GetVersion = function()
    return version
end

CoD.TFPCUtil.GetFromSaveData = function(varName, controller)
    if varName ~= "starting_points" then
        local index = CoD.TFOptionIndexes[varName]
        index = (index * 2) + 50
        local multiple = CoD.SavingDataUtility.GetData(controller, index)
        local remainder = CoD.SavingDataUtility.GetData(controller, index + 1)
        local result = (255 * multiple) + remainder

        return result
    else
        local index = CoD.TFOptionIndexes[varName]
        index = (index * 2) + 50
        local multof65025 = CoD.SavingDataUtility.GetData(controller, index)
        local multof255 = CoD.SavingDataUtility.GetData(controller, index + 1)
        local remainder = CoD.SavingDataUtility.GetData(controller, index + 2)
        local result = (65025 * multof65025) + (255 * multof255) + remainder

        return result
    end
end

CoD.TFPCUtil.LoadFromSaveData = function(varName, controller)
    local result = CoD.TFPCUtil.GetFromSaveData(varName, controller)
    Engine.SetDvar("tfoption_" .. varName, result)
end

CoD.TFPCUtil.SetToSaveData = function(varName, value, controller)
    Engine.SetDvar("tfoption_" .. varName, value)

    if varName ~= "starting_points" then
        local index = CoD.TFOptionIndexes[varName]
        index = (index * 2) + 50

        local remainder = value % 255
        local multiple = math.floor(value / 255)
        CoD.SavingDataUtility.SaveData(controller, index, multiple)
        CoD.SavingDataUtility.SaveData(controller, index + 1, remainder)
    else
        local index = CoD.TFOptionIndexes[varName]
        index = (index * 2) + 50

        local multof65025 = math.floor(value / 65025)
        local multof255 = math.floor((value % 65025) / 255)
        local remainder = value % 255;

        CoD.SavingDataUtility.SaveData(controller, index, multof65025)
        CoD.SavingDataUtility.SaveData(controller, index + 1, multof255)
        CoD.SavingDataUtility.SaveData(controller, index + 2, remainder)
    end
end

CoD.TFPCUtil.SetToJSON = function(varName, value)
    if not CoD.TFPCUtil.IsOptionExisted(varName) then
        return
    end

    local converted = tonumber(value)
    if not converted then
        converted = CoD.TFOptionsDefault[varName]
    end
    Engine.SetDvar("tfoption_" .. varName, converted)
    CoD.DataUtil.SaveItem(CoD.SavingDataModes.TFOptions, varName, converted)
end

CoD.TFPCUtil.GetFromJSON = function(varName)
    local result = CoD.DataUtil.GetItem(CoD.SavingDataModes.TFOptions, varName)
    if varName ~= "version" then
        if result == nil then
            result = CoD.TFOptionsDefault[varName]
        end
    
        if result == nil then
            result = 0
        end
    end
    
    return result
end

CoD.TFPCUtil.LoadFromJSON = function(varName)
    local result = CoD.TFPCUtil.GetFromJSON(varName)
    Engine.SetDvar("tfoption_" .. varName, result)
end

CoD.TFPCUtil.CheckForRecentUpdate = function()
    if UseOldSaveData() then
        local index = CoD.TFOptionIndexes["version"]
        index = (index * 2) + 50
        local multiple = CoD.SavingDataUtility.GetData(InstanceRef, index)
        local remainder = CoD.SavingDataUtility.GetData(InstanceRef, index + 1)
        local result = (255 * multiple) + remainder

        if result ~= CoD.TFPCUtil.GetVersion() then
            CoD.TFPCUtil.ResetToDefault()
            return true
        end
        return false
    end

    local result = CoD.TFPCUtil.GetFromJSON("version")
    if not result or result ~= CoD.TFPCUtil.GetVersion() then
        CoD.TFPCUtil.ResetToDefault()
        return true
    end
    return false
end

CoD.TFPCUtil.ResetToDefault = function()
    if UseOldSaveData() then
        for varName, value in pairs(CoD.TFOptionsDefault) do
            CoD.TFPCUtil.SetToSaveData(varName, value, 0)
        end
        return
    end

    CoD.DataUtil.SaveJSON(CoD.SavingDataModes.TFOptions, CoD.TFOptionsDefault)
    for varName, value in pairs(CoD.TFOptionsDefault) do
        if value then
            Engine.SetDvar("tfoption_" .. varName, value)
        end
    end
end

CoD.TFPCUtil.LoadTFOptions = function()
    if UseOldSaveData() then
        for varName, value in pairs(CoD.TFOptionsDefault) do
            CoD.TFPCUtil.LoadFromSaveData(varName)
        end
        return
    end

    local table = CoD.DataUtil.LoadJSON(CoD.SavingDataModes.TFOptions)
    for varName, _ in pairs(CoD.TFOptionsDefault) do
        local value = table[varName]
        if value then
            local converted = tonumber(value)
            if converted then
                Engine.SetDvar("tfoption_" .. varName, converted)
            end
        end
    end
end

CoD.TFPCUtil.IsOptionExisted = function(varName)
    if CoD.TFOptionsDefault and CoD.TFOptionsDefault[varName] then
        return true
    end

    return false
end

CoD.TFPCUtil.CheckBoxOptionChecked = function(itemRef, updateTable)
    local controller = nil
    if updateTable.menu then
        controller = updateTable.menu.m_ownerController
    else
        controller = updateTable.controller
    end
    local itemRefModel = itemRef:getModel()
    if itemRefModel then
        local result = CoD.TFPCUtil.GetOptionInfo(itemRefModel, controller)
        if type(result.currentValue) == "number" then
            return math.abs(result.currentValue - result.highValue) < 0.01
        elseif type(result.currentValue) == "string" then
            return result.currentValue == result.highValue
        end
    end
    return false
end

CoD.TFPCUtil.GetValueForOption = function(varNameString)
    local curVal = 0
    if UseOldSaveData() then
        curVal = tonumber(CoD.TFPCUtil.GetFromSaveData(varNameString))
    else
        curVal = CoD.TFPCUtil.GetFromJSON(varNameString)
    end

    return curVal
end

CoD.TFPCUtil.GetOptionInfo = function(itemRef, controller)
    if itemRef then
        local result = {}

        local varNameModel = Engine.GetModel(itemRef, "profileVarName")
        if varNameModel then
            local varNameString = Engine.GetModelValue(varNameModel)
            local isUserProfile = false
            local profileTypeModel = Engine.GetModel(itemRef, "profileType")
            if profileTypeModel then
                local profileType = Engine.GetModelValue(profileTypeModel)
                local profileValue = nil
                if profileType == "user" then
                    profileValue = Engine.ProfileValueAsString(controller, varNameString)

                    isUserProfile = true
                elseif profileType == "function" then
                    profileValue = "errorValueString"
                    local getFunctionModel = Engine.GetModel(itemRef, "getFunction")
                    if getFunctionModel then
                        local optionController = controller
                        local optionControllerModel = Engine.GetModel(itemRef, "optionController")
                        if optionControllerModel then
                            optionController = Engine.GetModelValue(optionControllerModel)
                        end
                        result.getValueFunction = Engine.GetModelValue(getFunctionModel)
                        profileValue = result.getValueFunction(optionController)
                    end
                else
                    profileValue = Engine.GetHardwareProfileValueAsString(varNameString)

                end
                result.currentValue = tonumber(profileValue)
                if not result.currentValue then
                    result.currentValue = profileValue
                end
                result.profileType = profileType
            else
                local getValModel = Engine.GetModel(itemRef, "callbackGetValueForOption")
                local callbackGetValue = CoD.TFPCUtil.GetValueForOption
                if getValModel then
                    callbackGetValue = Engine.GetModelValue(getValModel)
                end
                local curVal = callbackGetValue(varNameString)
                result.currentValue = curVal

                if not result.currentValue then
                    result.currentValue = 0
                end
            end
            result.profileVarName = varNameString
            local lowValueModel = Engine.GetModel(itemRef, "lowValue")
            local highValueModel = Engine.GetModel(itemRef, "highValue")
            if lowValueModel and highValueModel then
                result.lowValue = Engine.GetModelValue(lowValueModel)
                result.highValue = Engine.GetModelValue(highValueModel)
            elseif isUserProfile then
                result.lowValue = 0
                result.highValue = 1
            else
                local f6_local7, f6_local8 = Dvar["r_sssblurEnable"]:getDomain()
                result.lowValue = 0
                result.highValue = 1
            end
            if Engine.GetModel(itemRef, "useIntegerDisplay") then
                result.useIntegerDisplay = 1
            else
                result.useIntegerDisplay = 0
            end
            if Engine.GetModel(itemRef, "useMultipleOf10Display") then
                result.useMultipleOf10Display = 1
            else
                result.useMultipleOf10Display = 0
            end
            if Engine.GetModel(itemRef, "useMultipleOf100Display") then
                result.useMultipleOf100Display = 1
            else
                result.useMultipleOf100Display = 0
            end

            if Engine.GetModel(itemRef, "isFloat") then
                result.isFloat = 1
                result.currentValue = result.currentValue / 100;
            else
                result.isFloat = 0
            end

            local widgetTypeModel = Engine.GetModel(itemRef, "widgetType")
            if widgetTypeModel then
                local widgetType = Engine.GetModelValue(widgetTypeModel)
                if widgetType == "slider" then
                    local sliderSpeedModel = Engine.GetModel(itemRef, "sliderSpeed")
                    if sliderSpeedModel then
                        result.sliderSpeed = Engine.GetModelValue(sliderSpeedModel)
                    else
                        local valueRange = result.highValue - result.lowValue
                        if result.useIntegerDisplay == 1 then
                            result.sliderSpeed = 10 / valueRange
                        elseif result.useMultipleOf10Display == 1 then
                            result.sliderSpeed = 100 / valueRange
                        elseif result.useMultipleOf100Display == 1 then
                            result.sliderSpeed = 1000 / valueRange
                        else
                            result.sliderSpeed = 0.1 / valueRange
                        end
                    end
                end
                result.widgetType = widgetType
            end
            local getLabelFnModel = Engine.GetModel(itemRef, "getLabelFn")
            if getLabelFnModel then
                result.getLabelFn = Engine.GetModelValue(getLabelFnModel)
            end
            local chatChannelModel = Engine.GetModel(itemRef, "chatChannel")
            if chatChannelModel then
                result.chatChannel = Engine.GetModelValue(chatChannelModel)
                if 0 < Engine.ChatClient_FilterChannelGet(controller, result.chatChannel) then
                    result.currentValue = 1
                else
                    result.currentValue = 0
                end
            end
            return result
        end
    end
    return nil
end

CoD.TFPCUtil.SetValueForOption = function(varNameString, newValue)
    if UseOldSaveData() then
        CoD.TFPCUtil.SetToSaveData(varNameString, newValue, 0)
    else
        CoD.TFPCUtil.SetToJSON(varNameString, newValue)
    end
end

CoD.TFPCUtil.SetOptionValue = function(itemRef, controller, newValue)
    if itemRef then

        local varNameModel = Engine.GetModel(itemRef, "profileVarName")
        if varNameModel then
            local varNameString = Engine.GetModelValue(varNameModel)
            local profileTypeModel = Engine.GetModel(itemRef, "profileType")
            if profileTypeModel then
                local profileType = Engine.GetModelValue(profileTypeModel)
                if profileType == "user" then
                    Engine.SetProfileVar(controller, varNameString, newValue)
                elseif profileType == "function" then
                    local setFunctionModel = Engine.GetModel(itemRef, "setFunction")
                    if setFunctionModel then
                        local optionController = controller
                        local optionControllerModel = Engine.GetModel(itemRef, "optionController")
                        if optionControllerModel then
                            optionController = Engine.GetModelValue(optionControllerModel)
                        end
                        local setFunction = Engine.GetModelValue(setFunctionModel)
                        setFunction(optionController, newValue)
                    end
                else
                    Engine.SetHardwareProfileValue(varNameString, newValue)
                end
            else
                local setValModel = Engine.GetModel(itemRef, "callbackSetValueForOption")
                local callbackSetValue = CoD.TFPCUtil.SetValueForOption
                if setValModel then
                    callbackSetValue = Engine.GetModelValue(setValModel)
                end

                callbackSetValue(varNameString, newValue)

                local callbackForController = Engine.GetModel(itemRef, "callbackForController")
                if callbackForController and type(callbackForController) == "function" then
                    callbackForController(itemRef, varNameString, newValue)
                end
            end
            CoD.TFPCUtil.DirtyOptions(controller)
        end
    end
end

CoD.TFPCUtil.GetDirtyFlag = function()
    if CoD.TFOptionsDirtyFlag then
        return true
    end

    return false
end

CoD.TFPCUtil.SetDirtyFlag = function()
    CoD.TFOptionsDirtyFlag = true
end

CoD.TFPCUtil.UnsetDirtyFlag = function()
    CoD.TFOptionsDirtyFlag = false
end

CoD.TFPCUtil.ApplyChangesInGame = function(controller)
    if CoD.isFrontend then
        return
    end

    if not CoD.TFPCUtil.GetDirtyFlag then
        return
    end

    Engine.SendMenuResponse(controller, "popup_leavegame", "TFOptionsChanged")
end

CoD.TFPCUtil.GetOptionsDirtyModel = function(controller, createIfMissing)
    local optionsDirtyModel = Engine.GetModel(Engine.GetModelForController(controller), "PC.OptionsDirty")
    if not optionsDirtyModel and createIfMissing then
        optionsDirtyModel = Engine.CreateModel(Engine.GetModelForController(controller), "PC.OptionsDirty")
    end
    return optionsDirtyModel
end

CoD.TFPCUtil.FreeOptionsDirtyModel = function(controller)
    local optionsDirtyModel = CoD.TFPCUtil.GetOptionsDirtyModel(controller)
    if optionsDirtyModel then
        Engine.UnsubscribeAndFreeModel(optionsDirtyModel)
    end
end

CoD.TFPCUtil.DirtyOptions = function(controller)
    Engine.SetModelValue(CoD.TFPCUtil.GetOptionsDirtyModel(controller, true), 1)
    CoD.TFPCUtil.SetDirtyFlag()
end

CoD.TFPCUtil.IsOptionsDirty = function(controller)
    local optionsDirtyModel = CoD.TFPCUtil.GetOptionsDirtyModel(controller)
    if optionsDirtyModel then
        return Engine.GetModelValue(optionsDirtyModel) ~= 0
    else
        return false
    end
end

CoD.TFPCUtil.RefreshAllOptions = function(element, controller)
    element:dispatchEventToRoot({
        name = "options_refresh",
        controller = controller
    })
end

CoD.TFPCUtil.SimulateButtonPress = function(controller, button)
    local model = Engine.GetModel(Engine.GetModelForController(controller), "ButtonBits." .. button)
    if model then
        Engine.SetModelValue(model, Enum.LUIButtonFlags.FLAG_DOWN)
    end
end

CoD.TFPCUtil.SimulateButtonPressUsingElement = function(controller, element)
    local model = element:getModel()
    if model then
        local buttonModel = Engine.GetModel(model, "Button")
        if buttonModel then
            CoD.TFPCUtil.SimulateButtonPress(controller, Engine.GetModelValue(buttonModel))
        end
    end
end

CoD.TFPCUtil.OptionsCheckboxAction = function(controller, checkbox)
    local checkboxModel = checkbox:getModel()
    if checkboxModel then
        local result = CoD.TFPCUtil.GetOptionInfo(checkboxModel, controller)

        if result then
            local newValue = nil
            local isAlreadyOff = false
            if type(result.currentValue) == "number" then
                isAlreadyOff = math.abs(result.currentValue - result.lowValue) < 0.01
            elseif type(result.currentValue) == "string" then
                isAlreadyOff = result.currentValue == result.lowValue
            end
            if isAlreadyOff then
                newValue = result.highValue
            else
                newValue = result.lowValue
            end
            CoD.TFPCUtil.SetOptionValue(checkboxModel, controller, newValue)
            checkbox:playSound("list_action")
            return newValue
        end
    end
    return false
end

CoD.TFPCUtil.OptionsChatClientChannelFilterCheckboxProperties = function(controller, element)
    local model = element:getModel()
    if model then
        local optionInfo = CoD.TFPCUtil.GetOptionInfo(model, controller)
        if optionInfo then
            local newValue = nil
            if optionInfo.currentValue == optionInfo.lowValue then
                newValue = optionInfo.highValue
            else
                newValue = optionInfo.lowValue
            end
            Engine.ChatClient_FilterChannelSet(controller, optionInfo.chatChannel, 0 < newValue)
            CoD.TFPCUtil.SetOptionValue(model, controller, Engine.ChatClient_FilterChannelGet(controller,
                Enum.chatChannel_e.CHAT_CHANNEL_COUNT))
            return newValue
        end
    end
    return false
end

CoD.TFPCUtil.OptionsNavNuttonAction = function(var, itemRef, varA, varB)
    itemRef:playSound("list_action")
    local itemModel = itemRef:getModel()
    if itemModel then
        CoD.TFPCUtil.NavigateToPage(itemModel, varA, varB)
    end

end

CoD.TFPCUtil.NavigateToPage = function(itemRef, varA, varB)
    local pageModel = Engine.GetModel(itemRef, "page")
    if pageModel then
        local newPageString = Engine.GetModelValue(pageModel)

        OpenPopup_NoDependency(varA, newPageString, varB)
    end
end

CoD.TFPCUtil.OptionsNavButtonProperties = {
    navAction = CoD.TFPCUtil.OptionsNavNuttonAction
}

CoD.TFPCUtil.OptionsUrlButtonAction = function(var, itemRef, varA, varB)
    itemRef:playSound("list_action")
    local itemModel = itemRef:getModel()
    if itemModel then
        local urlModel = Engine.GetModel(itemModel, "url")
        if urlModel then
            local urlString = Engine.GetModelValue(urlModel)
            if urlString == "" then
                return
            end
            Engine.OpenURL(urlString)
        end
    end
end

CoD.TFPCUtil.OptionsUrlButtonProperties = {
    navAction = CoD.TFPCUtil.OptionsUrlButtonAction
}

CoD.TFPCUtil.OptionsEmptyButtonAction = function(var, itemRef, varA, varB)

end

CoD.TFPCUtil.OptionsEmptyButtonProperties = {
    navAction = CoD.TFPCUtil.OptionsEmptyButtonAction
}

CoD.TFPCUtil.OptionsGenericCheckboxProperties = {
    checkboxAction = CoD.TFPCUtil.OptionsCheckboxAction
}
CoD.TFPCUtil.OptionsChatClientChannelFilterCheckboxProperties = {
    checkboxAction = CoD.TFPCUtil.OptionsChatClientChannelFilterCheckboxProperties
}
CoD.TFPCUtil.OptionsDropdownItemSelected = function(controller, dropdown, selectedItem)
    local valueDisplay = ""
    local model = selectedItem:getModel()
    if model then
        local valueDisplayModel = Engine.GetModel(model, "valueDisplay")
        if valueDisplayModel then
            valueDisplay = Engine.GetModelValue(valueDisplayModel)
        end
        local value = nil
        local valueModel = Engine.GetModel(model, "value")
        if valueModel then
            value = Engine.GetModelValue(valueModel)
        end
        CoD.TFPCUtil.SetOptionValue(dropdown:getModel(), controller, value)
        dropdown:playSound("list_action")
    end
    return valueDisplay
end

CoD.TFPCUtil.OptionsDropdownRefresh = function(controller, dropdown, list)
    local valueDisplay = ""
    local model = dropdown:getModel()
    if model then
        local optionInfo = CoD.TFPCUtil.GetOptionInfo(model, controller)
        if optionInfo then
            local profileVarName = optionInfo.profileVarName
            local model2, f19_local5 = false
            local item = list:findItem({
                value = optionInfo.currentValue
            }, nil, model2, f19_local5)
            local usedFallbackItem = false
            if not item then
                item = list:getFirstSelectableItem()
                usedFallbackItem = true
            end
            if item then
                local model3 = item:getModel()
                if model3 then
                    local valueDisplayModel = Engine.GetModel(model3, "valueDisplay")
                    if valueDisplayModel then
                        valueDisplay = Engine.GetModelValue(valueDisplayModel)
                    end
                    if usedFallbackItem then
                        model2 = Engine.GetModel(model3, "value")
                        if model2 then
                            CoD.TFPCUtil.SetOptionValue(model, controller, Engine.GetModelValue(model2))
                        end
                    end
                end
            end
        end
    end
    return valueDisplay
end

CoD.TFPCUtil.OptionsDropdownCurrentValue = function(controller, dropdown)
    local model = dropdown:getModel()
    if model then
        local optionInfo = CoD.TFPCUtil.GetOptionInfo(model, controller)
        return optionInfo.currentValue
    else

    end
end

CoD.TFPCUtil.OptionsGenericDropdownProperties = {
    dropDownItemSelected = CoD.TFPCUtil.OptionsDropdownItemSelected,
    dropDownRefresh = CoD.TFPCUtil.OptionsDropdownRefresh,
    dropDownCurrentValue = CoD.TFPCUtil.OptionsDropdownCurrentValue
}
CoD.TFPCUtil.DependantDropdownProperties = {
    dropDownItemSelected = function(controller, f21_arg1, selectedItem)
        CoD.TFPCUtil.RefreshAllOptions(f21_arg1, controller)
        return CoD.TFPCUtil.OptionsDropdownItemSelected(controller, f21_arg1, selectedItem)
    end,
    dropDownRefresh = CoD.TFPCUtil.OptionsDropdownRefresh,
    dropDownCurrentValue = CoD.TFPCUtil.OptionsDropdownCurrentValue
}
CoD.TFPCUtil.ShadowOptionIndex = 0
CoD.TFPCUtil.ShadowDropdownItemSelected = function(controller, dropdown, selectedItem)
    local valueDisplay = ""
    local optionValues = CoD.TFPCUtil.GetModelValues(selectedItem:getModel(), {"value", "valueDisplay"})
    if optionValues then
        valueDisplay = optionValues.valueDisplay
        CoD.TFPCUtil.ShadowOptionIndex = optionValues.value
        CoD.TFPCUtil.DirtyOptions(controller)
        dropdown:playSound("list_action")
    end
    return valueDisplay
end

CoD.TFPCUtil.ShadowDropdownRefresh = function(controller, dropdown, list)
    local valueDisplay = ""
    local f23_local1, f23_local2 = false
    local item = list:findItem({
        value = CoD.TFPCUtil.ShadowOptionIndex
    }, nil, f23_local1, f23_local2)
    local usedFallbackItem = false
    if not item then
        item = list:getFirstSelectableItem()
        usedFallbackItem = true
    end
    if item then
        local optionValues = CoD.TFPCUtil.GetModelValues(item:getModel(), {"value", "valueDisplay"})
        valueDisplay = optionValues.valueDisplay
        if usedFallbackItem then
            CoD.TFPCUtil.ShadowOptionIndex = optionValues.value
            CoD.TFPCUtil.DirtyOptions(controller)
        end
    end
    return valueDisplay
end

CoD.TFPCUtil.ShadowDropdownCurrentValue = function(controller, dropdown)
    return CoD.TFPCUtil.ShadowOptionIndex
end

CoD.TFPCUtil.ShadowDropdownProperties = {
    dropDownItemSelected = CoD.TFPCUtil.ShadowDropdownItemSelected,
    dropDownRefresh = CoD.TFPCUtil.ShadowDropdownRefresh,
    dropDownCurrentValue = CoD.TFPCUtil.ShadowDropdownCurrentValue
}
CoD.TFPCUtil.VolumetricOptionIndex = 0
CoD.TFPCUtil.VolumetricDropdownItemSelected = function(controller, dropdown, selectedItem)
    local valueDisplay = ""
    local optionValues = CoD.TFPCUtil.GetModelValues(selectedItem:getModel(), {"value", "valueDisplay"})
    if optionValues then
        valueDisplay = optionValues.valueDisplay
        CoD.TFPCUtil.VolumetricOptionIndex = optionValues.value
        CoD.TFPCUtil.DirtyOptions(controller)
        dropdown:playSound("list_action")
    end
    return valueDisplay
end

CoD.TFPCUtil.VolumetricDropdownRefresh = function(controller, dropdown, list)
    local valueDisplay = ""
    local f26_local1, f26_local2 = false
    local item = list:findItem({
        value = CoD.TFPCUtil.VolumetricOptionIndex
    }, nil, f26_local1, f26_local2)
    local usedFallbackItem = false
    if not item then
        item = list:getFirstSelectableItem()
        usedFallbackItem = true
    end
    if item then
        local optionValues = CoD.TFPCUtil.GetModelValues(item:getModel(), {"value", "valueDisplay"})
        valueDisplay = optionValues.valueDisplay
        if usedFallbackItem then
            CoD.TFPCUtil.VolumetricOptionIndex = optionValues.value
            CoD.TFPCUtil.DirtyOptions(controller)
        end
    end
    return valueDisplay
end

CoD.TFPCUtil.VolumetricDropdownCurrentValue = function(controller, dropdown)
    return CoD.TFPCUtil.VolumetricOptionIndex
end

CoD.TFPCUtil.VolumetricDropdownProperties = {
    dropDownItemSelected = CoD.TFPCUtil.VolumetricDropdownItemSelected,
    dropDownRefresh = CoD.TFPCUtil.VolumetricDropdownRefresh,
    dropDownCurrentValue = CoD.TFPCUtil.VolumetricDropdownCurrentValue
}
CoD.TFPCUtil.SaveCurrentGraphicsOptions = function()
    CoD.TFPCUtil.SavedVolumetricOptionIndex = CoD.TFPCUtil.VolumetricOptionIndex
end

CoD.TFPCUtil.RevertUnsavedGraphicsOptions = function()
    CoD.TFPCUtil.VolumetricOptionIndex = CoD.TFPCUtil.SavedVolumetricOptionIndex
    Engine.SetVolumetricQuality(CoD.TFPCUtil.VolumetricOptionIndex)
end

CoD.TFPCUtil.OptionsSliderRefresh = function(controller, element)
    local itemRef = element:getModel()
    if itemRef then
        local sliderInfo = CoD.TFPCUtil.GetOptionInfo(itemRef, controller)
        if sliderInfo then
            if sliderInfo.useIntegerDisplay == 1 then
                element.m_formatString = "%u"
            end
            if sliderInfo.useMultipleOf10Display == 1 then
                element.m_formatString = "%u"
            end
            if sliderInfo.useMultipleOf100Display == 1 then
                element.m_formatString = "%u"
            end
            local fraction = (sliderInfo.currentValue - sliderInfo.lowValue) /
                                   (sliderInfo.highValue - sliderInfo.lowValue)
            if fraction < 0 then
                fraction = 0
            end
            if 1 < fraction then
                fraction = 1
            end
            element.m_fraction = fraction
            element.m_currentValue = sliderInfo.currentValue
            element.m_sliderSpeed = sliderInfo.sliderSpeed
            element.m_range = sliderInfo.highValue - sliderInfo.lowValue
        end
    end
end

CoD.TFPCUtil.OptionsSliderUpdated = function(controller, element, fraction)
    local itemRef = element:getModel()
    if itemRef then
        local sliderInfo = CoD.TFPCUtil.GetOptionInfo(itemRef, controller)
        local newValue = string.format(element.m_formatString,
            (sliderInfo.highValue - sliderInfo.lowValue) * fraction + sliderInfo.lowValue)
        if sliderInfo.useMultipleOf10Display == 1 then
            newValue = string.format("%u0", tonumber(newValue) / 10)
        end
        if sliderInfo.useMultipleOf100Display == 1 then
            newValue = string.format("%u00", tonumber(newValue) / 100)
        end
        if sliderInfo.isFloat == 1 then
            CoD.TFPCUtil.SetOptionValue(itemRef, controller, newValue * 100)
        else
            CoD.TFPCUtil.SetOptionValue(itemRef, controller, newValue)
        end
        element.m_currentValue = newValue
        element.m_fraction = fraction
        element.m_sliderSpeed = sliderInfo.sliderSpeed
        element.m_range = sliderInfo.highValue - sliderInfo.lowValue
    end
end

CoD.TFPCUtil.OptionsGenericSliderProperties = {
    sliderRefresh = CoD.TFPCUtil.OptionsSliderRefresh,
    sliderUpdated = CoD.TFPCUtil.OptionsSliderUpdated
}
