-- 60119719b1763507d1eefbe5835c2644
-- This hash is used for caching, delete to decompile the file again

require( "ui.uieditor.widgets.CharacterCustomization.ChooseCharacter_LoadoutListItem_MouseHoverIcon" )
require( "ui.uieditor.widgets.HUD.core_AmmoWidget.AmmoWidget_AbilityGlow" )
-- require( "ui.uieditor.widgets.CAC.cac_IconTokenStatic" )

local f0_local0 = function ( f1_arg0, f1_arg1 )
	f1_arg0:setHandleMouse( true )
	f1_arg0.m_forceMouseEventDispatch = true
	f1_arg0.disabledAllowNav = true
end

local PostLoadFunc = function ( self, controller, menu )
	if CoD.isPC then
		f0_local0( self, controller )
	end
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_RIGHT, nil, function ( f3_arg0, f3_arg1, f3_arg2, f3_arg3 )
		if FirstTimeSetup_ChangedCharacter( f3_arg2 ) then
			FirstTimeSetup_SetComplete( f3_arg2 )
			return false
		else
			
		end
	end )
end

CoD.ChooseCharacter_LoadoutListItem_InGame = InheritFrom( LUI.UIElement )
CoD.ChooseCharacter_LoadoutListItem_InGame.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.ChooseCharacter_LoadoutListItem_InGame )
	self.id = "ChooseCharacter_LoadoutListItem_InGame"
	self.soundSet = "none"
	self:setLeftRight( true, false, 0, 90 )
	self:setTopBottom( true, false, 0, 90 )
	self:makeFocusable()
	self:setHandleMouse( true )
	self.anyChildUsesUpdateState = true
	
	local MouseHoverIcon = CoD.ChooseCharacter_LoadoutListItem_MouseHoverIcon.new( menu, controller )
	MouseHoverIcon:setLeftRight( true, true, 0, 0 )
	MouseHoverIcon:setTopBottom( true, true, 0, 0 )
	MouseHoverIcon:setAlpha( 0 )
	self:addElement( MouseHoverIcon )
	self.MouseHoverIcon = MouseHoverIcon
	
	local OrangeGlow = LUI.UIImage.new()
	OrangeGlow:setLeftRight( true, false, 6.51, 83.49 )
	OrangeGlow:setTopBottom( true, false, 6.51, 83.49 )
	OrangeGlow:setAlpha( 0 )
	OrangeGlow:setImage( RegisterImage( "uie_img_t7_hud_mp_weapon_hero_orangering" ) )
	self:addElement( OrangeGlow )
	self.OrangeGlow = OrangeGlow
	
	local OrangeGlow0 = LUI.UIImage.new()
	OrangeGlow0:setLeftRight( true, false, -11.99, 101.99 )
	OrangeGlow0:setTopBottom( true, false, -11.99, 101.99 )
	OrangeGlow0:setAlpha( 0 )
	OrangeGlow0:setImage( RegisterImage( "uie_img_t7_hud_mp_weapon_hero_orangering" ) )
	OrangeGlow0:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( OrangeGlow0 )
	self.OrangeGlow0 = OrangeGlow0
	
	local itemOff = LUI.UIImage.new()
	itemOff:setLeftRight( true, true, 10, -10 )
	itemOff:setTopBottom( true, true, 10, -10 )
	itemOff:setAlpha( 0 )
	itemOff:linkToElementModel( self, "gameImageOff", true, function ( model )
		local gameImageOff = Engine.GetModelValue( model )
		if gameImageOff then
			itemOff:setImage( RegisterImage( gameImageOff ) )
		end
	end )
	self:addElement( itemOff )
	self.itemOff = itemOff
	
	local itemOn = LUI.UIImage.new()
	itemOn:setLeftRight( true, true, 0, 0 )
	itemOn:setTopBottom( true, true, 0, 0 )
	itemOn:setZoom( -30 )
	itemOn:linkToElementModel( self, "gameImageOn", true, function ( model )
		local gameImageOn = Engine.GetModelValue( model )
		if gameImageOn then
			itemOn:setImage( RegisterImage( gameImageOn ) )
		end
	end )
	self:addElement( itemOn )
	self.itemOn = itemOn
	
	local Glow0 = CoD.AmmoWidget_AbilityGlow.new( menu, controller )
	Glow0:setLeftRight( true, true, 4, -4 )
	Glow0:setTopBottom( true, true, 4, -4 )
	Glow0:setRGB( 1, 0.65, 0 )
	Glow0:setAlpha( 0 )
	Glow0:setZoom( 13.47 )
	Glow0:setScale( 1.2 )
	Glow0:setRFTMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( Glow0 )
	self.Glow0 = Glow0
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 5 )

				OrangeGlow:completeAnimation()
				self.OrangeGlow:setAlpha( 0 )
				self.clipFinished( OrangeGlow, {} )

				OrangeGlow0:completeAnimation()
				self.OrangeGlow0:setAlpha( 0 )
				self.clipFinished( OrangeGlow0, {} )

				itemOff:completeAnimation()
				self.itemOff:setLeftRight( true, true, 0, 0 )
				self.itemOff:setTopBottom( true, true, 0, 0 )
				self.itemOff:setAlpha( 1 )
				self.itemOff:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_normal" ) )
				self.clipFinished( itemOff, {} )

				itemOn:completeAnimation()
				self.itemOn:setLeftRight( true, true, 0, 0 )
				self.itemOn:setTopBottom( true, true, 0, 0 )
				self.itemOn:setAlpha( 0 )
				self.clipFinished( itemOn, {} )

				Glow0:completeAnimation()
				self.Glow0:setAlpha( 0 )
				self.clipFinished( Glow0, {} )
			end,
			Focus = function ()
				self:setupElementClipCounter( 4 )

				OrangeGlow:completeAnimation()
				self.OrangeGlow:setAlpha( 0 )
				self.clipFinished( OrangeGlow, {} )

				itemOff:completeAnimation()
				self.itemOff:setLeftRight( true, true, 0, 0 )
				self.itemOff:setTopBottom( true, true, 0, 0 )
				self.itemOff:setAlpha( 1 )
				self.clipFinished( itemOff, {} )
				local itemOnFrame2 = function ( itemOn, event )
					local itemOnFrame3 = function ( itemOn, event )
						if not event.interrupted then
							itemOn:beginAnimation( "keyframe", 79, true, false, CoD.TweenType.Back )
						end
						itemOn:setLeftRight( true, true, -15, 15 )
						itemOn:setTopBottom( true, true, -15, 15 )
						itemOn:setAlpha( 1 )
						itemOn:setZoom( 0 )
						if event.interrupted then
							self.clipFinished( itemOn, event )
						else
							itemOn:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						itemOnFrame3( itemOn, event )
						return 
					else
						itemOn:beginAnimation( "keyframe", 90, false, false, CoD.TweenType.Linear )
						itemOn:setLeftRight( true, true, -20.47, 20.47 )
						itemOn:setTopBottom( true, true, -20.47, 20.47 )
						itemOn:setAlpha( 1.37 )
						itemOn:registerEventHandler( "transition_complete_keyframe", itemOnFrame3 )
					end
				end
				
				itemOn:completeAnimation()
				self.itemOn:setLeftRight( true, true, 0, 0 )
				self.itemOn:setTopBottom( true, true, 0, 0 )
				self.itemOn:setAlpha( 0 )
				self.itemOn:setZoom( 0 )
				itemOnFrame2( itemOn, {} )
				local Glow0Frame2 = function ( Glow0, event )
					local Glow0Frame3 = function ( Glow0, event )
						if not event.interrupted then
							Glow0:beginAnimation( "keyframe", 210, false, false, CoD.TweenType.Linear )
						end
						Glow0:setLeftRight( true, true, 4, -4 )
						Glow0:setTopBottom( true, true, 4, -4 )
						Glow0:setAlpha( 0 )
						Glow0:setZoom( 13.47 )
						Glow0:setScale( 1.7 )
						if event.interrupted then
							self.clipFinished( Glow0, event )
						else
							Glow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						Glow0Frame3( Glow0, event )
						return 
					else
						Glow0:beginAnimation( "keyframe", 90, false, false, CoD.TweenType.Linear )
						Glow0:setAlpha( 1 )
						Glow0:registerEventHandler( "transition_complete_keyframe", Glow0Frame3 )
					end
				end
				
				Glow0:completeAnimation()
				self.Glow0:setLeftRight( true, true, 4, -4 )
				self.Glow0:setTopBottom( true, true, 4, -4 )
				self.Glow0:setAlpha( 0.13 )
				self.Glow0:setZoom( 13.47 )
				self.Glow0:setScale( 1.3 )
				Glow0Frame2( Glow0, {} )
			end
		},
		Disabled = {
			DefaultClip = function ()
				self:setupElementClipCounter( 5 )

				OrangeGlow:completeAnimation()
				self.OrangeGlow:setAlpha( 0 )
				self.clipFinished( OrangeGlow, {} )

				OrangeGlow0:completeAnimation()
				self.OrangeGlow0:setAlpha( 0 )
				self.clipFinished( OrangeGlow0, {} )

				itemOff:completeAnimation()
				self.itemOff:setLeftRight( true, true, 10, -10 )
				self.itemOff:setTopBottom( true, true, 10, -10 )
				self.itemOff:setAlpha( 1 )
				self.clipFinished( itemOff, {} )

				itemOn:completeAnimation()
				self.itemOn:setAlpha( 0 )
				self.clipFinished( itemOn, {} )

				Glow0:completeAnimation()
				self.Glow0:setAlpha( 0 )
				self.clipFinished( Glow0, {} )
			end,
			Focus = function ()
				self:setupElementClipCounter( 5 )

				local OrangeGlowFrame2 = function ( OrangeGlow, event )
					local OrangeGlowFrame3 = function ( OrangeGlow, event )
						if not event.interrupted then
							OrangeGlow:beginAnimation( "keyframe", 79, true, false, CoD.TweenType.Back )
						end
						OrangeGlow:setLeftRight( true, false, -11.99, 101.99 )
						OrangeGlow:setTopBottom( true, false, -11.99, 101.99 )
						OrangeGlow:setAlpha( 1 )
						OrangeGlow:setScale( 1 )
						if event.interrupted then
							self.clipFinished( OrangeGlow, event )
						else
							OrangeGlow:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						OrangeGlowFrame3( OrangeGlow, event )
						return 
					else
						OrangeGlow:beginAnimation( "keyframe", 90, false, false, CoD.TweenType.Linear )
						OrangeGlow:setAlpha( 1 )
						OrangeGlow:setScale( 1.15 )
						OrangeGlow:registerEventHandler( "transition_complete_keyframe", OrangeGlowFrame3 )
					end
				end
				
				OrangeGlow:completeAnimation()
				self.OrangeGlow:setLeftRight( true, false, -11.99, 101.99 )
				self.OrangeGlow:setTopBottom( true, false, -11.99, 101.99 )
				self.OrangeGlow:setAlpha( 0 )
				self.OrangeGlow:setScale( 0.6 )
				OrangeGlowFrame2( OrangeGlow, {} )
				local OrangeGlow0Frame2 = function ( OrangeGlow0, event )
					local OrangeGlow0Frame3 = function ( OrangeGlow0, event )
						if not event.interrupted then
							OrangeGlow0:beginAnimation( "keyframe", 130, false, false, CoD.TweenType.Linear )
						end
						OrangeGlow0:setLeftRight( true, false, -11.99, 101.99 )
						OrangeGlow0:setTopBottom( true, false, -11.99, 101.99 )
						OrangeGlow0:setAlpha( 0.25 )
						OrangeGlow0:setScale( 1 )
						OrangeGlow0:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
						if event.interrupted then
							self.clipFinished( OrangeGlow0, event )
						else
							OrangeGlow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						OrangeGlow0Frame3( OrangeGlow0, event )
						return 
					else
						OrangeGlow0:beginAnimation( "keyframe", 170, false, false, CoD.TweenType.Linear )
						OrangeGlow0:setAlpha( 0.1 )
						OrangeGlow0:registerEventHandler( "transition_complete_keyframe", OrangeGlow0Frame3 )
					end
				end
				
				OrangeGlow0:completeAnimation()
				self.OrangeGlow0:setLeftRight( true, false, -11.99, 101.99 )
				self.OrangeGlow0:setTopBottom( true, false, -11.99, 101.99 )
				self.OrangeGlow0:setAlpha( 0 )
				self.OrangeGlow0:setScale( 1 )
				self.OrangeGlow0:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
				OrangeGlow0Frame2( OrangeGlow0, {} )
				local itemOffFrame2 = function ( itemOff, event )
					if not event.interrupted then
						itemOff:beginAnimation( "keyframe", 170, true, false, CoD.TweenType.Back )
					end
					itemOff:setLeftRight( true, true, -15, 15 )
					itemOff:setTopBottom( true, true, -15, 15 )
					itemOff:setAlpha( 1 )
					if event.interrupted then
						self.clipFinished( itemOff, event )
					else
						itemOff:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				itemOff:completeAnimation()
				self.itemOff:setLeftRight( true, true, 10, -10 )
				self.itemOff:setTopBottom( true, true, 10, -10 )
				self.itemOff:setAlpha( 1 )
				itemOffFrame2( itemOff, {} )

				itemOn:completeAnimation()
				self.itemOn:setAlpha( 0 )
				self.clipFinished( itemOn, {} )
				local Glow0Frame2 = function ( Glow0, event )
					local Glow0Frame3 = function ( Glow0, event )
						if not event.interrupted then
							Glow0:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
						end
						Glow0:setAlpha( 0 )
						Glow0:setScale( 1.7 )
						if event.interrupted then
							self.clipFinished( Glow0, event )
						else
							Glow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						Glow0Frame3( Glow0, event )
						return 
					else
						Glow0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
						Glow0:setAlpha( 1 )
						Glow0:registerEventHandler( "transition_complete_keyframe", Glow0Frame3 )
					end
				end
				
				Glow0:completeAnimation()
				self.Glow0:setAlpha( 0 )
				self.Glow0:setScale( 1.3 )
				Glow0Frame2( Glow0, {} )
			end
		},
		NotAvailable = {
			DefaultClip = function ()
				self:setupElementClipCounter( 5 )

				OrangeGlow:completeAnimation()
				self.OrangeGlow:setAlpha( 0 )
				self.clipFinished( OrangeGlow, {} )

				OrangeGlow0:completeAnimation()
				self.OrangeGlow0:setAlpha( 0 )
				self.clipFinished( OrangeGlow0, {} )

				itemOff:completeAnimation()
				self.itemOff:setLeftRight( true, true, 10, -10 )
				self.itemOff:setTopBottom( true, true, 10, -10 )
				self.itemOff:setAlpha( 1 )
				self.clipFinished( itemOff, {} )

				itemOn:completeAnimation()
				self.itemOn:setAlpha( 0 )
				self.clipFinished( itemOn, {} )

				Glow0:completeAnimation()
				self.Glow0:setAlpha( 0 )
				self.clipFinished( Glow0, {} )
			end,
			Focus = function ()
				self:setupElementClipCounter( 5 )

				local OrangeGlowFrame2 = function ( OrangeGlow, event )
					local OrangeGlowFrame3 = function ( OrangeGlow, event )
						if not event.interrupted then
							OrangeGlow:beginAnimation( "keyframe", 79, true, false, CoD.TweenType.Back )
						end
						OrangeGlow:setLeftRight( true, false, -11.99, 101.99 )
						OrangeGlow:setTopBottom( true, false, -11.99, 101.99 )
						OrangeGlow:setAlpha( 1 )
						OrangeGlow:setScale( 1 )
						if event.interrupted then
							self.clipFinished( OrangeGlow, event )
						else
							OrangeGlow:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						OrangeGlowFrame3( OrangeGlow, event )
						return 
					else
						OrangeGlow:beginAnimation( "keyframe", 90, false, false, CoD.TweenType.Linear )
						OrangeGlow:setAlpha( 1 )
						OrangeGlow:setScale( 1.15 )
						OrangeGlow:registerEventHandler( "transition_complete_keyframe", OrangeGlowFrame3 )
					end
				end
				
				OrangeGlow:completeAnimation()
				self.OrangeGlow:setLeftRight( true, false, -11.99, 101.99 )
				self.OrangeGlow:setTopBottom( true, false, -11.99, 101.99 )
				self.OrangeGlow:setAlpha( 0 )
				self.OrangeGlow:setScale( 0.6 )
				OrangeGlowFrame2( OrangeGlow, {} )
				local OrangeGlow0Frame2 = function ( OrangeGlow0, event )
					local OrangeGlow0Frame3 = function ( OrangeGlow0, event )
						if not event.interrupted then
							OrangeGlow0:beginAnimation( "keyframe", 130, false, false, CoD.TweenType.Linear )
						end
						OrangeGlow0:setLeftRight( true, false, -11.99, 101.99 )
						OrangeGlow0:setTopBottom( true, false, -11.99, 101.99 )
						OrangeGlow0:setAlpha( 0.25 )
						OrangeGlow0:setScale( 1 )
						OrangeGlow0:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
						if event.interrupted then
							self.clipFinished( OrangeGlow0, event )
						else
							OrangeGlow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						OrangeGlow0Frame3( OrangeGlow0, event )
						return 
					else
						OrangeGlow0:beginAnimation( "keyframe", 170, false, false, CoD.TweenType.Linear )
						OrangeGlow0:setAlpha( 0.1 )
						OrangeGlow0:registerEventHandler( "transition_complete_keyframe", OrangeGlow0Frame3 )
					end
				end
				
				OrangeGlow0:completeAnimation()
				self.OrangeGlow0:setLeftRight( true, false, -11.99, 101.99 )
				self.OrangeGlow0:setTopBottom( true, false, -11.99, 101.99 )
				self.OrangeGlow0:setAlpha( 0 )
				self.OrangeGlow0:setScale( 1 )
				self.OrangeGlow0:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
				OrangeGlow0Frame2( OrangeGlow0, {} )
				local itemOffFrame2 = function ( itemOff, event )
					if not event.interrupted then
						itemOff:beginAnimation( "keyframe", 170, true, false, CoD.TweenType.Back )
					end
					itemOff:setLeftRight( true, true, -15, 15 )
					itemOff:setTopBottom( true, true, -15, 15 )
					itemOff:setAlpha( 1 )
					if event.interrupted then
						self.clipFinished( itemOff, event )
					else
						itemOff:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				itemOff:completeAnimation()
				self.itemOff:setLeftRight( true, true, 10, -10 )
				self.itemOff:setTopBottom( true, true, 10, -10 )
				self.itemOff:setAlpha( 1 )
				itemOffFrame2( itemOff, {} )

				itemOn:completeAnimation()
				self.itemOn:setAlpha( 0 )
				self.clipFinished( itemOn, {} )
				local Glow0Frame2 = function ( Glow0, event )
					local Glow0Frame3 = function ( Glow0, event )
						if not event.interrupted then
							Glow0:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
						end
						Glow0:setAlpha( 0 )
						Glow0:setScale( 1.7 )
						if event.interrupted then
							self.clipFinished( Glow0, event )
						else
							Glow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						Glow0Frame3( Glow0, event )
						return 
					else
						Glow0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
						Glow0:setAlpha( 1 )
						Glow0:registerEventHandler( "transition_complete_keyframe", Glow0Frame3 )
					end
				end
				
				Glow0:completeAnimation()
				self.Glow0:setAlpha( 0 )
				self.Glow0:setScale( 1.3 )
				Glow0Frame2( Glow0, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "Disabled",
			condition = function ( menu, element, event )
				return IsDisabled( element, controller )
			end
		},
		{
			stateName = "NotAvailable",
			condition = function ( menu, element, event )
				return IsHeroWeaponAbilityNotAvailable( element, controller )
			end
		}
	} )
	self:linkToElementModel( self, "disabled", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "disabled"
		} )
	end )
	self:linkToElementModel( self, "itemIndex", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "itemIndex"
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.MouseHoverIcon:close()
		element.Glow0:close()
		element.itemOff:close()
		element.itemOn:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
