require( "ui.uieditor.widgets.MPHudWidgets.ScorePopup.MPScrFeedItem" )
require( "ui.uieditor.widgets.MPHudWidgets.ScorePopup.MPScr_PlusPointsContainer" )

local PostLoadFunc = function ( self, controller, menu )
	self.ScoreFeedItem0.TextBox:setText( "" )
	local topAnchor, bottomAnchor, top, bottom = self.ScoreFeedItem0:getLocalTopBottom()
	local feedItemHeight = bottom - top
	self.ScoreFeedItem0.top = top
	self.MPScrPlusPointsContainer:setAlpha( 0 )
	self.lastAnim = 0
	self.AddScoreFeed = function ( self2, scoreText, isThiefScore )
		self:setLeftRight(false, false, -50, 400)
		self:setTopBottom(false, true, -330.000000, -280.000000)
		for i = 14, 1, -1 do
			local ScoreFeedItem_Next = self["ScoreFeedItem" .. i]
			local ScoreFeedItem = self["ScoreFeedItem" .. i - 1]
			if ScoreFeedItem and ScoreFeedItem.text then
				if not ScoreFeedItem_Next then
					self["ScoreFeedItem" .. i] = CoD.MPScrFeedItem.new( menu, controller )
					ScoreFeedItem_Next = self["ScoreFeedItem" .. i]
					self:addElement( ScoreFeedItem_Next )
				end
				ScoreFeedItem_Next:setLeftRight( false, false, 50, 290 )
				ScoreFeedItem_Next:setTopBottom( topAnchor, bottomAnchor, ScoreFeedItem.top, ScoreFeedItem.top + feedItemHeight )
				ScoreFeedItem_Next.textColor = ScoreFeedItem.textColor
				ScoreFeedItem_Next:setRGB( ScoreFeedItem_Next.textColor.r, ScoreFeedItem_Next.textColor.g, ScoreFeedItem_Next.textColor.b )
				ScoreFeedItem_Next.text = ScoreFeedItem.text
				ScoreFeedItem_Next.TextBox:setText( ScoreFeedItem_Next.text )
				ScoreFeedItem_Next:beginAnimation( "keyframe", 100, false, true, CoD.TweenType.Linear )
				local topAnchor, bottomAnchor, top, bottom = ScoreFeedItem_Next:getLocalTopBottom()
				ScoreFeedItem_Next:setTopBottom( topAnchor, bottomAnchor, top + feedItemHeight, bottom + feedItemHeight )
				ScoreFeedItem_Next.top = top + feedItemHeight
			end
		end
		if isThiefScore then
			self.ScoreFeedItem0.textColor = ColorSet.ThiefScoreFeedColor
		else
			self.ScoreFeedItem0.textColor = {
				r = 1,
				g = 1,
				b = 1
			}
		end
		self.ScoreFeedItem0:setRGB( self.ScoreFeedItem0.textColor.r, self.ScoreFeedItem0.textColor.g, self.ScoreFeedItem0.textColor.b )
		self.ScoreFeedItem0.text = scoreText
		self.ScoreFeedItem0.TextBox:setText( self.ScoreFeedItem0.text )
		self.ScoreFeedItem0:playClip( "DefaultClip" )
		
		--self.ScoreFeedItem0:completeAnimation()
		self.ScoreFeedItem0:setLeftRight( false, false, 140, 380 )
		self.ScoreFeedItem0:setAlpha(0)
		self.ScoreFeedItem0:beginAnimation( "keyframe", 200, false, true, CoD.TweenType.Linear )
		self.ScoreFeedItem0:setLeftRight( false, false, 50, 290 )
		self.ScoreFeedItem0:setAlpha(1)
	end
	
	self.AddCenterScore = function ( self, scoreName, score )
		if scoreName ~= nil then
			if score >= 0 and score <= 0 then
				return 
			elseif self.currentScore == nil then
				self.currentScore = 0
			end
			self.currentScore = self.currentScore + score
			local scorePrefix
			if self.currentScore > 0 then
				scorePrefix = Engine.Localize( "MP_PLUS" )
				if not scorePrefix then
				
				else
					self.Score:setText( scorePrefix .. self.currentScore )
					if scoreName ~= "SCORE_KILL" then
						self:AddScoreFeed( Engine.Localize( scoreName ) )
					end
				end
			end
			scorePrefix = ""
		elseif self.streakLabel ~= nil then
			self.streakLabel:out()
			self.streakLabel = nil
		end
	end
	
	self.AddCombatEfficiencyScore = function ( self2, menu, score, controller )
		if score == 0 or score > 10000 then
			return 
		end
		local mPScr_PlusPointsContainer = CoD.MPScr_PlusPointsContainer.new( menu, controller )
		mPScr_PlusPointsContainer:setScale( 0.4 )
		mPScr_PlusPointsContainer.MPScr_PlusPoints.Label1:setText( "+" .. score )
		mPScr_PlusPointsContainer.MPScr_PlusPoints.Label2:setText( "+" .. score )
		mPScr_PlusPointsContainer.MPScr_PlusPoints:playClip( "DefaultClip" )
		mPScr_PlusPointsContainer:setLeftRight( self2:getLocalLeftRight() )
		mPScr_PlusPointsContainer:setTopBottom( self2:getLocalTopBottom() )
		self:setLeftRight(false, false, -50, 400)
		self:setTopBottom(false, true, -330.000000, -280.000000)
		self2.lastAnim = self2.lastAnim + 1
		Engine.PlaySound( "gdt_ce_score" )
		mPScr_PlusPointsContainer:setState( "DefaultState" )
		if not mPScr_PlusPointsContainer:hasClip( "Anim" .. self2.lastAnim ) then
			self2.lastAnim = 1
		end
		mPScr_PlusPointsContainer:registerEventHandler( "clip_over", function ( element, event )
			element:close()
		end )
		local parentElement = self2:getParent()
		parentElement:addElement( mPScr_PlusPointsContainer )
		mPScr_PlusPointsContainer:playClip( "Anim" .. self2.lastAnim )
	end
	
	self:registerEventHandler( "clip_over", function ( element, event )
		element.currentScore = 0
		for feedIndex = 0, 14, 1 do
			if not element["ScoreFeedItem" .. feedIndex] then
				break
			elseif feedIndex == 0 then
				local feedItemPrefix = "ScoreFeedItem"
				element["ScoreFeedItem" .. feedIndex].TextBox:setText( "" )
				feedItemPrefix = "ScoreFeedItem"
				element["ScoreFeedItem" .. feedIndex].text = nil
			else
				element["ScoreFeedItem" .. feedIndex]:close()
				element["ScoreFeedItem" .. feedIndex] = nil
			end
		end
	end )
end

CoD.MPScr = InheritFrom( LUI.UIElement )
CoD.MPScr.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.MPScr )
	self.id = "MPScr"
	self.soundSet = "HUD"
    self:setLeftRight(false, false, -50, 400)
	self:setTopBottom(false, true, -330.000000, -280.000000)
	-- self:setYRot(-40)
	self.anyChildUsesUpdateState = true
	
	local ScoreFeedGlow = LUI.UIImage.new()
	ScoreFeedGlow:setLeftRight( false, false, -62, 62 )
	ScoreFeedGlow:setTopBottom( false, false, -55, 50 )
    self:setLeftRight(false, false, -50, 400)
    self:setTopBottom(false, true, -330.000000, -280.000000)
	ScoreFeedGlow:setRGB( 0.09, 0.16, 0.19 )
	ScoreFeedGlow:setImage( RegisterImage( "uie_lui_score_feed_glow" ) )
	ScoreFeedGlow:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( ScoreFeedGlow )
	self.ScoreFeedGlow = ScoreFeedGlow
	
	local Score = LUI.UIText.new()
	Score:setLeftRight( false, false, -50, 50 )
	Score:setTopBottom( true, false, 17, 36 )
    self:setLeftRight(false, false, -50, 400)
    self:setTopBottom(false, true, -330.000000, -280.000000)
	Score:setText( Engine.Localize( "+100" ) )
	Score:setTTF( "fonts/foundrygridnik-bold.ttf" )
	Score:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	Score:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	LUI.OverrideFunction_CallOriginalFirst( Score, "setText", function ( element, controller )
		ScaleWidgetToLabelCentered( self, element, 0 )
	end )
	self:addElement( Score )
	self.Score = Score
	
	local ScoreFeedItem0 = CoD.MPScrFeedItem.new( menu, controller )
	ScoreFeedItem0:setLeftRight( false, false, 50, 290 )
	ScoreFeedItem0:setTopBottom( true, false, 11, 29 )
    self:setLeftRight(false, false, -50, 400)
    self:setTopBottom(false, true, -330.000000, -280.000000)
	self:addElement( ScoreFeedItem0 )
	self.ScoreFeedItem0 = ScoreFeedItem0
	
	local MPScrPlusPointsContainer = CoD.MPScr_PlusPointsContainer.new( menu, controller )
	MPScrPlusPointsContainer:setLeftRight( true, false, 77.23, 162.23 )
	MPScrPlusPointsContainer:setTopBottom( true, false, -14, 52 )
    self:setLeftRight(false, false, -50, 400)
    self:setTopBottom(false, true, -330.000000, -280.000000)
	MPScrPlusPointsContainer:setAlpha( 0 )
	MPScrPlusPointsContainer:setScale( 0.4 )
	self:addElement( MPScrPlusPointsContainer )
	self.MPScrPlusPointsContainer = MPScrPlusPointsContainer
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				ScoreFeedGlow:completeAnimation()
				self.ScoreFeedGlow:setAlpha( 0 )
				self.clipFinished( ScoreFeedGlow, {} )
				Score:completeAnimation()
				self.Score:setAlpha( 0 )
				self.clipFinished( Score, {} )
				MPScrPlusPointsContainer:completeAnimation()
				self.MPScrPlusPointsContainer:setAlpha( 0 )
				self.clipFinished( MPScrPlusPointsContainer, {} )
			end,
			CombatEfficiencyScore = function ()
				self:setupElementClipCounter( 3 )
				local ScoreFeedGlowFrame2 = function ( ScoreFeedGlow, event )
					local ScoreFeedGlowFrame3 = function ( ScoreFeedGlow, event )
						local ScoreFeedGlowFrame4 = function ( ScoreFeedGlow, event )
							local ScoreFeedGlowFrame5 = function ( ScoreFeedGlow, event )
								if not event.interrupted then
									ScoreFeedGlow:beginAnimation( "keyframe", 60, false, false, CoD.TweenType.Linear )
								end
								ScoreFeedGlow:setLeftRight( false, false, -50, 50 )
								ScoreFeedGlow:setTopBottom( false, false, 0, 0 )
								Score:setLeftRight( false, false, -50, 50 )
								Score:setTopBottom( true, false, 14, 33 )
								self:setLeftRight(false, false, -50, 400)
								self:setTopBottom(false, true, -330.000000, -280.000000)
								ScoreFeedGlow:setRGB( 0, 0, 0 )
								ScoreFeedGlow:setAlpha( 1 )
								if event.interrupted then
									self.clipFinished( ScoreFeedGlow, event )
								else
									ScoreFeedGlow:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
								end
							end
							
							if event.interrupted then
								ScoreFeedGlowFrame5( ScoreFeedGlow, event )
								return 
							else
								ScoreFeedGlow:beginAnimation( "keyframe", 9, false, false, CoD.TweenType.Linear )
								ScoreFeedGlow:setRGB( 1, 1, 1 )
								ScoreFeedGlow:registerEventHandler( "transition_complete_keyframe", ScoreFeedGlowFrame5 )
								Score:setLeftRight( false, false, -50, 50 )
								Score:setTopBottom( true, false, 14, 33 )
							end
						end
						
						if event.interrupted then
							ScoreFeedGlowFrame4( ScoreFeedGlow, event )
							return 
						else
							ScoreFeedGlow:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
							ScoreFeedGlow:setRGB( 0.18, 0.33, 0.37 )
							ScoreFeedGlow:registerEventHandler( "transition_complete_keyframe", ScoreFeedGlowFrame4 )
							Score:setLeftRight( false, false, -50, 50 )
							Score:setTopBottom( true, false, 14, 33 )
						end
					end
					
					if event.interrupted then
						ScoreFeedGlowFrame3( ScoreFeedGlow, event )
						return 
					else
						ScoreFeedGlow:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
						ScoreFeedGlow:setRGB( 0.07, 0.27, 0.31 )
						ScoreFeedGlow:setAlpha( 1 )
						ScoreFeedGlow:registerEventHandler( "transition_complete_keyframe", ScoreFeedGlowFrame3 )
						Score:setLeftRight( false, false, -50, 50 )
						Score:setTopBottom( true, false, 14, 33 )
					end
				end
				
				ScoreFeedGlow:completeAnimation()
				self.ScoreFeedGlow:setLeftRight( false, false, -62, 62 )
				self.ScoreFeedGlow:setTopBottom( false, false, -55, 50 )
				self:setLeftRight(false, false, -50, 400)
				self:setTopBottom(false, true, -330.000000, -280.000000)
				self.ScoreFeedGlow:setRGB( 1, 1, 1 )
				self.ScoreFeedGlow:setAlpha( 0.5 )
				self.Score:setLeftRight( false, false, -50, 50 )
				self.Score:setTopBottom( true, false, 14, 33 )
				ScoreFeedGlowFrame2( ScoreFeedGlow, {} )
				local ScoreFrame2 = function ( Score, event )
					local ScoreFrame3 = function ( Score, event )
						local ScoreFrame4 = function ( Score, event )
							local ScoreFrame5 = function ( Score, event )
								if not event.interrupted then
									Score:beginAnimation( "keyframe", 9, false, false, CoD.TweenType.Linear )
								end
								Score:setRGB( 0.6, 0.83, 0.96 )
								Score:setAlpha( 0 )
								Score:setScale( 1 )
								if event.interrupted then
									self.clipFinished( Score, event )
								else
									Score:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
								end
							end
							
							if event.interrupted then
								ScoreFrame5( Score, event )
								return 
							else
								Score:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
								Score:registerEventHandler( "transition_complete_keyframe", ScoreFrame5 )
							end
						end
						
						if event.interrupted then
							ScoreFrame4( Score, event )
							return 
						else
							Score:beginAnimation( "keyframe", 250, true, false, CoD.TweenType.Back )
							Score:setScale( 1 )
							Score:registerEventHandler( "transition_complete_keyframe", ScoreFrame4 )
						end
					end
					
					if event.interrupted then
						ScoreFrame3( Score, event )
						return 
					else
						Score:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
						Score:setScale( 1.75 )
						Score:registerEventHandler( "transition_complete_keyframe", ScoreFrame3 )
					end
				end
				
				Score:completeAnimation()
				self.Score:setRGB( 0.6, 0.83, 0.96 )
				self.Score:setAlpha( 1 )
				self.Score:setScale( 0 )
				ScoreFrame2( Score, {} )
				local MPScrPlusPointsContainerFrame2 = function ( MPScrPlusPointsContainer, event )
					local MPScrPlusPointsContainerFrame3 = function ( MPScrPlusPointsContainer, event )
						if not event.interrupted then
							MPScrPlusPointsContainer:beginAnimation( "keyframe", 49, false, false, CoD.TweenType.Linear )
						end
						MPScrPlusPointsContainer:setAlpha( 0 )
						if event.interrupted then
							self.clipFinished( MPScrPlusPointsContainer, event )
						else
							MPScrPlusPointsContainer:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						MPScrPlusPointsContainerFrame3( MPScrPlusPointsContainer, event )
						return 
					else
						MPScrPlusPointsContainer:beginAnimation( "keyframe", 1000, false, false, CoD.TweenType.Linear )
						MPScrPlusPointsContainer:registerEventHandler( "transition_complete_keyframe", MPScrPlusPointsContainerFrame3 )
					end
				end
				
				MPScrPlusPointsContainer:completeAnimation()
				self.MPScrPlusPointsContainer:setAlpha( 1 )
				MPScrPlusPointsContainerFrame2( MPScrPlusPointsContainer, {} )
			end,
			NormalScore = function ()
				self:setupElementClipCounter( 3 )
				local ScoreFeedGlowFrame2 = function ( ScoreFeedGlow, event )
					local ScoreFeedGlowFrame3 = function ( ScoreFeedGlow, event )
						local ScoreFeedGlowFrame4 = function ( ScoreFeedGlow, event )
							local ScoreFeedGlowFrame5 = function ( ScoreFeedGlow, event )
								if not event.interrupted then
									ScoreFeedGlow:beginAnimation( "keyframe", 60, false, false, CoD.TweenType.Linear )
								end
								ScoreFeedGlow:setLeftRight( false, false, -50, 50 )
								ScoreFeedGlow:setTopBottom( false, false, 0, 0 )
								self:setLeftRight(false, false, -50, 400)
								self:setTopBottom(false, true, -330.000000, -280.000000)
								ScoreFeedGlow:setRGB( 0, 0, 0 )
								ScoreFeedGlow:setAlpha( 0.5 )
								Score:setLeftRight( false, false, -50, 50 )
								Score:setTopBottom( true, false, 14, 33 )
								if event.interrupted then
									self.clipFinished( ScoreFeedGlow, event )
								else
									ScoreFeedGlow:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
								end
							end
							
							if event.interrupted then
								ScoreFeedGlowFrame5( ScoreFeedGlow, event )
								return 
							else
								ScoreFeedGlow:beginAnimation( "keyframe", 9, false, false, CoD.TweenType.Linear )
								ScoreFeedGlow:setRGB( 1, 1, 1 )
								ScoreFeedGlow:registerEventHandler( "transition_complete_keyframe", ScoreFeedGlowFrame5 )
								Score:setLeftRight( false, false, -50, 50 )
								Score:setTopBottom( true, false, 14, 33 )
							end
						end
						
						if event.interrupted then
							ScoreFeedGlowFrame4( ScoreFeedGlow, event )
							return 
						else
							ScoreFeedGlow:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
							ScoreFeedGlow:setRGB( 0.06, 0, 0.13 )
							ScoreFeedGlow:registerEventHandler( "transition_complete_keyframe", ScoreFeedGlowFrame4 )
							Score:setLeftRight( false, false, -50, 50 )
							Score:setTopBottom( true, false, 14, 33 )
						end
					end
					
					if event.interrupted then
						ScoreFeedGlowFrame3( ScoreFeedGlow, event )
						return 
					else
						ScoreFeedGlow:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
						ScoreFeedGlow:setRGB( 0.09, 0.16, 0.19 )
						ScoreFeedGlow:registerEventHandler( "transition_complete_keyframe", ScoreFeedGlowFrame3 )
					end
				end
				
				ScoreFeedGlow:completeAnimation()
				self.ScoreFeedGlow:setLeftRight( false, false, -62, 62 )
				self.ScoreFeedGlow:setTopBottom( false, false, -55, 50 )
				self:setLeftRight(false, false, -50, 400)
				self:setTopBottom(false, true, -330.000000, -280.000000)
				self.ScoreFeedGlow:setRGB( 1, 1, 1 )
				self.ScoreFeedGlow:setAlpha( 0.5 )
				
				self.Score:setLeftRight( false, false, -50, 50 )
				self.Score:setTopBottom( true, false, 14, 33 )
				ScoreFeedGlowFrame2( ScoreFeedGlow, {} )
				local ScoreFrame2 = function ( Score, event )
					local ScoreFrame3 = function ( Score, event )
						local ScoreFrame4 = function ( Score, event )
							local ScoreFrame5 = function ( Score, event )
								if not event.interrupted then
									Score:beginAnimation( "keyframe", 9, false, false, CoD.TweenType.Linear )
								end
								Score:setRGB( 1, 1, 1 )
								Score:setAlpha( 0 )
								Score:setScale( 1 )
								if event.interrupted then
									self.clipFinished( Score, event )
								else
									Score:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
								end
							end
							
							if event.interrupted then
								ScoreFrame5( Score, event )
								return 
							else
								Score:beginAnimation( "keyframe", 500, true, true, CoD.TweenType.Elastic )
								Score:registerEventHandler( "transition_complete_keyframe", ScoreFrame5 )
							end
						end
						
						if event.interrupted then
							ScoreFrame4( Score, event )
							return 
						else
							Score:beginAnimation( "keyframe", 250, true, false, CoD.TweenType.Back )
							Score:setScale( 1 )
							Score:registerEventHandler( "transition_complete_keyframe", ScoreFrame4 )
						end
					end
					
					if event.interrupted then
						ScoreFrame3( Score, event )
						return 
					else
						Score:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
						Score:setScale( 1.75 )
						Score:registerEventHandler( "transition_complete_keyframe", ScoreFrame3 )
					end
				end
				
				Score:completeAnimation()
				self.Score:setRGB( 1, 1, 1 )
				self.Score:setAlpha( 1 )
				self.Score:setScale( 0 )
				self.Score:setLeftRight( false, false, -50, 50 )
				self.Score:setTopBottom( true, false, 14, 33 )
				ScoreFrame2( Score, {} )
				MPScrPlusPointsContainer:completeAnimation()
				self.MPScrPlusPointsContainer:setAlpha( 0 )
				self.clipFinished( MPScrPlusPointsContainer, {} )
			end
		},
		Hidden = {
			DefaultClip = function ()
				self:setAlpha(0.9)
				self:setupElementClipCounter( 2 )
				ScoreFeedGlow:completeAnimation()
				self.ScoreFeedGlow:setAlpha( 0 )
				self.clipFinished( ScoreFeedGlow, {} )
				Score:completeAnimation()
				self.Score:setAlpha( 0 )
				self.clipFinished( Score, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				local isVisibilityBitSet = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_FINAL_KILLCAM )
				if not isVisibilityBitSet then
					isVisibilityBitSet = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_ROUND_END_KILLCAM )
					if not isVisibilityBitSet then
						isVisibilityBitSet = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM )
						if not isVisibilityBitSet then
							isVisibilityBitSet = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN )
							if not isVisibilityBitSet then
								isVisibilityBitSet = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE )
							end
						end
					end
				end
				return isVisibilityBitSet
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_FINAL_KILLCAM ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_FINAL_KILLCAM
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_ROUND_END_KILLCAM ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_ROUND_END_KILLCAM
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
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN
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
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ScoreFeedItem0:close()
		element.MPScrPlusPointsContainer:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

