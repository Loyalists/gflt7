require("ui.uieditor.widgets.Lobby.Common.FE_FocusBarContainer")
local configureInputCallbacks = function (element, controller, menu)
	CoD.Menu.AddButtonCallbackFunction(menu, element, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function (element2, menu, controller, event)
		element:processEvent({name = "lose_focus", controller = controller})
		local dropdownItem = element
		return dropdownItem:dispatchEventToParent({name = "dropdown_item_cancelled", element = element})
	end)
	CoD.Menu.AddButtonCallbackFunction(menu, element, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function (element2, menu, controller, event)
		if not menu.m_disableNavigation and menu:AcceptGamePadButtonInputFromModelCallback(controller) then
			element:processEvent({name = "lose_focus", controller = controller})
			local dropdownItem = element
			return dropdownItem:dispatchEventToParent({name = "dropdown_item_selected", element = element})
		else

		end
	end)
	element.m_dropdownItem = true
end

local configurePCInput = function (f2_arg0, controller, menu)
	if CoD.isPC then
		configureInputCallbacks(f2_arg0, controller, menu)
	end
end

CoD.OptionDropdownItem = InheritFrom(LUI.UIElement)
CoD.OptionDropdownItem.new = function (HudRef, controller)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, controller)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.OptionDropdownItem)
	Widget.id = "OptionDropdownItem"
	Widget.soundSet = "none"
	Widget:setLeftRight(true, false, 0, 250)
	Widget:setTopBottom(true, false, 0, 24)
	Widget:makeFocusable()
	Widget:setHandleMouse(true)
	Widget.anyChildUsesUpdateState = true
	local fullbacking = LUI.UIImage.new()
	fullbacking:setLeftRight(true, true, 0, 0)
	fullbacking:setTopBottom(true, true, 0, 0)
	fullbacking:setRGB(0, 0, 0)
	Widget:addElement(fullbacking)
	Widget.fullbacking = fullbacking
	
	local labelText = LUI.UIText.new()
	labelText:setLeftRight(true, false, 6.2, 243)
	labelText:setTopBottom(true, false, 0, 24)
	labelText:setTTF("fonts/default.ttf")
	labelText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	labelText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	labelText:linkToElementModel(Widget, "valueDisplay", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			labelText:setText(Engine.Localize(ModelValue))
		end
	end)
	Widget:addElement(labelText)
	Widget.labelText = labelText
	
	local focusBarT = CoD.FE_FocusBarContainer.new(HudRef, controller)
	focusBarT:setLeftRight(true, true, -2, 2)
	focusBarT:setTopBottom(true, false, -1, 3)
	focusBarT:setAlpha(0)
	focusBarT:setZoom(1)
	Widget:addElement(focusBarT)
	Widget.FocusBarT = focusBarT
	
	local focusBarB = CoD.FE_FocusBarContainer.new(HudRef, controller)
	focusBarB:setLeftRight(true, true, -2, 2)
	focusBarB:setTopBottom(false, true, -2, 2)
	focusBarB:setAlpha(0)
	focusBarB:setZoom(1)
	Widget:addElement(focusBarB)
	Widget.FocusBarB = focusBarB
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		labelText:completeAnimation()
		Widget.labelText:setLeftRight(true, false, 6.2, 243)
		Widget.labelText:setTopBottom(true, false, 0, 24)
		Widget.labelText:setRGB(0.87, 0.37, 0)
		Widget.labelText:setAlpha(0.75)
		Widget.clipFinished(labelText, {})
		focusBarT:completeAnimation()
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(focusBarT, {})
		focusBarB:completeAnimation()
		Widget.FocusBarB:setAlpha(0)
		Widget.clipFinished(focusBarB, {})
	end, Focus = function ()
		Widget:setupElementClipCounter(4)
		fullbacking:completeAnimation()
		Widget.fullbacking:setRGB(0, 0, 0)
		Widget.fullbacking:setAlpha(1)
		Widget.clipFinished(fullbacking, {})
		labelText:completeAnimation()
		Widget.labelText:setLeftRight(true, false, 6.2, 240)
		Widget.labelText:setTopBottom(true, false, 0, 24)
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(labelText, {})
		focusBarT:completeAnimation()
		Widget.FocusBarT:setAlpha(1)
		Widget.clipFinished(focusBarT, {})
		focusBarB:completeAnimation()
		Widget.FocusBarB:setAlpha(1)
		Widget.clipFinished(focusBarB, {})
	end}}
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.FocusBarT:close()
		Sender.FocusBarB:close()
		Sender.labelText:close()
	end)
	if configurePCInput then
		configurePCInput(Widget, controller, HudRef)
	end
	return Widget
end

