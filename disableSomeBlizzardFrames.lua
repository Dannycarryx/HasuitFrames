

-- should have just deleted my addon and wow when i encountered this



local tinsert = tinsert
tinsert(hasuitDoThis_Player_Login, function()
    local savedUserOptions = hasuitSavedUserOptions
    local userOptionsOnChanged = hasuitUserOptionsOnChanged
    
    
    local function printAboutReloading()
        print("hiding blizzard frames requires reload")
    end
    
    local hideBlizzardParty = savedUserOptions["hideBlizzardParty"]
    userOptionsOnChanged["hideBlizzardParty"] = printAboutReloading
    
    local hideBlizzardArena = savedUserOptions["hideBlizzardArena"]
    userOptionsOnChanged["hideBlizzardArena"] = printAboutReloading
    
    local hideBlizzardRaid = savedUserOptions["hideBlizzardRaid"]
    userOptionsOnChanged["hideBlizzardRaid"] = printAboutReloading
    
    
    if hideBlizzardParty or hideBlizzardArena or hideBlizzardRaid then
        
        if EditModeSystemSettingsDialog then
            EditModeSystemSettingsDialog:SetPropagateKeyboardInput(true)
        end
        
        if EventToastManagerFrame then
            EventToastManagerFrame:SetPropagateMouseClicks(true)
            -- EventToastManagerFrame.currentDisplayingToast:SetPropagateMouseClicks(true) --todo
        end
        
        
        local type = type
        local ignoredFramesList = {}
        local hiddenFrame = CreateFrame("Frame")
        hiddenFrame:Hide()
        local function hookScriptFunction(frame)
            frame:UnregisterAllEvents()
        end
        local function danDisableBlizzardUnitFrame2(frame)
            if type(frame)=="table" then
                if not frame.danSeen then
                    frame.danSeen = true
                    tinsert(ignoredFramesList, frame)
                    frame:HookScript("OnEvent", hookScriptFunction)
                    frame:SetParent(hiddenFrame)
                end
            end
        end
        
        if hideBlizzardParty then
            local PartyFrame = PartyFrame
            if type(PartyFrame)=="table" then
                danDisableBlizzardUnitFrame2(CompactPartyFrameMember1) --raid-style party frames turned on
                danDisableBlizzardUnitFrame2(CompactPartyFrameMember2)
                danDisableBlizzardUnitFrame2(CompactPartyFrameMember3)
                danDisableBlizzardUnitFrame2(CompactPartyFrameMember4)
                danDisableBlizzardUnitFrame2(CompactPartyFrameMember5) --maybe best to disable pet frames too?
                danDisableBlizzardUnitFrame2(PartyFrame.MemberFrame1) --raid-style party frames turned off
                danDisableBlizzardUnitFrame2(PartyFrame.MemberFrame2)
                danDisableBlizzardUnitFrame2(PartyFrame.MemberFrame3)
                danDisableBlizzardUnitFrame2(PartyFrame.MemberFrame4)
                danDisableBlizzardUnitFrame2(PartyFrame)
            end
        end
        
        if hideBlizzardArena then
            local CompactArenaFrame = CompactArenaFrame --do not disable this frame. Some arena events stop working and there's no fix for it other than to leave this frame untouched. You can't even try to unregister events and then reregister the specific ones that break
            if type(CompactArenaFrame)=="table" then --todo check to see if some frames are still getting events here, like debuff frames/castbars etc, maybe slight performance gain available
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember1)
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember2)
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember3)
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember4)
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember5)
                danDisableBlizzardUnitFrame2(CompactArenaFramePet1)
                danDisableBlizzardUnitFrame2(CompactArenaFramePet2)
                danDisableBlizzardUnitFrame2(CompactArenaFramePet3)
                danDisableBlizzardUnitFrame2(CompactArenaFramePet4)
                danDisableBlizzardUnitFrame2(CompactArenaFramePet5) --maybe better to change cvar pvpOptionDisplayPets? raidOptionDisplayPets showArenaEnemyPets showPartyPets
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame1)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame2)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame3)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame4)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame5)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.PreMatchFramesContainer)
                danDisableBlizzardUnitFrame2(CompactArenaFrameTitle)
                danDisableBlizzardUnitFrame2(CompactArenaFrameBorderFrame)
            end
        end
        
        if hideBlizzardRaid then
            UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
            local CompactRaidFrameContainer = CompactRaidFrameContainer
            if type(CompactRaidFrameContainer)=="table" then
                local groupMode = CompactRaidFrameContainer.groupMode
                if groupMode=="flush" then --combined groups
                    local flowFrames = CompactRaidFrameContainer.flowFrames
                    if type(flowFrames)=="table" then
                        for i=1,#flowFrames do
                            local frame = flowFrames[i]
                            if type(frame)=="table" then
                                if frame.optionTable then
                                    danDisableBlizzardUnitFrame2(frame)
                                end
                            end
                        end
                    end
                elseif groupMode=="discrete" then --separate groups
                    local flowFrames = CompactRaidFrameContainer.flowFrames
                    if type(flowFrames)=="table" then
                        for i=1,#flowFrames do --groups
                            local memberUnitFrames = flowFrames[i].memberUnitFrames
                            if type(memberUnitFrames)=="table" then
                                for j=1,#memberUnitFrames do
                                    local frame = memberUnitFrames[i]
                                    if type(frame)=="table" then
                                        if frame.optionTable then
                                            danDisableBlizzardUnitFrame2(frame)
                                        end
                                    end
                                end
                            end
                        end
                    end
                -- else
                    -- hasuitDoThis_EasySavedVariables("groupMode: "..tostring(groupMode)) --can be nil sometimes
                end
                
                danDisableBlizzardUnitFrame2(CompactRaidFrameContainer)
                
                -- local danDoThisOnUpdate = hasuitDoThis_OnUpdate
                -- hooksecurefunc("CompactUnitFrame_OnLoad", function(frame)
                    -- danDoThisOnUpdate(function()
                        -- if type(frame)=="table" and frame.optionTable then
                            -- print(hasuitPurple, frame)
                            -- danUnregisterEvents(frame)
                        -- end
                    -- end)
                -- end)
            end
        end
        for i=1,#ignoredFramesList do
            ignoredFramesList[i].danSeen = nil --freeing microscopic amount of memory/making frames the way they were before in case there are any pairs( things that go on them that could break from this still being there. .danSeen probably does nothing to begin with but definitely nothing after this
        end
    end
end) --ps no frame for arenapet15?
