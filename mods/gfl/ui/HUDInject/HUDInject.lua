-- This file will allow you to inject your own custom HUD Widgets into stock HUD without rebuilding them. Have fun!
require("ui.t7.utility.SavingDataUtility")

CoD.HUDInject = InheritFrom(LUI.UIElement)
CoD.HUDInject.Maps = {}

-- Removes score from All HUDs. Add more here to remove items from the HUD.
local function zmAllRemoveElements(InjectionWidget, HudRef, InstanceRef)
    -- Removes score HUD from all maps
    --local mapHUD = HudRef.T7HudMenuGameMode
    --mapHUD:removeElement(mapHUD.Score)

    
end

-- Adds injection text to Factory HUD. Add more here to inject into HUD.
local function zmFactoryInjectElements(InjectionWidget, HudRef, InstanceRef)
    --InjectionWidget.DevWins = CoD.TextWithBg.new(HudRef, InstanceRef)
    --InjectionWidget.DevWins:setLeftRight(true, true, 240, -240)
    --InjectionWidget.DevWins:setTopBottom(true, false, 20, 50)
    --InjectionWidget.DevWins.Text:setText("HUD Inject")
    --InjectionWidget.DevWins.Bg:setRGB(0.098, 0.098, 0.098)
    --InjectionWidget.DevWins.Bg:setAlpha(0.8)
    --InjectionWidget:addElement(InjectionWidget.DevWins)

end

--Inject widgets to all maps
local function zmAllInjectElements(InjectionWidget, HudRef, InstanceRef)
    --InjectionWidget.DevWins = CoD.TextWithBg.new(HudRef, InstanceRef)
    --InjectionWidget.DevWins:setLeftRight(true, true, 240, -240)
    --InjectionWidget.DevWins:setTopBottom(true, false, 20, 50)
    --InjectionWidget.DevWins.Text:setText("TEST")
    --InjectionWidget.DevWins.Bg:setRGB(0.098, 0.098, 0.098)
    --InjectionWidget.DevWins.Bg:setAlpha(0.8)
    --InjectionWidget:addElement(InjectionWidget.DevWins)

end

-- Add every widget that you injected in here for proper cleanup.
local function zmFactoryCleanupElements(InjectionWidget)
    InjectionWidget.DevWins:close()
end
--clean up all maps
local function zmAllCleanupElements(InjectionWidget)
    InjectionWidget.DevWins:close()
end

-- Takes args to simplify adding new map entries. Use "zm_all" for mapName to incject to all maps.
-- Be warned, if you try to reference an element that does not have that element, you will get a UI Error
local function AddElementsForMap(mapName, removeElements, injectElements, cleanupElements)
    local mapTable = {
        mapName = mapName,
        removeElements = removeElements,
        injectElements = injectElements,
        cleanupElements = cleanupElements
    }

    table.insert(CoD.HUDInject.Maps, mapTable)
end

-- Constructs the table used to add/remove/cleanup elements on HUD.
local function CreateMapsTable()
    -- Add entries for new maps like this.
    -- Use nil for injection, removal, or cleanup if you don't want to use them.
    -- Do actions for The Giant. Removal function is nil since we're not removing anything specific to The Giant.
    AddElementsForMap("zm_factory", nil, zmFactoryInjectElements, zmFactoryCleanupElements)
    -- Do actions for all maps. Injection and cleanup functions are nil since we're not injecting stuff to all maps.
    AddElementsForMap("zm_all", zmAllRemoveElements, zmAllInjectElements, zmAllCleanupElements)
end

-- Injection widget. This will be injected into the map specific HUD.
function CoD.HUDInject.new(HudRef, InstanceRef)
    local Widget = LUI.UIElement.new()
    Widget:setClass(CoD.HUDInject)
    Widget.id = "HUDInject"
    Widget.soundSet = "default"
    Widget.anyChildUsesUpdateState = false
    
    -- Injector widget takes up entire screen. This is so we can inject elements anywhere on the HUD.
    Widget:setLeftRight(true, true, 0, 0)
    Widget:setTopBottom(true, true, 0, 0)

    CreateMapsTable()

    -- Add widgets to be injected here.
    local mapName = Engine.GetCurrentMap()
    for index=1, #CoD.HUDInject.Maps do
        local mapTable = CoD.HUDInject.Maps[index]
        if mapTable.mapName == mapName or mapTable.mapName == "zm_all" then
            -- Remove elements from the map's hud
            if mapTable.removeElements then
                mapTable.removeElements(Widget, HudRef, InstanceRef)
            end
            -- Add elements to the map's hud
            if mapTable.injectElements then
                mapTable.injectElements(Widget, HudRef, InstanceRef)
            end
            -- Setup close function to cleanup
            if mapTable.cleanupElements then
                LUI.OverrideFunction_CallOriginalSecond(HudRef.T7HudMenuGameMode, "close", mapTable.cleanupElements)
            end
        end
    end

    return Widget
end

-- Original function rebuilt from disassembled file. Loading this in CSC or require() in lua will override the stock function with our custom one.
local function AddHUDWidgetsOriginal(HudRef, Unknown)
    if Engine.IsDemoPlaying() then
        if HudRef.safeArea then
            -- Demo element doesn't exist (== nil)
            if not HudRef.safeArea.Demo then
                HudRef.safeArea.Demo = CoD.Demo.new(HudRef.safeArea, InstanceRef.controller)
                HudRef.safeArea.Demo:setLeftRight(true, true, 0, 0)
                HudRef.safeArea.Demo:setTopBottom(true, true, 0, 0)
                -- Basically addElement
                HudRef:addForceClosedSafeAreaChild(HudRef.safeArea.Demo)

                HudRef.safeArea.Demo:processEvent({
                    name = "gain_focus",
                    controller = InstanceRef.controller
                })
                HudRef.safeArea.Demo:gainFocus({
                    controller = InstanceRef.controller
                })

                LUI.OverrideFunction_CallOriginalSecond(HudRef.safeArea.Demo, "close", function(Widget)
                    CoD.Menu.UnsubscribeFromControllerSubscriptionsForElement(HudRef.safeArea, Widget)
                end)

                UpdateState(HudRef.safeArea.Demo)
                HudRef:registerEventHandler("occlusion_change", function(Sender, Event)
                    if not Event.occluded then
                        Sender.safeArea.Demo:processEvent({
                            name = "gain_focus",
                            controller = InstanceRef.controller
                        })
                    end

                    CoD.Menu.OcclusionChange(Sender, Event)
                end)
            end
            
            

            -- The element exists at this point
            CoD.DemoUtility.AddInformationScreen(HudRef)

            if InstanceRef.activateDemoStartScreen then
                if not CoD.DemoUtility.LastActivatedInformationScreen == Enum.demoInformationScreenTypes.DEMO_INFORMATION_SCREEN_FILM_START_SCREEN_FADE_OUT then
                    CoD.DemoUtility.ActivateInformationScreen(HudRef, {
                        controller = InstanceRef.controller,
                        informationScreenType = Enum.demoInformationScreenTypes.DEMO_INFORMATION_SCREEN_FILM_START_SCREEN_FADE_IN,
                        animationTime = 0,
                        animationState = "fade_in"
                    })
                else
                    if InstanceRef.openHighlightStartScreen then
                        CoD.DemoUtility.OpenStartHighlightReel(HudRef, InstanceRef)
                    else
                        -- Still need to check if it exists. Just in case.
                        if HudRef.safeArea then
                            if HudRef.safeArea.Demo then
                                HudRef.safeArea.Demo:close()
                                HudRef.safeArea.Demo = nil
                            end
                        end
                    end
                end
            end
        end
    end
end

-- This function gets called when the HUD initialized. This will be used as an injection point
-- HudRef is the HUD that was opened. This is not t7hud_zm_MAPNAME. This is the parent menu file, one level up from map hud.
-- To access the MAP HUD, simply use HudRef.T7HudMenuGameMode
-- Powerup HUD can also be accessed this way: HudRef.powerupsArea
CoD.DemoUtility.AddHUDWidgets = function(HudRef, InstanceRef)
    AddHUDWidgetsOriginal(HudRef, InstanceRef)

    
    local function CheckForSaveData(ModelRef)
        if IsParamModelEqualToString(ModelRef, "setSaveData") then
           local notifyData = CoD.GetScriptNotifyData( ModelRef )
           CoD.SavingDataUtility.SaveData(InstanceRef, notifyData[1], notifyData[2])
        elseif IsParamModelEqualToString(ModelRef, "getSaveData") then
           local notifyData = CoD.GetScriptNotifyData( ModelRef )
           local SaveDataValue = CoD.SavingDataUtility.GetData(InstanceRef, notifyData[1])
           Engine.SendMenuResponse(InstanceRef, "restartgamepopup", notifyData[1] .. "," .. SaveDataValue)
        end
    end
    HudRef:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", CheckForSaveData)
    --HudRef.T7HudMenuGameMode.HUDInject = CoD.HUDInject.new(HudRef, InstanceRef)
    --HudRef.T7HudMenuGameMode:addElement(HudRef.T7HudMenuGameMode.HUDInject)
end