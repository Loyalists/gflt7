require("ui.t7.utility.CCUtility_og")

DataSources.HeroCustomizationTabs = DataSourceHelpers.ListSetup("HeroCustomizationTabs", function(f21_arg0)
    local f21_local0 = {}
    local f21_local1 = function(f22_arg0, f22_arg1, f22_arg2)
        table.insert(f21_local0, {
            models = {
                tabName = f22_arg0,
                tabIcon = "",
                breadcrumbCount = 0
            },
            properties = {
                isBlackMarket = f22_arg1,
                selectIndex = not f22_arg1,
                filterName = f22_arg2
            }
        })
    end

    table.insert(f21_local0, {
        models = {
            tabIcon = CoD.buttonStrings.shoulderl
        },
        properties = {
            m_mouseDisabled = true
        }
    })
    f21_local1("MPUI_STANDARD_CAPS", false, CoD.CCUtility.PersonalizeHeroData.HeroCustomizationTabCategories[1])
    -- if IsLive() then
    -- 	f21_local1("MENU_BLACK_MARKET", true, CoD.CCUtility.PersonalizeHeroData.HeroCustomizationTabCategories[2])
    -- end
    table.insert(f21_local0, {
        models = {
            tabIcon = CoD.buttonStrings.shoulderr
        },
        properties = {
            m_mouseDisabled = true
        }
    })
    return f21_local0
end, false)

CoD.CCUtility.IsMissionCompleted = function(f33_arg0, f33_arg1)
    return true
end

CoD.CCUtility.IsBodyOrHelmetAccessible = function(f34_arg0, f34_arg1, f34_arg2, f34_arg3)
    if CoD.CCUtility.customizationMode == Enum.eModes.MODE_CAMPAIGN or Engine.IsCampaignGame() then
        local f34_local0 = CoD.getStatsMilestoneTable(2, Enum.eModes.MODE_CAMPAIGN)
        local f34_local1 = 1
        local f34_local2 = 2
        local f34_local3 = 3
        local f34_local4 = Engine.TableFindRows(f34_local0, f34_local1, f34_arg1)
        if f34_local4 ~= nil then
            for f34_local8, f34_local9 in ipairs(f34_local4) do
                local f34_local10 = Engine.TableLookupGetColumnValueForRow(f34_local0, f34_local9, f34_local2)
                local f34_local11 = Engine.TableLookupGetColumnValueForRow(f34_local0, f34_local9, f34_local3)
                if f34_local10 + 1 == f34_arg2 and
                    (f34_local11 == "none" or CoD.CCUtility.IsMissionCompleted(f34_arg0, f34_local11)) then
                    return true
                end
            end
        end
        return false
    elseif CoD.CCUtility.customizationMode == Enum.eModes.MODE_ZOMBIES or Engine.IsZombiesGame() then
		local heroIndex = CoD.CCUtility.Heroes.HeroIndexForEdits
		if f34_arg1 == "bodystyle" then
			-- soe beast
			-- refer to zm_character_customization
			if heroIndex == 4 and f34_arg2 == 5 then
				return false
			end
		end
		return true
	else
        return true
    end
end

CoD.CCUtility.CreateCarouselItemLoadoutDatasource = function ( f7_arg0, f7_arg1, f7_arg2 )
	local f7_local0 = "HeroCarouselItemLoadoutList" .. f7_arg0.properties.heroIndex
	DataSources[f7_local0] = DataSourceHelpers.ListSetup( f7_local0, function ( f8_arg0 )
		local f8_local0 = {}
		local f8_local1 = Engine.GetLoadoutTypeForHero( f8_arg0, f7_arg0.properties.heroIndex )
		for f8_local2 = 0, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_COUNT - 1, 1 do
			local f8_local5 = Engine.GetLoadoutInfoForHero( f7_arg1, f7_arg0.properties.heroIndex, f8_local2 )
			local f8_local6 = false
			-- if IsProgressionEnabled( f8_arg0 ) or IsLive() and IsFirstTimeSetup( f8_arg0, Enum.eModes.MODE_MULTIPLAYER ) then
			-- 	f8_local6 = Engine.IsItemLocked( f8_arg0, f8_local5.itemIndex, Enum.eModes.MODE_MULTIPLAYER )
			-- end
			if f8_local5 then
				if CoD.CCUtility.customizationMode == Enum.eModes.MODE_ZOMBIES then
					table.insert( f8_local0, {
						models = {
							name = Engine.Localize( "MENU_SELECT_CAPS" ),
							gameImageOff = f8_local5.gameImageOff,
							gameImageOn = f8_local5.gameImageOn,
							description = Engine.Localize( "GFL_CHARACTER_MENU_SELECT_DESC" ),
							header = CoD.CCUtility.GetHeaderForLoadoutSlot( f8_local2 ),
							equippedSlot = f8_local2,
							itemIndex = f8_local5.itemIndex,
							disabled = f8_local6,
							itemType = Enum.VoteItemType.VOTE_ITEM_TYPE_ITEM
						},
						properties = {
							equippedSlot = f8_local2,
							hintText = CoD.CCUtility.GetHintTextForLoadoutSlot( f8_local2 ),
							selectIndex = f8_local1 == f8_local2,
							heroIndex = f7_arg0.properties.heroIndex
						}
					} )
				else
					table.insert( f8_local0, {
						models = {
							name = f8_local5.itemName,
							gameImageOff = f8_local5.gameImageOff,
							gameImageOn = f8_local5.gameImageOn,
							description = f8_local5.itemDesc,
							header = CoD.CCUtility.GetHeaderForLoadoutSlot( f8_local2 ),
							equippedSlot = f8_local2,
							itemIndex = f8_local5.itemIndex,
							disabled = f8_local6,
							itemType = Enum.VoteItemType.VOTE_ITEM_TYPE_ITEM
						},
						properties = {
							equippedSlot = f8_local2,
							hintText = CoD.CCUtility.GetHintTextForLoadoutSlot( f8_local2 ),
							selectIndex = f8_local1 == f8_local2,
							heroIndex = f7_arg0.properties.heroIndex
						}
					} )
				end
			end
		end
		return f8_local0
	end, true )
	return f7_local0
end

local function IsSOEBeast( f13_arg0 )
	if f13_arg0 ~= nil and f13_arg0.assetName ~= nil and f13_arg0.assetName == "pbt_zm_zod_beast" then
		return true
	else
		return false
	end
end

CoD.CCUtility.HeroesListPrepare = function ( f77_arg0 )
	local f77_local0 = Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "autoevents" ), "cycled" )
	local f77_local1 = Engine.GetHeroList( CoD.CCUtility.customizationMode )
	local f77_local2 = {}
	local f77_local3 = Enum.CharacterGenderTypes.CHARACTER_GENDER_TYPE_ANY
	if CoD.CCUtility.customizationMode == Enum.eModes.MODE_CAMPAIGN then
		f77_local3 = Engine.GetEquippedGender( f77_arg0, Enum.eModes.MODE_CAMPAIGN )
	end
	local f77_local4 = CoD.CCUtility.CompletionEpicComplete( f77_arg0, f77_local1 )
	local f77_local5 = 0
	for f77_local11, f77_local12 in ipairs( f77_local1 ) do
		if f77_local3 == Enum.CharacterGenderTypes.CHARACTER_GENDER_TYPE_ANY or f77_local12.gender == f77_local3 then
			local f77_local9 = false
			if CoDShared.IsLootHero( f77_local12 ) then
				f77_local9 = not AllowLootHero( f77_arg0 )
			end

			if IsSOEBeast( f77_local12 ) then
				f77_local9 = true
			end

			if not f77_local9 then
				local f77_local10 = CoD.CCUtility.GetHeroModels( f77_local12, f77_local11, f77_arg0, f77_local4 )

				if CoDShared.IsLootHero( f77_local12 ) then
					table.insert( f77_local2, 1, f77_local10 )
					f77_local10.shouldIgnoreWhenCounting = true
					f77_local5 = f77_local5 + 1
				else
					table.insert( f77_local2, f77_local10 )
				end
			end
		end
	end
	if CoD.isPC then
		for f77_local11, f77_local12 in ipairs( f77_local2 ) do
			f77_local12.properties.carouselPos = f77_local11
		end
	end
	local f77_local6 = 1
	for f77_local12, f77_local9 in ipairs( f77_local2 ) do
		if not f77_local9.shouldIgnoreWhenCounting then
			f77_local9.models.count = Engine.Localize( "MENU_X_OF_Y", f77_local6, #f77_local2 - f77_local5 )
			f77_local6 = f77_local6 + 1
		end
	end
	return f77_local2
end

DataSources.HeroesList = DataSourceHelpers.ListSetup( "HeroesList", CoD.CCUtility.HeroesListPrepare, true )

CoD.CCUtility.GetHeroModels = function ( f75_arg0, f75_arg1, f75_arg2, f75_arg3 )
	local f75_local0 = Engine.GetEquippedInfoForHero( f75_arg2, CoD.CCUtility.customizationMode, f75_arg0.bodyIndex )
	local f75_local1 = Engine.GetHeroCustomizationTable( CoD.CCUtility.customizationMode, f75_arg0.bodyIndex )
	local f75_local2, f75_local3 = CoD.CCUtility.Heroes.GetHeroUnlockInfo( f75_arg2, f75_arg0.bodyIndex )
	local f75_local4 = CoD.CCUtility.Heroes.HeroIndexForEdits
	if not f75_local4 then
		f75_local4 = Engine.GetEquippedHero( f75_arg2, CoD.CCUtility.customizationMode )
	end
	local f75_local5 = Engine.GetHeroBundleInfo( CoD.CCUtility.customizationMode, f75_arg0.bodyIndex ) or {}
	local f75_local6 = {
		models = {
			backgroundWithCharacter = f75_arg0.backgroundWithCharacter or "blacktransparent",
			lockedBackgroundWithCharacter = f75_arg0.background,
			name = f75_arg0.displayName,
			unlockDescription = f75_local3,
			level = 1,
			unlockedCharacterSliver = f75_arg0.frozenMomentRender or "blacktransparent",
			lockedCharacterSliver = f75_local5.lockedSliverRender or "blacktransparent",
			disabled = f75_arg0.disabled or f75_local2,
			equippedSlot = Engine.GetLoadoutTypeForHero( f75_arg2, f75_arg0.bodyIndex ),
			selectedHeadInfo = CoD.CCUtility.CreateSelectedItemModel( f75_arg2, f75_local1, f75_local0, f75_arg0.bodyIndex, Enum.CharacterItemType.CHARACTER_ITEM_TYPE_HELMET ),
			selectedBodyInfo = CoD.CCUtility.CreateSelectedItemModel( f75_arg2, f75_local1, f75_local0, f75_arg0.bodyIndex, Enum.CharacterItemType.CHARACTER_ITEM_TYPE_BODY ),
			selectedShowcaseWeaponInfo = nil,
			selectedTauntInfo = nil,
			itemType = Enum.VoteItemType.VOTE_ITEM_TYPE_ITEM,
			heroIndex = f75_arg0.bodyIndex,
			breadcrumbCount = CoD.CCUtility.Heroes.GetPersonalizationNewCount( f75_arg2, f75_arg0.bodyIndex )
		},
		properties = {
			heroIndex = f75_arg0.bodyIndex,
			selectIndex = f75_arg0.bodyIndex == f75_local4
		}
	}
	if CoDShared.IsLootHero( f75_arg0 ) then
		local f75_local7 = function ( f76_arg0, f76_arg1 )
			if f76_arg0:exists() then
				return tonumber( f76_arg0:get() )
			else
				return f76_arg1
			end
		end
		
		f75_local6.models.contractsRemaining = 0
		f75_local6.models.isActivated = false
		f75_local6.models.activeTimeRemaining = 0
		local f75_local8 = Dvar.ui_enableAllHeroes:get()
		if f75_local8 then
			local f75_local9 = f75_local6.models
			local f75_local10 = f75_local7
			local f75_local11 = Dvar.ui_blackjack_contracts
			local f75_local12
			if f75_local8 then
				f75_local12 = 1
				if not f75_local12 then
				
				else
					f75_local9.contractsRemaining = f75_local10( f75_local11, f75_local12 )
					f75_local6.models.isActivated = f75_local7( Dvar.ui_blackjack_active, 1 ) == 1
					f75_local6.models.activeTimeRemaining = f75_local7( Dvar.ui_blackjack_remainingTime, 29754 )
				end
			end
			f75_local12 = 0
		else
			local f75_local9 = Engine.StorageGetBuffer( f75_arg2, Enum.StorageFileType.STORAGE_MP_STATS_ONLINE )
			if f75_local9 and f75_local9.TenthSpecialistContract then
				f75_local6.models.contractsRemaining = f75_local9.blackjack_contract_count:get()
			end
			local f75_local10 = Engine.ConsumableGet( f75_arg2, "blackjack", "awarded" ) - Engine.ConsumableGet( f75_arg2, "blackjack", "consumed" )
			f75_local6.models.isActivated = f75_local10 > 0
			f75_local6.models.activeTimeRemaining = f75_local10 * 1000
		end
		f75_local6.models.breadcrumbCount = 0
		f75_local6.properties.customWidgetOverride = CoD.ChooseContractCharacterLoadoutCarouselItem
	end
	if not f75_local6.models.disabled then
		f75_local6.models.loadoutDatasource = CoD.CCUtility.CreateCarouselItemLoadoutDatasource( f75_local6, CoD.CCUtility.customizationMode, f75_arg2 )
		if CoD.CCUtility.customizationMode == Enum.eModes.MODE_ZOMBIES then
			f75_local6.models.cardBackDatasource = CoD.CCUtility.CreateZMCarouselCardBackDatasource( f75_local6, f75_arg0, CoD.CCUtility.customizationMode, f75_arg2, f75_local5, f75_arg3 )
		else
			f75_local6.models.cardBackDatasource = CoD.CCUtility.CreateCarouselCardBackDatasource( f75_local6, f75_arg0, CoD.CCUtility.customizationMode, f75_arg2, f75_local5, f75_arg3 )
		end
		f75_local6.models.newTransmissions = CoD.CCUtility.GetTransmissionNewCount( f75_arg2, f75_arg0.bodyIndex, f75_local5 )
	end
	return f75_local6
end

CoD.CCUtility.CreateZMCarouselCardBackDatasource = function ( f12_arg0, f12_arg1, f12_arg2, f12_arg3, f12_arg4, f12_arg5 )
	local f12_local0 = "HeroCarouselCardBackList" .. f12_arg0.properties.heroIndex
	DataSources[f12_local0] = DataSourceHelpers.ListSetup( f12_local0, function ( f13_arg0 )
		local f13_local0 = {}
		local f13_local1 = function ( f14_arg0, f14_arg1, f14_arg2, f14_arg3 )
			local f14_local0 = {
				models = {
					text = f14_arg0,
					icon = f14_arg1
				},
				properties = {}
			}
			if f14_arg2 then
				for f14_local4, f14_local5 in pairs( f14_arg2 ) do
					f14_local0.models[f14_local4] = f14_local5
				end
			end
			f14_local0.models.alias = f14_local0.models.alias or ""
			if f14_arg3 then
				for f14_local4, f14_local5 in pairs( f14_arg3 ) do
					f14_local0.properties[f14_local4] = f14_local5
				end
			end
			return f14_local0
		end
		
		local f13_local2 = function ( f15_arg0, f15_arg1, f15_arg2 )
			return Engine.Localize( "HEROES_CARD_BACK_ENTRY", f15_arg0, f15_arg1, f15_arg2 or "" )
		end
		
		local f13_local3 = 1
		local f13_local4 = Engine.GetLoadoutInfoForHero( f12_arg2, f12_arg0.properties.heroIndex, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_WEAPON )
		local f13_local5 = Engine.GetLoadoutInfoForHero( f12_arg2, f12_arg0.properties.heroIndex, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_GADGET )
		table.insert( f13_local0, f13_local1( f13_local2( f13_local3, 1, "HEROES_BIO" ), "t7_hud_hero_icon_filetype_text", {
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
			DataSources[f16_local0] = DataSourceHelpers.ListSetup( f16_local0, function ( f17_arg0 )
				local f17_local0 = {}
				local f17_local1 = f12_arg4["transmission" .. f16_arg1 .. "ContactsCount"] or 0
				for f17_local2 = 0, f17_local1 - 1, 1 do
					table.insert( f17_local0, {
						models = {
							contactIcon = f12_arg4["transmission" .. f16_arg1 .. "Contact" .. f17_local2 .. "Image"],
							contactName = Engine.Localize( "HEROES_CONTACT_X", f16_arg2, f16_arg3 + f17_local2, f12_arg4["transmission" .. f16_arg1 .. "Contact" .. f17_local2 .. "Name"] )
						}
					} )
				end
				return f17_local0
			end, true )
			return f16_local0
		end
		
		local f13_local7 = f12_arg4.transmissions or 0
		for f13_local8 = 0, f13_local7 - 1, 1 do
			local f13_local11, f13_local12 = nil
			if Dvar.allItemsUnlocked:get() then
				f13_local11 = false
			else
				f13_local11, f13_local12 = Engine.IsSpecialistTransmissionLocked( f13_arg0, f12_arg0.properties.heroIndex, f13_local8 + 1 )
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
				table.insert( f13_local0, f13_local1( f13_local2( f13_local3, 1, "HEROES_TRANSMISSION" ), "t7_hud_hero_icon_filetype_audio", {
					cardBackIcon = f13_local13,
					transmissionName = Engine.Localize( "HEROES_TRANSMISSION_X", f13_local3, 1, f12_arg4["transmission" .. f13_local8 .. "Name"] or "" ),
					contactsListDatasource = f13_local6( f12_arg0.properties.heroIndex, f13_local8, f13_local3, 2 ),
					transmissionSynopsis = f12_arg4["transmission" .. f13_local8 .. "Synopsis"] or "",
					transmissionFrequency = f13_local14,
					alias = f12_arg4["transmission" .. f13_local8 .. "Alias"],
					frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Transmission",
					playingSound = false,
					isNew = CoD.CCUtility.IsTransmissionNew( f13_arg0, f12_arg1.bodyIndex, f13_local8 )
				}, {
					transmissionIndex = f13_local8,
					heroIndex = f12_arg1.bodyIndex
				} ) )
			elseif f13_local12 then
				local f13_local13 = "HEROES_COMPLETE_ASSIGNMENT_FOR_TRANSMISSION"
				local f13_local14 = ""
				local f13_local15 = ""
				local f13_local16 = ""
				local f13_local17 = CoD.getStatsMilestoneTable( f13_local12.challengeTable + 1, CoD.PrestigeUtility.GetPermanentUnlockMode() )
				if f13_local8 == 0 then
				
				elseif f13_local8 == 4 or f13_local8 == 3 and not f12_arg5 then
					f13_local13 = "HEROES_ASSIGNMENT_CLASSIFIED"
				else
					f13_local14 = Engine.Localize( Engine.TableLookupGetColumnValueForRow( f13_local17, f13_local12.challengeRow, Enum.milestoneTableColumns_t.MILESTONE_COLUMN_STRING ), f13_local12.targetValue, f12_arg1.displayName )
				end
				f13_local14 = Engine.Localize( Engine.TableLookupGetColumnValueForRow( f13_local17, f13_local12.challengeRow, Enum.milestoneTableColumns_t.MILESTONE_COLUMN_STRING ) .. "_DESC", f13_local12.targetValue, f12_arg1.displayName )
				f13_local15 = f13_local12.currentValue / f13_local12.targetValue
				f13_local16 = Engine.Localize( "MENU_X_SLASH_Y", f13_local12.currentValue, f13_local12.targetValue )
			end
			f13_local3 = f13_local3 + 1
		end
		return f13_local0
	end, true )
	return f12_local0
end

CoD.CCUtility.CreateCarouselCardBackDatasource = function ( f12_arg0, f12_arg1, f12_arg2, f12_arg3, f12_arg4, f12_arg5 )
	local f12_local0 = "HeroCarouselCardBackList" .. f12_arg0.properties.heroIndex
	DataSources[f12_local0] = DataSourceHelpers.ListSetup( f12_local0, function ( f13_arg0 )
		local f13_local0 = {}
		local f13_local1 = function ( f14_arg0, f14_arg1, f14_arg2, f14_arg3 )
			local f14_local0 = {
				models = {
					text = f14_arg0,
					icon = f14_arg1
				},
				properties = {}
			}
			if f14_arg2 then
				for f14_local4, f14_local5 in pairs( f14_arg2 ) do
					f14_local0.models[f14_local4] = f14_local5
				end
			end
			f14_local0.models.alias = f14_local0.models.alias or ""
			if f14_arg3 then
				for f14_local4, f14_local5 in pairs( f14_arg3 ) do
					f14_local0.properties[f14_local4] = f14_local5
				end
			end
			return f14_local0
		end
		
		local f13_local2 = function ( f15_arg0, f15_arg1, f15_arg2 )
			return Engine.Localize( "HEROES_CARD_BACK_ENTRY", f15_arg0, f15_arg1, f15_arg2 or "" )
		end
		
		local f13_local3 = 1
		local f13_local4 = Engine.GetLoadoutInfoForHero( f12_arg2, f12_arg0.properties.heroIndex, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_WEAPON )
		local f13_local5 = Engine.GetLoadoutInfoForHero( f12_arg2, f12_arg0.properties.heroIndex, Enum.heroLoadoutTypes_e.HERO_LOADOUT_TYPE_GADGET )

		local f13_local6 = f13_local1( f13_local2( f13_local3, 1, "HEROES_SIMULATION" ), "t7_hud_hero_icon_filetype_stats", {
			cardBackIcon = f12_arg1.cardBackIcon,
			realName = f12_arg1.realName,
			age = f12_arg1.age,
			genderString = f12_arg1.genderString,
			frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Stats"
		}, nil )
		if CoDShared.IsLootHero( f12_arg1 ) then
			if f13_local4 then
				f13_local6.models.weaponName = f13_local4.itemName
				local f13_local7 = "specialiststats." .. f12_arg0.properties.heroIndex .. ".stats.kills_weapon"
				f13_local6.models.weaponKills = CoD.CACUtility.CombatRecordGetFullNameStat( f13_arg0, f13_local7 )
				f13_local6.models.weaponKillsPerUse = CombatRecordGetTwoStatRatioForItemIndexAndSpecificNumerator( f13_arg0, f13_local7, "used", f13_local4.itemIndex )
				f13_local6.models.weaponKillsPerDeath = CombatRecordGetTwoStatRatioForItemIndexAndSpecificNumerator( f13_arg0, f13_local7, "deathsDuringUse", f13_local4.itemIndex )
			end
			if f13_local5 then
				f13_local6.models.abilityName = f13_local5.itemName
				local f13_local7 = "specialiststats." .. f12_arg0.properties.heroIndex .. ".stats.kills_ability"
				f13_local6.models.abilityKills = CoD.CACUtility.CombatRecordGetFullNameStat( f13_arg0, f13_local7 )
				f13_local6.models.abilityKillsLabel = f13_local5.itemName .. "_KILL_TYPE"
				f13_local6.models.abilityKillsPerUse = CombatRecordGetTwoStatRatioForItemIndexAndSpecificNumerator( f13_arg0, f13_local7, "used", f13_local5.itemIndex )
				f13_local6.models.abilityKillsPerUseLabel = f13_local5.itemName .. "_KILL_TYPE_PER_USE"
			end
		else
			if f13_local4 then
				f13_local6.models.weaponName = f13_local4.itemName
				f13_local6.models.weaponKills = CombatRecordGetItemStatForItemIndex( f13_arg0, "kills", f13_local4.itemIndex )
				f13_local6.models.weaponKillsPerUse = CombatRecordGetTwoStatRatioForItemIndex( f13_arg0, "kills", "used", f13_local4.itemIndex )
				f13_local6.models.weaponKillsPerDeath = CombatRecordGetTwoStatRatioForItemIndex( f13_arg0, "kills", "deathsDuringUse", f13_local4.itemIndex )
			end
			if f13_local5 then
				f13_local6.models.abilityName = f13_local5.itemName
				f13_local6.models.abilityKills = CombatRecordGetItemStatForItemIndex( f13_arg0, "combatRecordStat", f13_local5.itemIndex )
				f13_local6.models.abilityKillsLabel = f13_local5.itemName .. "_KILL_TYPE"
				f13_local6.models.abilityKillsPerUse = CombatRecordGetTwoStatRatioForItemIndex( f13_arg0, "combatRecordStat", "used", f13_local5.itemIndex )
				f13_local6.models.abilityKillsPerUseLabel = f13_local5.itemName .. "_KILL_TYPE_PER_USE"
			end
		end
		table.insert( f13_local0, f13_local6 )
		f13_local3 = f13_local3 + 1

		table.insert( f13_local0, f13_local1( f13_local2( f13_local3, 1, "HEROES_BIO" ), "t7_hud_hero_icon_filetype_text", {
			cardBackIcon = f12_arg1.cardBackIcon,
			realName = f12_arg1.realName,
			age = f12_arg1.age,
			genderString = f12_arg1.genderString,
			bio = f12_arg1.bio,
			frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Bio"
		}, nil ) )
		f13_local3 = f13_local3 + 1
		if f13_local4 then
			table.insert( f13_local0, f13_local1( f13_local2( f13_local3, 1, f13_local4.itemName ), "t7_hud_hero_icon_filetype_details", {
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
		if f13_local5 then
			table.insert( f13_local0, f13_local1( f13_local2( f13_local3, 1, f13_local5.itemName ), "t7_hud_hero_icon_filetype_details", {
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
			DataSources[f16_local0] = DataSourceHelpers.ListSetup( f16_local0, function ( f17_arg0 )
				local f17_local0 = {}
				local f17_local1 = f12_arg4["transmission" .. f16_arg1 .. "ContactsCount"] or 0
				for f17_local2 = 0, f17_local1 - 1, 1 do
					table.insert( f17_local0, {
						models = {
							contactIcon = f12_arg4["transmission" .. f16_arg1 .. "Contact" .. f17_local2 .. "Image"],
							contactName = Engine.Localize( "HEROES_CONTACT_X", f16_arg2, f16_arg3 + f17_local2, f12_arg4["transmission" .. f16_arg1 .. "Contact" .. f17_local2 .. "Name"] )
						}
					} )
				end
				return f17_local0
			end, true )
			return f16_local0
		end
		
		local f13_local7 = f12_arg4.transmissions or 0
		for f13_local8 = 0, f13_local7 - 1, 1 do
			local f13_local11, f13_local12 = nil
			if Dvar.allItemsUnlocked:get() then
				f13_local11 = false
			else
				f13_local11, f13_local12 = Engine.IsSpecialistTransmissionLocked( f13_arg0, f12_arg0.properties.heroIndex, f13_local8 + 1 )
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
				table.insert( f13_local0, f13_local1( f13_local2( f13_local3, 1, "HEROES_TRANSMISSION" ), "t7_hud_hero_icon_filetype_audio", {
					cardBackIcon = f13_local13,
					transmissionName = Engine.Localize( "HEROES_TRANSMISSION_X", f13_local3, 1, f12_arg4["transmission" .. f13_local8 .. "Name"] or "" ),
					contactsListDatasource = f13_local6( f12_arg0.properties.heroIndex, f13_local8, f13_local3, 2 ),
					transmissionSynopsis = f12_arg4["transmission" .. f13_local8 .. "Synopsis"] or "",
					transmissionFrequency = f13_local14,
					alias = f12_arg4["transmission" .. f13_local8 .. "Alias"],
					frameWidget = "CoD.ChooseCharacterLoadout_CardBack_Transmission",
					playingSound = false,
					isNew = CoD.CCUtility.IsTransmissionNew( f13_arg0, f12_arg1.bodyIndex, f13_local8 )
				}, {
					transmissionIndex = f13_local8,
					heroIndex = f12_arg1.bodyIndex
				} ) )
			elseif f13_local12 then
				local f13_local13 = "HEROES_COMPLETE_ASSIGNMENT_FOR_TRANSMISSION"
				local f13_local14 = ""
				local f13_local15 = ""
				local f13_local16 = ""
				local f13_local17 = CoD.getStatsMilestoneTable( f13_local12.challengeTable + 1, CoD.PrestigeUtility.GetPermanentUnlockMode() )
				if f13_local8 == 0 then
				
				elseif f13_local8 == 4 or f13_local8 == 3 and not f12_arg5 then
					f13_local13 = "HEROES_ASSIGNMENT_CLASSIFIED"
				else
					f13_local14 = Engine.Localize( Engine.TableLookupGetColumnValueForRow( f13_local17, f13_local12.challengeRow, Enum.milestoneTableColumns_t.MILESTONE_COLUMN_STRING ), f13_local12.targetValue, f12_arg1.displayName )
				end
				f13_local14 = Engine.Localize( Engine.TableLookupGetColumnValueForRow( f13_local17, f13_local12.challengeRow, Enum.milestoneTableColumns_t.MILESTONE_COLUMN_STRING ) .. "_DESC", f13_local12.targetValue, f12_arg1.displayName )
				f13_local15 = f13_local12.currentValue / f13_local12.targetValue
				f13_local16 = Engine.Localize( "MENU_X_SLASH_Y", f13_local12.currentValue, f13_local12.targetValue )
			end
			f13_local3 = f13_local3 + 1
		end
		return f13_local0
	end, true )
	return f12_local0
end