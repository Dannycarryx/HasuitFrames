
do
    -- local hasuitUnitFrameForUnit = hasuitUnitFrameForUnit

    -- local UnitGUID = UnitGUID

    -- local hasuitUnitEventFunctions = hasuitUnitEventFunctions
    
    -- local function mainUnitEventFunction(_,event,unit,...)
        -- local unitGUID = UnitGUID(unit)
        -- local unitFrame = hasuitUnitFrameForUnit[unitGUID]
        -- if unitFrame then
            -- hasuitUnitEventFunctions[event](unit,unitFrame,...)
        -- end
    -- end
    
    
    tinsert(hasuitDoThis_Addon_Loaded, function()
        local hasuitButtonForUnit = hasuitButtonForUnit
        local hasuitUnitAuraFunction = hasuitUnitAuraFunction
        local asd = {
            "player",
            "party1",
            "party2",
            "party3",
            "party4",
            
            "arena1",
            "arena2",
            "arena3",
            "arena4",
            "arena5",
            
            "raid1",
            "raid2",
            "raid3",
            "raid4",
            "raid5",
            "raid6",
            "raid7",
            "raid8",
            "raid9",
            "raid10",
            "raid11",
            "raid12",
            "raid13",
            "raid14",
            "raid15",
            "raid16",
            "raid17",
            "raid18",
            "raid19",
            "raid20",
            "raid21",
            "raid22",
            "raid23",
            "raid24",
            "raid25",
            "raid26",
            "raid27",
            "raid28",
            "raid29",
            "raid30",
            "raid31",
            "raid32",
            "raid33",
            "raid34",
            "raid35",
            "raid36",
            "raid37",
            "raid38",
            "raid39",
            "raid40",
        }
        -- tinsert(asd, "target")
        
        for i=1,#asd do
            local unit = asd[i]
            -- print(unit)
            local button = hasuitButtonForUnit[unit]
            button:SetScript("OnEvent", hasuitUnitAuraFunction)
            button:RegisterUnitEvent("UNIT_AURA", unit)
        end
        -- local button = hasuitButtonForUnit["target"] --for testing stuff on target from /hf, comment out after done or make it better
        -- button:SetScript("OnEvent", hasuitUnitAuraFunction)
        -- button:RegisterUnitEvent("UNIT_AURA", "target")
    end)
end



