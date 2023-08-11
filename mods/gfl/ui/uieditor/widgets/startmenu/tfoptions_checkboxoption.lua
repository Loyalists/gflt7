require("ui.uieditor.widgets.StartMenu.StartMenu_frame_noBG")
require("ui.uieditor.widgets.Lobby.Common.FE_FocusBarContainer")
local f0_local0 = function (f1_arg0, f1_arg1, f1_arg2)
	f1_arg0:registerEventHandler("options_refresh", function (Sender, Event)
		Sender:processEvent({name = "update_state", controller = Event.controller})
	end)
	CoD.Menu.AddButtonCallbackFunction(f1_arg2, f1_arg0, f1_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function (f4_arg0, f4_arg1, f4_arg2, f4_arg3)
		if not f1_arg0.disabled and not f4_arg1.m_disableNavigation and f4_arg1:AcceptGamePadButtonInputFromModelCallback(f4_arg2) then
			if type(f1_arg0.checkboxAction) == "function" then
				f1_arg0.checkboxAction(f4_arg2, f1_arg0)
				f1_arg0:processEvent({name = "update_state", controller = f4_arg2})
			end
			return true
		else

		end
	end)
end

CoD.TFOptions_CheckBoxOption = InheritFrom(LUI.UIElement)
CoD.TFOptions_CheckBoxOption.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
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
	local f2_local1 = LUI.UIImage.new()
	f2_local1:setLeftRight(true, true, 0, 0)
	f2_local1:setTopBottom(true, true, 0, 0)
	f2_local1:setRGB(0.1, 0.1, 0.1)
	f2_local1:setAlpha(0)
	Widget:addElement(f2_local1)
	Widget.fullBacking = f2_local1
	
	local f2_local2 = CoD.StartMenu_frame_noBG.new(HudRef, InstanceRef)
	f2_local2:setLeftRight(true, true, 0, 0)
	f2_local2:setTopBottom(true, true, 0, 0)
	f2_local2:setRGB(0.87, 0.37, 0)
	f2_local2:setAlpha(0)
	Widget:addElement(f2_local2)
	Widget.fullBorder = f2_local2
	
	local f2_local3 = CoD.StartMenu_frame_noBG.new(HudRef, InstanceRef)
	f2_local3:setLeftRight(true, true, -8.5, -443.5)
	f2_local3:setTopBottom(true, true, -13, 13)
	f2_local3:setScale(0.3)
	Widget:addElement(f2_local3)
	Widget.checkboxBacking = f2_local3
	
	local f2_local4 = LUI.UIImage.new()
	f2_local4:setLeftRight(true, false, 14.75, 33.25)
	f2_local4:setTopBottom(true, false, 8.25, 25.75)
	f2_local4:setAlpha(0)
	f2_local4:setImage(RegisterImage("uie_t7_menu_cacselection_checkbox_empty"))
	Widget:addElement(f2_local4)
	Widget.CheckboxBkg = f2_local4
	
	local f2_local5 = LUI.UIImage.new()
	f2_local5:setLeftRight(true, false, 14.75, 33.25)
	f2_local5:setTopBottom(true, false, 8.25, 25.75)
	f2_local5:setImage(RegisterImage("uie_t7_menu_cacselection_checkbox"))
	Widget:addElement(f2_local5)
	Widget.checkboxCheck = f2_local5
	
	local f2_local6 = LUI.UITightText.new()
	f2_local6:setLeftRight(true, false, 47, 500)
	f2_local6:setTopBottom(true, false, 4.5, 29.5)
	f2_local6:setTTF("fonts/default.ttf")
	f2_local6:linkToElementModel(Widget, "label", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f2_local6:setText(Engine.Localize(ModelValue))
		end
	end)
	Widget:addElement(f2_local6)
	Widget.labelText = f2_local6
	
	local f2_local7 = CoD.StartMenu_frame_noBG.new(HudRef, InstanceRef)
	f2_local7:setLeftRight(true, true, 0, 0)
	f2_local7:setTopBottom(true, true, 0, 0)
	Widget:addElement(f2_local7)
	Widget.StartMenuframenoBG00 = f2_local7
	
	local f2_local8 = CoD.FE_FocusBarContainer.new(HudRef, InstanceRef)
	f2_local8:setLeftRight(true, true, 2, 0)
	f2_local8:setTopBottom(true, false, 0, 4)
	f2_local8:setAlpha(0)
	f2_local8:setZoom(1)
	Widget:addElement(f2_local8)
	Widget.FocusBarT = f2_local8
	
	local f2_local9 = CoD.FE_FocusBarContainer.new(HudRef, InstanceRef)
	f2_local9:setLeftRight(true, true, 0, 0)
	f2_local9:setTopBottom(false, true, -5.5, 0)
	f2_local9:setAlpha(0)
	f2_local9:setZoom(1)
	Widget:addElement(f2_local9)
	Widget.FocusBarB = f2_local9
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(7)
		f2_local2:completeAnimation()
		Widget.fullBorder:setAlpha(0)
		Widget.clipFinished(f2_local2, {})
		f2_local3:completeAnimation()
		Widget.checkboxBacking:setRGB(0.78, 0.78, 0.78)
		Widget.clipFinished(f2_local3, {})
		f2_local4:completeAnimation()
		Widget.CheckboxBkg:setRGB(1, 1, 1)
		Widget.CheckboxBkg:setAlpha(1)
		Widget.clipFinished(f2_local4, {})
		f2_local5:completeAnimation()
		Widget.checkboxCheck:setRGB(1, 0.45, 0)
		Widget.checkboxCheck:setAlpha(0)
		Widget.clipFinished(f2_local5, {})
		f2_local6:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(f2_local6, {})
		f2_local8:completeAnimation()
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(f2_local8, {})
		f2_local9:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
		f2_local9:setAlpha(0)
		f2_local9:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
	end, Focus = function ()
		Widget:setupElementClipCounter(7)
		f2_local2:completeAnimation()
		Widget.fullBorder:setAlpha(1)
		Widget.clipFinished(f2_local2, {})
		f2_local3:completeAnimation()
		Widget.checkboxBacking:setRGB(0.87, 0.37, 0)
		Widget.clipFinished(f2_local3, {})
		f2_local4:completeAnimation()
		Widget.CheckboxBkg:setRGB(1, 0.41, 0)
		Widget.CheckboxBkg:setAlpha(1)
		Widget.clipFinished(f2_local4, {})
		f2_local5:completeAnimation()
		Widget.checkboxCheck:setAlpha(0)
		Widget.clipFinished(f2_local5, {})
		f2_local6:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(f2_local6, {})
		f2_local8:completeAnimation()
		Widget.FocusBarT:setLeftRight(true, true, 0, 0)
		Widget.FocusBarT:setTopBottom(true, false, 0, 4)
		Widget.FocusBarT:setAlpha(1)
		Widget.clipFinished(f2_local8, {})
		f2_local9:completeAnimation()
		Widget.FocusBarB:setLeftRight(true, true, 0, 0)
		Widget.FocusBarB:setTopBottom(false, true, -5.5, 0)
		Widget.FocusBarB:setAlpha(1)
		Widget.clipFinished(f2_local9, {})
	end}, Checked = {DefaultClip = function ()
		Widget:setupElementClipCounter(7)
		f2_local2:completeAnimation()
		Widget.fullBorder:setAlpha(0)
		Widget.clipFinished(f2_local2, {})
		f2_local3:completeAnimation()
		Widget.checkboxBacking:setRGB(0.78, 0.78, 0.78)
		Widget.clipFinished(f2_local3, {})
		f2_local4:completeAnimation()
		Widget.CheckboxBkg:setRGB(1, 1, 1)
		Widget.CheckboxBkg:setAlpha(0.5)
		Widget.clipFinished(f2_local4, {})
		f2_local5:completeAnimation()
		Widget.checkboxCheck:setRGB(1, 1, 1)
		Widget.checkboxCheck:setAlpha(1)
		local f8_local0 = function (f15_arg0, f15_arg1)
			if not f15_arg1.interrupted then
				f15_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
			end
			f15_arg0:setRGB(1, 1, 1)
			f15_arg0:setAlpha(1)
			if f15_arg1.interrupted then
				Widget.clipFinished(f15_arg0, f15_arg1)
			else
				f15_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f8_local0(f2_local5, {})
		f2_local6:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(f2_local6, {})
		f2_local8:completeAnimation()
		Widget.FocusBarT:setAlpha(0)
		Widget.clipFinished(f2_local8, {})
		f2_local9:completeAnimation()
		Widget.FocusBarB:setAlpha(0)
		Widget.clipFinished(f2_local9, {})
	end, Focus = function ()
		Widget:setupElementClipCounter(7)
		f2_local2:completeAnimation()
		Widget.fullBorder:setAlpha(1)
		Widget.clipFinished(f2_local2, {})
		f2_local3:completeAnimation()
		Widget.checkboxBacking:setRGB(0.87, 0.37, 0)
		Widget.clipFinished(f2_local3, {})
		f2_local4:completeAnimation()
		Widget.CheckboxBkg:setRGB(1, 1, 1)
		Widget.CheckboxBkg:setAlpha(0)
		Widget.clipFinished(f2_local4, {})
		f2_local5:completeAnimation()
		Widget.checkboxCheck:setRGB(0.87, 0.37, 0)
		Widget.checkboxCheck:setAlpha(1)
		local f9_local0 = function (f16_arg0, f16_arg1)
			if not f16_arg1.interrupted then
				f16_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
			end
			f16_arg0:setRGB(0.98, 0.44, 0.04)
			f16_arg0:setAlpha(1)
			if f16_arg1.interrupted then
				Widget.clipFinished(f16_arg0, f16_arg1)
			else
				f16_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f9_local0(f2_local5, {})
		f2_local6:completeAnimation()
		Widget.labelText:setRGB(1, 1, 1)
		Widget.labelText:setAlpha(1)
		Widget.clipFinished(f2_local6, {})
		f2_local8:completeAnimation()
		Widget.FocusBarT:setLeftRight(true, true, 0, 0)
		Widget.FocusBarT:setTopBottom(true, false, 0, 4)
		Widget.FocusBarT:setAlpha(1)
		local f9_local1 = function (f17_arg0, f17_arg1)
			if not f17_arg1.interrupted then
				f17_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
			end
			f17_arg0:setLeftRight(true, true, 0, 0)
			f17_arg0:setTopBottom(true, false, 0, 4)
			f17_arg0:setAlpha(1)
			if f17_arg1.interrupted then
				Widget.clipFinished(f17_arg0, f17_arg1)
			else
				f17_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f9_local1(f2_local8, {})
		f2_local9:completeAnimation()
		Widget.FocusBarB:setLeftRight(true, true, 0, 0)
		Widget.FocusBarB:setTopBottom(false, true, -5.5, 0)
		Widget.FocusBarB:setAlpha(1)
		local f9_local2 = function (f18_arg0, f18_arg1)
			if not f18_arg1.interrupted then
				f18_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
			end
			f18_arg0:setLeftRight(true, true, 0, 0)
			f18_arg0:setTopBottom(false, true, -5.5, 0)
			f18_arg0:setAlpha(1)
			if f18_arg1.interrupted then
				Widget.clipFinished(f18_arg0, f18_arg1)
			else
				f18_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f9_local2(f2_local9, {})
	end}, Disabled = {DefaultClip = function ()
		Widget:setupElementClipCounter(4)
		f2_local3:completeAnimation()
		Widget.checkboxBacking:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(f2_local3, {})
		f2_local4:completeAnimation()
		Widget.CheckboxBkg:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(f2_local4, {})
		f2_local5:completeAnimation()
		Widget.checkboxCheck:setRGB(0.2, 0.2, 0.2)
		Widget.checkboxCheck:setAlpha(0)
		Widget.clipFinished(f2_local5, {})
		f2_local6:completeAnimation()
		Widget.labelText:setRGB(0.2, 0.2, 0.2)
		Widget.clipFinished(f2_local6, {})
	end}}
	Widget:mergeStateConditions({{stateName = "Checked", condition = function (HudRef, ItemRef, UpdateTable)
		return CoD.TFPCUtil.CheckBoxOptionChecked(ItemRef, UpdateTable)
	end}, {stateName = "Disabled", condition = function (HudRef, ItemRef, UpdateTable)
		return IsDisabled(ItemRef, InstanceRef)
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
	if f0_local0 then
		f0_local0(Widget, InstanceRef, HudRef)
	end
	return Widget
end

