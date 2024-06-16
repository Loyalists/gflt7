require( "ui.uieditor.widgets.hud.aae_t9_zombie_health_bar.aae_t9_zombie_health_bar" )

CoD.AAE_t9_zombie_health_bar_container = InheritFrom( LUI.UIElement )
CoD.AAE_t9_zombie_health_bar_container.new = function ( menu, controller )
	
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.AAE_t9_zombie_health_bar_container )
	self.id = "AAE_t9_zombie_health_bar_container"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 0 )
	self:setTopBottom( true, false, 0, 0 )
	self.anyChildUsesUpdateState = true

	--actor start at 24
	--vehicle start at 121
	if not self.t9_zombie_health_bar_widgets_actor then
		self.t9_zombie_health_bar_widgets_actor = {}
	end

	if not self.t9_zombie_health_bar_widgets_vehicle then
		self.t9_zombie_health_bar_widgets_vehicle = {}
	end

	self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "hudItems.spawn_actor_healthbar"), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then 
			if not self.t9_zombie_health_bar_widgets_actor[modelValue - 24] then
				self.t9_zombie_health_bar_widgets_actor[modelValue - 24] = CoD.AAE_t9_zombie_health_bar.new( self, controller )
				self.t9_zombie_health_bar_widgets_actor[modelValue - 24].enittyNum = tostring(modelValue)
				self.t9_zombie_health_bar_widgets_actor[modelValue - 24].AAE_t9_zombie_health_bar_the_bar.enittyNum = tostring(modelValue)
				--self.t9_zombie_health_bar_widgets_actor[modelValue - 24]:setupEntityContainer(modelValue , 0, 0, 75 )
				self.t9_zombie_health_bar_widgets_actor[modelValue - 24]:setModel( Engine.CreateModel( Engine.GetModelForController( controller ) , "AAE_ZombieHealthModel_" .. modelValue ), controller )
				self:addElement( self.t9_zombie_health_bar_widgets_actor[modelValue - 24]  )
			end
		end
	end)

	self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "hudItems.spawn_vehicle_healthbar"), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then 
			if not self.t9_zombie_health_bar_widgets_vehicle[modelValue - 121] then
				self.t9_zombie_health_bar_widgets_vehicle[modelValue - 121] = CoD.AAE_t9_zombie_health_bar.new( self, controller )
				self.t9_zombie_health_bar_widgets_vehicle[modelValue - 121].enittyNum = tostring(modelValue)
				self.t9_zombie_health_bar_widgets_vehicle[modelValue - 121].AAE_t9_zombie_health_bar_the_bar.enittyNum = tostring(modelValue)
				--self.t9_zombie_health_bar_widgets_vehicle[modelValue - 24]:setupEntityContainer(modelValue , 0, 0, 20 )
				self.t9_zombie_health_bar_widgets_vehicle[modelValue - 121]:setModel( Engine.CreateModel( Engine.GetModelForController( controller ) , "AAE_ZombieHealthModel_" .. modelValue ), controller )
				self:addElement( self.t9_zombie_health_bar_widgets_vehicle[modelValue - 121]  )
			end
		end
	end)
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		if element.t9_zombie_health_bar_widgets_actor then
			for i = 1 , #element.t9_zombie_health_bar_widgets_actor, 1 do
				if element.t9_zombie_health_bar_widgets_actor[i] then
					element.t9_zombie_health_bar_widgets_actor[i]:close()
				end
			end
		end
		if element.t9_zombie_health_bar_widgets_vehicle then
			for i = 1 , #element.t9_zombie_health_bar_widgets_vehicle, 1 do
				if element.t9_zombie_health_bar_widgets_vehicle[i] then
					element.t9_zombie_health_bar_widgets_vehicle[i]:close()
				end
			end
		end
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

