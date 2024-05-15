require( "ui_mp.T6.HUD.Loading_og" )

require("ui.util.T7Overcharged")

local options = {
    modname = "gfl",
    filespath = [[.\mods\gfl\]],
    workshopid = "3019676071",
    discordAppId = nil, -- "{{DISCORD_APP_ID}}" -- Not required, create your application at https://discord.com/developers/applications/
    showExternalConsole = true
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

	["zm_town_hd"] = "t7_menu_zm_loadscreen_bus_depot",
	["zm_town"] = "t7_menu_zm_loadscreen_bus_depot",
	["zm_farm_hd"] = "t7_menu_zm_loadscreen_bus_depot",
	["zm_depot"] = "t7_menu_zm_loadscreen_bus_depot",
	["zm_der_riese"] = "t7_menu_zm_loadscreen_giant",
	["zm_irondragon"] = "t7_menu_zm_loadscreen_castle",
	["zm_coast"] = "t7_menu_zm_loadscreen_cotd",
	["zm_pentagon"] = "t7_menu_zm_loadscreen_classified",
	["zm_classifive"] = "t7_menu_zm_loadscreen_classified",
	["zm_tranzit_busdepot"] = "t7_menu_zm_loadscreen_bus_depot",
	["zm_log_tuvong"] = "t7_menu_zm_loadscreen_tuvong",
	["zm_lit"] = "t7_menu_zm_loadscreen_classified",
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
	["zm_log_tuvong"] = true,
	["zm_lit"] = true,
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

		if Engine.GetLobbyClientCount( Enum.LobbyType.LOBBY_TYPE_GAME ) <= 1 and Dvar.tfoption_disable_intro_movie:exists() and Dvar.tfoption_disable_intro_movie:get() ~= "0" then
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

local f0_local0 = function ( f1_arg0, f1_arg1 )
	if Engine.IsCinematicMp4() then
		if not f1_arg0.ismp4 then
			f1_arg0:setImage( RegisterMaterial( "cinematic_mp4" ) )
			f1_arg0.ismp4 = true
		end
	elseif f1_arg0.ismp4 then
		f1_arg0:setImage( RegisterMaterial( "black" ) )
		f1_arg0.ismp4 = nil
	end
end

local f0_local1 = function ( f3_arg0, f3_arg1 )
	f3_arg0.continueButton:registerEventHandler( "hide_continue_button", CoD.Loading.HideContinueButton )
	f3_arg0.continueButton:addElement( LUI.UITimer.new( 5000, "hide_continue_button", true, f3_arg0.continueButton ) )
	f3_arg0.continueButton:beginAnimation( "show", 1000 )
	f3_arg0.continueButton:setAlpha( 1 )
	return LUI.UIButton.gainFocus( f3_arg0.continueButton, f3_arg1 )
end

local f0_local2 = function ( f4_arg0, f4_arg1 )
	Engine.Stop3DCinematic( 0 )
	if Engine.IsLobbyHost( Enum.LobbyType.LOBBY_TYPE_GAME ) then
		Engine.SetLoadingMovieSkippedState( true )
	end
end

local function AddContinueButton( f5_local0, f5_arg0 )
	local f5_local36 = 15
	local f5_local37 = 15
	local f5_local38, f5_local39 = Engine.GetUserSafeArea()
	f5_local0.buttonModel = Engine.CreateModel( Engine.GetModelForController( f5_arg0 ), "Loading.buttonPrompts" )
	LUI.OverrideFunction_CallOriginalSecond( f5_local0, "close", function ( element )
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( f5_arg0 ), "LoadingScreenOverlayForTeamGames.buttonPrompts" ) )
	end )
	f5_local0.continueButton = LUI.UIButton.new()
	f5_local0.continueButton:setLeftRight( false, false, -f5_local38, f5_local38 / 2 - f5_local36 )
	f5_local0.continueButton:setTopBottom( false, false, f5_local39 / 2 - CoD.textSize.Condensed - f5_local37, f5_local39 / 2 - f5_local37 )
	f5_local0.continueButton:setAlignment( LUI.Alignment.Right )
	f5_local0.continueButton:setAlpha( 0 )
	f5_local0.continueButton:setActionSFX( "uin_mov_skip" )
	f5_local0:addElement( f5_local0.continueButton )
	f5_local0.continueButton:setActionEventNameNewStyle( f5_local0, f5_arg0, "loading_startplay" )
	f5_local0.continueButton:addElement( CoD.ButtonPrompt.new( "start", "", f5_local0, "loading_startplay", true ) )
	f5_local0.continueButton.label = LUI.UIText.new()
	f5_local0.continueButton.label:setLeftRight( true, true, 0, 0 )
	f5_local0.continueButton.label:setTopBottom( true, true, 0, 0 )
	f5_local0.continueButton.label:setFont( CoD.fonts.Condensed )
	f5_local0.continueButton.label:setAlignment( LUI.Alignment.Right )
	f5_local0.continueButton:addElement( f5_local0.continueButton.label )
	f5_local0.continueButton.label:setText( Engine.Localize( "PLATFORM_SKIP" ) )
	f5_local0.continueButton:setHandleMouse( false )
	if CoD.isPC then
		f5_local0:setForceMouseEventDispatch( true )
		f5_local0.continueButtonContainer = LUI.UIElement.new()
		f5_local0.continueButtonContainer:setLeftRight( true, true, 0, 0 )
		f5_local0.continueButtonContainer:setTopBottom( true, true, 0, 0 )
		f5_local0.continueButtonContainer:setAlpha( 1 )
		f5_local0.continueButtonContainer.id = "continueButtonContainer"
		f5_local0.continueButtonContainer:setHandleMouse( true )
		f5_local0:addElement( f5_local0.continueButtonContainer )
		f5_local0.continueButtonContainer:registerEventHandler( "button_action", function ( element, event )
			SendButtonPressToMenuEx( f5_local0, event.controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		end )
	end
end

LUI.createMenu.Loading = function ( f5_arg0 )
	local f5_local0 = CoD.Menu.NewFromState( "Loading", {
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = true,
		top = 0,
		bottom = 0
	} )
	f5_local0.id = "loadingMenu"
	f5_local0:setOwner( f5_arg0 )
	f5_local0:registerEventHandler( "start_loading", CoD.Loading.StartLoading )
	f5_local0:registerEventHandler( "start_spinner", CoD.Loading.StartSpinner )
	f5_local0:registerEventHandler( "fade_in_map_location", CoD.Loading.FadeInMapLocation )
	f5_local0:registerEventHandler( "fade_in_gametype", CoD.Loading.FadeInGametype )
	f5_local0:registerEventHandler( "fade_in_map_image", CoD.Loading.FadeInMapImage )
	if Dvar.fs_game:get() == Dvar.fs_game_saved:get() and Dvar.fs_game_saved:exists() and Dvar.sv_hostname:exists() and Dvar.sv_hostname:get() ~= "BlackOpsPublic" and Dvar.sv_hostname:get() ~= "Dedicated - dedicatedpc" and Dvar.sv_hostname:get() ~= "" then
	    Engine.SetDvar( "fs_game", "usermaps" )
    end

	local f5_local1 = false
	local f5_local2 = Engine.GetCurrentMap()
	local f5_local3 = Engine.GetCurrentGameType()
	local f5_local4 = CoD.GetMapValue( f5_local2, "loadingImage", "black" )
	if Engine.IsMultiplayerGame() then
		Engine.PlayMenuMusic( "load_" .. f5_local2 )
	end

	if CoD.isZombie then
		if f5_local2 ~= nil and f5_local2 == "zm_island" and IsJapaneseSku() and CoD.LANGUAGE_JAPANESE == Dvar.loc_language:get() then
			f5_local1 = false
		elseif f5_local2 ~= nil and (f5_local2 == "zm_asylum" or f5_local2 == "zm_cosmodrome" or f5_local2 == "zm_moon" or f5_local2 == "zm_sumpf" or f5_local2 == "zm_temple") then
			f5_local1 = false
		elseif Engine.IsDemoPlaying() or Engine.IsSplitscreen() then
			f5_local1 = false
		elseif not IsIntroMovieDisabled() then
			f5_local1 = true
			local f5_local5 = CoD.GetMapValue( f5_local2, "introMovie" )
			if f5_local5 == nil and Mods_IsUsingUsermap() then
				f5_local5 = f5_local2 .. "_load"
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
				Engine.PlayMenuMusic( "load_" .. f5_local2 )
			end
		end
	else
		if true == Dvar.ui_useloadingmovie:get() or CoD.isCampaign then
			if true == Engine.IsCampaignModeZombies() then
				f5_local2 = f5_local2 .. "_nightmares"
			end
			local f5_local6 = CoD.GetMapValue( f5_local2, "introMovie" )
			if f5_local2 ~= nil and f5_local2 == "cp_sh_singapore" and Dvar.cp_queued_level:get() == "cp_mi_sing_blackstation" then
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
		if CoD.GetMapValue( f5_local2, "fadeToWhite" ) == 1 then
			local f5_local7 = "$white"
		end
		f5_local4 = f5_local7 or "black"
	else
		Engine.SetDvar( "ui_useloadingmovie", 0 )
		if f5_local4 == nil or f5_local4 == "" or CoD.isMultiplayer then
			f5_local4 = "black"
		end
	end
	if Engine.IsLevelPreloaded( f5_local2 ) then
		f5_local0.addLoadingElement = function ( f6_arg0, f6_arg1 )
			if CoD.isCampaign then
				f6_arg0:addElement( f6_arg1 )
			end
		end
		
	else
		f5_local0.addLoadingElement = function ( f7_arg0, f7_arg1 )
			f7_arg0:addElement( f7_arg1 )
		end
		
	end

	local customMapImage = GetCustomMapImage( Engine.GetCurrentMap() )
	if CoD.isCampaign or not f5_local1 then
		if customMapImage ~= nil then
			f5_local4 = customMapImage
		end
	end

	f5_local0.mapImage = LUI.UIStreamedImage.new()
	f5_local0.mapImage.id = "mapImage"
	f5_local0.mapImage:setLeftRight( false, false, -640, 640 )
	f5_local0.mapImage:setTopBottom( false, false, -360, 360 )
	f5_local0.mapImage:setAlpha( 0 )
	f5_local0.mapImage:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_normal" ) )
	f5_local0.mapImage:setImage( RegisterImage( f5_local4 ) )
	f5_local0:addElement( f5_local0.mapImage )
	if f5_local1 == true then
		f5_local0.mapImage:setShaderVector( 0, 0, 0, 0, 0 )
		f5_local0.mapImage.ismp4 = false
	end
	local f5_local6 = 10
	local f5_local5 = 70
	local f5_local8 = "Big"
	local f5_local9 = CoD.fonts[f5_local8]
	local f5_local10 = CoD.textSize[f5_local8]
	local f5_local11 = "Condensed"
	local f5_local12 = CoD.fonts[f5_local11]
	local f5_local13 = CoD.textSize[f5_local11]
	f5_local0.mapNameLabel = LUI.UIText.new()
	f5_local0.mapNameLabel.id = "mapNameLabel"
	f5_local0.mapNameLabel:setLeftRight( true, false, f5_local5, f5_local5 + 1 )
	f5_local0.mapNameLabel:setTopBottom( true, false, f5_local6, f5_local6 + f5_local10 )
	f5_local0.mapNameLabel:setFont( f5_local9 )
	f5_local0.mapNameLabel:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
	f5_local0.mapNameLabel:setAlpha( 0 )
	f5_local0.mapNameLabel:registerEventHandler( "transition_complete_map_name_fade_in", CoD.Loading.MapNameFadeInComplete )
	f5_local0:addLoadingElement( f5_local0.mapNameLabel )
	f5_local6 = f5_local6 + f5_local10 - 5
	f5_local0.mapLocationLabel = LUI.UIText.new()
	f5_local0.mapLocationLabel.id = "mapLocationLabel"
	f5_local0.mapLocationLabel:setLeftRight( true, false, f5_local5, f5_local5 + 1 )
	f5_local0.mapLocationLabel:setTopBottom( true, false, f5_local6, f5_local6 + f5_local13 )
	f5_local0.mapLocationLabel:setFont( f5_local12 )
	f5_local0.mapLocationLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
	f5_local0.mapLocationLabel:setAlpha( 0 )
	f5_local0.mapLocationLabel:registerEventHandler( "transition_complete_map_location_fade_in", CoD.Loading.MapLocationFadeInComplete )
	f5_local0:addLoadingElement( f5_local0.mapLocationLabel )
	f5_local6 = f5_local6 + f5_local13 - 2
	f5_local0.gametypeLabel = LUI.UIText.new()
	f5_local0.gametypeLabel.id = "gametypeLabel"
	f5_local0.gametypeLabel:setLeftRight( true, false, f5_local5, f5_local5 + 1 )
	f5_local0.gametypeLabel:setTopBottom( true, false, f5_local6, f5_local6 + f5_local13 )
	f5_local0.gametypeLabel:setFont( f5_local12 )
	f5_local0.gametypeLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
	f5_local0.gametypeLabel:setAlpha( 0 )
	f5_local0.gametypeLabel:registerEventHandler( "transition_complete_gametype_fade_in", CoD.Loading.GametypeFadeInComplete )
	f5_local0:addLoadingElement( f5_local0.gametypeLabel )
	f5_local6 = f5_local6 + f5_local13 + 5
	local DemoTitle = Engine.Localize( "MPUI_TITLE_CAPS" ) .. ":"
	local f6_local14_1, f6_local14_2, f6_local14_3, f6_local14_4 = GetTextDimensions(DemoTitle, f5_local12, f5_local13)
	local DemoDuration = Engine.Localize( "MPUI_DURATION_CAPS" ) .. ":"
	local f6_local16_1, f6_local16_2, f6_local16_3, f6_local16_4 = GetTextDimensions(DemoDuration, f5_local12, f5_local13)
	local DemoAuthor = Engine.Localize( "MPUI_AUTHOR_CAPS" ) .. ":"
	local f6_local18_1, f6_local18_2, f6_local18_3, f6_local18_4 = GetTextDimensions(DemoAuthor, f5_local12, f5_local13)
	local f5_local20 = math.max(f6_local14_3, f6_local16_3, f6_local18_3) + 10
	local f5_local21 = 0

	if not Engine.IsLevelPreloaded( f5_local2 ) then
		f5_local0.demoInfoContainer = LUI.UIElement.new()
		f5_local0.demoInfoContainer:setLeftRight( true, false, f5_local5, 600 )
		f5_local0.demoInfoContainer:setTopBottom( true, false, f5_local6, f5_local6 + 600 )
		f5_local0.demoInfoContainer:setAlpha( 0 )
		f5_local0:addLoadingElement( f5_local0.demoInfoContainer )
		f5_local0.demoTitleTitle = LUI.UIText.new()
		f5_local0.demoTitleTitle:setLeftRight( true, true, 0, 0 )
		f5_local0.demoTitleTitle:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		f5_local0.demoTitleTitle:setFont( f5_local12 )
		f5_local0.demoTitleTitle:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
		f5_local0.demoTitleTitle:setAlignment( LUI.Alignment.Left )
		f5_local0.demoTitleTitle:setText( DemoTitle )
		SetupAutoHorizontalAlignArabicText( f5_local0.demoTitleTitle )
		f5_local0.demoInfoContainer:addElement( f5_local0.demoTitleTitle )
		f5_local0.demoTitleLabel = LUI.UIText.new()
		f5_local0.demoTitleLabel:setLeftRight( true, true, f5_local20, 0 )
		f5_local0.demoTitleLabel:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		f5_local0.demoTitleLabel:setFont( f5_local12 )
		f5_local0.demoTitleLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
		f5_local0.demoTitleLabel:setAlignment( LUI.Alignment.Left )
		SetupAutoHorizontalAlignArabicText( f5_local0.demoTitleLabel )
		f5_local0.demoInfoContainer:addElement( f5_local0.demoTitleLabel )
		f5_local21 = f5_local21 + f5_local13 - 2
		f5_local0.demoDurationTitle = LUI.UIText.new()
		f5_local0.demoDurationTitle:setLeftRight( true, true, 0, 0 )
		f5_local0.demoDurationTitle:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		f5_local0.demoDurationTitle:setFont( f5_local12 )
		f5_local0.demoDurationTitle:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
		f5_local0.demoDurationTitle:setAlignment( LUI.Alignment.Left )
		f5_local0.demoDurationTitle:setText( DemoDuration )
		SetupAutoHorizontalAlignArabicText( f5_local0.demoDurationTitle )
		f5_local0.demoInfoContainer:addElement( f5_local0.demoDurationTitle )
		f5_local0.demoDurationLabel = LUI.UIText.new()
		f5_local0.demoDurationLabel:setLeftRight( true, true, f5_local20, 0 )
		f5_local0.demoDurationLabel:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		f5_local0.demoDurationLabel:setFont( f5_local12 )
		f5_local0.demoDurationLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
		f5_local0.demoDurationLabel:setAlignment( LUI.Alignment.Left )
		SetupAutoHorizontalAlignArabicText( f5_local0.demoDurationLabel )
		f5_local0.demoInfoContainer:addElement( f5_local0.demoDurationLabel )
		f5_local21 = f5_local21 + f5_local13 - 2
		f5_local0.demoAuthorTitle = LUI.UIText.new()
		f5_local0.demoAuthorTitle:setLeftRight( true, true, 0, 0 )
		f5_local0.demoAuthorTitle:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		f5_local0.demoAuthorTitle:setFont( f5_local12 )
		f5_local0.demoAuthorTitle:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
		f5_local0.demoAuthorTitle:setAlignment( LUI.Alignment.Left )
		f5_local0.demoAuthorTitle:setText( DemoAuthor )
		SetupAutoHorizontalAlignArabicText( f5_local0.demoAuthorTitle )
		f5_local0.demoInfoContainer:addElement( f5_local0.demoAuthorTitle )
		f5_local0.demoAuthorLabel = LUI.UIText.new()
		f5_local0.demoAuthorLabel:setLeftRight( true, true, f5_local20, 0 )
		f5_local0.demoAuthorLabel:setTopBottom( true, false, f5_local21, f5_local21 + f5_local13 )
		f5_local0.demoAuthorLabel:setFont( f5_local12 )
		f5_local0.demoAuthorLabel:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
		f5_local0.demoAuthorLabel:setAlignment( LUI.Alignment.Left )
		SetupAutoHorizontalAlignArabicText( f5_local0.demoAuthorLabel )
		f5_local0.demoInfoContainer:addElement( f5_local0.demoAuthorLabel )
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
	f5_local0.loadingBarContainer = LUI.UIElement.new()
	f5_local0.loadingBarContainer.id = "loadingBarContainer"
	f5_local0.loadingBarContainer:setLeftRight( false, false, -f5_local26 / 2, f5_local26 / 2 )
	f5_local0.loadingBarContainer:setTopBottom( false, true, f5_local27 - f5_local25, f5_local27 )
	f5_local0.loadingBarContainer:setAlpha( 0 )
	f5_local0:addElement( f5_local0.loadingBarContainer )
	--f5_local0.dykContainer = LUI.UIElement.new()
	--f5_local0.dykContainer.id = "dykContainer"
	--f5_local0.dykContainer:setLeftRight( true, true, f5_local22 + f5_local31, 0 )
	--f5_local0.dykContainer:setTopBottom( true, false, f5_local28, f5_local28 + CoD.Loading.DYKFontHeight )
	--f5_local0.dykContainer.containerHeight = f5_local23
	--f5_local0.dykContainer.textAreaWidth = f5_local26 - f5_local22 - f5_local31 - f5_local29 - f5_local30 - 1

	--CoD.Loading.SetupDYKContainerImages( f5_local0.dykContainer )


	f5_local28 = f5_local28 + f5_local23 + 1
	f5_local0.spinner = LUI.UIImage.new()
	f5_local0.spinner.id = "spinner"
	f5_local29 = 110
	f5_local30 = f5_local30 * 5
	f5_local0.spinner:setLeftRight( false, true, -(f5_local29 + f5_local30 / 2), -(f5_local29 - f5_local30 / 2) )
	f5_local0.spinner:setTopBottom( false, true, -(f5_local29 + f5_local30 / 2), -(f5_local29 - f5_local30 / 2) )
	f5_local0.spinner:setImage( RegisterMaterial( "lui_loader" ) )
	f5_local0.spinner:setShaderVector( 0, 0, 0, 0, 0 )
	f5_local0.spinner:setAlpha( 0 )
	f5_local0.spinner:setPriority( 200 )
	f5_local0:addElement( f5_local0.spinner )
	local self = LUI.UIImage.new()
	self.id = "loadingBarBackground"
	self:setLeftRight( true, true, 1, -1 )
	self:setTopBottom( true, false, f5_local28, f5_local28 + f5_local24 )
	self:setRGB( 0.1, 0.1, 0.1 )
	f5_local0.loadingBarContainer:addElement( self )
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
	f5_local0.loadingBarContainer:addElement( self )
	self:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self:setShaderVector( 1, 0, 0, 0, 0 )
	self:setShaderVector( 2, 1, 0, 0, 0 )
	self:setShaderVector( 3, 0, 0, 0, 0 )
	self:setShaderVector( 1, 0, 0, 0, 0 )
	self:setShaderVector( 2, 1, 0, 0, 0 )
	self:setShaderVector( 3, 0, 0, 0, 0 )
	self:subscribeToGlobalModel( f5_arg0, "LoadingScreenTeamInfo", "loadedFraction", function ( modelRef )
		local loadedFraction = Engine.GetModelValue( modelRef )
		if loadedFraction then
			self:setShaderVector( 0, loadedFraction, 0, 0, 0 )
			self:setShaderVector( 0, loadedFraction, 0, 0, 0 )
		end
	end )
	LUI.OverrideFunction_CallOriginalSecond( f5_local0, "close", function ( element )
		self:close()
	end )
	f5_local28 = f5_local28 + f5_local24
	f5_local0.statusLabel = LUI.UIText.new()
	f5_local0.statusLabel:setLeftRight( true, true, 9, 0 )
	f5_local0.statusLabel:setTopBottom( true, false, 5, 29 )
	f5_local0.statusLabel:setAlpha( 1 )
	f5_local0.statusLabel:setFont(CoD.Loading.DYKFont)
	f5_local0.statusLabel:setAlignment( LUI.Alignment.Left )
	f5_local0.statusLabel:setupLoadingStatusText()
	f5_local0.loadingBarContainer:addElement( f5_local0.statusLabel )

	local mapDescription = CoD.GetMapValue( Engine.GetCurrentMap(), "mapDescription", "" )
	if Mods_IsUsingUsermap() then
		local ModsLists = Engine.Mods_Lists_GetInfoEntries( "usermaps", 0, Engine.Mods_Lists_GetInfoEntriesCount( "usermaps" ) )
		if ModsLists then
			for int = 0 , #ModsLists, 1 do
				local map = ModsLists[int] 
				if map.ugcName == Dvar.ui_mapname:get() and LUI.startswith( map.internalName, "zm_" ) then
					mapDescription = map.description
				end
			end
		end
	end

	f5_local0.didYouKnow = LUI.UIText.new()
	f5_local0.didYouKnow:setLeftRight( true, true, f5_local22 + f5_local31, 0 )
	f5_local0.didYouKnow:setTopBottom( true, false, f5_local28, f5_local28 + CoD.Loading.DYKFontHeight )
	--f5_local0.didYouKnow:setRGB( CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b )
	f5_local0.didYouKnow:setFont( CoD.Loading.DYKFont )
	f5_local0.didYouKnow:setAlignment( LUI.Alignment.Left )
	f5_local0.didYouKnow:setText( Engine.Localize( mapDescription ) )
	--f5_local0.didYouKnow:setPriority( 0 )
	f5_local0.didYouKnow:setAlpha( 1 )
	f5_local0.loadingBarContainer:addElement( f5_local0.didYouKnow )

	if f5_local1 == true then
		f5_local0.mapImage:setAlpha( 1 )
		CoD.Loading.AddNewLoadingScreen( f5_local0 )
		f5_local0.cinematicSubtitles = CoD.MovieSubtitles.new( f5_local0, f5_arg0 )
		f5_local0.cinematicSubtitles:setLeftRight( false, false, -640, 640 )
		f5_local0.cinematicSubtitles:setTopBottom( false, false, -360, 360 )
		f5_local0:addElement( f5_local0.cinematicSubtitles )
		f5_local0.mapImage:registerEventHandler( "loading_updateimage", f0_local0 )
		f5_local0.mapImage.id = "loadingMenu.mapImage"
		f5_local0:addElement( LUI.UITimer.new( 16, "loading_updateimage", false, f5_local0.mapImage ) )
		Engine.SetDvar( "ui_useloadingmovie", 1 )
		AddContinueButton( f5_local0, f5_arg0 )
		f5_local0:registerEventHandler( "loading_displaycontinue", f0_local1 )
		f5_local0:registerEventHandler( "loading_startplay", f0_local2 )
		if Engine.GetCurrentMap() == "zm_theater" then
			CoD.Loading.StartLoading( f5_local0 )
			CoD.Loading.StartSpinner( f5_local0 )
			f5_local0:registerEventHandler( "fade_in_map_image", nil )
		end
	else
		if CoD.isCampaign then
			CoD.Loading.StartLoading( f5_local0 )
			CoD.Loading.FadeInMapImage( f5_local0 )
			Engine.SetDvar( "ui_useloadingmovie", 1 )
			AddContinueButton( f5_local0, f5_arg0 )
			f5_local0:registerEventHandler( "loading_displaycontinue", f0_local1 )
			f5_local0:registerEventHandler( "loading_startplay", f0_local2 )
		else
			CoD.Loading.StartLoading( f5_local0 )
			f5_local0:addElement( LUI.UITimer.new( CoD.Loading.SpinnerDelayTime, "start_spinner", true, f5_local0 ) )
		end
	end
	return f5_local0
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

CoD.Loading.StartLoading = function ( f13_arg0 )
	Engine.PrintInfo( Enum.consoleLabel.LABEL_DEFAULT, "Opening loading screen...\n" )
	if f13_arg0.loadingScreenOverlay == nil then
		CoD.Loading.AddNewLoadingScreen( f13_arg0 )
	end
	if Engine.IsMultiplayerGame() then
		return 
	end
	local f13_local0 = Engine.GetPrimaryController()
	local f13_local1 = MapNameToLocalizedMapName( Engine.GetCurrentMap() )
	local f13_local2 = MapNameToLocalizedMapLocation( Engine.GetCurrentMap() )
	local f13_local3 = Engine.GetCurrentGametypeName( f13_local0 )
	f13_arg0.mapNameLabel:setText( f13_local1 )
	f13_arg0.mapLocationLabel:setText( f13_local2 )
	f13_arg0.gametypeLabel:setText( f13_local3 )
	if Engine.IsDemoPlaying() then
		local f13_local4 = Dvar.ls_demotitle:get()
		local f13_local5 = Dvar.ls_demoduration:get()
		local f13_local6 = ""
		if f13_local5 > 0 then
			f13_local6 = Engine.SecondsAsTime( Dvar.ls_demoduration:get() )
		end
		local f13_local7 = Dvar.ls_demoauthor:get()
		f13_arg0.demoTitleLabel:setText( f13_local4 )
		f13_arg0.demoDurationLabel:setText( f13_local6 )
		f13_arg0.demoAuthorLabel:setText( f13_local7 )
		if f13_local7 == "" then
			f13_arg0.demoAuthorTitle:setAlpha( 0 )
		end
		if f13_local6 == "" then
			f13_arg0.demoDurationTitle:setAlpha( 0 )
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
	f13_arg0.mapNameLabel:beginAnimation( "map_name_fade_in", CoD.Loading.FadeInTime )
	f13_arg0.mapNameLabel:setAlpha( 1 )
end