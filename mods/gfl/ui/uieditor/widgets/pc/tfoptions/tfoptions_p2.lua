require("ui.uieditor.widgets.PC.StartMenu.Dropdown.OptionDropdown")
require("ui.uieditor.widgets.PC.Utility.OptionInfoWidget")
local f0_local0 = function (f1_arg0, f1_arg1)
    f1_arg0:dispatchEventToChildren({name = "options_refresh", controller = f1_arg1})
    f1_arg0.gameOptionList.m_managedItemPriority = true
    f1_arg0:registerEventHandler("dropdown_triggered", function (Sender, Event)
        for f3_local0 = 1, Sender.gameOptionList.requestedRowCount, 1 do
            local f3_local1 = Sender.gameOptionList:getItemAtPosition(f3_local0, 1)
            if Event.inUse and f3_local1 ~= Event.widget then
                f3_local1.m_inputDisabled = true
            else
                f3_local1.m_inputDisabled = false
            end
        end
    end)
end

CoD.TFOptions_P2 = InheritFrom(LUI.UIElement)
CoD.TFOptions_P2.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.TFOptions_P2)
	Widget.id = "TFOptions_P2"
	Widget.soundSet = "ChooseDecal"
	Widget:setLeftRight(true, false, 0, 1100)
	Widget:setTopBottom(true, false, 0, 600)
	Widget:makeFocusable()
	Widget.onlyChildrenFocusable = true
	Widget.anyChildUsesUpdateState = true
	local f2_local1 = LUI.UIList.new(HudRef, InstanceRef, 0, 0, nil, false, false, 0, 0, false, false)
	f2_local1:makeFocusable()
	f2_local1:setLeftRight(true, false, 0, 500)
	f2_local1:setTopBottom(true, false, 30, 506)
	f2_local1:setDataSource("TFOptionsP2")
	f2_local1:setWidgetType(CoD.OptionDropdown)
	f2_local1:setVerticalCount(14)
	f2_local1:setSpacing(0)
	Widget:addElement(f2_local1)
	Widget.gameOptionList = f2_local1
	
	local f2_local2 = CoD.OptionInfoWidget.new(HudRef, InstanceRef)
	f2_local2:setLeftRight(true, false, 550, 950)
	f2_local2:setTopBottom(true, false, 30, 330)
	Widget:addElement(f2_local2)
	Widget.optionInfo = f2_local2
	
	f2_local2:linkToElementModel(f2_local1, "description", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f2_local2.description:setText(Engine.Localize(ModelValue))
		end
	end)
	f2_local2:linkToElementModel(f2_local1, "label", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f2_local2.title.itemName:setText(Engine.Localize(ModelValue))
		end
	end)
	f2_local1.id = "gameOptionList"
	Widget:registerEventHandler("gain_focus", function (Sender, Event)
		if Sender.m_focusable then
			local f6_local0 = Sender.gameOptionList
			if f6_local0:processEvent(Event) then
				return true
			end
		end
		return LUI.UIElement.gainFocus(Sender, Event)
	end)
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.gameOptionList:close()
		Sender.optionInfo:close()
	end)
	if f0_local0 then
		f0_local0(Widget, InstanceRef, HudRef)
	end
	return Widget
end

