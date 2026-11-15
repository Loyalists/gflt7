require("ui.uieditor.widgets.StartMenu.StartMenu_frame_noBG")
require("ui.uieditor.widgets.Lobby.Common.FE_FocusBarContainer")
local configureInputCallbacks = function (self, controller, menu)
	self:registerEventHandler("options_refresh", function (Sender, Event)
		Sender:processEvent({name = "update_state", controller = Event.controller})
	end)
	CoD.Menu.AddButtonCallbackFunction(menu, self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function (element, menu, controller, event)
		if not self.disabled and not menu.m_disableNavigation and menu:AcceptGamePadButtonInputFromModelCallback(controller) then
			if type(self.navAction) == "function" then
				self.navAction(controller, self, menu, controller)
				self:processEvent({name = "update_state", controller = controller})
			end
			return true
		else

		end
	end)
end

CoD.TFOptions_NavButton = InheritFrom(LUI.UIElement)
CoD.TFOptions_NavButton.new = function (HudRef, controller)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, controller)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.TFOptions_NavButton)
	Widget.id = "TFOptions_NavButton"
	Widget.soundSet = "ChooseDecal"
	Widget:setLeftRight(true, false, 0, 500)
	Widget:setTopBottom(true, false, 0, 34)
	Widget:makeFocusable()
	Widget:setHandleMouse(true)
	Widget.anyChildUsesUpdateState = true
	local fullBacking = LUI.UIImage.new()
	fullBacking:setLeftRight(true, true, 0, 0)
	fullBacking:setTopBottom(true, true, 0, 0)
	fullBacking:setRGB(0.1, 0.1, 0.1)
	fullBacking:setAlpha(0)
	Widget:addElement(fullBacking)
	Widget.fullBacking = fullBacking
	
	local fullBorder = CoD.StartMenu_frame_noBG.new(HudRef, controller)
	fullBorder:setLeftRight(true, true, 0, 0)
	fullBorder:setTopBottom(true, true, 0, 0)
	fullBorder:setRGB(0.87, 0.37, 0)
	fullBorder:setAlpha(0)
	Widget:addElement(fullBorder)
	Widget.fullBorder = fullBorder
	
	local labelText = LUI.UITightText.new()
	labelText:setLeftRight(true, false, 9.34, 500)
	labelText:setTopBottom(true, false, 4.5, 29.5)
	labelText:setTTF("fonts/default.ttf")
	labelText:linkToElementModel(Widget, "label", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			labelText:setText(Engine.Localize(ModelValue))
		end
	end)
	Widget:addElement(labelText)
	Widget.labelText = labelText
	
	local startMenuframenoBG00 = CoD.StartMenu_frame_noBG.new(HudRef, controller)
	startMenuframenoBG00:setLeftRight(true, true, 0, 0)
	startMenuframenoBG00:setTopBottom(true, true, 0, 0)
	Widget:addElement(startMenuframenoBG00)
	Widget.StartMenuframenoBG00 = startMenuframenoBG00
	
	local focusBarT = CoD.FE_FocusBarContainer.new(HudRef, controller)
	focusBarT:setLeftRight(true, true, 2, 0)
	focusBarT:setTopBottom(true, false, 0, 4)
	focusBarT:setAlpha(0)
	focusBarT:setZoom(1)
	Widget:addElement(focusBarT)
	Widget.FocusBarT = focusBarT
	
	local focusBarB = CoD.FE_FocusBarContainer.new(HudRef, controller)
	focusBarB:setLeftRight(true, true, 0, 0)
	focusBarB:setTopBottom(false, true, -5.5, 0)
	focusBarB:setAlpha(0)
	focusBarB:setZoom(1)
	Widget:addElement(focusBarB)
	Widget.FocusBarB = focusBarB
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(7)
		fullBorder:completeAnimation()
		Widget.fullBorder:setAlpha(0)
		Widget.clipFinished(fullBorder, {})
		labelText:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(labelText, {})
		focusBarT:completeAnimation()
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(focusBarT, {})
		focusBarB:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
		focusBarB:setAlpha(0)
		focusBarB:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
	end, Focus = function ()
		Widget:setupElementClipCounter(7)
		fullBorder:completeAnimation()
		Widget.fullBorder:setAlpha(1)
		Widget.clipFinished(fullBorder, {})
		labelText:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(labelText, {})
		focusBarT:completeAnimation()
		Widget.FocusBarT:setLeftRight(true, true, 0, 0)
		Widget.FocusBarT:setTopBottom(true, false, 0, 4)
		Widget.FocusBarT:setAlpha(1)
		Widget.clipFinished(focusBarT, {})
		focusBarB:completeAnimation()
		Widget.FocusBarB:setLeftRight(true, true, 0, 0)
		Widget.FocusBarB:setTopBottom(false, true, -5.5, 0)
		Widget.FocusBarB:setAlpha(1)
		Widget.clipFinished(focusBarB, {})
	end}, Checked = {DefaultClip = function ()
		Widget:setupElementClipCounter(7)
		fullBorder:completeAnimation()
		Widget.fullBorder:setAlpha(0)
		Widget.clipFinished(fullBorder, {})
		labelText:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(labelText, {})
		focusBarT:completeAnimation()
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(focusBarT, {})
		focusBarB:completeAnimation()
		Widget.FocusBarB:setAlpha(0)
		Widget.clipFinished(focusBarB, {})
	end, Focus = function ()
		Widget:setupElementClipCounter(7)
		fullBorder:completeAnimation()
		Widget.fullBorder:setAlpha(1)
		Widget.clipFinished(fullBorder, {})
		labelText:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(labelText, {})
		focusBarT:completeAnimation()
		Widget.FocusBarT:setLeftRight(true, true, 0, 0)
		Widget.FocusBarT:setTopBottom(true, false, 0, 4)
		Widget.FocusBarT:setAlpha(1)
		local f9_local1 = function (element, event)
			if not event.interrupted then
				element:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
			end
			element:setLeftRight(true, true, 0, 0)
			element:setTopBottom(true, false, 0, 4)
			element:setAlpha(1)
			if event.interrupted then
				Widget.clipFinished(element, event)
			else
				element:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f9_local1(focusBarT, {})
		focusBarB:completeAnimation()
		Widget.FocusBarB:setLeftRight(true, true, 0, 0)
		Widget.FocusBarB:setTopBottom(false, true, -5.5, 0)
		Widget.FocusBarB:setAlpha(1)
		local f9_local2 = function (element, event)
			if not event.interrupted then
				element:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
			end
			element:setLeftRight(true, true, 0, 0)
			element:setTopBottom(false, true, -5.5, 0)
			element:setAlpha(1)
			if event.interrupted then
				Widget.clipFinished(element, event)
			else
				element:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f9_local2(focusBarB, {})
	end}, Disabled = {DefaultClip = function ()
		Widget:setupElementClipCounter(4)
		labelText:completeAnimation()
		Widget.labelText:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(labelText, {})
	end}}
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.fullBorder:close()
		Sender.StartMenuframenoBG00:close()
		Sender.FocusBarT:close()
		Sender.FocusBarB:close()
		Sender.labelText:close()
	end)
	if configureInputCallbacks then
		configureInputCallbacks(Widget, controller, HudRef)
	end
	return Widget
end

