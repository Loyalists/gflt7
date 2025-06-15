if not CoD.CharacterUtil then
    CoD.CharacterUtil = {}
end

CoD.CharacterUtil.GetHeroesList_InGame = function(customizationMode)
    local heroes = {}
    table.insert(heroes, {
        displayName = "M16A1",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_m16a1",
		frozenMomentRender = "t7_menu_choosespecialist_default_m16a1",
		disabled = false,
		slots = {
			{
				displayName = "MENU_CLASSIC",
				character = "m16a1_prime",
				gameImageOff = "t7_gfl_chibi_m16a1_prime",
			},
			{
				displayName = "Sangvis Ferri",
				character = "m16a1",
				gameImageOff = "t7_gfl_chibi_m16a1",
			},
		},
    })

    -- table.insert(heroes, {
    --     displayName = "M16A1 (SF)",
    --     backgroundWithCharacter = "t7_menu_mp_hero_background_with_m16a1_sf",
	-- 	frozenMomentRender = "t7_menu_choosespecialist_default_m16a1_sf",
	-- 	disabled = false,
	-- 	slots = {
	-- 		{
	-- 			character = "m16a1",
	-- 			gameImageOff = "t7_gfl_chibi_m16a1",
	-- 		},
	-- 	},
    -- })

    table.insert(heroes, {
        displayName = "M4A1",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_m4a1",
		frozenMomentRender = "t7_menu_choosespecialist_default_m4a1",
		disabled = false,
		slots = {
			{
				character = "m4a1",
				gameImageOff = "t7_gfl_chibi_m4a1",
			},
		},
    })

    table.insert(heroes, {
        displayName = "AK-12",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_firebreak",
		frozenMomentRender = "t7_menu_choosespecialist_default_firebreak",
		disabled = false,
		slots = {
			{
				character = "ak12",
				gameImageOff = "t7_gfl_chibi_ak12",
			},
		},
    })

    table.insert(heroes, {
        displayName = "AN-94",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_an94",
		frozenMomentRender = "t7_menu_choosespecialist_default_an94",
		disabled = false,
		slots = {
			{
				character = "an94",
				gameImageOff = "t7_gfl_chibi_an94",
			},
		},
    })

    table.insert(heroes, {
        displayName = "HK416",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_grenadier",
		frozenMomentRender = "t7_menu_choosespecialist_default_battery",
		disabled = false,
		slots = {
			{
				character = "hk416",
				gameImageOff = "t7_gfl_chibi_hk416",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Howa Type 89",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_enforcer",
		frozenMomentRender = "t7_menu_choosespecialist_default_seraph",
		disabled = false,
		slots = {
			{
				character = "type89",
				gameImageOff = "t7_gfl_chibi_type89",
			},
		},
    })

    table.insert(heroes, {
        displayName = "AK-Alfa",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_technomancer",
		frozenMomentRender = "t7_menu_choosespecialist_default_prophet",
		disabled = false,
		slots = {
			{
				character = "tololo",
				gameImageOff = "t7_gfl_chibi_tololo",
			},
		},
    })

    table.insert(heroes, {
		character = "suomi",
        displayName = "Suomi",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_suomi",
		frozenMomentRender = "t7_menu_choosespecialist_default_suomi",
		disabled = false,
		slots = {
			{
				character = "suomi",
				gameImageOff = "t7_gfl_chibi_suomi",
			},
		},
    })

    table.insert(heroes, {
        displayName = "RFB",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_rfb",
		frozenMomentRender = "t7_menu_choosespecialist_default_rfb",
		disabled = false,
		slots = {
			{
				character = "rfb",
				gameImageOff = "t7_gfl_chibi_rfb",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Vepley",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_vepley",
		frozenMomentRender = "t7_menu_choosespecialist_default_vepley",
		disabled = false,
		slots = {
			{
				character = "vepley_backpack",
				displayName = "MENU_NORMAL_CAPS",
				gameImageOff = "t7_gfl_chibi_vepley",
			},
			{
				character = "vepley",
				displayName = "w/o Backpack",
				gameImageOff = "t7_gfl_chibi_vepley",
			},
		},
    })

    table.insert(heroes, {
        displayName = "MP7",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_mp7",
		frozenMomentRender = "t7_menu_choosespecialist_default_mp7",
		disabled = false,
		slots = {
			{
				character = "mp7_tights",
				displayName = "MENU_NORMAL_CAPS",
				gameImageOff = "t7_gfl_chibi_mp7",
			},
			{
				character = "mp7_casual_tights",
				displayName = "Casual",
				gameImageOff = "t7_gfl_chibi_mp7",
			},
		},
    })

    table.insert(heroes, {
        displayName = "M4 SOPMOD II",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_mercenary",
		frozenMomentRender = "t7_menu_choosespecialist_default_ruin",
		disabled = false,
		slots = {
			{
				character = "m4_sopmod_ii",
				gameImageOff = "t7_gfl_chibi_m4_sopmod_ii",
			},
		},
    })

    table.insert(heroes, {
        displayName = "RO635",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_trapper",
		frozenMomentRender = "t7_menu_choosespecialist_default_nomad",
		disabled = false,
		slots = {
			{
				character = "ro635",
				gameImageOff = "t7_gfl_chibi_ro635",
			},
		},
    })

    table.insert(heroes, {
        displayName = "ST AR-15",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_st_ar15",
		frozenMomentRender = "t7_menu_choosespecialist_default_st_ar15",
		disabled = false,
		slots = {
			{
				character = "st_ar15",
				gameImageOff = "t7_gfl_chibi_st_ar15",
			},
		},
    })

    table.insert(heroes, {
        displayName = "P90",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_blackmarket",
		frozenMomentRender = "t7_menu_choosespecialist_default_blackmarket",
		disabled = false,
		slots = {
			{
				character = "p90",
				gameImageOff = "t7_gfl_chibi_p90",
			},
		},
    })

    table.insert(heroes, {
        displayName = "G36",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_centaureissi",
		frozenMomentRender = "t7_menu_choosespecialist_default_centaureissi",
		disabled = false,
		slots = {
			{
				character = "centaureissi",
				gameImageOff = "t7_gfl_chibi_centaureissi",
			},
		},
    })

    table.insert(heroes, {
        displayName = "G36C",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_g36c",
		frozenMomentRender = "t7_menu_choosespecialist_default_g36c",
		disabled = false,
		slots = {
			{
				character = "g36c",
				gameImageOff = "t7_gfl_chibi_g36c",
			},
		},
    })

    table.insert(heroes, {
        displayName = "9A-91",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_9a91",
		frozenMomentRender = "t7_menu_choosespecialist_default_9a91",
		disabled = false,
		slots = {
			{
				character = "9a91",
				gameImageOff = "t7_gfl_chibi_9a91",
			},
		},
    })

    table.insert(heroes, {
        displayName = "UMP45",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_spectre",
		frozenMomentRender = "t7_menu_choosespecialist_default_spectre",
		disabled = false,
		slots = {
			{
				character = "ump45",
				gameImageOff = "t7_gfl_chibi_ump45",
			},
		},
    })

    table.insert(heroes, {
        displayName = "UMP9",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_lenna",
		frozenMomentRender = "t7_menu_choosespecialist_default_lenna",
		disabled = false,
		slots = {
			{
				character = "lenna_base",
				displayName = "MENU_NORMAL_CAPS",
				gameImageOff = "t7_gfl_chibi_lenna",
			},
			{
				character = "lenna_ssr",
				displayName = "Flying Phantom",
				gameImageOff = "t7_gfl_chibi_lenna",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Super SASS",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_outrider",
		frozenMomentRender = "t7_menu_choosespecialist_default_outrider",
		disabled = false,
		slots = {
			{
				character = "super_sass",
				gameImageOff = "t7_gfl_chibi_super_sass",
			},
		},
    })

    table.insert(heroes, {
        displayName = "WA2000",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_wa2000",
		frozenMomentRender = "t7_menu_choosespecialist_default_wa2000",
		disabled = false,
		slots = {
			{
				character = "macqiato",
				gameImageOff = "t7_gfl_chibi_macqiato",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Vector",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_vector",
		frozenMomentRender = "t7_menu_choosespecialist_default_vector",
		disabled = false,
		slots = {
			{
				character = "vector_p2",
				displayName = "MENU_CLASSIC",
				gameImageOff = "t7_gfl_chibi_vector",
			},
			{
				character = "vector_p1",
				displayName = "School",
				gameImageOff = "t7_gfl_chibi_vector",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Negev",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_negev",
		frozenMomentRender = "t7_menu_choosespecialist_default_negev",
		disabled = false,
		slots = {
			{
				character = "negev",
				gameImageOff = "t7_gfl_chibi_negev",
			},
		},
    })

    table.insert(heroes, {
        displayName = "G11",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_g11",
		frozenMomentRender = "t7_menu_choosespecialist_default_g11",
		disabled = false,
		slots = {
			{
				character = "g11",
				gameImageOff = "t7_gfl_chibi_g11",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Dima",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_dima",
		frozenMomentRender = "t7_menu_choosespecialist_default_dima",
		disabled = false,
		slots = {
			{
				character = "dima",
				gameImageOff = "t7_gfl_chibi_dima",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Jaeger",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_sf",
		frozenMomentRender = "t7_menu_choosespecialist_default_jaeger",
		disabled = false,
		slots = {
			{
				character = "jaeger",
				gameImageOff = "t7_gfl_chibi_jaeger",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Guard",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_sf",
		frozenMomentRender = "t7_menu_choosespecialist_default_guard",
		disabled = false,
		slots = {
			{
				character = "guard",
				gameImageOff = "t7_gfl_chibi_guard",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Ripper",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_sf",
		frozenMomentRender = "t7_menu_choosespecialist_default_ripper",
		disabled = false,
		slots = {
			{
				character = "ripper",
				gameImageOff = "t7_gfl_chibi_ripper",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Vespid",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_sf",
		frozenMomentRender = "t7_menu_choosespecialist_default_vespid",
		disabled = false,
		slots = {
			{
				character = "vespid",
				gameImageOff = "t7_gfl_chibi_vespid",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Ouroboros",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_reaper",
		frozenMomentRender = "t7_menu_choosespecialist_default_reaper",
		disabled = false,
		slots = {
			{
				character = "ouroboros",
				gameImageOff = "t7_gfl_chibi_ouroboros",
			},
		},
    })

    table.insert(heroes, {
        displayName = "Dreamer",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_reaper",
		frozenMomentRender = "t7_menu_choosespecialist_default_dreamer",
		disabled = false,
		slots = {
			{
				character = "dreamer",
				gameImageOff = "t7_gfl_chibi_dreamer",
			},
		},
    })

	for i, hero in ipairs( heroes ) do
		local index = i - 1
		hero.bodyIndex = index
	end

	return heroes
end

CoD.CharacterUtil.GetCharacterFromHeroesList = function(heroes, element)
	if not heroes or not element then
		return nil
	end
	local index = element.heroIndex
	for _, hero in ipairs( heroes ) do
		if hero and hero.bodyIndex and index == hero.bodyIndex and hero.slots then
			for k, slot in ipairs( hero.slots ) do
				if k == element.equippedSlot then
					return slot.character
				end
			end
		end
	end

	return nil
end

CoD.CharacterUtil.SendCharacterSystemResponse = function( controller, character )
	Engine.SendMenuResponse(controller, "popup_leavegame", "CharacterSystem" .. "," .. character )
end

CoD.CharacterUtil.SelectHero_InGame = function( element, controller )
    local heroes = CoD.CharacterUtil.GetHeroesList_InGame( CoD.CCUtility.customizationMode )
    local char = CoD.CharacterUtil.GetCharacterFromHeroesList(heroes, element)
    if char then
        CoD.CharacterUtil.SendCharacterSystemResponse(controller, char)
    end
end

CoD.CharacterUtil.CreateCarouselItemLoadoutDatasource_InGame = function ( f7_arg0, f7_arg1, f7_arg2 )
	local f7_local0 = "HeroCarouselItemLoadoutList_InGame" .. f7_arg0.properties.heroIndex
	DataSources[f7_local0] = DataSourceHelpers.ListSetup( f7_local0, function ( f8_arg0 )
		local f8_local0 = {}
		if not f7_arg0.slots then
			return f8_local0
		end
		
		for i, slot in ipairs(f7_arg0.slots) do
			if slot then
				table.insert( f8_local0, {
					models = {
						name = Engine.Localize( slot.displayName or "MENU_SELECT_CAPS" ),
						gameImageOff = slot.gameImageOff or "blacktransparent",
						gameImageOn = slot.gameImageOn or "blacktransparent",
						description = Engine.Localize( slot.description or "GFL_CHARACTER_MENU_SELECT_DESC" ),
						header = CoD.CCUtility.GetHeaderForLoadoutSlot( i ),
						equippedSlot = i,
						itemIndex = i,
						disabled = false,
						itemType = Enum.VoteItemType.VOTE_ITEM_TYPE_ITEM
					},
					properties = {
						equippedSlot = i,
						hintText = CoD.CCUtility.GetHintTextForLoadoutSlot( i ),
						selectIndex = i == 1,
						heroIndex = f7_arg0.properties.heroIndex
					}
				} )
			end
		end
		return f8_local0
	end, true )
	return f7_local0
end

CoD.CharacterUtil.GetHeroModels_InGame = function ( f75_arg0, f75_arg1, f75_arg2, f75_arg3 )
	local f75_local4 = CoD.CCUtility.Heroes.HeroIndexForEdits
	if not f75_local4 then
		f75_local4 = 0
	end
	local f75_local6 = {
		models = {
			backgroundWithCharacter = f75_arg0.backgroundWithCharacter or "blacktransparent",
			lockedBackgroundWithCharacter = f75_arg0.backgroundWithCharacter or "blacktransparent",
			name = f75_arg0.displayName,
			unlockDescription = "",
			level = 1,
			unlockedCharacterSliver = f75_arg0.frozenMomentRender or "blacktransparent",
			lockedCharacterSliver = f75_arg0.frozenMomentRender or "blacktransparent",
			disabled = f75_arg0.disabled or false,
			equippedSlot = 0,
			selectedHeadInfo = nil,
			selectedBodyInfo = nil,
			selectedShowcaseWeaponInfo = nil,
			selectedTauntInfo = nil,
			itemType = Enum.VoteItemType.VOTE_ITEM_TYPE_ITEM,
			heroIndex = f75_arg0.bodyIndex,
			breadcrumbCount = 0,
		},
		properties = {
			heroIndex = f75_arg0.bodyIndex,
			selectIndex = f75_arg0.bodyIndex == f75_local4
		},
		slots = f75_arg0.slots,
	}
	if not f75_local6.models.disabled then
		f75_local6.models.loadoutDatasource = CoD.CharacterUtil.CreateCarouselItemLoadoutDatasource_InGame( f75_local6, CoD.CCUtility.customizationMode, f75_arg2 )
	end
	return f75_local6
end

CoD.CharacterUtil.HeroesListPrepare_InGame = function ( f77_arg0 )
	local f77_local1 = CoD.CharacterUtil.GetHeroesList_InGame( CoD.CCUtility.customizationMode )
	local f77_local2 = {}
	local f77_local5 = 0
	for f77_local11, f77_local12 in ipairs( f77_local1 ) do
		local f77_local10 = CoD.CharacterUtil.GetHeroModels_InGame( f77_local12, f77_local11, f77_arg0, nil )
		table.insert( f77_local2, f77_local10 )
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

DataSources.HeroesList_InGame = DataSourceHelpers.ListSetup( "HeroesList_InGame", CoD.CharacterUtil.HeroesListPrepare_InGame, true )
