require( "ui.uieditor.widgets.HUD.Waypoint.GenericWaypointContainer" )
require( "ui.uieditor.widgets.MPHudWidgets.WaypointBase" )
require( "ui.uieditor.widgets.MPHudWidgets.WaypointWidgetContainer" )
require( "ui.uieditor.widgets.DynamicContainerWidget" )

CoD.GetCachedObjective = function ( objectiveName )
	if objectiveName == nil then
		return nil
	elseif CoD.Zombie.ObjectivesTable[objectiveName] ~= nil then
		return CoD.Zombie.ObjectivesTable[objectiveName]
	end

	local objectiveInfo = Engine.GetObjectiveInfo( objectiveName )

	if objectiveInfo ~= nil then
		CoD.Zombie.ObjectivesTable[objectiveName] = objectiveInfo
	end

	return objectiveInfo
end

local SetupWaypoint = function ( element, event )
    local gameTypeContainer = CoD.GenericWaypointContainer.new( element.menu, event.controller )
    gameTypeContainer:setLeftRight( true, true, 0, 0 )
    gameTypeContainer:setTopBottom( true, true, 0, 0 )
    element:addElement( gameTypeContainer )
    element.gameTypeContainer = gameTypeContainer

	element.gameTypeContainer.objective = element.objective
	element.gameTypeContainer:setupWaypointContainer( event )
end

local PostLoadFunc2 = function ( self, controller )
	local ButtonPrompt = function ( interactPromptContainer, objective_properties )
		local controller2 = objective_properties.controller or controller
		local ObjectiveName = Engine.GetObjectiveName( controller2, objective_properties.objId )
		local CachedObjective = CoD.GetCachedObjective( ObjectiveName )
		if CachedObjective == nil then
			return 
		end
		local objective_model = Engine.GetModel( Engine.GetModelForController( controller2 ), "objective" .. objective_properties.objId )
		local objectivestate_model = objective_model and Engine.GetModel( objective_model, "state" )
		local direction_model = objective_model and Engine.CreateModel( objective_model, "clamped" )
		direction_model = objective_model and Engine.CreateModel( objective_model, "direction" )
		local objectivestate = CoD.OBJECTIVESTATE_EMPTY
		
		local ButtonPrompt3d = self.interactPromptContainer["button" .. objective_properties.objId]
		if ButtonPrompt3d ~= nil then
			objectivestate = ButtonPrompt3d.state
		end
		local state_check = Engine.GetObjectiveState( controller2, objective_properties.objId )
		if state_check == CoD.OBJECTIVESTATE_ACTIVE or state_check == CoD.OBJECTIVESTATE_INVISIBLE then
	
			if ButtonPrompt3d == nil then
				if CoD.isCampaign or CoD.isZombie then
					ButtonPrompt3d = CoD.ButtonPrompt3dCPZM.new( self, controller2 )
				else
					ButtonPrompt3d = CoD.ButtonPrompt3d.new( self, controller2 )
				end
				ButtonPrompt3d.objective = CachedObjective
				ButtonPrompt3d:setupEntity( objective_properties )
				ButtonPrompt3d:setModel( objective_model )
				self.interactPromptContainer:addElement( ButtonPrompt3d )
				self.interactPromptContainer["button" .. objective_properties.objId] = ButtonPrompt3d
				ButtonPrompt3d:subscribeToModel( objectivestate_model, function ( model )
					local modelValue = Engine.GetModelValue( model )
					if modelValue ~= CoD.OBJECTIVESTATE_ACTIVE and modelValue ~= CoD.OBJECTIVESTATE_INVISIBLE then
						ButtonPrompt3d:close()
					elseif modelValue == CoD.OBJECTIVESTATE_ACTIVE then
						ButtonPrompt3d:show()
					else
						ButtonPrompt3d:hide()
					end
				end )
			else
				ButtonPrompt3d.objective = CachedObjective
				ButtonPrompt3d:setupEntity( objective_properties )
			end
			ButtonPrompt3d.state = state_check
		end
		return true
	end
	self:subscribeToModel( Engine.CreateModel( Engine.GetModelForController( controller ), "newObjectiveType" .. Enum.ObjectiveTypes.OBJECTIVE_TYPE_3DPROMPT ), function ( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			ButtonPrompt( self.interactPromptContainer, {controller = controller, objId = ModelValue , objType = Enum.ObjectiveTypes.OBJECTIVE_TYPE_3DPROMPT} )
		end	
	end, false )
end

local PostLoadFunc = function ( self, controller )
	local CreateObjective = function ( element, event )
		local objectiveName = Engine.GetObjectiveName( event.controller, event.objId )

		local cachedObjective = CoD.GetCachedObjective( objectiveName )

		if cachedObjective == nil then
			return 
		elseif Dvar.cg_luiDebug:get() == true then
			DebugPrint( "Waypoint ID " .. event.objId .. ": " .. objectiveName .. ": " .. #element.WaypointContainerList .. " waypoints active" )
		end

		if not element.savedStates then
			element.savedStates = {}
			element.savedEntNums = {}
			element.savedObjectiveNames = {}
			element.savedTeam = -1
			element.savedRound = -1
		end

		local objectiveState = Engine.GetObjectiveState( controller, event.objId )

		local savedState = element.savedStates[event.objId]

		if not savedState then
			savedState = CoD.OBJECTIVESTATE_EMPTY
		end

		local controllerModel = Engine.GetModelForController( event.controller )
		local objectiveIdModel = Engine.GetModel( controllerModel, "objective" .. event.objId )
		local objectiveStateModel = Engine.GetModel( objectiveIdModel, "state" )
		local entNum = CoD.SafeGetModelValue( objectiveIdModel, "entNum" )
		local teamId = CoD.GetTeamID( controller )
		local roundsPlayed = Engine.GetRoundsPlayed( controller )

		if teamId ~= element.savedTeam or roundsPlayed ~= element.savedRound then
			element.savedStates = {}
			element.savedEntNums = {}
			element.savedObjectiveNames = {}
		end

		if not CoD.isCampaign and Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED ) and objectiveState == savedState and entNum == element.savedEntNums[event.objId] and objectiveName == element.savedObjectiveNames[event.objId] then
			if objectiveStateModel ~= nil then
				Engine.ForceNotifyModelSubscriptions( objectiveStateModel )
			end

			return
		elseif objectiveStateModel ~= nil then
			local waypointWidgetContainer = Engine.GetModelValue( objectiveStateModel )

			Engine.SetModelValue( objectiveStateModel, CoD.OBJECTIVESTATE_EMPTY )
			Engine.SetModelValue( objectiveStateModel, waypointWidgetContainer )
		end

		element.savedStates[event.objId] = objectiveState
		element.savedEntNums[event.objId] = entNum
		element.savedObjectiveNames[event.objId] = objectiveName
		element.savedTeam = teamId
		element.savedRound = roundsPlayed

		if objectiveName then
			local waypointWidgetContainer = CoD.WaypointWidgetContainer.new( element, event.controller )
			waypointWidgetContainer.objective = cachedObjective
			waypointWidgetContainer.setupWaypoint = SetupWaypoint
			waypointWidgetContainer:setupWaypoint( event )
			waypointWidgetContainer:setLeftRight( true, true, 0, 0 )
			waypointWidgetContainer:setTopBottom( true, true, 0, 0 )
			element:addElement( waypointWidgetContainer )

			table.insert( element.WaypointContainerList, waypointWidgetContainer )

			waypointWidgetContainer:update( event )
			waypointWidgetContainer:setModel( objectiveIdModel )

			waypointWidgetContainer:subscribeToModel( objectiveStateModel, function ( model )
				local modelValue = Engine.GetModelValue( model )

				element.savedStates[event.objId] = modelValue
                
				if modelValue == CoD.OBJECTIVESTATE_ACTIVE
				or modelValue == CoD.OBJECTIVESTATE_CURRENT
				or modelValue == CoD.OBJECTIVESTATE_DONE then
					waypointWidgetContainer:show()
					waypointWidgetContainer:update( {
						controller = event.controller,
						objState = modelValue
					} )
				elseif modelValue == CoD.OBJECTIVESTATE_EMPTY then
					element:removeWaypoint( event.objId )
					element.savedEntNums[event.objId] = nil
				else
					waypointWidgetContainer:hide()
				end
			end )

			local updateTimeModel = Engine.GetModel( objectiveIdModel, "updateTime" )

			if updateTimeModel ~= nil then
				waypointWidgetContainer:subscribeToModel( updateTimeModel, function ( model )
					waypointWidgetContainer:update( {
						controller = event.controller
					} )
				end )
			end

			waypointWidgetContainer:subscribeToModel( Engine.GetModel( objectiveIdModel, "progress" ), function ( model )
				waypointWidgetContainer:update( {
					controller = event.controller,
					progress = Engine.GetModelValue( model )
				} )
			end )

			waypointWidgetContainer:subscribeToModel( Engine.GetModel( objectiveIdModel, "clientUseMask" ), function ( model )
				waypointWidgetContainer:update( {
					controller = event.controller,
					clientUseMask = Engine.GetModelValue( model )
				} )
			end )

			local colorBlindModeModel = Engine.GetModel( controllerModel, "profile.colorBlindMode" )

			if colorBlindModeModel then
				waypointWidgetContainer:subscribeToModel( colorBlindModeModel, function ( model )
					waypointWidgetContainer:update( {
						controller = event.controller
					} )
				end, false )
			end
		end

		return true
	end
	
	self.WaypointBase.WaypointContainerList = {}

	CoD.Zombie.ObjectivesTable = Engine.BuildObjectivesTable()

	if CoD.Zombie.ObjectivesTable == nil or #CoD.Zombie.ObjectivesTable == 0 then
		error( "LUI Error: Failed to load objectives.json!" )
	end

	for index = #CoD.Zombie.ObjectivesTable, 1, -1 do
		local objectiveName = CoD.Zombie.ObjectivesTable[index]

		CoD.Zombie.ObjectivesTable[objectiveName.id] = objectiveName

		table.remove( CoD.Zombie.ObjectivesTable, index )
	end

	self:subscribeToModel( Engine.CreateModel( Engine.GetModelForController( controller ), "newObjectiveType" .. Enum.ObjectiveTypes.OBJECTIVE_TYPE_WAYPOINT ), function ( model )
		CreateObjective( self.WaypointBase, {
			controller = controller,
			objId = Engine.GetModelValue( model ),
			objType = Enum.ObjectiveTypes.OBJECTIVE_TYPE_WAYPOINT
		} )
	end, false )

	-- PostLoadFunc2(self, controller)
end

CoD.KingslayerWaypointsContainer = InheritFrom( LUI.UIElement )
CoD.KingslayerWaypointsContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.KingslayerWaypointsContainer )
	self.id = "KingslayerWaypointsContainer"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	
	self.WaypointBase = CoD.WaypointBase.new( self, controller )
	self.WaypointBase:setLeftRight( false, false, -640, 640 )
	self.WaypointBase:setTopBottom( false, false, -360, 360 )
	self.WaypointBase:registerEventHandler( "menu_loaded", function ( element, event )
		local retVal = nil

		SizeToSafeArea( element, controller )

		if not retVal then
			retVal = element:dispatchEventToChildren( event )
		end

		return retVal
	end )
	self:addElement( self.WaypointBase )

    -- local interactPromptContainer = CoD.DynamicContainerWidget.new( menu, controller )
    -- interactPromptContainer:setLeftRight( true, true, 0, 0 )
    -- interactPromptContainer:setTopBottom( true, true, 0, 0 )
    -- self:addElement( interactPromptContainer )
    -- self.interactPromptContainer = interactPromptContainer

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.WaypointBase:close()
        -- element.interactPromptContainer:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
