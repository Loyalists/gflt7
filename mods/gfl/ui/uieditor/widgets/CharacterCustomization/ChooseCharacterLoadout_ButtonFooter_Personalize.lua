-- 058b2cf4088ba3b0d563a5338468493a
-- This hash is used for caching, delete to decompile the file again

require( "ui.uieditor.widgets.BlackMarket.BM_Contracts_Specialist_btn_bg_left" )
require( "ui.uieditor.widgets.PC.ChooseCharacter.ChooseCharacter_CardClickButton" )
require( "ui.uieditor.widgets.CAC.NewBreadcrumbCount" )

local f0_local0 = function ( f1_arg0, f1_arg1, f1_arg2 )
	f1_arg0:setForceMouseEventDispatch( true )
	f1_arg0.clickableButton.m_button = Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE
	f1_arg0.clickableButton.keyshortcut:setText( Engine.Localize( "[^3P^7]" ) )

	LUI.OverrideFunction_CallOriginalFirst( f1_arg0.clickableButton.label, "setText", function ( element, controller )
		ScaleWidgetToLabel( f1_arg0.clickableButton, element, 5 )
	end )
end

local PostLoadFunc = function ( self, controller, menu )
	if CoD.isPC then
		f0_local0( self, controller, menu )
	end
end

CoD.ChooseCharacterLoadout_ButtonFooter_Personalize = InheritFrom( LUI.UIElement )
CoD.ChooseCharacterLoadout_ButtonFooter_Personalize.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.ChooseCharacterLoadout_ButtonFooter_Personalize )
	self.id = "ChooseCharacterLoadout_ButtonFooter_Personalize"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 66 )
	self:setTopBottom( true, false, 0, 37 )
	self.anyChildUsesUpdateState = true
	
	local BMContractsSpecialistbtnbgleft = CoD.BM_Contracts_Specialist_btn_bg_left.new( menu, controller )
	BMContractsSpecialistbtnbgleft:setLeftRight( true, true, -62, 0 )
	BMContractsSpecialistbtnbgleft:setTopBottom( true, false, -7, 34 )
	BMContractsSpecialistbtnbgleft:setAlpha( 0 )
	self:addElement( BMContractsSpecialistbtnbgleft )
	self.BMContractsSpecialistbtnbgleft = BMContractsSpecialistbtnbgleft
	
	local BlackBoxBottomLeft = LUI.UIImage.new()
	BlackBoxBottomLeft:setLeftRight( true, true, -30, 0 )
	BlackBoxBottomLeft:setTopBottom( false, false, 11.88, 18.02 )
	BlackBoxBottomLeft:setRGB( 0, 0, 0 )
	BlackBoxBottomLeft:setAlpha( 0.6 )
	self:addElement( BlackBoxBottomLeft )
	self.BlackBoxBottomLeft = BlackBoxBottomLeft
	
	local BlackBoxLeft = LUI.UIImage.new()
	BlackBoxLeft:setLeftRight( true, true, -30, 0 )
	BlackBoxLeft:setTopBottom( false, false, -18.5, 8.89 )
	BlackBoxLeft:setRGB( 0, 0, 0 )
	BlackBoxLeft:setAlpha( 0.45 )
	self:addElement( BlackBoxLeft )
	self.BlackBoxLeft = BlackBoxLeft
	
	local personalizeLabel = LUI.UITightText.new()
	personalizeLabel:setLeftRight( false, false, -33.5, 32.5 )
	personalizeLabel:setTopBottom( false, false, -15.25, 4.75 )
	personalizeLabel:setText( Engine.Localize( "HEROES_PERSONALIZE" ) )
	personalizeLabel:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )

	LUI.OverrideFunction_CallOriginalFirst( personalizeLabel, "setText", function ( element, controller )
		ScaleWidgetToLabelCentered( self, element, 5 )
	end )
	self:addElement( personalizeLabel )
	self.personalizeLabel = personalizeLabel
	
	local Button1 = LUI.UIImage.new()
	Button1:setLeftRight( true, false, -27.5, -5.5 )
	Button1:setTopBottom( false, false, -16, 6.39 )
	Button1:subscribeToGlobalModel( controller, "Controller", "alt2_button_image", function ( model )
		local alt2ButtonImage = Engine.GetModelValue( model )
		if alt2ButtonImage then
			Button1:setImage( RegisterImage( alt2ButtonImage ) )
		end
	end )
	self:addElement( Button1 )
	self.Button1 = Button1
	
	local clickableButton = CoD.ChooseCharacter_CardClickButton.new( menu, controller )
	clickableButton:setLeftRight( true, false, -23.25, 65.5 )
	clickableButton:setTopBottom( true, false, 1.2, 26.2 )
	clickableButton:setAlpha( 0 )
	clickableButton.label:setText( Engine.Localize( "HEROES_PERSONALIZE" ) )
	clickableButton.keyshortcut:setText( Engine.Localize( "" ) )
	self:addElement( clickableButton )
	self.clickableButton = clickableButton
	
	local LineRight = LUI.UIImage.new()
	LineRight:setLeftRight( false, true, -12.15, 3.85 )
	LineRight:setTopBottom( false, false, -16, 5.5 )
	LineRight:setImage( RegisterImage( "uie_t7_menu_cac_buttonboxlrgstrokemr" ) )
	LineRight:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( LineRight )
	self.LineRight = LineRight
	
	local borderLines = LUI.UIImage.new()
	borderLines:setLeftRight( true, true, -62.3, 0 )
	borderLines:setTopBottom( false, false, -31.8, 26.2 )
	borderLines:setAlpha( 0.8 )
	borderLines:setImage( RegisterImage( "uie_t7_specialist_footer_btn_frame_left" ) )
	borderLines:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_nineslice_add" ) )
	borderLines:setShaderVector( 0, 0.55, 0.5, 0, 0 )
	borderLines:setupNineSliceShader( 70, 29 )
	self:addElement( borderLines )
	self.borderLines = borderLines
	
	local breadcrumbCount = CoD.NewBreadcrumbCount.new( menu, controller )
	breadcrumbCount:setLeftRight( false, true, -20.5, -2.5 )
	breadcrumbCount:setTopBottom( true, false, -12.3, 5.7 )
	breadcrumbCount:linkToElementModel( self, "breadcrumbCount", true, function ( model )
		local _breadcrumbCount = Engine.GetModelValue( model )
		if _breadcrumbCount then
			breadcrumbCount.countText:setText( Engine.Localize( _breadcrumbCount ) )
		end
	end )
	breadcrumbCount:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				return ShouldDisplayWeaponGroupBreadcrumbCount( self, controller )
			end
		}
	} )
	breadcrumbCount:linkToElementModel( breadcrumbCount, "breadcrumbCount", true, function ( model )
		menu:updateElementState( breadcrumbCount, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "breadcrumbCount"
		} )
	end )
	self:addElement( breadcrumbCount )
	self.breadcrumbCount = breadcrumbCount
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				personalizeLabel:completeAnimation()
				self.personalizeLabel:setRGB( 1, 1, 1 )
				self.personalizeLabel:setAlpha( 1 )
				self.clipFinished( personalizeLabel, {} )

				Button1:completeAnimation()
				self.Button1:setRGB( 1, 1, 1 )
				self.Button1:setAlpha( 1 )
				self.clipFinished( Button1, {} )

				clickableButton:completeAnimation()
				self.clickableButton:setRGB( 1, 1, 1 )
				self.clickableButton:setAlpha( 0 )
				self.clipFinished( clickableButton, {} )
			end
		},
		NoPersonalization_PC = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				personalizeLabel:completeAnimation()
				self.personalizeLabel:setRGB( 0.49, 0.49, 0.49 )
				self.personalizeLabel:setAlpha( 0 )
				self.clipFinished( personalizeLabel, {} )

				Button1:completeAnimation()
				self.Button1:setRGB( 0.49, 0.49, 0.49 )
				self.Button1:setAlpha( 0 )
				self.clipFinished( Button1, {} )

				clickableButton:completeAnimation()
				self.clickableButton:setRGB( 0.49, 0.49, 0.49 )
				self.clickableButton:setAlpha( 1 )
				self.clipFinished( clickableButton, {} )
			end
		},
		NoPersonalization = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				personalizeLabel:completeAnimation()
				self.personalizeLabel:setRGB( 0.28, 0.28, 0.28 )
				self.personalizeLabel:setAlpha( 1 )
				self.clipFinished( personalizeLabel, {} )

				Button1:completeAnimation()
				self.Button1:setRGB( 0.49, 0.49, 0.49 )
				self.Button1:setAlpha( 1 )
				self.clipFinished( Button1, {} )

				clickableButton:completeAnimation()
				self.clickableButton:setRGB( 0.49, 0.49, 0.49 )
				self.clickableButton:setAlpha( 0 )
				self.clipFinished( clickableButton, {} )
			end
		},
		DefaultState_PC = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				personalizeLabel:completeAnimation()
				self.personalizeLabel:setRGB( 1, 1, 1 )
				self.personalizeLabel:setAlpha( 0 )
				self.clipFinished( personalizeLabel, {} )

				Button1:completeAnimation()
				self.Button1:setRGB( 1, 1, 1 )
				self.Button1:setAlpha( 0 )
				self.clipFinished( Button1, {} )

				clickableButton:completeAnimation()
				self.clickableButton:setRGB( 1, 1, 1 )
				self.clickableButton:setAlpha( 1 )
				self.clipFinished( clickableButton, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "NoPersonalization_PC",
			condition = function ( menu, element, event )
				local f14_local0
				if not CharacterHasAnyWeaponUnlocked( controller, element ) then
					f14_local0 = not IsGamepad( controller )
				else
					f14_local0 = false
				end
				return f14_local0
			end
		},
		{
			stateName = "NoPersonalization",
			condition = function ( menu, element, event )
				return not CharacterHasAnyWeaponUnlocked( controller, element )
			end
		},
		{
			stateName = "DefaultState_PC",
			condition = function ( menu, element, event )
				return not IsGamepad( controller )
			end
		}
	} )
	self:linkToElementModel( self, "heroIndex", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "heroIndex"
		} )
	end )
	if self.m_eventHandlers.input_source_changed then
		local f4_local10 = self.m_eventHandlers.input_source_changed
		self:registerEventHandler( "input_source_changed", function ( element, event )
			event.menu = event.menu or menu
			element:updateState( event )
			return f4_local10( element, event )
		end )
	else
		self:registerEventHandler( "input_source_changed", LUI.UIElement.updateState )
	end
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "LastInput"
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.BMContractsSpecialistbtnbgleft:close()
		element.clickableButton:close()
		element.breadcrumbCount:close()
		element.Button1:close()
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
