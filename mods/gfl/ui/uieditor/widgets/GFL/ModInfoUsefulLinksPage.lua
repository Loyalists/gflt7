require("ui.uieditor.widgets.PC.StartMenu.Dropdown.OptionDropdown")
require("ui.uieditor.widgets.PC.Utility.OptionInfoWidget")
require("ui.uieditor.widgets.Scrollbars.verticalScrollbar")

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

CoD.ModInfoUsefulLinksPage = InheritFrom(LUI.UIElement)
CoD.ModInfoUsefulLinksPage.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.ModInfoUsefulLinksPage)
	Widget.id = "ModInfoUsefulLinksPage"
	Widget.soundSet = "ChooseDecal"
	Widget:setLeftRight(true, false, 0, 1100)
	Widget:setTopBottom(true, false, 0, 600)
	Widget:makeFocusable()
	Widget.onlyChildrenFocusable = true
	Widget.anyChildUsesUpdateState = true

	local gameOptionList = LUI.UIList.new(HudRef, InstanceRef, 0, 0, nil, false, false, 0, 0, false, false)
	gameOptionList:makeFocusable()
	gameOptionList:setLeftRight(true, false, 0, 500)
	gameOptionList:setTopBottom(true, false, 30, 506)
	gameOptionList:setDataSource("ModInfoUsefulLinks")
	gameOptionList:setWidgetType(CoD.OptionDropdown)
    gameOptionList:setVerticalCount(14)
	gameOptionList:setSpacing(0)
	Widget:addElement(gameOptionList)
	Widget.gameOptionList = gameOptionList
	
	local optionInfo = CoD.OptionInfoWidget.new(HudRef, InstanceRef)
	optionInfo:setLeftRight(true, false, 550, 1050)
	optionInfo:setTopBottom(true, false, 30, 330)
	Widget:addElement(optionInfo)
	Widget.optionInfo = optionInfo
	
	optionInfo:linkToElementModel(gameOptionList, "description", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			optionInfo.description:setText(Engine.Localize(ModelValue))
		end
	end)
	optionInfo:linkToElementModel(gameOptionList, "label", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			optionInfo.title.itemName:setText(Engine.Localize(ModelValue))
		end
	end)
	gameOptionList.id = "gameOptionList"
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

