-- 52e010f12ad5764d682c20a22d261661
-- This hash is used for caching, delete to decompile the file again

require( "ui.uieditor.widgets.CharacterCustomization.ChooseCharacterLoadoutCarouselItem_Internal_InGame" )
require( "ui.uieditor.widgets.Lobby.Common.FE_FocusBarContainer" )

local f0_local0 = function ( f1_arg0, f1_arg1 )
	f1_arg0.m_preventFromBeingCurrentMouseFocus = true
	f1_arg0.disabledAllowNav = true
end

local PostLoadFunc = function ( f2_arg0, f2_arg1 )
	local f2_local0, f2_local1 = f2_arg0:getLocalSize()
	f2_arg0.getWidthInList = function ()
		if f2_arg0.gridInfoTable then
			if f2_arg0.gridInfoTable.parentGrid.activeWidget == f2_arg0 then
				return f2_local0
			else
				return 90
			end
		else
			
		end
	end
	
	if CoD.isPC then
		f0_local0( f2_arg0, f2_arg1 )
	end
end

CoD.ChooseCharacterLoadoutCarouselItem_InGame = InheritFrom( LUI.UIElement )
CoD.ChooseCharacterLoadoutCarouselItem_InGame.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.ChooseCharacterLoadoutCarouselItem_InGame )
	self.id = "ChooseCharacterLoadoutCarouselItem_InGame"
	self.soundSet = "none"
	self:setLeftRight( true, false, 0, 816 )
	self:setTopBottom( true, false, 0, 500 )
	self:makeFocusable()
	self:setHandleMouse( true )
	self.anyChildUsesUpdateState = true
	
	local item = CoD.ChooseCharacterLoadoutCarouselItem_Internal_InGame.new( menu, controller )
	item:setLeftRight( true, true, 0, 0 )
	item:setTopBottom( true, true, 30, -30 )
	item.heroNumber:setAlpha( 0 )
	item.border:setRGB( 0.29, 0.29, 0.29 )
	item.infoArea:setAlpha( 0 )
	item:linkToElementModel( self, nil, false, function ( model )
		item:setModel( model, controller )
	end )
	item:registerEventHandler( "list_item_gain_focus", function ( element, event )
		local f6_local0 = nil
		-- HeroLoadoutPreviewChange( element, controller )
		-- SetSpecialistAsOld( self, element, controller )
		return f6_local0
	end )
	self:addElement( item )
	self.item = item
	
	local FocusBarB0 = CoD.FE_FocusBarContainer.new( menu, controller )
	FocusBarB0:setLeftRight( false, false, -44.5, 44.5 )
	FocusBarB0:setTopBottom( false, false, 70, 74 )
	FocusBarB0:setAlpha( 0 )
	FocusBarB0:setZoom( 1 )
	self:addElement( FocusBarB0 )
	self.FocusBarB0 = FocusBarB0
	
	local FocusBarB00 = CoD.FE_FocusBarContainer.new( menu, controller )
	FocusBarB00:setLeftRight( false, false, -45.5, 45.5 )
	FocusBarB00:setTopBottom( false, false, -210, -214 )
	FocusBarB00:setAlpha( 0 )
	FocusBarB00:setZRot( -180 )
	FocusBarB00:setZoom( 1 )
	self:addElement( FocusBarB00 )
	self.FocusBarB00 = FocusBarB00
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				item:completeAnimation()

				item.lockedCharacterWithBackground:completeAnimation()

				item.lockedSliverRender:completeAnimation()

				item.characterWithBackground:completeAnimation()

				item.unlockSliverRender:completeAnimation()

				item.heroNumber:completeAnimation()

				item.border:completeAnimation()

				item.infoArea:completeAnimation()

				item.FETitleNumBrdr0:completeAnimation()

				item.newIcon:completeAnimation()

				self.item:setLeftRight( true, true, 0, 0 )
				self.item:setTopBottom( true, true, 30, -30 )
				self.item:setAlpha( 1 )
				self.item:setYRot( 0 )
				self.item.lockedCharacterWithBackground:setAlpha( 0 )
				self.item.lockedSliverRender:setAlpha( 0 )
				self.item.characterWithBackground:setAlpha( 0 )
				self.item.unlockSliverRender:setAlpha( 1 )
				self.item.heroNumber:setAlpha( 0 )
				self.item.border:setRGB( 0.29, 0.29, 0.29 )
				self.item.infoArea:setAlpha( 0 )
				self.item.FETitleNumBrdr0:setAlpha( 0 )
				self.item.newIcon:setAlpha( 1 )
				self.clipFinished( item, {} )

				FocusBarB0:completeAnimation()
				self.FocusBarB0:setAlpha( 0 )
				self.clipFinished( FocusBarB0, {} )

				FocusBarB00:completeAnimation()
				self.FocusBarB00:setAlpha( 0 )
				self.clipFinished( FocusBarB00, {} )
			end,
			Focus = function ()
				self:setupElementClipCounter( 3 )

				item:completeAnimation()

				item.lockedCharacterWithBackground:completeAnimation()

				item.lockedSliverRender:completeAnimation()

				item.characterWithBackground:completeAnimation()

				item.unlockSliverRender:completeAnimation()

				item.heroNumber:completeAnimation()

				item.border:completeAnimation()

				item.infoArea:completeAnimation()

				item.FETitleNumBrdr0:completeAnimation()

				item.newIcon:completeAnimation()

				self.item:setLeftRight( true, true, 0, 0 )
				self.item:setTopBottom( true, true, 0, 0 )
				self.item:setAlpha( 1 )
				self.item.lockedCharacterWithBackground:setAlpha( 0 )
				self.item.lockedSliverRender:setAlpha( 0 )
				self.item.characterWithBackground:setAlpha( 1 )
				self.item.unlockSliverRender:setAlpha( 0 )
				self.item.heroNumber:setAlpha( 1 )
				self.item.border:setRGB( 1, 0.41, 0 )
				self.item.infoArea:setAlpha( 1 )
				self.item.FETitleNumBrdr0:setAlpha( 0 )
				self.item.newIcon:setAlpha( 0 )
				self.clipFinished( item, {} )

				FocusBarB0:completeAnimation()
				self.FocusBarB0:setAlpha( 0 )
				self.clipFinished( FocusBarB0, {} )

				FocusBarB00:completeAnimation()
				self.FocusBarB00:setAlpha( 0 )
				self.clipFinished( FocusBarB00, {} )
			end,
			Over = function ()
				self:setupElementClipCounter( 3 )

				item:completeAnimation()

				item.lockedCharacterWithBackground:completeAnimation()

				item.lockedSliverRender:completeAnimation()

				item.characterWithBackground:completeAnimation()

				item.unlockSliverRender:completeAnimation()

				item.heroNumber:completeAnimation()

				item.border:completeAnimation()

				item.infoArea:completeAnimation()

				item.FETitleNumBrdr0:completeAnimation()

				item.newIcon:completeAnimation()
				self.item:setLeftRight( true, true, 0, 0 )
				self.item:setTopBottom( true, true, 30, -30 )
				self.item.lockedCharacterWithBackground:setAlpha( 0 )
				self.item.lockedSliverRender:setAlpha( 0 )
				self.item.characterWithBackground:setAlpha( 0 )
				self.item.unlockSliverRender:setAlpha( 1 )
				self.item.heroNumber:setAlpha( 0 )
				self.item.border:setRGB( 0.29, 0.29, 0.29 )
				self.item.infoArea:setAlpha( 0 )
				self.item.FETitleNumBrdr0:setAlpha( 0 )
				self.item.newIcon:setAlpha( 0.9 )
				self.clipFinished( item, {} )

				FocusBarB0:completeAnimation()
				self.FocusBarB0:setLeftRight( false, false, -45.5, 45.5 )
				self.FocusBarB0:setTopBottom( false, false, 221, 217 )
				self.FocusBarB0:setAlpha( 1 )
				self.FocusBarB0:setScale( 1 )
				self.clipFinished( FocusBarB0, {} )

				FocusBarB00:completeAnimation()
				self.FocusBarB00:setLeftRight( false, false, -45.5, 45.5 )
				self.FocusBarB00:setTopBottom( false, false, -217, -221 )
				self.FocusBarB00:setAlpha( 1 )
				self.FocusBarB00:setZRot( -180 )
				self.FocusBarB00:setScale( 1 )
				self.clipFinished( FocusBarB00, {} )
			end
		}
	}

	CoD.Menu.AddNavigationHandler( menu, self, controller )

	LUI.OverrideFunction_CallOriginalFirst( self, "setState", function ( element, controller )
		if IsSelfInState( self, "DefaultState" ) and IsElementInFocus( element ) then
			MakeElementFocusable( self, "item", controller )
			SetFocusToElement( self, "item", controller )
		elseif IsSelfInState( self, "DefaultState" ) then
			MakeElementFocusable( self, "item", controller )
		end
	end )
	item.id = "item"
	self:registerEventHandler( "gain_focus", function ( element, event )
		if element.m_focusable and element.item:processEvent( event ) then
			return true
		else
			return LUI.UIElement.gainFocus( element, event )
		end
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.item:close()
		element.FocusBarB0:close()
		element.FocusBarB00:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
