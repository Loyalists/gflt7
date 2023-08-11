require("ui.uieditor.widgets.StartMenu.StartMenu_frame_noBG")
require("ui.uieditor.widgets.Lobby.Common.FE_FocusBarContainer")
require("ui.uieditor.widgets.PC.StartMenu.Dropdown.OptionDropdownItem")
require("ui.uieditor.widgets.PC.StartMenu.Dropdown.TFOptionDropdownItem")
require("ui.uieditor.widgets.Scrollbars.verticalScrollbar")
local f0_local0 = function (f1_arg0, f1_arg1)
	if f1_arg0.DropDownList then
		f1_arg0.inUse = not f1_arg0.inUse
		if f1_arg0.inUse then
			f1_arg0:setPriority(100)
			f1_arg0.m_disableNavigation = true
			MakeFocusable(f1_arg0.DropDownList)
			SetFocusToElement(f1_arg0, "DropDownList", f1_arg1)
			f1_arg0.DropDownList.m_disableNavigation = nil
			if type(f1_arg0.dropDownCurrentValue) == "function" then
				local f1_local0 = f1_arg0.DropDownList
				local f1_local1, f1_local2 = false
				f1_local0 = f1_local0:findItem({value = f1_arg0.dropDownCurrentValue(f1_arg1, f1_arg0)}, nil, f1_local1, f1_local2)
				if f1_local0 then
					f1_arg0.DropDownList:setActiveItem(f1_local0)
				end
			end
			local f1_local3, f1_local0 = f1_arg0.DropDownList:getLocalSize()
			f1_arg0.listBackground:setTopBottom(false, true, 0, f1_local0)
		else
			f1_arg0:setPriority(0)
			f1_arg0.m_disableNavigation = nil
			MakeNotFocusable(f1_arg0.DropDownList)
			SetLoseFocusToElement(f1_arg0, "DropDownList", f1_arg1)
			f1_arg0.DropDownList.m_disableNavigation = true
		end
		f1_arg0:dispatchEventToParent({name = "dropdown_triggered", widget = f1_arg0, inUse = f1_arg0.inUse, controller = f1_arg1})
	end
end

local f0_local1 = function (f2_arg0, f2_arg1, f2_arg2)
	f2_arg0:setForceMouseEventDispatch(true)
	f2_arg0:registerEventHandler("dropdown_item_selected", function (Sender, Event)
		if type(Sender.dropDownItemSelected) == "function" and Sender.inUse then
			Sender.currentValueText:setText(Engine.Localize(Sender.dropDownItemSelected(f2_arg1, Sender, Event.element)))
		end
		f0_local0(Sender, f2_arg1)
		UpdateState(Sender, Event)
		Sender.DropDownList:updateDataSource()
		CoD.Menu.UpdateButtonShownState(Sender, f2_arg2, f2_arg1, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE)
		return true
	end)
	f2_arg0:registerEventHandler("dropdown_item_cancelled", function (Sender, Event)
		if Sender.inUse then
			f0_local0(Sender, f2_arg1)
			UpdateState(Sender, Event)
			return true
		else
			return false
		end
	end)
	f2_arg0:registerEventHandler("options_refresh", function (Sender, Event)
		Sender.DropDownList:updateDataSource()
		if type(Sender.dropDownRefresh) == "function" then
			Sender.currentValueText:setText(Engine.Localize(Sender.dropDownRefresh(f2_arg1, Sender, Sender.DropDownList)))
		end
		UpdateState(Sender, Event)
	end)
	f2_arg0.listBackground:setHandleMouseButton(true)
	f2_arg0.listBackground:registerEventHandler("leftmouseup", function (Sender, Event)
		if Event.inside then
			Sender.m_clickedInside = nil
		end
	end)
	f2_arg0.listBackground:registerEventHandler("leftmousedown", function (Sender, Event)
		Sender.m_clickedInside = true
	end)
	f2_arg0.listBackground:registerEventHandler("leftclick_outside", function (Sender, Event)
		if f2_arg0.inUse and not Sender.m_clickedInside then
			f0_local0(f2_arg0, f2_arg1)
			UpdateState(f2_arg0, Event)
			return true
		else
			Sender.m_clickedInside = nil
			return false
		end
	end)
	f2_arg0:registerEventHandler("mouse_left_click", function (Sender, Event)
		if Event.element.m_dropdownItem then
			return Sender:dispatchEventToParent(Event)
		else
			return true
		end
	end)
	f2_arg2:AddButtonCallbackFunction(f2_arg0, f2_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function (f12_arg0, f12_arg1, f12_arg2, f12_arg3)
		if not f2_arg0.disabled and not f12_arg1.m_disableNavigation and f12_arg1:AcceptGamePadButtonInputFromModelCallback(f12_arg2) then
			if not f2_arg0.inUse then
				f0_local0(f2_arg0, f12_arg2)
				UpdateState(f2_arg0, {name = "update_state", controller = f12_arg2})
			end
			return true
		else

		end
	end)
	if f2_arg2.menuName == "StartMenu_Options_Sound_PC" then
		local f2_local0 = function (f13_arg0, f13_arg1, f13_arg2)
			if type(f13_arg0.dropDownCurrentValue) == "function" then
				local f13_local0 = f13_arg0.DropDownList
				local f13_local1, f13_local2 = false
				f13_local0 = f13_local0:findItem({value = f13_arg0.dropDownCurrentValue(f13_arg1, f13_arg0)}, nil, f13_local1, f13_local2)
				if f13_local0 then
					local f13_local3 = f13_local0:getModel()
					if f13_local3 then
						local f13_local4 = Engine.GetModel(f13_local3, f13_arg2)
						if f13_local4 then
							local f13_local5 = Engine.GetModelValue(f13_local4)
							if f13_local5 and f13_local5 ~= "" then
								return f13_local5
							end
						end
					end
				end
			end
			return nil
		end

		local f2_local1 = function (f14_arg0, f14_arg1)
			local f14_local0 = f14_arg0:getModel()
			if f14_local0 then
				Engine.SetModelValue(Engine.CreateModel(f14_local0, "alias"), f14_arg1)
			end
		end

		f2_arg0:registerEventHandler("list_item_lose_focus", function (Sender, Event)
			if f2_local0(f2_arg0, f2_arg1, "alias") then
				StopMPMusicPreview(f2_arg1, f2_arg0)
				return true
			else
				return false
			end
		end)
		f2_arg0:registerEventHandler("lose_focus", function (Sender, Event)
			if f2_local0(f2_arg0, f2_arg1, "alias") then
				StopMPMusicPreview(f2_arg1, f2_arg0)
			end
		end)
		f2_arg2:AddButtonCallbackFunction(f2_arg0, f2_arg1, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "P", function (f17_arg0, f17_arg1, f17_arg2, f17_arg3)
			local f17_local0 = f2_local0(f2_arg0, f17_arg2, "alias")
			if f17_local0 then
				f2_local1(f2_arg0, f17_local0)
				StopMPMusicPreview(f17_arg2, f2_arg0)
				PlayMPMusicPreview(f17_arg2, f2_arg0)
				return true
			else
				return false
			end
		end, function (f18_arg0, f18_arg1, f18_arg2)
			if f2_local0(f2_arg0, f18_arg2, "alias") then
				CoD.Menu.SetButtonLabel(f18_arg1, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "MENU_PLAY_MUSIC_SAMPLE")
				return true
			else
				return false
			end
		end)
	end
end

local f0_local2 = function (f3_arg0, f3_arg1, f3_arg2)
	if CoD.isPC then
		f0_local1(f3_arg0, f3_arg1, f3_arg2)
	end
end

CoD.TFOptions_Dropdown = InheritFrom(LUI.UIElement)
CoD.TFOptions_Dropdown.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
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
	local f4_local1 = LUI.UIImage.new()
	f4_local1:setLeftRight(true, false, 250, 519)
	f4_local1:setTopBottom(true, false, 34, 292)
	f4_local1:setRGB(0, 0, 0)
	f4_local1:setAlpha(0)
	Widget:addElement(f4_local1)
	Widget.listBackground = f4_local1
	
	local f4_local2 = LUI.UIImage.new()
	f4_local2:setLeftRight(true, true, 0, 0)
	f4_local2:setTopBottom(true, true, 0, 0)
	f4_local2:setRGB(0.1, 0.1, 0.1)
	f4_local2:setAlpha(0)
	Widget:addElement(f4_local2)
	Widget.fullBacking = f4_local2
	
	local f4_local3 = CoD.StartMenu_frame_noBG.new(HudRef, InstanceRef)
	f4_local3:setLeftRight(true, true, 0, 0)
	f4_local3:setTopBottom(true, true, 0, 0)
	Widget:addElement(f4_local3)
	Widget.StartMenuframenoBG00 = f4_local3
	
	local f4_local4 = LUI.UIText.new()
	f4_local4:setLeftRight(true, false, 9.34, 285)
	f4_local4:setTopBottom(true, false, 4.5, 29.5)
	f4_local4:setTTF("fonts/default.ttf")
	f4_local4:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	f4_local4:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget:addElement(f4_local4)
	Widget.labelText = f4_local4
	
	local f4_local5 = LUI.UIImage.new()
	f4_local5:setLeftRight(true, false, 250, 491)
	f4_local5:setTopBottom(true, false, 7.25, 26.75)
	f4_local5:setRGB(0.1, 0.1, 0.1)
	f4_local5:setAlpha(0)
	Widget:addElement(f4_local5)
	Widget.dropdownBacking = f4_local5
	
	local f4_local6 = LUI.UIText.new()
	f4_local6:setLeftRight(true, false, 255, 470)
	f4_local6:setTopBottom(true, false, 4.25, 29.25)
	f4_local6:setText(Engine.Localize(""))
	f4_local6:setTTF("fonts/default.ttf")
	f4_local6:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	f4_local6:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget:addElement(f4_local6)
	Widget.currentValueText = f4_local6
	
	local f4_local7 = CoD.FE_FocusBarContainer.new(HudRef, InstanceRef)
	f4_local7:setLeftRight(true, true, 0, 0)
	f4_local7:setTopBottom(false, true, -5.5, 0)
	f4_local7:setAlpha(0)
	f4_local7:setZoom(1)
	Widget:addElement(f4_local7)
	Widget.FocusBarB = f4_local7
	
	local f4_local8 = CoD.FE_FocusBarContainer.new(HudRef, InstanceRef)
	f4_local8:setLeftRight(true, true, 2, 0)
	f4_local8:setTopBottom(true, false, 0, 4)
	f4_local8:setAlpha(0)
	f4_local8:setZoom(1)
	Widget:addElement(f4_local8)
	Widget.FocusBarT = f4_local8
	
	local f4_local9 = LUI.UIList.new(HudRef, InstanceRef, 2, 0, nil, true, false, 1, 0, false, true)
	f4_local9:makeFocusable()
	f4_local9:setLeftRight(false, true, -251, 0)
	f4_local9:setTopBottom(true, false, 34, 150)
	f4_local9:setAlpha(0)
	f4_local9:setWidgetType(CoD.OptionDropdownItem)
	f4_local9:setVerticalCount(8)
	f4_local9:setVerticalScrollbar(CoD.verticalScrollbar)
	Widget:addElement(f4_local9)
	Widget.DropDownList = f4_local9
	
	local f4_local10 = LUI.UIImage.new()
	f4_local10:setLeftRight(true, true, 468.12, -1)
	f4_local10:setTopBottom(true, true, 4.5, -4.5)
	f4_local10:setZRot(90)
	f4_local10:setScale(0.6)
	f4_local10:setImage(RegisterImage("uie_characterminiselectorarrow"))
	Widget:addElement(f4_local10)
	Widget.Arrow = f4_local10
	
	local f4_local11 = CoD.StartMenu_frame_noBG.new(HudRef, InstanceRef)
	f4_local11:setLeftRight(true, true, 0, 0)
	f4_local11:setTopBottom(true, true, 0, 0)
	f4_local11:setRGB(0.87, 0.37, 0)
	f4_local11:setAlpha(0)
	Widget:addElement(f4_local11)
	Widget.frameOutline = f4_local11
	
	Widget.labelText:linkToElementModel(Widget, "label", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f4_local4:setText(Engine.Localize(ModelValue))
			--f4_local4:setText("TEST")
		end
	end)
	Widget.DropDownList:linkToElementModel(Widget, "datasource", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f4_local9:setDataSource(ModelValue)
		end
	end)
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(8)
		f4_local1:completeAnimation()
		Widget.listBackground:setAlpha(0)
		Widget.clipFinished(f4_local1, {})
		f4_local4:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.clipFinished(f4_local4, {})
		f4_local6:completeAnimation()
		Widget.currentValueText:setRGB(1, 1, 1)
		Widget.currentValueText:setAlpha(0.5)
		Widget.clipFinished(f4_local6, {})
		f4_local7:completeAnimation()
		Widget.FocusBarB:setAlpha(0)
		Widget.clipFinished(f4_local7, {})
		f4_local8:completeAnimation()
		Widget.FocusBarT:setLeftRight(true, true, 0, 0)
		Widget.FocusBarT:setTopBottom(true, false, 0, 4)
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(f4_local8, {})
		f4_local9:completeAnimation()
		Widget.DropDownList:setAlpha(0)
		Widget.clipFinished(f4_local9, {})
		f4_local10:completeAnimation()
		Widget.Arrow:setRGB(1, 1, 1)
		Widget.Arrow:setZRot(90)
		Widget.clipFinished(f4_local10, {})
		f4_local11:completeAnimation()
		Widget.frameOutline:setAlpha(0)
		Widget.clipFinished(f4_local11, {})
	end, Focus = function ()
		Widget:setupElementClipCounter(7)
		f4_local1:completeAnimation()
		Widget.listBackground:setAlpha(0)
		Widget.clipFinished(f4_local1, {})
		f4_local6:completeAnimation()
		Widget.currentValueText:setAlpha(1)
		Widget.clipFinished(f4_local6, {})
		f4_local7:completeAnimation()
		Widget.FocusBarB:setAlpha(1)
		Widget.clipFinished(f4_local7, {})
		f4_local8:completeAnimation()
		Widget.FocusBarT:setAlpha(1)
		Widget.clipFinished(f4_local8, {})
		f4_local9:completeAnimation()
		Widget.DropDownList:setAlpha(0)
		Widget.clipFinished(f4_local9, {})
		f4_local10:completeAnimation()
		Widget.Arrow:setZRot(90)
		Widget.clipFinished(f4_local10, {})
		f4_local11:completeAnimation()
		Widget.frameOutline:setAlpha(1)
		Widget.clipFinished(f4_local11, {})
	end}, Disabled = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f4_local4:completeAnimation()
		Widget.labelText:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(f4_local4, {})
		f4_local6:completeAnimation()
		Widget.currentValueText:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(f4_local6, {})
		f4_local10:completeAnimation()
		Widget.Arrow:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(f4_local10, {})
	end}, InUse = {DefaultClip = function ()
		Widget:setupElementClipCounter(7)
		f4_local1:completeAnimation()
		Widget.listBackground:setAlpha(1)
		Widget.clipFinished(f4_local1, {})
		f4_local4:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.clipFinished(f4_local4, {})
		f4_local6:completeAnimation()
		Widget.currentValueText:setRGB(1, 1, 1)
		Widget.clipFinished(f4_local6, {})
		f4_local7:completeAnimation()
		Widget.FocusBarB:setAlpha(0)
		Widget.clipFinished(f4_local7, {})
		f4_local8:completeAnimation()
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(f4_local8, {})
		f4_local9:completeAnimation()
		Widget.DropDownList:setAlpha(1)
		Widget.clipFinished(f4_local9, {})
		f4_local10:completeAnimation()
		Widget.Arrow:setRGB(1, 1, 1)
		Widget.Arrow:setZRot(270)
		Widget.clipFinished(f4_local10, {})
	end}}
	Widget:mergeStateConditions({{stateName = "Disabled", condition = function (HudRef, ItemRef, UpdateTable)
		return IsDisabled(ItemRef, InstanceRef)
	end}, {stateName = "InUse", condition = function (HudRef, ItemRef, UpdateTable)
		return DropDownListIsInUse(ItemRef)
	end}})
	Widget:linkToElementModel(Widget, "disabled", true, function (ModelRef)
		HudRef:updateElementState(Widget, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "disabled"})
	end)
	LUI.OverrideFunction_CallOriginalFirst(Widget, "setState", function (f28_arg0, f28_arg1)
		if IsInDefaultState(f28_arg0) then
			MakeElementNotFocusable(Widget, "DropDownList", InstanceRef)
		end
	end)
	f4_local9.id = "DropDownList"
	Widget:registerEventHandler("gain_focus", function (Sender, Event)
		if Sender.m_focusable then
			local f29_local0 = Sender.DropDownList
			if f29_local0:processEvent(Event) then
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
		f0_local2(Widget, InstanceRef, HudRef)
	end
	return Widget
end

