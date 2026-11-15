require("ui.uieditor.widgets.PC.StartMenu.Dropdown.OptionDropdown")
require("ui.uieditor.widgets.PC.Utility.OptionInfoWidget")
require("ui.uieditor.widgets.Scrollbars.verticalScrollbar")
local setupOptionsRefresh = function (self, controller)
    self:dispatchEventToChildren({name = "options_refresh", controller = controller})
    self.gameOptionList.m_managedItemPriority = true
    self:registerEventHandler("dropdown_triggered", function (Sender, Event)
        for rowIndex = 1, Sender.gameOptionList.requestedRowCount, 1 do
            local option = Sender.gameOptionList:getItemAtPosition(rowIndex, 1)
            if Event.inUse and option ~= Event.widget then
                option.m_inputDisabled = true
            else
                option.m_inputDisabled = false
            end
        end
    end)
end

CoD.TFOptions_P1 = InheritFrom(LUI.UIElement)
CoD.TFOptions_P1.new = function (HudRef, controller)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, controller)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.TFOptions_P1)
	Widget.id = "TFOptions_P1"
	Widget.soundSet = "ChooseDecal"
	Widget:setLeftRight(true, false, 0, 1100)
	Widget:setTopBottom(true, false, 0, 600)
	Widget:makeFocusable()
	Widget.onlyChildrenFocusable = true
	Widget.anyChildUsesUpdateState = true

	local gameOptionList = LUI.UIList.new(HudRef, controller, 0, 0, nil, false, false, 0, 0, false, false)
	gameOptionList:makeFocusable()
	gameOptionList:setLeftRight(true, false, 0, 500)
	gameOptionList:setTopBottom(true, false, 30, 506)
	gameOptionList:setDataSource("TFOptionsP1")
	gameOptionList:setWidgetType(CoD.OptionDropdown)
    gameOptionList:setVerticalCount(14)
	gameOptionList:setSpacing(0)
	Widget:addElement(gameOptionList)
	Widget.gameOptionList = gameOptionList
	
	local optionInfo = CoD.OptionInfoWidget.new(HudRef, controller)
	optionInfo:setLeftRight(true, false, 550, 1050)
	optionInfo:setTopBottom(true, false, 30, 330)
	Widget:addElement(optionInfo)
	Widget.optionInfo = optionInfo
	
	local InGameNote = LUI.UIText.new()
	InGameNote:setLeftRight( true, false, 550, 1050 )
	InGameNote:setTopBottom( true, false, 400, 400 + CoD.textSize.Default )
	InGameNote:setRGB( 0.74, 0.74, 0.74 )
	InGameNote:setAlpha( 0 )
	InGameNote:setText( Engine.Localize( "TF_MENU_INGAME_NOTE" ) )
	InGameNote:setTTF( "fonts/default.ttf" )
	InGameNote:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	InGameNote:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	Widget:addElement(InGameNote)
	Widget.InGameNote = InGameNote
	
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

	Widget.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				Widget:setupElementClipCounter( 1 )

				InGameNote:completeAnimation()
				Widget.InGameNote:setAlpha( 0 )
				Widget.clipFinished( InGameNote, {} )
			end
		},
		InGame = {
			DefaultClip = function ()
				Widget:setupElementClipCounter( 1 )

				InGameNote:completeAnimation()
				Widget.InGameNote:setAlpha( 1 )
				Widget.clipFinished( InGameNote, {} )
			end
		}
	}

	Widget:mergeStateConditions( {
		{
			stateName = "InGame",
			condition = function ( menu, element, event )
				if CoD.isFrontend then
					return false
				end

				return true
			end
		}
	} )

	Widget:registerEventHandler("gain_focus", function (Sender, Event)
		if Sender.m_focusable then
			local gameOptionList = Sender.gameOptionList
			if gameOptionList:processEvent(Event) then
				return true
			end
		end
		return LUI.UIElement.gainFocus(Sender, Event)
	end)
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.gameOptionList:close()
		Sender.optionInfo:close()
	end)
	if setupOptionsRefresh then
		setupOptionsRefresh(Widget, controller, HudRef)
	end
	return Widget
end

