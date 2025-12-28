require("ui.t7.utility.DataUtil")
-- require("ui.T7.Utility.TFPCUtility")

local personalizationVersion = 0

CoD.PersonalizationDefault = {
    version = personalizationVersion,
    disable_intro_movie = 1,
    hud = 0,
    custom_hud = 1,
    thirdperson = 0,
}

CoD.PersonalizationDirtyFlag = false

if not CoD.PersonalizationUtil then
    CoD.PersonalizationUtil = {}
end

CoD.PersonalizationUtil.GetVersion = function()
    return personalizationVersion
end

CoD.PersonalizationUtil.IsOptionExisted = function(varName)
    if CoD.PersonalizationDefault and CoD.PersonalizationDefault[varName] then
        return true
    end

    return false
end

CoD.PersonalizationUtil.SetItem = function(varName, value)
    if not CoD.PersonalizationUtil.IsOptionExisted(varName) then
        return
    end

    local converted = tonumber(value)
    if not converted then
        converted = CoD.PersonalizationDefault[varName]
    end
    Engine.SetDvar("personalization_" .. varName, converted)
    CoD.DataUtil.SaveItem(CoD.SavingDataModes.Personalization, varName, converted)
end

CoD.PersonalizationUtil.GetItem = function(varName)
    local result = CoD.DataUtil.GetItem(CoD.SavingDataModes.Personalization, varName)
    if varName ~= "version" then
        if result == nil then
            result = CoD.PersonalizationDefault[varName]
        end
    
        if result == nil then
            result = 0
        end
    end
    
    return result
end

CoD.PersonalizationUtil.LoadItem = function(varName)
    local result = CoD.PersonalizationUtil.GetItem(varName)
    Engine.SetDvar("personalization_" .. varName, result)
end

CoD.PersonalizationUtil.GetValueForOption = function(varNameString)
    local curVal = CoD.PersonalizationUtil.GetItem(varNameString)
    return curVal
end

CoD.PersonalizationUtil.SetValueForOption = function(varNameString, newValue)
    CoD.PersonalizationUtil.SetItem(varNameString, newValue)
end

CoD.PersonalizationUtil.CheckForRecentUpdate = function()
    local result = CoD.PersonalizationUtil.GetItem("version")
    if not result or result ~= CoD.PersonalizationUtil.GetVersion() then
        CoD.PersonalizationUtil.ResetToDefault()
        return true
    end
    return false
end

CoD.PersonalizationUtil.ResetToDefault = function()
    CoD.DataUtil.SaveJSON(CoD.SavingDataModes.Personalization, CoD.PersonalizationDefault)
    for varName, value in pairs(CoD.PersonalizationDefault) do
        if value then
            Engine.SetDvar("personalization_" .. varName, value)
        end
    end
end

CoD.PersonalizationUtil.LoadPersonalization = function()
    local table = CoD.DataUtil.LoadJSON(CoD.SavingDataModes.Personalization)
    for varName, _ in pairs(CoD.PersonalizationDefault) do
        local value = table[varName]
        if value then
            local converted = tonumber(value)
            if converted then
                Engine.SetDvar("personalization_" .. varName, converted)
            end
        end
    end
end

-- CoD.PersonalizationUtil.GetDirtyFlag = function()
--     if CoD.PersonalizationDirtyFlag then
--         return true
--     end

--     return false
-- end

-- CoD.PersonalizationUtil.SetDirtyFlag = function()
--     CoD.PersonalizationDirtyFlag = true
-- end

-- CoD.PersonalizationUtil.UnsetDirtyFlag = function()
--     CoD.PersonalizationDirtyFlag = false
-- end

CoD.PersonalizationUtil.ApplyChangesInGame = function(controller)
    if CoD.isFrontend then
        return
    end

    -- if not CoD.PersonalizationUtil.GetDirtyFlag then
    --     return
    -- end

    Engine.SendMenuResponse(controller, "popup_leavegame", "PersonalizationOptionsChanged")
end