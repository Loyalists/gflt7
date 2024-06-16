local function moveWhiteFlash( percent, element )
	element:completeAnimation()
	local fraction = 120
	local drawpoint = math.floor(fraction * percent)
	
	element:setLeftRight(false, false, -60 + drawpoint, -60 + drawpoint + 2)
	element:setTopBottom(false, false, -24.5, 20)
	element:beginAnimation("keyframe", 300, true, true, CoD.TweenType.Linear)
	element:setTopBottom(false, false, -2.25, -2.25)
end

CoD.AAE_t9_zombie_health_bar_the_bar = InheritFrom( LUI.UIElement )
CoD.AAE_t9_zombie_health_bar_the_bar.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.AAE_t9_zombie_health_bar_the_bar )
	self.id = "AAE_DamageNumber"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 0 )
	self:setTopBottom( true, false, 0, 0 )
	self:setScale(0)
	self.anyChildUsesUpdateState = true
	self.currenthealth = 1
	self:setPriority( -10000 )

	self.BlackBar = LUI.UIImage.new()
	self.BlackBar:setLeftRight(false, false, -60, 60)
	self.BlackBar:setTopBottom(false, false, -4.5, 0)
	self.BlackBar:setImage(RegisterImage("$black"))
	self.BlackBar:setAlpha(0.5)
	self.BlackBar:setRGB(0, 0, 0)

	self:addElement(self.BlackBar)	
	
	self.WhiteBar = LUI.UIImage.new()
	self.WhiteBar:setLeftRight(false, false, -60, 60)
	self.WhiteBar:setTopBottom(false, false, -4.5, 0)
	self.WhiteBar:setImage(RegisterImage("$white"))
	self.WhiteBar:setMaterial(LUI.UIImage.GetCachedMaterial("uie_wipe_normal"))
	self.WhiteBar:setShaderVector(1, 0, 0, 0, 0) 
	self.WhiteBar:setShaderVector(2, 1, 1, 1, 1)   
	self.WhiteBar:setShaderVector(3, 0, 0, 0, 0) 

	self:addElement(self.WhiteBar)
	
	self.RedBar = LUI.UIImage.new() 
	self.RedBar:setLeftRight(false, false, -60, 60)
	self.RedBar:setTopBottom(false, false, -4.5, 0)
	self.RedBar:setImage(RegisterImage("$white"))
	self.RedBar:setMaterial(LUI.UIImage.GetCachedMaterial("uie_wipe_normal"))
	self.RedBar:setRGB(0.87, 0.33, 0.22)
	self.RedBar:setShaderVector(0, 1, 0, 0, 0) 
	self.RedBar:setShaderVector(1, 0, 0, 0, 0) 
	self.RedBar:setShaderVector(2, 1, 1, 1, 1)   
	self.RedBar:setShaderVector(3, 0, 0, 0, 0)  

	self:addElement(self.RedBar)
	
	self.HealthBarName = LUI.UIText.new()
    self.HealthBarName:setLeftRight(false, false, -60, 60)
    self.HealthBarName:setTopBottom(false, false, -4 - 20 + 25, 4 - 10 + 25)
	self.HealthBarName:setRGB(0.87, 0.33, 0.22)
    self.HealthBarName:setText(Engine.Localize(""))
	self.HealthBarName:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	self.HealthBarName:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	
    self:addElement(self.HealthBarName)
	
	self.Dot = LUI.UIImage.new()
	self.Dot:setLeftRight(false, false, -84, -62)
	self.Dot:setTopBottom(false, false, -1, 21)
	self.Dot:setImage(RegisterImage("uie_ui_icon_minimap_zm_ai_normal"))
	self:addElement(self.Dot)
	
	self.WhiteFlash = LUI.UIImage.new()
	self.WhiteFlash:setLeftRight(false, false, -50, -44)
	self.WhiteFlash:setTopBottom(false, false, -2.25, -2.25)
	self.WhiteFlash:setImage(RegisterImage("$white"))
	self.WhiteFlash:setMaterial(LUI.UIImage.GetCachedMaterial("uie_wipe_normal"))
	self.WhiteFlash:setShaderVector(0, 1, 0, 0, 0) 
	self.WhiteFlash:setShaderVector(1, 0, 0, 0, 0) 
	self.WhiteFlash:setShaderVector(2, 1, 1, 1, 1)   
	self.WhiteFlash:setShaderVector(3, 0, 0, 0, 0) 
	self:addElement(self.WhiteFlash)

	self:subscribeToGlobalModel( controller, "PerController", "scriptNotify", function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue == "aae_zombie_health" then
			local notifyData = CoD.GetScriptNotifyData( model )
			if self.enittyNum then
				local is_visibility = Engine.GetModelValue(Engine.GetModel(Engine.GetModel( Engine.GetModelForController(controller), "AAE_ZombieHealthModel_" .. tostring(self.enittyNum) ) , "visibility"))
				if #notifyData == 3 and tostring(notifyData[2]) == self.enittyNum then
					local health_value = notifyData[1] / 100
					if self.currenthealth ~= health_value and health_value < 1 then			
						self.currenthealth = health_value
						if is_visibility and is_visibility == 1 then
							if notifyData[3] == 1 then
								self.WhiteBar:setRGB(1,0.945,0)
							end
							self.RedBar:beginAnimation("keyframe", 150, true, true, CoD.TweenType.Linear)
							moveWhiteFlash( health_value, self.WhiteFlash )
						end
						self.WhiteBar:beginAnimation("keyframe", 400, true, true, CoD.TweenType.Linear)
						self.WhiteBar:setRGB(1,1,1)
						self.RedBar:setShaderVector(0, health_value, 0, 0, 0) 
						self.WhiteBar:setShaderVector(0, health_value, 0, 0, 0) 
					end
				else
					if #notifyData == 2 and self.enittyNum and tostring(notifyData[1]) == self.enittyNum and notifyData[2] == 1 then
						if is_visibility and is_visibility == 1 then
							self.WhiteBar:setRGB(1,0.945,0)
						end
					end
				end
			end
		end
	end)
	self:linkToElementModel( self, "progress", true, function ( model )
		local ModelValue = Engine.GetModelValue(model)
		if ModelValue then
			self.currenthealth = ModelValue				
			if self.enittyNum then
				local is_visibility = Engine.GetModelValue(Engine.GetModel(Engine.GetModel( Engine.GetModelForController(controller), "AAE_ZombieHealthModel_" .. tostring(self.enittyNum)) , "visibility"))			
				if is_visibility and is_visibility == 1 then
					self.RedBar:beginAnimation("keyframe", 150, true, true, CoD.TweenType.Linear)
					moveWhiteFlash( ModelValue, self.WhiteFlash )
				end
			end
			self.WhiteBar:beginAnimation("keyframe", 400, true, true, CoD.TweenType.Linear)
			self.WhiteBar:setRGB(1,1,1)
			self.RedBar:setShaderVector(0, ModelValue)
			self.WhiteBar:setShaderVector(0, ModelValue)
		end
	end)
	
	self:linkToElementModel( self, "priority", true, function ( model )
		local ModelValue = Engine.GetModelValue(model)
		if ModelValue then
			self:setPriority( ModelValue )--ModelValue = 0
		end
	end)
	
	self:linkToElementModel( self, "ai_icon", true, function ( model )
		local ModelValue = Engine.GetModelValue(model)
		if ModelValue then
			self.currenthealth = 1
			self.WhiteBar:setRGB(1,1,1)		
			self.RedBar:setShaderVector(0, 1, 0, 0, 0) 
			self.WhiteBar:setShaderVector(0, 1, 0, 0, 0) 
			if ModelValue == "none" then
				self.Dot:setAlpha(0)
			else
				self.Dot:setAlpha(1)
				self.Dot:setImage(RegisterImage(ModelValue))
			end
		end
	end)
	
	self:linkToElementModel( self, "ai_name", true, function ( model )
		local ModelValue = Engine.GetModelValue(model)
		if ModelValue then
			self.currenthealth = 1
			self.WhiteBar:setRGB(1,1,1)
			self.RedBar:setShaderVector(0, 1, 0, 0, 0) 
			self.WhiteBar:setShaderVector(0, 1, 0, 0, 0) 
			self.HealthBarName:setText( Engine.Localize( ModelValue ) )
		end
	end)

	self:linkToElementModel( self, "visibility", true, function ( model )
		local ModelValue = Engine.GetModelValue(model)
		if ModelValue and self.enittyNum then
			if ModelValue == 1 then
				self:setScale(1)
			elseif ModelValue == 2 then
				self:setScale(0)
			else
				self:setScale(0)
			end
		end
	end)

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.BlackBar:close()
		element.WhiteBar:close()
		element.RedBar:close()
		element.HealthBarName:close()
		element.Dot:close()
		element.WhiteFlash:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

