require("ui.uieditor.datasources_og")

for i = 0, Engine.GetMaxControllerCount() - 1, 1 do
    local hudItems = Engine.CreateModel(Engine.GetModelForController(i), "hudItems")
    Engine.CreateModel(hudItems, "ThirdpersonCrosshair")
    Engine.CreateModel(hudItems, "CharacterPopup")
    Engine.CreateModel(hudItems, "spawn_actor_healthbar")
    Engine.CreateModel( hudItems, "hud_offset" )
end
Engine.CreateModel( Engine.GetGlobalModel(), "CustomHUD" )

function GetZMStartMenuGameOptions( short, withOptions )
    local options = {}
    if CoD.isZombie then
        table.insert(options, {
            models = {
                displayText = "MENU_RESUMEGAME_CAPS",
                action = StartMenuGoBack_ListElement
            }
        })

        table.insert(options, {
            models = {
                displayText = "CODCASTER_QS_THIRD_PERSON",
                action = HandleToggleThirdPersonButton
            }
        })

        if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) then
            table.insert(options, {
                models = {
                    displayText = "MENU_RESTART_LEVEL_CAPS",
                    action = RestartGame
                }
            })

            local tfoptionsText = "GFL_MENU_TFOPTIONS"
            if short then
                tfoptionsText = "GFL_MENU_TFOPTIONS_SHORT"
            end
            table.insert(options, {
                models = {
                    displayText = tfoptionsText,
                    action = OpenTFOptions_InGame
                }
            })
        end

        if withOptions then
            table.insert(options, {
                models = {
                    displayText = "MENU_OPTIONS_CAPS",
                    action = function(self, element, controller, actionParam, menu)
                        NavigateToMenu(menu, "GenericStartMenu_Options", true, controller)
                    end
                }
            })
        end
        
        local charactersText = "CPUI_CHOOSE_CHARACTER_CAPS"
        if short then
            charactersText = "GFL_MENU_CHARACTERS"
        end
        table.insert(options, {
            models = {
                displayText = charactersText,
                action = OpenZMChooseCharacterLoadout_InGame
            }
        })
        table.insert(options, {
            models = {
                displayText = "GFL_MENU_MOD_INFO",
                action = OpenModInfo_InGame
            }
        })
        if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) then
            table.insert(options, {
                models = {
                    displayText = "MENU_END_GAME_CAPS",
                    action = QuitGame_MP
                }
            })
        else
            table.insert(options, {
                models = {
                    displayText = "MENU_QUIT_GAME_CAPS",
                    action = QuitGame_MP
                }
            })
        end
        table.insert(options, {
            models = {
                displayText = "QUIT TO DESKTOP",
                action = OpenPCQuit
            }
        })
    end
    return options
end

function LocalizeOptions(options)
    for _, option in ipairs(options) do
        if option.models and option.models.displayText then
            option.models.displayText = Engine.Localize(option.models.displayText)
        end
    end
end

DataSources.FeaturedCardHelper = function ( controller, f196_arg1 )
	local featuredCards = {}
	local sequence = 0

	if 1 == Dvar.ui_enableZMHDFeaturedCard:get() or Dvar.ui_enableZMHDFeaturedCard:get() == "1" then
		local background = "t7_crm_zmhd_cosmic_featured_thermometerlocked"
		if IsThermometerProgressEqualTo( 1 ) then
			background = "t7_crm_zmhd_cosmic_featured_thermometer"
		end
		table.insert( featuredCards, {
			models = {
				title = "",
				actionTitle = "MENU_DETAILS",
				action = "open_zmhd_thermometer",
				background = background,
				sequence = sequence
			}
		} )
		sequence = sequence + 1
	end

	local featuredCardsData = Engine.GetFeaturedCardsData()
	if featuredCardsData ~= nil then
		local cardsCountToShow = featuredCardsData.cardsCountToShow
		if featuredCardsData.enabled == true and 0 < cardsCountToShow then
			for index = 0, cardsCountToShow - 1, 1 do
				local featuredCard = Engine.GetFeaturedCard( index )
				if featuredCard.valid == true then
					local includeCard = true
					if featuredCard.subTitle == "zm" and not CoD.isZombie then
						includeCard = false
					end
					if featuredCard.subTitle == "mp" and not CoD.isMultiplayer then
						includeCard = false
					end
					if includeCard then
						table.insert( featuredCards, {
							models = {
								index = index,
								title = featuredCard.title,
								subTitle = featuredCard.subTitle,
								type = featuredCard.type,
								actionTitle = featuredCard.actionTitle,
								action = featuredCard.action,
								background = featuredCard.bg,
								sequence = sequence
							}
						} )
						sequence = sequence + 1
					end
				end
			end
		end
	end

	if CoD.isZombie then
		local f196_local3 = nil
		table.insert( featuredCards, {
			models = {
                title = "MENU_INTEL_CAPS",
				actionTitle = "MENU_DETAILS",
				action = "gfl_open_welcomemenu",
                background = "t7_crm_gfl_intel_room",
				sequence = sequence
			},
		} )
		sequence = sequence + 1

		table.insert( featuredCards, {
			models = {
                title = "Latest Changelogs",
				actionTitle = "MENU_DETAILS",
				action = "gfl_open_changelogs",
                background = "t7_crm_gfl_dday",
				sequence = sequence
			},
		} )
		sequence = sequence + 1
	end

	return featuredCards
end

DataSources.FeaturedCards = ListHelper_SetupDataSource( "FeaturedCards", function ( controller )
	return DataSources.FeaturedCardHelper( controller, true )
end, nil, nil, DataSources.FeaturedCardPostCreationHelper )

DataSources.FeaturedCardTicks = ListHelper_SetupDataSource( "FeaturedCardTicks", function ( controller )
	return DataSources.FeaturedCardHelper( controller, false )
end, nil, nil, DataSources.FeaturedCardPostCreationHelper )

DataSources.GFLCRMButtonList = {
	prepare = function ( f651_arg0, f651_arg1, f651_arg2 )
		f651_arg1.optionModels = {}
		local f651_local0 = {
			{
				displayText = "MENU_OK",
				displayImage = "",
				displayDesc = "",
				action = GoBack
			}
		}
		local listModel = Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "GFLCRMButtonList" ), "list" )
		for index, f651_local6 in ipairs( f651_local0 ) do
			f651_arg1.optionModels[index] = Engine.CreateModel( listModel, "buttonModel_" .. index )
			Engine.SetModelValue( Engine.CreateModel( f651_arg1.optionModels[index], "displayText" ), Engine.Localize( f651_local6.displayText ) )
			Engine.SetModelValue( Engine.CreateModel( f651_arg1.optionModels[index], "displayImage" ), f651_local6.displayImage )
			Engine.SetModelValue( Engine.CreateModel( f651_arg1.optionModels[index], "hintText" ), Engine.Localize( f651_local6.displayDesc ) )
			Engine.SetModelValue( Engine.CreateModel( f651_arg1.optionModels[index], "action" ), f651_local6.action )
		end
	end,
	getCount = function ( f652_arg0 )
		return #f652_arg0.optionModels
	end,
	getItem = function ( f653_arg0, f653_arg1, f653_arg2 )
		return f653_arg1.optionModels[f653_arg2]
	end
}

DataSources.GalleryList = ListHelper_SetupDataSource("GalleryList", function(controller)
    local galleryItems = {}
    local campaignMaps = {"cp_mi_eth_prologue", "cp_mi_zurich_newworld", "cp_mi_sing_blackstation",
                         "cp_mi_sing_biodomes", "cp_mi_sing_sgen", "cp_mi_sing_vengeance", "cp_mi_cairo_ramses",
                         "cp_mi_cairo_infection", "cp_mi_cairo_aquifer", "cp_mi_cairo_lotus", "cp_mi_zurich_coalescence"}
    local playerStats = Engine.GetPlayerStats(controller)
    local assets = Engine.GetAssetList("cp_default_gallery")
    for f777_local4 = 1, #assets, 1 do
        table.insert(galleryItems, {
            models = {
                displayName = assets[f777_local4].displayName,
                image = assets[f777_local4].image,
                unlocked = true
            },
            properties = {
                mapName = "",
                unlocked = true
            }
        })
    end
    for f777_local4 = 1, #campaignMaps, 1 do
        local mapName = campaignMaps[f777_local4]
        local mapInfo = CoD.mapsTable[mapName]
        local f777_local9
        -- if f777_local2.PlayerStatsByMap[f777_local7].hasBeenCompleted:get() ~= 1 then
        --     f777_local9 = f777_local8.isSafeHouse
        -- else
        --     f777_local9 = true
        -- end
        f777_local9 = true
        if f777_local9 then
            assets = Engine.GetAssetList(mapName .. "_list")
            if assets ~= nil then
                for f777_local10 = 1, #assets, 1 do
                    table.insert(galleryItems, {
                        models = {
                            displayName = assets[f777_local10].displayName,
                            image = assets[f777_local10].image,
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
    return galleryItems
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
        local startMenuSelectionModelModel = Engine.CreateModel(Engine.GetGlobalModel(), "StartMenuSelectionModel")
        for index, f99_local6 in ipairs(f99_local0) do
            local model = Engine.CreateModel(startMenuSelectionModelModel, "buttonModel_" .. index)
            f99_arg1.options[index] = model
            Engine.SetModelValue(Engine.CreateModel(model, "displayText"),
                Engine.Localize(f99_local6.optionDisplay))
            Engine.SetModelValue(Engine.CreateModel(model, "action"), f99_local6.action)
        end
    end,
    getCount = function(f100_arg0)
        return #f100_arg0.options
    end,
    getItem = function(f101_arg0, f101_arg1, f101_arg2)
        return f101_arg1.options[f101_arg2]
    end
}

DataSources.StartMenuGameOptions = ListHelper_SetupDataSource("StartMenuGameOptions", function(controller)
    local options = {}
    if Engine.IsDemoPlaying() then
        local demoSegmentCount = Engine.GetDemoSegmentCount()
        local isDemoHighlightReelMode = Engine.IsDemoHighlightReelMode()
        local isDemoClipPlaying = Engine.IsDemoClipPlaying()
        if not IsDemoRestrictedBasicMode() then
            table.insert(options, {
                models = {
                    displayText = Engine.ToUpper(Engine.Localize("MENU_UPLOAD_CLIP", demoSegmentCount)),
                    action = StartMenuUploadClip,
                    disabledFunction = IsUploadClipButtonDisabled
                },
                properties = {
                    hideHelpItemLabel = true
                }
            })
        end
        if isDemoHighlightReelMode then
            table.insert(options, {
                models = {
                    displayText = Engine.ToUpper(Engine.Localize("MENU_DEMO_CUSTOMIZE_HIGHLIGHT_REEL")),
                    action = StartMenuOpenCustomizeHighlightReel,
                    disabledFunction = IsCustomizeHighlightReelButtonDisabled
                }
            })
        end
        table.insert(options, {
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
        if isDemoClipPlaying then
            f89_local4 = Engine.ToUpper(Engine.Localize("MENU_END_CLIP"))
        else
            f89_local4 = Engine.ToUpper(Engine.Localize("MENU_END_FILM"))
        end
        table.insert(options, {
            models = {
                displayText = Engine.ToUpper(f89_local4),
                action = StartMenuEndDemo
            }
        })
    elseif CoD.isCampaign then
        table.insert(options, {
            models = {
                displayText = "MENU_RESUMEGAME_CAPS",
                action = StartMenuGoBack_ListElement
            }
        })
        table.insert(options, {
            models = {
                displayText = "CODCASTER_QS_THIRD_PERSON",
                action = HandleToggleThirdPersonButton
            }
        })
        local f89_local1 = CoD.SafeGetModelValue(Engine.GetModelForController(controller), "safehouse.inTrainingSim") or 0
        if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) then
            if not CoD.isSafehouse and controller == Engine.GetPrimaryController() then
                table.insert(options, {
                    models = {
                        displayText = "MENU_RESTART_MISSION_CAPS",
                        action = RestartMission
                    }
                })
                table.insert(options, {
                    models = {
                        displayText = "MENU_RESTART_CHECKPOINT_CAPS",
                        action = RestartFromCheckpoint
                    }
                })
            end
            if controller == Engine.GetPrimaryController() then
                table.insert(options, {
                    models = {
                        displayText = "MENU_CHANGE_DIFFICULTY_CAPS",
                        action = OpenDifficultySelect
                    }
                })
            end
            if CoD.isSafehouse and f89_local1 == 1 then
                table.insert(options, {
                    models = {
                        displayText = "MENU_END_TRAINING_SIM",
                        action = EndTrainingSim
                    }
                })
            elseif controller == Engine.GetPrimaryController() then
                if Engine.DvarBool(0, "ui_blocksaves") then
                    table.insert(options, {
                        models = {
                            displayText = "MENU_EXIT_CAPS",
                            action = SaveAndQuitGame
                        }
                    })
                else
                    table.insert(options, {
                        models = {
                            displayText = "MENU_SAVE_AND_QUIT_CAPS",
                            action = SaveAndQuitGame
                        }
                    })
                end
            end
        elseif CoD.isSafehouse and f89_local1 == 1 then
            table.insert(options, {
                models = {
                    displayText = "MENU_END_TRAINING_SIM",
                    action = EndTrainingSim
                }
            })
        else
            table.insert(options, {
                models = {
                    displayText = "MENU_LEAVE_PARTY_AND_EXIT_CAPS",
                    action = QuitGame
                }
            })
        end
    elseif CoD.isMultiplayer then
        if Engine.Team(controller, "name") ~= "TEAM_SPECTATOR" and Engine.GetGametypeSetting("disableClassSelection") ~= 1 then
            table.insert(options, {
                models = {
                    displayText = "MPUI_CHOOSE_CLASS_BUTTON_CAPS",
                    action = ChooseClass
                }
            })
        end
        if Engine.GameModeIsMode(CoD.GAMEMODE_PUBLIC_MATCH) == false and
            Engine.GameModeIsMode(CoD.GAMEMODE_LEAGUE_MATCH) == false and
            not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_ROUND_END_KILLCAM) and
            not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_FINAL_KILLCAM) and
            CoD.IsTeamChangeAllowed() then
            table.insert(options, {
                models = {
                    displayText = "MPUI_CHANGE_TEAM_BUTTON_CAPS",
                    action = ChooseTeam
                }
            })
        end

        table.insert(options, {
            models = {
                displayText = "CODCASTER_QS_THIRD_PERSON",
                action = HandleToggleThirdPersonButton
            }
        })

        if controller == 0 then
            local displayText = "MENU_QUIT_GAME_CAPS"
            if Engine.IsLobbyHost(Enum.LobbyType.LOBBY_TYPE_GAME) and not CoD.isOnlineGame() then
                displayText = "MENU_END_GAME_CAPS"
            end
            table.insert(options, {
                models = {
                    displayText = displayText,
                    action = QuitGame_MP
                }
            })
        end
    elseif CoD.isZombie then
        return GetZMStartMenuGameOptions(false, false)
    end
    table.insert(options, {
        models = {
            displayText = "QUIT TO DESKTOP",
            action = OpenPCQuit
        }
    })
    return options
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
            for modelName, f914_local8 in pairs(f914_local0) do
                local model = Engine.CreateModel(menu.chatEntries[f914_local1].model, modelName)
            end
        end
        menu.updateModels = function(controller2, menu, f915_arg2, f915_arg3)
            if not menu.GetList then
                return
            end
            local f915_local0 = {}
            f915_local0 = menu.GetList(controller2, f915_arg2, f915_arg3, menu.filter)
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
                    for modelName, value in pairs(f915_local4) do
                        local model = Engine.GetModel(menu.chatEntries[f915_local5].model, modelName)
                        if model ~= nil then
                            Engine.SetModelValue(model, value)
                        end
                        menu.chatEntries[f915_local5].properties[modelName] = value
                        if modelName == "timeMs" then
                            sending_timeMs = math.floor(value / 1000)
                        end
                        if modelName == "xuid" then
                            sending_User = value
                        end
                        if modelName == "fullname" then
                            sending_Name = string.sub(tostring(value), 1, -2)
                        end
                        if modelName == "text" then
                            sending_Text = value
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
            return menu.chatEntries[f915_arg2 % menu.numElementsInList + 1].model
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

DataSources.StartMenuTabs = ListHelper_SetupDataSource( "StartMenuTabs", function ( controller )
	local tabs = {}
	table.insert( tabs, {
		models = {
			tabIcon = CoD.buttonStrings.shoulderl
		},
		properties = {
			m_mouseDisabled = true
		}
	} )
	if Engine.IsDemoPlaying() then
		local f44_local1 = "CoD.StartMenu_GameOptions"
		if Engine.IsZombiesGame() then
			f44_local1 = "CoD.StartMenu_GameOptions_ZM"
		end
		table.insert( tabs, {
			models = {
				tabName = Engine.Localize( "MENU_THEATER_CAPS" ),
				tabWidget = f44_local1,
				tabIcon = ""
			},
			properties = {
				tabId = "gameOptions"
			}
		} )
	elseif Engine.IsInGame() then
		if IsGameTypeDOA() and not InSafehouse() then
			table.insert( tabs, {
				models = {
					tabName = "DOA",
					tabWidget = "CoD.StartMenu_GameOptions_DOA",
					tabIcon = ""
				},
				properties = {
					tabId = "gameOptions"
				}
			} )
		elseif CoD.isCampaign then
			table.insert( tabs, {
				models = {
					tabName = SessionModeToUnlocalizedSessionModeCaps( Engine.CurrentSessionMode() ),
					tabWidget = "CoD.StartMenu_GameOptions_CP",
					tabIcon = ""
				},
				properties = {
					tabId = "gameOptions"
				}
			} )
			if not Engine.IsCampaignModeZombies() then
				if CoD.isSafehouse and CoD.isOnlineGame() and not IsInTrainingSim( controller ) and Dvar.ui_safehousebarracks:get() and not IsPlayerAGuest( controller ) then
					table.insert( tabs, {
						models = {
							tabName = "CPUI_BARRACKS_CAPS",
							tabWidget = "CoD.CombatRecordCP_Contents",
							tabIcon = ""
						},
						properties = {
							tabId = "combatRecord"
						}
					} )
				end
				if HighestMapReachedGreaterThan( controller, 1 ) or LUI.DEV ~= nil then
					table.insert( tabs, {
						models = {
							tabName = "CPUI_TACTICAL_MODE_CAPS",
							tabWidget = "CoD.StartMenu_TacticalMode",
							tabIcon = ""
						},
						properties = {
							tabId = "tacticalMode"
						}
					} )
				end
				if not CoD.isSafehouse and not IsPlayerAGuest( controller ) then
					table.insert( tabs, {
						models = {
							tabName = "CPUI_ACCOLADES",
							tabWidget = "CoD.MissionRecordVault_Challenges",
							tabIcon = ""
						},
						properties = {
							tabId = "accolades"
						}
					} )
				end
			end
		elseif Engine.IsZombiesGame() then
			table.insert( tabs, {
				models = {
					tabName = SessionModeToUnlocalizedSessionModeCaps( Engine.CurrentSessionMode() ),
					tabWidget = "CoD.StartMenu_GameOptions_ZM",
					tabIcon = ""
				},
				properties = {
					tabId = "gameOptions"
				}
			} )
		else
			table.insert( tabs, {
				models = {
					tabName = SessionModeToUnlocalizedSessionModeCaps( Engine.CurrentSessionMode() ),
					tabWidget = "CoD.StartMenu_GameOptions",
					tabIcon = ""
				},
				properties = {
					tabId = "gameOptions"
				}
			} )
		end
	else
		if not IsPlayerAGuest( controller ) then
			table.insert( tabs, {
				models = {
					tabName = "MENU_TAB_IDENTITY_CAPS",
					tabWidget = "CoD.StartMenu_Identity",
					tabIcon = ""
				},
				properties = {
					tabId = "identity",
					disabled = Dvar.ui_execdemo_gamescom:get()
				}
			} )
		end
		if not IsLobbyNetworkModeLAN() and not Dvar.ui_execdemo:get() and not Engine.IsCampaignModeZombies() and not IsPlayerAGuest( controller ) then
			table.insert( tabs, {
				models = {
					tabName = "MENU_TAB_CHALLENGES_CAPS",
					tabWidget = "CoD.StartMenu_Challenges",
					tabIcon = ""
				},
				properties = {
					tabId = "challenges"
				}
			} )
			local isPC = CoD.isPC
			if isPC then
				isPC = Mods_IsUsingMods()
			end
			table.insert( tabs, {
				models = {
					tabName = "MENU_TAB_BARRACKS_CAPS",
					tabWidget = "CoD.StartMenu_Barracks",
					tabIcon = "",
					disabled = isPC
				},
				properties = {
					tabId = "barracks"
				}
			} )
			if CommunityOptionsEnabled() then
				local openMediaTabAfterClosingGroups = CoD.perController[controller].openMediaTabAfterClosingGroups
				CoD.perController[controller].openMediaTabAfterClosingGroups = false
				table.insert( tabs, {
					models = {
						tabName = "MENU_TAB_MEDIA_CAPS",
						tabWidget = "CoD.StartMenu_Media",
						tabIcon = ""
					},
					properties = {
						tabId = "media",
						selectIndex = openMediaTabAfterClosingGroups
					}
				} )
			end
		end
	end
	if IsGameTypeDOA() and Engine.IsInGame() and not InSafehouse() then
		local insert = table.insert
		local f44_local2 = tabs
		local f44_local3 = {
			models = {
				tabName = "MENU_TAB_OPTIONS_CAPS",
				tabWidget = "CoD.StartMenu_Options_DOA",
				tabIcon = ""
			}
		}
		local f44_local4 = {
			tabId = "options"
		}
		local ui_execdemo = Dvar.ui_execdemo:get()
		if ui_execdemo then
			ui_execdemo = not Engine.IsInGame()
		end
		f44_local4.selectIndex = ui_execdemo
		f44_local3.properties = f44_local4
		insert( f44_local2, f44_local3 )
	else
		local insert = table.insert
		local f44_local2 = tabs
		local f44_local3 = {
			models = {
				tabName = "MENU_TAB_OPTIONS_CAPS",
				tabWidget = "CoD.StartMenu_Options",
				tabIcon = ""
			}
		}
		local f44_local4 = {
			tabId = "options"
		}
		local ui_execdemo_gamescom = Dvar.ui_execdemo_gamescom:get()
		if ui_execdemo_gamescom then
			ui_execdemo_gamescom = not Engine.IsInGame()
		end
		f44_local4.selectIndex = ui_execdemo_gamescom
		f44_local3.properties = f44_local4
		insert( f44_local2, f44_local3 )
	end

    if Engine.IsInGame() and CoD.isZombie then
        local newOption = {
            models = {
                tabName = "GFL_MENU_PERSONALIZATION",
                tabWidget = "CoD.PersonalizationOptions_P1",
                tabIcon = ""
            },
            properties = {
                tabId = "personalization"
            }
        }
        table.insert( tabs, newOption )
    end

	table.insert( tabs, {
		models = {
			tabIcon = CoD.buttonStrings.shoulderr
		},
		properties = {
			m_mouseDisabled = true
		}
	} )
	return tabs
end, true )