-- 4e13d66602133af012161ace1280491f
-- This hash is used for caching, delete to decompile the file again

require( "ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame" )
require( "ui.uieditor.widgets.Lobby.Common.FE_Menu_LeftGraphics" )
require( "ui.uieditor.widgets.Pregame.Pregame_TimerOverlay" )
require( "ui.uieditor.widgets.CAC.UnlockTokensWidget" )
require( "ui.uieditor.widgets.Prestige.Prestige_PermanentUnlockTokensWidget" )
require( "ui.uieditor.widgets.CharacterCustomization.ChooseCharacter_TabBar" )
require( "ui.uieditor.menus.CharacterCustomization.PersonalizeCharacter" )
require( "ui.uieditor.widgets.CharacterCustomization.ChooseCharacterLoadoutCarouselItem" )
require( "ui.uieditor.widgets.CharacterCustomization.ChooseCharacter_HelpBubble" )
require( "ui.uieditor.widgets.Lobby.Common.FE_TalkersWidget" )
require( "ui.uieditor.widgets.PC.ChooseCharacter.CharacterMiniSelector" )

local synchronizeMiniSelector = function ( self, controller )
	local activeWidget = self.characterCarousel.activeWidget
	if activeWidget and activeWidget.carouselPos then
		self.charMiniSelector.characterGrid:setActiveIndex( 1, activeWidget.carouselPos )
	end
	self:registerEventHandler( "mini_item_selected", function ( element, event )
		local characterCarousel = element.characterCarousel
		if event.index then
			if not element.m_sync then
				element.m_sync = true
				element.characterCarousel:setActiveIndex( 1, event.index )
			else
				element.m_sync = nil
			end
		end
	end )
	self:registerEventHandler( "list_active_changed", function ( element, event )
		if event.list == self.characterCarousel then
			local activeWidget = event.list.activeWidget
			if activeWidget and activeWidget.carouselPos then
				if not self.m_sync then
					self.m_sync = true
					self.charMiniSelector:processEvent( {
						name = "sync_mini_selector",
						index = activeWidget.carouselPos,
						controller = controller
					} )
				else
					self.m_sync = nil
				end
			end
		end
		return true
	end )
	self:registerEventHandler( "list_focus_changed", function ( element, event )
		local activeWidget = element.characterCarousel.activeWidget
		if not activeWidget then
			return 
		end
		activeWidget:setHandleMouseButton( false )
		local parentElement = activeWidget:getParent()
		local firstChild = parentElement:getFirstChild()
		while firstChild do
			if firstChild ~= activeWidget then
				firstChild:setFocus( false )
				firstChild:setHandleMouseButton( true )
				if firstChild.currentState == "Flipped" then
					firstChild:setState( "DefaultState", true )
				end
			end
			firstChild = firstChild:getNextSibling()
		end
	end )
	self:processEvent( {
		name = "list_focus_changed",
		controller = controller
	} )
end

local PreLoadFunc = function ( self, controller )
	self.restoreState = function ()
		
	end
	
	CheckGCCatchUp()
end

local PostLoadFunc = function ( self, controller )
	self.characterCarousel.m_disableNavigation = true
	if CoD.isPC then
		synchronizeMiniSelector( self, controller )
	end
	CoD.perController[controller].weaponCategory = "specialist"
	CoD.CACUtility.CreateUnlockTokenModels( controller )
	CoD.PrestigeUtility.CreatePermanentUnlockTokenModel( controller )
end

LUI.createMenu.ChooseZMCharacterLoadout = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "ChooseZMCharacterLoadout" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "MP_SpecialistsAndScorestreaks"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "ChooseZMCharacterLoadout.buttonPrompts" )
	local menu = self
	self.anyChildUsesUpdateState = true
	
	local BGblack = LUI.UIImage.new()
	BGblack:setLeftRight( true, true, 1280, -1280 )
	BGblack:setTopBottom( true, true, 0, 0 )
	BGblack:setRGB( 0, 0, 0 )
	BGblack:setAlpha( 0.45 )
	self:addElement( BGblack )
	self.BGblack = BGblack
	
	local BlackBG = LUI.UIImage.new()
	BlackBG:setLeftRight( true, true, 0, 0 )
	BlackBG:setTopBottom( true, true, 0, 0 )
	BlackBG:setImage( RegisterImage( "uie_fe_cp_background" ) )
	self:addElement( BlackBG )
	self.BlackBG = BlackBG
	
	local title = Engine.Localize( "CPUI_CHOOSE_CHARACTER_CAPS" )
	local GenericMenuFrame0 = CoD.GenericMenuFrame.new( menu, controller )
	GenericMenuFrame0:setLeftRight( true, false, 0, 1280 )
	GenericMenuFrame0:setTopBottom( true, false, 0, 720 )
	GenericMenuFrame0.titleLabel:setText( title )
	GenericMenuFrame0.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText( title )
	GenericMenuFrame0.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon.FeatureIcon:setImage( RegisterImage( "uie_t7_mp_icon_header_character" ) )
	self:addElement( GenericMenuFrame0 )
	self.GenericMenuFrame0 = GenericMenuFrame0
	
	local bumperBacking = LUI.UIImage.new()
	bumperBacking:setLeftRight( false, false, -408, 408 )
	bumperBacking:setTopBottom( true, false, 104, 133 )
	bumperBacking:setRGB( 0.22, 0.22, 0.22 )
	bumperBacking:setAlpha( 0 )
	self:addElement( bumperBacking )
	self.bumperBacking = bumperBacking
	
	local Image0 = LUI.UIImage.new()
	Image0:setLeftRight( true, false, 191, 227 )
	Image0:setTopBottom( false, false, -269.75, -266.25 )
	Image0:setZRot( 180 )
	Image0:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Image0:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_add" ) )
	self:addElement( Image0 )
	self.Image0 = Image0
	
	local Image1 = LUI.UIImage.new()
	Image1:setLeftRight( true, false, 191, 227 )
	Image1:setTopBottom( false, false, -229, -226 )
	Image1:setZRot( 180 )
	Image1:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Image1:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_add" ) )
	self:addElement( Image1 )
	self.Image1 = Image1
	
	local Image4 = LUI.UIImage.new()
	Image4:setLeftRight( true, false, 191, 227 )
	Image4:setTopBottom( false, false, 277.5, 280.5 )
	Image4:setZRot( 180 )
	Image4:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Image4:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_add" ) )
	self:addElement( Image4 )
	self.Image4 = Image4
	
	local Image5 = LUI.UIImage.new()
	Image5:setLeftRight( true, false, 1053, 1089 )
	Image5:setTopBottom( false, false, 278, 281.5 )
	Image5:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Image5:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_add" ) )
	self:addElement( Image5 )
	self.Image5 = Image5
	
	local FEMenuLeftGraphics = CoD.FE_Menu_LeftGraphics.new( menu, controller )
	FEMenuLeftGraphics:setLeftRight( true, false, 19, 71 )
	FEMenuLeftGraphics:setTopBottom( true, false, 86, 703.25 )
	self:addElement( FEMenuLeftGraphics )
	self.FEMenuLeftGraphics = FEMenuLeftGraphics
	
	local CategoryListLine = LUI.UIImage.new()
	CategoryListLine:setLeftRight( true, false, -11, 1293 )
	CategoryListLine:setTopBottom( true, false, 80, 88 )
	CategoryListLine:setRGB( 0.9, 0.9, 0.9 )
	CategoryListLine:setImage( RegisterImage( "uie_t7_menu_cac_tabline" ) )
	self:addElement( CategoryListLine )
	self.CategoryListLine = CategoryListLine
	
	local PregameTimerOverlay = CoD.Pregame_TimerOverlay.new( menu, controller )
	PregameTimerOverlay:setLeftRight( true, true, 0, 0 )
	PregameTimerOverlay:setTopBottom( true, true, 0, 0 )
	PregameTimerOverlay:mergeStateConditions( {
		{
			stateName = "CharacterSelect",
			condition = function ( menu, element, event )
				return AlwaysTrue()
			end
		}
	} )
	PregameTimerOverlay:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.Pregame.state" ), function ( model )
		menu:updateElementState( PregameTimerOverlay, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.Pregame.state"
		} )
	end )
	self:addElement( PregameTimerOverlay )
	self.PregameTimerOverlay = PregameTimerOverlay
	
	local Image00 = LUI.UIImage.new()
	Image00:setLeftRight( true, false, 1056, 1092 )
	Image00:setTopBottom( false, false, -269.75, -266.25 )
	Image00:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Image00:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_add" ) )
	self:addElement( Image00 )
	self.Image00 = Image00
	
	local Image10 = LUI.UIImage.new()
	Image10:setLeftRight( true, false, 1056, 1092 )
	Image10:setTopBottom( false, false, -229, -226 )
	Image10:setImage( RegisterImage( "uie_t7_menu_frontend_pixelist" ) )
	Image10:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_add" ) )
	self:addElement( Image10 )
	self.Image10 = Image10
	
	local UnlockTokensWidget = CoD.UnlockTokensWidget.new( menu, controller )
	UnlockTokensWidget:setLeftRight( false, true, -362, -123 )
	UnlockTokensWidget:setTopBottom( true, false, 36, 80 )
	UnlockTokensWidget:setAlpha( HideIfInPermanentUnlockMenu( 1 ) )
	UnlockTokensWidget.tokenLabel:setTTF( "fonts/escom.ttf" )
	self:addElement( UnlockTokensWidget )
	self.UnlockTokensWidget = UnlockTokensWidget
	
	local PermanentUnlockTokensWidget = CoD.Prestige_PermanentUnlockTokensWidget.new( menu, controller )
	PermanentUnlockTokensWidget:setLeftRight( false, true, -362, -81 )
	PermanentUnlockTokensWidget:setTopBottom( true, false, 36, 80 )
	PermanentUnlockTokensWidget:setAlpha( ShowIfInPermanentUnlockMenu( 0 ) )
	PermanentUnlockTokensWidget.tokenLabel:setTTF( "fonts/escom.ttf" )
	self:addElement( PermanentUnlockTokensWidget )
	self.PermanentUnlockTokensWidget = PermanentUnlockTokensWidget
	
	local ChooseCharacterTabBar = CoD.ChooseCharacter_TabBar.new( menu, controller )
	ChooseCharacterTabBar:setLeftRight( true, false, 232, 1048 )
	ChooseCharacterTabBar:setTopBottom( true, false, 91.25, 134.5 )
	self:addElement( ChooseCharacterTabBar )
	self.ChooseCharacterTabBar = ChooseCharacterTabBar
	
	local characterCarousel = LUI.UIList.new( menu, controller, 4, 200, nil, false, true, 232, 0, false, false )
	characterCarousel:makeFocusable()
	characterCarousel:setLeftRight( true, true, 0, 0 )
	characterCarousel:setTopBottom( true, false, 136.75, 636.75 )
	characterCarousel:setWidgetType( CoD.ChooseCharacterLoadoutCarouselItem )
	characterCarousel:setHorizontalCount( 7 )
	characterCarousel:setSpacing( 4 )
	characterCarousel:setDataSource( "HeroesList" )
	characterCarousel:linkToElementModel( characterCarousel, "disabled", true, function ( model )
		local element = characterCarousel
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "disabled"
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE )
	end )
	characterCarousel:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.Pregame.state" ), function ( model )
		local element = characterCarousel
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.Pregame.state"
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE )
	end )
	characterCarousel:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "firstTimeFlowState" ), function ( model )
		local element = characterCarousel
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "firstTimeFlowState"
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE )
	end )
	characterCarousel:linkToElementModel( characterCarousel, "heroIndex", true, function ( model )
		local element = characterCarousel
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "heroIndex"
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
	end )
	characterCarousel:linkToElementModel( characterCarousel, nil, true, function ( model )
		local element = characterCarousel
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = nil
		}
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
	end )
	characterCarousel:registerEventHandler( "list_item_gain_focus", function ( element, event )
		local handlerResult = nil
		UpdateEditingHero( element, controller )
		UpdateElementState( self, "leftBumper", controller )
		UpdateElementState( self, "rightBumper", controller )
		PlaySoundSetSound( self, "navigate" )
		SetSpecialistAsOld( self, element, controller )
		return handlerResult
	end )
	characterCarousel:registerEventHandler( "gain_focus", function ( element, event )
		local focusResult = nil
		if element.gainFocus then
			focusResult = element:gainFocus( event )
		elseif element.super.gainFocus then
			focusResult = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_RB )
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_LB )
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE )
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE )
		return focusResult
	end )
	characterCarousel:registerEventHandler( "lose_focus", function ( element, event )
		local focusResult = nil
		if element.loseFocus then
			focusResult = element:loseFocus( event )
		elseif element.super.loseFocus then
			focusResult = element.super:loseFocus( event )
		end
		return focusResult
	end )
	menu:AddButtonCallbackFunction( characterCarousel, controller, Enum.LUIButton.LUI_KEY_RB, nil, function ( element, menu, controller, event )
		if not IsRepeatButtonPress( event ) then
			NavigateToNextHeroCard( menu, self, element, controller )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if not IsRepeatButtonPress( nil ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_RB, "" )
			return false
		else
			return false
		end
	end, false )
	menu:AddButtonCallbackFunction( characterCarousel, controller, Enum.LUIButton.LUI_KEY_LB, nil, function ( element, menu, controller, event )
		if not IsRepeatButtonPress( event ) then
			NavigateToPreviousHeroCard( menu, self, element, controller )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if not IsRepeatButtonPress( nil ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_LB, "" )
			return false
		else
			return false
		end
	end, false )
	menu:AddButtonCallbackFunction( characterCarousel, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "P", function ( element, menu, controller, event )
		if not IsDisabled( element, controller ) and not PregameActive() and CharacterCustomization_IsEnabled( controller ) and IsElementInState( element, "DefaultState" ) then
			NavigateToMenu( self, "PersonalizeCharacter", true, controller )
			return true
		elseif not IsDisabled( element, controller ) and not PregameActive() and IsElementInState( element, "DefaultState" ) then
			SetElementState( self, element, controller, "Challenges" )
			UpdateAllMenuButtonPrompts( menu, controller )
			PlaySoundSetSound( self, "navigate" )
			return true
		elseif not IsDisabled( element, controller ) and not PregameActive() and IsElementInState( element, "Challenges" ) then
			SetElementState( self, element, controller, "DefaultState" )
			UpdateAllMenuButtonPrompts( menu, controller )
			PlaySoundAlias( "uin_paint_decal_nav" )
			return true
		else
			
		end

	end, function ( element, menu, controller )
		if not IsDisabled( element, controller ) and not PregameActive() and CharacterCustomization_IsEnabled( controller ) and IsElementInState( element, "DefaultState" ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "" )
			return false
		elseif not IsDisabled( element, controller ) and not PregameActive() and IsElementInState( element, "DefaultState" ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "" )
			return false
		elseif not IsDisabled( element, controller ) and not PregameActive() and IsElementInState( element, "Challenges" ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "" )
			return false
		else
			return false
		end
	end, false )
	menu:AddButtonCallbackFunction( characterCarousel, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "C", function ( element, menu, controller, event )
		if IsElementInState( element, "DefaultState" ) and not IsDisabled( element, controller ) and not IsInPermanentUnlockMenu( controller ) then
			SetElementState( self, element, controller, "Flipped" )
			UpdateAllMenuButtonPrompts( menu, controller )
			return true
		elseif IsElementInState( element, "Flipped" ) and not IsDisabled( element, controller ) and not IsInPermanentUnlockMenu( controller ) then
			SetElementState( self, element, controller, "DefaultState" )
			UpdateAllMenuButtonPrompts( menu, controller )
			PlaySoundAlias( "uin_paint_decal_nav" )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if IsElementInState( element, "DefaultState" ) and not IsDisabled( element, controller ) and not IsInPermanentUnlockMenu( controller ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "" )
			return false
		elseif IsElementInState( element, "Flipped" ) and not IsDisabled( element, controller ) and not IsInPermanentUnlockMenu( controller ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "" )
			return false
		else
			return false
		end
	end, false )
	menu:AddButtonCallbackFunction( characterCarousel, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, event )
		if IsElementInAnyState( element, "Flipped", "Challenges" ) then
			SetElementState( self, element, controller, "DefaultState" )
			UpdateAllMenuButtonPrompts( menu, controller )
			PlaySoundAlias( "uin_paint_decal_nav" )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if IsElementInAnyState( element, "Flipped", "Challenges" ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )
			return true
		else
			return false
		end
	end, false )
	self:addElement( characterCarousel )
	self.characterCarousel = characterCarousel
	
	local ChooseCharacterHelpBubble = CoD.ChooseCharacter_HelpBubble.new( menu, controller )
	ChooseCharacterHelpBubble:setLeftRight( true, false, 64, 241 )
	ChooseCharacterHelpBubble:setTopBottom( true, false, 93.75, 633.5 )
	self:addElement( ChooseCharacterHelpBubble )
	self.ChooseCharacterHelpBubble = ChooseCharacterHelpBubble
	
	local FETalkersWidget = CoD.FE_TalkersWidget.new( menu, controller )
	FETalkersWidget:setLeftRight( false, true, -254, -64 )
	FETalkersWidget:setTopBottom( true, false, 88, 475 )
	self:addElement( FETalkersWidget )
	self.FETalkersWidget = FETalkersWidget
	
	local element = nil
	if IsPC() then
		element = CoD.CharacterMiniSelector.new( menu, controller )
	else
		element = LUI.UIElement.createFake()
	end
	element:setLeftRight( true, false, 491, 791 )
	element:setTopBottom( true, false, 641.5, 671.5 )
	if IsPC() then
		self:addElement( element )
	end
	self.charMiniSelector = element
	ChooseCharacterTabBar:linkToElementModel( characterCarousel, nil, false, function ( model )
		ChooseCharacterTabBar:setModel( model, controller )
	end )
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )
				local characterCarouselFrame2 = function ( characterCarousel, event )
					local characterCarouselFrame3 = function ( characterCarousel, event )
						if not event.interrupted then
							characterCarousel:beginAnimation( "keyframe", 290, false, false, CoD.TweenType.Linear )
						end
						characterCarousel:setAlpha( 1 )
						if event.interrupted then
							self.clipFinished( characterCarousel, event )
						else
							characterCarousel:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						characterCarouselFrame3( characterCarousel, event )
						return 
					else
						characterCarousel:beginAnimation( "keyframe", 209, false, false, CoD.TweenType.Linear )
						characterCarousel:registerEventHandler( "transition_complete_keyframe", characterCarouselFrame3 )
					end
				end
				
				characterCarousel:completeAnimation()
				self.characterCarousel:setAlpha( 0 )
				characterCarouselFrame2( characterCarousel, {} )
			end
		}
	}
	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.Pregame.state" ), function ( model )
		local menu2 = self
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.Pregame.state"
		}
		CoD.Menu.UpdateButtonShownState( menu2, menu, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "firstTimeFlowState" ), function ( model )
		local menu2 = self
		local event = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "firstTimeFlowState"
		}
		CoD.Menu.UpdateButtonShownState( menu2, menu, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE )
	end )
	self:registerEventHandler( "menu_opened", function ( element, event )
		local f35_local0 = nil
		if not f35_local0 then
			f35_local0 = element:dispatchEventToChildren( event )
		end
		return f35_local0
	end )
	self:registerEventHandler( "menu_loaded", function ( element, event )
		local f36_local0 = nil
		SetCharacterModeToSessionMode( self, element, controller, Enum.eModes.MODE_ZOMBIES )
		RefreshCharacterCustomization( self, element, controller )
		SendClientScriptMenuChangeNotify( controller, menu, true )
		ShowHeaderKickerAndIcon( menu )
		SetElementStateByElementName( self, "GenericMenuFrame0", controller, "Update" )
		PlayClipOnElement( self, {
			elementName = "cac3dTitleIntermediary0",
			clipName = "Intro"
		}, controller )
		PlayClip( self, "intro", controller )
		SetHeadingKickerTextToGameMode( "" )
		if not f36_local0 then
			f36_local0 = element:dispatchEventToChildren( event )
		end
		return f36_local0
	end )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, event )
		ClearSavedHeroForEdits( controller )
		ClearSavedState( self, controller )
		PlaySoundSetSound( self, "menu_go_back" )
		SendClientScriptMenuChangeNotify( controller, menu, false )
		SetPerControllerTableProperty( controller, "updateNewBreadcrumbs", true )
		GoBack( self, controller )
		ForceLobbyButtonUpdate( controller )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )
		return true
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, event )
		if AlwaysFalse() then
			return true
		else
			
		end
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		if AlwaysFalse() then
			return true
		else
			return false
		end
	end, true )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_LTRIG, "U", function ( element, menu, controller, event )
		if IsStarterPack( controller ) then
			StarterParckPurchase( self, controller, menu )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if IsStarterPack( controller ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_LTRIG, "PLATFORM_STARTER_PACK_UPGRADE_TITLE" )
			return true
		else
			return false
		end
	end, false )
	GenericMenuFrame0:setModel( self.buttonModel, controller )
	characterCarousel.id = "characterCarousel"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = menu
	} )
	if not self:restoreState() then
		self.characterCarousel:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.GenericMenuFrame0:close()
		element.FEMenuLeftGraphics:close()
		element.PregameTimerOverlay:close()
		element.UnlockTokensWidget:close()
		element.PermanentUnlockTokensWidget:close()
		element.ChooseCharacterTabBar:close()
		element.characterCarousel:close()
		element.ChooseCharacterHelpBubble:close()
		element.FETalkersWidget:close()
		element.charMiniSelector:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "ChooseZMCharacterLoadout.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

