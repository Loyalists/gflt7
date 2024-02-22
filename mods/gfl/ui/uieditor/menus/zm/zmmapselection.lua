require( "ui.uieditor.widgets.Lobby.Common.FE_ButtonPanelShaderContainer" )
require( "ui.uieditor.widgets.Lobby.LobbyStreamerBlackFade" )
require( "ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame" )
require( "ui.uieditor.widgets.List1Button_Playlist" )
require( "ui.uieditor.widgets.Scrollbars.verticalScrollbar" )
require( "ui.uieditor.widgets.MP.MatchSettings.matchSettingsInfo" )
require( "ui.uieditor.widgets.Lobby.Common.FE_Menu_LeftGraphics" )

local f0_local0 = function ( f1_arg0, f1_arg1 )
	if not CoD.useMouse then
		return 
	else
		LUI.OverrideFunction_CallOriginalFirst( f1_arg0, "setState", function ( element, controller )
			if IsSelfInState( f1_arg0, "SelectingMap" ) then
				f1_arg0.mapList:setMouseDisabled( false )
				f1_arg0.mapCategoriesList:setMouseDisabled( true )
				f1_arg0.m_categorySet = false
			else
				f1_arg0.mapList:setMouseDisabled( true )
				f1_arg0.mapCategoriesList:setMouseDisabled( false )
			end
		end )
		f1_arg0.mapList:setMouseDisabled( true )
		f1_arg0.mapList:registerEventHandler( "leftclick_outside", function ( element, event )
			if IsSelfInState( f1_arg0, "SelectingMap" ) and f1_arg0.m_categorySet then
				CoD.PCUtil.SimulateButtonPress( f1_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE )
			end
			f1_arg0.m_categorySet = true
			return true
		end )
	end
end

local PostLoadFunc = function ( f4_arg0, f4_arg1 )
	f0_local0( f4_arg0, f4_arg1 )
end

local f0_local2 = 10000
local f0_local3 = 10001

local sort_map_index = function ( mapname )
	if mapname == "zm_prototype" or mapname == "zm_asylum" or mapname == "zm_cosmodrome" or mapname == "zm_moon" or mapname == "zm_sumpf" or mapname == "zm_temple" or mapname == "zm_theater" or mapname == "zm_tomb" then
		return CoD.CONTENT_ORIGINAL_MAP_INDEX
	end
	if mapname == "zm_factory" or mapname == "zm_castle" or mapname == "zm_island" or mapname == "zm_stalingrad" or mapname == "zm_genesis" then
		return CoD.CONTENT_ORIGINAL_MAP_INDEX
	end
	if mapname == "zm_zod" then		
		return CoD.CONTENT_ORIGINAL_MAP_INDEX
	end
end

DataSources.ZMMapCategoriesDataSource = DataSourceHelpers.ListSetup( "ZMMapCategoriesDataSource", function ( f6_arg0 )
	local categories_array = {}
	local current_dlcIndex = CoD.GetMapValue( Engine.DvarString( nil, "ui_mapname" ), "dlc_pack", CoD.CONTENT_ORIGINAL_MAP_INDEX )

	local add_to_categories = function ( mapCategory, dlcIndex )
			return {
				models = { text = Engine.Localize( "MPUI_MAP_CATEGORY_" .. mapCategory .. "_CAPS" ), buttonText = Engine.Localize( "MPUI_MAP_CATEGORY_" .. mapCategory .. "_CAPS" ), image = "playlist_map", description = Engine.Localize( "MPUI_MAP_CATEGORY_" .. mapCategory .. "_DESC" ) },
				properties = { category = dlcIndex, selectIndex = current_dlcIndex == dlcIndex }
			}
	end

	local add_to_categories_custommap = function ( mapCategory, dlcIndex , button_text , desc_text)
			return {
				models = { text = Engine.Localize( button_text ), buttonText = Engine.Localize( button_text ), image = "playlist_map", description = Engine.Localize( desc_text ) },
				properties = { category = dlcIndex, selectIndex = current_dlcIndex == dlcIndex }
			}
	end
	CoD.mapsTable = Engine.GetGDTMapsTable()
	table.insert( categories_array, add_to_categories( "standard", CoD.CONTENT_ORIGINAL_MAP_INDEX ) )
	local UserMaps = Engine.Mods_Lists_GetInfoEntries( LuaEnums.USERMAP_BASE_PATH, 0, Engine.Mods_Lists_GetInfoEntriesCount( LuaEnums.USERMAP_BASE_PATH ) )
	if Mods_Enabled() and UserMaps and #UserMaps > 0 then
		table.insert( categories_array, add_to_categories( "mods", CoD.CONTENT_MODS_INDEX ) )
	end
	return categories_array
end, true )

DataSources.ZMMapListDataSource = DataSourceHelpers.ListSetup( "ZMMapListDataSource", function ( menu, controller )
	local MapList = {}

	local checkUniqueID = function ( mapname, mapname2 )
		return CoD.mapsTable[mapname].unique_id < CoD.mapsTable[mapname2].unique_id
	end
	
	local check_gameModeEnum = function ( mapname )
		if CoD.gameModeEnum ~= CoD.mapsTable[mapname].session_mode then
			return false
		end
		return sort_map_index( mapname ) == CoD.perController[menu].mapCategory
	end
	
	local mapsTable = CoD.mapsTable
	local sessionMode_Check = Engine.SessionModeIsMode( CoD.SESSIONMODE_OFFLINE )
	local currentmap = Engine.DvarString( nil, "ui_mapname" )

	if sessionMode_Check == false then
		for i, map in LUI.IterateTableBySortedKeys( mapsTable, checkUniqueID, check_gameModeEnum ) do
			local map_models = { models = { text = Engine.Localize( map.mapName ), buttonText = LocalizeToUpperString( CoD.StoreUtility.PrependPurchaseIconIfNeeded( menu, i, map.mapName ) ), image = map.previewImage, description = Engine.Localize( CoD.StoreUtility.AddUpsellToDescriptionIfNeeded( menu, i, map.mapDescription ) ), dlcIndex = map.dlc_pack } }
			local properties = { mapName = i, selectIndex = i == currentmap }
			properties.disabled = false
			properties.purchasable = not Engine.IsMapValid( i )
			map_models.properties = properties
			table.insert( MapList, map_models )
		end
	end
	--if Mods_Enabled() and CoD.perController[menu].mapCategory == CoD.CONTENT_MODS_INDEX then
	if Mods_Enabled() then
		local UserMaps = Engine.Mods_Lists_GetInfoEntries( LuaEnums.USERMAP_BASE_PATH, 0, Engine.Mods_Lists_GetInfoEntriesCount( LuaEnums.USERMAP_BASE_PATH ) )
		if UserMaps then
			for i = 0, #UserMaps, 1 do
				if LUI.startswith( UserMaps[i].internalName, "zm_" ) then
					if CoD.perController[menu].mapCategory == CoD.CONTENT_MODS_INDEX then
						table.insert( MapList, { models = { text = UserMaps[i].name, buttonText = LocalizeToUpperString(string.sub( UserMaps[i].name, 1, 32 )), image = UserMaps[i].ugcName, description = UserMaps[i].description }, properties = { mapName = UserMaps[i].ugcName, selectIndex = i == currentmap } } )
					end
				end
			end
		end
	end
	CoD.StoreUtility.AddListDLCListener( controller )
	return MapList
end, true )

LUI.createMenu.ZMMapSelection = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "ZMMapSelection" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "default"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	Engine.Mods_Lists_UpdateUsermaps()
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "ZMMapSelection.buttonPrompts" )
	self.anyChildUsesUpdateState = true
	
	local LeftPanel = CoD.FE_ButtonPanelShaderContainer.new( self, controller )
	LeftPanel:setLeftRight( true, true, -45, 35 )
	LeftPanel:setTopBottom( true, true, -43, 102 )
	LeftPanel:setRGB( 0.31, 0.31, 0.31 )
	self:addElement( LeftPanel )
	self.LeftPanel = LeftPanel
	
	local FadeForStreamer = CoD.LobbyStreamerBlackFade.new( self, controller )
	FadeForStreamer:setLeftRight( true, false, 0, 1280 )
	FadeForStreamer:setTopBottom( true, false, 0, 720 )
	FadeForStreamer:mergeStateConditions( {
		{
			stateName = "Transparent",
			condition = function ( menu, element, event )
				return IsGlobalModelValueEqualTo( element, controller, "hideWorldForStreamer", 0 )
			end
		}
	} )
	FadeForStreamer:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "hideWorldForStreamer" ), function ( model )
		self:updateElementState( FadeForStreamer, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hideWorldForStreamer"
		} )
	end )
	self:addElement( FadeForStreamer )
	self.FadeForStreamer = FadeForStreamer
	
	local frame = CoD.GenericMenuFrame.new( self, controller )
	frame:setLeftRight( true, true, 0, 0 )
	frame:setTopBottom( true, true, 0, 0 )
	frame.titleLabel:setText( Engine.Localize( "MPUI_CHANGE_MAP_CAPS" ) )
	frame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText( Engine.Localize( "MPUI_CHANGE_MAP_CAPS" ) )
	self:addElement( frame )
	self.frame = frame
	
	local mapCategoriesList = LUI.UIList.new( self, controller, 2, 0, nil, false, false, 0, 0, false, false )
	mapCategoriesList:makeFocusable()
	mapCategoriesList:setLeftRight( true, false, 67, 347 )
	mapCategoriesList:setTopBottom( true, false, 109, 277 )
	mapCategoriesList:setWidgetType( CoD.List1Button_Playlist )
	mapCategoriesList:setVerticalCount( 16 )
	mapCategoriesList:setDataSource( "ZMMapCategoriesDataSource" )
	mapCategoriesList:registerEventHandler( "gain_focus", function ( element, event )
		local f17_local0 = nil
		if element.gainFocus then
			f17_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f17_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f17_local0
	end )
	mapCategoriesList:registerEventHandler( "lose_focus", function ( element, event )
		local f18_local0 = nil
		if element.loseFocus then
			f18_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f18_local0 = element.super:loseFocus( event )
		end
		return f18_local0
	end )
	self:AddButtonCallbackFunction( mapCategoriesList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, model )
		SetElementPropertyOnPerControllerTable( controller, "mapCategory", element, "category" )
		UpdateElementDataSource( self, "mapList" )
		SetMenuState( menu, "SelectingMap" )
		SetLoseFocusToElement( self, "mapCategoriesList", controller )
		MakeElementNotFocusable( self, "mapCategoriesList", controller )
		MakeElementFocusable( self, "mapList", controller )
		SetFocusToElement( self, "mapList", controller )
		PlaySoundSetSound( self, "list_action" )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	mapCategoriesList:mergeStateConditions( {
		{
			stateName = "Disabled_NoListFocus",
			condition = function ( menu, element, event )
				local f21_local0
				if not IsParentListInFocus( element ) then
					f21_local0 = IsDisabled( element, controller )
				else
					f21_local0 = false
				end
				return f21_local0
			end
		},
		{
			stateName = "NoListFocus",
			condition = function ( menu, element, event )
				return not IsParentListInFocus( element )
			end
		}
	} )
	mapCategoriesList:linkToElementModel( mapCategoriesList, "disabled", true, function ( model )
		self:updateElementState( mapCategoriesList, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "disabled"
		} )
	end )
	self:addElement( mapCategoriesList )
	self.mapCategoriesList = mapCategoriesList
	
	local mapList = LUI.UIList.new( self, controller, 2, 0, nil, false, false, 0, 0, false, false )
	mapList:makeFocusable()
	mapList:setLeftRight( true, false, 287, 567 )
	mapList:setTopBottom( true, false, 109, 651 )
	mapList:setWidgetType( CoD.List1Button_Playlist )
	mapList:setVerticalCount( 16 )
	mapList:setVerticalScrollbar( CoD.verticalScrollbar )
	mapList:setDataSource( "ZMMapListDataSource" )
	mapList:registerEventHandler( "gain_focus", function ( element, event )
		local f24_local0 = nil
		if element.gainFocus then
			f24_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f24_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f24_local0
	end )
	mapList:registerEventHandler( "lose_focus", function ( element, event )
		local f25_local0 = nil
		if element.loseFocus then
			f25_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f25_local0 = element.super:loseFocus( event )
		end
		return f25_local0
	end )

	self:AddButtonCallbackFunction( mapList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( f26_arg0, f26_arg1, f26_arg2, f26_arg3 )
		if not IsElementPropertyValue( f26_arg0, "purchasable", true ) then
			MapSelected( f26_arg0, f26_arg2 )
			self.mapSelected = true
			GoBack( self, f26_arg2 )
			ClearSavedState( self, f26_arg2 )
			-- PlaySoundSetSound( self, "action" )
			return true
		else
			OpenPurchaseMapPackConfirmation( f26_arg2, f26_arg0, "ZMMapSelect", f26_arg1 )
			return true
		end
	end, function ( f27_arg0, f27_arg1, f27_arg2 )
		CoD.Menu.SetButtonLabel( f27_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )

	mapList:mergeStateConditions( {
		{
			stateName = "Disabled_NoListFocus",
			condition = function ( menu, element, event )
				local f28_local0
				if not IsParentListInFocus( element ) then
					f28_local0 = IsDisabled( element, controller )
				else
					f28_local0 = false
				end
				return f28_local0
			end
		},
		{
			stateName = "NoListFocus",
			condition = function ( menu, element, event )
				return not IsParentListInFocus( element )
			end
		}
	} )
	mapList:linkToElementModel( mapList, "disabled", true, function ( model )
		self:updateElementState( mapList, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "disabled"
		} )
	end )
	self:addElement( mapList )
	self.mapList = mapList
	
	local categoryInfo = CoD.matchSettingsInfo.new( self, controller )
	categoryInfo:setLeftRight( true, false, 600, 1050 )
	categoryInfo:setTopBottom( true, false, 109, 659 )
	categoryInfo.FRBestTime.BestTimeValueText:setText( Engine.Localize( "--:--:--" ) )
	categoryInfo:mergeStateConditions( {
		{
			stateName = "AspectRatio_1x1",
			condition = function ( menu, element, event )
				return AlwaysTrue()
			end
		}
	} )
	self:addElement( categoryInfo )
	self.categoryInfo = categoryInfo
	
	local mapInfo = CoD.matchSettingsInfo.new( self, controller )
	mapInfo:setLeftRight( true, false, 600, 1216 )
	mapInfo:setTopBottom( true, false, 109, 736.84 )
	mapInfo.FRBestTime.BestTimeValueText:setText( Engine.Localize( "--:--:--" ) )
	mapInfo:mergeStateConditions( {
		{
			stateName = "AspectRatio_1x1",
			condition = function ( menu, element, event )
				return AlwaysFalse()
			end
		}
	} )
	self:addElement( mapInfo )
	self.mapInfo = mapInfo
	
	local FEMenuLeftGraphics = CoD.FE_Menu_LeftGraphics.new( self, controller )
	FEMenuLeftGraphics:setLeftRight( true, false, 19, 71 )
	FEMenuLeftGraphics:setTopBottom( true, false, 84, 701.25 )
	self:addElement( FEMenuLeftGraphics )
	self.FEMenuLeftGraphics = FEMenuLeftGraphics
	
	categoryInfo:linkToElementModel( mapCategoriesList, nil, false, function ( model )
		categoryInfo:setModel( model, controller )
	end )
	mapInfo:linkToElementModel( mapList, nil, false, function ( model )
		mapInfo:setModel( model, controller )
	end )
	mapCategoriesList.navigation = {
		right = mapList
	}
	mapList.navigation = {
		left = mapCategoriesList
	}
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				frame:completeAnimation()
				self.frame:setAlpha( 1 )
				self.clipFinished( frame, {} )
				mapList:completeAnimation()
				self.mapList:setAlpha( 0 )
				self.clipFinished( mapList, {} )
				categoryInfo:completeAnimation()
				self.categoryInfo:setAlpha( 1 )
				self.clipFinished( categoryInfo, {} )
				mapInfo:completeAnimation()
				self.mapInfo:setAlpha( 0 )
				self.clipFinished( mapInfo, {} )
			end
		},
		SelectingMap = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				frame:completeAnimation()
				self.frame:setAlpha( 1 )
				self.clipFinished( frame, {} )
				mapList:completeAnimation()
				self.mapList:setAlpha( 1 )
				self.clipFinished( mapList, {} )
				categoryInfo:completeAnimation()
				self.categoryInfo:setAlpha( 0 )
				self.clipFinished( categoryInfo, {} )
				mapInfo:completeAnimation()
				self.mapInfo:setAlpha( 1 )
				self.clipFinished( mapInfo, {} )
			end
		}
	}
	CoD.Menu.AddNavigationHandler( self, self, controller )
	self:registerEventHandler( "menu_loaded", function ( self, event )
		local f37_local0 = nil
		MakeElementNotFocusable( self, "mapList", controller )
		if not f37_local0 then
			f37_local0 = self:dispatchEventToChildren( event )
		end
		return f37_local0
	end )
	self:registerEventHandler( "menu_opened", function ( self, event )
		local f38_local0 = nil
		SetElementStateByElementName( self, "frame", controller, "Update" )
		PlayClipOnElement( self, {
			elementName = "frame",
			clipName = "Intro"
		}, controller )
		PlayClip( self, "Intro", controller )
		if not f38_local0 then
			f38_local0 = self:dispatchEventToChildren( event )
		end
		return f38_local0
	end )
	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, model )
		if IsMenuInState( menu, "DefaultState" ) then
			Engine.UpdateModPreviewImage( Engine.DvarString(nil , "ui_mapname") )
			GoBack( self, controller )
			return true
		else
			SetPerControllerTableProperty( controller, "mapCategory", nil )
			SetMenuState( menu, "DefaultState" )
			SetLoseFocusToElement( self, "mapList", controller )
			MakeElementNotFocusable( self, "mapList", controller )
			MakeElementFocusable( self, "mapCategoriesList", controller )
			SetFocusToElement( self, "mapCategoriesList", controller )
			PlaySoundSetSound( self, "menu_go_back" )
			return true
		end
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )
		return true
	end, false )
	frame:setModel( self.buttonModel, controller )
	mapCategoriesList.id = "mapCategoriesList"
	mapList.id = "mapList"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = self
	} )
	if not self:restoreState() then
		self.mapCategoriesList:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.LeftPanel:close()
		element.FadeForStreamer:close()
		element.frame:close()
		element.mapCategoriesList:close()
		element.mapList:close()
		element.categoryInfo:close()
		element.mapInfo:close()
		element.FEMenuLeftGraphics:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "ZMMapSelection.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

