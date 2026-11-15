-- 1e131aa3c2c36b2960ab9c7315a0d213
-- This hash is used for caching, delete to decompile the file again

require( "ui.uieditor.widgets.PC.ChooseCharacter.CharacterMiniSelectorItem" )
require( "ui.uieditor.widgets.PC.ChooseCharacter.CharacterMiniSelectorLeftButton" )
require( "ui.uieditor.widgets.PC.ChooseCharacter.CharacterMiniSelectorRightButton" )
require( "ui.uieditor.widgets.Lobby.Common.FE_TitleNumBrdr" )

DataSources.HeroesListMini_InGame = DataSourceHelpers.ListSetup( "HeroesListMini_InGame", function ( controller )
	local heroes = CoD.CharacterUtil.GetHeroesList_InGame( CoD.CCUtility.customizationMode )
	local items = {}
	for index, hero in ipairs( heroes ) do
		local heroItem = {
			models = {
				name = hero.displayName,
				disabled = hero.disabled
			}
		}
		table.insert( items, heroItem )
	end
	for index, item in ipairs( items ) do
		item.models.index = index
	end
	return items
end, true )

local resizeToCharacterGrid = function ( element )
	local width, height = element.characterGrid:getLocalSize()
	element.characterGrid:setLeftRight( false, false, -(width / 2), width / 2 )
	local halfWidth = (width + 100) / 2
	element:setLeftRight( false, false, -halfWidth, halfWidth )
end

local PostLoadFunc = function ( self, controller )
	self:setForceMouseEventDispatch( true )
	self.characterGrid:setDataSource( "HeroesListMini_InGame" )
	self:registerEventHandler( "list_active_changed", function ( element, event )
		if event.list == self.characterGrid then
			local model = event.model
			if model then
				local indexModel = Engine.GetModel( model, "index" )
				if indexModel then
					self:dispatchEventToParent( {
						name = "mini_item_selected",
						index = Engine.GetModelValue( indexModel ),
						controller = controller
					} )
				end
			end
		end
		return true
	end )
	self:registerEventHandler( "sync_mini_selector", function ( element, event )
		element.characterGrid:setActiveIndex( 1, event.index )
	end )
	self:registerEventHandler( "mini_selector_left", function ( element, event )
		SelectPreviousItemIfPossible( element, element.characterGrid, controller )
	end )
	self:registerEventHandler( "mini_selector_right", function ( element, event )
		SelectNextItemIfPossible( element, element.characterGrid, controller )
	end )
	self:registerEventHandler( "menu_opened", function ( element, event )
		resizeToCharacterGrid( element )
	end )
end

CoD.CharacterMiniSelector_InGame = InheritFrom( LUI.UIElement )
CoD.CharacterMiniSelector_InGame.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.CharacterMiniSelector_InGame )
	self.id = "CharacterMiniSelector_InGame"
	self.soundSet = "CAC_EditLoadout"
	self:setLeftRight( true, false, 0, 300 )
	self:setTopBottom( true, false, 0, 30 )
	self.anyChildUsesUpdateState = true
	
	local characterGrid = LUI.GridLayout.new( menu, controller, false, 0, 0, 4, 0, nil, nil, false, false, 0, 0, false, true )
	characterGrid:setLeftRight( false, false, -598, 598 )
	characterGrid:setTopBottom( true, true, 5, -5 )
	characterGrid:setAlpha( 0 )
	characterGrid:setWidgetType( CoD.CharacterMiniSelectorItem )
	characterGrid:setHorizontalCount( 50 )
	characterGrid:setSpacing( 4 )
	characterGrid:registerEventHandler( "mouse_left_click", function ( element, event )
		local f10_local0 = nil
		SelectItemIfPossible( self, element, controller, event )
		PlaySoundSetSound( self, "list_up" )
		if not f10_local0 then
			f10_local0 = element:dispatchEventToChildren( event )
		end
		return f10_local0
	end )
	self:addElement( characterGrid )
	self.characterGrid = characterGrid
	
	local leftButton = CoD.CharacterMiniSelectorLeftButton.new( menu, controller )
	leftButton:setLeftRight( true, false, 0, 30 )
	leftButton:setTopBottom( true, true, 0, 0 )
	self:addElement( leftButton )
	self.leftButton = leftButton
	
	local rightButton = CoD.CharacterMiniSelectorRightButton.new( menu, controller )
	rightButton:setLeftRight( false, true, -30, 0 )
	rightButton:setTopBottom( true, true, 0, 0 )
	self:addElement( rightButton )
	self.rightButton = rightButton
	
	local FETitleNumBrdr0 = CoD.FE_TitleNumBrdr.new( menu, controller )
	FETitleNumBrdr0:setLeftRight( true, true, 30, -30 )
	FETitleNumBrdr0:setTopBottom( true, true, 0, 0 )
	self:addElement( FETitleNumBrdr0 )
	self.FETitleNumBrdr0 = FETitleNumBrdr0
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				characterGrid:completeAnimation()
				self.characterGrid:setAlpha( 0 )
				self.clipFinished( characterGrid, {} )

				leftButton:completeAnimation()
				self.leftButton:setAlpha( 0 )
				self.clipFinished( leftButton, {} )

				rightButton:completeAnimation()
				self.rightButton:setAlpha( 0 )
				self.clipFinished( rightButton, {} )

				FETitleNumBrdr0:completeAnimation()
				self.FETitleNumBrdr0:setAlpha( 0 )
				self.clipFinished( FETitleNumBrdr0, {} )
			end
		},
		Visible = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				characterGrid:completeAnimation()
				self.characterGrid:setLeftRight( true, true, 44, -44 )
				self.characterGrid:setTopBottom( true, true, 5, -5 )
				self.characterGrid:setAlpha( 1 )
				self.clipFinished( characterGrid, {} )

				leftButton:completeAnimation()
				self.leftButton:setAlpha( 1 )
				self.clipFinished( leftButton, {} )

				rightButton:completeAnimation()
				self.rightButton:setAlpha( 1 )
				self.clipFinished( rightButton, {} )

				FETitleNumBrdr0:completeAnimation()
				self.FETitleNumBrdr0:setLeftRight( true, true, 30, -30 )
				self.FETitleNumBrdr0:setTopBottom( true, true, 0, 0 )
				self.clipFinished( FETitleNumBrdr0, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				return IsPC() and not IsGamepad( controller )
			end
		}
	} )
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

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.characterGrid:close()
		element.leftButton:close()
		element.rightButton:close()
		element.FETitleNumBrdr0:close()
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
