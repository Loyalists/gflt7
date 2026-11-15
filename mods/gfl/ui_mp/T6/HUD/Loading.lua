require( "ui_mp.T6.HUD.Loading_og" )

-- require("ui.util.T7Overcharged")

local options = {
    modname = "gfl",
    filespath = [[.\mods\gfl\]],
    workshopid = "3019676071",
    discordAppId = nil, -- "{{DISCORD_APP_ID}}" -- Not required, create your application at https://discord.com/developers/applications/
    showExternalConsole = false
}

-- InitializeT7Overcharged(options)

local CustomMapImageTable = {
	["cp_sh_cairo"] = "t7_menu_gfl_loadscreen_command_room",
	["cp_sh_mobile"] = "t7_menu_gfl_loadscreen_command_room",
	["cp_sh_singapore"] = "t7_menu_gfl_loadscreen_command_room",
	["cp_mi_eth_prologue"] = "t7_menu_gfl_loadscreen_indoorfight",
	["cp_mi_zurich_newworld"] = "t7_menu_gfl_loadscreen_city",
	["cp_mi_sing_blackstation"] = "t7_menu_gfl_loadscreen_berlinstreet_dream",
	["cp_mi_sing_biodomes"] = "t7_menu_gfl_loadscreen_city2",
	-- ["cp_mi_sing_biodomes2"] = "t7_menu_gfl_loadscreen_city2",
	["cp_mi_sing_sgen"] = "t7_menu_gfl_loadscreen_metro",
	["cp_mi_sing_vengeance"] = "t7_menu_gfl_loadscreen_city_burning",
	["cp_mi_cairo_ramses"] = "t7_menu_gfl_loadscreen_base",
	-- ["cp_mi_cairo_ramses2"] = "t7_menu_gfl_loadscreen_base",
	["cp_mi_cairo_infection"] = "t7_menu_gfl_loadscreen_m4a1",
	["cp_mi_cairo_infection2"] = "t7_menu_gfl_loadscreen_snowmountain",
	["cp_mi_cairo_infection3"] = "t7_menu_gfl_loadscreen_m4a1",
	["cp_mi_cairo_aquifer"] = "t7_menu_gfl_loadscreen_desert",
	["cp_mi_cairo_lotus"] = "t7_menu_gfl_loadscreen_tower",
	["cp_mi_cairo_lotus2"] = "t7_menu_gfl_loadscreen_tower",
	["cp_mi_cairo_lotus3"] = "t7_menu_gfl_loadscreen_tower",
	["cp_mi_zurich_coalescence"] = "t7_menu_gfl_loadscreen_2019summer_4_1",

	["zm_town_hd"] = "t7_menu_zm_loadscreen_town",
	["zm_town"] = "t7_menu_zm_loadscreen_town",
	["zm_farm_hd"] = "t7_menu_zm_loadscreen_town",
	["zm_depot"] = "t7_menu_zm_loadscreen_bus_depot",
	["zm_der_riese"] = "t7_menu_zm_loadscreen_giant",
	["zm_irondragon"] = "t7_menu_zm_loadscreen_castle",
	["zm_coast"] = "t7_menu_zm_loadscreen_cotd",
	["zm_pentagon"] = "t7_menu_zm_loadscreen_classified",
	["zm_classifive"] = "t7_menu_zm_loadscreen_classified",
	["zm_tranzit_busdepot"] = "t7_menu_zm_loadscreen_bus_depot",
	["zm_vk_tra_sur_busdepot"] = "t7_menu_zm_loadscreen_bus_depot",
	["zm_log_tuvong"] = "t7_menu_zm_loadscreen_tuvong",
	["zm_lit"] = "t7_menu_zm_loadscreen_classified",
	["zm_wing"] = "t7_menu_zm_loadscreen_wing",
	["zm_sanctuary"] = "t7_menu_zm_loadscreen_sanctuary",
	["zm_rig"] = "t7_menu_zm_loadscreen_neptune",
	["zm_prison"] = "t7_menu_zm_loadscreen_prison",
	["zm_nuked"] = "t7_menu_zm_loadscreen_nuketown",
	["zm_die"] = "t7_menu_zm_loadscreen_highrise",
}

local IntroMovieDisabledMaps = {
	["cp_sh_cairo"] = true,
	["cp_sh_mobile"] = true,
	["cp_sh_singapore"] = true,
	["cp_mi_eth_prologue"] = true,
	["cp_mi_zurich_newworld"] = true,
	["cp_mi_sing_blackstation"] = true,
	["cp_mi_sing_biodomes"] = true,
	-- ["cp_mi_sing_biodomes2"] = true,
	["cp_mi_sing_sgen"] = true,
	["cp_mi_sing_vengeance"] = true,
	["cp_mi_cairo_ramses"] = true,
	-- ["cp_mi_cairo_ramses2"] = true,
	["cp_mi_cairo_infection"] = true,
	["cp_mi_cairo_infection2"] = true,
	["cp_mi_cairo_infection3"] = true,
	["cp_mi_cairo_aquifer"] = true,
	["cp_mi_cairo_lotus"] = true,
	["cp_mi_cairo_lotus2"] = true,
	["cp_mi_cairo_lotus3"] = true,
	["cp_mi_zurich_coalescence"] = true,

	["zm_town_hd"] = true,
	["zm_town"] = true,
	["zm_farm_hd"] = true,
	["zm_depot"] = true,
	["zm_der_riese"] = true,
	["zm_irondragon"] = true,
	["zm_coast"] = true,
	["zm_pentagon"] = true,
	["zm_classifive"] = true,
	["zm_tranzit_busdepot"] = true,
	["zm_vk_tra_sur_busdepot"] = true,
	["zm_log_tuvong"] = true,
	["zm_lit"] = true,
	["zm_wing"] = true,
	["zm_sanctuary"] = true,
	["zm_rig"] = true,
	["zm_prison"] = true,
	["zm_nuked"] = true,
	["zm_die"] = true,
}

local function GetCustomMapImage( mapName )
    if CustomMapImageTable == nil or mapName == nil then
	    return nil
    end

    local mapImage = CustomMapImageTable[mapName]
    if mapImage == nil then
        return nil
    end

	return mapImage
end

local function IsIntroMovieDisabled()
	if CoD.isZombie then
		if Engine.GetLobbyClientCount( Enum.LobbyType.LOBBY_TYPE_GAME ) > 1 then
			return true
		end

		if Engine.GetLobbyClientCount( Enum.LobbyType.LOBBY_TYPE_GAME ) <= 1 and Dvar.personalization_disable_intro_movie:exists() and Dvar.personalization_disable_intro_movie:get() ~= "0" then
			return true
		end
	end

	local mapName = Engine.GetCurrentMap()
    if IntroMovieDisabledMaps ~= nil and mapName ~= nil then
		local check = IntroMovieDisabledMaps[mapName]
		if check ~= nil and check == true then
			return true
		end
    end

	return false
end

local updateCinematicImage = function ( image, event )
	if Engine.IsCinematicMp4() then
		if not image.ismp4 then
			image:setImage( RegisterMaterial( "cinematic_mp4" ) )
			image.ismp4 = true
		end
	elseif image.ismp4 then
		image:setImage( RegisterMaterial( "black" ) )
		image.ismp4 = nil
	end
end

local showContinueButton = function ( loadingMenu, event )
	loadingMenu.continueButton:registerEventHandler( "hide_continue_button", CoD.Loading.HideContinueButton )
	loadingMenu.continueButton:addElement( LUI.UITimer.new( 5000, "hide_continue_button", true, loadingMenu.continueButton ) )
	loadingMenu.continueButton:beginAnimation( "show", 1000 )
	loadingMenu.continueButton:setAlpha( 1 )
	return LUI.UIButton.gainFocus( loadingMenu.continueButton, event )
end

local skipLoadingCinematic = function ( loadingMenu, event )
	Engine.Stop3DCinematic( 0 )
	if Engine.IsLobbyHost( Enum.LobbyType.LOBBY_TYPE_GAME ) then
		Engine.SetLoadingMovieSkippedState( true )
	end
end

local function AddContinueButton( loadingMenu, controller )
	local horizontalPadding = 15
	local verticalPadding = 15
	local safeAreaWidth, safeAreaHeight = Engine.GetUserSafeArea()
	loadingMenu.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "Loading.buttonPrompts" )
	LUI.OverrideFunction_CallOriginalSecond( loadingMenu, "close", function ( element )
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "LoadingScreenOverlayForTeamGames.buttonPrompts" ) )
	end )
	loadingMenu.continueButton = LUI.UIButton.new()
	loadingMenu.continueButton:setLeftRight( false, false, -safeAreaWidth, safeAreaWidth / 2 - horizontalPadding )
	loadingMenu.continueButton:setTopBottom( false, false, safeAreaHeight / 2 - CoD.textSize.Condensed - verticalPadding, safeAreaHeight / 2 - verticalPadding )
	loadingMenu.continueButton:setAlignment( LUI.Alignment.Right )
	loadingMenu.continueButton:setAlpha( 0 )
	loadingMenu.continueButton:setActionSFX( "uin_mov_skip" )
	loadingMenu:addElement( loadingMenu.continueButton )
	loadingMenu.continueButton:setActionEventNameNewStyle( loadingMenu, controller, "loading_startplay" )
	loadingMenu.continueButton:addElement( CoD.ButtonPrompt.new( "start", "", loadingMenu, "loading_startplay", true ) )
	loadingMenu.continueButton.label = LUI.UIText.new()
	loadingMenu.continueButton.label:setLeftRight( true, true, 0, 0 )
	loadingMenu.continueButton.label:setTopBottom( true, true, 0, 0 )
	loadingMenu.continueButton.label:setFont( CoD.fonts.Condensed )
	loadingMenu.continueButton.label:setAlignment( LUI.Alignment.Right )
	loadingMenu.continueButton:addElement( loadingMenu.continueButton.label )
	loadingMenu.continueButton.label:setText( Engine.Localize( "PLATFORM_SKIP" ) )
	loadingMenu.continueButton:setHandleMouse( false )
	if CoD.isPC then
		loadingMenu:setForceMouseEventDispatch( true )
		loadingMenu.continueButtonContainer = LUI.UIElement.new()
		loadingMenu.continueButtonContainer:setLeftRight( true, true, 0, 0 )
		loadingMenu.continueButtonContainer:setTopBottom( true, true, 0, 0 )
		loadingMenu.continueButtonContainer:setAlpha( 1 )
		loadingMenu.continueButtonContainer.id = "continueButtonContainer"
		loadingMenu.continueButtonContainer:setHandleMouse( true )
		loadingMenu:addElement( loadingMenu.continueButtonContainer )
		loadingMenu.continueButtonContainer:registerEventHandler( "button_action", function ( element, event )
			SendButtonPressToMenuEx( loadingMenu, event.controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		end )
	end
end

LUI.createMenu.Loading = function ( controller )
	-- Loading music/cinematics replace the lobby's random selection.
	CoD.GFLRandomMusicState = nil
	local loadingMenu = CoD.Menu.NewFromState( "Loading", {
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = true,
		top = 0,
		bottom = 0
	} )
	loadingMenu.id = "loadingMenu"
	loadingMenu:setOwner( controller )
	loadingMenu:registerEventHandler( "start_loading", CoD.Loading.StartLoading )
	loadingMenu:registerEventHandler( "start_spinner", CoD.Loading.StartSpinner )
	loadingMenu:registerEventHandler( "fade_in_map_location", CoD.Loading.FadeInMapLocation )
	loadingMenu:registerEventHandler( "fade_in_gametype", CoD.Loading.FadeInGametype )
	loadingMenu:registerEventHandler( "fade_in_map_image", CoD.Loading.FadeInMapImage )
	if Dvar.fs_game:get() == Dvar.fs_game_saved:get() and Dvar.fs_game_saved:exists() and Dvar.sv_hostname:exists() and Dvar.sv_hostname:get() ~= "BlackOpsPublic" and Dvar.sv_hostname:get() ~= "Dedicated - dedicatedpc" and Dvar.sv_hostname:get() ~= "" then
	    Engine.SetDvar( "fs_game", "usermaps" )
    end

	local f5_local1 = false
	local mapName = Engine.GetCurrentMap()
	local gameType = Engine.GetCurrentGameType()
	local imageName = CoD.GetMapValue( mapName, "loadingImage", "black" )
	if Engine.IsMultiplayerGame() then
		Engine.PlayMenuMusic( "load_" .. mapName )
	end

	if CoD.isZombie then
		if mapName ~= nil and mapName == "zm_island" and IsJapaneseSku() and CoD.LANGUAGE_JAPANESE == Dvar.loc_language:get() then
			f5_local1 = false
		elseif mapName ~= nil and (mapName == "zm_asylum" or mapName == "zm_cosmodrome" or mapName == "zm_moon" or mapName == "zm_sumpf" or mapName == "zm_temple") then
			f5_local1 = false
		elseif Engine.IsDemoPlaying() or Engine.IsSplitscreen() then
			f5_local1 = false
		elseif not IsIntroMovieDisabled() then
			f5_local1 = true
			local f5_local5 = CoD.GetMapValue( mapName, "introMovie" )
			if f5_local5 == nil and Mods_IsUsingUsermap() then
				f5_local5 = mapName .. "_load"
			end
			if f5_local5 ~= nil and not Engine.IsCinematicPlaying() then
				Engine.StartLoadingCinematic( f5_local5 )
			end
			f5_local1 = true
		else
			f5_local1 = false
		end
		if not f5_local1 then
			if Mods_IsUsingUsermap() then
				local randomMusic = CoD.GetRandomMusicTracks( "load_usermaps" )
				if randomMusic ~= nil then
					Engine.PlayMenuMusic(randomMusic)
				else
					Engine.PlayMenuMusic( "load_usermaps" )
				end
			else
				Engine.PlayMenuMusic( "load_" .. mapName )
			end
		end
	else
		if true == Dvar.ui_useloadingmovie:get() or CoD.isCampaign then
			if true == Engine.IsCampaignModeZombies() then
				mapName = mapName .. "_nightmares"
			end
			local f5_local6 = CoD.GetMapValue( mapName, "introMovie" )
			if mapName ~= nil and mapName == "cp_sh_singapore" and Dvar.cp_queued_level:get() == "cp_mi_sing_blackstation" then
				f5_local6 = "CP_safehouse_load_loadingmovie"
			end
			if not IsIntroMovieDisabled() then
				if f5_local6 ~= nil and not Engine.IsCinematicPlaying() then
					Engine.StartLoadingCinematic( f5_local6 )
				end
			end
			Engine.SetDvar( "ui_useloadingmovie", 0 )
		end
		f5_local1 = false
		if not IsIntroMovieDisabled() then
			if Dvar.art_review:get() ~= "1" and (CoD.isCampaign or CoD.isZombie) and Engine.IsCinematicStarted() then
				f5_local1 = true
			end
		end
	end
	if f5_local1 then
		Engine.SetDvar( "ui_useloadingmovie", 1 )
		if CoD.GetMapValue( mapName, "fadeToWhite" ) == 1 then
			local f5_local7 = "$white"
		end
		imageName = f5_local7 or "black"
	else
		Engine.SetDvar( "ui_useloadingmovie", 0 )
		if imageName == nil or imageName == "" or CoD.isMultiplayer then
			imageName = "black"
		end
	end
	if Engine.IsLevelPreloaded( mapName ) then
		loadingMenu.addLoadingElement = function ( element, f6_arg1 )
			if CoD.isCampaign then
				element:addElement( f6_arg1 )
			end
		end
		
	else
		loadingMenu.addLoadingElement = function ( element, f7_arg1 )
			element:addElement( f7_arg1 )
		end
		
	end

	local customMapImage = GetCustomMapImage( Engine.GetCurrentMap() )
	if CoD.isCampaign or not f5_local1 then
		if customMapImage ~= nil then
			imageName = customMapImage
		end
	end

	loadingMenu.mapImage = LUI.UIStreamedImage.new()
	loadingMenu.mapImage.id = "mapImage"
	loadingMenu.mapImage:setLeftRight( false, false, -640, 640 )
	loadingMenu.mapImage:setTopBottom( false, false, -360, 360 )
	loadingMenu.mapImage:setAlpha( 0 )
	loadingMenu.mapImage:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_normal" ) )
	loadingMenu.mapImage:setImage( RegisterImage( imageName ) )
	loadingMenu:addElement( loadingMenu.mapImage )
	if f5_local1 == true then
		loadingMenu.mapImage:setShaderVector( 0, 0, 0, 0, 0 )
		loadingMenu.mapImage.ismp4 = false
	end
	local f5_local6 = 10
	local f5_local5 = 70
	local f5_local8 = "Big"
	local f5_local9 = CoD.fonts[f5_local8]
	local f5_local10 = CoD.textSize[f5_local8]
	local f5_local11 = "Condensed"
	local f5_local12 = CoD.fonts[f5_local11]
	local f5_local13 = CoD.textSize[f5_local11]
	loadingMenu.mapNameLabel = LUI.UIText.new()
	loadingMenu.mapNameLabel.id = "mapNameLabel"
	loadingMenu.mapNameLabel:setLeftRight( true, false, f5_local5, f5_local5 + 1 )
	loadingMenu.mapNameLabel:setTopBottom( true, false, f5_local6, f5_local6 + f5_local10 )
	loadingMenu.mapNameLabel:setFont( f5_local9 )
	loadingMenu.mapNameLabel:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
	loadingMenu.mapNameLabel:setAlpha( 0 )
	loadingMenu.mapNameLabel:registerEventHandler( "transition_complete_map_name_fade_in", CoD.Loading.MapNameFadeInComplete )
	loadingMenu:addLoadingElement( loadingMenu.mapNameLabel )
	f5_local6 = f5_local6 + f5_local10 - 5
	loadingMenu.mapLocationLabel = LUI.UIText.new()
	loadingMenu.mapLocationLabel.id = "mapLocationLabel"
	loadingMenu.mapLocationLabel:setLeftRight( true, false, f5_local5, f5_local5 + 1 )
	loadingMenu.mapLocationLabel:setTopBottom( true, false, f5_local6, f5_local6 + f5_local13 )
	loadingMenu.mapLocationLabel:setFont( f5_local12 )
	loadingMenu.mapLocationLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
	loadingMenu.mapLocationLabel:setAlpha( 0 )
	loadingMenu.mapLocationLabel:registerEventHandler( "transition_complete_map_location_fade_in", CoD.Loading.MapLocationFadeInComplete )
	loadingMenu:addLoadingElement( loadingMenu.mapLocationLabel )
	f5_local6 = f5_local6 + f5_local13 - 2
	loadingMenu.gametypeLabel = LUI.UIText.new()
	loadingMenu.gametypeLabel.id = "gametypeLabel"
	loadingMenu.gametypeLabel:setLeftRight( true, false, f5_local5, f5_local5 + 1 )
	loadingMenu.gametypeLabel:setTopBottom( true, false, f5_local6, f5_local6 + f5_local13 )
	loadingMenu.gametypeLabel:setFont( f5_local12 )
	loadingMenu.gametypeLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
	loadingMenu.gametypeLabel:setAlpha( 0 )
	loadingMenu.gametypeLabel:registerEventHandler( "transition_complete_gametype_fade_in", CoD.Loading.GametypeFadeInComplete )
	loadingMenu:addLoadingElement( loadingMenu.gametypeLabel )
	f5_local6 = f5_local6 + f5_local13 + 5
	local DemoTitle = Engine.Localize( "MPUI_TITLE_CAPS" ) .. ":"
	local f6_local14_1, f6_local14_2, f6_local14_3, f6_local14_4 = GetTextDimensions(DemoTitle, f5_local12, f5_local13)
	local DemoDuration = Engine.Localize( "MPUI_DURATION_CAPS" ) .. ":"
	local f6_local16_1, f6_local16_2, f6_local16_3, f6_local16_4 = GetTextDimensions(DemoDuration, f5_local12, f5_local13)
	local DemoAuthor = Engine.Localize( "MPUI_AUTHOR_CAPS" ) .. ":"
	local f6_local18_1, f6_local18_2, f6_local18_3, f6_local18_4 = GetTextDimensions(DemoAuthor, f5_local12, f5_local13)
	local f5_local20 = math.max(f6_local14_3, f6_local16_3, f6_local18_3) + 10
	local f5_local21 = 0

	if not Engine.IsLevelPreloaded( mapName ) then
		loadingMenu.demoInfoContainer = LUI.UIElement.new()
		loadingMenu.demoInfoContainer:setLeftRight( true, false, f5_local5, 600 )
		loadingMenu.demoInfoContainer:setTopBottom( true, false, f5_local6, f5_local6 + 600 )
		loadingMenu.demoInfoContainer:setAlpha( 0 )
		loadingMenu:addLoadingElement( loadingMenu.demoInfoContainer )
		loadingMenu.demoTitleTitle = LUI.UIText.new()
		loadingMenu.demoTitleTitle:setLeftRight( true, true, 0, 0 )
		loadingMenu.demoTitleTitle:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		loadingMenu.demoTitleTitle:setFont( f5_local12 )
		loadingMenu.demoTitleTitle:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
		loadingMenu.demoTitleTitle:setAlignment( LUI.Alignment.Left )
		loadingMenu.demoTitleTitle:setText( DemoTitle )
		SetupAutoHorizontalAlignArabicText( loadingMenu.demoTitleTitle )
		loadingMenu.demoInfoContainer:addElement( loadingMenu.demoTitleTitle )
		loadingMenu.demoTitleLabel = LUI.UIText.new()
		loadingMenu.demoTitleLabel:setLeftRight( true, true, f5_local20, 0 )
		loadingMenu.demoTitleLabel:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		loadingMenu.demoTitleLabel:setFont( f5_local12 )
		loadingMenu.demoTitleLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
		loadingMenu.demoTitleLabel:setAlignment( LUI.Alignment.Left )
		SetupAutoHorizontalAlignArabicText( loadingMenu.demoTitleLabel )
		loadingMenu.demoInfoContainer:addElement( loadingMenu.demoTitleLabel )
		f5_local21 = f5_local21 + f5_local13 - 2
		loadingMenu.demoDurationTitle = LUI.UIText.new()
		loadingMenu.demoDurationTitle:setLeftRight( true, true, 0, 0 )
		loadingMenu.demoDurationTitle:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		loadingMenu.demoDurationTitle:setFont( f5_local12 )
		loadingMenu.demoDurationTitle:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
		loadingMenu.demoDurationTitle:setAlignment( LUI.Alignment.Left )
		loadingMenu.demoDurationTitle:setText( DemoDuration )
		SetupAutoHorizontalAlignArabicText( loadingMenu.demoDurationTitle )
		loadingMenu.demoInfoContainer:addElement( loadingMenu.demoDurationTitle )
		loadingMenu.demoDurationLabel = LUI.UIText.new()
		loadingMenu.demoDurationLabel:setLeftRight( true, true, f5_local20, 0 )
		loadingMenu.demoDurationLabel:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		loadingMenu.demoDurationLabel:setFont( f5_local12 )
		loadingMenu.demoDurationLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
		loadingMenu.demoDurationLabel:setAlignment( LUI.Alignment.Left )
		SetupAutoHorizontalAlignArabicText( loadingMenu.demoDurationLabel )
		loadingMenu.demoInfoContainer:addElement( loadingMenu.demoDurationLabel )
		f5_local21 = f5_local21 + f5_local13 - 2
		loadingMenu.demoAuthorTitle = LUI.UIText.new()
		loadingMenu.demoAuthorTitle:setLeftRight( true, true, 0, 0 )
		loadingMenu.demoAuthorTitle:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		loadingMenu.demoAuthorTitle:setFont( f5_local12 )
		loadingMenu.demoAuthorTitle:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
		loadingMenu.demoAuthorTitle:setAlignment( LUI.Alignment.Left )
		loadingMenu.demoAuthorTitle:setText( DemoAuthor )
		SetupAutoHorizontalAlignArabicText( loadingMenu.demoAuthorTitle )
		loadingMenu.demoInfoContainer:addElement( loadingMenu.demoAuthorTitle )
		loadingMenu.demoAuthorLabel = LUI.UIText.new()
		loadingMenu.demoAuthorLabel:setLeftRight( true, true, f5_local20, 0 )
		loadingMenu.demoAuthorLabel:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		loadingMenu.demoAuthorLabel:setFont( f5_local12 )
		loadingMenu.demoAuthorLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
		loadingMenu.demoAuthorLabel:setAlignment( LUI.Alignment.Left )
		SetupAutoHorizontalAlignArabicText( loadingMenu.demoAuthorLabel )
		loadingMenu.demoInfoContainer:addElement( loadingMenu.demoAuthorLabel )
	end
	
	local f5_local22 = 3
	local f5_local23 = CoD.Loading.DYKFontHeight + f5_local22 * 2
	local f5_local24 = 2
	local f5_local25 = f5_local23 + 1 + f5_local24 + CoD.Loading.DYKFontHeight - f5_local6
	local f5_local26 = CoD.Menu.Width - 5 * 2
	local f5_local27 = -200
	local f5_local28 = 0
	local f5_local29 = 2
	local f5_local30 = f5_local23 - f5_local29 * 2
	local f5_local31 = 6
	loadingMenu.loadingBarContainer = LUI.UIElement.new()
	loadingMenu.loadingBarContainer.id = "loadingBarContainer"
	loadingMenu.loadingBarContainer:setLeftRight( false, false, -f5_local26 / 2, f5_local26 / 2 )
	loadingMenu.loadingBarContainer:setTopBottom( false, true, f5_local27 - f5_local25, f5_local27 )
	loadingMenu.loadingBarContainer:setAlpha( 0 )
	loadingMenu:addElement( loadingMenu.loadingBarContainer )
	--f5_local0.dykContainer = LUI.UIElement.new()
	--f5_local0.dykContainer.id = "dykContainer"
	--f5_local0.dykContainer:setLeftRight( true, true, f5_local22 + f5_local31, 0 )
	--f5_local0.dykContainer:setTopBottom( true, false, f5_local28, f5_local28 + CoD.Loading.DYKFontHeight )
	--f5_local0.dykContainer.containerHeight = f5_local23
	--f5_local0.dykContainer.textAreaWidth = f5_local26 - f5_local22 - f5_local31 - f5_local29 - f5_local30 - 1

	--CoD.Loading.SetupDYKContainerImages( f5_local0.dykContainer )


	f5_local28 = f5_local28 + f5_local23 + 1
	loadingMenu.spinner = LUI.UIImage.new()
	loadingMenu.spinner.id = "spinner"
	f5_local29 = 110
	f5_local30 = f5_local30 * 5
	loadingMenu.spinner:setLeftRight( false, true, -(f5_local29 + f5_local30 / 2), -(f5_local29 - f5_local30 / 2) )
	loadingMenu.spinner:setTopBottom( false, true, -(f5_local29 + f5_local30 / 2), -(f5_local29 - f5_local30 / 2) )
	loadingMenu.spinner:setImage( RegisterMaterial( "lui_loader" ) )
	loadingMenu.spinner:setShaderVector( 0, 0, 0, 0, 0 )
	loadingMenu.spinner:setAlpha( 0 )
	loadingMenu.spinner:setPriority( 200 )
	loadingMenu:addElement( loadingMenu.spinner )
	local self = LUI.UIImage.new()
	self.id = "loadingBarBackground"
	self:setLeftRight( true, true, 1, -1 )
	self:setTopBottom( true, false, f5_local28, f5_local28 + f5_local24 )
	self:setRGB( 0.1, 0.1, 0.1 )
	loadingMenu.loadingBarContainer:addElement( self )
	--local self = LUI.UIImage.new()
	--self:setLeftRight( true, true, 1, -1 )
	--self:setTopBottom( true, false, f5_local28, f5_local28 + f5_local24 )
	--self:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
	--self:setAlpha(0)
	--f5_local0.loadingBarContainer:addElement( self )
	local f5_local34 = 1
	local self = LUI.UIImage.new()
	self:setLeftRight( true, true, 2, -2 )
	self:setTopBottom( true, false, f5_local28, f5_local28 + f5_local34 )
	self:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )-----loadbar
	self:setAlpha( 1 )
	loadingMenu.loadingBarContainer:addElement( self )
	self:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self:setShaderVector( 1, 0, 0, 0, 0 )
	self:setShaderVector( 2, 1, 0, 0, 0 )
	self:setShaderVector( 3, 0, 0, 0, 0 )
	self:setShaderVector( 1, 0, 0, 0, 0 )
	self:setShaderVector( 2, 1, 0, 0, 0 )
	self:setShaderVector( 3, 0, 0, 0, 0 )
	self:subscribeToGlobalModel( controller, "LoadingScreenTeamInfo", "loadedFraction", function ( modelRef )
		local loadedFraction = Engine.GetModelValue( modelRef )
		if loadedFraction then
			self:setShaderVector( 0, loadedFraction, 0, 0, 0 )
			self:setShaderVector( 0, loadedFraction, 0, 0, 0 )
		end
	end )
	LUI.OverrideFunction_CallOriginalSecond( loadingMenu, "close", function ( element )
		self:close()
	end )
	f5_local28 = f5_local28 + f5_local24
	loadingMenu.statusLabel = LUI.UIText.new()
	loadingMenu.statusLabel:setLeftRight( true, true, 9, 0 )
	loadingMenu.statusLabel:setTopBottom( true, false, 5, 29 )
	loadingMenu.statusLabel:setAlpha( 1 )
	loadingMenu.statusLabel:setFont(CoD.Loading.DYKFont)
	loadingMenu.statusLabel:setAlignment( LUI.Alignment.Left )
	loadingMenu.statusLabel:setupLoadingStatusText()
	loadingMenu.loadingBarContainer:addElement( loadingMenu.statusLabel )

	-- local mapDescription = CoD.GetMapValue( Engine.GetCurrentMap(), "mapDescription", "" )
	-- if Mods_IsUsingUsermap() then
	-- 	local ModsLists = Engine.Mods_Lists_GetInfoEntries( "usermaps", 0, Engine.Mods_Lists_GetInfoEntriesCount( "usermaps" ) )
	-- 	if ModsLists then
	-- 		for int = 0 , #ModsLists, 1 do
	-- 			local map = ModsLists[int] 
	-- 			if map.ugcName == Dvar.ui_mapname:get() and LUI.startswith( map.internalName, "zm_" ) then
	-- 				mapDescription = map.description
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- f5_local0.didYouKnow = LUI.UIText.new()
	-- f5_local0.didYouKnow:setLeftRight( true, true, f5_local22 + f5_local31, 0 )
	-- f5_local0.didYouKnow:setTopBottom( true, false, f5_local28, f5_local28 + CoD.Loading.DYKFontHeight )
	-- --f5_local0.didYouKnow:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
	-- f5_local0.didYouKnow:setFont( CoD.Loading.DYKFont )
	-- f5_local0.didYouKnow:setAlignment( LUI.Alignment.Left )
	-- f5_local0.didYouKnow:setText( Engine.Localize( mapDescription ) )
	-- --f5_local0.didYouKnow:setPriority( 0 )
	-- f5_local0.didYouKnow:setAlpha( 1 )
	-- f5_local0.loadingBarContainer:addElement( f5_local0.didYouKnow )

	if f5_local1 == true then
		loadingMenu.mapImage:setAlpha( 1 )
		CoD.Loading.AddNewLoadingScreen( loadingMenu )
		loadingMenu.cinematicSubtitles = CoD.MovieSubtitles.new( loadingMenu, controller )
		loadingMenu.cinematicSubtitles:setLeftRight( false, false, -640, 640 )
		loadingMenu.cinematicSubtitles:setTopBottom( false, false, -360, 360 )
		loadingMenu:addElement( loadingMenu.cinematicSubtitles )
		loadingMenu.mapImage:registerEventHandler( "loading_updateimage", updateCinematicImage )
		loadingMenu.mapImage.id = "loadingMenu.mapImage"
		loadingMenu:addElement( LUI.UITimer.new( 16, "loading_updateimage", false, loadingMenu.mapImage ) )
		Engine.SetDvar( "ui_useloadingmovie", 1 )
		AddContinueButton( loadingMenu, controller )
		loadingMenu:registerEventHandler( "loading_displaycontinue", showContinueButton )
		loadingMenu:registerEventHandler( "loading_startplay", skipLoadingCinematic )
		if Engine.GetCurrentMap() == "zm_theater" then
			CoD.Loading.StartLoading( loadingMenu )
			CoD.Loading.StartSpinner( loadingMenu )
			loadingMenu:registerEventHandler( "fade_in_map_image", nil )
		end
	else
		if CoD.isCampaign then
			CoD.Loading.StartLoading( loadingMenu )
			CoD.Loading.FadeInMapImage( loadingMenu )
			Engine.SetDvar( "ui_useloadingmovie", 1 )
			AddContinueButton( loadingMenu, controller )
			loadingMenu:registerEventHandler( "loading_displaycontinue", showContinueButton )
			loadingMenu:registerEventHandler( "loading_startplay", skipLoadingCinematic )
		else
			CoD.Loading.StartLoading( loadingMenu )
			loadingMenu:addElement( LUI.UITimer.new( CoD.Loading.SpinnerDelayTime, "start_spinner", true, loadingMenu ) )
		end
	end
	return loadingMenu
end

CoD.Loading.FadeInMapImage = function ( f22_arg0 )
	f22_arg0.mapImage:beginAnimation( "map_image_fade_in", CoD.Loading.FadeInTime )
	f22_arg0.mapImage:setAlpha( 1 )
	--f22_arg0.mapImage:setRGB( 1, 1, 1 )
	f22_arg0.loadingBarContainer:beginAnimation( "loading_bar_fade_in", 100 )
	f22_arg0.loadingBarContainer:setAlpha( 1 )
	CoD.Loading.StartSpinner( f22_arg0 )
	if Engine.IsDemoPlaying() then
		f22_arg0.demoInfoContainer:beginAnimation( "demo_info_fade_in", 1 )
		f22_arg0.demoInfoContainer:setAlpha( 1 )
	end
end

CoD.Loading.StartLoading = function ( loadingMenu )
	Engine.PrintInfo( Enum.consoleLabel.LABEL_DEFAULT, "Opening loading screen...\n" )
	if loadingMenu.loadingScreenOverlay == nil then
		CoD.Loading.AddNewLoadingScreen( loadingMenu )
	end
	if Engine.IsMultiplayerGame() then
		return 
	end
	local controller = Engine.GetPrimaryController()
	local localizedMapName = MapNameToLocalizedMapName( Engine.GetCurrentMap() )
	local localizedMapLocation = MapNameToLocalizedMapLocation( Engine.GetCurrentMap() )
	local gameTypeName = Engine.GetCurrentGametypeName( controller )
	loadingMenu.mapNameLabel:setText( localizedMapName )
	loadingMenu.mapLocationLabel:setText( localizedMapLocation )
	loadingMenu.gametypeLabel:setText( gameTypeName )
	if Engine.IsDemoPlaying() then
		local demoTitle = Dvar.ls_demotitle:get()
		local demoDuration = Dvar.ls_demoduration:get()
		local demoDurationText = ""
		if demoDuration > 0 then
			demoDurationText = Engine.SecondsAsTime( Dvar.ls_demoduration:get() )
		end
		local demoAuthor = Dvar.ls_demoauthor:get()
		loadingMenu.demoTitleLabel:setText( demoTitle )
		loadingMenu.demoDurationLabel:setText( demoDurationText )
		loadingMenu.demoAuthorLabel:setText( demoAuthor )
		if demoAuthor == "" then
			loadingMenu.demoAuthorTitle:setAlpha( 0 )
		end
		if demoDurationText == "" then
			loadingMenu.demoDurationTitle:setAlpha( 0 )
		end
	end
	--if CoD.isZombie == true then
		--local f13_local4 = CoD.Loading.GetDidYouKnowString()
		--local f13_local5 = {}
		--f13_local5 = GetTextDimensions( f13_local4, CoD.Loading.DYKFont, CoD.Loading.DYKFontHeight )
		--if f13_arg0.dykContainer.textAreaWidth < f13_local5[3] then
			--f13_arg0.dykContainer:setTopBottom( true, false, -CoD.Loading.DYKFontHeight, f13_arg0.dykContainer.containerHeight )
		--end
		--f13_arg0.didYouKnow:setText( f13_local4 )
	--end
	loadingMenu.mapNameLabel:beginAnimation( "map_name_fade_in", CoD.Loading.FadeInTime )
	loadingMenu.mapNameLabel:setAlpha( 1 )
end
