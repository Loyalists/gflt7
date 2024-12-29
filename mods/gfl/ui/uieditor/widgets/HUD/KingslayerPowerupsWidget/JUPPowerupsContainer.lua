require( "ui.uieditor.widgets.HUD.KingslayerPowerupsWidget.KingslayerPowerupsListItem" )

if not CoD.JUPClientFieldNames then
	CoD.JUPClientFieldNames = {
		{
			clientFieldName = "powerup_instant_kill",
			image = "v_ui_icons_zombies_powerup_instakill"
		},
		{
			clientFieldName = "powerup_double_points",
			image = "v_ui_icons_zombies_powerup_double_points"
		},
		{
			clientFieldName = "powerup_fire_sale",
			image = "v_ui_icons_zombies_powerup_firesale"
		},
		{
			clientFieldName = "powerup_mini_gun",
			image = "v_ui_icons_zombies_powerup_deathmachine"
		}
	}
end

CoD.PowerUps.Update = function ( self, event )
	local powerupStateModel = Engine.GetModel( Engine.GetModelForController( event.controller ), event.name .. ".state" )

	if powerupStateModel ~= nil then
		Engine.SetModelValue( powerupStateModel, event.newValue )
	end

	CoD.PowerUps.UpdateState( self, event )
	CoD.PowerUps.UpdatePosition( self, event )
end

local PreLoadFunc = function ( self, controller )
	for index = 1, #CoD.JUPClientFieldNames do
		Engine.CreateModel( Engine.GetModelForController( controller ), CoD.JUPClientFieldNames[index].clientFieldName .. ".state" )
	end
end

local PostLoadFunc = function ( self, controller, menu )
	for index = 1, #CoD.JUPClientFieldNames do
		local powerupStateModel = Engine.GetModel( Engine.GetModelForController( controller ), CoD.JUPClientFieldNames[index].clientFieldName .. ".state" )
		local powerupTimeModel = Engine.GetModel( Engine.GetModelForController( controller ), CoD.JUPClientFieldNames[index].clientFieldName .. ".time" )
		
		if powerupStateModel ~= nil then
			self.PowerupList:subscribeToModel( powerupStateModel, function ( model )
				self.PowerupList:updateDataSource()
			end )
		end

		if powerupTimeModel ~= nil then
			self.PowerupList:subscribeToModel( powerupTimeModel, function ( model )
				self.PowerupList:updateDataSource()
			end )
		end
	end
end

DataSources.JUPPowerups = DataSourceHelpers.ListSetup( "JUPPowerups", function ( controller, element )	
	local powerups = {}

	local powerupState = nil
	local powerupTime = nil

	for index = 1, #CoD.JUPClientFieldNames do
		powerupState = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), CoD.JUPClientFieldNames[index].clientFieldName .. ".state" ) )
		powerupTime = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), CoD.JUPClientFieldNames[index].clientFieldName .. ".time" ) )

		if powerupState then
			if powerupState > 0 then
				table.insert( powerups, {
					models = {
						image = CoD.JUPClientFieldNames[index].image,
						state = powerupState,
						time = powerupTime
					}
				} )
			end
		end
	end

	return powerups
end, true )

CoD.JUPPowerupsContainer = InheritFrom( LUI.UIElement )
CoD.JUPPowerupsContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.JUPPowerupsContainer )
	self.id = "JUPPowerupsContainer"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )

	self.PowerupList = LUI.UIList.new( menu, controller, 17, 0, nil, false, false, 0, 0, false, false )
	self.PowerupList:makeFocusable()
	self.PowerupList:setLeftRight( false, false, 0, 0 )
	self.PowerupList:setTopBottom( false, true, 0, -177.5 )
	self.PowerupList:setWidgetType( CoD.KingslayerPowerupsListItem )
	self.PowerupList:setHorizontalCount( 4 )
	self.PowerupList:setDataSource( "JUPPowerups" )
	self:addElement( self.PowerupList )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )

				self.PowerupList:completeAnimation()
				self.PowerupList:setAlpha( 1 )
				self.clipFinished( self.PowerupList, {} )
			end,
			Hidden = function ()
				self:setupElementClipCounter( 1 )
	
				local HiddenTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( 0 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.PowerupList:completeAnimation()
				self.PowerupList:setAlpha( 1 )
				HiddenTransition( self.PowerupList, {} )
			end
		},
		Hidden = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )

				self.PowerupList:completeAnimation()
				self.PowerupList:setAlpha( 0 )
				self.clipFinished( self.PowerupList, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 1 )

				local DefaultStateTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( 1 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.PowerupList:completeAnimation()
				self.PowerupList:setAlpha( 0 )
				DefaultStateTransition( self.PowerupList, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED )
				and Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_SCOPED )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE ) then
					return false
				else
					return true
				end
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
		} )
	end )

	self.PowerupList.id = "PowerupList"

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.PowerupList:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
