

-- should have just deleted my addon and wow when i encountered this




tinsert(hasuitDoThisPlayer_Login, function()
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
        local danDisableBlizzardUnitFrame2
        local ignoredFramesList = {}
        do
            local hiddenFrame = CreateFrame("Frame")
            hiddenFrame:Hide()
            local function hookScriptFunction(frame)
                frame:UnregisterAllEvents()
            end
            function danDisableBlizzardUnitFrame2(frame)
                if type(frame)=="table" then
                    if not frame.danSeen then
                        frame.danSeen = true
                        tinsert(ignoredFramesList, frame)
                        frame:HookScript("OnEvent", hookScriptFunction)
                        frame:SetParent(hiddenFrame)
                    end
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
                danDisableBlizzardUnitFrame2(CompactPartyFrameMember5)
                danDisableBlizzardUnitFrame2(PartyFrame.MemberFrame1) --raid-style party frames turned off
                danDisableBlizzardUnitFrame2(PartyFrame.MemberFrame2)
                danDisableBlizzardUnitFrame2(PartyFrame.MemberFrame3)
                danDisableBlizzardUnitFrame2(PartyFrame.MemberFrame4)
                danDisableBlizzardUnitFrame2(PartyFrame)
            end
        end
        
        if hideBlizzardArena then
            local CompactArenaFrame = CompactArenaFrame
            if type(CompactArenaFrame)=="table" then
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember1)
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember2)
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember3)
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember4)
                danDisableBlizzardUnitFrame2(CompactArenaFrameMember5)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame1)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame2)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame3)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame4)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.StealthedUnitFrame5)
                danDisableBlizzardUnitFrame2(CompactArenaFrame.PreMatchFramesContainer)
                danDisableBlizzardUnitFrame2(CompactArenaFrameTitle)
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
                    -- hasuitDoThisEasySavedVariables("groupMode: "..tostring(groupMode)) --can be nil sometimes
                end
                
                danDisableBlizzardUnitFrame2(CompactRaidFrameContainer)
                
                -- local danDoThisOnUpdate = hasuitDoThisOnUpdate
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
            ignoredFramesList[i].danSeen = nil
        end
    end
end) --ps no frame for arenapet15?
