require("ui.uieditor.conditions_og")

function FeaturedCards_IsEnabled( element, controller )
	local lobbyNav = LobbyData.GetLobbyNav()
	
	if lobbyNav ~= LobbyData.UITargets.UI_MODESELECT.id and lobbyNav ~= LobbyData.UITargets.UI_ZMLOBBYONLINE.id then
		return false
	else
		local enabled = Engine.GetModelValue( Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "FeaturedCardsRoot", true ), "Enabled", true ) )
		if HasLiveEvent( controller ) then
			return true
		elseif lobbyNav == LobbyData.UITargets.UI_ZMLOBBYONLINE.id then
			return true
		elseif Dvar.ui_enableZMHDFeaturedCard:get() == 1 or Dvar.ui_enableZMHDFeaturedCard:get() == "1" then
			return true
		else
			local featuredCardsData = Engine.GetFeaturedCardsData()
			if Dvar.live_featuredEnabled:get() == false or featuredCardsData.enabled == false then
				return false
			elseif featuredCardsData.validCardsCount == 0 then
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

function CharacterHasAnyWeaponUnlocked( controller, element )
    if CoD.CCUtility.customizationMode == Enum.eModes.MODE_ZOMBIES then
        return true
    end

	if not IsProgressionEnabled( controller ) and (not IsLive() or not IsFirstTimeSetup( controller, Enum.eModes.MODE_MULTIPLAYER )) then
		return true
	end
	local heroIndex = element.heroIndex
	if not heroIndex then
		heroIndex = CoD.SafeGetModelValue( element:getModel(), "heroIndex" )
	end
	if not heroIndex then
		return false
	elseif IsMultiplayer() then
		local heroes = Engine.GetHeroList( Enum.eModes.MODE_MULTIPLAYER )
		local f952_local2 = heroes[heroIndex + 1]
		if f952_local2 and CoDShared.IsLootHero( f952_local2 ) then
			return true
		end
	end
	for loadoutType = 0, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_COUNT - 1, 1 do
		local loadoutInfo = Engine.GetLoadoutInfoForHero( Enum.eModes.MODE_MULTIPLAYER, heroIndex, loadoutType )
		if not Engine.IsItemLocked( controller, loadoutInfo.itemIndex, Enum.eModes.MODE_MULTIPLAYER ) and Engine.IsItemPurchased( controller, loadoutInfo.itemIndex, Enum.eModes.MODE_MULTIPLAYER ) then
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

Engine.IsItemLocked = function(controller, f43_local6, f43_local7)
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