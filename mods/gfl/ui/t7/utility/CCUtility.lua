require("ui.t7.utility.CCUtility_og")

DataSources.HeroCustomizationTabs = DataSourceHelpers.ListSetup("HeroCustomizationTabs", function(controller)
    local tabs = {}
    local addTab = function(tabName, isBlackMarket, filterName)
        table.insert(tabs, {
            models = {
                tabName = tabName,
                tabIcon = "",
                breadcrumbCount = 0
            },
            properties = {
                isBlackMarket = isBlackMarket,
                selectIndex = not isBlackMarket,
                filterName = filterName
            }
        })
    end

    table.insert(tabs, {
        models = {
            tabIcon = CoD.buttonStrings.shoulderl
        },
        properties = {
            m_mouseDisabled = true
        }
    })
    addTab("MPUI_STANDARD_CAPS", false, CoD.CCUtility.PersonalizeHeroData.HeroCustomizationTabCategories[1])
    -- if IsLive() then
    -- 	f21_local1("MENU_BLACK_MARKET", true, CoD.CCUtility.PersonalizeHeroData.HeroCustomizationTabCategories[2])
    -- end
    table.insert(tabs, {
        models = {
            tabIcon = CoD.buttonStrings.shoulderr
        },
        properties = {
            m_mouseDisabled = true
        }
    })
    return tabs
end, false)

CoD.CCUtility.IsMissionCompleted = function(controller, missionName)
    return true
end

CoD.CCUtility.IsBodyOrHelmetAccessible = function(controller, customizationType, itemIndex, itemCount)
    if CoD.CCUtility.customizationMode == Enum.eModes.MODE_CAMPAIGN or Engine.IsCampaignGame() then
        local milestoneTable = CoD.getStatsMilestoneTable(2, Enum.eModes.MODE_CAMPAIGN)
        local customizationTypeColumn = 1
        local itemIndexColumn = 2
        local missionNameColumn = 3
        local matchingRows = Engine.TableFindRows(milestoneTable, customizationTypeColumn, customizationType)
        if matchingRows ~= nil then
            for index, row in ipairs(matchingRows) do
                local unlockItemIndex = Engine.TableLookupGetColumnValueForRow(milestoneTable, row, itemIndexColumn)
                local missionName = Engine.TableLookupGetColumnValueForRow(milestoneTable, row, missionNameColumn)
                if unlockItemIndex + 1 == itemIndex and
                    (missionName == "none" or CoD.CCUtility.IsMissionCompleted(controller, missionName)) then
                    return true
                end
            end
        end
        return false
    elseif CoD.CCUtility.customizationMode == Enum.eModes.MODE_ZOMBIES or Engine.IsZombiesGame() then
		local heroIndex = CoD.CCUtility.Heroes.HeroIndexForEdits
		if customizationType == "bodystyle" then
			-- soe beast
			-- refer to zm_character_customization
			if heroIndex == 4 and itemIndex == 5 then
				return false
			end
		end
		return true
	else
        return true
    end
end

CoD.CCUtility.CreateCarouselItemLoadoutDatasource = function ( heroData, mode, controller )
	local dataSourceName = "HeroCarouselItemLoadoutList" .. heroData.properties.heroIndex
	DataSources[dataSourceName] = DataSourceHelpers.ListSetup( dataSourceName, function ( controller )
		local loadouts = {}
		local equippedLoadoutType = Engine.GetLoadoutTypeForHero( controller, heroData.properties.heroIndex )
		for loadoutType = 0, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_COUNT - 1, 1 do
			local loadoutInfo = Engine.GetLoadoutInfoForHero( mode, heroData.properties.heroIndex, loadoutType )
			local isLocked = false
			-- if IsProgressionEnabled( f8_arg0 ) or IsLive() and IsFirstTimeSetup( f8_arg0, Enum.eModes.MODE_MULTIPLAYER ) then
			-- 	f8_local6 = Engine.IsItemLocked( f8_arg0, f8_local5.itemIndex, Enum.eModes.MODE_MULTIPLAYER )
			-- end
			if loadoutInfo then
				if CoD.CCUtility.customizationMode == Enum.eModes.MODE_ZOMBIES then
					table.insert( loadouts, {
						models = {
							name = Engine.Localize( "MENU_SELECT_CAPS" ),
							gameImageOff = loadoutInfo.gameImageOff,
							gameImageOn = loadoutInfo.gameImageOn,
							description = Engine.Localize( "GFL_CHARACTER_MENU_SELECT_DESC" ),
							header = CoD.CCUtility.GetHeaderForLoadoutSlot( loadoutType ),
							equippedSlot = loadoutType,
							itemIndex = loadoutInfo.itemIndex,
							disabled = isLocked,
							itemType = Enum.VoteItemType.VOTE_ITEM_TYPE_ITEM
						},
						properties = {
							equippedSlot = loadoutType,
							hintText = CoD.CCUtility.GetHintTextForLoadoutSlot( loadoutType ),
							selectIndex = equippedLoadoutType == loadoutType,
							heroIndex = heroData.properties.heroIndex
						}
					} )
				else
					table.insert( loadouts, {
						models = {
							name = loadoutInfo.itemName,
							gameImageOff = loadoutInfo.gameImageOff,
							gameImageOn = loadoutInfo.gameImageOn,
							description = loadoutInfo.itemDesc,
							header = CoD.CCUtility.GetHeaderForLoadoutSlot( loadoutType ),
							equippedSlot = loadoutType,
							itemIndex = loadoutInfo.itemIndex,
							disabled = isLocked,
							itemType = Enum.VoteItemType.VOTE_ITEM_TYPE_ITEM
						},
						properties = {
							equippedSlot = loadoutType,
							hintText = CoD.CCUtility.GetHintTextForLoadoutSlot( loadoutType ),
							selectIndex = equippedLoadoutType == loadoutType,
							heroIndex = heroData.properties.heroIndex
						}
					} )
				end
			end
		end
		return loadouts
	end, true )
	return dataSourceName
end

local function IsSOEBeast( hero )
	if hero ~= nil and hero.assetName ~= nil and hero.assetName == "pbt_zm_zod_beast" then
		return true
	else
		return false
	end
end

CoD.CCUtility.HeroesListPrepare = function ( controller )
	local cycledModel = Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "autoevents" ), "cycled" )
	local heroes = Engine.GetHeroList( CoD.CCUtility.customizationMode )
	local heroItems = {}
	local gender = Enum.CharacterGenderTypes.CHARACTER_GENDER_TYPE_ANY
	if CoD.CCUtility.customizationMode == Enum.eModes.MODE_CAMPAIGN then
		gender = Engine.GetEquippedGender( controller, Enum.eModes.MODE_CAMPAIGN )
	end
	local isEpicComplete = CoD.CCUtility.CompletionEpicComplete( controller, heroes )
	local lootHeroCount = 0
	for f77_local11, hero in ipairs( heroes ) do
		if gender == Enum.CharacterGenderTypes.CHARACTER_GENDER_TYPE_ANY or hero.gender == gender then
			local excludeHero = false
			if CoDShared.IsLootHero( hero ) then
				excludeHero = not AllowLootHero( controller )
			end

			if IsSOEBeast( hero ) then
				excludeHero = true
			end

			if not excludeHero then
				local heroModels = CoD.CCUtility.GetHeroModels( hero, f77_local11, controller, isEpicComplete )

				if CoDShared.IsLootHero( hero ) then
					table.insert( heroItems, 1, heroModels )
					heroModels.shouldIgnoreWhenCounting = true
					lootHeroCount = lootHeroCount + 1
				else
					table.insert( heroItems, heroModels )
				end
			end
		end
	end
	if CoD.isPC then
		for index, heroItem in ipairs( heroItems ) do
			heroItem.properties.carouselPos = index
		end
	end
	local displayIndex = 1
	for index, heroItem in ipairs( heroItems ) do
		if not heroItem.shouldIgnoreWhenCounting then
			heroItem.models.count = Engine.Localize( "MENU_X_OF_Y", displayIndex, #heroItems - lootHeroCount )
			displayIndex = displayIndex + 1
		end
	end
	return heroItems
end

DataSources.HeroesList = DataSourceHelpers.ListSetup( "HeroesList", CoD.CCUtility.HeroesListPrepare, true )

CoD.CCUtility.GetHeroModels = function ( hero, heroIndex, controller, isEpicComplete )
	local equippedHeroInfo = Engine.GetEquippedInfoForHero( controller, CoD.CCUtility.customizationMode, hero.bodyIndex )
	local heroCustomizationTable = Engine.GetHeroCustomizationTable( CoD.CCUtility.customizationMode, hero.bodyIndex )
	local isLocked, unlockDescription = CoD.CCUtility.Heroes.GetHeroUnlockInfo( controller, hero.bodyIndex )
	local selectedHeroIndex = CoD.CCUtility.Heroes.HeroIndexForEdits
	if not selectedHeroIndex then
		selectedHeroIndex = Engine.GetEquippedHero( controller, CoD.CCUtility.customizationMode )
	end
	local heroBundleInfo = Engine.GetHeroBundleInfo( CoD.CCUtility.customizationMode, hero.bodyIndex ) or {}
	local heroData = {
		models = {
			backgroundWithCharacter = hero.backgroundWithCharacter or "blacktransparent",
			lockedBackgroundWithCharacter = hero.background,
			name = hero.displayName,
			unlockDescription = unlockDescription,
			level = 1,
			unlockedCharacterSliver = hero.frozenMomentRender or "blacktransparent",
			lockedCharacterSliver = heroBundleInfo.lockedSliverRender or "blacktransparent",
			disabled = hero.disabled or isLocked,
			equippedSlot = Engine.GetLoadoutTypeForHero( controller, hero.bodyIndex ),
			selectedHeadInfo = CoD.CCUtility.CreateSelectedItemModel( controller, heroCustomizationTable, equippedHeroInfo, hero.bodyIndex, Enum.CharacterItemType.CHARACTER_ITEM_TYPE_HELMET ),
			selectedBodyInfo = CoD.CCUtility.CreateSelectedItemModel( controller, heroCustomizationTable, equippedHeroInfo, hero.bodyIndex, Enum.CharacterItemType.CHARACTER_ITEM_TYPE_BODY ),
			selectedShowcaseWeaponInfo = nil,
			selectedTauntInfo = nil,
			itemType = Enum.VoteItemType.VOTE_ITEM_TYPE_ITEM,
			heroIndex = hero.bodyIndex,
			breadcrumbCount = CoD.CCUtility.Heroes.GetPersonalizationNewCount( controller, hero.bodyIndex )
		},
		properties = {
			heroIndex = hero.bodyIndex,
			selectIndex = hero.bodyIndex == selectedHeroIndex
		}
	}
	if CoDShared.IsLootHero( hero ) then
		local getDvarOrDefault = function ( dvar, defaultValue )
			if dvar:exists() then
				return tonumber( dvar:get() )
			else
				return defaultValue
			end
		end
		
		heroData.models.contractsRemaining = 0
		heroData.models.isActivated = false
		heroData.models.activeTimeRemaining = 0
		local ui_enableAllHeroes = Dvar.ui_enableAllHeroes:get()
		if ui_enableAllHeroes then
			local models = heroData.models
			local f75_local10 = getDvarOrDefault
			local ui_blackjack_contracts = Dvar.ui_blackjack_contracts
			local f75_local12
			if ui_enableAllHeroes then
				f75_local12 = 1
				if not f75_local12 then
				
				else
					models.contractsRemaining = f75_local10( ui_blackjack_contracts, f75_local12 )
					heroData.models.isActivated = getDvarOrDefault( Dvar.ui_blackjack_active, 1 ) == 1
					heroData.models.activeTimeRemaining = getDvarOrDefault( Dvar.ui_blackjack_remainingTime, 29754 )
				end
			end
			f75_local12 = 0
		else
			local sTORAGE_MP_STATS_ONLINEBuffer = Engine.StorageGetBuffer( controller, Enum.StorageFileType.STORAGE_MP_STATS_ONLINE )
			if sTORAGE_MP_STATS_ONLINEBuffer and sTORAGE_MP_STATS_ONLINEBuffer.TenthSpecialistContract then
				heroData.models.contractsRemaining = sTORAGE_MP_STATS_ONLINEBuffer.blackjack_contract_count:get()
			end
			local f75_local10 = Engine.ConsumableGet( controller, "blackjack", "awarded" ) - Engine.ConsumableGet( controller, "blackjack", "consumed" )
			heroData.models.isActivated = f75_local10 > 0
			heroData.models.activeTimeRemaining = f75_local10 * 1000
		end
		heroData.models.breadcrumbCount = 0
		heroData.properties.customWidgetOverride = CoD.ChooseContractCharacterLoadoutCarouselItem
	end
	if not heroData.models.disabled then
		heroData.models.loadoutDatasource = CoD.CCUtility.CreateCarouselItemLoadoutDatasource( heroData, CoD.CCUtility.customizationMode, controller )
		if CoD.CCUtility.customizationMode == Enum.eModes.MODE_ZOMBIES then
			heroData.models.cardBackDatasource = CoD.CCUtility.CreateZMCarouselCardBackDatasource( heroData, hero, CoD.CCUtility.customizationMode, controller, heroBundleInfo, isEpicComplete )
		else
			heroData.models.cardBackDatasource = CoD.CCUtility.CreateCarouselCardBackDatasource( heroData, hero, CoD.CCUtility.customizationMode, controller, heroBundleInfo, isEpicComplete )
		end
		heroData.models.newTransmissions = CoD.CCUtility.GetTransmissionNewCount( controller, hero.bodyIndex, heroBundleInfo )
	end
	return heroData
end

CoD.CCUtility.CreateZMCarouselCardBackDatasource = function ( f12_arg0, f12_arg1, mode, controller, f12_arg4, f12_arg5 )
	local f12_local0 = "HeroCarouselCardBackList" .. f12_arg0.properties.heroIndex
	DataSources[f12_local0] = DataSourceHelpers.ListSetup( f12_local0, function ( controller )
		local items = {}
		local f13_local1 = function ( f14_arg0, f14_arg1, f14_arg2, f14_arg3 )
			local f14_local0 = {
				models = {
					text = f14_arg0,
					icon = f14_arg1
				},
				properties = {}
			}
			if f14_arg2 then
				for key, f14_local5 in pairs( f14_arg2 ) do
					f14_local0.models[key] = f14_local5
				end
			end
			f14_local0.models.alias = f14_local0.models.alias or ""
			if f14_arg3 then
				for key, f14_local5 in pairs( f14_arg3 ) do
					f14_local0.properties[key] = f14_local5
				end
			end
			return f14_local0
		end
		
		local f13_local2 = function ( f15_arg0, f15_arg1, f15_arg2 )
			return Engine.Localize( "HEROES_CARD_BACK_ENTRY", f15_arg0, f15_arg1, f15_arg2 or "" )
		end
		
		local f13_local3 = 1
		local loadoutInfo = Engine.GetLoadoutInfoForHero( mode, f12_arg0.properties.heroIndex, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_WEAPON )
		local loadoutInfo = Engine.GetLoadoutInfoForHero( mode, f12_arg0.properties.heroIndex, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_GADGET )
		table.insert( items, f13_local1( f13_local2( f13_local3, 1, "HEROES_BIO" ), "t7_hud_hero_icon_filetype_text", {
			cardBackIcon = f12_arg1.cardBackIcon,
			realName = f12_arg1.realName,
			age = f12_arg1.age,
			genderString = f12_arg1.genderString,
			bio = f12_arg1.bio,
			frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Bio"
		}, nil ) )
		f13_local3 = f13_local3 + 1

		local f13_local6 = function ( f16_arg0, f16_arg1, f16_arg2, f16_arg3 )
			local f16_local0 = "TransmissionContactList_" .. f16_arg0 .. "_" .. f16_arg1
			DataSources[f16_local0] = DataSourceHelpers.ListSetup( f16_local0, function ( controller )
				local items = {}
				local f17_local1 = f12_arg4["transmission" .. f16_arg1 .. "ContactsCount"] or 0
				for f17_local2 = 0, f17_local1 - 1, 1 do
					table.insert( items, {
						models = {
							contactIcon = f12_arg4["transmission" .. f16_arg1 .. "Contact" .. f17_local2 .. "Image"],
							contactName = Engine.Localize( "HEROES_CONTACT_X", f16_arg2, f16_arg3 + f17_local2, f12_arg4["transmission" .. f16_arg1 .. "Contact" .. f17_local2 .. "Name"] )
						}
					} )
				end
				return items
			end, true )
			return f16_local0
		end
		
		local f13_local7 = f12_arg4.transmissions or 0
		for f13_local8 = 0, f13_local7 - 1, 1 do
			local f13_local11, f13_local12 = nil
			if Dvar.allItemsUnlocked:get() then
				f13_local11 = false
			else
				f13_local11, f13_local12 = Engine.IsSpecialistTransmissionLocked( controller, f12_arg0.properties.heroIndex, f13_local8 + 1 )
			end
			if not f13_local11 then
				local f13_local13, f13_local14 = nil
				if f13_local8 == 4 then
					f13_local14 = f12_arg4["transmission" .. f13_local8 .. "ID"] or ""
					f13_local13 = "t7_menu_hero_bio_headshot_unknown"
				else
					f13_local14 = (f12_arg4.characterFrequency or "") .. "." .. (f12_arg4["transmission" .. f13_local8 .. "ID"] or "")
					f13_local13 = f12_arg1.cardBackIcon
				end
				table.insert( items, f13_local1( f13_local2( f13_local3, 1, "HEROES_TRANSMISSION" ), "t7_hud_hero_icon_filetype_audio", {
					cardBackIcon = f13_local13,
					transmissionName = Engine.Localize( "HEROES_TRANSMISSION_X", f13_local3, 1, f12_arg4["transmission" .. f13_local8 .. "Name"] or "" ),
					contactsListDatasource = f13_local6( f12_arg0.properties.heroIndex, f13_local8, f13_local3, 2 ),
					transmissionSynopsis = f12_arg4["transmission" .. f13_local8 .. "Synopsis"] or "",
					transmissionFrequency = f13_local14,
					alias = f12_arg4["transmission" .. f13_local8 .. "Alias"],
					frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Transmission",
					playingSound = false,
					isNew = CoD.CCUtility.IsTransmissionNew( controller, f12_arg1.bodyIndex, f13_local8 )
				}, {
					transmissionIndex = f13_local8,
					heroIndex = f12_arg1.bodyIndex
				} ) )
			elseif f13_local12 then
				local f13_local13 = "HEROES_COMPLETE_ASSIGNMENT_FOR_TRANSMISSION"
				local f13_local14 = ""
				local f13_local15 = ""
				local f13_local16 = ""
				local tableName = CoD.getStatsMilestoneTable( f13_local12.challengeTable + 1, CoD.PrestigeUtility.GetPermanentUnlockMode() )
				if f13_local8 == 0 then
				
				elseif f13_local8 == 4 or f13_local8 == 3 and not f12_arg5 then
					f13_local13 = "HEROES_ASSIGNMENT_CLASSIFIED"
				else
					f13_local14 = Engine.Localize( Engine.TableLookupGetColumnValueForRow( tableName, f13_local12.challengeRow, Enum.milestoneTableColumns_t.MILESTONE_COLUMN_STRING ), f13_local12.targetValue, f12_arg1.displayName )
				end
				f13_local14 = Engine.Localize( Engine.TableLookupGetColumnValueForRow( tableName, f13_local12.challengeRow, Enum.milestoneTableColumns_t.MILESTONE_COLUMN_STRING ) .. "_DESC", f13_local12.targetValue, f12_arg1.displayName )
				f13_local15 = f13_local12.currentValue / f13_local12.targetValue
				f13_local16 = Engine.Localize( "MENU_X_SLASH_Y", f13_local12.currentValue, f13_local12.targetValue )
			end
			f13_local3 = f13_local3 + 1
		end
		return items
	end, true )
	return f12_local0
end

CoD.CCUtility.CreateCarouselCardBackDatasource = function ( f12_arg0, f12_arg1, mode, controller, f12_arg4, f12_arg5 )
	local f12_local0 = "HeroCarouselCardBackList" .. f12_arg0.properties.heroIndex
	DataSources[f12_local0] = DataSourceHelpers.ListSetup( f12_local0, function ( controller )
		local items = {}
		local f13_local1 = function ( f14_arg0, f14_arg1, f14_arg2, f14_arg3 )
			local f14_local0 = {
				models = {
					text = f14_arg0,
					icon = f14_arg1
				},
				properties = {}
			}
			if f14_arg2 then
				for key, f14_local5 in pairs( f14_arg2 ) do
					f14_local0.models[key] = f14_local5
				end
			end
			f14_local0.models.alias = f14_local0.models.alias or ""
			if f14_arg3 then
				for key, f14_local5 in pairs( f14_arg3 ) do
					f14_local0.properties[key] = f14_local5
				end
			end
			return f14_local0
		end
		
		local f13_local2 = function ( f15_arg0, f15_arg1, f15_arg2 )
			return Engine.Localize( "HEROES_CARD_BACK_ENTRY", f15_arg0, f15_arg1, f15_arg2 or "" )
		end
		
		local f13_local3 = 1
		local loadoutInfo = Engine.GetLoadoutInfoForHero( mode, f12_arg0.properties.heroIndex, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_WEAPON )
		local loadoutInfo2 = Engine.GetLoadoutInfoForHero( mode, f12_arg0.properties.heroIndex, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_GADGET )

		local f13_local6 = f13_local1( f13_local2( f13_local3, 1, "HEROES_SIMULATION" ), "t7_hud_hero_icon_filetype_stats", {
			cardBackIcon = f12_arg1.cardBackIcon,
			realName = f12_arg1.realName,
			age = f12_arg1.age,
			genderString = f12_arg1.genderString,
			frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Stats"
		}, nil )
		if CoDShared.IsLootHero( f12_arg1 ) then
			if loadoutInfo then
				f13_local6.models.weaponName = loadoutInfo.itemName
				local f13_local7 = "specialiststats." .. f12_arg0.properties.heroIndex .. ".stats.kills_weapon"
				f13_local6.models.weaponKills = CoD.CACUtility.CombatRecordGetFullNameStat( controller, f13_local7 )
				f13_local6.models.weaponKillsPerUse = CombatRecordGetTwoStatRatioForItemIndexAndSpecificNumerator( controller, f13_local7, "used", loadoutInfo.itemIndex )
				f13_local6.models.weaponKillsPerDeath = CombatRecordGetTwoStatRatioForItemIndexAndSpecificNumerator( controller, f13_local7, "deathsDuringUse", loadoutInfo.itemIndex )
			end
			if loadoutInfo2 then
				f13_local6.models.abilityName = loadoutInfo2.itemName
				local f13_local7 = "specialiststats." .. f12_arg0.properties.heroIndex .. ".stats.kills_ability"
				f13_local6.models.abilityKills = CoD.CACUtility.CombatRecordGetFullNameStat( controller, f13_local7 )
				f13_local6.models.abilityKillsLabel = loadoutInfo2.itemName .. "_KILL_TYPE"
				f13_local6.models.abilityKillsPerUse = CombatRecordGetTwoStatRatioForItemIndexAndSpecificNumerator( controller, f13_local7, "used", loadoutInfo2.itemIndex )
				f13_local6.models.abilityKillsPerUseLabel = loadoutInfo2.itemName .. "_KILL_TYPE_PER_USE"
			end
		else
			if loadoutInfo then
				f13_local6.models.weaponName = loadoutInfo.itemName
				f13_local6.models.weaponKills = CombatRecordGetItemStatForItemIndex( controller, "kills", loadoutInfo.itemIndex )
				f13_local6.models.weaponKillsPerUse = CombatRecordGetTwoStatRatioForItemIndex( controller, "kills", "used", loadoutInfo.itemIndex )
				f13_local6.models.weaponKillsPerDeath = CombatRecordGetTwoStatRatioForItemIndex( controller, "kills", "deathsDuringUse", loadoutInfo.itemIndex )
			end
			if loadoutInfo2 then
				f13_local6.models.abilityName = loadoutInfo2.itemName
				f13_local6.models.abilityKills = CombatRecordGetItemStatForItemIndex( controller, "combatRecordStat", loadoutInfo2.itemIndex )
				f13_local6.models.abilityKillsLabel = loadoutInfo2.itemName .. "_KILL_TYPE"
				f13_local6.models.abilityKillsPerUse = CombatRecordGetTwoStatRatioForItemIndex( controller, "combatRecordStat", "used", loadoutInfo2.itemIndex )
				f13_local6.models.abilityKillsPerUseLabel = loadoutInfo2.itemName .. "_KILL_TYPE_PER_USE"
			end
		end
		table.insert( items, f13_local6 )
		f13_local3 = f13_local3 + 1

		table.insert( items, f13_local1( f13_local2( f13_local3, 1, "HEROES_BIO" ), "t7_hud_hero_icon_filetype_text", {
			cardBackIcon = f12_arg1.cardBackIcon,
			realName = f12_arg1.realName,
			age = f12_arg1.age,
			genderString = f12_arg1.genderString,
			bio = f12_arg1.bio,
			frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Bio"
		}, nil ) )
		f13_local3 = f13_local3 + 1
		if loadoutInfo then
			table.insert( items, f13_local1( f13_local2( f13_local3, 1, loadoutInfo.itemName ), "t7_hud_hero_icon_filetype_details", {
				weaponSubItem = f13_local2( f13_local3, 3, f12_arg1.weaponSubItemDesc ),
				weaponCardBackIcon = f12_arg1.weaponCardBackIcon or "blacktransparent",
				weaponCardBackSubIcon = f12_arg1.weaponCardBackSubIcon or "blacktransparent",
				weaponDesc = f12_arg1.weaponCardBackDesc,
				weaponSchemaTitle = f13_local2( f13_local3, 2, "HEROES_SCHEMA" ),
				weaponSchema = f12_arg1.weaponSchema,
				frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Weapon"
			}, nil ) )
		end
		f13_local3 = f13_local3 + 1
		if loadoutInfo2 then
			table.insert( items, f13_local1( f13_local2( f13_local3, 1, loadoutInfo2.itemName ), "t7_hud_hero_icon_filetype_details", {
				abilitySubItem = f13_local2( f13_local3, 3, f12_arg1.abilitySubItemDesc ),
				abilityCardBackIcon = f12_arg1.abilityCardBackIcon or "blacktransparent",
				abilityCardBackSubIcon = f12_arg1.abilityCardBackSubIcon or "blacktransparent",
				abilityDesc = f12_arg1.abilityCardBackDesc,
				abilitySchemaTitle = f13_local2( f13_local3, 2, "HEROES_SCHEMA" ),
				abilitySchema = f12_arg1.abilitySchema,
				frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Ability"
			}, nil ) )
		end
		f13_local3 = f13_local3 + 1

		local f13_local6 = function ( f16_arg0, f16_arg1, f16_arg2, f16_arg3 )
			local f16_local0 = "TransmissionContactList_" .. f16_arg0 .. "_" .. f16_arg1
			DataSources[f16_local0] = DataSourceHelpers.ListSetup( f16_local0, function ( controller )
				local items = {}
				local f17_local1 = f12_arg4["transmission" .. f16_arg1 .. "ContactsCount"] or 0
				for f17_local2 = 0, f17_local1 - 1, 1 do
					table.insert( items, {
						models = {
							contactIcon = f12_arg4["transmission" .. f16_arg1 .. "Contact" .. f17_local2 .. "Image"],
							contactName = Engine.Localize( "HEROES_CONTACT_X", f16_arg2, f16_arg3 + f17_local2, f12_arg4["transmission" .. f16_arg1 .. "Contact" .. f17_local2 .. "Name"] )
						}
					} )
				end
				return items
			end, true )
			return f16_local0
		end
		
		local f13_local7 = f12_arg4.transmissions or 0
		for f13_local8 = 0, f13_local7 - 1, 1 do
			local f13_local11, f13_local12 = nil
			if Dvar.allItemsUnlocked:get() then
				f13_local11 = false
			else
				f13_local11, f13_local12 = Engine.IsSpecialistTransmissionLocked( controller, f12_arg0.properties.heroIndex, f13_local8 + 1 )
			end
			if not f13_local11 then
				local f13_local13, f13_local14 = nil
				if f13_local8 == 4 then
					f13_local14 = f12_arg4["transmission" .. f13_local8 .. "ID"] or ""
					f13_local13 = "t7_menu_hero_bio_headshot_unknown"
				else
					f13_local14 = (f12_arg4.characterFrequency or "") .. "." .. (f12_arg4["transmission" .. f13_local8 .. "ID"] or "")
					f13_local13 = f12_arg1.cardBackIcon
				end
				table.insert( items, f13_local1( f13_local2( f13_local3, 1, "HEROES_TRANSMISSION" ), "t7_hud_hero_icon_filetype_audio", {
					cardBackIcon = f13_local13,
					transmissionName = Engine.Localize( "HEROES_TRANSMISSION_X", f13_local3, 1, f12_arg4["transmission" .. f13_local8 .. "Name"] or "" ),
					contactsListDatasource = f13_local6( f12_arg0.properties.heroIndex, f13_local8, f13_local3, 2 ),
					transmissionSynopsis = f12_arg4["transmission" .. f13_local8 .. "Synopsis"] or "",
					transmissionFrequency = f13_local14,
					alias = f12_arg4["transmission" .. f13_local8 .. "Alias"],
					frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Transmission",
					playingSound = false,
					isNew = CoD.CCUtility.IsTransmissionNew( controller, f12_arg1.bodyIndex, f13_local8 )
				}, {
					transmissionIndex = f13_local8,
					heroIndex = f12_arg1.bodyIndex
				} ) )
			elseif f13_local12 then
				local f13_local13 = "HEROES_COMPLETE_ASSIGNMENT_FOR_TRANSMISSION"
				local f13_local14 = ""
				local f13_local15 = ""
				local f13_local16 = ""
				local tableName = CoD.getStatsMilestoneTable( f13_local12.challengeTable + 1, CoD.PrestigeUtility.GetPermanentUnlockMode() )
				if f13_local8 == 0 then
				
				elseif f13_local8 == 4 or f13_local8 == 3 and not f12_arg5 then
					f13_local13 = "HEROES_ASSIGNMENT_CLASSIFIED"
				else
					f13_local14 = Engine.Localize( Engine.TableLookupGetColumnValueForRow( tableName, f13_local12.challengeRow, Enum.milestoneTableColumns_t.MILESTONE_COLUMN_STRING ), f13_local12.targetValue, f12_arg1.displayName )
				end
				f13_local14 = Engine.Localize( Engine.TableLookupGetColumnValueForRow( tableName, f13_local12.challengeRow, Enum.milestoneTableColumns_t.MILESTONE_COLUMN_STRING ) .. "_DESC", f13_local12.targetValue, f12_arg1.displayName )
				f13_local15 = f13_local12.currentValue / f13_local12.targetValue
				f13_local16 = Engine.Localize( "MENU_X_SLASH_Y", f13_local12.currentValue, f13_local12.targetValue )
			end
			f13_local3 = f13_local3 + 1
		end
		return items
	end, true )
	return f12_local0
end