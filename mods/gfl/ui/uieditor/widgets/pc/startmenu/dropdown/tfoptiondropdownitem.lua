require("ui.uieditor.widgets.Lobby.Common.FE_FocusBarContainer")
local f0_local0 = function (f1_arg0, f1_arg1, f1_arg2)
	CoD.Menu.AddButtonCallbackFunction(f1_arg2, f1_arg0, f1_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function (f4_arg0, f4_arg1, f4_arg2, f4_arg3)
		f1_arg0:processEvent({name = "lose_focus", controller = f4_arg2})
		local f4_local0 = f1_arg0
		return f4_local0:dispatchEventToParent({name = "dropdown_item_cancelled", element = f1_arg0})
	end)
	CoD.Menu.AddButtonCallbackFunction(f1_arg2, f1_arg0, f1_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function (f5_arg0, f5_arg1, f5_arg2, f5_arg3)
		if not f5_arg1.m_disableNavigation and f5_arg1:AcceptGamePadButtonInputFromModelCallback(f5_arg2) then
			f1_arg0:processEvent({name = "lose_focus", controller = f5_arg2})
			local f5_local0 = f1_arg0
			return f5_local0:dispatchEventToParent({name = "dropdown_item_selected", element = f1_arg0})
		else

		end
	end)
	f1_arg0.m_dropdownItem = true
end

local f0_local1 = function (f2_arg0, f2_arg1, f2_arg2)
	if CoD.isPC then
		f0_local0(f2_arg0, f2_arg1, f2_arg2)
	end
end

CoD.OptionDropdownItem = InheritFrom(LUI.UIElement)
CoD.OptionDropdownItem.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
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
	local f3_local1 = LUI.UIImage.new()
	f3_local1:setLeftRight(true, true, 0, 0)
	f3_local1:setTopBottom(true, true, 0, 0)
	f3_local1:setRGB(0, 0, 0)
	Widget:addElement(f3_local1)
	Widget.fullbacking = f3_local1
	
	local f3_local2 = LUI.UIText.new()
	f3_local2:setLeftRight(true, false, 6.2, 243)
	f3_local2:setTopBottom(true, false, 0, 24)
	f3_local2:setTTF("fonts/default.ttf")
	f3_local2:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	f3_local2:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	f3_local2:linkToElementModel(Widget, "valueDisplay", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f3_local2:setText(Engine.Localize(ModelValue))
		end
	end)
	Widget:addElement(f3_local2)
	Widget.labelText = f3_local2
	
	local f3_local3 = CoD.FE_FocusBarContainer.new(HudRef, InstanceRef)
	f3_local3:setLeftRight(true, true, -2, 2)
	f3_local3:setTopBottom(true, false, -1, 3)
	f3_local3:setAlpha(0)
	f3_local3:setZoom(1)
	Widget:addElement(f3_local3)
	Widget.FocusBarT = f3_local3
	
	local f3_local4 = CoD.FE_FocusBarContainer.new(HudRef, InstanceRef)
	f3_local4:setLeftRight(true, true, -2, 2)
	f3_local4:setTopBottom(false, true, -2, 2)
	f3_local4:setAlpha(0)
	f3_local4:setZoom(1)
	Widget:addElement(f3_local4)
	Widget.FocusBarB = f3_local4
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f3_local2:completeAnimation()
		Widget.labelText:setLeftRight(true, false, 6.2, 243)
		Widget.labelText:setTopBottom(true, false, 0, 24)
		Widget.labelText:setRGB(0.87, 0.37, 0)
		Widget.labelText:setAlpha(0.75)
		Widget.clipFinished(f3_local2, {})
		f3_local3:completeAnimation()
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(f3_local3, {})
		f3_local4:completeAnimation()
		Widget.FocusBarB:setAlpha(0)
		Widget.clipFinished(f3_local4, {})
	end, Focus = function ()
		Widget:setupElementClipCounter(4)
		f3_local1:completeAnimation()
		Widget.fullbacking:setRGB(0, 0, 0)
		Widget.fullbacking:setAlpha(1)
		Widget.clipFinished(f3_local1, {})
		f3_local2:completeAnimation()
		Widget.labelText:setLeftRight(true, false, 6.2, 240)
		Widget.labelText:setTopBottom(true, false, 0, 24)
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(f3_local2, {})
		f3_local3:completeAnimation()
		Widget.FocusBarT:setAlpha(1)
		Widget.clipFinished(f3_local3, {})
		f3_local4:completeAnimation()
		Widget.FocusBarB:setAlpha(1)
		Widget.clipFinished(f3_local4, {})
	end}}
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.FocusBarT:close()
		Sender.FocusBarB:close()
		Sender.labelText:close()
	end)
	if f0_local1 then
		f0_local1(Widget, InstanceRef, HudRef)
	end
	return Widget
end

