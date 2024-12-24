require("ui.uieditor.widgets.PC.StartMenu.Dropdown.OptionDropdown")
require("ui.uieditor.widgets.PC.Utility.OptionInfoWidget")
require("ui.uieditor.widgets.Scrollbars.verticalScrollbar")

CoD.ModInfoP1 = InheritFrom(LUI.UIElement)
CoD.ModInfoP1.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.ModInfoP1)
	Widget.id = "ModInfoP1"
	Widget.soundSet = "ChooseDecal"
	Widget:setLeftRight(true, false, 0, 1100)
	Widget:setTopBottom(true, false, 0, 600)
	Widget:makeFocusable()
	Widget.onlyChildrenFocusable = true
	Widget.anyChildUsesUpdateState = true
	-- local gameOptionList = LUI.UIList.new(HudRef, InstanceRef, 0, 0, nil, false, false, 0, 0, false, false)
	-- gameOptionList:makeFocusable()
	-- gameOptionList:setLeftRight(true, false, 0, 500)
	-- gameOptionList:setTopBottom(true, false, 30, 506)
	-- gameOptionList:setDataSource("ModInfoP1")
	-- gameOptionList:setWidgetType(CoD.OptionDropdown)
    -- gameOptionList:setVerticalCount(14)
	-- gameOptionList:setSpacing(0)
	-- gameOptionList.id = "gameOptionList"

	-- Widget:addElement(gameOptionList)
	-- Widget.gameOptionList = gameOptionList

	local optionInfo = CoD.OptionInfoWidget.new(HudRef, InstanceRef)
	optionInfo:setLeftRight(true, false, 0, 1050)
	optionInfo:setTopBottom(true, false, 30, 330)
	optionInfo.title.itemName:setText(Engine.Localize("GFL_MODINFO_WELCOME_TITLE"))
	optionInfo.description:setText(Engine.Localize("GFL_MODINFO_WELCOME_DESC"))

	Widget:addElement(optionInfo)
	Widget.optionInfo = optionInfo
	
	-- optionInfo:linkToElementModel(gameOptionList, "description", true, function (ModelRef)
	-- 	local ModelValue = Engine.GetModelValue(ModelRef)
	-- 	if ModelValue then
	-- 		optionInfo.description:setText(Engine.Localize(ModelValue))
	-- 	end
	-- end)
	-- optionInfo:linkToElementModel(gameOptionList, "label", true, function (ModelRef)
	-- 	local ModelValue = Engine.GetModelValue(ModelRef)
	-- 	if ModelValue then
	-- 		optionInfo.title.itemName:setText(Engine.Localize(ModelValue))
	-- 	end
	-- end)

	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		-- Sender.gameOptionList:close()
		Sender.optionInfo:close()
	end)

	return Widget
end

