require("ui_mp.t6.hud_og")
require("ui.uieditor.widgets.GFL.HUD.ThirdpersonCrosshair")
if CoD.isZombie then
    require( "ui.uieditor.menus.hud.JUPHud_zm_factory" )
end

local PreLoadFunc = function( self, controller )
    if CoD.isZombie then
        require("ui.uieditor.widgets.HUD.ZM_NotifFactory.ZMNotificationContainer")
        -- require("ui.uieditor.widgets.HUD.ZM_NotifFactory.ZmNotifBGB_ContainerFactory")
        require( "ui.uieditor.widgets.hud.aae_t9_zombie_health_bar.aae_t9_zombie_health_bar_container" )
        require( "ui.uieditor.widgets.StartMenu.StartMenu_GameOptions_ZM" )
        require( "ui.uieditor.menus.CharacterCustomization.ChooseZMCharacterLoadout_InGame" )
        require( "ui.uieditor.widgets.HUD.KingslayerWaypointsWidget.KingslayerWaypointsContainer" )
    end
end

local f0_local10 = function ()
    local f0_local9 = false
	if f0_local9 then
		return 
	end
	f0_local9 = true
	require( "ui_mp.T6.HUD.InGameMenus" )
	require( "ui.uieditor.menus.Core_UI_require" )
	require( "ui.uieditor.menus.core_patch_require" )
	if CoD.isPC then
		require( "ui.uieditor.menus.core_patch_pc_require" )
	end
	if CoD.isCampaign then
		require( "ui.uieditor.menus.hud.HUD_CP_require" )
		require( "ui.uieditor.menus.hud.cp_patch_require" )
		require( "ui.uieditor.widgets.Reticles.RocketLaunchers.rocketLauncherReticle" )
		if Engine.GetCurrentMap() == "cp_mi_eth_prologue" then
			require( "ui.uieditor.menus.CPLevels.Prologue.SecurityCamera" )
			require( "ui.uieditor.menus.SpinnerFullscreenBlack" )
		elseif Engine.GetCurrentMap() == "cp_mi_zurich_coalescence" then
			require( "ui.uieditor.menus.SpinnerFullscreenBlack" )
		end
	elseif CoD.isZombie then
		require( "ui.uieditor.menus.hud.HUD_ZM_require" )
		require( "ui.uieditor.menus.hud.zm_patch_require" )
		require( "ui.uieditor.widgets.Reticles.Magnifier.MagnifierReticle_UI3D" )
		require( "ui.uieditor.widgets.Demo.Demo" )
		if Mods_IsUsingMods() then
			require( "ui.uieditor.widgets.HUD.Console.Console" )
		end
		if Engine.GetCurrentMap() == "zm_zod" then
			require( "ui.uieditor.menus.hud.T7Hud_ZM" )
			require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )
			require( "ui.uieditor.menus.ZMLevels.ZOD.JumpScare" )
			require( "ui.uieditor.widgets.HUD.ZM_TimeBar.ZM_BeastmodeTimeBarWidget" )
			require( "ui.uieditor.widgets.ZMInventory.FuseBox.FuseWidget" )
			require( "ui.uieditor.widgets.ZMInventory.InventoryWidget" )
			require( "ui.uieditor.widgets.ZMInventory.Ritual.RitualItem" )
			require( "ui.uieditor.widgets.ZMInventory.Ritual.RitualWidget" )
		elseif Engine.GetCurrentMap() == "zm_factory" then
			require( "ui.uieditor.menus.hud.T7Hud_zm_factory" )
			require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )
		elseif Engine.GetCurrentMap() == "zm_castle" then
			require( "ui.uieditor.menus.hud.T7Hud_zm_castle" )
			require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )
		elseif Engine.GetCurrentMap() == "zm_island" then
			require( "ui.uieditor.menus.hud.T7Hud_zm_island" )
			require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )
		elseif Engine.GetCurrentMap() == "zm_stalingrad" then
			require( "ui.uieditor.menus.hud.T7Hud_zm_stalingrad" )
			require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )
			require( "ui.uieditor.widgets.Reticles.LauncherMulti.LauncherMultiReticle" )
		elseif Engine.GetCurrentMap() == "zm_genesis" then
			require( "ui.uieditor.menus.hud.T7Hud_zm_genesis" )
			require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )
		elseif Engine.GetCurrentMap() == "zm_tomb" then
			require( "ui.uieditor.menus.hud.T7Hud_zm_tomb" )
			require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )
			require( "ui.uieditor.menus.ZMLevels.TOMB.JumpScare-Tomb" )
			require( "ui.uieditor.widgets.Reticles.LauncherMulti.LauncherMultiReticle" )
		elseif Engine.GetCurrentMap() == "zm_cosmodrome" or Engine.GetCurrentMap() == "zm_moon" or Engine.GetCurrentMap() == "zm_temple" or Engine.GetCurrentMap() == "zm_theater" then
			require( "ui.uieditor.menus.hud.T7Hud_zm_dlc5" )
			require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )
			require( "ui.uieditor.widgets.Reticles.LauncherMulti.LauncherMultiReticle" )
		else
			require( "ui.uieditor.menus.hud.T7Hud_zm_factory" )
			require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )
		end
	else
		require( "ui.uieditor.menus.hud.HUD_MP_require" )
		require( "ui.uieditor.menus.hud.mp_patch_require" )
		require( "ui.uieditor.widgets.MPHudWidgets.CodCaster.CodCaster" )
		require( "ui.uieditor.widgets.Demo.Demo" )
		require( "ui.uieditor.widgets.Reticles.RocketLaunchers.rocketLauncherReticle" )
		if Engine.GetCurrentMap() == "mp_city" then
			require( "ui.uieditor.menus.VehicleHUDs.Scorestreaks.VHUD_SiegeBot" )
		end
	end
end

local function AddCustomHUDElements_Zombie(menu, controller)
    -- local self = menu:getParent()
    local self = menu
    local parent = menu:getParent()
	if Engine.DvarInt(nil, "personalization_hud") ~= 0 then
        self:setupHUDShaker()
	end

    local ZMNotificationContainer = CoD.ZMNotificationContainer.new(menu, controller)
    -- if Engine.GetCurrentMap() == "zm_log_kowloon" then
    --     ZMNotificationContainer = CoD.ZMNotificationContainer.new(menu, controller)
    -- else
    --     ZMNotificationContainer = CoD.ZmNotifBGB_ContainerFactory.new(menu, controller)
    -- end

    ZMNotificationContainer:setLeftRight(false, false, -156, 156)
    ZMNotificationContainer:setTopBottom(true, false, -6, 247)
    ZMNotificationContainer:setScale(0.75)
    ZMNotificationContainer:subscribeToGlobalModel(controller, "PerController", "hudItems.CharacterPopup",
        function(model)
            local ModelValue = Engine.GetModelValue(model)
            if ModelValue then
                if ModelValue == "" or ModelValue == "none" then
                    return
                end

                local container = ZMNotificationContainer
                if container and container.id and container.id == "ZMNotificationContainer" then
                    ClearNotificationQueue(container)
                end

                AddCharacterNotification(self, container, ModelValue)
            end
        end)

    ZMNotificationContainer:subscribeToGlobalModel(controller, "PerController", "scriptNotify", function(model)
        local container = ZMNotificationContainer

        if model and Engine.GetModelValue( model ) then
            local param = Engine.GetModelValue( model )
            if not string.match( param, "gfl_" ) then
                return
            end
        else
            return
        end

        if container and container.id and container.id == "ZMNotificationContainer" then
            ClearNotificationQueue(container)
        end

        if IsParamModelEqualToString(model, "gfl_cheats_notification") then
            AddCheatsNotification(self, container, model)
        elseif IsParamModelEqualToString(model, "gfl_tdoll_zombies_notification") then
            AddSimpleNotification(self, container, "t7_gfl_notification_hk416_gloomy", "GFL_ZM_NOTIFICATION_TDOLL_ZOMBIES", "GFL_ZM_NOTIFICATION_TDOLL_ZOMBIES_DESC")
        end
    end)

    self:addElement(ZMNotificationContainer)
    self.ZMNotificationContainer = ZMNotificationContainer

    local ZombieHealthBar = CoD.AAE_t9_zombie_health_bar_container.new( menu, controller )
    self:addElement( ZombieHealthBar )
    self.ZombieHealthBar = ZombieHealthBar

    local function UpdateZombieHealthBarVisible( ModelRef )
        local ModelValue = Engine.GetModelValue( ModelRef )
        if ModelValue then
            if ModelValue == 1 then
                ZombieHealthBar:setScale(1)
            else
                ZombieHealthBar:setScale(0)
            end
        end
    end
    local function UpdateZombieHealthBarNotVisible( ModelRef )
        local ModelValue = Engine.GetModelValue( ModelRef )
        if ModelValue then
            if ModelValue == 1 then
                ZombieHealthBar:setScale(0)
            else
                ZombieHealthBar:setScale(1)
            end
        end
    end
    ZombieHealthBar:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE ), UpdateZombieHealthBarVisible )
    ZombieHealthBar:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE ), UpdateZombieHealthBarVisible )
    ZombieHealthBar:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE ), UpdateZombieHealthBarVisible )
    ZombieHealthBar:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE ), UpdateZombieHealthBarNotVisible )

    self.KingslayerWaypointsContainer = CoD.KingslayerWaypointsContainer.new( self, controller )
    self.KingslayerWaypointsContainer:setLeftRight( true, true, 0, 0 )
    self.KingslayerWaypointsContainer:setTopBottom( true, true, 0, 0 )
    self:addElement( self.KingslayerWaypointsContainer )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
        element.ZMNotificationContainer:close()
        element.ZombieHealthBar:close()
		element.KingslayerWaypointsContainer:close()
	end )
end

local function AddCustomHUDElements_Common(menu, controller)
    local self = menu:getParent()

    local ThirdpersonCrosshair = CoD.ThirdpersonCrosshair.new(menu, controller)
    self.ThirdpersonCrosshair = ThirdpersonCrosshair
    self:addElement(ThirdpersonCrosshair)

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
	end )
end

function HUD_FirstSnapshot_Common(f40_arg0, f40_arg1)
	if PreLoadFunc then
		PreLoadFunc( f40_arg0, f40_arg1 )
	end

    CoD.CACUtility.ForceStreamAttachmentImages(f40_arg1.controller)
    if not CoD.isMultiplayer then
        f40_arg0.cinematicSubtitles = CoD.MovieSubtitles.new(f40_arg0, f40_arg1.controller)
        f40_arg0.cinematicSubtitles:setLeftRight(false, false, -640, 640)
        f40_arg0.cinematicSubtitles:setTopBottom(false, false, -360, 360)
        f40_arg0:addElement(f40_arg0.cinematicSubtitles)
    end
    local f40_local0 = f40_arg1.controller
    HUD_AddHintTextElements(f40_arg0, f40_local0)
    local f40_local1 = CoD.Menu.NewSafeAreaFromState("hud_safearea", f40_arg1.controller)
    f40_local1:setPriority(100)
    f40_local1:setOwner(f40_arg1.controller)
    f40_arg0:addElement(f40_local1)
    if f40_arg0.safeArea and f40_arg0.safeArea.buttonModel then
        Engine.UnsubscribeAndFreeModel(f40_arg0.safeArea.buttonModel)
        f40_arg0.safeArea:close()
    end
    f40_arg0.safeArea = f40_local1
    f40_arg0.safeArea.buttonModel = Engine.CreateModel(Engine.GetModelForController(f40_local0), "HUD.buttonPrompts")
    local f40_local2 = CoD.GrenadeEffect.new(f40_local0)
    f40_local2:setLeftRight(true, true, 0, 0)
    f40_local2:setTopBottom(true, true, 0, 0)
    f40_arg0:addForceClosedSafeAreaChild(f40_local2)
    if CoD.isZombie == true then
        CoD.Zombie.SoloQuestMode = false
        local f40_local3 = Engine.GetLobbyClientCount(Enum.LobbyType.LOBBY_TYPE_GAME)
        if f40_local3 == 1 and
            (CoD.isOnlineGame() == false or Engine.GameModeIsMode(CoD.GAMEMODE_PRIVATE_MATCH) == false) then
            CoD.Zombie.SoloQuestMode = true
        end
        if Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == true and f40_local3 > 2 then
            CoD.Zombie.LocalSplitscreenMultiplePlayers = true
        end
    end
    HUD_CloseScoreBoard(f40_arg0, f40_arg1)
    if Dvar.ui_gametype:get() ~= "fr" and not CoD.ShowNewScoreboard() then
        f40_arg0.scoreBoard = LUI.createMenu.Scoreboard(f40_arg1.controller)
        f40_arg0.scoreboardUpdateTimer = LUI.UITimer.new(1000, {
            name = "update_scoreboard",
            controller = f40_arg1.controller
        }, false)
    end
    Engine.Durango_CheckPrimaryStolenPopupAfterLoading()

    AddCustomHUDElements_Common(f40_arg0, f40_arg1.controller)
    if CoD.isZombie then
        AddCustomHUDElements_Zombie(f40_arg0, f40_arg1.controller)
    end
end

function HUD_FirstSnapshot_Zombie( f52_arg0, f52_arg1 )
	CoD.GameMessages.AddSubtitlesWindow( f52_arg0, {
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = false,
		bottomAnchor = true,
		top = -100,
		bottom = -100 + CoD.textSize.Default
	} )
	local self = LUI.UIElement.new()
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:sizeToSafeArea()
	f52_arg0:addForceClosedChild( self )
	if CoD.Zombie.IsDLCMap( CoD.Zombie.DLC3Maps ) then
		self:registerEventHandler( "time_bomb_hud_toggle", HUD_ToggleZombieHudContainer )
	end
	f0_local10()
	if f52_arg0.T7HudMenuGameMode == nil then
		local powerupsArea = Engine.GetCurrentMap()
		local hudName
		if powerupsArea == "zm_zod" then
			hudName = "T7Hud_ZM"
        else
            hudName = "T7Hud_" .. powerupsArea
		end

        local createHud = LUI.createMenu.T7Hud_zm_factory
        local hudFunc = LUI.createMenu[hudName]
        if hudFunc then
            createHud = hudFunc
        elseif powerupsArea == "zm_cosmodrome" or powerupsArea == "zm_moon" or powerupsArea == "zm_temple" or powerupsArea == "zm_theater" then
            createHud = LUI.createMenu.T7Hud_zm_dlc5
        end

        f52_arg0.T7HudMenuGameMode = createHud( f52_arg1.controller )
	else
		f52_arg0.T7HudMenuGameMode:setAlpha( 1 )
		local powerupsArea = Engine.GetModelForController( f52_arg1.controller )
		if powerupsArea then
			powerupsArea = Engine.GetModel( powerupsArea, "hudItems.playerSpawned" )
		end
		if powerupsArea and Engine.GetModelValue( powerupsArea ) then
			Engine.SetModelValue( powerupsArea, true )
		end
	end
	f52_arg0:addElement( f52_arg0.T7HudMenuGameMode )
	
	local powerupsArea = LUI.createMenu.PowerUpsArea( f52_arg1.controller )
	self:addElement( powerupsArea )
	self.powerupsArea = powerupsArea
	
    local function ResetPowerupsAreaVisibility()
        if self.powerupsArea == nil then
            return
        end

        if Engine.DvarInt(nil, "personalization_custom_hud") ~= 0 then
            if self.powerupsArea.scaleContainer then
                self.powerupsArea.scaleContainer:setAlpha( 0 )
            end
        else
            if self.powerupsArea.scaleContainer then
                self.powerupsArea.scaleContainer:setAlpha( 1 )
            end
        end
    end

    f52_arg0:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "CustomHUD" ), function(model)
        local ModelValue = Engine.GetModelValue(model)
        if ModelValue then
            ResetPowerupsAreaVisibility()
        end
    end)

    ResetPowerupsAreaVisibility()

	if CoD.isZombie == true and Mods_IsUsingMods() then
		local f52_local2 = CoD.Console.new( f52_arg0, f52_arg1.controller )
		f52_local2:setLeftRight( true, false, 39, 809 )
		f52_local2:setTopBottom( false, true, -160, -20 )
		f52_local2:setAlpha( 1 )
		f52_arg0:addElement( f52_local2 )
		f52_arg0.Console = f52_local2
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.powerupsArea:close()
	end )
	if not Engine.IsSplitscreen() then
		CoD.GameMessages.AddObituaryWindow( f52_arg0, {
			leftAnchor = true,
			rightAnchor = false,
			left = 13,
			right = 277,
			topAnchor = false,
			bottomAnchor = true,
			top = -220 - CoD.textSize.ExtraSmall,
			bottom = -220
		}, f52_arg1.controller )
		CoD.GameMessages.BoldGameMessagesWindow( f52_arg0, {
			leftAnchor = false,
			rightAnchor = false,
			left = 0,
			right = 0,
			topAnchor = true,
			bottomAnchor = false,
			top = 50,
			bottom = 50 + CoD.textSize.Default
		}, f52_arg1.controller )
	end
	CoD.DemoUtility.AddHUDWidgets( f52_arg0, f52_arg1 )
	if f52_arg0.occludedBy and CoD.OverlayUtility.Overlays.MessageDialogBox.getStringRef( f52_arg1.controller ) == "PLATFORM_PROFILE_CHANGE_MESSAGE" then
		LuaUtils.MessageDialogForceSubscriptionFire( true )
	end
end