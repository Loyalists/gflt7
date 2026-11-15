require("ui.uieditor.widgets.List1Button_Playlist")

local buttonWidth = 280
local labelInset = 12

local removeLastCharacter = function(text)
    local last = #text
    -- Step over UTF-8 continuation bytes so ellipsis never splits a character.
    while last > 0 and string.byte(text, last) >= 128 and string.byte(text, last) < 192 do
        last = last - 1
    end
    return string.sub(text, 1, last - 1)
end

local configureLabel = function(button, label, resizeButton)
    label:setLeftRight(true, false, labelInset, buttonWidth - labelInset)
    label.setText = function(element, text)
        local displayText = string.gsub(text or "", "[\r\n\t]", " ")
        LUI.UIText.setText(element, displayText)
        if element:getTextWidth() > buttonWidth - 2 * labelInset then
            repeat
                displayText = removeLastCharacter(displayText)
                LUI.UIText.setText(element, displayText .. "...")
            until displayText == "" or element:getTextWidth() <= buttonWidth - 2 * labelInset
        end

        -- Match the stock text-sized background, bounded by the map column.
        if resizeButton then
            button:setWidth(math.min(buttonWidth, element:getTextWidth() + 2 * labelInset))
        end
    end
end

CoD.GFLMapSelectionButton = InheritFrom(CoD.List1Button_Playlist)
CoD.GFLMapSelectionButton.new = function(menu, controller)
    local self = CoD.List1Button_Playlist.new(menu, controller)
    self:setLeftRight(true, false, 0, buttonWidth)
    configureLabel(self, self.btnDisplayText, true)
    configureLabel(self, self.btnDisplayTextStroke, false)
    return self
end
