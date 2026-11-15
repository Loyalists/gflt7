-- Adapted from All-Around-Enhancement IW8DamageFeedback.lua.
-- Sounds remain server-side, using GFL's tfoption_hitmarkers_sound setting.
local function get_next_rot(self)
    self.ZRot_stats = -self.ZRot_stats
    return 6 * self.ZRot_stats
end

local function get_splah_rot(self)
    self.ZRot_stats = -self.ZRot_stats
    return 3 * self.ZRot_stats
end

local function HitMarker_PostLoad(self, controller)
    LUI.OverrideFunction_CallOriginalFirst(self, "setState", function(element, state)
        if state == "DefaultState" then
            if element.moveToDefaultTimer then
                element.moveToDefaultTimer:close()
                element.moveToDefaultTimer = nil
            end
        elseif element.moveToDefaultTimer then
            element.moveToDefaultTimer:reset()
        else
            element.moveToDefaultTimer = LUI.UITimer.newElementTimer(1, true, function()
                local model = Engine.GetModel(Engine.GetModelForController(controller), "currentWeapon.damageFeedbackState")
                if model then
                    Engine.SetModelValue(model, 0)
                end
            end)
            element:addElement(element.moveToDefaultTimer)
        end
    end)
    LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
        if element.moveToDefaultTimer then
            element.moveToDefaultTimer:close()
            element.moveToDefaultTimer = nil
        end
    end)
end

CoD.IW8DamageFeedback = InheritFrom( LUI.UIElement ) 
CoD.IW8DamageFeedback.new = function ( menu, controller )
	local self = LUI.UIElement.new() 
	HitMarker_PostLoad( self, controller ) 
	self:setUseStencil( false ) 
	self:setClass( CoD.IW8DamageFeedback ) 
	self.id = "IW8DamageFeedback" 
	self.soundSet = "none" 
	self:setLeftRight( true, true, 0, 0 ) 
	self:setTopBottom( true, true, 0, 0 ) 
	self.anyChildUsesUpdateState = true 
	self.ZRot_stats = 1
	
	local hit = RegisterImage( "t10_hit" )
	local head = RegisterImage( "t10_head" )
	local splash = RegisterImage( "t10_splah_hit" )
	
	local damage = LUI.UIImage.new() 
	damage:setLeftRight(true, true, -18, 18)
	damage:setTopBottom(true, true, -18, 18)
	damage:setAlpha(0)
	damage:setImage( hit ) 
	damage:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_nineslice_normal" ) )
	damage:setShaderVector( 0, 1, 1, 0, 0 )
	damage:setupNineSliceShader( 20,20 )
	self:addElement( damage ) 
	self.damage = damage 


	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
			end
		},
		Stage1 = {
			DefaultClip = function ()
				self:setupElementClipCounter(1)
				self.damage:completeAnimation()
				local damageFrame1 = function(damage, event)
					local damageFrame2 = function(damage, event)
						local damageFrame3 = function(damage, event)
							local damageFrame4 = function(damage, event)
								if event.interrupted then
									self.clipFinished( damage, event ) 
								else
									damage:setZRot(0)
									damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
									damage:setAlpha(0)
									damage:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if event.interrupted then
								damageFrame4(damage, event)
								return
							else
								damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
								damage:registerEventHandler("transition_complete_keyframe", damageFrame4)
							end
						end
		
						if event.interrupted then
							damageFrame3(damage, event)
							return
						else
							damage:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
							damage:setLeftRight(true, true, -18, 18)
							damage:setTopBottom(true, true, -18, 18)
							damage:setAlpha(1)
							damage:setZRot(0)
							damage:registerEventHandler("transition_complete_keyframe", damageFrame3)
						end
					end
					if event.interrupted then
						damageFrame2(damage, event)
						return
					else
						damage:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
						damage:setLeftRight(true, true, -27, 27 )
						damage:setTopBottom(true, true, -27, 27)
						damage:setAlpha(1)
						damage:setZRot(get_next_rot(self))
						damage:registerEventHandler("transition_complete_keyframe", damageFrame2)
					end
				end

				self.damage:setLeftRight(true, true, -18, 18 )
				self.damage:setTopBottom(true, true, -18, 18)
				self.damage:setZRot(0)
				self.damage:setScale(1)
				self.damage:setImage( hit ) 
				self.damage:setupNineSliceShader( 21,21 )
				self.damage:setRGB(1,1,1)
				damageFrame1(self.damage, {})
			end
		},
		Stage2 = {
			DefaultClip = function ()
				self:setupElementClipCounter(1)
				self.damage:completeAnimation()
				local damageFrame1 = function(damage, event)
					local damageFrame2 = function(damage, event)
						local damageFrame3 = function(damage, event)
							local damageFrame4 = function(damage, event)
								if event.interrupted then
									self.clipFinished( damage, event ) 
								else
									damage:setZRot(0)
									damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
									damage:setAlpha(0)
									damage:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if event.interrupted then
								damageFrame4(damage, event)
								return
							else
								damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
								damage:registerEventHandler("transition_complete_keyframe", damageFrame4)
							end
						end
		
						if event.interrupted then
							damageFrame3(damage, event)
							return
						else
							damage:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
							damage:setLeftRight(true, true, -18, 18)
							damage:setTopBottom(true, true, -18, 18)
							damage:setAlpha(1)
							damage:setZRot(0)
							damage:registerEventHandler("transition_complete_keyframe", damageFrame3)
						end
					end
					if event.interrupted then
						damageFrame2(damage, event)
						return
					else
						damage:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
						damage:setLeftRight(true, true, -27, 27)
						damage:setTopBottom(true, true, -27, 27)
						damage:setAlpha(1)
						damage:setZRot(get_next_rot(self))
						damage:registerEventHandler("transition_complete_keyframe", damageFrame2)
					end
				end

				self.damage:setLeftRight(true, true, -18, 18)
				self.damage:setTopBottom(true, true, -18, 18)
				self.damage:setZRot(0)
				self.damage:setScale(1)
				self.damage:setImage( head ) 
				self.damage:setupNineSliceShader( 19,19 )
				self.damage:setRGB(0.93 , 0.82 , 0.09)
				damageFrame1(self.damage, {})
			end
		},
		Stage3 = {
			DefaultClip = function ()
				self:setupElementClipCounter(1)
				self.damage:completeAnimation()
				local damageFrame1 = function(damage, event)
					local damageFrame2 = function(damage, event)
						local damageFrame3 = function(damage, event)
							local damageFrame4 = function(damage, event)
								if event.interrupted then
									self.clipFinished( damage, event ) 
								else
									damage:setZRot(0)
									damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
									damage:setLeftRight(true, true, -30, 30)
									damage:setTopBottom(true, true, -30, 30)
									damage:setAlpha(0)
									damage:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if event.interrupted then
								damageFrame4(damage, event)
								return
							else
								damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
								damage:registerEventHandler("transition_complete_keyframe", damageFrame4)
							end
						end
		
						if event.interrupted then
							damageFrame3(damage, event)
							return
						else
							damage:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
							damage:setLeftRight(true, true, -18, 18)
							damage:setTopBottom(true, true, -18, 18)
							damage:setAlpha(1)
							damage:setZRot(0)
							damage:registerEventHandler("transition_complete_keyframe", damageFrame3)
						end
					end
					if event.interrupted then
						damageFrame2(damage, event)
						return
					else
						damage:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
						damage:setLeftRight(true, true, -27, 27)
						damage:setTopBottom(true, true, -27, 27)
						damage:setAlpha(1)
						damage:setZRot(get_next_rot(self))
						damage:registerEventHandler("transition_complete_keyframe", damageFrame2)
					end
				end

				self.damage:setLeftRight(true, true, -18, 18)
				self.damage:setTopBottom(true, true, -18, 18)
				self.damage:setZRot(0)
				self.damage:setScale(1)
				self.damage:setImage( hit ) 
				self.damage:setupNineSliceShader( 21,21 )
				self.damage:setRGB(1,0.3,0.2)
				damageFrame1(self.damage, {})
			end
		},
		Stage4 = {
			DefaultClip = function ()
				self:setupElementClipCounter(1)
				self.damage:completeAnimation()
				local damageFrame1 = function(damage, event)
					local damageFrame2 = function(damage, event)
						local damageFrame3 = function(damage, event)
							local damageFrame4 = function(damage, event)
								if event.interrupted then	
									self.clipFinished( damage, event ) 
								else
									damage:setZRot(0)
									damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
									damage:setLeftRight(true, true, -30, 30)
									damage:setTopBottom(true, true, -30, 30)
									damage:setAlpha(0)
									damage:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if event.interrupted then
								damageFrame4(damage, event)
								return
							else
								damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
								damage:registerEventHandler("transition_complete_keyframe", damageFrame4)
							end
						end
		
						if event.interrupted then
							damageFrame3(damage, event)
							return
						else
							damage:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
							damage:setLeftRight(true, true, -18, 18)
							damage:setTopBottom(true, true, -18, 18)
							damage:setAlpha(1)
							damage:setZRot(0)
							damage:registerEventHandler("transition_complete_keyframe", damageFrame3)
						end
					end
					if event.interrupted then
						damageFrame2(damage, event)
						return
					else
						damage:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
						damage:setLeftRight(true, true, -27, 27)
						damage:setTopBottom(true, true, -27, 27)
						damage:setAlpha(1)
						damage:setZRot(get_next_rot(self))
						damage:registerEventHandler("transition_complete_keyframe", damageFrame2)
					end
				end

				self.damage:setLeftRight(true, true, -18, 18)
				self.damage:setTopBottom(true, true, -18, 18)
				self.damage:setZRot(0)
				self.damage:setScale(1)
				self.damage:setImage( head ) 
				self.damage:setupNineSliceShader( 19,19 )
				self.damage:setRGB(1,0.3,0.2)
				damageFrame1(self.damage, {})
			end
		},
		Stage5 = {
			DefaultClip = function ()
				self:setupElementClipCounter(1)
				self.damage:completeAnimation()
				local damageFrame1 = function(damage, event)
					local damageFrame2 = function(damage, event)
						local damageFrame3 = function(damage, event)
							local damageFrame4 = function(damage, event)
								if event.interrupted then	
									self.clipFinished( damage, event ) 
								else
									damage:setZRot(0)
									damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
									damage:setLeftRight(true, true, -30, 30)
									damage:setTopBottom(true, true, -30, 30)
									damage:setAlpha(0)
									damage:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if event.interrupted then
								damageFrame4(damage, event)
								return
							else
								damage:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
								damage:registerEventHandler("transition_complete_keyframe", damageFrame4)
							end
						end
		
						if event.interrupted then
							damageFrame3(damage, event)
							return
						else
							damage:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
							damage:setLeftRight(true, true, -18, 18)
							damage:setTopBottom(true, true, -18, 18)
							damage:setAlpha(1)
							damage:setZRot(0)
							damage:registerEventHandler("transition_complete_keyframe", damageFrame3)
						end
					end
					if event.interrupted then
						damageFrame2(damage, event)
						return
					else
						damage:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
						damage:setLeftRight(true, true, -27, 27)
						damage:setTopBottom(true, true, -27, 27)
						damage:setAlpha(1)
						damage:setZRot(get_next_rot(self))
						damage:registerEventHandler("transition_complete_keyframe", damageFrame2)
					end
				end

				self.damage:setLeftRight(true, true, -18, 18)
				self.damage:setTopBottom(true, true, -18, 18)
				self.damage:setZRot(0)
				self.damage:setScale(1)
				self.damage:setImage( head ) 
				self.damage:setupNineSliceShader( 19,19 )
				self.damage:setRGB(1,0.3,0.2)
				damageFrame1(self.damage, {})
			end
		},
		Splah = {
			DefaultClip = function ()
				self:setupElementClipCounter(1)
				self.damage:completeAnimation()
				local damageFrame1 = function(damage, event)
					local damageFrame2 = function(damage, event)
						local damageFrame3 = function(damage, event)
							local damageFrame4 = function(damage, event)
								if event.interrupted then
									self.clipFinished( damage, event ) 
								else
									damage:setZRot(0)
									damage:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
									damage:setAlpha(0)
									damage:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if event.interrupted then
								damageFrame4(damage, event)
								return
							else
								damage:beginAnimation("keyframe", 10, false, false, CoD.TweenType.Linear)
								damage:registerEventHandler("transition_complete_keyframe", damageFrame4)
							end
						end
		
						if event.interrupted then
							damageFrame3(damage, event)
							return
						else
							damage:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
							damage:setLeftRight(true, true, -30, 30)
							damage:setAlpha(1)
							damage:setZRot(0)
							damage:registerEventHandler("transition_complete_keyframe", damageFrame3)
						end
					end
					if event.interrupted then
						damageFrame2(damage, event)
						return
					else
						damage:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
						damage:setLeftRight(true, true, -40, 40)
						damage:setAlpha(1)
						damage:setZRot(get_splah_rot(self))
						damage:registerEventHandler("transition_complete_keyframe", damageFrame2)
					end
				end

				self.damage:setLeftRight(true, true, -30, 30)
				self.damage:setTopBottom(false, false, -30 , 30 )
				self.damage:setZRot(0)
				self.damage:setScale(1.2)
				self.damage:setImage( splash ) 
				self.damage:setupNineSliceShader( 30 , 30 )
				self.damage:setRGB(1,1,1)
				damageFrame1(self.damage, {})
			end
		},
		SplahDeath = {
			DefaultClip = function ()
				self:setupElementClipCounter(1)
				self.damage:completeAnimation()
				local damageFrame1 = function(damage, event)
					local damageFrame2 = function(damage, event)
						local damageFrame3 = function(damage, event)
							local damageFrame4 = function(damage, event)
								if event.interrupted then
									self.clipFinished( damage, event ) 
								else
									damage:setZRot(0)
									damage:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
									damage:setLeftRight(true, true, -37, 37)
									damage:setAlpha(0)
									damage:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if event.interrupted then
								damageFrame4(damage, event)
								return
							else
								damage:beginAnimation("keyframe", 10, false, false, CoD.TweenType.Linear)
								damage:registerEventHandler("transition_complete_keyframe", damageFrame4)
							end
						end
		
						if event.interrupted then
							damageFrame3(damage, event)
							return
						else
							damage:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
							damage:setLeftRight(true, true, -30, 30)
							damage:setAlpha(1)
							damage:setZRot(0)
							damage:registerEventHandler("transition_complete_keyframe", damageFrame3)
						end
					end
					if event.interrupted then
						damageFrame2(damage, event)
						return
					else
						damage:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
						damage:setLeftRight(true, true, -40, 40)
						damage:setAlpha(1)
						damage:setZRot(get_splah_rot(self))
						damage:registerEventHandler("transition_complete_keyframe", damageFrame2)
					end
				end

				self.damage:setLeftRight(true, true, -30, 30)
				self.damage:setTopBottom(false, false, -30 , 30 )
				self.damage:setZRot(0)
				self.damage:setScale(1.2)
				self.damage:setImage( splash ) 
				self.damage:setupNineSliceShader( 30 , 30 )
				self.damage:setRGB(1,0.3,0.2)
				damageFrame1(self.damage, {})
			end
		}
	}


	self:mergeStateConditions( {
		{
			stateName = "Stage1",
			condition = function ( menu, element, event )
				return DamageFeedbackInStage( element, Enum.DamageFeedbackState.DAMAGE_FEEDBACK_STATE_1 ) and not DamageFeedbackFlagSet( element, Enum.DamageFeedbackFlags.DAMAGE_FEEDBACK_FLAG_DEAD )
			end
		},
		{
			stateName = "Stage2",
			condition = function ( menu, element, event )
				return DamageFeedbackInStage( element, Enum.DamageFeedbackState.DAMAGE_FEEDBACK_STATE_2 ) and not DamageFeedbackFlagSet( element, Enum.DamageFeedbackFlags.DAMAGE_FEEDBACK_FLAG_DEAD )
			end
		},
		{
			stateName = "Stage3",
			condition = function ( menu, element, event )
				return DamageFeedbackInStage( element, Enum.DamageFeedbackState.DAMAGE_FEEDBACK_STATE_1 ) and DamageFeedbackFlagSet( element, Enum.DamageFeedbackFlags.DAMAGE_FEEDBACK_FLAG_DEAD )
			end
		},
		{
			stateName = "Stage4",
			condition = function ( menu, element, event )
				return DamageFeedbackInStage( element, Enum.DamageFeedbackState.DAMAGE_FEEDBACK_STATE_2 ) and DamageFeedbackFlagSet( element, Enum.DamageFeedbackFlags.DAMAGE_FEEDBACK_FLAG_DEAD )
			end
		},
		{
			stateName = "Stage5",
			condition = function ( menu, element, event )
				return DamageFeedbackInStage( element, Enum.DamageFeedbackState.DAMAGE_FEEDBACK_STATE_5 )
			end
		},
		{
			stateName = "Splah",
			condition = function ( menu, element, event )
				return DamageFeedbackInStage( element, Enum.DamageFeedbackState.DAMAGE_FEEDBACK_STATE_3 ) and not DamageFeedbackFlagSet( element, Enum.DamageFeedbackFlags.DAMAGE_FEEDBACK_FLAG_DEAD )
			end
		},
		{
			stateName = "SplahDeath",
			condition = function ( menu, element, event )
				return DamageFeedbackInStage( element, Enum.DamageFeedbackState.DAMAGE_FEEDBACK_STATE_3 ) and DamageFeedbackFlagSet( element, Enum.DamageFeedbackFlags.DAMAGE_FEEDBACK_FLAG_DEAD )
			end
		}
	} ) 
	self.firing_state = 1
	self:linkToElementModel( self, "damageFeedbackState", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "damageFeedbackState"
		} ) 

		if self.firing_state == 1 then
			local frame3 = function(hitmarker, event)
				hitmarker:beginAnimation("keyframe", 50, false, false, CoD.TweenType.Linear)

				hitmarker:registerEventHandler("transition_complete_keyframe", function(hitmarker, event)
					hitmarker.firing_state = 1
				end)
			end
		
			local frame2 = function(hitmarker, event)
				hitmarker:beginAnimation("keyframe", 20, false, false, CoD.TweenType.Linear)
				hitmarker:setAlpha(1)
				hitmarker:registerEventHandler("transition_complete_keyframe", frame3)
			end
		
			local frame1 = function(hitmarker, event)
				hitmarker:beginAnimation("keyframe", 10, false, false, CoD.TweenType.Linear)
				hitmarker:registerEventHandler("transition_complete_keyframe", frame2)
			end

			self.firing_state = 2
			self:beginAnimation("keyframe", 20, false, false, CoD.TweenType.Linear)
			self:setAlpha(0.01)
			self:registerEventHandler("transition_complete_keyframe", frame1)
		end
	end ) 
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.damage:close()
	end ) 
	
	
	return self
end
 
