EnableGlobals()
local io = require("io")
local json = require("ui.util.json")

if not CoD.SavingDataUtility then
    CoD.SavingDataUtility = {}
end

local loadoutSlotNames =  {
    "primary", "secondary", "primarygrenade", "specialgrenade", "primarygadget", 
    "primarygadgetattachment1", "primarygadgetattachment2", "primarygadgetattachment3", "secondarygadget", "primaryattachment1", 
    "primaryattachment2", "primaryattachment3", "primaryattachment4", "primaryattachment5", "primaryattachment6", 
    "secondaryattachment1", "secondaryattachment2", "secondaryattachment3", "secondaryattachment4", "secondaryattachment5", 
    "secondaryattachment6", "specialty1", "specialty2", "specialty3", "specialty4", 
    "specialty5", "specialty6", "bonuscard1", "bonuscard2", "bonuscard3", 
    "killstreak1", "killstreak2", "killstreak3", "cybercore", "cybercom_ability1", 
    "cybercom_ability2", "cybercom_ability3", "cybercom_tacrig1", "cybercom_tacrig2",
    "primarypaintjobslot", "primarycamo", "primaryreticle", "primarygunsmithvariant", "primaryreticlecolor", "primarylens", "primaryemblem", "primarytag", 
    "secondarypaintjobslot", "secondarycamo", "secondaryreticle", "secondarygunsmithvariant", "secondaryreticlecolor", "secondarylens", "secondaryemblem", "secondarytag", 
    "primaryattachment1cosmeticvariant", "primaryattachment2cosmeticvariant", "primaryattachment3cosmeticvariant", "primaryattachment4cosmeticvariant", "primaryattachment5cosmeticvariant", 
    "primaryattachment6cosmeticvariant", "secondaryattachment1cosmeticvariant", "secondaryattachment2cosmeticvariant", 
    "secondaryattachment3cosmeticvariant", "secondaryattachment4cosmeticvariant", "secondaryattachment5cosmeticvariant", "secondaryattachment6cosmeticvariant"
}

function CoD.SavingDataUtility.SaveData(InstanceRef, SaveSpot, SaveValue)
    if SaveSpot < 50 then
        Engine.SetBubbleGumBuff(InstanceRef, math.floor(SaveSpot / 5), SaveSpot % 5, SaveValue)
        Engine.StorageWrite(InstanceRef, Enum.StorageFileType.STORAGE_ZM_LOADOUTS_OFFLINE)
    else
        SaveSpot = SaveSpot - 50
        Engine.SetClassItem(InstanceRef, math.floor(SaveSpot / #loadoutSlotNames), loadoutSlotNames[(SaveSpot % #loadoutSlotNames) + 1], SaveValue)
        Engine.Exec(InstanceRef, "saveLoadout")
    end
end

function CoD.SavingDataUtility.GetData(InstanceRef, SaveSpot)
    if SaveSpot < 50 then
        return Engine.GetBubbleGumBuff(InstanceRef, math.floor(SaveSpot / 5), SaveSpot % 5)
    else
        SaveSpot = SaveSpot - 50
        return Engine.GetClassItem(InstanceRef, math.floor(SaveSpot / #loadoutSlotNames), loadoutSlotNames[(SaveSpot % #loadoutSlotNames) + 1], false)
    end
end

function CoD.SavingDataUtility.SaveJSONData(SaveSpot, SaveValue)
    local path = ".\\players\\" .. "gfl_tfoptions.json"
    local table = CoD.SavingDataUtility.LoadJSON()
    if not table then
        return false
    end

    local file = io.open( path, "w" )
    if file then
        table[SaveSpot] = SaveValue
        file:write( json.encode(table) )
        io.close( file )
    else
        return false
    end
    
    return true
end

function CoD.SavingDataUtility.GetJSONData(SaveSpot)
    local path = ".\\players\\" .. "gfl_tfoptions.json"
    local table = {}
    local file = io.open( path, "r" )

    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        io.close( file )
        table = json.decode(contents)
        local value = table[SaveSpot]
        if value then
            return value
        end
    end

    return nil
end

function CoD.SavingDataUtility.SaveJSON(table)
    local path = ".\\players\\" .. "gfl_tfoptions.json"
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

function CoD.SavingDataUtility.LoadJSON()
    local path = ".\\players\\" .. "gfl_tfoptions.json"
    local table = {}
    local file = io.open( path, "r" )

    if file then
        local contents = file:read( "*a" )
        io.close( file )
        table = json.decode(contents)
    end

    return table
end