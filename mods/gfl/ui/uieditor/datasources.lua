require("ui.uieditor.datasources_og")

DataSources.GalleryList = ListHelper_SetupDataSource("GalleryList", function(f777_arg0)
    local f777_local0 = {}
    local f777_local1 = {"cp_mi_eth_prologue", "cp_mi_zurich_newworld", "cp_mi_sing_blackstation",
                         "cp_mi_sing_biodomes", "cp_mi_sing_sgen", "cp_mi_sing_vengeance", "cp_mi_cairo_ramses",
                         "cp_mi_cairo_infection", "cp_mi_cairo_aquifer", "cp_mi_cairo_lotus", "cp_mi_zurich_coalescence"}
    local f777_local2 = Engine.GetPlayerStats(f777_arg0)
    local f777_local3 = Engine.GetAssetList("cp_default_gallery")
    for f777_local4 = 1, #f777_local3, 1 do
        table.insert(f777_local0, {
            models = {
                displayName = f777_local3[f777_local4].displayName,
                image = f777_local3[f777_local4].image,
                unlocked = true
            },
            properties = {
                mapName = "",
                unlocked = true
            }
        })
    end
    for f777_local4 = 1, #f777_local1, 1 do
        local f777_local7 = f777_local1[f777_local4]
        local f777_local8 = CoD.mapsTable[f777_local7]
        local f777_local9
        -- if f777_local2.PlayerStatsByMap[f777_local7].hasBeenCompleted:get() ~= 1 then
        --     f777_local9 = f777_local8.isSafeHouse
        -- else
        --     f777_local9 = true
        -- end
        f777_local9 = true
        if f777_local9 then
            f777_local3 = Engine.GetAssetList(f777_local7 .. "_list")
            if f777_local3 ~= nil then
                for f777_local10 = 1, #f777_local3, 1 do
                    table.insert(f777_local0, {
                        models = {
                            displayName = f777_local3[f777_local10].displayName,
                            image = f777_local3[f777_local10].image,
                            unlocked = true
                        },
                        properties = {
                            mapName = "",
                            unlocked = true
                        }
                    })
                end
            end
        end
    end
    return f777_local0
end)

DataSources.StartMenuSelectionList = {
    prepare = function(f99_arg0, f99_arg1, f99_arg2)
        f99_arg1.options = {}
        local f99_local0 = nil
        if CoD.isCampaign == true then
            f99_local0 = {{
                optionDisplay = "MENU_RESTART_MISSION_CAPS",
                action = RestartMission
            }, {
                optionDisplay = "MENU_RESTART_CHECKPOINT_CAPS",
                action = RestartFromCheckpoint
            }, {
                optionDisplay = "MENU_END_GAME_CAPS",
                action = QuitGame
            }}
        else
            f99_local0 = {{
                optionDisplay = "MPUI_CHOOSE_CLASS_CAPS",
                action = ChooseClass
            }, {
                optionDisplay = "MPUI_CHANGE_TEAM_BUTTON_CAPS",
                action = ChooseTeam
            }, {
                optionDisplay = "MENU_LEAVE_GAME_CAPS",
                action = QuitGame_MP
            }}
        end
        if not f99_local0 then
            return
        end
        local f99_local1 = Engine.CreateModel(Engine.GetGlobalModel(), "StartMenuSelectionModel")
        for f99_local5, f99_local6 in ipairs(f99_local0) do
            local f99_local7 = Engine.CreateModel(f99_local1, "buttonModel_" .. f99_local5)
            f99_arg1.options[f99_local5] = f99_local7
            Engine.SetModelValue(Engine.CreateModel(f99_local7, "displayText"),
                Engine.Localize(f99_local6.optionDisplay))
            Engine.SetModelValue(Engine.CreateModel(f99_local7, "action"), f99_local6.action)
        end
    end,
    getCount = function(f100_arg0)
        return #f100_arg0.options
    end,
    getItem = function(f101_arg0, f101_arg1, f101_arg2)
        return f101_arg1.options[f101_arg2]
    end
}

DataSources.StartMenuGameOptions = ListHelper_SetupDataSource("StartMenuGameOptions", function(f89_arg0)
    local f89_local0 = {}
    if Engine.IsDemoPlaying() then
        local f89_local1 = Engine.GetDemoSegmentCount()
        local f89_local2 = Engine.IsDemoHighlightReelMode()
        local f89_local3 = Engine.IsDemoClipPlaying()
        if not IsDemoRestrictedBasicMode() then
            table.insert(f89_local0, {
                models = {
                    displayText = Engine.ToUpper(Engine.Localize("MENU_UPLOAD_CLIP", f89_local1)),
                    action = StartMenuUploadClip,
                    disabledFunction = IsUploadClipButtonDisabled
                },
                properties = {
                    hideHelpItemLabel = true
                }
            })
        end
        if f89_local2 then
            table.insert(f89_local0, {
                models = {
                    displayText = Engine.ToUpper(Engine.Localize("MENU_DEMO_CUSTOMIZE_HIGHLIGHT_REEL")),
                    action = StartMenuOpenCustomizeHighlightReel,
                    disabledFunction = IsCustomizeHighlightReelButtonDisabled
                }
            })
        end
        table.insert(f89_local0, {
            models = {
                displayText = Engine.ToUpper(Engine.ToUpper(Engine.Localize("MENU_JUMP_TO_START"))),
                action = StartMenuJumpToStart,
                disabledFunction = IsJumpToStartButtonDisabled
            },
            properties = {
                hideHelpItemLabel = true
            }
        })
        local f89_local4 = nil
        if f89_local3 then
            f89_local4 = Engine.ToUpper(Engine.Localize("MENU_END_CLIP"))
        else
            f89_local4 = Engine.ToUpper(Engine.Localize("MENU_END_FILM"))
        end
        table.insert(f89_local0, {
            models = {
                displayText = Engine.ToUpper(f89_local4),
                action = StartMenuEndDemo
            }
        })
    elseif CoD.isCampaign then
        table.insert(f89_local0, {
            models = {
                displayText = "MENU_RESUMEGAME_CAPS",
                action = StartMenuGoBack_ListElement
            }
        })
        local f89_local1 = CoD.SafeGetModelValue(Engine.GetModelForController(f89_arg0), "safehouse.inTrainingSim") or 0
        if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) then
            if not CoD.isSafehouse and f89_arg0 == Engine.GetPrimaryController() then
                table.insert(f89_local0, {
                    models = {
                        displayText = "MENU_RESTART_MISSION_CAPS",
                        action = RestartMission
                    }
                })
                table.insert(f89_local0, {
                    models = {
                        displayText = "MENU_RESTART_CHECKPOINT_CAPS",
                        action = RestartFromCheckpoint
                    }
                })
            end
            if f89_arg0 == Engine.GetPrimaryController() then
                table.insert(f89_local0, {
                    models = {
                        displayText = "MENU_CHANGE_DIFFICULTY_CAPS",
                        action = OpenDifficultySelect
                    }
                })
            end
            if CoD.isSafehouse and f89_local1 == 1 then
                table.insert(f89_local0, {
                    models = {
                        displayText = "MENU_END_TRAINING_SIM",
                        action = EndTrainingSim
                    }
                })
            elseif f89_arg0 == Engine.GetPrimaryController() then
                if Engine.DvarBool(0, "ui_blocksaves") then
                    table.insert(f89_local0, {
                        models = {
                            displayText = "MENU_EXIT_CAPS",
                            action = SaveAndQuitGame
                        }
                    })
                else
                    table.insert(f89_local0, {
                        models = {
                            displayText = "MENU_SAVE_AND_QUIT_CAPS",
                            action = SaveAndQuitGame
                        }
                    })
                end
            end
        elseif CoD.isSafehouse and f89_local1 == 1 then
            table.insert(f89_local0, {
                models = {
                    displayText = "MENU_END_TRAINING_SIM",
                    action = EndTrainingSim
                }
            })
        else
            table.insert(f89_local0, {
                models = {
                    displayText = "MENU_LEAVE_PARTY_AND_EXIT_CAPS",
                    action = QuitGame
                }
            })
        end
    elseif CoD.isMultiplayer then
        if Engine.Team(f89_arg0, "name") ~= "TEAM_SPECTATOR" and Engine.GetGametypeSetting("disableClassSelection") ~= 1 then
            table.insert(f89_local0, {
                models = {
                    displayText = "MPUI_CHOOSE_CLASS_BUTTON_CAPS",
                    action = ChooseClass
                }
            })
        end
        if Engine.GameModeIsMode(CoD.GAMEMODE_PUBLIC_MATCH) == false and
            Engine.GameModeIsMode(CoD.GAMEMODE_LEAGUE_MATCH) == false and
            not Engine.IsVisibilityBitSet(f89_arg0, Enum.UIVisibilityBit.BIT_ROUND_END_KILLCAM) and
            not Engine.IsVisibilityBitSet(f89_arg0, Enum.UIVisibilityBit.BIT_FINAL_KILLCAM) and
            CoD.IsTeamChangeAllowed() then
            table.insert(f89_local0, {
                models = {
                    displayText = "MPUI_CHANGE_TEAM_BUTTON_CAPS",
                    action = ChooseTeam
                }
            })
        end
        if f89_arg0 == 0 then
            local f89_local2 = "MENU_QUIT_GAME_CAPS"
            if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) and not CoD.isOnlineGame() then
                f89_local2 = "MENU_END_GAME_CAPS"
            end
            table.insert(f89_local0, {
                models = {
                    displayText = f89_local2,
                    action = QuitGame_MP
                }
            })
        end
    elseif CoD.isZombie then
        table.insert(f89_local0, {
            models = {
                displayText = "MENU_RESUMEGAME_CAPS",
                action = StartMenuGoBack_ListElement
            }
        })
        if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) == true then
            table.insert(f89_local0, {
                models = {
                    displayText = "MENU_RESTART_LEVEL_CAPS",
                    action = RestartGame
                }
            })
            table.insert(f89_local0, {
                models = {
                    displayText = "GFL_MENU_TFOPTIONS",
                    action = OpenTFOptions_InGame
                }
            })
        end
        table.insert(f89_local0, {
            models = {
                displayText = "CPUI_CHOOSE_CHARACTER_CAPS",
                action = OpenZMChooseCharacterLoadout_InGame
            }
        })
        if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) == true then
            table.insert(f89_local0, {
                models = {
                    displayText = "MENU_END_GAME_CAPS",
                    action = QuitGame_MP
                }
            })
        else
            table.insert(f89_local0, {
                models = {
                    displayText = "MENU_QUIT_GAME_CAPS",
                    action = QuitGame_MP
                }
            })
        end
    end
    table.insert(f89_local0, {
        models = {
            displayText = "QUIT TO DESKTOP",
            action = OpenPCQuit
        }
    })
    return f89_local0
end, true)

DataSources.ChatClientEntriesList = {
    prepare = function(controller, menu, f914_arg2)
        local function BooleanToNumber(value)
            return value and 1 or 0
        end

        menu.numElementsInList = menu.vCount
        menu.controller = controller
        menu.chatClientEntriesModel = CoD.ChatClientUtility.GetChatEntriesListModel()
        menu.filter = Engine.ChatClient_FilterChannelGet(controller, Enum.chatChannel_e.CHAT_CHANNEL_COUNT)
        menu.GetList = Engine.ChatClient_GetEntries
        menu.CountEntries = Engine.ChatClient_EntriesCount(controller, menu.filter)
        local f914_local0 = {
            xuid = 0,
            fullname = "",
            text = "",
            timestamp = "",
            timeMs = 0,
            chText = "",
            chColor = ""
        }
        menu.chatEntries = {}
        for f914_local1 = 1, menu.numElementsInList, 1 do
            menu.chatEntries[f914_local1] = {}
            menu.chatEntries[f914_local1].root =
                Engine.CreateModel(menu.chatClientEntriesModel, "entry_" .. f914_local1)
            menu.chatEntries[f914_local1].model = Engine.CreateModel(menu.chatEntries[f914_local1].root, "model")
            menu.chatEntries[f914_local1].properties = {}
            for f914_local7, f914_local8 in pairs(f914_local0) do
                local f914_local9 = Engine.CreateModel(menu.chatEntries[f914_local1].model, f914_local7)
            end
        end
        menu.updateModels = function(f915_arg0, f915_arg1, f915_arg2, f915_arg3)
            if not f915_arg1.GetList then
                return
            end
            local f915_local0 = {}
            f915_local0 = f915_arg1.GetList(f915_arg0, f915_arg2, f915_arg3, f915_arg1.filter)
            if f915_local0 then
                local sending_timeMs = 0
                local sending_User = 0
                local sending_Text = ""
                local sending_Name = ""
                if not Dvar.chat_LastMs:exists() then
                    Engine.SetDvar("chat_LastMs", 0)
                end

                local chat_LastMs = tonumber(Dvar.chat_LastMs:get())
                if chat_LastMs == nil then
                    chat_LastMs = 0
                end
                -- if type(chat_LastMs) == "boolean" then
                -- 	chat_LastMs = BooleanToNumber(chat_LastMs)
                -- end

                for f915_local1 = 1, #f915_local0, 1 do
                    local f915_local4 = f915_local0[f915_local1]
                    local f915_local5 = #f915_local0 + 1 - f915_local1
                    for f915_local9, f915_local10 in pairs(f915_local4) do
                        local f915_local11 = Engine.GetModel(f915_arg1.chatEntries[f915_local5].model, f915_local9)
                        if f915_local11 ~= nil then
                            Engine.SetModelValue(f915_local11, f915_local10)
                        end
                        f915_arg1.chatEntries[f915_local5].properties[f915_local9] = f915_local10
                        if f915_local9 == "timeMs" then
                            sending_timeMs = math.floor(f915_local10 / 1000)
                        end
                        if f915_local9 == "xuid" then
                            sending_User = f915_local10
                        end
                        if f915_local9 == "fullname" then
                            sending_Name = string.sub(tostring(f915_local10), 1, -2)
                        end
                        if f915_local9 == "text" then
                            sending_Text = f915_local10
                        end
                    end
                    if tostring(Engine.GetXUID64(controller)) == tostring(sending_User) then
                        if sending_timeMs > math.floor(chat_LastMs) then
                            SendChatNotifyResponse(controller, sending_Text)
                            Engine.SetDvar("chat_LastMs", sending_timeMs)
                            -- Engine.SetDvar("chat_last_xuid", tostring(sending_User))
                            -- Engine.SetDvar("chat_last_fullname", sending_Name)
                            -- Engine.SetDvar("chat_last_text", sending_Text)
                        end
                    end
                    if Engine.IsBOIII == true and tostring(sending_Name) ==
                        tostring(Engine.GetPlayerNameForClientNum(Engine.GetClientNum(controller))) and sending_timeMs >
                        math.floor(chat_LastMs) then
                        SendChatNotifyResponse(controller, sending_Text)
                        Engine.SetDvar("chat_LastMs", sending_timeMs)
                        -- Engine.SetDvar("chat_last_xuid", tostring(sending_User))
                        -- Engine.SetDvar("chat_last_fullname", sending_Name)
                        -- Engine.SetDvar("chat_last_text", sending_Text)
                    end
                end
            end
            return f915_arg1.chatEntries[f915_arg2 % f915_arg1.numElementsInList + 1].model
        end

        menu.updateModels(controller, menu, 0, menu.numElementsInList)
        if menu.updateSubscription then
            menu:removeSubscription(menu.updateSubscription)
        end
        menu.updateSubscription = menu:subscribeToModel(CoD.ChatClientUtility.GetUpdateModel(), function()
            menu:updateDataSource()
        end, false)
    end,
    getCount = function(f917_arg0)
        return f917_arg0.CountEntries
    end,
    getItem = function(f918_arg0, f918_arg1, f918_arg2)
        return f918_arg1.chatEntries[f918_arg2].model
    end
}

for i = 0, Engine.GetMaxControllerCount() - 1, 1 do
    local hudItems = Engine.CreateModel(Engine.GetModelForController(i), "hudItems")
    Engine.CreateModel(hudItems, "ThirdpersonCrosshair")
    Engine.CreateModel(hudItems, "CharacterPopup")
    Engine.CreateModel(hudItems, "spawn_actor_healthbar")
end
