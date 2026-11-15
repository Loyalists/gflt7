-- c1b4680d4681496f1eb005814a62442f
-- This hash is used for caching, delete to decompile the file again

require( "ui.uieditor.widgets.CAC.MenuSelectScreen.WeaponNameWidget" )
require( "ui.uieditor.widgets.Lobby.Common.FE_TitleNumBrdr" )
require( "ui.uieditor.widgets.CharacterCustomization.ChooseCharacterLoadoutCarouselItem_InfoAreaWeapon" )
require( "ui.uieditor.widgets.CharacterCustomization.ChooseCharacter_LoadoutListItem_InGame" )

local f0_local0 = function ( self, controller )
end

local PreLoadFunc = function ( self, controller )
	local isFirstTimeSetup = IsFirstTimeSetup( controller, Enum.eModes.MODE_MULTIPLAYER )
	local firstTimeFlowState = Engine.GetModelValue( Engine.CreateModel( Engine.GetModelForController( controller ), "firstTimeFlowState" ) )
	if firstTimeFlowState == nil or firstTimeFlowState == CoD.CCUtility.FirstTimeFlowState.None then
		if isFirstTimeSetup and not CharacterDraftActive() then
			FirstTimeSetup_SetOverview( controller )
		else
			FirstTimeSetup_SetNone( controller )
		end
	end
end

local PostLoadFunc = function ( self, controller )
	if CoD.isPC then
		f0_local0( self, controller )
	end
	if FirstTimeSetup_Overview( controller ) then
		self.loadoutOptions:makeNotFocusable()
		self.loadoutOptions:processEvent( {
			name = "lose_focus",
			controller = controller
		} )
		self:subscribeToModel( Engine.CreateModel( Engine.GetModelForController( controller ), "firstTimeFlowState" ), function ( model )
			if FirstTimeSetup_Overview( controller ) == false then
				self.loadoutOptions:makeFocusable()
				self.loadoutOptions:processEvent( {
					name = "gain_focus",
					controller = controller
				} )
			end
		end )
	end
end

CoD.ChooseCharacterLoadoutCarouselItem_InfoArea_InGame = InheritFrom( LUI.UIElement )
CoD.ChooseCharacterLoadoutCarouselItem_InfoArea_InGame.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.ChooseCharacterLoadoutCarouselItem_InfoArea_InGame )
	self.id = "ChooseCharacterLoadoutCarouselItem_InfoArea_InGame"
	self.soundSet = "none"
	self:setLeftRight( true, false, 0, 300 )
	self:setTopBottom( true, false, 0, 500 )
	self:makeFocusable()
	self.onlyChildrenFocusable = true
	self.anyChildUsesUpdateState = true
	
	local TempBackground = LUI.UIImage.new()
	TempBackground:setLeftRight( true, false, 10, 245 )
	TempBackground:setTopBottom( true, true, 11, -6 )
	TempBackground:setRGB( 0, 0, 0 )
	TempBackground:setAlpha( 0.6 )
	self:addElement( TempBackground )
	self.TempBackground = TempBackground
	
	local callsignLabel = LUI.UITightText.new()
	callsignLabel:setLeftRight( true, false, 35, 109 )
	callsignLabel:setTopBottom( true, false, 36, 56 )
	callsignLabel:setText( LocalizeToUpperString( "HEROES_CALLSIGN" ) )
	callsignLabel:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	self:addElement( callsignLabel )
	self.callsignLabel = callsignLabel
	
	local loadoutItemDescription = LUI.UIText.new()
	loadoutItemDescription:setLeftRight( true, false, 34, 224 )
	loadoutItemDescription:setTopBottom( true, false, 320.5, 339.5 )
	loadoutItemDescription:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	loadoutItemDescription:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	loadoutItemDescription:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	self:addElement( loadoutItemDescription )
	self.loadoutItemDescription = loadoutItemDescription
	
	local WeaponNameWidget0 = CoD.WeaponNameWidget.new( menu, controller )
	WeaponNameWidget0:setLeftRight( true, false, 34, 230 )
	WeaponNameWidget0:setTopBottom( true, false, 60, 94 )
	WeaponNameWidget0:linkToElementModel( self, "name", true, function ( model )
		local name = Engine.GetModelValue( model )
		if name then
			WeaponNameWidget0.weaponNameLabel:setText( Engine.Localize( name ) )
		end
	end )
	self:addElement( WeaponNameWidget0 )
	self.WeaponNameWidget0 = WeaponNameWidget0
	
	local FETitleNumBrdr1 = CoD.FE_TitleNumBrdr.new( menu, controller )
	FETitleNumBrdr1:setLeftRight( true, true, 10, -55 )
	FETitleNumBrdr1:setTopBottom( false, false, -239, 244 )
	self:addElement( FETitleNumBrdr1 )
	self.FETitleNumBrdr1 = FETitleNumBrdr1
	
	local LeftBoxLine = LUI.UIImage.new()
	LeftBoxLine:setLeftRight( true, true, 19, -67 )
	LeftBoxLine:setTopBottom( true, false, 168, 172 )
	LeftBoxLine:setImage( RegisterImage( "uie_t7_menu_frontend_titlenumbrdrum" ) )
	LeftBoxLine:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( LeftBoxLine )
	self.LeftBoxLine = LeftBoxLine

	local ChooseCharacterLoadoutCarouselItemInfoAreaWeapon = CoD.ChooseCharacterLoadoutCarouselItem_InfoAreaWeapon.new( menu, controller )
	ChooseCharacterLoadoutCarouselItemInfoAreaWeapon:setLeftRight( true, false, 33.69, 216.69 )
	ChooseCharacterLoadoutCarouselItemInfoAreaWeapon:setTopBottom( true, false, 292, 317.5 )
	self:addElement( ChooseCharacterLoadoutCarouselItemInfoAreaWeapon )
	self.ChooseCharacterLoadoutCarouselItemInfoAreaWeapon = ChooseCharacterLoadoutCarouselItemInfoAreaWeapon
	
	local loadoutOptions = LUI.UIList.new( menu, controller, 10, 0, nil, false, false, 0, 0, false, false )
	loadoutOptions:makeFocusable()
	loadoutOptions:setLeftRight( true, false, 29, 219 )
	loadoutOptions:setTopBottom( true, false, 186.5, 276.5 )
	loadoutOptions:setWidgetType( CoD.ChooseCharacter_LoadoutListItem_InGame )
	loadoutOptions:setHorizontalCount( 2 )
	loadoutOptions:setSpacing( 10 )
	loadoutOptions:linkToElementModel( self, "loadoutDatasource", true, function ( model )
		local loadoutDatasource = Engine.GetModelValue( model )
		if loadoutDatasource then
			loadoutOptions:setDataSource( loadoutDatasource )
		end
	end )
	loadoutOptions:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "firstTimeFlowState" ), function ( model )
		local element = loadoutOptions
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "firstTimeFlowState"
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	loadoutOptions:registerEventHandler( "input_source_changed", function ( element, event )
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	loadoutOptions:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		local element = loadoutOptions
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "LastInput"
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	loadoutOptions:linkToElementModel( loadoutOptions, "disabled", true, function ( model )
		local element = loadoutOptions
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "disabled"
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	loadoutOptions:linkToElementModel( loadoutOptions, "itemIndex", true, function ( model )
		local element = loadoutOptions
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "itemIndex"
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	loadoutOptions:linkToElementModel( loadoutOptions, nil, true, function ( model )
		local element = loadoutOptions
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = nil
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	loadoutOptions:registerEventHandler( "gain_focus", function ( element, event )
		local focusResult = nil
		if element.gainFocus then
			focusResult = element:gainFocus( event )
		elseif element.super.gainFocus then
			focusResult = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return focusResult
	end )
	loadoutOptions:registerEventHandler( "lose_focus", function ( element, event )
		local focusResult = nil
		if element.loseFocus then
			focusResult = element:loseFocus( event )
		elseif element.super.loseFocus then
			focusResult = element.super:loseFocus( event )
		end
		return focusResult
	end )
	menu:AddButtonCallbackFunction( loadoutOptions, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, model )
		-- SelectHero( self, element, controller )
		-- HeroLoadoutChanged( self, element, controller )
		-- CharacterDraftLoadoutSelected( self, element, controller )
		-- SendClientScriptMenuChangeNotify( controller, menu, false )
		-- SetPerControllerTableProperty( controller, "updateNewBreadcrumbs", true )
		-- ForceLobbyButtonUpdate( controller )
		CoD.CharacterUtil.SelectHero_InGame(element, controller)
		GoBack( self, controller )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( loadoutOptions )
	self.loadoutOptions = loadoutOptions
	
	loadoutItemDescription:linkToElementModel( loadoutOptions, "description", true, function ( model )
		local description = Engine.GetModelValue( model )
		if description then
			loadoutItemDescription:setText( Engine.Localize( description ) )
		end
	end )
	ChooseCharacterLoadoutCarouselItemInfoAreaWeapon:linkToElementModel( loadoutOptions, "name", true, function ( model )
		local name = Engine.GetModelValue( model )
		if name then
			ChooseCharacterLoadoutCarouselItemInfoAreaWeapon.loadOutItemName:setText( LocalizeToUpperString( name ) )
		end
	end )
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				loadoutItemDescription:completeAnimation()
				self.loadoutItemDescription:setAlpha( 1 )
				self.clipFinished( loadoutItemDescription, {} )

				ChooseCharacterLoadoutCarouselItemInfoAreaWeapon:completeAnimation()
				self.ChooseCharacterLoadoutCarouselItemInfoAreaWeapon:setAlpha( 1 )
				self.clipFinished( ChooseCharacterLoadoutCarouselItemInfoAreaWeapon, {} )

				loadoutOptions:completeAnimation()
				self.loadoutOptions:setAlpha( 1 )
				self.clipFinished( loadoutOptions, {} )
			end
		}
	}

	self:linkToElementModel( self, "disabled", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "disabled"
		} )
	end )
	if self.m_eventHandlers.input_source_changed then
		local input_source_changed = self.m_eventHandlers.input_source_changed
		self:registerEventHandler( "input_source_changed", function ( element, event )
			event.menu = event.menu or menu
			element:updateState( event )
			return input_source_changed( element, event )
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
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "firstTimeFlowState" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "firstTimeFlowState"
		} )
	end )
	loadoutOptions.id = "loadoutOptions"
	self:registerEventHandler( "gain_focus", function ( element, event )
		if element.m_focusable and element.loadoutOptions:processEvent( event ) then
			return true
		else
			return LUI.UIElement.gainFocus( element, event )
		end
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.WeaponNameWidget0:close()
		element.FETitleNumBrdr1:close()
		element.ChooseCharacterLoadoutCarouselItemInfoAreaWeapon:close()
		element.loadoutOptions:close()
		element.loadoutItemDescription:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
