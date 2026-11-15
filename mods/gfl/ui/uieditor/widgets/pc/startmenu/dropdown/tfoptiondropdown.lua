require("ui.uieditor.widgets.StartMenu.StartMenu_frame_noBG")
require("ui.uieditor.widgets.Lobby.Common.FE_FocusBarContainer")
require("ui.uieditor.widgets.PC.StartMenu.Dropdown.OptionDropdownItem")
require("ui.uieditor.widgets.PC.StartMenu.Dropdown.TFOptionDropdownItem")
require("ui.uieditor.widgets.Scrollbars.verticalScrollbar")
local f0_local0 = function (element, controller)
	if element.DropDownList then
		element.inUse = not element.inUse
		if element.inUse then
			element:setPriority(100)
			element.m_disableNavigation = true
			MakeFocusable(element.DropDownList)
			SetFocusToElement(element, "DropDownList", controller)
			element.DropDownList.m_disableNavigation = nil
			if type(element.dropDownCurrentValue) == "function" then
				local dropDownList = element.DropDownList
				local f1_local1, f1_local2 = false
				dropDownList = dropDownList:findItem({value = element.dropDownCurrentValue(controller, element)}, nil, f1_local1, f1_local2)
				if dropDownList then
					element.DropDownList:setActiveItem(dropDownList)
				end
			end
			local width, height = element.DropDownList:getLocalSize()
			element.listBackground:setTopBottom(false, true, 0, height)
		else
			element:setPriority(0)
			element.m_disableNavigation = nil
			MakeNotFocusable(element.DropDownList)
			SetLoseFocusToElement(element, "DropDownList", controller)
			element.DropDownList.m_disableNavigation = true
		end
		element:dispatchEventToParent({name = "dropdown_triggered", widget = element, inUse = element.inUse, controller = controller})
	end
end

local f0_local1 = function (element, controller, menu)
	element:setForceMouseEventDispatch(true)
	element:registerEventHandler("dropdown_item_selected", function (Sender, Event)
		if type(Sender.dropDownItemSelected) == "function" and Sender.inUse then
			Sender.currentValueText:setText(Engine.Localize(Sender.dropDownItemSelected(controller, Sender, Event.element)))
		end
		f0_local0(Sender, controller)
		UpdateState(Sender, Event)
		Sender.DropDownList:updateDataSource()
		CoD.Menu.UpdateButtonShownState(Sender, menu, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE)
		return true
	end)
	element:registerEventHandler("dropdown_item_cancelled", function (Sender, Event)
		if Sender.inUse then
			f0_local0(Sender, controller)
			UpdateState(Sender, Event)
			return true
		else
			return false
		end
	end)
	element:registerEventHandler("options_refresh", function (Sender, Event)
		Sender.DropDownList:updateDataSource()
		if type(Sender.dropDownRefresh) == "function" then
			Sender.currentValueText:setText(Engine.Localize(Sender.dropDownRefresh(controller, Sender, Sender.DropDownList)))
		end
		UpdateState(Sender, Event)
	end)
	element.listBackground:setHandleMouseButton(true)
	element.listBackground:registerEventHandler("leftmouseup", function (Sender, Event)
		if Event.inside then
			Sender.m_clickedInside = nil
		end
	end)
	element.listBackground:registerEventHandler("leftmousedown", function (Sender, Event)
		Sender.m_clickedInside = true
	end)
	element.listBackground:registerEventHandler("leftclick_outside", function (Sender, Event)
		if element.inUse and not Sender.m_clickedInside then
			f0_local0(element, controller)
			UpdateState(element, Event)
			return true
		else
			Sender.m_clickedInside = nil
			return false
		end
	end)
	element:registerEventHandler("mouse_left_click", function (Sender, Event)
		if Event.element.m_dropdownItem then
			return Sender:dispatchEventToParent(Event)
		else
			return true
		end
	end)
	menu:AddButtonCallbackFunction(element, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function (element2, menu, controller, event)
		if not element.disabled and not menu.m_disableNavigation and menu:AcceptGamePadButtonInputFromModelCallback(controller) then
			if not element.inUse then
				f0_local0(element, controller)
				UpdateState(element, {name = "update_state", controller = controller})
			end
			return true
		else

		end
	end)
	if menu.menuName == "StartMenu_Options_Sound_PC" then
		local f2_local0 = function (element, controller, modelName)
			if type(element.dropDownCurrentValue) == "function" then
				local dropDownList = element.DropDownList
				local f13_local1, f13_local2 = false
				dropDownList = dropDownList:findItem({value = element.dropDownCurrentValue(controller, element)}, nil, f13_local1, f13_local2)
				if dropDownList then
					local model = dropDownList:getModel()
					if model then
						local model = Engine.GetModel(model, modelName)
						if model then
							local modelValue = Engine.GetModelValue(model)
							if modelValue and modelValue ~= "" then
								return modelValue
							end
						end
					end
				end
			end
			return nil
		end

		local f2_local1 = function (element, value)
			local model = element:getModel()
			if model then
				Engine.SetModelValue(Engine.CreateModel(model, "alias"), value)
			end
		end

		element:registerEventHandler("list_item_lose_focus", function (Sender, Event)
			if f2_local0(element, controller, "alias") then
				StopMPMusicPreview(controller, element)
				return true
			else
				return false
			end
		end)
		element:registerEventHandler("lose_focus", function (Sender, Event)
			if f2_local0(element, controller, "alias") then
				StopMPMusicPreview(controller, element)
			end
		end)
		menu:AddButtonCallbackFunction(element, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "P", function (element2, menu, controller, event)
			local value = f2_local0(element, controller, "alias")
			if value then
				f2_local1(element, value)
				StopMPMusicPreview(controller, element)
				PlayMPMusicPreview(controller, element)
				return true
			else
				return false
			end
		end, function (element2, menu, controller)
			if f2_local0(element, controller, "alias") then
				CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "MENU_PLAY_MUSIC_SAMPLE")
				return true
			else
				return false
			end
		end)
	end
end

local f0_local2 = function (f3_arg0, controller, menu)
	if CoD.isPC then
		f0_local1(f3_arg0, controller, menu)
	end
end

CoD.TFOptions_Dropdown = InheritFrom(LUI.UIElement)
CoD.TFOptions_Dropdown.new = function (HudRef, controller)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, controller)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.TFOptions_Dropdown)
	Widget.id = "TFOptions_Dropdown"
	Widget.soundSet = "none"
	Widget:setLeftRight(true, false, 0, 500)
	Widget:setTopBottom(true, false, 0, 34)
	Widget:makeFocusable()
	Widget:setHandleMouse(true)
	Widget.anyChildUsesUpdateState = true
	local listBackground = LUI.UIImage.new()
	listBackground:setLeftRight(true, false, 250, 519)
	listBackground:setTopBottom(true, false, 34, 292)
	listBackground:setRGB(0, 0, 0)
	listBackground:setAlpha(0)
	Widget:addElement(listBackground)
	Widget.listBackground = listBackground
	
	local fullBacking = LUI.UIImage.new()
	fullBacking:setLeftRight(true, true, 0, 0)
	fullBacking:setTopBottom(true, true, 0, 0)
	fullBacking:setRGB(0.1, 0.1, 0.1)
	fullBacking:setAlpha(0)
	Widget:addElement(fullBacking)
	Widget.fullBacking = fullBacking
	
	local startMenuframenoBG00 = CoD.StartMenu_frame_noBG.new(HudRef, controller)
	startMenuframenoBG00:setLeftRight(true, true, 0, 0)
	startMenuframenoBG00:setTopBottom(true, true, 0, 0)
	Widget:addElement(startMenuframenoBG00)
	Widget.StartMenuframenoBG00 = startMenuframenoBG00
	
	local labelText = LUI.UIText.new()
	labelText:setLeftRight(true, false, 9.34, 285)
	labelText:setTopBottom(true, false, 4.5, 29.5)
	labelText:setTTF("fonts/default.ttf")
	labelText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	labelText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget:addElement(labelText)
	Widget.labelText = labelText
	
	local dropdownBacking = LUI.UIImage.new()
	dropdownBacking:setLeftRight(true, false, 250, 491)
	dropdownBacking:setTopBottom(true, false, 7.25, 26.75)
	dropdownBacking:setRGB(0.1, 0.1, 0.1)
	dropdownBacking:setAlpha(0)
	Widget:addElement(dropdownBacking)
	Widget.dropdownBacking = dropdownBacking
	
	local currentValueText = LUI.UIText.new()
	currentValueText:setLeftRight(true, false, 255, 470)
	currentValueText:setTopBottom(true, false, 4.25, 29.25)
	currentValueText:setText(Engine.Localize(""))
	currentValueText:setTTF("fonts/default.ttf")
	currentValueText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	currentValueText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget:addElement(currentValueText)
	Widget.currentValueText = currentValueText
	
	local focusBarB = CoD.FE_FocusBarContainer.new(HudRef, controller)
	focusBarB:setLeftRight(true, true, 0, 0)
	focusBarB:setTopBottom(false, true, -5.5, 0)
	focusBarB:setAlpha(0)
	focusBarB:setZoom(1)
	Widget:addElement(focusBarB)
	Widget.FocusBarB = focusBarB
	
	local focusBarT = CoD.FE_FocusBarContainer.new(HudRef, controller)
	focusBarT:setLeftRight(true, true, 2, 0)
	focusBarT:setTopBottom(true, false, 0, 4)
	focusBarT:setAlpha(0)
	focusBarT:setZoom(1)
	Widget:addElement(focusBarT)
	Widget.FocusBarT = focusBarT
	
	local dropDownList = LUI.UIList.new(HudRef, controller, 2, 0, nil, true, false, 1, 0, false, true)
	dropDownList:makeFocusable()
	dropDownList:setLeftRight(false, true, -251, 0)
	dropDownList:setTopBottom(true, false, 34, 150)
	dropDownList:setAlpha(0)
	dropDownList:setWidgetType(CoD.OptionDropdownItem)
	dropDownList:setVerticalCount(8)
	dropDownList:setVerticalScrollbar(CoD.verticalScrollbar)
	Widget:addElement(dropDownList)
	Widget.DropDownList = dropDownList
	
	local arrow = LUI.UIImage.new()
	arrow:setLeftRight(true, true, 468.12, -1)
	arrow:setTopBottom(true, true, 4.5, -4.5)
	arrow:setZRot(90)
	arrow:setScale(0.6)
	arrow:setImage(RegisterImage("uie_characterminiselectorarrow"))
	Widget:addElement(arrow)
	Widget.Arrow = arrow
	
	local frameOutline = CoD.StartMenu_frame_noBG.new(HudRef, controller)
	frameOutline:setLeftRight(true, true, 0, 0)
	frameOutline:setTopBottom(true, true, 0, 0)
	frameOutline:setRGB(0.87, 0.37, 0)
	frameOutline:setAlpha(0)
	Widget:addElement(frameOutline)
	Widget.frameOutline = frameOutline
	
	Widget.labelText:linkToElementModel(Widget, "label", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			labelText:setText(Engine.Localize(ModelValue))
			--f4_local4:setText("TEST")
		end
	end)
	Widget.DropDownList:linkToElementModel(Widget, "datasource", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			dropDownList:setDataSource(ModelValue)
		end
	end)
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(8)
		listBackground:completeAnimation()
		Widget.listBackground:setAlpha(0)
		Widget.clipFinished(listBackground, {})
		labelText:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.clipFinished(labelText, {})
		currentValueText:completeAnimation()
		Widget.currentValueText:setRGB(1, 1, 1)
		Widget.currentValueText:setAlpha(0.5)
		Widget.clipFinished(currentValueText, {})
		focusBarB:completeAnimation()
		Widget.FocusBarB:setAlpha(0)
		Widget.clipFinished(focusBarB, {})
		focusBarT:completeAnimation()
		Widget.FocusBarT:setLeftRight(true, true, 0, 0)
		Widget.FocusBarT:setTopBottom(true, false, 0, 4)
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(focusBarT, {})
		dropDownList:completeAnimation()
		Widget.DropDownList:setAlpha(0)
		Widget.clipFinished(dropDownList, {})
		arrow:completeAnimation()
		Widget.Arrow:setRGB(1, 1, 1)
		Widget.Arrow:setZRot(90)
		Widget.clipFinished(arrow, {})
		frameOutline:completeAnimation()
		Widget.frameOutline:setAlpha(0)
		Widget.clipFinished(frameOutline, {})
	end, Focus = function ()
		Widget:setupElementClipCounter(7)
		listBackground:completeAnimation()
		Widget.listBackground:setAlpha(0)
		Widget.clipFinished(listBackground, {})
		currentValueText:completeAnimation()
		Widget.currentValueText:setAlpha(1)
		Widget.clipFinished(currentValueText, {})
		focusBarB:completeAnimation()
		Widget.FocusBarB:setAlpha(1)
		Widget.clipFinished(focusBarB, {})
		focusBarT:completeAnimation()
		Widget.FocusBarT:setAlpha(1)
		Widget.clipFinished(focusBarT, {})
		dropDownList:completeAnimation()
		Widget.DropDownList:setAlpha(0)
		Widget.clipFinished(dropDownList, {})
		arrow:completeAnimation()
		Widget.Arrow:setZRot(90)
		Widget.clipFinished(arrow, {})
		frameOutline:completeAnimation()
		Widget.frameOutline:setAlpha(1)
		Widget.clipFinished(frameOutline, {})
	end}, Disabled = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		labelText:completeAnimation()
		Widget.labelText:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(labelText, {})
		currentValueText:completeAnimation()
		Widget.currentValueText:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(currentValueText, {})
		arrow:completeAnimation()
		Widget.Arrow:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(arrow, {})
	end}, InUse = {DefaultClip = function ()
		Widget:setupElementClipCounter(7)
		listBackground:completeAnimation()
		Widget.listBackground:setAlpha(1)
		Widget.clipFinished(listBackground, {})
		labelText:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.clipFinished(labelText, {})
		currentValueText:completeAnimation()
		Widget.currentValueText:setRGB(1, 1, 1)
		Widget.clipFinished(currentValueText, {})
		focusBarB:completeAnimation()
		Widget.FocusBarB:setAlpha(0)
		Widget.clipFinished(focusBarB, {})
		focusBarT:completeAnimation()
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(focusBarT, {})
		dropDownList:completeAnimation()
		Widget.DropDownList:setAlpha(1)
		Widget.clipFinished(dropDownList, {})
		arrow:completeAnimation()
		Widget.Arrow:setRGB(1, 1, 1)
		Widget.Arrow:setZRot(270)
		Widget.clipFinished(arrow, {})
	end}}
	Widget:mergeStateConditions({{stateName = "Disabled", condition = function (HudRef, ItemRef, UpdateTable)
		return IsDisabled(ItemRef, controller)
	end}, {stateName = "InUse", condition = function (HudRef, ItemRef, UpdateTable)
		return DropDownListIsInUse(ItemRef)
	end}})
	Widget:linkToElementModel(Widget, "disabled", true, function (ModelRef)
		HudRef:updateElementState(Widget, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "disabled"})
	end)
	LUI.OverrideFunction_CallOriginalFirst(Widget, "setState", function (f28_arg0, f28_arg1)
		if IsInDefaultState(f28_arg0) then
			MakeElementNotFocusable(Widget, "DropDownList", controller)
		end
	end)
	dropDownList.id = "DropDownList"
	Widget:registerEventHandler("gain_focus", function (Sender, Event)
		if Sender.m_focusable then
			local dropDownList = Sender.DropDownList
			if dropDownList:processEvent(Event) then
				return true
			end
		end
		return LUI.UIElement.gainFocus(Sender, Event)
	end)
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.StartMenuframenoBG00:close()
		Sender.FocusBarB:close()
		Sender.FocusBarT:close()
		Sender.DropDownList:close()
		Sender.frameOutline:close()
		Sender.labelText:close()
	end)
	if f0_local2 then
		f0_local2(Widget, controller, HudRef)
	end
	return Widget
end

