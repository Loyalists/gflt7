EnableGlobals()

require("ui.T7.Utility.DataUtil")

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

function CoD.SavingDataUtility.SaveData(controller, SaveSpot, SaveValue)
    if SaveSpot < 50 then
        Engine.SetBubbleGumBuff(controller, math.floor(SaveSpot / 5), SaveSpot % 5, SaveValue)
        Engine.StorageWrite(controller, Enum.StorageFileType.STORAGE_ZM_LOADOUTS_OFFLINE)
    else
        SaveSpot = SaveSpot - 50
        Engine.SetClassItem(controller, math.floor(SaveSpot / #loadoutSlotNames), loadoutSlotNames[(SaveSpot % #loadoutSlotNames) + 1], SaveValue)
        Engine.Exec(controller, "saveLoadout")
    end
end

function CoD.SavingDataUtility.GetData(controller, SaveSpot)
    if SaveSpot < 50 then
        return Engine.GetBubbleGumBuff(controller, math.floor(SaveSpot / 5), SaveSpot % 5)
    else
        SaveSpot = SaveSpot - 50
        return Engine.GetClassItem(controller, math.floor(SaveSpot / #loadoutSlotNames), loadoutSlotNames[(SaveSpot % #loadoutSlotNames) + 1], false)
    end
end