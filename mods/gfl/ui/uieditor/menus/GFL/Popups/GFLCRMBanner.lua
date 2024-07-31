require( "ui.uieditor.widgets.FileShare.FullscreenPopup.FullscreenPopupTemplate" )
require( "ui.uieditor.widgets.Footer.fe_LeftContainer_NOTLobby" )

local PostLoadFunc = function ( f1_arg0, f1_arg1 )

end

LUI.createMenu.GFLCRMBanner = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "GFLCRMBanner" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "default"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "GFLCRMBanner.buttonPrompts" )
	local f2_local1 = self
	self.anyChildUsesUpdateState = true
	
	local FullscreenPopupTemplate = CoD.FullscreenPopupTemplate.new( f2_local1, controller )
	FullscreenPopupTemplate:setLeftRight( true, false, -3.04, 1280.96 )
	FullscreenPopupTemplate:setTopBottom( true, false, 0, 720 )
	FullscreenPopupTemplate.ButtonList:setDataSource( "GFLCRMButtonList" )
	FullscreenPopupTemplate.WorkingTitle:setText( Engine.Localize( "MENU_NEW" ) )
	FullscreenPopupTemplate.Title:setText( Engine.Localize( "GFL_MODINFO_WELCOME_TITLE" ) )
	FullscreenPopupTemplate.Subtitle:setText( Engine.Localize( "GFL_MODINFO_WELCOME_DESC" ) )
	FullscreenPopupTemplate.DoneTitle:setText( Engine.Localize( "MENU_NEW" ) )
	FullscreenPopupTemplate.ErrorSubtitle:setText( Engine.Localize( "MENU_NEW" ) )

	self:addElement( FullscreenPopupTemplate )
	self.FullscreenPopupTemplate = FullscreenPopupTemplate
	
	local leftButtonBar = CoD.fe_LeftContainer_NOTLobby.new( f2_local1, controller )
	leftButtonBar:setLeftRight( true, false, 64, 496 )
	leftButtonBar:setTopBottom( true, false, 531, 563 )
	self:addElement( leftButtonBar )
	self.leftButtonBar = leftButtonBar

	f2_local1:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( f13_arg0, f13_arg1, f13_arg2, f13_arg3 )
		GoBack( self, f13_arg2 )
		return true
	end, function ( f14_arg0, f14_arg1, f14_arg2 )
		CoD.Menu.SetButtonLabel( f14_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_CLOSE" )
		return true
	end, false )

	FullscreenPopupTemplate.id = "FullscreenPopupTemplate"
	leftButtonBar:setModel( self.buttonModel, controller )
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = f2_local1
	} )
	if not self:restoreState() then
		self.FullscreenPopupTemplate:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.FullscreenPopupTemplate:close()
		element.leftButtonBar:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "GFLCRMBanner.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

