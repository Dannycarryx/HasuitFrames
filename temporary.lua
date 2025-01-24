
do --Thanks to Ghost from WoWUIDev discord for helping figure out why GetCurrentEventID wasn't working on friend's wow client, and Gismo for being the tester to figure out that it was broken to begin with --wouldn't have made things like this if i knew GetCurrentEventID() relied on scriptProfile. This solution is kind of awful but the cvar requirement will get removed soon tm so it kind of makes sense to just force a reload asap regardless of anything else until then. A huge amount of testing has been done with the current system and seems like things work fine, so cba changing the way it works for now. Maybe Blizzard could update things and make a separate cvar that GetCurrentEventID relies on that follows whatever scriptProfile gets set to unless specifically changed? Or have some way of watching for events from any unit without needing to worry about being inefficient with duplicates, like ideally register an event for any unitguid, then it gives the unitguid as a payload and only fires once, and then you can registerunitGUIDevent if you want and not have to go way out of your way to keep track of something like raid2 changed to raid3. tracking units like they're the only thing that matters is so dumb because then you can't follow specific things that happened like that unit has things on cooldown like barkskin/skull bash, or something like a chaos bolt is inc on that unit. Tracking things based on unitGUID instead of unit is also just way more efficient because you can set a bunch of things for a frame like unit class/color/spec etc (very long list that should include auras and mostly get rid of full aura updates, unithealth etc) and then not care that their unit token changed from raid2 to raid3
    local print = print
    local SetCVar = C_CVar.SetCVar
    local GetCVar = C_CVar.GetCVar
    local asd = GetCVar("scriptProfile")~="1"
    if asd then
        hasuitScriptProfileWasWrong = true
    end
    
    tinsert(hasuitDoThis_Player_Entering_WorldFirstOnly, function() --you should do  /console scriptProfile 0  if quitting HasuitFrames to make the game just a little faster. When updated to not need this anymore it will switch it back to 0 automatically along with a message saying it did that. Not sure how much of a difference this really makes
        local hasuitSavedVariables = hasuitSavedVariables
        local scriptProfileMessage = hasuitSavedVariables["scriptProfileMessage"]
        if asd then
            SetCVar("scriptProfile", "1")
            local hasuitPlayerFrame = hasuitPlayerFrame
            
            local asd1 = scriptProfileMessage and function()
                print("cvar scriptProfile must be 1 for HasuitFrames to work. It seems like something else changed this to 0 right after events PLAYER_LOGOUT/ADDONS_UNLOADING. Won't work right without the cvar already being set to 1 before addons begin loading")
            end
            
            or --here
            
            function()
                local reloadButton = CreateFrame("Button", "hasuitFramesOptionsreloadButton", hasuitPlayerFrame, "BackdropTemplate")
                reloadButton:SetBackdrop({
                    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
                })
                reloadButton:SetBackdropColor(0,0,0,0.2)
                
                local danFont = CreateFont("hasuitUserOptionsFont30")
                danFont:SetFont("Fonts/FRIZQT__.TTF", 30, "OUTLINE")
                local text = reloadButton:CreateFontString()
                text:SetFontObject(danFont)
                
                
                
                text:SetText("/reload")
                
                
                
                text:SetPoint("CENTER")
                text:SetJustifyH("CENTER")
                
                reloadButton:SetAllPoints()
                -- reloadButton:SetFrameStrata("TOOLTIP")
                reloadButton:SetFrameLevel(50)
                reloadButton:EnableMouse(true)
                reloadButton:RegisterForClicks("AnyDown")
                
                local reload = C_UI.Reload
                local function reloadFunction()
                    -- hasuitSavedVariables["scriptProfileMessage"] = "HasuitFrames reloaded to change cvar scriptProfile to 1. Without this the addon would not work. This requirement will be removed in the future."
                    hasuitSavedVariables["scriptProfileMessage"] = "HasuitFrames reloaded to change cvar scriptProfile to 1."
                    SetCVar("scriptProfile", "1")
                    reloadButton:SetScript("OnClick", nil)
                    -- reloadButton:SetScript("OnKeyDown", nil)
                    reload()
                end
                reloadButton:SetScript("OnClick", reloadFunction)
                -- reloadButton:SetScript("OnKeyDown", reloadFunction)
            end
            
            asd1()
            
        elseif scriptProfileMessage then
            print(scriptProfileMessage)
            hasuitSavedVariables["scriptProfileMessage"] = nil
            
            
            if hasuitSavedVariables["repeatWelcomeMessage"] then
                
                local C_Timer_After = C_Timer.After
                hasuitDoThis_OnUpdate(function()
                    C_Timer_After(0, function()
                        print(hasuitSavedVariables["repeatWelcomeMessage"])
                        hasuitSavedVariables["repeatWelcomeMessage"] = nil
                    end)
                end)
                
            end
            
        end
        
        local danFrame = CreateFrame("Frame")
        danFrame:RegisterEvent("PLAYER_LOGOUT")
        danFrame:RegisterEvent("ADDONS_UNLOADING")
        danFrame:SetScript("OnEvent", function()
            if GetCVar("scriptProfile")~="1" then
                if not hasuitSavedVariables["scriptProfileMessage"] then
                    hasuitSavedVariables["scriptProfileMessage"] = "HasuitFrames changed cvar scriptProfile to 1"
                end
                SetCVar("scriptProfile", "1")
            end
        end)
    end)
end
