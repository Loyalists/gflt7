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
							name = "SELECT",
							gameImageOff = f8_local5.gameImageOff,
							gameImageOn = f8_local5.gameImageOn,
							description = "Choose the preferred T-Doll as your in-game character!",
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