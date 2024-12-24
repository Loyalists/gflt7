local io = require("io")
local json = require("ui.util.json")

local TFOptionsFileName = "gfl_tfoptions.json"
local TFOptionsFilePath = ".\\players\\" .. TFOptionsFileName

local PersonalizationFileName = "gfl_personalization.json"
local PersonalizationFilePath = ".\\players\\" .. PersonalizationFileName

CoD.SavingDataModes = {
    TFOptions = 0,
    Personalization = 1,
}

if not CoD.DataUtil then
    CoD.DataUtil = {}
end

CoD.DataUtil.GetFilePath = function(mode)
    if not mode then
        return nil
    end
    
    local map = {
        [CoD.SavingDataModes.TFOptions] = TFOptionsFilePath,
        [CoD.SavingDataModes.Personalization] = PersonalizationFilePath,
    }

    local path = map[mode]
    return path
end

CoD.DataUtil.SaveItem = function(mode, saveSpot, saveValue)
    local path = CoD.DataUtil.GetFilePath(mode)
    if not path then
        return false
    end

    local table = CoD.DataUtil.LoadJSON(mode)
    if not table then
        return false
    end

    local file = io.open( path, "w" )
    if file then
        table[saveSpot] = saveValue
        file:write( json.encode(table) )
        io.close( file )
    else
        return false
    end
    
    return true
end

CoD.DataUtil.GetItem = function(mode, saveSpot)
    local path = CoD.DataUtil.GetFilePath(mode)
    if not path then
        return nil
    end

    local table = {}
    local file = io.open( path, "r" )

    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        io.close( file )
        table = json.decode(contents)
        local value = table[saveSpot]
        if value then
            return value
        end
    end

    return nil
end

CoD.DataUtil.SaveJSON = function(mode, table)
    local path = CoD.DataUtil.GetFilePath(mode)
    if not path then
        return false
    end
    
    if not table then
        return false
    end

    local file = io.open( path, "w" )
    if file then
        file:write( json.encode(table) )
        io.close( file )
    else
        return false
    end

    return true
end

CoD.DataUtil.LoadJSON = function(mode)
    local path = CoD.DataUtil.GetFilePath(mode)
    local table = {}
    if not path then
        return table
    end

    local file = io.open( path, "r" )

    if file then
        local contents = file:read( "*a" )
        io.close( file )
        table = json.decode(contents)
    end

    return table
end