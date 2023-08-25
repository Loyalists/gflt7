require("ui.t7.utility.BlackMarketUtility_og")

CoD.BlackMarketUtility.IsItemLocked = function ( f100_arg0, f100_arg1 )
	if Dvar.ui_allLootUnlocked:get() == "1" then
		return false
	elseif f100_arg1 then
		local blacklist = {"pbt_loot_"}
		for k in pairs(blacklist) do
			if string.find(f100_arg1, k) then
				local f100_local0 = CoD.BlackMarketUtility.GetItemQuantity(f100_arg0, f100_arg1)
				if f100_local0 == nil then
					local f100_local1 = CoD.BlackMarketUtility.UnlockedByPrerequisites(f100_arg0, f100_arg1)
					if f100_local1 ~= nil then
						return not f100_local1
					end
				end
				if f100_local0 == nil or f100_local0 == 0 then
					return true
				else
					return false
				end
			end
		end

		return false
	else
		return false
	end
end

CoD.BlackMarketUtility.ClassContainsLockedItems = function ( f101_arg0, f101_arg1 )
	return false
end

CoD.BlackMarketUtility.BuildCallingCardSets = function ( f108_arg0 )
	CoD.BlackMarketUtility.CallingCardsTable = {}
	CoD.BlackMarketUtility.CommonCallingCardsTable = {}
	local f108_local0 = {}
	local f108_local1 = {}
	local f108_local2 = "calling_card"
	local f108_local3 = 0
	local f108_local4 = 4
	local f108_local5 = 5
	local f108_local6 = CoD.BlackMarketUtility.GetCallingCardRows()
	local f108_local7 = 0
	local f108_local8 = 0
	local f108_local9 = 0
	for f108_local16, f108_local17 in ipairs( f108_local6 ) do
		local f108_local18 = Engine.TableLookupGetColumnValueForRow( CoD.BlackMarketUtility.lootTableName, f108_local17, f108_local3 )
		local f108_local19 = Engine.TableLookupGetColumnValueForRow( CoD.BlackMarketUtility.lootTableName, f108_local17, f108_local4 )
		local f108_local20 = Engine.TableLookupGetColumnValueForRow( CoD.BlackMarketUtility.lootTableName, f108_local17, f108_local5 )
		local f108_local21 = CoD.BlackMarketUtility.GetCallingCardTitleFromImage( f108_local18 )
		local f108_local22 = CoD.BlackMarketUtility.GetLootCallingCardIndex( f108_arg0, f108_local18 )
		local f108_local23 = CoD.BlackMarketUtility.GetRarityForLootItemFromName( f108_local18 )
		local f108_local24 = CoD.BlackMarketUtility.GetItemQuantity( f108_arg0, f108_local18 )
		if f108_local19 ~= "" then
			if not f108_local1[f108_local19] then
				f108_local1[f108_local19] = {}
			end
			table.insert( f108_local1[f108_local19], {
				title = f108_local21,
				name = f108_local18,
				rarity = f108_local23,
				duplicateCount = f108_local24,
				iconId = f108_local22,
				sortKey = CoD.BlackMarketUtility.GetCallingCardSortKeyFromImage( f108_local18 ),
				isBMClassified = CoD.BlackMarketUtility.IsItemLocked( f108_arg0, f108_local18 ),
				isContractClassified = false
			} )
		end
		if f108_local20 ~= "" then
			local f108_local13 = {}
			local f108_local14 = CoD.BlackMarketUtility.GetRarityForCallingCardSetFromSetName( f108_local20 )
			local f108_local15 = nil
			f108_local13.name = f108_local20
			f108_local13.title = f108_local21
			f108_local13.setCount = CoD.BlackMarketUtility.GetSetPieceStringForLootSet( f108_arg0, f108_local20, f108_local2 )
			f108_local15, f108_local13.totalSetCount, f108_local13.newCount = CoD.BlackMarketUtility.GetNumOwnedAndTotalForCallingCardSet( f108_arg0, f108_local20 )
			f108_local13.iconId = 0
			f108_local13.masterCardIconId = f108_local22
			f108_local13.rarity = f108_local14
			if Engine.IsEmblemBackgroundNew( f108_arg0, f108_local22 ) and not BlackMarketHideMasterCallingCards() then
				f108_local13.newCount = f108_local13.newCount + 1
			end
			table.insert( f108_local0, f108_local13 )
		end
		f108_local7 = f108_local7 + 1
		local f108_local13 = CoD.BlackMarketUtility.IsItemLocked( f108_arg0, f108_local18 )
		if not f108_local13 then
			f108_local8 = f108_local8 + 1
		end
		local f108_local14 = CoD.BlackMarketUtility.GetLootCallingCardIndex( f108_arg0, f108_local18 )
		if f108_local14 and Engine.IsEmblemBackgroundNew( f108_arg0, f108_local14 ) then
			f108_local9 = f108_local9 + 1
		end
		table.insert( CoD.BlackMarketUtility.CommonCallingCardsTable, {
			title = f108_local21,
			name = f108_local18,
			rarity = f108_local23,
			duplicateCount = f108_local24,
			iconId = f108_local22,
			isBMClassified = f108_local13,
			isContractClassified = false
		} )
	end
	for f108_local16, f108_local17 in pairs( f108_local0 ) do
		if f108_local1[f108_local17.name] then
			f108_local17.callingCards = f108_local1[f108_local17.name]
			local f108_local18 = true
			local f108_local19 = false
			for f108_local23, f108_local24 in ipairs( f108_local17.callingCards ) do
				if f108_local24.isBMClassified == false then
					f108_local18 = false
					if f108_local17.iconId == 0 then
						f108_local17.iconId = CoD.BlackMarketUtility.GetLootCallingCardIndex( f108_arg0, f108_local24.name )
					end
				end
				f108_local19 = true
			end
			if BlackMarketHideMasterCallingCards() then
				f108_local19 = true
			end
			if not f108_local17.iconId then
				f108_local17.iconId = 0
			end
			f108_local17.isBMClassified = f108_local19
			f108_local17.isSetBMClassified = f108_local18
			f108_local17.isSetContractClassified = false
		end
	end
	if not Dvar.ui_disable_side_bet:exists() or Dvar.ui_disable_side_bet:get() == "0" then
		local f108_local11 = CoD.ChallengesUtility.GetSideBetCallingCards( f108_arg0, function ( f109_arg0, f109_arg1 )
			return tonumber( f109_arg0.imageID ) < tonumber( f109_arg1.imageID )
		end )
		local f108_local12 = {
			name = CoD.BlackMarketUtility.SideBetSetName,
			callingCards = {},
			iconId = f108_local11[1].models.iconId,
			newCount = 0,
			masterCardIconId = 0,
			isSetBMClassified = false,
			isSetContractClassified = false,
			totalSetCount = #f108_local11 - 1,
			setCount = Engine.Localize( "MPUI_BM_SET_X_OF_Y", 0, 6 ),
			isBMClassified = false,
			isContractClassified = false,
			rarity = "",
			title = "CONTRACT_SIDE_BET_CALLING_CARD"
		}
		local f108_local16 = 0
		for f108_local20, f108_local21 in ipairs( f108_local11 ) do
			if not f108_local21.properties.isExpert then
				if not f108_local21.models.isLocked then
					f108_local16 = f108_local16 + 1
					f108_local12.iconId = f108_local21.models.iconId
				end
				if not f108_local21.models.isLocked and Engine.IsEmblemBackgroundNew( f108_arg0, f108_local21.models.iconId ) then
					f108_local12.newCount = f108_local12.newCount + 1
				end
				table.insert( f108_local12.callingCards, {
					rarity = "",
					title = Engine.TableLookup( nil, CoD.backgroundsTable, 1, f108_local21.models.iconId, 4 ),
					isBMClassified = false,
					isContractClassified = false,
					isLocked = false,
					sortKey = f108_local20,
					iconId = f108_local21.models.iconId,
					name = CoD.BlackMarketUtility.SideBetSetName,
					duplicateCount = 0,
					description = f108_local21.models.description
				} )
			end
			f108_local12.masterCardIconId = f108_local21.models.iconId
			if not f108_local21.models.isLocked then
				f108_local12.iconId = f108_local21.models.iconId
				f108_local12.isBMClassified = false
				if Engine.IsEmblemBackgroundNew( f108_arg0, f108_local21.models.iconId ) then
					f108_local12.newCount = f108_local12.newCount + 1
				end
			end
		end
		f108_local12.setCount = Engine.Localize( "MPUI_BM_SET_X_OF_Y", f108_local16, f108_local12.totalSetCount )
		f108_local12.isSetBMClassified = f108_local16 < 1
		table.insert( f108_local0, f108_local12 )
	end
	table.insert( f108_local0, CoD.BlackMarketUtility.AddSpecialContractCallingCardSet( f108_arg0, "mp_action" ) )
	table.sort( f108_local0, CoD.BlackMarketUtility.SortUnlockIconId )
	CoD.BlackMarketUtility.CallingCardsTable = f108_local0
	return f108_local8, f108_local8 .. " / " .. f108_local7, f108_local9
end