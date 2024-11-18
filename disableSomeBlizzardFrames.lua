

-- should have just deleted my addon and wow when i encountered this



local tinsert = tinsert
tinsert(hasuitDoThis_Player_Login, function()
    local savedUserOptions = hasuitSavedUserOptions
    local userOptionsOnChanged = hasuitUserOptionsOnChanged
    
    
    local print = print
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
        local function danDisableBlizzardUnitFrame(frame)
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
                danDisableBlizzardUnitFrame(CompactPartyFrameMember1) --raid-style party frames turned on
                danDisableBlizzardUnitFrame(CompactPartyFrameMember2)
                danDisableBlizzardUnitFrame(CompactPartyFrameMember3)
                danDisableBlizzardUnitFrame(CompactPartyFrameMember4)
                danDisableBlizzardUnitFrame(CompactPartyFrameMember5) --todo best to disable pet frames too? and anything else still getting events
                danDisableBlizzardUnitFrame(PartyFrame.MemberFrame1) --raid-style party frames turned off
                danDisableBlizzardUnitFrame(PartyFrame.MemberFrame2)
                danDisableBlizzardUnitFrame(PartyFrame.MemberFrame3)
                danDisableBlizzardUnitFrame(PartyFrame.MemberFrame4)
                danDisableBlizzardUnitFrame(PartyFrame)
            end
        end
        
        if hideBlizzardArena then
            local CompactArenaFrame = CompactArenaFrame --do not disable this frame. Some arena events stop working and there's no fix for it other than to leave this frame untouched. You can't even try to unregister events and then reregister the specific ones that break, although could maybe surgically unregister everything except the ones that break, or some things at least, by trial and error
            if type(CompactArenaFrame)=="table" then --todo check to see if some frames are still getting events, like debuff frames/castbars etc
                danDisableBlizzardUnitFrame(CompactArenaFrameMember1)
                danDisableBlizzardUnitFrame(CompactArenaFrameMember2)
                danDisableBlizzardUnitFrame(CompactArenaFrameMember3)
                danDisableBlizzardUnitFrame(CompactArenaFrameMember4)
                danDisableBlizzardUnitFrame(CompactArenaFrameMember5)
                danDisableBlizzardUnitFrame(CompactArenaFramePet1)
                danDisableBlizzardUnitFrame(CompactArenaFramePet2)
                danDisableBlizzardUnitFrame(CompactArenaFramePet3)
                danDisableBlizzardUnitFrame(CompactArenaFramePet4)
                danDisableBlizzardUnitFrame(CompactArenaFramePet5) --maybe better to change cvar pvpOptionDisplayPets? raidOptionDisplayPets showArenaEnemyPets showPartyPets, todo? Not a fan of changing things that don't change back after uninstalling the addon, like scriptProfile. maybe there should be a small uninstall addon that just sets everything back the way it was. That might be good to just go ahead and change a bunch of stuff. The addon should also keep track of things changed while addon is installed and change back to things appropriately if uninstalling.
                danDisableBlizzardUnitFrame(CompactArenaFrame.StealthedUnitFrame1)
                danDisableBlizzardUnitFrame(CompactArenaFrame.StealthedUnitFrame2)
                danDisableBlizzardUnitFrame(CompactArenaFrame.StealthedUnitFrame3)
                danDisableBlizzardUnitFrame(CompactArenaFrame.StealthedUnitFrame4)
                danDisableBlizzardUnitFrame(CompactArenaFrame.StealthedUnitFrame5)
                danDisableBlizzardUnitFrame(CompactArenaFrame.PreMatchFramesContainer)
                danDisableBlizzardUnitFrame(CompactArenaFrameTitle)
                danDisableBlizzardUnitFrame(CompactArenaFrameBorderFrame)
            end
        end
        
        if hideBlizzardRaid then
            UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE") --might break blizzard party frames if player is trying to track those but hide raid frames?
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
                                    danDisableBlizzardUnitFrame(frame)
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
                                            danDisableBlizzardUnitFrame(frame)
                                        end
                                    end
                                end
                            end
                        end
                    end
                -- else
                    -- hasuitDoThis_EasySavedVariables("groupMode: "..tostring(groupMode)) --can be nil sometimes
                end
                
                danDisableBlizzardUnitFrame(CompactRaidFrameContainer)
                
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
            ignoredFramesList[i].danSeen = nil --making frames the way they were before in case there are any pairs( things that go on them that could break from this still being there. .danSeen probably does nothing to begin with but definitely nothing after this
        end
    end
end) --ps no frame for arenapet15?
