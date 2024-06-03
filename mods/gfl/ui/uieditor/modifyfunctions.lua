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