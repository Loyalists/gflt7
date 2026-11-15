-- 6815c9c1b1204d9a5e2dc24b972da4b7
-- This hash is used for caching, delete to decompile the file again

require( "ui.uieditor.menus.ZMHD.ZMHD_Community_Theme" )
require( "ui.uieditor.widgets.Lobby.Common.FE_ButtonPanelShaderContainer" )
require( "ui.uieditor.widgets.Lobby.LobbyStreamerBlackFade" )
require( "ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame" )
require( "ui.uieditor.widgets.Scrollbars.verticalCounterBlackMarket" )
require( "ui.uieditor.widgets.BlackMarket.CryptokeyWidget" )
require( "ui.uieditor.widgets.Lobby.Common.FE_Menu_LeftGraphics" )
require( "ui.uieditor.widgets.BlackMarket.BlackMarketSafeAreaContainer" )
require( "ui.uieditor.widgets.BlackMarket.BM_TopNavBtn" )
require( "ui.uieditor.widgets.BlackMarket.BM_Promo" )
require( "ui.uieditor.widgets.BlackMarket.BM_GunMeter" )

DataSources.BurnDupeProgress = {
	getModel = function ( controller )
		CoD.OverlayUtility.UpdateBurnDupeProgress()
		return Engine.CreateModel( Engine.GetGlobalModel(), "BurnDupeProgress" )
	end
}
DataSources.AutoeventsCycled = {
	getModel = function ( controller )
		local autoeventsModel = Engine.CreateModel( Engine.GetGlobalModel(), "autoevents" )
		local cycledModel = Engine.CreateModel( autoeventsModel, "cycled" )
		if not Engine.GetModelValue( cycledModel ) then
			Engine.SetModelValue( cycledModel, 1 )
		end
		return autoeventsModel
	end
}
DataSources.AutoeventsBribeTimer = {
	getModel = function ( controller )
		local autoeventsModel = Engine.CreateModel( Engine.GetGlobalModel(), "autoevents" )
		local autoevent_timer_bribeModel = Engine.CreateModel( autoeventsModel, "autoevent_timer_bribe" )
		local autoevent_timer_lootbundle_promoModel = Engine.CreateModel( autoeventsModel, "autoevent_timer_lootbundle_promo" )
		local autoevent_timer_trifecta_promoModel = Engine.CreateModel( autoeventsModel, "autoevent_timer_trifecta_promo" )
		local autoevent_timer_limited_timeModel = Engine.CreateModel( autoeventsModel, "autoevent_timer_limited_time" )
		local autoevent_timer_rare100Model = Engine.CreateModel( autoeventsModel, "autoevent_timer_rare100" )
		local autoevent_timer_rare_nodupe_20bundleModel = Engine.CreateModel( autoeventsModel, "autoevent_timer_rare_nodupe_20bundle" )
		local autoevent_timer_grandslamModel = Engine.CreateModel( autoeventsModel, "autoevent_timer_grandslam" )
		local autoevent_timer_rare_bundle_10for5Model = Engine.CreateModel( autoeventsModel, "autoevent_timer_rare_bundle_10for5" )
		if not Engine.GetModelValue( autoevent_timer_bribeModel ) then
			Engine.SetModelValue( autoevent_timer_bribeModel, "00:00:00" )
		end
		if not Engine.GetModelValue( autoevent_timer_rare_bundle_10for5Model ) then
			Engine.SetModelValue( autoevent_timer_rare_bundle_10for5Model, "00:00:00" )
		end
		if not Engine.GetModelValue( autoevent_timer_trifecta_promoModel ) then
			Engine.SetModelValue( autoevent_timer_trifecta_promoModel, "00:00:00" )
		end
		if not Engine.GetModel( autoeventsModel, "autoevent_timer_bribe_red" ) then
			Engine.SetModelValue( Engine.CreateModel( autoeventsModel, "autoevent_timer_bribe_red" ), false )
		end
		if not Engine.GetModel( autoeventsModel, "autoevent_timer_lootbundle_promo_red" ) then
			Engine.SetModelValue( Engine.CreateModel( autoeventsModel, "autoevent_timer_lootbundle_promo_red" ), false )
		end
		if not Engine.GetModel( autoeventsModel, "autoevent_timer_trifecta_promo_red" ) then
			Engine.SetModelValue( Engine.CreateModel( autoeventsModel, "autoevent_timer_trifecta_promo_red" ), false )
		end
		if not Engine.GetModel( autoeventsModel, "autoevent_timer_rare_nodupe_20bundle_red" ) then
			Engine.SetModelValue( Engine.CreateModel( autoeventsModel, "autoevent_timer_rare_nodupe_20bundle_red" ), false )
		end
		return autoeventsModel
	end
}
CoD.OverlayUtility.UpdateBurnDupeProgress = function ()
	local burnDupeProgress = Engine.GetBurnDupeProgress()
	if burnDupeProgress == nil then
		burnDupeProgress = {
			total = 0,
			processed = 0
		}
	end
	local burnDupeProgressModel = Engine.CreateModel( Engine.GetGlobalModel(), "BurnDupeProgress" )
	Engine.SetModelValue( Engine.CreateModel( burnDupeProgressModel, "total" ), burnDupeProgress.total )
	Engine.SetModelValue( Engine.CreateModel( burnDupeProgressModel, "processed" ), burnDupeProgress.processed )
	local value = 0
	if burnDupeProgress.processed > 0 and burnDupeProgress.total > 0 then
		value = burnDupeProgress.processed / burnDupeProgress.total
	end
	if value > 1 then
		value = 1
	end
	Engine.SetModelValue( Engine.CreateModel( burnDupeProgressModel, "fraction" ), value )
	Engine.SetModelValue( Engine.CreateModel( burnDupeProgressModel, "progressString" ), burnDupeProgress.processed .. " / " .. burnDupeProgress.total )
end

local openPurchaseCurrencyStore = function ( self, element, controller, purchaseInfo, menu )
	if purchaseInfo.itemCODPointCost > 0 then
		GoBackAndOpenStoreCodPointsOverlayOnParent( menu, menu.menuName, controller )
	else
		GoBackAndOpenStoreCodPointsOverlayOnParent( menu, "BMCPStore", controller )
	end
end

local openCodPointsStore = function ( self, element, controller, purchaseInfo, menu )
	OpenCodPointsStore( self, element, controller, "BMCPStore", menu )
end

local isFreeBundle = function ( purchaseInfo )
	local isFreeBundle
	if purchaseInfo.supplyDropType ~= CoD.BlackMarketUtility.DropTypes.BUNDLE or purchaseInfo.itemCODPointCost ~= 0 or purchaseInfo.itemCost ~= 0 then
		isFreeBundle = false
	else
		isFreeBundle = true
	end
	return isFreeBundle
end

CoD.OverlayUtility.AddSystemOverlay( "PurchaseSupplyDropConfirmation", {
	menuName = "SystemOverlay_Full",
	frameWidget = "CoD.SystemOverlay_BlackMarket",
	title = function ( controller, purchaseInfo )
		if isFreeBundle( purchaseInfo ) then
			return Engine.Localize( "MPUI_BM_SUPPLY_DROPS_REMAINING" )
		elseif purchaseInfo.supplyDropType == CoD.BlackMarketUtility.DropTypes.BRIBE then
			if purchaseInfo.again then
				return Engine.Localize( "MPUI_BM_BRIBE_REROLL" )
			else
				return Engine.Localize( CoD.BlackMarketUtility.GetCurrentBribePopupTitle() )
			end
		elseif (purchaseInfo.itemCODPointCost == 0 or Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost) and (purchaseInfo.itemCost == 0 or CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost) then
			return "MPUI_BM_NO_CURRENCY"
		elseif purchaseInfo.again then
			return Engine.Localize( "MENU_PURCHASE_CONFIRMAITON" )
		else
			return Engine.ToUpper( Engine.Localize( purchaseInfo.displayText ) )
		end
	end,
	description = function ( controller, purchaseInfo )
		if purchaseInfo.again then
			return purchaseInfo.displayText
		elseif isFreeBundle( purchaseInfo ) then
			local remainingBundleCount = 0
			if not IsBundleActive( controller ) then
				remainingBundleCount = remainingBundleCount + CoD.BlackMarketUtility.GetCurrentBundleCount( controller )
			end
			if not IsHundredBundleActive( controller ) then
				remainingBundleCount = remainingBundleCount + CoD.BlackMarketUtility.GetCurrentHundredBundleCount( controller )
			end
			if not IsRareBundle10for5Active( controller ) then
				remainingBundleCount = remainingBundleCount + CoD.BlackMarketUtility.GetCurrentRareBundle10for5Count( controller )
			end
			if not IsRare20BundleActive( controller ) then
				remainingBundleCount = remainingBundleCount + CoD.BlackMarketUtility.GetCurrentRare20BundleCount( controller )
			end
			if not IsRare20LDBundleActive( controller ) then
				remainingBundleCount = remainingBundleCount + CoD.BlackMarketUtility.GetCurrentRare20LDBundleCount( controller )
			end
			return Engine.Localize( "MPUI_BM_OPEN_REMAINING_CRATES", remainingBundleCount )
		elseif (purchaseInfo.supplyDropType == CoD.BlackMarketUtility.DropTypes.BRIBE or purchaseInfo.supplyDropType == CoD.BlackMarketUtility.DropTypes.BUNDLE or purchaseInfo.supplyDropType == CoD.BlackMarketUtility.DropTypes.HUNDRED_BUNDLE or purchaseInfo.supplyDropType == CoD.BlackMarketUtility.DropTypes.RARE_BUNDLE_10FOR5 or purchaseInfo.supplyDropType == CoD.BlackMarketUtility.DropTypes.RARE_20BUNDLE) and purchaseInfo.itemCODPointCost > 0 and Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost then
			if purchaseInfo.displayText == "MPUI_BM_BRIBE_3X_GESTURES_TAUNTS" then
				purchaseInfo.displayText = "MPUI_BM_BRIBE_3X_GESTURES_TAUNTS_PROMO_TITLE"
			end
			return Engine.Localize( "MPUI_BM_NO_CODPOINTS_DESCRIPTION", purchaseInfo.displayText )
		elseif purchaseInfo.itemCODPointCost > 0 and Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost and (purchaseInfo.itemCost == 0 or CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost) then
			return Engine.Localize( "MPUI_BM_NO_CURRENCY_DESCRIPTION", purchaseInfo.displayText )
		elseif purchaseInfo.itemCODPointCost == 0 and CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost then
			return Engine.Localize( "MPUI_BM_NOT_ENOUGH_CRYPTOKEYS" )
		elseif purchaseInfo.supplyDropType == CoD.BlackMarketUtility.DropTypes.BRIBE then
			return Engine.Localize( CoD.BlackMarketUtility.GetCurrentBribePopupDescription() )
		elseif purchaseInfo.itemCODPointCost == 0 then
			return Engine.Localize( "MPUI_BM_PURCHASE_CONFIRMATION_KEYS_TEXT", purchaseInfo.displayText )
		elseif purchaseInfo.itemCost == 0 then
			return Engine.Localize( "MPUI_BM_PURCHASE_CONFIRMATION_CODPOINTS_TEXT", purchaseInfo.displayText )
		else
			return Engine.Localize( "MPUI_BM_PURCHASE_CONFIRMATION_TEXT", purchaseInfo.displayText )
		end
	end,
	image = function ( controller, purchaseInfo )
		return purchaseInfo.image
	end,
	cost = function ( controller, purchaseInfo )
		return purchaseInfo.itemCost
	end,
	codpointcost = function ( controller, purchaseInfo )
		return purchaseInfo.itemCODPointCost
	end,
	supplyDropType = function ( controller, purchaseInfo )
		return purchaseInfo.supplyDropType
	end,
	["cryptoKeyType.rarity"] = function ( controller, purchaseInfo )
		if purchaseInfo.supplyDropType == CoD.BlackMarketUtility.DropTypes.NO_DUPES_CRATE then
			return "MPUI_BM_RARE"
		else
			return CoD.BlackMarketUtility.GetCrateTypeString( purchaseInfo.supplyDropType )
		end
	end,
	categoryType = CoD.OverlayUtility.OverlayTypes.GenericMessage,
	state = "PurchaseSupplyDrop",
	listDatasource = function ( controller, purchaseInfo )
		DataSources.PurchaseSupplyDropMenuList = DataSourceHelpers.ListSetup( "PurchaseSupplyDropMenuList", function ( controller, list )
			local items = {}
			if list.purchasingBundle then
				return {}
			end
			local createPurchaseOption = function ( displayText, action, f17_arg2, f17_arg3 )
				return {
					models = {
						displayText = displayText,
						disabled = f17_arg3
					},
					properties = {
						action = action,
						actionParam = purchaseInfo,
						selectIndex = f17_arg2,
						disabledAllowNav = true
					}
				}
			end
			
			if list.purchasedBundle then
				local action = function ( f18_arg0, f18_arg1, controller, f18_arg3, menu, f18_arg5 )
					f18_arg3.supplyDropType = list.purchasedBundleType
					CoD.BlackMarketUtility.TradeForCrateAction( f18_arg0, f18_arg1, controller, f18_arg3, GoBack( menu, controller ), Enum.InventoryCurrency.INVENTORY_CURRENCY_MP_BUNDLE_ITEM, list )
				end
				
				local action2 = function ( self, element, controller, purchaseInfo, menu )
					GoBack( menu, controller )
				end
				
				if list.purchasedBundleType == CoD.BlackMarketUtility.DropTypes.GRAND_SLAM then
					table.insert( items, createPurchaseOption( "MENU_CONTINUE_CAPS", action2, true, false ) )
				else
					table.insert( items, createPurchaseOption( "MPUI_BM_OPEN_BUNDLE_NOW", action, true, false ) )
				end
				return items
			end
			local action = function ( self, element, controller, purchaseInfo, menu )
				CoD.BlackMarketUtility.TradeForCrateAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_MP_CRYPTO_KEYS, list )
			end
			
			local action2 = function ( self, element, controller, purchaseInfo, menu )
				CoD.BlackMarketUtility.TradeForCrateAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_COD_POINTS, list )
			end
			
			local action3 = function ( self, element, controller, purchaseInfo, menu )
				menu = GoBack( menu, controller )
				purchaseInfo.supplyDropType = CoD.BlackMarketUtility.DropTypes.RARE
				if not IsRare20LDBundleActive( controller ) and CoD.BlackMarketUtility.GetCurrentRare20LDBundleCount( controller ) > 0 then
					purchaseInfo.supplyDropType = CoD.BlackMarketUtility.DropTypes.RARE_20LDBUNDLE
				end
				CoD.BlackMarketUtility.TradeForCrateAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_MP_BUNDLE_ITEM, list )
			end
			
			local action4 = function ( self, element, controller, purchaseInfo, menu )
				menu = GoBack( menu, controller )
				purchaseInfo.supplyDropType = CoD.BlackMarketUtility.DropTypes.HUNDRED_BUNDLE
				CoD.BlackMarketUtility.TradeForCrateAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_MP_BUNDLE_ITEM, list )
			end
			
			local action5 = function ( self, element, controller, purchaseInfo, menu )
				menu = GoBack( menu, controller )
				purchaseInfo.supplyDropType = CoD.BlackMarketUtility.DropTypes.RARE_BUNDLE_10FOR5
				CoD.BlackMarketUtility.TradeForCrateAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_MP_BUNDLE_ITEM, list )
			end
			
			local action6 = function ( self, element, controller, purchaseInfo, menu )
				menu = GoBack( menu, controller )
				purchaseInfo.supplyDropType = CoD.BlackMarketUtility.DropTypes.RARE_20BUNDLE
				CoD.BlackMarketUtility.TradeForCrateAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_MP_BUNDLE_ITEM, list )
			end
			
			local action7 = function ( self, element, controller, purchaseInfo, menu )
				menu = GoBack( menu, controller )
				purchaseInfo.supplyDropType = CoD.BlackMarketUtility.DropTypes.RARE_20LDBUNDLE
				CoD.BlackMarketUtility.TradeForCrateAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_MP_BUNDLE_ITEM, list )
			end
			
			local action8 = function ( self, element, controller, purchaseInfo, menu )
				GoBack( menu, controller )
			end
			
			if isFreeBundle( purchaseInfo ) then
				local action = action3
				if IsBundleActive( controller ) and not IsHundredBundleActive( controller ) and CoD.BlackMarketUtility.GetCurrentHundredBundleCount( controller ) > 0 then
					action = action4
				end
				if IsBundleActive( controller ) and not IsRareBundle10for5Active( controller ) and CoD.BlackMarketUtility.GetCurrentRareBundle10for5Count( controller ) > 0 then
					action = action5
				end
				if IsBundleActive( controller ) and not IsRare20BundleActive( controller ) and CoD.BlackMarketUtility.GetCurrentRare20BundleCount( controller ) > 0 then
					action = action6
				end
				if IsBundleActive( controller ) and not IsRare20LDBundleActive( controller ) and CoD.BlackMarketUtility.GetCurrentRare20LDBundleCount( controller ) > 0 then
					action = action7
				end
				table.insert( items, createPurchaseOption( "MPUI_BM_OPEN_BUNDLE_NOW", action, true, false ) )
				table.insert( items, createPurchaseOption( "MPUI_BM_OPEN_BUNDLE_LATER", action8, false, false ) )
			elseif purchaseInfo.itemCODPointCost > 0 and Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost and (purchaseInfo.itemCost == 0 or CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost) then
				table.insert( items, createPurchaseOption( "MPUI_PURCHASE_CODPOINTS_CAPS", openPurchaseCurrencyStore, true, false ) )
				table.insert( items, createPurchaseOption( "MENU_CANCEL_CAPS", action8, false, false ) )
			elseif purchaseInfo.itemCODPointCost == 0 and CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost then
				table.insert( items, createPurchaseOption( "MENU_CONTINUE_CAPS", action8, false, false ) )
			else
				if purchaseInfo.itemCost > 0 then
					table.insert( items, createPurchaseOption( Engine.Localize( "MPUI_BM_TRADE_CRYPTOKEYS", purchaseInfo.itemCost ), action, true, CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost ) )
				end
				if purchaseInfo.itemCODPointCost > 0 then
					table.insert( items, createPurchaseOption( Engine.Localize( "MPUI_BM_TRADE_COD_POINTS", purchaseInfo.itemCODPointCost ), action2, false, Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost ) )
				end
				if purchaseInfo.supplyDropType == CoD.BlackMarketUtility.DropTypes.RARE then
					if not IsBundleActive( controller ) then
						local f16_local10 = CoD.BlackMarketUtility.GetCurrentBundleCount( controller ) + CoD.BlackMarketUtility.GetCurrentHundredBundleCount( controller ) + CoD.BlackMarketUtility.GetCurrentRareBundle10for5Count( controller ) + CoD.BlackMarketUtility.GetCurrentRare20BundleCount( controller )
						if f16_local10 > 0 then
							table.insert( items, createPurchaseOption( Engine.Localize( "MPUI_BM_OPEN_REMAINING_BUNDLE", f16_local10 ), action3, false, false ) )
						end
					elseif not IsHundredBundleActive( controller ) then
						local hundredBundleCount = CoD.BlackMarketUtility.GetCurrentHundredBundleCount( controller )
						if hundredBundleCount > 0 then
							table.insert( items, createPurchaseOption( Engine.Localize( "MPUI_BM_OPEN_REMAINING_BUNDLE", hundredBundleCount ), action4, false, false ) )
						end
					elseif not IsRareBundle10for5Active( controller ) then
						local rareBundle10for5Count = CoD.BlackMarketUtility.GetCurrentRareBundle10for5Count( controller )
						if rareBundle10for5Count > 0 then
							table.insert( items, createPurchaseOption( Engine.Localize( "MPUI_BM_OPEN_REMAINING_BUNDLE", rareBundle10for5Count ), action5, false, false ) )
						end
					elseif not IsRare20BundleActive( controller ) then
						local rare20BundleCount = CoD.BlackMarketUtility.GetCurrentRare20BundleCount( controller )
						if rare20BundleCount > 0 then
							table.insert( items, createPurchaseOption( Engine.Localize( "MPUI_BM_OPEN_REMAINING_BUNDLE", rare20BundleCount ), action6, false, false ) )
						end
					elseif not IsRare20LDBundleActive( controller ) then
						local rare20LDBundleCount = CoD.BlackMarketUtility.GetCurrentRare20LDBundleCount( controller )
						if rare20LDBundleCount > 0 then
							table.insert( items, createPurchaseOption( Engine.Localize( "MPUI_BM_OPEN_REMAINING_BUNDLE", rare20LDBundleCount ), action7, false, false ) )
						end
					end
				end
				table.insert( items, createPurchaseOption( "MENU_CANCEL_CAPS", action8, false, false ) )
			end
			return items
		end, true )
		return "PurchaseSupplyDropMenuList"
	end,
	[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack,
	postCreateStep = function ( f28_arg0, f28_arg1, f28_arg2, f28_arg3 )
		if f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.BRIBE then
			local loot_bribeCrate_dwid = Dvar.loot_bribeCrate_dwid:get()
			f28_arg0:subscribeToGlobalModel( f28_arg1, "AutoeventsCycled", "cycled", function ()
				if loot_bribeCrate_dwid ~= Dvar.loot_bribeCrate_dwid:get() or loot_bribeCrate_dwid == 0 then
					DelayGoBack( f28_arg0, f28_arg1 )
				end
			end )
		end
		if f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.RARE then
			local isLootSaleActive = IsLootSaleActive( f28_arg1 )
			f28_arg0:subscribeToGlobalModel( f28_arg1, "AutoeventsCycled", "cycled", function ()
				if isLootSaleActive ~= IsLootSaleActive( f28_arg1 ) then
					DelayGoBack( f28_arg0, f28_arg1 )
				end
			end )
		end
		if f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.BUNDLE then
			local isBundleActive = IsBundleActive( f28_arg1 )
			f28_arg0:subscribeToGlobalModel( f28_arg1, "AutoeventsCycled", "cycled", function ()
				if isBundleActive ~= IsBundleActive( f28_arg1 ) then
					DelayGoBack( f28_arg0, f28_arg1 )
				end
			end )
		end
		if f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.HUNDRED_BUNDLE then
			local isHundredBundleActive = IsHundredBundleActive( f28_arg1 )
			f28_arg0:subscribeToGlobalModel( f28_arg1, "AutoeventsCycled", "cycled", function ()
				if isHundredBundleActive ~= IsHundredBundleActive( f28_arg1 ) then
					DelayGoBack( f28_arg0, f28_arg1 )
				end
			end )
		end
		if f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.RARE_BUNDLE_10FOR5 then
			local isRareBundle10for5Active = IsRareBundle10for5Active( f28_arg1 )
			f28_arg0:subscribeToGlobalModel( f28_arg1, "AutoeventsCycled", "cycled", function ()
				if isRareBundle10for5Active ~= IsRareBundle10for5Active( f28_arg1 ) then
					DelayGoBack( f28_arg0, f28_arg1 )
				end
			end )
		end
		if f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.Rare_20Bundle then
			local isRare20BundleActive = IsRare20BundleActive( f28_arg1 )
			f28_arg0:subscribeToGlobalModel( f28_arg1, "AutoeventsCycled", "cycled", function ()
				if startingRare20BundleState ~= IsRare20BundleActive( f28_arg1 ) then
					DelayGoBack( f28_arg0, f28_arg1 )
				end
			end )
		end
		if f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.Rare_20LDBundle then
			local isRare20LDBundleActive = IsRare20LDBundleActive( f28_arg1 )
			f28_arg0:subscribeToGlobalModel( f28_arg1, "AutoeventsCycled", "cycled", function ()
				if startingRare20LDBundleState ~= IsRare20LDBundleActive( f28_arg1 ) then
					DelayGoBack( f28_arg0, f28_arg1 )
				end
			end )
		end
		if f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.NO_DUPES_CRATE or f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.NO_DUPES_BUNDLE then
			local isNoDupesPromoActive = IsNoDupesPromoActive( f28_arg1 )
			f28_arg0:subscribeToGlobalModel( f28_arg1, "AutoeventsCycled", "cycled", function ()
				if isNoDupesPromoActive ~= IsNoDupesPromoActive( f28_arg1 ) then
					DelayGoBack( f28_arg0, f28_arg1 )
				end
			end )
		end
		if f28_arg3.supplyDropType == CoD.BlackMarketUtility.DropTypes.GRAND_SLAM then
			local isGrandSlamActive = IsGrandSlamActive( f28_arg1 )
			f28_arg0:subscribeToGlobalModel( f28_arg1, "AutoeventsCycled", "cycled", function ()
				if isGrandSlamActive ~= IsGrandSlamActive( f28_arg1 ) then
					DelayGoBack( f28_arg0, f28_arg1 )
				end
			end )
		end
	end
} )
CoD.OverlayUtility.AddSystemOverlay( "BurnDuplicatesConfirmation", {
	menuName = "SystemOverlay_Full",
	frameWidget = "CoD.SystemOverlay_BlackMarket",
	title = function ( controller, purchaseInfo )
		if purchaseInfo == nil or purchaseInfo == -1 then
			return Engine.Localize( "MPUI_BM_BURN_CONFIRMATION_NODUPES" )
		else
			return Engine.Localize( "MPUI_BM_BURN_CONFIRMATION" )
		end
	end,
	description = function ( controller, purchaseInfo )
		if purchaseInfo == nil or purchaseInfo == -1 then
			return Engine.Localize( "MPUI_BM_BURN_DUPLICATE_DESCRIPTION_NO_DUPLICATES" )
		elseif purchaseInfo == 0 then
			return Engine.Localize( "MPUI_BM_BURN_DUPLICATE_DESCRIPTION_NONE" )
		elseif purchaseInfo == 1 then
			return Engine.Localize( "MPUI_BM_BURN_DUPLICATE_DESCRIPTION_ONE" )
		else
			return Engine.Localize( "MPUI_BM_BURN_DUPLICATE_DESCRIPTION_MULTIPLE", purchaseInfo )
		end
	end,
	image = "uie_t7_blackmarket_bribe",
	categoryType = CoD.OverlayUtility.OverlayTypes.GenericMessage,
	state = "BurnDuplicates",
	totalDuplicates = CoD.BlackMarketUtility.GetNumDupesTotal,
	commonDuplicates = function ( f40_arg0 )
		return CoD.BlackMarketUtility.GetNumDupesForType( f40_arg0, Enum.LootRarityType.LOOT_RARITY_TYPE_COMMON )
	end,
	rareDuplicates = function ( f41_arg0 )
		return CoD.BlackMarketUtility.GetNumDupesForType( f41_arg0, Enum.LootRarityType.LOOT_RARITY_TYPE_RARE )
	end,
	legendaryDuplicates = function ( f42_arg0 )
		return CoD.BlackMarketUtility.GetNumDupesForType( f42_arg0, Enum.LootRarityType.LOOT_RARITY_TYPE_LEGENDARY )
	end,
	epicDuplicates = function ( f43_arg0 )
		return CoD.BlackMarketUtility.GetNumDupesForType( f43_arg0, Enum.LootRarityType.LOOT_RARITY_TYPE_EPIC )
	end,
	listDatasource = function ( f44_arg0 )
		DataSources.BurnDuplicatesMenuList = DataSourceHelpers.ListSetup( "BurnDuplicatesMenuList", function ( controller, list )
			local items = {}
			local createBurnOption = function ( displayText, action, f46_arg2 )
				return {
					models = {
						displayText = displayText
					},
					properties = {
						action = action,
						selectIndex = f46_arg2
					}
				}
			end
			
			local finishedBurningDuplicates = list.finishedBurningDuplicates
			if not finishedBurningDuplicates and CoD.BlackMarketUtility.GetNumDupesTotal( controller ) == 0 and not list.isBurningDuplicates then
				finishedBurningDuplicates = true
			end
			if finishedBurningDuplicates then
				local action = function ( self, element, controller, purchaseInfo, menu )
					GoBack( menu, controller )
				end
				
				local f45_local4 = {}
				return createBurnOption( "MENU_OK_CAPS", action, true )
			elseif list.isBurningDuplicates then
				return {}
			end
			local action = function ( self, element, controller, purchaseInfo, menu )
				if list.isBurningDuplicates then
					return 
				end
				local f48_local0 = Engine.GetLobbyUIScreen()
				if f48_local0 ~= LobbyData.UITargets.UI_MPLOBBYONLINE.id and f48_local0 ~= LobbyData.UITargets.UI_MPLOBBYONLINEPUBLICGAME.id and f48_local0 ~= LobbyData.UITargets.UI_MPLOBBYONLINEARENA.id and f48_local0 ~= LobbyData.UITargets.UI_MPLOBBYONLINEARENAGAME.id then
					GoBack( menu, controller )
					LuaUtils.UI_ShowErrorMessageDialog( controller, "MPUI_BM_BURN_DUPLICATES_FAILED", "" )
				end
				if Engine.BurnLootDuplicates == nil or not Engine.BurnLootDuplicates( controller, Enum.eModes.MODE_MULTIPLAYER ) then
					GoBack( menu, controller )
					LuaUtils.UI_ShowErrorMessageDialog( controller, "MPUI_BM_BURN_DUPLICATES_FAILED", "" )
					return 
				end
				list.isBurningDuplicates = true
				menu[CoD.OverlayUtility.GoBackPropertyName] = nil
				list.disabled = true
				self:setState( "BurningDuplicates" )
				self.BurningDuplicatesAnimation:playClip( "StartBurning" )
				self.BurningDuplicatesAnimation.nextClip = "Burning"
				list:updateDataSource( true )
				CoD.Menu.UpdateAllButtonPrompts( menu, controller )
				local f48_local1 = CoD.BlackMarketUtility.GetProgressTowardNextKey( controller ) * CoD.BlackMarketUtility.XPPerCryptoKey + CoD.BlackMarketUtility.GetXPEarnedForBurning( controller, CoD.BlackMarketUtility.GetNumDupesForType( controller, Enum.LootRarityType.LOOT_RARITY_TYPE_COMMON ), CoD.BlackMarketUtility.GetNumDupesForType( controller, Enum.LootRarityType.LOOT_RARITY_TYPE_RARE ), CoD.BlackMarketUtility.GetNumDupesForType( controller, Enum.LootRarityType.LOOT_RARITY_TYPE_LEGENDARY ), CoD.BlackMarketUtility.GetNumDupesForType( controller, Enum.LootRarityType.LOOT_RARITY_TYPE_EPIC ) )
				if Dvar.ui_cryptocommondupes:exists() then
					Dvar.ui_cryptocommondupes:set( 0 )
					Dvar.ui_cryptoraredupes:set( 0 )
					Dvar.ui_cryptolegendarydupes:set( 0 )
					Dvar.ui_cryptoepicdupes:set( 0 )
				end
				Engine.PlaySound( "uin_bm_keyburn_loop" )
				CoD.OverlayUtility.UpdateBurnDupeProgress()
				self.BurningDuplicatesAnimation:registerEventHandler( "clip_over", function ( element, event )
					local f49_local0 = Engine.GetBurnDupeState()
					if Engine.IsInventoryBusy( controller ) or f49_local0 == Enum.LootBurnDupeState.LOOT_BURN_DUPE_REQUESTED or f49_local0 == Enum.LootBurnDupeState.LOOT_BURN_DUPE_BUSY then
						CoD.OverlayUtility.UpdateBurnDupeProgress()
						Engine.PlaySound( "uin_bm_keyburn_loop" )
						LUI.UIElement.clipOver( element, event )
					else
						CoD.OverlayUtility.UpdateBurnDupeProgress()
						Engine.PlaySound( "uin_bm_keyburn_loop" )
						element:playClip( "StopBurning" )
						element:registerEventHandler( "clip_over", function ( element, event )
							Engine.PlaySound( "uin_bm_keyburn_done" )
							CoD.OverlayUtility.UpdateBurnDupeProgress()
							element:registerEventHandler( "clip_over", LUI.UIElement.clipOver )
							list.finishedBurningDuplicates = true
							menu[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack()
							list.disabled = false
							CoD.Menu.UpdateAllButtonPrompts( menu, controller )
							if f49_local0 == Enum.LootBurnDupeState.LOOT_BURN_DUPE_FAILED then
								GoBack( menu, controller )
								LuaUtils.UI_ShowErrorMessageDialog( controller, "MPUI_BM_BURN_DUPLICATES_FAILED", "" )
								return 
							end
							self:setState( "BurnedDuplicates" )
							local f50_local0 = math.floor( f48_local1 / CoD.BlackMarketUtility.XPPerCryptoKey )
							local text = self.textForBurning.text
							local f50_local2 = text
							text = text.setText
							local localize = Engine.Localize
							local f50_local4
							if f50_local0 == 1 then
								f50_local4 = "MPUI_BM_BURNED_DESC_EARNED_ONE"
								if not f50_local4 then
								
								else
									text( f50_local2, localize( f50_local4, f50_local0 ) )
									list:updateDataSource()
								end
							end
							f50_local4 = "MPUI_BM_BURNED_DESC"
						end )
					end
				end )
				SendFrontendControllerZeroMenuResponse( controller, "BlackMarket", "burn_duplicates" )
			end
			
			local action2 = function ( self, element, controller, purchaseInfo, menu )
				if list.isBurningDuplicates then
					return 
				else
					GoBack( menu, controller )
				end
			end
			
			if Dvar.tu4_burnDuplicates:exists() and (Dvar.tu4_burnDuplicates:get() == true or Dvar.tu4_burnDuplicates:get() == "1") then
				table.insert( items, createBurnOption( "MPUI_BURN_DUPLICATES_CAPS", action, false ) )
			end
			table.insert( items, createBurnOption( "MENU_CANCEL_CAPS", action2, true ) )
			return items
		end, true )
		return "BurnDuplicatesMenuList"
	end,
	[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack
} )
CoD.OverlayUtility.AddSystemOverlay( "PurchaseTrifectaConfirmation", {
	menuName = "SystemOverlay_Full",
	frameWidget = "CoD.SystemOverlay_BlackMarket",
	title = function ( controller, purchaseInfo )
		if (purchaseInfo.itemCODPointCost == 0 or Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost) and (purchaseInfo.itemCost == 0 or CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost) then
			return "MPUI_BM_NO_CURRENCY"
		else
			return Engine.ToUpper( Engine.Localize( purchaseInfo.displayText ) )
		end
	end,
	description = function ( controller, purchaseInfo )
		if purchaseInfo.itemCODPointCost > 0 and Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost and purchaseInfo.itemCost > 0 and CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost then
			return Engine.Localize( "MPUI_BM_NO_CURRENCY_DESCRIPTION", purchaseInfo.displayText )
		elseif purchaseInfo.itemCost == 0 and Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost then
			return Engine.Localize( "MPUI_BM_TRIFECTA_NEED_CODPOINTS", purchaseInfo.displayText )
		elseif purchaseInfo.itemCODPointCost == 0 and CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost then
			return Engine.Localize( "MPUI_BM_TRIFECTA_NEED_CRYPTOKEYS", purchaseInfo.displayText )
		elseif purchaseInfo.itemCODPointCost == 0 then
			return Engine.Localize( "MPUI_BM_PURCHASE_CONFIRMATION_KEYS_TEXT", purchaseInfo.displayText )
		elseif purchaseInfo.itemCost == 0 then
			return Engine.Localize( "MPUI_BM_PURCHASE_CONFIRMATION_CODPOINTS_TEXT", purchaseInfo.displayText )
		else
			return Engine.Localize( "MPUI_BM_PURCHASE_CONFIRMATION_TEXT", purchaseInfo.displayText )
		end
	end,
	image = "t7_blackmarket_promo_triple_play",
	cost = function ( controller, purchaseInfo )
		return purchaseInfo.itemCost
	end,
	codpointcost = function ( controller, purchaseInfo )
		return purchaseInfo.itemCODPointCost
	end,
	supplyDropType = CoD.BlackMarketUtility.DropTypes.TRIFECTA,
	categoryType = CoD.OverlayUtility.OverlayTypes.GenericMessage,
	state = "PurchaseSupplyDrop",
	listDatasource = function ( controller, purchaseInfo )
		DataSources.PurchaseTrifectaMenuList = DataSourceHelpers.ListSetup( "PurchaseTrifectaMenuList", function ( controller, list )
			local items = {}
			if list.purchasingBundle then
				return {}
			end
			local createPurchaseOption = function ( displayText, action, f58_arg2, f58_arg3 )
				return {
					models = {
						displayText = displayText,
						disabled = f58_arg3
					},
					properties = {
						action = action,
						actionParam = purchaseInfo,
						selectIndex = f58_arg2
					}
				}
			end
			
			local action = function ( self, element, controller, purchaseInfo, menu )
				local trifecta_cryptokeys_sku = Dvar.trifecta_cryptokeys_sku:get()
				if trifecta_cryptokeys_sku then
					CoD.BlackMarketUtility.TradeForTrifectaAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_MP_CRYPTO_KEYS, list, trifecta_cryptokeys_sku )
				end
			end
			
			local action2 = function ( self, element, controller, purchaseInfo, menu )
				local trifecta_cod_points_sku = Dvar.trifecta_cod_points_sku:get()
				if trifecta_cod_points_sku then
					CoD.BlackMarketUtility.TradeForTrifectaAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_COD_POINTS, list, trifecta_cod_points_sku )
				end
			end
			
			local action3 = function ( self, element, controller, purchaseInfo, menu )
				GoBack( menu, controller )
			end
			
			if list.purchasedBundle then
				table.insert( items, createPurchaseOption( "MENU_CONTINUE_CAPS", action3, true, false ) )
				return items
			elseif purchaseInfo.itemCODPointCost > 0 and Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost and (purchaseInfo.itemCost == 0 or CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost) then
				table.insert( items, createPurchaseOption( "MPUI_PURCHASE_CODPOINTS_CAPS", openPurchaseCurrencyStore, true, false ) )
				table.insert( items, createPurchaseOption( "MENU_CANCEL_CAPS", action3, false, false ) )
			elseif purchaseInfo.itemCODPointCost == 0 and CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost then
				table.insert( items, createPurchaseOption( "MENU_CONTINUE_CAPS", action3, false, false ) )
			else
				if purchaseInfo.itemCost > 0 then
					table.insert( items, createPurchaseOption( Engine.Localize( "MPUI_BM_TRADE_CRYPTOKEYS", purchaseInfo.itemCost ), action, true, CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) < purchaseInfo.itemCost ) )
				end
				if purchaseInfo.itemCODPointCost > 0 then
					table.insert( items, createPurchaseOption( Engine.Localize( "MPUI_BM_TRADE_COD_POINTS", purchaseInfo.itemCODPointCost ), action2, false, Engine.GetCoDPoints( controller ) < purchaseInfo.itemCODPointCost ) )
				end
				table.insert( items, createPurchaseOption( "MENU_CANCEL_CAPS", action3, false, false ) )
			end
			return items
		end, true )
		return "PurchaseTrifectaMenuList"
	end,
	[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack,
	postCreateStep = function ( f62_arg0, f62_arg1, f62_arg2, f62_arg3 )
		local isTrifectaBundleActive = IsTrifectaBundleActive( f62_arg1 )
		f62_arg0:subscribeToGlobalModel( f62_arg1, "AutoeventsCycled", "cycled", function ()
			if isTrifectaBundleActive ~= IsTrifectaBundleActive( f62_arg1 ) then
				DelayGoBack( f62_arg0, f62_arg1 )
			end
		end )
	end
} )
DataSources.BlackMarketCryptokeyList = DataSourceHelpers.ListSetup( "BlackMarketCryptokeyList", function ( controller, list )
	local items = {}
	local lUI_ALIGNMENT_LEFT = Enum.LUIAlignment.LUI_ALIGNMENT_LEFT
	local f64_local2 = function ()
		if lUI_ALIGNMENT_LEFT == Enum.LUIAlignment.LUI_ALIGNMENT_LEFT then
			lUI_ALIGNMENT_LEFT = Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT
		else
			lUI_ALIGNMENT_LEFT = Enum.LUIAlignment.LUI_ALIGNMENT_LEFT
		end
	end
	
	local f64_local3 = function ( displayText, image, confirmationImage, hintText, itemCount, codPointCost, action, supplyDropType, columnSpan, displayTextTitle, rewardCount )
		if hintText == "MPUI_BM_RARE_KEY_HINT_TEXT" and Dvar.tu4_enableBonusCryptokeysHint:exists() and Dvar.tu4_enableBonusCryptokeysHint:get() == false then
			hintText = "MPUI_BM_RARE_KEY_HINT_TEXT_NOBONUS"
		end
		if not columnSpan then
			columnSpan = 1
		end
		local f66_local0 = lUI_ALIGNMENT_LEFT
		if columnSpan > 1 then
			f66_local0 = Enum.LUIAlignment.LUI_ALIGNMENT_CENTER
		else
			f64_local2()
		end
		return {
			models = {
				displayText = displayText,
				displayTextTitle = displayTextTitle or displayText,
				image = image,
				hintText = hintText,
				itemCount = itemCount,
				itemCODPointCost = codPointCost,
				rewardCount = rewardCount,
				hintTextAlign = f66_local0
			},
			properties = {
				action = action,
				supplyDropType = supplyDropType,
				actionParam = {
					displayText = displayText,
					image = confirmationImage,
					itemCost = itemCount,
					itemCODPointCost = codPointCost,
					supplyDropType = supplyDropType
				},
				columnSpan = columnSpan
			}
		}
	end
	
	local f64_local4 = function ( self, element, controller, purchaseInfo, menu )
		CoD.OverlayUtility.CreateOverlay( controller, self, "PurchaseSupplyDropConfirmation", controller, purchaseInfo )
	end
	
	local f64_local5 = function ( self, element, controller, purchaseInfo, menu )
		purchaseInfo.vials = tonumber( Dvar.loot_vialsFromKeysOffer:get() )
		purchaseInfo.isCryptokeys = true
		purchaseInfo.cryptokeyCost = purchaseInfo.itemCost
		CoD.OverlayUtility.CreateOverlay( controller, self, "PurchaseVialsConfirmation", controller, purchaseInfo )
	end
	
	local action = function ( self, element, controller, purchaseInfo, menu )
		CoD.BlackMarketUtility.TradeForCrateAction( self, element, controller, purchaseInfo, menu, Enum.InventoryCurrency.INVENTORY_CURRENCY_MP_BUNDLE_ITEM, items )
	end
	
	local f64_local7 = function ( self, element, controller, purchaseInfo, menu )
		OpenOutfitStore( self, element, controller, "BlackMarket", menu, nil )
	end
	
	local f64_local8 = function ( self, element, controller, purchaseInfo, menu )
		CoD.OverlayUtility.CreateOverlay( controller, self, "PurchaseTrifectaConfirmation", controller, purchaseInfo )
	end
	
	local f64_local9 = function ( self, element, controller, purchaseInfo, menu )
		if not IsSixPackBundleInCooldown( controller ) then
			f64_local4( self, element, controller, purchaseInfo, menu )
		end
	end
	
	local f64_local10 = function ( self, element, controller, purchaseInfo, menu )
		if not IsDailyDoubleBundleInCooldown( controller ) then
			f64_local4( self, element, controller, purchaseInfo, menu )
		end
	end
	
	if IsTrifectaBundleActive( controller ) then
		local f64_local11 = 0
		local f64_local12 = 0
		if Dvar.trifecta_cryptokeys_drop_id:exists() and Engine.GetInventoryItemQuantity( controller, Dvar.trifecta_cryptokeys_drop_id:get() ) == 0 then
			f64_local11 = CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.TRIFECTA )
		end
		if Dvar.trifecta_cod_points_drop_id:exists() and Engine.GetInventoryItemQuantity( controller, Dvar.trifecta_cod_points_drop_id:get() ) == 0 then
			f64_local12 = CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.TRIFECTA )
		end
		if f64_local11 > 0 or f64_local12 > 0 then
			table.insert( items, f64_local3( "MPUI_BM_TRIFECTA", "t7_blackmarket_promo_triple_play", "t7_blackmarket_promo_triple_play", "MPUI_BM_TRIFECTA_KEY_HINT_TEXT", f64_local11, f64_local12, f64_local8, CoD.BlackMarketUtility.DropTypes.TRIFECTA, 2, "MPUI_BM_TRIFECTA_PACKAGE_DESC" ) )
		end
	end
	if CoD.BlackMarketUtility.GetCurrentBribeString() ~= nil then
		local f64_local11 = CoD.BlackMarketUtility.GetCurrentBribeString()
		local f64_local12 = CoD.BlackMarketUtility.GetCurrentBribeImage()
		table.insert( items, f64_local3( f64_local11, f64_local12, f64_local12 .. "_hover", CoD.BlackMarketUtility.GetCurrentBribeHint(), CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.BRIBE ), CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.BRIBE ), f64_local4, CoD.BlackMarketUtility.DropTypes.BRIBE, 2 ) )
	end
	if IsGrandSlamActive( controller ) then
		local f64_local11 = 0
		local f64_local12 = 0
		if Engine.GetInventoryItemQuantity( controller, CoD.BlackMarketUtility.loot_grand_slam_drop_id ) == 0 then
			f64_local12 = CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.GRAND_SLAM ) or 0
		end
		if f64_local11 > 0 or f64_local12 > 0 then
			table.insert( items, f64_local3( "MPUI_BM_GRAND_SLAM", "t7_blackmarket_crate_bribe_grandslam_large", "t7_blackmarket_crate_bribe_grandslam_large", "MPUI_BM_GRAND_SLAM_KEY_HINT_TEXT", f64_local11, f64_local12, f64_local4, CoD.BlackMarketUtility.DropTypes.GRAND_SLAM, 2, "MPUI_BM_GRAND_SLAM_PACKAGE_DESC" ) )
		end
	end
	if IsHundredBundleActive( controller ) then
		local hundredBundleCount = CoD.BlackMarketUtility.GetCurrentHundredBundleCount( controller )
		local hundredBundleImage = CoD.BlackMarketUtility.HundredBundleImage
		if hundredBundleCount > 0 then
			table.insert( items, f64_local3( CoD.BlackMarketUtility.HundredBundleTitle, hundredBundleImage, hundredBundleImage .. "_glow", Engine.Localize( "MPUI_BM_BUNDLES_REMAINING", hundredBundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.HUNDRED_BUNDLE, 2 ) )
		else
			table.insert( items, f64_local3( CoD.BlackMarketUtility.HundredBundleTitle, hundredBundleImage, hundredBundleImage .. "_glow", Engine.Localize( CoD.BlackMarketUtility.HundredBundleHint, Engine.DvarInt( nil, "loot_rare100_cpcost" ) ), 0, CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.HUNDRED_BUNDLE ), f64_local4, CoD.BlackMarketUtility.DropTypes.HUNDRED_BUNDLE, 2, "MPUI_BM_HUNDRED_BUNDLE_PROMO_DESC" ) )
		end
		list.currentHundredBundleCount = hundredBundleCount
		if not list.updateHundredBundleSubscription then
			list.updateHundredBundleSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "hundredBundles" ), function ()
				if CoD.BlackMarketUtility.GetCurrentHundredBundleCount( controller ) ~= list.currentHundredBundleCount then
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if IsRareBundle10for5Active( controller ) then
		local rareBundle10for5Count = CoD.BlackMarketUtility.GetCurrentRareBundle10for5Count( controller )
		local rareBundle10for5Image = CoD.BlackMarketUtility.RareBundle10for5Image
		if rareBundle10for5Count > 0 then
			table.insert( items, f64_local3( CoD.BlackMarketUtility.RareBundle10for5Title, rareBundle10for5Image, rareBundle10for5Image .. "_glow", Engine.Localize( "MPUI_BM_BUNDLES_REMAINING", rareBundle10for5Count ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.RARE_BUNDLE_10FOR5, 2 ) )
		else
			table.insert( items, f64_local3( CoD.BlackMarketUtility.RareBundle10for5Title, rareBundle10for5Image, rareBundle10for5Image .. "_glow", Engine.Localize( CoD.BlackMarketUtility.RareBundle10for5Hint, Engine.DvarInt( nil, "rare_bundle_10for5_cpCost" ) ), 0, CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.RARE_BUNDLE_10FOR5 ), f64_local4, CoD.BlackMarketUtility.DropTypes.RARE_BUNDLE_10FOR5, 2, "MPUI_BM_RARE_BUNDLE_10FOR5_PROMO_DESC" ) )
		end
		list.currentRareBundle10for5Count = rareBundle10for5Count
		if not list.updateRareBundle10for5Subscription then
			list.updateRareBundle10for5Subscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "rareBundle10for5s" ), function ()
				if CoD.BlackMarketUtility.GetCurrentRareBundle10for5Count( controller ) ~= list.currentRareBundle10for5Count then
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if IsRare20BundleActive( controller ) then
		local rare20BundleCount = CoD.BlackMarketUtility.GetCurrentRare20BundleCount( controller )
		local bundleImage = CoD.BlackMarketUtility.BundleImage
		if rare20BundleCount > 0 then
			table.insert( items, f64_local3( CoD.BlackMarketUtility.BundleTitle, bundleImage, bundleImage .. "_glow", Engine.Localize( "MPUI_BM_BUNDLES_REMAINING", rare20BundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.RARE_20BUNDLE, 2 ) )
		else
			table.insert( items, f64_local3( CoD.BlackMarketUtility.BundleTitle, bundleImage, bundleImage .. "_glow", Engine.Localize( CoD.BlackMarketUtility.BundleHint, 20, Engine.DvarInt( nil, "loot_bundle_cpCost" ) ), 0, Engine.DvarInt( nil, "loot_bundle_cpCost" ), f64_local4, CoD.BlackMarketUtility.DropTypes.RARE_20BUNDLE, 2, Engine.Localize( CoD.BlackMarketUtility.PromoBundleDesc, 20 ) ) )
		end
		list.currentRare20BundleCount = rare20BundleCount
		if not list.updateRare20BundleSubscription then
			list.updateRare20BundleSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "rare20Bundles" ), function ()
				if CoD.BlackMarketUtility.GetCurrentRare20BundleCount( controller ) ~= list.currentRare20BundleCount then
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if IsRare20LDBundleActive( controller ) then
		local rare20LDBundleCount = CoD.BlackMarketUtility.GetCurrentRare20LDBundleCount( controller )
		local bundleImage = CoD.BlackMarketUtility.BundleImage
		if rare20LDBundleCount > 0 then
			table.insert( items, f64_local3( "MPUI_BM_BRIBE_LDBUNDLE_BRIBE_TITLE", bundleImage, bundleImage .. "_glow", Engine.Localize( "MPUI_BM_BUNDLES_REMAINING", rare20LDBundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.RARE_20LDBUNDLE, 2 ) )
		elseif Engine.GetInventoryItemQuantity( controller, CoD.BlackMarketUtility.rare20LDPackBundleSentinel ) == 0 then
			table.insert( items, f64_local3( "MPUI_BM_BRIBE_LDBUNDLE_BRIBE_TITLE", bundleImage, bundleImage .. "_glow", "MPUI_BM_BRIBE_LDBUNDLE_BRIBE_HINT", 0, Engine.DvarInt( nil, "loot_bundle_cpCost" ), f64_local4, CoD.BlackMarketUtility.DropTypes.RARE_20LDBUNDLE, 2, "MPUI_BM_BRIBE_LDBUNDLE_BRIBE_DESC" ) )
		end
		list.currentRare20LDBundleCount = rare20LDBundleCount
		if not list.updateRare20LDBundleSubscription then
			list.updateRare20LDBundleSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "rare20LDBundles" ), function ()
				if CoD.BlackMarketUtility.GetCurrentRare20LDBundleCount( controller ) ~= list.currentRare20LDBundleCount then
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if IsRare15BundleActive( controller ) then
		local outfit3BundleCount = CoD.BlackMarketUtility.GetCurrentOutfit3BundleCount( controller )
		local rare15BundleCount = CoD.BlackMarketUtility.GetCurrentRare15BundleCount( controller )
		local bundleImage = CoD.BlackMarketUtility.BundleImage
		if rare15BundleCount == 0 and outfit3BundleCount == 0 then
			table.insert( items, f64_local3( CoD.BlackMarketUtility.BundleAndBribeTitle, bundleImage, bundleImage .. "_glow", Engine.Localize( CoD.BlackMarketUtility.BundleAndBribeHint, 15, 3, Engine.DvarInt( nil, "loot_bundle_cpCost" ) ), 0, Engine.DvarInt( nil, "loot_bundle_cpCost" ), f64_local4, CoD.BlackMarketUtility.DropTypes.RARE_15BUNDLE, 2, Engine.Localize( CoD.BlackMarketUtility.BundleAndBribeDesc, 15, 3 ) ) )
			list.currentRare15BundleCount = rare15BundleCount
			if not list.updateRare15BundleSubscription then
				list.updateRare15BundleSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "rare15Bundles" ), function ()
					if CoD.BlackMarketUtility.GetCurrentRare15BundleCount( controller ) ~= list.currentRare15BundleCount then
						list:updateDataSource( false )
					end
				end, false )
			end
			list.currentOutfit3BundleCount = outfit3BundleCount
			if not list.updateOutfit3BundleSubscription then
				list.updateOutfit3BundleSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "outfit3Bundles" ), function ()
					if CoD.BlackMarketUtility.GetCurrentOutfit3BundleCount( controller ) ~= list.currentOutfit3BundleCount then
						list:updateDataSource( false )
					end
				end, false )
			end
		end
	end
	if Dvar.show_bm_outfit_widget:exists() and Dvar.show_bm_outfit_widget:get() == "1" then
		local f64_local11 = "uie_t7_blackmarket_crate_bribe_chip"
		table.insert( items, f64_local3( "MPUI_BM_OUTFIT_STORE_TITLE", f64_local11, f64_local11 .. "_glow", Engine.Localize( "MPUI_BM_OUTFIT_STORE_HINT" ), 0, 0, f64_local7, CoD.BlackMarketUtility.DropTypes.OUTFIT_STORE, 2, "MPUI_BM_OUTFIT_STORE_TITLE" ) )
	end
	if IsBundleActive( controller ) then
		local bundleCount = CoD.BlackMarketUtility.GetCurrentBundleCount( controller )
		local bundleImage = CoD.BlackMarketUtility.BundleImage
		if bundleCount > 0 then
			table.insert( items, f64_local3( CoD.BlackMarketUtility.BundleTitle, bundleImage, bundleImage .. "_glow", Engine.Localize( "MPUI_BM_BUNDLES_REMAINING", bundleCount, Engine.DvarInt( nil, "loot_bundle_final_count" ) ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.RARE, 2 ) )
		else
			table.insert( items, f64_local3( CoD.BlackMarketUtility.BundleTitle, bundleImage, bundleImage .. "_glow", Engine.Localize( CoD.BlackMarketUtility.BundleHint, Engine.DvarInt( nil, "loot_bundle_final_count" ), Engine.DvarInt( nil, "loot_bundle_cpCost" ) ), CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.BUNDLE ), CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.BUNDLE ), f64_local4, CoD.BlackMarketUtility.DropTypes.BUNDLE, 2, Engine.Localize( CoD.BlackMarketUtility.PromoBundleDesc, Engine.DvarInt( nil, "loot_bundle_final_count" ) ) ) )
		end
		list.currentBundleCount = bundleCount
		if not list.updateBundlesSubscription then
			list.updateBundlesSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "bundles" ), function ()
				if CoD.BlackMarketUtility.GetCurrentBundleCount( controller ) ~= list.currentBundleCount then
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if IsKeysForVialsOfferActive( controller ) then
		local f64_local11 = "t7_blackmarket_divinium_chip"
		local f64_local12 = "t7_blackmarket_divinium_chip"
		local f64_local13 = tonumber( Dvar.loot_vialsCost:get() or 60 )
		local f64_local14 = 0
		local f64_local15 = tonumber( Dvar.loot_vialsFromKeysOffer:get() )
		table.insert( items, f64_local3( Engine.Localize( "MPUI_BM_OFFER_DIVINIUM", f64_local15 ), f64_local11, f64_local12, Engine.Localize( "MPUI_BM_OFFER_DIVINIUM_HINT", f64_local13, f64_local15 ), f64_local13, f64_local14, f64_local5, CoD.BlackMarketUtility.DropTypes.TRADE_KEYS_FOR_VIALS, 2 ) )
	end
	local f64_local11 = nil
	if IsLootSaleActive( controller ) then
		table.insert( items, f64_local3( "MPUI_BM_RARE_DROP", "uie_t7_blackmarket_crate_rare_focus", "uie_t7_blackmarket_crate_rare_focus", DvarLocalizedIntoStringMultiplied( "loot_salePercentOff", 100, "MPUI_BM_RARE_DROP_PROMO_HINT" ), CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.RARE ), CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.RARE ), f64_local4, CoD.BlackMarketUtility.DropTypes.RARE, 2, "MPUI_BM_RARE_DROP_PROMO_DESC" ) )
	end
	local f64_local12 = #items < 2
	local f64_local13 = f64_local3( "MPUI_BM_COMMON_DROP", "t7_blackmarket_crate_common", "uie_t7_blackmarket_crate_common_focus", "MPUI_BM_COMMON_KEY_HINT_TEXT", CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.COMMON ), CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.COMMON ), f64_local4, CoD.BlackMarketUtility.DropTypes.COMMON )
	table.insert( items, f64_local13 )
	if not IsLootSaleActive( controller ) then
		f64_local11 = f64_local3( "MPUI_BM_RARE_DROP", "t7_blackmarket_crate_rare", "uie_t7_blackmarket_crate_rare_focus", "MPUI_BM_RARE_KEY_HINT_TEXT", CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.RARE ), CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.RARE ), f64_local4, CoD.BlackMarketUtility.DropTypes.RARE )
		table.insert( items, f64_local11 )
	end
	if IsSixPackBundleActive( controller ) then
		local sixPackCommonBundleCount = CoD.BlackMarketUtility.GetCurrentSixPackCommonBundleCount( controller )
		if sixPackCommonBundleCount > 0 then
			table.insert( items, f64_local3( "MPUI_BM_SIX_PACK", "uie_t7_blackmarket_6pack_commons_closed", "uie_t7_blackmarket_6pack_commons_closed", Engine.Localize( "MPUI_BM_SIX_PACK_BUNDLES_REMAINING", sixPackCommonBundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.SIX_PACK ) )
		else
			table.insert( items, f64_local3( "MPUI_BM_SIX_PACK", "uie_t7_blackmarket_6pack_commons_closed", "uie_t7_blackmarket_6pack_commons_closed", Engine.Localize( "MPUI_BM_SIX_PACK_PROMO_HINT", Engine.DvarInt( nil, "loot_sixPack_final_count" ) ), CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.SIX_PACK ), CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.SIX_PACK ), f64_local9, CoD.BlackMarketUtility.DropTypes.SIX_PACK ) )
		end
		f64_local12 = false
		list.currentSixPackCommonBundleCount = sixPackCommonBundleCount
		if not list.updateSixPackCommonSubscription then
			list.updateSixPackCommonSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "sixPackCommonBundles" ), function ()
				local sixPackCommonBundleCount = CoD.BlackMarketUtility.GetCurrentSixPackCommonBundleCount( controller )
				if sixPackCommonBundleCount ~= list.currentSixPackCommonBundleCount then
					list.currentSixPackCommonBundleCount = sixPackCommonBundleCount
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if IsDailyDoubleBundleActive( controller ) then
		local dailyDoubleRareBundleCount = CoD.BlackMarketUtility.GetCurrentDailyDoubleRareBundleCount( controller )
		if dailyDoubleRareBundleCount > 0 then
			table.insert( items, f64_local3( "MPUI_BM_DAILY_DOUBLE", "uie_t7_blackmarket_dailydouble", "uie_t7_blackmarket_dailydouble", Engine.Localize( "MPUI_BM_BUNDLES_REMAINING", dailyDoubleRareBundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.DAILY_DOUBLE_RARE_BUNDLE ) )
		else
			table.insert( items, f64_local3( "MPUI_BM_DAILY_DOUBLE", "uie_t7_blackmarket_dailydouble", "uie_t7_blackmarket_dailydouble", Engine.Localize( "MPUI_BM_DAILY_DOUBLE_PROMO_HINT", Engine.DvarInt( nil, "loot_dailyDouble_final_count" ) ), CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.DAILY_DOUBLE ), CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.DAILY_DOUBLE ), f64_local10, CoD.BlackMarketUtility.DropTypes.DAILY_DOUBLE ) )
		end
		f64_local12 = false
		list.currentDailyDoubleRareBundleCount = dailyDoubleRareBundleCount
		if not list.updateDailyDoubleRareSubscription then
			list.updateDailyDoubleRareSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "dailyDoubleRareBundles" ), function ()
				local dailyDoubleRareBundleCount = CoD.BlackMarketUtility.GetCurrentDailyDoubleRareBundleCount( controller )
				if dailyDoubleRareBundleCount ~= list.currentDailyDoubleRareBundleCount then
					list.currentDailyDoubleRareBundleCount = dailyDoubleRareBundleCount
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	local rare15BundleCount = CoD.BlackMarketUtility.GetCurrentRare15BundleCount( controller )
	if rare15BundleCount > 0 then
		local bundleImage = CoD.BlackMarketUtility.BundleImage
		table.insert( items, f64_local3( CoD.BlackMarketUtility.BundleTitle, bundleImage, bundleImage .. "_glow", Engine.Localize( "MPUI_BM_BUNDLES_REMAINING", rare15BundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.RARE_15BUNDLE ) )
		list.currentRare15BundleCount = rare15BundleCount
		if not list.updateRare15BundleSubscription then
			list.updateRare15BundleSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "rare15Bundles" ), function ()
				if CoD.BlackMarketUtility.GetCurrentRare15BundleCount( controller ) ~= list.currentRare15BundleCount then
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	local outfit3BundleCount = CoD.BlackMarketUtility.GetCurrentOutfit3BundleCount( controller )
	if outfit3BundleCount > 0 then
		local bundleImage = CoD.BlackMarketUtility.BundleImage
		table.insert( items, f64_local3( "MPUI_BM_BRIBE_OUTFIT_TRIPLE", bundleImage, bundleImage .. "_glow", Engine.Localize( "MPUI_BM_OUTFIT_BRIBES_REMAINING", outfit3BundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.OUTFIT_3BUNDLE ) )
		list.currentOutfit3BundleCount = outfit3BundleCount
		if not list.updateOutfit3BundleSubscription then
			list.updateOutfit3BundleSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "outfit3Bundles" ), function ()
				if CoD.BlackMarketUtility.GetCurrentOutfit3BundleCount( controller ) ~= list.currentOutfit3BundleCount then
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if HasWeapon3XBundles( controller ) then
		local weapon3XBundleCount = CoD.BlackMarketUtility.GetCurrentWeapon3XBundleCount( controller )
		table.insert( items, f64_local3( "MPUI_BM_WEAPON_3X", "t7_blackmarket_bribe_gold_bribe_3_weapons", "t7_blackmarket_bribe_gold_bribe_3_weapons", "MPUI_BM_WEAPON_3X_HINT", 0, 0, action, CoD.BlackMarketUtility.DropTypes.WEAPON_3X ) )
		f64_local12 = false
		list.currentWeapon3XBundleCount = weapon3XBundleCount
		if not list.updateWeapon3XSubscription then
			list.updateWeapon3XSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "weapon3XBundles" ), function ()
				local weapon3XBundleCount = CoD.BlackMarketUtility.GetCurrentWeapon3XBundleCount( controller )
				if weapon3XBundleCount ~= list.currentWeapon3XBundleCount then
					list.currentWeapon3XBundleCount = weapon3XBundleCount
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if HasLimitedEditionCamoBundles( controller ) then
		local limitedEditionCamoBundleCount = CoD.BlackMarketUtility.GetCurrentLimitedEditionCamoBundleCount( controller )
		table.insert( items, f64_local3( "MPUI_BM_LIMITED_CAMO_BUNDLE", "t7_blackmarket_bribe_gold_bribe_camo", "t7_blackmarket_bribe_gold_bribe_camo", "MPUI_BM_LIMITED_CAMO_BUNDLE_HINT", 0, 0, action, CoD.BlackMarketUtility.DropTypes.LIMITED_EDITION_CAMO ) )
		f64_local12 = false
		list.currentlimitedEditionCamoBundleCount = limitedEditionCamoBundleCount
		if not list.updateLimitedEditionCamoSubscription then
			list.updateLimitedEditionCamoSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "limitedEditionCamoBundles" ), function ()
				local limitedEditionCamoBundleCount = CoD.BlackMarketUtility.GetCurrentLimitedEditionCamoBundleCount( controller )
				if limitedEditionCamoBundleCount ~= list.currentlimitedEditionCamoBundleCount then
					list.currentlimitedEditionCamoBundleCount = limitedEditionCamoBundleCount
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if IsNoDupesCrateActive( controller ) then
		table.insert( items, f64_local3( "MPUI_BM_NO_DUPES_CRATE", "uie_t7_blackmarket_crate_rare_focus", "uie_t7_blackmarket_crate_rare_focus", "MPUI_BM_NO_DUPES_CRATE_HINT", CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.NO_DUPES_CRATE ) or 0, CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.NO_DUPES_CRATE ) or 0, f64_local4, CoD.BlackMarketUtility.DropTypes.NO_DUPES_CRATE, 1, "MPUI_BM_RARE_DROP" ) )
	end
	if IsNoDupesBundleActive( controller ) then
		local noDupesBundleRareBundleCount = CoD.BlackMarketUtility.GetCurrentNoDupesBundleRareBundleCount( controller )
		if noDupesBundleRareBundleCount > 0 then
			table.insert( items, f64_local3( "MPUI_BM_NO_DUPES_BUNDLE_TITLE", "uie_t7_blackmarket_crate_bundle_10", "uie_t7_blackmarket_crate_bundle_10", "MPUI_BM_NO_DUPES_CRATE_HINT", 0, 0, action, CoD.BlackMarketUtility.DropTypes.NO_DUPES_BUNDLE, 1, "MPUI_BM_NO_DUPES_BUNDLE" ) )
		else
			table.insert( items, f64_local3( "MPUI_BM_NO_DUPES_BUNDLE_TITLE", "uie_t7_blackmarket_crate_bundle_10", "uie_t7_blackmarket_crate_bundle_10", Engine.Localize( "MPUI_BM_NO_DUPES_BUNDLE_HINT", 20 ), CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.NO_DUPES_BUNDLE ) or 0, CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.NO_DUPES_BUNDLE ) or 0, f64_local4, CoD.BlackMarketUtility.DropTypes.NO_DUPES_BUNDLE, 1, "MPUI_BM_NO_DUPES_BUNDLE" ) )
		end
		f64_local12 = false
		list.currentNoDupesRareBundleCount = noDupesBundleRareBundleCount
		if not list.updateNoDupesRareSubscription then
			list.updateNoDupesRareSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "noDupesRareBundles" ), function ()
				local noDupesBundleRareBundleCount = CoD.BlackMarketUtility.GetCurrentNoDupesBundleRareBundleCount( controller )
				if noDupesBundleRareBundleCount ~= list.currentNoDupesRareBundleCount then
					list.currentNoDupesRareBundleCount = noDupesBundleRareBundleCount
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if IsBundleExperimentActive( controller ) then
		local bundleExperimentRareBundleCount = CoD.BlackMarketUtility.GetCurrentBundleExperimentRareBundleCount( controller )
		local f64_local17 = Engine.Localize( "MPUI_BM_BUNDLE_EXPERIMENT", Engine.Localize( Engine.DvarString( nil, "loot_3pack_final_count_string_ref" ) ) )
		if bundleExperimentRareBundleCount > 0 then
			table.insert( items, f64_local3( f64_local17, "uie_t7_blackmarket_crate_bundle", "uie_t7_blackmarket_crate_bundle", Engine.Localize( "MPUI_BM_BUNDLES_REMAINING", bundleExperimentRareBundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.BUNDLE_EXPERIMENT ) )
		else
			table.insert( items, f64_local3( f64_local17, "uie_t7_blackmarket_crate_bundle", "uie_t7_blackmarket_crate_bundle", Engine.Localize( "MPUI_BM_BUNDLE_EXPERIMENT_HINT", Engine.DvarInt( nil, "loot_3pack_final_count" ) ), CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.BUNDLE_EXPERIMENT ), CoD.BlackMarketUtility.GetCrateCODPointCost( CoD.BlackMarketUtility.DropTypes.BUNDLE_EXPERIMENT ), f64_local4, CoD.BlackMarketUtility.DropTypes.BUNDLE_EXPERIMENT ) )
		end
		f64_local12 = false
		list.currentBundleExperimentRareBundleCount = bundleExperimentRareBundleCount
		if not list.updateBundleExperimentRareSubscription then
			list.updateBundleExperimentRareSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "bundleExperimentRareBundles" ), function ()
				local bundleExperimentRareBundleCount = CoD.BlackMarketUtility.GetCurrentBundleExperimentRareBundleCount( controller )
				if bundleExperimentRareBundleCount ~= list.currentBundleExperimentRareBundleCount then
					list.currentBundleExperimentRareBundleCount = bundleExperimentRareBundleCount
					list:updateDataSource( false )
				end
			end, false )
		end
	end
	if HasCodeBundles( controller ) then
		table.insert( items, f64_local3( "MPUI_BM_CODE_BUNDLE", "uie_t7_blackmarket_crate_bundle", "uie_t7_blackmarket_crate_bundle", Engine.Localize( "MPUI_BM_BUNDLES_REMAINING", CoD.BlackMarketUtility.GetCurrentCodeBundleRareBundleCount( controller ) ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.CODE_BUNDLE ) )
		f64_local12 = false
	end
	list.currentCodeBundleRareBundleCount = currentCodeBundleRareBundleCount
	if not list.updateCodeBundleRareBundles then
		list.updateCodeBundleRareBundles = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "codeBundleRareBundles" ), function ()
			local codeBundleRareBundleCount = CoD.BlackMarketUtility.GetCurrentCodeBundleRareBundleCount( controller )
			if codeBundleRareBundleCount ~= list.currentCodeBundleRareBundleCount then
				list.currentCodeBundleRareBundleCount = codeBundleRareBundleCount
				list:updateDataSource( false )
			end
		end, false )
	end
	local incentiveRareBundleCount = CoD.BlackMarketUtility.GetCurrentIncentiveRareBundleCount( controller )
	if incentiveRareBundleCount > 0 then
		local f64_local17 = "blacktransparent"
		table.insert( items, f64_local3( CoD.BlackMarketUtility.IncentiveRareBundleTitle, f64_local17, f64_local17, Engine.Localize( CoD.BlackMarketUtility.IncentiveRareBundleHint, incentiveRareBundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.INCENTIVE_RARE_BUNDLE ) )
		f64_local12 = false
	end
	list.currentIncentiveRareBundleCount = incentiveRareBundleCount
	if not list.updateIncentiveRareSubscription then
		list.updateIncentiveRareSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "incentiveRareBundles" ), function ()
			if CoD.BlackMarketUtility.GetCurrentIncentiveRareBundleCount( controller ) ~= list.currentIncentiveRareBundleCount then
				list:updateDataSource( false )
			end
		end, false )
	end
	local incentiveWeaponBundleCount = CoD.BlackMarketUtility.GetCurrentIncentiveWeaponBundleCount( controller )
	if incentiveWeaponBundleCount > 0 then
		local f64_local18 = "blacktransparent"
		table.insert( items, f64_local3( CoD.BlackMarketUtility.IncentiveWeaponBundleTitle, f64_local18, f64_local18, Engine.Localize( CoD.BlackMarketUtility.IncentiveWeaponBundleHint, incentiveWeaponBundleCount ), 0, 0, action, CoD.BlackMarketUtility.DropTypes.INCENTIVE_WEAPON_BUNDLE ) )
		f64_local12 = false
	end
	list.currentIncentiveWeaponBundleCount = incentiveWeaponBundleCount
	if not list.updateIncentiveWeaponSubscription then
		list.updateIncentiveWeaponSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "incentiveWeaponBundles" ), function ()
			if CoD.BlackMarketUtility.GetCurrentIncentiveWeaponBundleCount( controller ) ~= list.currentIncentiveWeaponBundleCount then
				list:updateDataSource( false )
			end
		end, false )
	end
	local noDupeRangeBundleCount = CoD.BlackMarketUtility.GetCurrentNoDupeRangeBundleCount( controller )
	if noDupeRangeBundleCount > 0 then
		table.insert( items, f64_local3( "MPUI_BM_BRIBE_RANGE_WEAPON", "t7_blackmarket_bribe_weapon", "t7_blackmarket_bribe_weapon", "MPUI_BM_BRIBE_RANGE_WEAPON_KEY_HINT_TEXT", 0, 0, action, CoD.BlackMarketUtility.DropTypes.NO_DUPES_RANGE, 1, "", noDupeRangeBundleCount ) )
		f64_local12 = false
	end
	list.currentRangeWeaponNoDupesBundleCount = noDupeRangeBundleCount
	if not list.updateRangeWeaponNoDupesSubscription then
		list.updateRangeWeaponNoDupesSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "rangeWeaponNoDupesBundles" ), function ()
			if CoD.BlackMarketUtility.GetCurrentNoDupeRangeBundleCount( controller ) ~= list.currentRangeWeaponNoDupesBundleCount then
				list:updateDataSource( false )
			end
		end, false )
	end
	local noDupeMeleeBundleCount = CoD.BlackMarketUtility.GetCurrentNoDupeMeleeBundleCount( controller )
	if noDupeMeleeBundleCount > 0 then
		table.insert( items, f64_local3( "MPUI_BM_BRIBE_MELEE_WEAPON", "t7_blackmarket_bribe_melee", "t7_blackmarket_bribe_melee", "MPUI_BM_BRIBE_MELEE_WEAPON_KEY_HINT_TEXT", 0, 0, action, CoD.BlackMarketUtility.DropTypes.NO_DUPES_MELEE, 1, "", noDupeMeleeBundleCount ) )
		f64_local12 = false
	end
	list.currentMeleeWeaponNoDupesBundleCount = noDupeMeleeBundleCount
	if not list.updateMeleeWeaponNoDupesSubscription then
		list.updateMeleeWeaponNoDupesSubscription = list:subscribeToModel( Engine.GetModel( DataSources.CryptoKeyProgress.getModel( controller ), "meleeWeaponNoDupesBundles" ), function ()
			if CoD.BlackMarketUtility.GetCurrentNoDupeMeleeBundleCount( controller ) ~= list.currentMeleeWeaponNoDupesBundleCount then
				list:updateDataSource( false )
			end
		end, false )
	end
	f64_local13.models.useTallVersion = f64_local12
	f64_local11.models.useTallVersion = f64_local12
	return items
end, true )
DataSources.BlackMarketCryptokeyList.getWidgetTypeForItem = function ( list, model, row, column )
	if list.BlackMarketCryptokeyList[column].properties then
		if list.BlackMarketCryptokeyList[column].properties.isBribeCoin then
			return CoD.BribeCoinWidget
		else
			return CoD.CryptokeyWidget
		end
	else
		return nil
	end
end

DataSources.BlackMarketList = DataSourceHelpers.ListSetup( "BlackMarketList", function ( controller )
	local items = {}
	-- local f95_local1 = function ( f96_arg0, f96_arg1, f96_arg2, f96_arg3, f96_arg4, f96_arg5 )
	-- 	return {
	-- 		models = {
	-- 			displayText = f96_arg0,
	-- 			image = f96_arg2,
	-- 			disabled = f96_arg3,
	-- 			showBreadcrumb = f96_arg5
	-- 		},
	-- 		properties = {
	-- 			action = f96_arg1,
	-- 			selectIndex = f96_arg4
	-- 		}
	-- 	}
	-- end
	
	-- local f95_local2 = function ( f97_arg0, f97_arg1, f97_arg2, f97_arg3, f97_arg4 )
	-- 	local f97_local0 = CoD.BlackMarketUtility.GetProgressTowardNextKey( f97_arg2 )
	-- 	local f97_local1 = CoD.BlackMarketUtility.GetNumDupesForType( f97_arg2, Enum.LootRarityType.LOOT_RARITY_TYPE_COMMON )
	-- 	local f97_local2 = CoD.BlackMarketUtility.GetNumDupesForType( f97_arg2, Enum.LootRarityType.LOOT_RARITY_TYPE_RARE )
	-- 	local f97_local3 = CoD.BlackMarketUtility.GetNumDupesForType( f97_arg2, Enum.LootRarityType.LOOT_RARITY_TYPE_LEGENDARY )
	-- 	local f97_local4 = CoD.BlackMarketUtility.GetNumDupesForType( f97_arg2, Enum.LootRarityType.LOOT_RARITY_TYPE_EPIC )
	-- 	local f97_local5 = CoD.BlackMarketUtility.GetNumKeysEarnedForBurning( f97_arg2, f97_local1, f97_local2, f97_local3, f97_local4 )
	-- 	if f97_local1 + f97_local2 + f97_local3 + f97_local4 == 0 then
	-- 		f97_local5 = -1
	-- 	end
	-- 	CoD.OverlayUtility.CreateOverlay( f97_arg2, f97_arg0, "BurnDuplicatesConfirmation", f97_arg2, f97_local5, f97_local1, f97_local2, f97_local3, f97_local4 )
	-- end
	
	-- local f95_local3 = function ( f98_arg0, f98_arg1, f98_arg2, f98_arg3, f98_arg4 )
	-- 	OpenOverlay( f98_arg4, "BM_History", f98_arg2 )
	-- end
	
	-- local f95_local4 = function ( f99_arg0, f99_arg1, f99_arg2, f99_arg3, f99_arg4 )
	-- 	CycleContracts( f99_arg2 )
	-- 	OpenOverlay( f99_arg4, "BM_Contracts", f99_arg2 )
	-- 	local f99_local0 = f99_arg1:getModel( f99_arg2, "showBreadcrumb" )
	-- 	if f99_local0 then
	-- 		Engine.SetModelValue( f99_local0, false )
	-- 	end
	-- end
	
	-- local f95_local5 = false
	-- if Dvar.tu4_enableCodPoints:get() then
	-- 	table.insert( f95_local0, f95_local1( "MPUI_BM_BUY", f0_local1, "uie_ui_codpoints_symbol_32x32", f95_local5, true ) )
	-- end
	-- if Dvar.show_contracts_button:get() then
	-- 	local f95_local6 = Engine.StorageGetBuffer( f95_arg0, Enum.StorageFileType.STORAGE_MP_STATS_ONLINE )
	-- 	table.insert( f95_local0, f95_local1( "MPUI_BM_CONTRACTS", f95_local4, "uie_ui_codpoints_symbol_32x32", nil, nil, IsCommunityContractBreadCrumbActive( f95_arg0 ) or f95_local6 and f95_local6.ui_seen_new_contracts:get() == 0 or IsTrifectaContractBreadcrumbActive( f95_arg0 ) ) )
	-- end
	-- local f95_local6 = Engine.GetLootItemCount( f95_arg0, Enum.eModes.MODE_MULTIPLAYER )
	-- if f95_local6 ~= nil and f95_local6 > 0 then
	-- 	table.insert( f95_local0, f95_local1( "MPUI_BM_RECENT", f95_local3, "uie_ui_codpoints_symbol_32x32" ) )
	-- end
	-- if Dvar.tu4_burnDuplicates:get() then
	-- 	table.insert( f95_local0, f95_local1( "MPUI_BM_DUPLICATES", f95_local2, "uie_ui_codpoints_symbol_32x32" ) )
	-- end
	return items
end, true )
local PreLoadFunc = function ( self, controller )
	Engine.SetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "GameSettingsFlyoutOpen" ), false )
	Engine.SetModelValue( Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "autoevents" ), "targetController" ), controller )
	Engine.SetDvar( "live_autoEventPumpTime", 0 )
end

local PostLoadFunc = function ( self, controller )
	self.disablePopupOpenCloseAnim = true
	if CoD.BlackMarketUtility.GetCurrentCryptoKeyCount( controller ) >= CoD.BlackMarketUtility.GetCrateCryptoKeyCost( CoD.BlackMarketUtility.DropTypes.COMMON ) then
		SendFrontendControllerZeroMenuResponse( controller, "BlackMarket", "greeting" )
	else
		SendFrontendControllerZeroMenuResponse( controller, "BlackMarket", "greeting_broke" )
	end
	local playerStats = CoD.GetPlayerStats( controller )
	if playerStats then
		playerStats.blackMarketShowBreadcrumb:set( 0 )
		playerStats.extraBytes[0]:set( CoD.BlackMarketUtility.CurrentPromotionIndex )
	end
	local cycledModel = Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "autoevents" ), "cycled" )
	local six_pack_timerModel = Engine.CreateModel( Engine.GetModelForController( controller ), "six_pack_timer" )
	local daily_double_timerModel = Engine.CreateModel( Engine.GetModelForController( controller ), "daily_double_timer" )
	self:subscribeToModel( cycledModel, function ( model )
		self.cryptokeyList:updateDataSource( false )
	end, false )
	local isSixPackBundleInCooldown = IsSixPackBundleInCooldown( controller )
	local isDailyDoubleBundleInCooldown = IsDailyDoubleBundleInCooldown( controller )
	self:registerEventHandler( "bm_autoevents_tick", function ( element, event )
		Engine.SetDvar( "live_autoEventPumpTime", 0 )
		local isSixPackBundleInCooldown2 = IsSixPackBundleInCooldown( controller )
		local isDailyDoubleBundleInCooldown2 = IsDailyDoubleBundleInCooldown( controller )
		if isSixPackBundleInCooldown ~= isSixPackBundleInCooldown2 or isDailyDoubleBundleInCooldown ~= isDailyDoubleBundleInCooldown2 then
			isSixPackBundleInCooldown = isSixPackBundleInCooldown2
			isDailyDoubleBundleInCooldown = isDailyDoubleBundleInCooldown2
			Engine.ForceNotifyModelSubscriptions( cycledModel )
		end
		local f103_local2 = Engine.GetServerUTCTimeStr()
		local f103_local3 = false
		local sTORAGE_MP_STATS_ONLINEBuffer = Engine.StorageGetBuffer( controller, Enum.StorageFileType.STORAGE_MP_STATS_ONLINE )
		if sTORAGE_MP_STATS_ONLINEBuffer then
			local f103_local5 = tonumber( Engine.StringIntegerSubtraction( Engine.StringIntegerAddition( sTORAGE_MP_STATS_ONLINEBuffer.playerstatslist.ARENA_MAX_RANK.statvalue:getAsString(), Engine.DvarInt( nil, "loot_sixPack_cooloffSeconds" ) ), f103_local2 ) )
			if f103_local5 >= 0 then
				Engine.SetModelValue( six_pack_timerModel, LuaUtils.SecondsToTimeRemainingString( f103_local5 + 1, true ) )
				f103_local3 = true
			end
		end
		if not f103_local3 then
			local inventoryItem = Engine.GetInventoryItem( controller, Engine.DvarInt( nil, "loot_sixPack_consumable_id" ) )
			if inventoryItem then
				local f103_local5 = tonumber( Engine.StringIntegerSubtraction( inventoryItem.expireTimeStr, f103_local2 ) )
				if f103_local5 >= -CoD.BlackMarketUtility.CooldownTimerBufferSeconds then
					Engine.SetModelValue( six_pack_timerModel, LuaUtils.SecondsToTimeRemainingString( f103_local5 + CoD.BlackMarketUtility.CooldownTimerBufferSeconds + 1, true ) )
				end
			end
		end
		local inventoryItem = Engine.GetInventoryItem( controller, Engine.DvarInt( nil, "loot_dailyDouble_consumable_id" ) )
		if inventoryItem then
			local f103_local5 = tonumber( Engine.StringIntegerSubtraction( inventoryItem.expireTimeStr, f103_local2 ) )
			if f103_local5 >= -CoD.BlackMarketUtility.CooldownTimerBufferSeconds then
				Engine.SetModelValue( daily_double_timerModel, LuaUtils.SecondsToTimeRemainingString( f103_local5 + CoD.BlackMarketUtility.CooldownTimerBufferSeconds + 1, true ) )
			end
		end
	end )
	self._bm_autoevent_timer = LUI.UITimer.new( 100, "bm_autoevents_tick", false, self )
	self:addElement( self._bm_autoevent_timer )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element._bm_autoevent_timer:close()
	end )
	if Dvar.tu27_showGunMeter:get() then
		self.BMGunMeter0:setAlpha( 1 )
	end
	local sTORAGE_MP_STATS_ONLINEBuffer = Engine.StorageGetBuffer( controller, Enum.StorageFileType.STORAGE_MP_STATS_ONLINE )
	if sTORAGE_MP_STATS_ONLINEBuffer.contracts[LuaUtils.BMContracts.specialContractIndex].index:get() == 3014 and sTORAGE_MP_STATS_ONLINEBuffer.contracts[LuaUtils.BMContracts.specialContractIndex].award_given:get() == 1 and Engine.GetInventoryItemQuantity( controller, 99104 ) == 0 then
		Engine.PurchaseDWSKU( controller, 99106 )
	end
end

LUI.createMenu.BlackMarket = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "BlackMarket" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "MultiplayerMain"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "BlackMarket.buttonPrompts" )
	local menu = self
	self.anyChildUsesUpdateState = true
	
	local LeftPanel0 = CoD.FE_ButtonPanelShaderContainer.new( menu, controller )
	LeftPanel0:setLeftRight( true, true, 53.5, -735.5 )
	LeftPanel0:setTopBottom( true, true, 0, 46 )
	LeftPanel0:setRGB( 0.5, 0.5, 0.5 )
	LeftPanel0:setAlpha( 0 )
	self:addElement( LeftPanel0 )
	self.LeftPanel0 = LeftPanel0
	
	local FadeForStreamer = CoD.LobbyStreamerBlackFade.new( menu, controller )
	FadeForStreamer:setLeftRight( true, false, 0, 1280 )
	FadeForStreamer:setTopBottom( true, false, 0, 720 )
	FadeForStreamer:mergeStateConditions( {
		{
			stateName = "Transparent",
			condition = function ( menu, element, event )
				return IsGlobalModelValueEqualTo( element, controller, "hideWorldForStreamer", 0 )
			end
		}
	} )
	FadeForStreamer:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "hideWorldForStreamer" ), function ( model )
		menu:updateElementState( FadeForStreamer, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hideWorldForStreamer"
		} )
	end )
	self:addElement( FadeForStreamer )
	self.FadeForStreamer = FadeForStreamer
	
	local GenericMenuFrame = CoD.GenericMenuFrame.new( menu, controller )
	GenericMenuFrame:setLeftRight( true, true, 0, 0 )
	GenericMenuFrame:setTopBottom( true, true, 0, 0 )
	GenericMenuFrame.titleLabel:setText( Engine.Localize( "" ) )
	GenericMenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText( Engine.Localize( "MENU_BLACK_MARKET" ) )
	GenericMenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon.FeatureIcon:setImage( RegisterImage( "uie_t7_mp_icon_header_character" ) )
	self:addElement( GenericMenuFrame )
	self.GenericMenuFrame = GenericMenuFrame
	
	local verticalCounterBlackMarket = CoD.verticalCounterBlackMarket.new( menu, controller )
	verticalCounterBlackMarket:setLeftRight( true, false, 198.5, 398.5 )
	verticalCounterBlackMarket:setTopBottom( true, false, 639.41, 664.41 )
	verticalCounterBlackMarket:registerEventHandler( "menu_loaded", function ( element, event )
		local f108_local0 = nil
		SetAsListVerticalCounter( self, element, "cryptokeyList" )
		if not f108_local0 then
			f108_local0 = element:dispatchEventToChildren( event )
		end
		return f108_local0
	end )
	self:addElement( verticalCounterBlackMarket )
	self.verticalCounterBlackMarket = verticalCounterBlackMarket
	
	local cryptokeyList = LUI.UIList.new( menu, controller, 7, 0, nil, false, false, 0, 0, false, false )
	cryptokeyList:makeFocusable()
	cryptokeyList:setLeftRight( true, false, 66, 533 )
	cryptokeyList:setTopBottom( true, false, 151, 624 )
	cryptokeyList:setWidgetType( CoD.CryptokeyWidget )
	cryptokeyList:setHorizontalCount( 2 )
	cryptokeyList:setVerticalCount( 3 )
	cryptokeyList:setSpacing( 7 )
	-- cryptokeyList:setDataSource( "BlackMarketCryptokeyList" )
	cryptokeyList:registerEventHandler( "gain_focus", function ( element, event )
		local focusResult = nil
		if element.gainFocus then
			focusResult = element:gainFocus( event )
		elseif element.super.gainFocus then
			focusResult = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return focusResult
	end )
	cryptokeyList:registerEventHandler( "lose_focus", function ( element, event )
		local focusResult = nil
		if element.loseFocus then
			focusResult = element:loseFocus( event )
		elseif element.super.loseFocus then
			focusResult = element.super:loseFocus( event )
		end
		return focusResult
	end )
	menu:AddButtonCallbackFunction( cryptokeyList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil, function ( element, menu, controller, event )
		if IsElementInState( element, "OutfitShop" ) then
			ProcessListAction( self, element, controller )
			return true
		elseif IsCryptokeyWidgetAvailable( self, element, controller ) then
			ProcessListAction( self, element, controller )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if IsElementInState( element, "OutfitShop" ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_GO_TO_STORE" )
			return true
		elseif IsCryptokeyWidgetAvailable( self, element, controller ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
			return true
		else
			return false
		end
	end, false )
	self:addElement( cryptokeyList )
	self.cryptokeyList = cryptokeyList
	
	local FEMenuLeftGraphics = CoD.FE_Menu_LeftGraphics.new( menu, controller )
	FEMenuLeftGraphics:setLeftRight( true, false, 19, 71 )
	FEMenuLeftGraphics:setTopBottom( true, false, 77, 694.25 )
	self:addElement( FEMenuLeftGraphics )
	self.FEMenuLeftGraphics = FEMenuLeftGraphics
	
	local BlackMarketSafeAreaContainer = CoD.BlackMarketSafeAreaContainer.new( menu, controller )
	BlackMarketSafeAreaContainer:setLeftRight( true, false, 0, 1280 )
	BlackMarketSafeAreaContainer:setTopBottom( true, false, 0, 720 )
	self:addElement( BlackMarketSafeAreaContainer )
	self.BlackMarketSafeAreaContainer = BlackMarketSafeAreaContainer
	
	local buttonList0 = LUI.UIList.new( menu, controller, 1, 0, nil, false, false, 0, 0, false, false )
	buttonList0:makeFocusable()
	buttonList0:setLeftRight( true, false, 67, 530 )
	buttonList0:setTopBottom( true, false, 104, 145 )
	buttonList0:setWidgetType( CoD.BM_TopNavBtn )
	buttonList0:setHorizontalCount( 4 )
	buttonList0:setSpacing( 1 )
	buttonList0:setDataSource( "BlackMarketList" )
	buttonList0:registerEventHandler( "gain_focus", function ( element, event )
		local focusResult = nil
		if element.gainFocus then
			focusResult = element:gainFocus( event )
		elseif element.super.gainFocus then
			focusResult = element.super:gainFocus( event )
		end
		SetElementStateByElementName( self, "burnDuplicatesHint", controller, "DefaultState" )
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return focusResult
	end )
	buttonList0:registerEventHandler( "lose_focus", function ( element, event )
		local focusResult = nil
		if element.loseFocus then
			focusResult = element:loseFocus( event )
		elseif element.super.loseFocus then
			focusResult = element.super:loseFocus( event )
		end
		SetElementStateByElementName( self, "burnDuplicatesHint", controller, "NotVisible" )
		return focusResult
	end )
	menu:AddButtonCallbackFunction( buttonList0, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil, function ( element, menu, controller, event )
		ProcessListAction( self, element, controller )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( buttonList0 )
	self.buttonList0 = buttonList0
	
	local BMPromo = CoD.BM_Promo.new( menu, controller )
	BMPromo:setLeftRight( true, false, 440.5, 1458.5 )
	BMPromo:setTopBottom( true, false, 498.91, 651.91 )
	BMPromo:setScale( 0.8 )
	BMPromo:mergeStateConditions( {
		{
			stateName = "CodPoints",
			condition = function ( menu, element, event )
				return AlwaysFalse()
			end
		},
		{
			stateName = "Bribe",
			condition = function ( menu, element, event )
				return AlwaysFalse()
			end
		},
		{
			stateName = "Bundle",
			condition = function ( menu, element, event )
				return AlwaysFalse()
			end
		}
	} )
	BMPromo:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "autoevents.cycled" ), function ( model )
		menu:updateElementState( BMPromo, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "autoevents.cycled"
		} )
	end )
	BMPromo:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "CryptoKeyProgress.codeBundleRareBundles" ), function ( model )
		menu:updateElementState( BMPromo, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "CryptoKeyProgress.codeBundleRareBundles"
		} )
	end )
	self:addElement( BMPromo )
	self.BMPromo = BMPromo
	
	local BMGunMeter0 = CoD.BM_GunMeter.new( menu, controller )
	BMGunMeter0:setLeftRight( true, false, 482, 832 )
	BMGunMeter0:setTopBottom( true, false, 94.5, 195.5 )
	BMGunMeter0:setAlpha( 0 )
	BMGunMeter0:setScale( 0.6 )
	self:addElement( BMGunMeter0 )
	self.BMGunMeter0 = BMGunMeter0
	
	cryptokeyList.navigation = {
		up = buttonList0
	}
	buttonList0.navigation = {
		down = cryptokeyList
	}
	CoD.Menu.AddNavigationHandler( menu, self, controller )
	self:registerEventHandler( "menu_loaded", function ( element, event )
		local f122_local0 = nil
		SendClientScriptMenuChangeNotify( controller, menu, true )
		SetElementStateByElementName( self, "GenericMenuFrame", controller, "Update" )
		if not f122_local0 then
			f122_local0 = element:dispatchEventToChildren( event )
		end
		return f122_local0
	end )
	self:registerEventHandler( "menu_opened", function ( element, event )
		local f123_local0 = nil
		SetElementStateByElementName( self, "burnDuplicatesHint", controller, "NotVisible" )
		PlayClipOnElement( self, {
			elementName = "FEMenuLeftGraphics",
			clipName = "Intro"
		}, controller )
		-- OpenBlackMarketIncentivePopup( self, controller )
		-- OpenBlackMarketUnspentBundlePopupIfNeeded( f105_local1, controller )
		-- OpenBlackMarketWeaponContractErrorPopupIfNeeded( f105_local1, controller )
		-- OpenBlackMarketExperimentPromoPopupIfNeeded( f105_local1, controller )
		PlayMenuMusic( "black_market" )
		if not f123_local0 then
			f123_local0 = element:dispatchEventToChildren( event )
		end
		return f123_local0
	end )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, event )
		SendClientScriptMenuChangeNotify( controller, menu, false )
		GoBack( self, controller )
		ClearMenuSavedState( menu )
		HandleGoBackFromBlackMarket( self, element, controller, "", menu )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )
		return true
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, nil, function ( element, menu, controller, event )
		if IsBooleanDvarSet( "ui_enablePromoMenu" ) then
			OpenOverlay( self, "ZMHD_Community_Theme", controller, "", "" )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if IsBooleanDvarSet( "ui_enablePromoMenu" ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "MENU_COMMUNITY_CHALLENGE" )
			return true
		else
			return false
		end
	end, false )
	-- f105_local1:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "S", function ( f128_arg0, f128_arg1, f128_arg2, f128_arg3 )
	-- 	OpenOutfitStore( self, f128_arg0, f128_arg2, "BlackMarket", f128_arg1 )
	-- 	return true
	-- end, function ( f129_arg0, f129_arg1, f129_arg2 )
	-- 	CoD.Menu.SetButtonLabel( f129_arg1, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "MENU_VIEW_STORE_OUTFITS" )
	-- 	return true
	-- end, false )
	LUI.OverrideFunction_CallOriginalFirst( self, "close", function ( element )
		SendFrontendControllerZeroMenuResponse( controller, "BlackMarket", "closed" )
		CommitProfileChanges( controller )
		ForceLobbyButtonUpdate( controller )
		SendClientScriptNotify( controller, "BlackMarket", "cycle_stop" )
		ValidateMPLootWeapons( controller )
		PlayMenuMusicForCurrentLobby( "" )
	end )
	GenericMenuFrame:setModel( self.buttonModel, controller )
	cryptokeyList.id = "cryptokeyList"
	buttonList0.id = "buttonList0"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = menu
	} )
	if not self:restoreState() then
		self.cryptokeyList:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.LeftPanel0:close()
		element.FadeForStreamer:close()
		element.GenericMenuFrame:close()
		element.verticalCounterBlackMarket:close()
		element.cryptokeyList:close()
		element.FEMenuLeftGraphics:close()
		element.BlackMarketSafeAreaContainer:close()
		element.buttonList0:close()
		element.BMPromo:close()
		element.BMGunMeter0:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "BlackMarket.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

