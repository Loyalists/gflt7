CoD.JUPAmmoInfo = InheritFrom( LUI.UIElement )
CoD.JUPAmmoInfo.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.JUPAmmoInfo )
	self.id = "JUPAmmoInfo"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	local ammoClipOffset = -28

    self.AmmoClip = LUI.UIText.new()
    self.AmmoClip:setLeftRight( true, true, 0 + ammoClipOffset, 245 + ammoClipOffset )
    self.AmmoClip:setTopBottom( false, true, -102, -102 + 85 )
    self.AmmoClip:setTTF( "fonts/main_bold.ttf" )
	self.AmmoClip:setScale( 0.5 )
	self.AmmoClip:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.AmmoClip:subscribeToGlobalModel( controller, "CurrentWeapon", "ammoInClip", function ( model )
		local ammoInClip = Engine.GetModelValue( model )

		if ammoInClip then
			if IsLowAmmoClip( controller ) then
				self.AmmoClip:setRGB( 0.85, 0.30, 0.21 )
			else
				self.AmmoClip:setRGB( 1, 1, 1 )
			end

			self.AmmoClip:setText( Engine.Localize( ammoInClip ) )
		end
	end )
    self:addElement( self.AmmoClip )

	self.AmmoClipDW = LUI.UIText.new()
    self.AmmoClipDW:setLeftRight( true, true, 0 + ammoClipOffset - 45, 245 + ammoClipOffset - 45 )
    self.AmmoClipDW:setTopBottom( false, true, -102, -102 + 85 )
    self.AmmoClipDW:setTTF( "fonts/main_bold.ttf" )
	self.AmmoClipDW:setScale( 0.5 )
	self.AmmoClipDW:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.AmmoClipDW:subscribeToGlobalModel( controller, "CurrentWeapon", "ammoInDWClip", function ( model )
		local ammoInDWClip = Engine.GetModelValue( model )

		if ammoInDWClip then
			if IsLowAmmoDWClip( controller ) then
				self.AmmoClipDW:setRGB( 0.85, 0.30, 0.21 )
			else
				self.AmmoClipDW:setRGB( 1, 1, 1 )
			end

			self.AmmoClipDW:setText( Engine.Localize( ammoInDWClip ) )
		end
	end )
    self:addElement( self.AmmoClipDW )

	self.AmmoStock = LUI.UIText.new()
    self.AmmoStock:setLeftRight( true, true, 0, 3220 )
    self.AmmoStock:setTopBottom( false, true, -86, -86 + 40 )
	self.AmmoStock:setTTF( "fonts/main_bold.ttf" )
	self.AmmoStock:setScale( 0.5 )
	self.AmmoStock:setAlpha( 0.7 )
	self.AmmoStock:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.AmmoStock:subscribeToGlobalModel( controller, "CurrentWeapon", "ammoStock", function ( model )
		local ammoStock = Engine.GetModelValue( model )

		if ammoStock then
			self.AmmoStock:setText( Engine.Localize( ammoStock ) )
		end
	end )
	self:addElement( self.AmmoStock )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				self.AmmoClip:completeAnimation()
				self.AmmoClip:setAlpha( 1 )
				self.clipFinished( self.AmmoClip, {} )

				self.AmmoClipDW:completeAnimation()
				self.AmmoClipDW:setAlpha( 0 )
				self.clipFinished( self.AmmoClipDW, {} )

				self.AmmoStock:completeAnimation()
				self.AmmoStock:setAlpha( 0.7 )
				self.clipFinished( self.AmmoStock, {} )
			end,
			AmmoPulse = function ()
				self:setupElementClipCounter( 1 )
			
				local AmmoPulseTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Linear )
					end
	
					element:setTopBottom( false, true, -102 - 10, -102 + 85 + 10 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.AmmoClip:completeAnimation()
				self.AmmoClip:setTopBottom( false, true, -102, -102 + 85 )
				AmmoPulseTransition( self.AmmoClip, {} )
			end
		},
		AmmoPulse = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )
				
				self.AmmoClip:completeAnimation()
				self.AmmoClip:setAlpha( 1 )
				self.clipFinished( self.AmmoClip, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 1 )
			
				local AmmoPulseTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Linear )
					end
	
					element:setTopBottom( false, true, -102, -102 + 85 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.AmmoClip:completeAnimation()
				self.AmmoClip:setTopBottom( false, true, -102 - 10, -102 + 85 + 10 )
				AmmoPulseTransition( self.AmmoClip, {} )
			end
		},
		Hidden = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				self.AmmoClip:completeAnimation()
				self.AmmoClip:setAlpha( 0 )
				self.clipFinished( self.AmmoClip, {} )

				self.AmmoClipDW:completeAnimation()
				self.AmmoClipDW:setAlpha( 0 )
				self.clipFinished( self.AmmoClipDW, {} )

				self.AmmoStock:completeAnimation()
				self.AmmoStock:setAlpha( 0 )
				self.clipFinished( self.AmmoStock, {} )
			end
		},
		WeaponDual = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				self.AmmoClip:completeAnimation()
				self.AmmoClip:setAlpha( 1 )
				self.clipFinished( self.AmmoClip, {} )

				self.AmmoClipDW:completeAnimation()
				self.AmmoClipDW:setAlpha( 1 )
				self.clipFinished( self.AmmoClipDW, {} )

				self.AmmoStock:completeAnimation()
				self.AmmoStock:setAlpha( 0.7 )
				self.clipFinished( self.AmmoStock, {} )
			end
		}
	}
	
	self:mergeStateConditions( {
		{
			stateName = "AmmoPulse",
			condition = function ( menu, element, event )
				return PulseNoAmmo( controller )
			end
		},
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				if not WeaponUsesAmmo( controller )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "minigun_zm" )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "cymbal_monkey_zm" )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "octobomb_zm" )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "frag_grenade_zm" )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "sticky_grenade_widows_wine_zm" )
				or ModelValueStartsWith( controller, "currentWeapon.viewmodelWeaponName", "zombie_" ) then
					return true
				else
					return false
				end
			end
		},
		{
			stateName = "WeaponDual",
			condition = function ( menu, element, event )
				if WeaponUsesAmmo( controller ) then
					return IsModelValueGreaterThanOrEqualTo( controller, "currentWeapon.ammoInDWClip", 0 )
				end
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.pulseNoAmmo" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.pulseNoAmmo"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.viewmodelWeaponName" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "currentWeapon.viewmodelWeaponName"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.ammoInDWClip" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "currentWeapon.ammoInDWClip"
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.AmmoClip:close()
		element.AmmoClipDW:close()
		element.AmmoStock:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
