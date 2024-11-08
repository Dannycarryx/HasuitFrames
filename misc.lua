
do
    local SetCVar = C_CVar.SetCVar
    local GetCVar = C_CVar.GetCVar
    local function asd1()
        SetCVar("scriptProfile", "1")
        
        local reloadButton = CreateFrame("Button", "hasuitFramesOptionsreloadButton", UIParent, "BackdropTemplate")
        reloadButton:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        })
        reloadButton:SetBackdropColor(0,0,0)
        
        local danFont80 = CreateFont("danUserOptionsFont80")
        danFont80:SetFont("Fonts/FRIZQT__.TTF", 80, "OUTLINE")
        local text = reloadButton:CreateFontString()
        text:SetFontObject(danFont80)
        
        
        
        text:SetText("click") --problem with this is potentially preventing normal setup from other addons if logging in with no savedvariables?
        
        
        
        text:SetPoint("CENTER",0,0)
        text:SetJustifyH("CENTER")
        
        reloadButton:SetAllPoints()
        reloadButton:SetFrameStrata("TOOLTIP") --todo not during movie?
        reloadButton:SetFrameLevel(9999)
        reloadButton:EnableMouse(true)
        reloadButton:RegisterForClicks("AnyDown")
        
        local reload = C_UI.Reload
        local function forcedReloadFunction()
            hasuitSavedVariables.scriptProfile = "HasuitFrames requires cvar scriptProfile to be set to 1 to work. It was set automatically. This requirement will be removed in the future." --has to be 0 before the addon even starts loading or GetCurrentEventID() won't work
            hasuitSavedVariables.repeatWelcomeMessage = true
            SetCVar("scriptProfile", "1")
            reloadButton:SetScript("OnClick", nil)
            reloadButton:SetScript("OnKeyDown", nil)
            reload()
        end
        reloadButton:SetScript("OnClick", forcedReloadFunction)
        reloadButton:SetScript("OnKeyDown", forcedReloadFunction)
    end
    
    tinsert(hasuitDoThis_Player_Entering_WorldFirstOnly, function() --you should do  /console scriptProfile 0  if quitting HasuitFrames to make the game just a little faster. When updated to not need this anymore it will switch it back to 0 automatically along with a message saying it did that. Not sure how much of a difference this really makes
        if GetCVar("scriptProfile")~="1" then --GetCurrentEventID()
            if InCinematic() or IsInCinematicScene() or OpeningCinematic() then
                local function asd2()
                    if InCinematic() or IsInCinematicScene() or OpeningCinematic() then
                        C_Timer.After(0.1, asd2)
                    else
                        asd1()
                    end
                end
                asd2()
            else
                asd1()
            end
            
        else
            local danFrame = CreateFrame("Frame")
            danFrame:RegisterEvent("PLAYER_LOGOUT")
            danFrame:SetScript("OnEvent", function()
                if GetCVar("scriptProfile")~="1" then
                    if not hasuitSavedVariables.scriptProfile then
                        hasuitSavedVariables.scriptProfile = "HasuitFrames set cvar scriptProfile to 1"
                    end
                    SetCVar("scriptProfile", "1")
                end
            end)
            
            if hasuitSavedVariables.scriptProfile then
                print(hasuitSavedVariables.scriptProfile)
                hasuitSavedVariables.scriptProfile = nil
            end
            
        end
    end)
end