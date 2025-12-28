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
    objectives = 1,
    checkpoints = 0,
    bot_health = 3,
}

CoD.TFOptionsDirtyFlag = false

if not CoD.TFPCUtil then
    CoD.TFPCUtil = {}
end
CoD.TFPCUtil.GetModelValues = function(f1_arg0, f1_arg1)
    local f1_local0 = {}
    if type(f1_arg1) == "string" then
        return CoD.SafeGetModelValue(f1_arg0, f1_arg1)
    elseif type(f1_arg1) == "table" then
        for f1_local4, f1_local5 in ipairs(f1_arg1) do
            f1_local0[f1_local5] = CoD.SafeGetModelValue(f1_arg0, f1_local5)
        end
        return f1_local0
    end
    return nil
end

CoD.TFPCUtil.GetElementModelValues = function(f2_arg0, f2_arg1)
    local f2_local0 = f2_arg0:getModel()
    if f2_local0 then
        return CoD.TFPCUtil.GetModelValues(f2_local0, f2_arg1)
    else
        return nil
    end
end

CoD.TFPCUtil.TrimString = function(f3_arg0)
    return string.gsub(f3_arg0, "^%s*(.-)%s*$", "%1")
end

CoD.TFPCUtil.TokenizeString = function(f4_arg0, f4_arg1)
    local f4_local0 = {}
    local f4_local1 = f4_arg0
    local f4_local2 = 0
    local f4_local3 = string.find(f4_arg0, f4_arg1)
    while f4_local3 do
        f4_local1 = CoD.TFPCUtil.TrimString(string.sub(f4_arg0, f4_local2, f4_local3 - 1))
        if f4_local1 ~= "" then
            table.insert(f4_local0, f4_local1)
        end
        f4_local2 = f4_local3 + 1
        f4_local3 = string.find(f4_arg0, f4_arg1, f4_local2)
    end
    f4_local1 = CoD.TFPCUtil.TrimString(string.sub(f4_arg0, f4_local2, string.len(f4_arg0)))
    if f4_local1 ~= "" then
        table.insert(f4_local0, f4_local1)
    end
    return f4_local0
end

CoD.TFPCUtil.GetVersion = function()
    return version
end

CoD.TFPCUtil.GetFromSaveData = function(varName, InstanceRef)
    if varName ~= "starting_points" then
        local index = CoD.TFOptionIndexes[varName]
        index = (index * 2) + 50
        local multiple = CoD.SavingDataUtility.GetData(InstanceRef, index)
        local remainder = CoD.SavingDataUtility.GetData(InstanceRef, index + 1)
        local result = (255 * multiple) + remainder

        return result
    else
        local index = CoD.TFOptionIndexes[varName]
        index = (index * 2) + 50
        local multof65025 = CoD.SavingDataUtility.GetData(InstanceRef, index)
        local multof255 = CoD.SavingDataUtility.GetData(InstanceRef, index + 1)
        local remainder = CoD.SavingDataUtility.GetData(InstanceRef, index + 2)
        local result = (65025 * multof65025) + (255 * multof255) + remainder

        return result
    end
end

CoD.TFPCUtil.LoadFromSaveData = function(varName, InstanceRef)
    local result = CoD.TFPCUtil.GetFromSaveData(varName, InstanceRef)
    Engine.SetDvar("tfoption_" .. varName, result)
end

CoD.TFPCUtil.SetToSaveData = function(varName, value, InstanceRef)
    Engine.SetDvar("tfoption_" .. varName, value)

    if varName ~= "starting_points" then
        local index = CoD.TFOptionIndexes[varName]
        index = (index * 2) + 50

        local remainder = value % 255
        local multiple = math.floor(value / 255)
        CoD.SavingDataUtility.SaveData(InstanceRef, index, multiple)
        CoD.SavingDataUtility.SaveData(InstanceRef, index + 1, remainder)
    else
        local index = CoD.TFOptionIndexes[varName]
        index = (index * 2) + 50

        local multof65025 = math.floor(value / 65025)
        local multof255 = math.floor((value % 65025) / 255)
        local remainder = value % 255;

        CoD.SavingDataUtility.SaveData(InstanceRef, index, multof65025)
        CoD.SavingDataUtility.SaveData(InstanceRef, index + 1, multof255)
        CoD.SavingDataUtility.SaveData(InstanceRef, index + 2, remainder)
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
    local f914_local0 = nil
    if updateTable.menu then
        f914_local0 = updateTable.menu.m_ownerController
    else
        f914_local0 = updateTable.controller
    end
    local itemRefModel = itemRef:getModel()
    if itemRefModel then
        local result = CoD.TFPCUtil.GetOptionInfo(itemRefModel, f914_local0)
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

CoD.TFPCUtil.GetOptionInfo = function(itemRef, f6_arg1)
    if itemRef then
        local result = {}

        local varNameModel = Engine.GetModel(itemRef, "profileVarName")
        if varNameModel then
            local varNameString = Engine.GetModelValue(varNameModel)
            local f6_local3 = false
            local f6_local4 = Engine.GetModel(itemRef, "profileType")
            if f6_local4 then
                local f6_local5 = Engine.GetModelValue(f6_local4)
                local f6_local6 = nil
                if f6_local5 == "user" then
                    f6_local6 = Engine.ProfileValueAsString(f6_arg1, varNameString)

                    f6_local3 = true
                elseif f6_local5 == "function" then
                    f6_local6 = "errorValueString"
                    local f6_local7 = Engine.GetModel(itemRef, "getFunction")
                    if f6_local7 then
                        local f6_local8 = f6_arg1
                        local f6_local9 = Engine.GetModel(itemRef, "optionController")
                        if f6_local9 then
                            f6_local8 = Engine.GetModelValue(f6_local9)
                        end
                        result.getValueFunction = Engine.GetModelValue(f6_local7)
                        f6_local6 = result.getValueFunction(f6_local8)
                    end
                else
                    f6_local6 = Engine.GetHardwareProfileValueAsString(varNameString)

                end
                result.currentValue = tonumber(f6_local6)
                if not result.currentValue then
                    result.currentValue = f6_local6
                end
                result.profileType = f6_local5
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
            local f6_local5 = Engine.GetModel(itemRef, "lowValue")
            local f6_local6 = Engine.GetModel(itemRef, "highValue")
            if f6_local5 and f6_local6 then
                result.lowValue = Engine.GetModelValue(f6_local5)
                result.highValue = Engine.GetModelValue(f6_local6)
            elseif f6_local3 then
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

            local f6_local8 = Engine.GetModel(itemRef, "widgetType")
            if f6_local8 then
                local f6_local9 = Engine.GetModelValue(f6_local8)
                if f6_local9 == "slider" then
                    local f6_local10 = Engine.GetModel(itemRef, "sliderSpeed")
                    if f6_local10 then
                        result.sliderSpeed = Engine.GetModelValue(f6_local10)
                    else
                        local f6_local11 = result.highValue - result.lowValue
                        if result.useIntegerDisplay == 1 then
                            result.sliderSpeed = 10 / f6_local11
                        elseif result.useMultipleOf10Display == 1 then
                            result.sliderSpeed = 100 / f6_local11
                        elseif result.useMultipleOf100Display == 1 then
                            result.sliderSpeed = 1000 / f6_local11
                        else
                            result.sliderSpeed = 0.1 / f6_local11
                        end
                    end
                end
                result.widgetType = f6_local9
            end
            local f6_local9 = Engine.GetModel(itemRef, "getLabelFn")
            if f6_local9 then
                result.getLabelFn = Engine.GetModelValue(f6_local9)
            end
            local f6_local10 = Engine.GetModel(itemRef, "chatChannel")
            if f6_local10 then
                result.chatChannel = Engine.GetModelValue(f6_local10)
                if 0 < Engine.ChatClient_FilterChannelGet(f6_arg1, result.chatChannel) then
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

CoD.TFPCUtil.SetOptionValue = function(itemRef, f7_arg1, newValue)
    if itemRef then

        local varNameModel = Engine.GetModel(itemRef, "profileVarName")
        if varNameModel then
            local varNameString = Engine.GetModelValue(varNameModel)
            local profileTypeModel = Engine.GetModel(itemRef, "profileType")
            if profileTypeModel then
                local profileType = Engine.GetModelValue(profileTypeModel)
                if profileType == "user" then
                    Engine.SetProfileVar(f7_arg1, varNameString, newValue)
                elseif profileType == "function" then
                    local f7_local4 = Engine.GetModel(itemRef, "setFunction")
                    if f7_local4 then
                        local f7_local5 = f7_arg1
                        local f7_local6 = Engine.GetModel(itemRef, "optionController")
                        if f7_local6 then
                            f7_local5 = Engine.GetModelValue(f7_local6)
                        end
                        local f7_local7 = Engine.GetModelValue(f7_local4)
                        f7_local7(f7_local5, newValue)
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
            CoD.TFPCUtil.DirtyOptions(f7_arg1)
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

CoD.TFPCUtil.GetOptionsDirtyModel = function(f8_arg0, f8_arg1)
    local f8_local0 = Engine.GetModel(Engine.GetModelForController(f8_arg0), "PC.OptionsDirty")
    if not f8_local0 and f8_arg1 then
        f8_local0 = Engine.CreateModel(Engine.GetModelForController(f8_arg0), "PC.OptionsDirty")
    end
    return f8_local0
end

CoD.TFPCUtil.FreeOptionsDirtyModel = function(f9_arg0)
    local f9_local0 = CoD.TFPCUtil.GetOptionsDirtyModel(f9_arg0)
    if f9_local0 then
        Engine.UnsubscribeAndFreeModel(f9_local0)
    end
end

CoD.TFPCUtil.DirtyOptions = function(f10_arg0)
    Engine.SetModelValue(CoD.TFPCUtil.GetOptionsDirtyModel(f10_arg0, true), 1)
    CoD.TFPCUtil.SetDirtyFlag()
end

CoD.TFPCUtil.IsOptionsDirty = function(f11_arg0)
    local f11_local0 = CoD.TFPCUtil.GetOptionsDirtyModel(f11_arg0)
    if f11_local0 then
        return Engine.GetModelValue(f11_local0) ~= 0
    else
        return false
    end
end

CoD.TFPCUtil.RefreshAllOptions = function(f12_arg0, f12_arg1)
    f12_arg0:dispatchEventToRoot({
        name = "options_refresh",
        controller = f12_arg1
    })
end

CoD.TFPCUtil.SimulateButtonPress = function(f13_arg0, f13_arg1)
    local f13_local0 = Engine.GetModel(Engine.GetModelForController(f13_arg0), "ButtonBits." .. f13_arg1)
    if f13_local0 then
        Engine.SetModelValue(f13_local0, Enum.LUIButtonFlags.FLAG_DOWN)
    end
end

CoD.TFPCUtil.SimulateButtonPressUsingElement = function(f14_arg0, f14_arg1)
    local f14_local0 = f14_arg1:getModel()
    if f14_local0 then
        local f14_local1 = Engine.GetModel(f14_local0, "Button")
        if f14_local1 then
            CoD.TFPCUtil.SimulateButtonPress(f14_arg0, Engine.GetModelValue(f14_local1))
        end
    end
end

CoD.TFPCUtil.OptionsCheckboxAction = function(f16_arg0, checkbox)
    local checkboxModel = checkbox:getModel()
    if checkboxModel then
        local result = CoD.TFPCUtil.GetOptionInfo(checkboxModel, f16_arg0)

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
            CoD.TFPCUtil.SetOptionValue(checkboxModel, f16_arg0, newValue)
            checkbox:playSound("list_action")
            return newValue
        end
    end
    return false
end

CoD.TFPCUtil.OptionsChatClientChannelFilterCheckboxProperties = function(f17_arg0, f17_arg1)
    local f17_local0 = f17_arg1:getModel()
    if f17_local0 then
        local f17_local1 = CoD.TFPCUtil.GetOptionInfo(f17_local0, f17_arg0)
        if f17_local1 then
            local f17_local2 = nil
            if f17_local1.currentValue == f17_local1.lowValue then
                f17_local2 = f17_local1.highValue
            else
                f17_local2 = f17_local1.lowValue
            end
            Engine.ChatClient_FilterChannelSet(f17_arg0, f17_local1.chatChannel, 0 < f17_local2)
            CoD.TFPCUtil.SetOptionValue(f17_local0, f17_arg0, Engine.ChatClient_FilterChannelGet(f17_arg0,
                Enum.chatChannel_e.CHAT_CHANNEL_COUNT))
            return f17_local2
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
CoD.TFPCUtil.OptionsDropdownItemSelected = function(f18_arg0, f18_arg1, f18_arg2)
    local f18_local0 = ""
    local f18_local1 = f18_arg2:getModel()
    if f18_local1 then
        local f18_local2 = Engine.GetModel(f18_local1, "valueDisplay")
        if f18_local2 then
            f18_local0 = Engine.GetModelValue(f18_local2)
        end
        local f18_local3 = nil
        local f18_local4 = Engine.GetModel(f18_local1, "value")
        if f18_local4 then
            f18_local3 = Engine.GetModelValue(f18_local4)
        end
        CoD.TFPCUtil.SetOptionValue(f18_arg1:getModel(), f18_arg0, f18_local3)
        f18_arg1:playSound("list_action")
    end
    return f18_local0
end

CoD.TFPCUtil.OptionsDropdownRefresh = function(f19_arg0, f19_arg1, f19_arg2)
    local f19_local0 = ""
    local f19_local1 = f19_arg1:getModel()
    if f19_local1 then
        local f19_local2 = CoD.TFPCUtil.GetOptionInfo(f19_local1, f19_arg0)
        if f19_local2 then
            local f19_local3 = f19_local2.profileVarName
            local f19_local4, f19_local5 = false
            local f19_local6 = f19_arg2:findItem({
                value = f19_local2.currentValue
            }, nil, f19_local4, f19_local5)
            local f19_local7 = false
            if not f19_local6 then
                f19_local6 = f19_arg2:getFirstSelectableItem()
                f19_local7 = true
            end
            if f19_local6 then
                local f19_local8 = f19_local6:getModel()
                if f19_local8 then
                    local f19_local9 = Engine.GetModel(f19_local8, "valueDisplay")
                    if f19_local9 then
                        f19_local0 = Engine.GetModelValue(f19_local9)
                    end
                    if f19_local7 then
                        f19_local4 = Engine.GetModel(f19_local8, "value")
                        if f19_local4 then
                            CoD.TFPCUtil.SetOptionValue(f19_local1, f19_arg0, Engine.GetModelValue(f19_local4))
                        end
                    end
                end
            end
        end
    end
    return f19_local0
end

CoD.TFPCUtil.OptionsDropdownCurrentValue = function(f20_arg0, f20_arg1)
    local f20_local0 = f20_arg1:getModel()
    if f20_local0 then
        local f20_local1 = CoD.TFPCUtil.GetOptionInfo(f20_local0, f20_arg0)
        return f20_local1.currentValue
    else

    end
end

CoD.TFPCUtil.OptionsGenericDropdownProperties = {
    dropDownItemSelected = CoD.TFPCUtil.OptionsDropdownItemSelected,
    dropDownRefresh = CoD.TFPCUtil.OptionsDropdownRefresh,
    dropDownCurrentValue = CoD.TFPCUtil.OptionsDropdownCurrentValue
}
CoD.TFPCUtil.DependantDropdownProperties = {
    dropDownItemSelected = function(f21_arg0, f21_arg1, f21_arg2)
        CoD.TFPCUtil.RefreshAllOptions(f21_arg1, f21_arg0)
        return CoD.TFPCUtil.OptionsDropdownItemSelected(f21_arg0, f21_arg1, f21_arg2)
    end,
    dropDownRefresh = CoD.TFPCUtil.OptionsDropdownRefresh,
    dropDownCurrentValue = CoD.TFPCUtil.OptionsDropdownCurrentValue
}
CoD.TFPCUtil.ShadowOptionIndex = 0
CoD.TFPCUtil.ShadowDropdownItemSelected = function(f22_arg0, f22_arg1, f22_arg2)
    local f22_local0 = ""
    local f22_local1 = CoD.TFPCUtil.GetModelValues(f22_arg2:getModel(), {"value", "valueDisplay"})
    if f22_local1 then
        f22_local0 = f22_local1.valueDisplay
        CoD.TFPCUtil.ShadowOptionIndex = f22_local1.value
        CoD.TFPCUtil.DirtyOptions(f22_arg0)
        f22_arg1:playSound("list_action")
    end
    return f22_local0
end

CoD.TFPCUtil.ShadowDropdownRefresh = function(f23_arg0, f23_arg1, f23_arg2)
    local f23_local0 = ""
    local f23_local1, f23_local2 = false
    local f23_local3 = f23_arg2:findItem({
        value = CoD.TFPCUtil.ShadowOptionIndex
    }, nil, f23_local1, f23_local2)
    local f23_local4 = false
    if not f23_local3 then
        f23_local3 = f23_arg2:getFirstSelectableItem()
        f23_local4 = true
    end
    if f23_local3 then
        local f23_local5 = CoD.TFPCUtil.GetModelValues(f23_local3:getModel(), {"value", "valueDisplay"})
        f23_local0 = f23_local5.valueDisplay
        if f23_local4 then
            CoD.TFPCUtil.ShadowOptionIndex = f23_local5.value
            CoD.TFPCUtil.DirtyOptions(f23_arg0)
        end
    end
    return f23_local0
end

CoD.TFPCUtil.ShadowDropdownCurrentValue = function(f24_arg0, f24_arg1)
    return CoD.TFPCUtil.ShadowOptionIndex
end

CoD.TFPCUtil.ShadowDropdownProperties = {
    dropDownItemSelected = CoD.TFPCUtil.ShadowDropdownItemSelected,
    dropDownRefresh = CoD.TFPCUtil.ShadowDropdownRefresh,
    dropDownCurrentValue = CoD.TFPCUtil.ShadowDropdownCurrentValue
}
CoD.TFPCUtil.VolumetricOptionIndex = 0
CoD.TFPCUtil.VolumetricDropdownItemSelected = function(f25_arg0, f25_arg1, f25_arg2)
    local f25_local0 = ""
    local f25_local1 = CoD.TFPCUtil.GetModelValues(f25_arg2:getModel(), {"value", "valueDisplay"})
    if f25_local1 then
        f25_local0 = f25_local1.valueDisplay
        CoD.TFPCUtil.VolumetricOptionIndex = f25_local1.value
        CoD.TFPCUtil.DirtyOptions(f25_arg0)
        f25_arg1:playSound("list_action")
    end
    return f25_local0
end

CoD.TFPCUtil.VolumetricDropdownRefresh = function(f26_arg0, f26_arg1, f26_arg2)
    local f26_local0 = ""
    local f26_local1, f26_local2 = false
    local f26_local3 = f26_arg2:findItem({
        value = CoD.TFPCUtil.VolumetricOptionIndex
    }, nil, f26_local1, f26_local2)
    local f26_local4 = false
    if not f26_local3 then
        f26_local3 = f26_arg2:getFirstSelectableItem()
        f26_local4 = true
    end
    if f26_local3 then
        local f26_local5 = CoD.TFPCUtil.GetModelValues(f26_local3:getModel(), {"value", "valueDisplay"})
        f26_local0 = f26_local5.valueDisplay
        if f26_local4 then
            CoD.TFPCUtil.VolumetricOptionIndex = f26_local5.value
            CoD.TFPCUtil.DirtyOptions(f26_arg0)
        end
    end
    return f26_local0
end

CoD.TFPCUtil.VolumetricDropdownCurrentValue = function(f27_arg0, f27_arg1)
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

CoD.TFPCUtil.OptionsSliderRefresh = function(f30_arg0, f30_arg1)
    local itemRef = f30_arg1:getModel()
    if itemRef then
        local sliderInfo = CoD.TFPCUtil.GetOptionInfo(itemRef, f30_arg0)
        if sliderInfo then
            if sliderInfo.useIntegerDisplay == 1 then
                f30_arg1.m_formatString = "%u"
            end
            if sliderInfo.useMultipleOf10Display == 1 then
                f30_arg1.m_formatString = "%u"
            end
            if sliderInfo.useMultipleOf100Display == 1 then
                f30_arg1.m_formatString = "%u"
            end
            local f30_local2 = (sliderInfo.currentValue - sliderInfo.lowValue) /
                                   (sliderInfo.highValue - sliderInfo.lowValue)
            if f30_local2 < 0 then
                f30_local2 = 0
            end
            if 1 < f30_local2 then
                f30_local2 = 1
            end
            f30_arg1.m_fraction = f30_local2
            f30_arg1.m_currentValue = sliderInfo.currentValue
            f30_arg1.m_sliderSpeed = sliderInfo.sliderSpeed
            f30_arg1.m_range = sliderInfo.highValue - sliderInfo.lowValue
        end
    end
end

CoD.TFPCUtil.OptionsSliderUpdated = function(f31_arg0, f31_arg1, f31_arg2)
    local itemRef = f31_arg1:getModel()
    if itemRef then
        local sliderInfo = CoD.TFPCUtil.GetOptionInfo(itemRef, f31_arg0)
        local newValue = string.format(f31_arg1.m_formatString,
            (sliderInfo.highValue - sliderInfo.lowValue) * f31_arg2 + sliderInfo.lowValue)
        if sliderInfo.useMultipleOf10Display == 1 then
            newValue = string.format("%u0", tonumber(newValue) / 10)
        end
        if sliderInfo.useMultipleOf100Display == 1 then
            newValue = string.format("%u00", tonumber(newValue) / 100)
        end
        if sliderInfo.isFloat == 1 then
            CoD.TFPCUtil.SetOptionValue(itemRef, f31_arg0, newValue * 100)
        else
            CoD.TFPCUtil.SetOptionValue(itemRef, f31_arg0, newValue)
        end
        f31_arg1.m_currentValue = newValue
        f31_arg1.m_fraction = f31_arg2
        f31_arg1.m_sliderSpeed = sliderInfo.sliderSpeed
        f31_arg1.m_range = sliderInfo.highValue - sliderInfo.lowValue
    end
end

CoD.TFPCUtil.OptionsGenericSliderProperties = {
    sliderRefresh = CoD.TFPCUtil.OptionsSliderRefresh,
    sliderUpdated = CoD.TFPCUtil.OptionsSliderUpdated
}