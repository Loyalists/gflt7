require( "ui.uieditor.modifyfunctions_og" )

function GetAttachmentImageFromIndex( controller, index, attachment )
	local attachment_int = tonumber( attachment )
	local index_int = tonumber( index )
	local final_image = ""
	local weapon_index = CoD.GetCustomization( controller, "weapon_index" )
	local gunsmithvariant = CoD.perController[controller].gunsmithVariantModel
	local attachmentVariantModel = Engine.GetModelValue( Engine.GetModel( gunsmithvariant, "attachmentVariant" .. index_int ) )
	if attachment_int > CoD.CraftUtility.Gunsmith.EMPTY_ITEM_INDEX then
		if attachmentVariantModel == 0 then
			final_image = Engine.GetAttachmentUniqueImageByAttachmentIndex( CoD.CraftUtility.GetCraftMode(), weapon_index, attachment_int )
		else
			local f262_local6 = Engine.GetAttachmentCosmeticVariant( CoD.CraftUtility.Gunsmith.GetWeaponPlusAttachmentsForVariant( controller, gunsmithvariant ), attachment_int )
			if f262_local6 and f262_local6.image then
				final_image = f262_local6.image
			else
				final_image = Engine.GetAttachmentUniqueImageByAttachmentIndex( CoD.CraftUtility.GetCraftMode(), weapon_index, attachment_int )
			end
		end
	end
	return final_image
end

local function getUsermapInfo()
    local info = Engine.GetLobbyUgcInfo()

    if info.usermapInfo and info.usermapInfo.ugcInfo then
        -- Set when the selected map is a usermap
        if info.usermapInfo.ugcInfo.ugcName and info.usermapInfo.ugcInfo.ugcName ~= '' then
            return info.usermapInfo.ugcInfo
        end
    end
    return nil
end

function MapNameToLocalizedMapName( f185_arg0 )
    -- Only works when loading into the map
    if Engine.IsUsingUsermap() then
        return Engine.UsingUsermapTitle()
    else
        local usermapInfo = getUsermapInfo()

        -- For lobby, searches for an installed usermap that matches the current usermap ID
        if usermapInfo then
            local usermapList = Engine.Mods_Lists_GetInfoEntries( LuaEnums.USERMAP_BASE_PATH, 0, Engine.Mods_Lists_GetInfoEntriesCount( LuaEnums.USERMAP_BASE_PATH ) )
            if usermapList then
                for i = 0, #usermapList, 1 do
                    local current = usermapList[i]

                    -- Found a usermap that matches this one - get its real name
                    if current.ugcName == usermapInfo.ugcName then
                        return Engine.Localize( current.name )
                    end
                end
            end
        end

        -- Otherwise normal logic
        return Engine.Localize( CoD.GetMapValue( f185_arg0, "mapNameCaps", f185_arg0 ) )
    end
end

function MapNameToMapImage( mapUniqueName )
    local returnValue = CoD.GetMapValue( mapUniqueName, "previewImage", "$black" )

    if returnValue == "$black" then
        local usermapInfo = getUsermapInfo()

        -- mapUniqueName is incorrectly set to usermap's map_name once selected, but should be its workshop ID. This corrects it.
        if usermapInfo and usermapInfo.ugcName then
            Engine.UpdateModPreviewImage( usermapInfo.ugcName )
        else
            -- Probably in map select
            Engine.UpdateModPreviewImage( mapUniqueName )
        end
        returnValue = "img_t7_mod_preview"
    end
    return returnValue
end