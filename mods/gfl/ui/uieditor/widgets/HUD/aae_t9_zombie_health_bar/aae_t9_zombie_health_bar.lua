require( "ui.uieditor.widgets.hud.aae_t9_zombie_health_bar.AAE_t9_zombie_health_bar_the_bar" )

CoD.AAE_t9_zombie_health_bar = InheritFrom( LUI.UIElement )
CoD.AAE_t9_zombie_health_bar.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.AAE_t9_zombie_health_bar )
	self.id = "AAE_t9_zombie_health_bar"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 0 )
	self:setTopBottom( true, false, 0, 0 )
	self:setAlpha(0)
	self.anyChildUsesUpdateState = true	

	local AAE_t9_zombie_health_bar_the_bar = CoD.AAE_t9_zombie_health_bar_the_bar.new( self, controller )
	AAE_t9_zombie_health_bar_the_bar:linkToElementModel( self, nil, false, function ( model )
		AAE_t9_zombie_health_bar_the_bar:setModel( model, controller )
	end )
	self:addElement( AAE_t9_zombie_health_bar_the_bar  )
	self.AAE_t9_zombie_health_bar_the_bar = AAE_t9_zombie_health_bar_the_bar

	self:linkToElementModel( self, "position", true, function ( model )
		local ModelValue = Engine.GetModelValue(model)
		if ModelValue and self.enittyNum then
			local bar_offset = splitString( ModelValue, ",")
			if #bar_offset == 3 then
				local origin_x = tonumber(bar_offset[1])
				local origin_y = tonumber(bar_offset[2])
				local origin_z = tonumber(bar_offset[3])
				--local distance = tonumber(bar_offset[4])
				if origin_x ~= 0 and origin_y ~= 0 and origin_z ~= 0 then
					self:setAlpha(1)
					self:setupGeneric3DWidget( origin_x, origin_y, origin_z)
					--self:setScale(GetBarSize(distance))
				end
			end
			--self:setupEntityContainer(self.enittyNum , 0, 0, ModelValue )
		end
	end)

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.AAE_t9_zombie_health_bar_the_bar:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

