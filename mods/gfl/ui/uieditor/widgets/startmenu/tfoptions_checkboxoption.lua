require("ui.uieditor.widgets.StartMenu.StartMenu_frame_noBG")
require("ui.uieditor.widgets.Lobby.Common.FE_FocusBarContainer")
local configureInputCallbacks = function (self, controller, menu)
	self:registerEventHandler("options_refresh", function (Sender, Event)
		Sender:processEvent({name = "update_state", controller = Event.controller})
	end)
	CoD.Menu.AddButtonCallbackFunction(menu, self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function (element, menu, controller, event)
		if not self.disabled and not menu.m_disableNavigation and menu:AcceptGamePadButtonInputFromModelCallback(controller) then
			if type(self.checkboxAction) == "function" then
				self.checkboxAction(controller, self)
				self:processEvent({name = "update_state", controller = controller})
			end
			return true
		else

		end
	end)
end

CoD.TFOptions_CheckBoxOption = InheritFrom(LUI.UIElement)
CoD.TFOptions_CheckBoxOption.new = function (HudRef, controller)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, controller)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.TFOptions_CheckBoxOption)
	Widget.id = "TFOptions_CheckBoxOption"
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
	
	local checkboxBacking = CoD.StartMenu_frame_noBG.new(HudRef, controller)
	checkboxBacking:setLeftRight(true, true, -8.5, -443.5)
	checkboxBacking:setTopBottom(true, true, -13, 13)
	checkboxBacking:setScale(0.3)
	Widget:addElement(checkboxBacking)
	Widget.checkboxBacking = checkboxBacking
	
	local checkboxBkg = LUI.UIImage.new()
	checkboxBkg:setLeftRight(true, false, 14.75, 33.25)
	checkboxBkg:setTopBottom(true, false, 8.25, 25.75)
	checkboxBkg:setAlpha(0)
	checkboxBkg:setImage(RegisterImage("uie_t7_menu_cacselection_checkbox_empty"))
	Widget:addElement(checkboxBkg)
	Widget.CheckboxBkg = checkboxBkg
	
	local checkboxCheck = LUI.UIImage.new()
	checkboxCheck:setLeftRight(true, false, 14.75, 33.25)
	checkboxCheck:setTopBottom(true, false, 8.25, 25.75)
	checkboxCheck:setImage(RegisterImage("uie_t7_menu_cacselection_checkbox"))
	Widget:addElement(checkboxCheck)
	Widget.checkboxCheck = checkboxCheck
	
	local labelText = LUI.UITightText.new()
	labelText:setLeftRight(true, false, 47, 500)
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
		checkboxBacking:completeAnimation()
		Widget.checkboxBacking:setRGB(0.78, 0.78, 0.78)
		Widget.clipFinished(checkboxBacking, {})
		checkboxBkg:completeAnimation()
		Widget.CheckboxBkg:setRGB(1, 1, 1)
		Widget.CheckboxBkg:setAlpha(1)
		Widget.clipFinished(checkboxBkg, {})
		checkboxCheck:completeAnimation()
		Widget.checkboxCheck:setRGB(1, 0.45, 0)
		Widget.checkboxCheck:setAlpha(0)
		Widget.clipFinished(checkboxCheck, {})
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
		checkboxBacking:completeAnimation()
		Widget.checkboxBacking:setRGB(0.87, 0.37, 0)
		Widget.clipFinished(checkboxBacking, {})
		checkboxBkg:completeAnimation()
		Widget.CheckboxBkg:setRGB(1, 0.41, 0)
		Widget.CheckboxBkg:setAlpha(1)
		Widget.clipFinished(checkboxBkg, {})
		checkboxCheck:completeAnimation()
		Widget.checkboxCheck:setAlpha(0)
		Widget.clipFinished(checkboxCheck, {})
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
		checkboxBacking:completeAnimation()
		Widget.checkboxBacking:setRGB(0.78, 0.78, 0.78)
		Widget.clipFinished(checkboxBacking, {})
		checkboxBkg:completeAnimation()
		Widget.CheckboxBkg:setRGB(1, 1, 1)
		Widget.CheckboxBkg:setAlpha(0.5)
		Widget.clipFinished(checkboxBkg, {})
		checkboxCheck:completeAnimation()
		Widget.checkboxCheck:setRGB(1, 1, 1)
		Widget.checkboxCheck:setAlpha(1)
		local f8_local0 = function (element, event)
			if not event.interrupted then
				element:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
			end
			element:setRGB(1, 1, 1)
			element:setAlpha(1)
			if event.interrupted then
				Widget.clipFinished(element, event)
			else
				element:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f8_local0(checkboxCheck, {})
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
		checkboxBacking:completeAnimation()
		Widget.checkboxBacking:setRGB(0.87, 0.37, 0)
		Widget.clipFinished(checkboxBacking, {})
		checkboxBkg:completeAnimation()
		Widget.CheckboxBkg:setRGB(1, 1, 1)
		Widget.CheckboxBkg:setAlpha(0)
		Widget.clipFinished(checkboxBkg, {})
		checkboxCheck:completeAnimation()
		Widget.checkboxCheck:setRGB(0.87, 0.37, 0)
		Widget.checkboxCheck:setAlpha(1)
		local f9_local0 = function (element, event)
			if not event.interrupted then
				element:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
			end
			element:setRGB(0.98, 0.44, 0.04)
			element:setAlpha(1)
			if event.interrupted then
				Widget.clipFinished(element, event)
			else
				element:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f9_local0(checkboxCheck, {})
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
		checkboxBacking:completeAnimation()
		Widget.checkboxBacking:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(checkboxBacking, {})
		checkboxBkg:completeAnimation()
		Widget.CheckboxBkg:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(checkboxBkg, {})
		checkboxCheck:completeAnimation()
		Widget.checkboxCheck:setRGB(0.2, 0.2, 0.2)
		Widget.checkboxCheck:setAlpha(0)
		Widget.clipFinished(checkboxCheck, {})
		labelText:completeAnimation()
		Widget.labelText:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(labelText, {})
	end}}
	Widget:mergeStateConditions({{stateName = "Checked", condition = function (HudRef, ItemRef, UpdateTable)
		return CoD.TFPCUtil.CheckBoxOptionChecked(ItemRef, UpdateTable)
	end}, {stateName = "Disabled", condition = function (HudRef, ItemRef, UpdateTable)
		return IsDisabled(ItemRef, controller)
	end}})
	Widget:linkToElementModel(Widget, "disabled", true, function (ModelRef)
		HudRef:updateElementState(Widget, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "disabled"})
	end)
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.fullBorder:close()
		Sender.checkboxBacking:close()
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

