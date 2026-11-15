require("ui.t7.utility.BlackMarketUtility_og")

CoD.BlackMarketUtility.IsItemLocked = function ( controller, itemName )
	if Dvar.ui_allLootUnlocked:get() == "1" then
		return false
	elseif itemName then
		local blacklist = {"pbt_loot_"}
		for k in pairs(blacklist) do
			if string.find(itemName, k) then
				local itemQuantity = CoD.BlackMarketUtility.GetItemQuantity(controller, itemName)
				if itemQuantity == nil then
					local isUnlockedByPrerequisites = CoD.BlackMarketUtility.UnlockedByPrerequisites(controller, itemName)
					if isUnlockedByPrerequisites ~= nil then
						return not isUnlockedByPrerequisites
					end
				end
				if itemQuantity == nil or itemQuantity == 0 then
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

CoD.BlackMarketUtility.BuildCallingCardSets = function ( controller )
	CoD.BlackMarketUtility.CallingCardsTable = {}
	CoD.BlackMarketUtility.CommonCallingCardsTable = {}
	local f108_local0 = {}
	local f108_local1 = {}
	local f108_local2 = "calling_card"
	local column = 0
	local column2 = 4
	local column3 = 5
	local callingCardRows = CoD.BlackMarketUtility.GetCallingCardRows()
	local f108_local7 = 0
	local f108_local8 = 0
	local f108_local9 = 0
	for index, row in ipairs( callingCardRows ) do
		local itemName = Engine.TableLookupGetColumnValueForRow( CoD.BlackMarketUtility.lootTableName, row, column )
		local f108_local19 = Engine.TableLookupGetColumnValueForRow( CoD.BlackMarketUtility.lootTableName, row, column2 )
		local f108_local20 = Engine.TableLookupGetColumnValueForRow( CoD.BlackMarketUtility.lootTableName, row, column3 )
		local callingCardTitle = CoD.BlackMarketUtility.GetCallingCardTitleFromImage( itemName )
		local callingCardIndex = CoD.BlackMarketUtility.GetLootCallingCardIndex( controller, itemName )
		local rarity = CoD.BlackMarketUtility.GetRarityForLootItemFromName( itemName )
		local itemQuantity = CoD.BlackMarketUtility.GetItemQuantity( controller, itemName )
		if f108_local19 ~= "" then
			if not f108_local1[f108_local19] then
				f108_local1[f108_local19] = {}
			end
			table.insert( f108_local1[f108_local19], {
				title = callingCardTitle,
				name = itemName,
				rarity = rarity,
				duplicateCount = itemQuantity,
				iconId = callingCardIndex,
				sortKey = CoD.BlackMarketUtility.GetCallingCardSortKeyFromImage( itemName ),
				isBMClassified = CoD.BlackMarketUtility.IsItemLocked( controller, itemName ),
				isContractClassified = false
			} )
		end
		if f108_local20 ~= "" then
			local f108_local13 = {}
			local rarity = CoD.BlackMarketUtility.GetRarityForCallingCardSetFromSetName( f108_local20 )
			local f108_local15 = nil
			f108_local13.name = f108_local20
			f108_local13.title = callingCardTitle
			f108_local13.setCount = CoD.BlackMarketUtility.GetSetPieceStringForLootSet( controller, f108_local20, f108_local2 )
			f108_local15, f108_local13.totalSetCount, f108_local13.newCount = CoD.BlackMarketUtility.GetNumOwnedAndTotalForCallingCardSet( controller, f108_local20 )
			f108_local13.iconId = 0
			f108_local13.masterCardIconId = callingCardIndex
			f108_local13.rarity = rarity
			if Engine.IsEmblemBackgroundNew( controller, callingCardIndex ) and not BlackMarketHideMasterCallingCards() then
				f108_local13.newCount = f108_local13.newCount + 1
			end
			table.insert( f108_local0, f108_local13 )
		end
		f108_local7 = f108_local7 + 1
		local isItemLocked = CoD.BlackMarketUtility.IsItemLocked( controller, itemName )
		if not isItemLocked then
			f108_local8 = f108_local8 + 1
		end
		local callingCardIndex2 = CoD.BlackMarketUtility.GetLootCallingCardIndex( controller, itemName )
		if callingCardIndex2 and Engine.IsEmblemBackgroundNew( controller, callingCardIndex2 ) then
			f108_local9 = f108_local9 + 1
		end
		table.insert( CoD.BlackMarketUtility.CommonCallingCardsTable, {
			title = callingCardTitle,
			name = itemName,
			rarity = rarity,
			duplicateCount = itemQuantity,
			iconId = callingCardIndex,
			isBMClassified = isItemLocked,
			isContractClassified = false
		} )
	end
	for key, f108_local17 in pairs( f108_local0 ) do
		if f108_local1[f108_local17.name] then
			f108_local17.callingCards = f108_local1[f108_local17.name]
			local f108_local18 = true
			local f108_local19 = false
			for index, callingCard in ipairs( f108_local17.callingCards ) do
				if callingCard.isBMClassified == false then
					f108_local18 = false
					if f108_local17.iconId == 0 then
						f108_local17.iconId = CoD.BlackMarketUtility.GetLootCallingCardIndex( controller, callingCard.name )
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
		local sideBetCallingCards = CoD.ChallengesUtility.GetSideBetCallingCards( controller, function ( f109_arg0, f109_arg1 )
			return tonumber( f109_arg0.imageID ) < tonumber( f109_arg1.imageID )
		end )
		local f108_local12 = {
			name = CoD.BlackMarketUtility.SideBetSetName,
			callingCards = {},
			iconId = sideBetCallingCards[1].models.iconId,
			newCount = 0,
			masterCardIconId = 0,
			isSetBMClassified = false,
			isSetContractClassified = false,
			totalSetCount = #sideBetCallingCards - 1,
			setCount = Engine.Localize( "MPUI_BM_SET_X_OF_Y", 0, 6 ),
			isBMClassified = false,
			isContractClassified = false,
			rarity = "",
			title = "CONTRACT_SIDE_BET_CALLING_CARD"
		}
		local f108_local16 = 0
		for index, f108_local21 in ipairs( sideBetCallingCards ) do
			f108_local21.models.isLocked = false
			if not f108_local21.properties.isExpert then
				if not f108_local21.models.isLocked then
					f108_local16 = f108_local16 + 1
					f108_local12.iconId = f108_local21.models.iconId
				end
				if not f108_local21.models.isLocked and Engine.IsEmblemBackgroundNew( controller, f108_local21.models.iconId ) then
					f108_local12.newCount = f108_local12.newCount + 1
				end
				table.insert( f108_local12.callingCards, {
					rarity = "",
					title = Engine.TableLookup( nil, CoD.backgroundsTable, 1, f108_local21.models.iconId, 4 ),
					isBMClassified = false,
					isContractClassified = false,
					isLocked = false,
					sortKey = index,
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
				if Engine.IsEmblemBackgroundNew( controller, f108_local21.models.iconId ) then
					f108_local12.newCount = f108_local12.newCount + 1
				end
			end
		end
		f108_local12.setCount = Engine.Localize( "MPUI_BM_SET_X_OF_Y", f108_local16, f108_local12.totalSetCount )
		f108_local12.isSetBMClassified = f108_local16 < 1
		table.insert( f108_local0, f108_local12 )
	end
	table.insert( f108_local0, CoD.BlackMarketUtility.AddSpecialContractCallingCardSet( controller, "mp_action" ) )
	table.sort( f108_local0, CoD.BlackMarketUtility.SortUnlockIconId )
	CoD.BlackMarketUtility.CallingCardsTable = f108_local0
	return f108_local8, f108_local8 .. " / " .. f108_local7, f108_local9
end