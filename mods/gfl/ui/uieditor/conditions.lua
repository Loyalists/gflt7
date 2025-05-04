require("ui.uieditor.conditions_og")

function FeaturedCards_IsEnabled( element, controller )
	local f1049_local0 = LobbyData.GetLobbyNav()
	
	if f1049_local0 ~= LobbyData.UITargets.UI_MODESELECT.id and f1049_local0 ~= LobbyData.UITargets.UI_ZMLOBBYONLINE.id then
		return false
	else
		local f1049_local1 = Engine.GetModelValue( Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "FeaturedCardsRoot", true ), "Enabled", true ) )
		if HasLiveEvent( controller ) then
			return true
		elseif f1049_local0 == LobbyData.UITargets.UI_ZMLOBBYONLINE.id then
			return true
		elseif Dvar.ui_enableZMHDFeaturedCard:get() == 1 or Dvar.ui_enableZMHDFeaturedCard:get() == "1" then
			return true
		else
			local f1049_local2 = Engine.GetFeaturedCardsData()
			if Dvar.live_featuredEnabled:get() == false or f1049_local2.enabled == false then
				return false
			elseif f1049_local2.validCardsCount == 0 then
				return false
			else
				return true
			end
		end
	end
end

function IsHeroLocked(f600_arg0, f600_arg1)
    return false
end

function IsCACItemLocked(f227_arg0, f227_arg1, f227_arg2)
    return false
end

function IsCACItemPurchased(f213_arg0, f213_arg1)
    return true
end

function IsCybercoreMenuDisabled(f243_arg0)
    return false
end

function IsAttachmentLockedInWeaponBuildKits( f677_arg0, f677_arg1 )
	return false
end

function IsAttachmentSlotLocked( f678_arg0, f678_arg1, f678_arg2 )
	return false
end

function IsItemAttachmentLocked( f9_arg0, f9_arg1, f9_arg2, f9_arg3, f9_arg4 )
	return false
end

function CharacterHasAnyWeaponUnlocked( f952_arg0, f952_arg1 )
    if CoD.CCUtility.customizationMode == Enum.eModes.MODE_ZOMBIES then
        return true
    end

	if not IsProgressionEnabled( f952_arg0 ) and (not IsLive() or not IsFirstTimeSetup( f952_arg0, Enum.eModes.MODE_MULTIPLAYER )) then
		return true
	end
	local f952_local0 = f952_arg1.heroIndex
	if not f952_local0 then
		f952_local0 = CoD.SafeGetModelValue( f952_arg1:getModel(), "heroIndex" )
	end
	if not f952_local0 then
		return false
	elseif IsMultiplayer() then
		local f952_local1 = Engine.GetHeroList( Enum.eModes.MODE_MULTIPLAYER )
		local f952_local2 = f952_local1[f952_local0 + 1]
		if f952_local2 and CoDShared.IsLootHero( f952_local2 ) then
			return true
		end
	end
	for f952_local1 = 0, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_COUNT - 1, 1 do
		local f952_local4 = Engine.GetLoadoutInfoForHero( Enum.eModes.MODE_MULTIPLAYER, f952_local0, f952_local1 )
		if not Engine.IsItemLocked( f952_arg0, f952_local4.itemIndex, Enum.eModes.MODE_MULTIPLAYER ) and Engine.IsItemPurchased( f952_arg0, f952_local4.itemIndex, Enum.eModes.MODE_MULTIPLAYER ) then
			return true
		end
	end
	return false
end

function AllowLootHero( f602_arg0 )
	return true
end

function UseOldSaveData()
	if Engine.IsBOIII and Engine.IsBOIII == true then
		return true
	end

	return false
end

function IsModInBetaTest()
	return false
end

Engine.IsItemLocked = function(f43_arg0, f43_local6, f43_local7)
	return false
end

Engine.IsItemPurchased = function(f213_arg0, f213_arg1)
    return true
end

Engine.ClientHasCollectible = function(f13_arg0, f13_arg1, f13_arg2, f13_arg3)
    return true
end

Engine.IsCharacterCustomizationItemLocked = function(f35_arg0, f36_local1, f36_local2, f36_arg0)
    return false
end

Engine.IsSpecialistTransmissionLocked = function( f11_arg0, f11_arg1, f11_arg2 )
	return false
end