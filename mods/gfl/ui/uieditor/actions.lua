require("ui.uieditor.actions_og")

function OpenWorkshop(InstanceRef, arg1, arg2)
    Engine.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3019676071")
end

function OpenIOPWiki(InstanceRef, arg1, arg2)
    Engine.OpenURL("https://iopwiki.com")
end

function OpenZMChangeLobby(InstanceRef, arg1, arg2)
    Engine.SendClientScriptNotify( InstanceRef, "lobby_room_changed", "" )
    PlaySoundSetSound( InstanceRef, "action" )
end

function NavigateToLobby(f355_arg0, f355_arg1, f355_arg2, f355_arg3)
    if f355_arg1 == "ZMLobbyOnlineCustomGame" or f355_arg1 == "ZMLobbyOnline" or f355_arg1 == "ZMLobbyLANGame" then
        CoD.TFPCUtil.CheckForRecentUpdate()
        CoD.TFPCUtil.LoadTFOptions()
    end

    CoD.LobbyBase.NavigateToLobby(f355_arg0, f355_arg1, f355_arg2, f355_arg3)
end

function OpenZMChooseCharacterLoadout( f1122_arg0, f1122_arg1, f1122_arg2, f1122_arg3, f1122_arg4 )
	CoD.CCUtility.customizationMode = Enum.eModes.MODE_ZOMBIES
	OpenZMChooseCharacterLoadout_Override( f1122_arg4, f1122_arg2, f1122_arg3 )
end

function OpenZMChooseCharacterLoadout_Override( f77_arg0, f77_arg1, f77_arg2 )
	CoD.LobbyBase.SetLeaderActivity( f77_arg1, CoD.LobbyBase.LeaderActivity.MODIFYING_HERO )
	local f77_local0 = OpenOverlay( f77_arg0, "ChooseZMCharacterLoadout", f77_arg1, f77_arg2 )
	LUI.OverrideFunction_CallOriginalFirst( f77_local0, "close", function ()
		CoD.LobbyBase.ResetLeaderActivity( f77_arg1 )
	end )
	return f77_local0
end

function OpenZMChooseCharacterLoadout_InGame( f427_arg0, f427_arg1, f427_arg2 )
	OpenOverlay( f427_arg0, "ChooseZMCharacterLoadout_InGame", f427_arg2 )
end

function OpenTFOptions( f206_arg0, f206_arg1, f206_arg2, f206_arg3, f206_arg4 )
	CoD.LobbyBase.OpenTFOptions( f206_arg0, f206_arg2 )
end

function OpenTFOptions_InGame( f427_arg0, f427_arg1, f427_arg2 )
	if not (Dvar.tfoption_tf_enabled:exists() and Dvar.tfoption_tf_enabled:get() == 0) then
		CoD.TFPCUtil.CheckForRecentUpdate()
		CoD.TFPCUtil.LoadTFOptions()
	end

	OpenOverlay(f427_arg0, "TFOptions", f427_arg2)
end

function OpenModInfo( f206_arg0, f206_arg1, f206_arg2, f206_arg3, f206_arg4 )
	CoD.LobbyBase.OpenModInfo( f206_arg0, f206_arg2 )
end

function OpenZMInfoPopup( InstanceRef, arg1, arg2 )
    LuaUtils.UI_ShowInfoMessageDialog( InstanceRef, "GFL_MODINFO_ZM_INFO_DESC", "GFL_MODINFO_ZM_INFO_TITLE" )
end

function OpenCPInfoPopup( InstanceRef, arg1, arg2 )
    LuaUtils.UI_ShowInfoMessageDialog( InstanceRef, "GFL_MODINFO_CP_INFO_DESC", "GFL_MODINFO_CP_INFO_TITLE" )
end

function OpenMPInfoPopup( InstanceRef, arg1, arg2 )
    LuaUtils.UI_ShowInfoMessageDialog( InstanceRef, "GFL_MODINFO_MP_INFO_DESC", "GFL_MODINFO_MP_INFO_TITLE" )
end

function splitString(inputstr, sep)
    if sep == nil or inputstr == nil then
        return nil
    end
    local t={}
    for str in string.gmatch(tostring(inputstr,""), "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function OpenConfigureCheatsPopup( f108_arg0, f108_arg1, f108_arg2, f108_arg3, f108_arg4 )
	CoD.OverlayUtility.AddSystemOverlay( "ConfigureCheatsPopup", {
		menuName = "SystemOverlay_Compact",
		title = "GFL_MENU_CONFIGURE_CHEATS",
		description = "TF_CHEATS_DESC",
		listDatasource = function ()
			DataSources.ConfigureCheatsPopup_List = DataSourceHelpers.ListSetup( "ConfigureCheatsPopup_List", function ( f110_arg0 )
				return {
					{
						models = {
							displayText = Engine.Localize( "MENU_DISABLE_CAPS" )
						},
						properties = {
							action = function ( f30_arg0, f30_arg1, f30_arg2, f30_arg3, f30_arg4 )
                                Engine.SetDvar( "tfoption_cheats", 0 )
								GoBack( f30_arg4, f30_arg2 )
							end
							
						}
					},
					{
						models = {
							displayText = Engine.Localize( "MENU_ENABLE_CAPS" )
						},
						properties = {
							action = function ( f31_arg0, f31_arg1, f31_arg2, f31_arg3, f31_arg4 )
                                Engine.SetDvar( "tfoption_cheats", 1 )
                                GoBack( f31_arg4, f31_arg2 )
							end
							
						}
					}
				}
			end, true, nil )
			return "ConfigureCheatsPopup_List"
		end,
		[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack,
		categoryType = CoD.OverlayUtility.OverlayTypes.GenericMessage
	} )
	CoD.OverlayUtility.CreateOverlay( f108_arg2, f108_arg0, "ConfigureCheatsPopup" )
end

function GetCharacterImageName(character)
	local prefix = "t7_gfl_chibi_"
	local suffix = ""
    if character ~= nil then
        suffix = string.lower(character)
    end

	local fullname = prefix .. suffix
	
    return fullname
end

function ClearNotificationQueue( container )
	container.notificationInProgress = false
	Engine.SetModelValue( container.notificationQueueEmptyModel, true )
end

function AddSimpleNotification( controller, container, image, title, description )
	local localizedTitle = ""
	local localizedDescription = ""
	if title then
		localizedTitle = Engine.Localize( Engine.ToUpper(title) )
	end

	if description then
		localizedDescription = Engine.Localize( Engine.ToUpper(description) )
	end
    
	container:appendNotification( {
		clip = "TextandImageBGB",
		title = localizedTitle,
        description = localizedDescription,
		bgbImage = RegisterImage( image )
	} )
end

function AddCharacterNotification( controller, container, character )
	local ref = "GFL_CHARACTER_"
    local title = Engine.Localize( Engine.ToUpper(ref .. character .. "_NAME") )
    -- local description = Engine.Localize( Engine.ToUpper(ref .. character .. "_DESC") )
    local description = ""
    
	container:appendNotification( {
		clip = "TextandImageBGB",
		title = title,
        description = description,
		bgbImage = RegisterImage( GetCharacterImageName( character ) )
	} )
end

function AddCheatsNotification( controller, container, model )
	container:appendNotification( {
		clip = "TextandImageBasic",
		title = Engine.Localize( "GFL_CHEATS_ENABLED" ),
		description = ""
	} )
end

function SendCharacterSystemResponse( controller, character )
	Engine.SendMenuResponse(controller, "popup_leavegame", "CharacterSystem" .. "," .. character )
end

function SendChatNotifyResponse( controller, sending_Text )
	Engine.SendMenuResponse(controller, "popup_leavegame", "ChatNotify" .. "…" .. string.gsub(tostring(sending_Text), " ", "¨"))
end

function GetCharacterFromHeroesList(index, heroes)
	if not heroes or not index then
		return nil
	end

	for _, hero in ipairs( heroes ) do
		if hero.character and hero.bodyIndex and index == hero.bodyIndex then
			return hero.character
		end
	end

	return nil
end

function GetHeroesList_InGame( customizationMode )
    local heroes = {}
    table.insert(heroes, {
		character = "m16a1_prime",
        displayName = "M16A1",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_m16a1",
		frozenMomentRender = "t7_menu_choosespecialist_default_m16a1",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_m16a1_prime",
    })

    table.insert(heroes, {
		character = "m16a1",
        displayName = "M16A1 (SF)",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_m16a1",
		frozenMomentRender = "t7_menu_choosespecialist_default_m16a1",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_m16a1",
    })

    table.insert(heroes, {
		character = "ak12",
        displayName = "AK-12",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_firebreak",
		frozenMomentRender = "t7_menu_choosespecialist_default_firebreak",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_ak12",
    })

    table.insert(heroes, {
		character = "an94",
        displayName = "AN-94",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_an94",
		frozenMomentRender = "t7_menu_choosespecialist_default_an94",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_an94",
    })

    table.insert(heroes, {
		character = "hk416",
        displayName = "HK416",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_grenadier",
		frozenMomentRender = "t7_menu_choosespecialist_default_battery",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_hk416",
    })

    table.insert(heroes, {
		character = "type89",
        displayName = "Howa Type 89",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_enforcer",
		frozenMomentRender = "t7_menu_choosespecialist_default_seraph",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_type89",
    })

    table.insert(heroes, {
		character = "tololo",
        displayName = "AK-Alfa",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_technomancer",
		frozenMomentRender = "t7_menu_choosespecialist_default_prophet",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_tololo",
    })

    table.insert(heroes, {
		character = "suomi",
        displayName = "Suomi",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_suomi",
		frozenMomentRender = "t7_menu_choosespecialist_default_suomi",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_suomi",
    })

    table.insert(heroes, {
		character = "rfb",
        displayName = "RFB",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_rfb",
		frozenMomentRender = "t7_menu_choosespecialist_default_rfb",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_rfb",
    })

    table.insert(heroes, {
		character = "vepley_backpack",
        displayName = "Vepley",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_vepley",
		frozenMomentRender = "t7_menu_choosespecialist_default_vepley",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_vepley",
    })

    table.insert(heroes, {
		character = "vepley",
        displayName = "Vepley w/o Backpack",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_vepley",
		frozenMomentRender = "t7_menu_choosespecialist_default_vepley",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_vepley",
    })

    table.insert(heroes, {
		character = "mp7_tights",
        displayName = "MP7",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_mp7",
		frozenMomentRender = "t7_menu_choosespecialist_default_mp7",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_mp7",
    })

    table.insert(heroes, {
		character = "mp7_casual_tights",
        displayName = "MP7 (Casual)",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_mp7",
		frozenMomentRender = "t7_menu_choosespecialist_default_mp7",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_mp7",
    })

    table.insert(heroes, {
		character = "m4_sopmod_ii",
        displayName = "M4 SOPMOD II",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_mercenary",
		frozenMomentRender = "t7_menu_choosespecialist_default_ruin",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_m4_sopmod_ii",
    })

    table.insert(heroes, {
		character = "ro635",
        displayName = "RO635",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_trapper",
		frozenMomentRender = "t7_menu_choosespecialist_default_nomad",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_ro635",
    })

    table.insert(heroes, {
		character = "st_ar15",
        displayName = "ST AR-15",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_st_ar15",
		frozenMomentRender = "t7_menu_choosespecialist_default_st_ar15",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_st_ar15",
    })

    table.insert(heroes, {
		character = "p90",
        displayName = "P90",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_blackmarket",
		frozenMomentRender = "t7_menu_choosespecialist_default_blackmarket",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_p90",
    })

    table.insert(heroes, {
		character = "centaureissi",
        displayName = "G36",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_centaureissi",
		frozenMomentRender = "t7_menu_choosespecialist_default_centaureissi",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_centaureissi",
    })

    table.insert(heroes, {
		character = "g36c",
        displayName = "G36C",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_g36c",
		frozenMomentRender = "t7_menu_choosespecialist_default_g36c",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_g36c",
    })

    table.insert(heroes, {
		character = "9a91",
        displayName = "9A-91",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_9a91",
		frozenMomentRender = "t7_menu_choosespecialist_default_9a91",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_9a91",
    })

    table.insert(heroes, {
		character = "ump45",
        displayName = "UMP45",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_spectre",
		frozenMomentRender = "t7_menu_choosespecialist_default_spectre",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_ump45",
    })

    table.insert(heroes, {
		character = "lenna",
        displayName = "UMP9",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_lenna",
		frozenMomentRender = "t7_menu_choosespecialist_default_lenna",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_lenna",
    })

    table.insert(heroes, {
		character = "super_sass",
        displayName = "Super SASS",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_outrider",
		frozenMomentRender = "t7_menu_choosespecialist_default_outrider",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_super_sass",
    })

    table.insert(heroes, {
		character = "macqiato",
        displayName = "WA2000",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_macqiato",
		frozenMomentRender = "t7_menu_choosespecialist_default_macqiato",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_macqiato",
    })

    table.insert(heroes, {
		character = "negev",
        displayName = "Negev",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_negev",
		frozenMomentRender = "t7_menu_choosespecialist_default_negev",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_negev",
    })

    table.insert(heroes, {
		character = "g11",
        displayName = "G11",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_g11",
		frozenMomentRender = "t7_menu_choosespecialist_default_g11",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_g11",
    })

    table.insert(heroes, {
		character = "dima",
        displayName = "Dima",
        backgroundWithCharacter = "t7_menu_mp_hero_background_with_dima",
		frozenMomentRender = "t7_menu_choosespecialist_default_dima",
		disabled = false,
		gameImageOff = "t7_gfl_chibi_dima",
    })

	for i, hero in ipairs( heroes ) do
		local index = i - 1
		hero.bodyIndex = index
	end

	return heroes
end