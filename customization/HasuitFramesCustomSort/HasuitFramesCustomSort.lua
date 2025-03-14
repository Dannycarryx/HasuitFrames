


-- The point is to overwrite/change things from the main addon. This one will put player frame on bottom as-is, 
-- but you can change things if you want without needing to worry about updates erasing what you changed
-- There's an example of how to sort arena frames below, as well as how to change arena123 or party123 macros automatically.

-- Things in between --[[ and --]] are commented out. To uncomment/enable something you could just put a space in between -- and [[
-- All examples work as described if you uncomment them.


local hasuitPlayerFrame = hasuitPlayerFrame
local groupUnitFrames = hasuitUnitFramesForUnitType["group"]
local arenaUnitFrames = hasuitUnitFramesForUnitType["arena"]
hasuitCustomSortActive = true --for HasuitNameplates








hasuitPartySort = function(a,b) --group size less than 6
    if a==hasuitPlayerFrame then
        return false --player on bottom
    elseif b==hasuitPlayerFrame then
        return true --player on bottom
    end
    
    local aPartyNumber = a.partyNumber --copy paste of the main addon's party sort function
    local bPartyNumber = b.partyNumber
    if aPartyNumber and bPartyNumber then
        return aPartyNumber<bPartyNumber
    elseif aPartyNumber then
        return true
    elseif bPartyNumber then
        return false
    elseif a.priority and b.priority then
        return a.priority<b.priority
    else
        return a.priority or b.priority and false or a.id<b.id
    end
end








hasuitRaidSort = function(a,b) --group size greater than or equal to 6
    if a==hasuitPlayerFrame then
        return false --player on bottom
    elseif b==hasuitPlayerFrame then
        return true --player on bottom
    end
    
    
    return a.priority<b.priority --copy paste of the main addon's raid sort function
end







--Player's DR icons follow whatever group frame is in first position and anchor on top of it:
local lastAttachedButton
local playerDiminishIcons = hasuitPlayerFrame.diminishIcons
local hasuitButtonForUnit = hasuitButtonForUnit
tinsert(groupUnitFrames.onPositionsUpdated, function()
    local button1 = hasuitButtonForUnit[groupUnitFrames[1].unit] --not important to read: button1 is guaranteed to stay still until the next groupUnitFrames.onPositionsUpdated, so attach to that instead of the unitFrame which can hop to a different button if its unit changes, even in combat
    if lastAttachedButton~=button1 then
        lastAttachedButton = button1
        for i=1,#playerDiminishIcons do
            local diminishIcon = playerDiminishIcons[i]
            diminishIcon:ClearAllPoints()
            diminishIcon:SetPoint("BOTTOMRIGHT", button1, "TOPRIGHT", -1-(i-1)*24, 1)
        end
    end
end)



-- Example player's DR icons anchored below player frame (only good if you sort player last, can overlap other frames if player isn't last)
-- Pick either this or the one above, or neither are needed if player is always sorted on top. (Or do your own thing like anchoring to UIParent instead of hasuitPlayerFrame.border and putting them on the topleft of the screen like I used to do. To test them you could put diminishIcon:SetAlpha(1) below diminishIcon:SetPoint
--[[
for i=1,#hasuitPlayerFrame.diminishIcons do
    local diminishIcon = hasuitPlayerFrame.diminishIcons[i]
    diminishIcon:ClearAllPoints()
    diminishIcon:SetPoint("TOPRIGHT", hasuitPlayerFrame.border, "BOTTOMRIGHT", -1-(i-1)*24, -1)
end
--]]












--------------------------------------------------------------------------
-- other intended ways to customize sorting, examples below. You could ctrl-f things in UnitFrames2.lua to see what you're overwriting:
-- hasuitRolePriorities --you could change or overwrite the role priorities table. This affects .priority, which is used by raid sort by default, example below
-- hasuitClassPriorities --^

-- the main sort functions:
-- groupUnitFrames.sort    --hasuitPartySort and hasuitRaidSort from above are both within this but you could change this instead
-- arenaUnitFrames.sort
--------------------------------------------------------------------------







-- example sorting player in middle: 
--[[
local tinsert = tinsert
local tremove = tremove
local repositionPlayerFrame = { --You can control which position the player frame will go for each group size. If you want it to work in raid too add   [6] = 3,   to this table beneath   [5] = 3,   etc, up to   [40] = 20,   (to be 20th position in a 40man raid)
    [1] = 1,
    [2] = 1,
    [3] = 2,
    [4] = 2,
    [5] = 3,
}
local mainGroupSort = groupUnitFrames.sort
groupUnitFrames.sort = function()
    mainGroupSort()
    local playerPosition = repositionPlayerFrame[#groupUnitFrames]
    if playerPosition then
        for i=1,#groupUnitFrames do
            if groupUnitFrames[i]==hasuitPlayerFrame then
                local playerFrame = tremove(groupUnitFrames, i)
                tinsert(groupUnitFrames, playerPosition, playerFrame)
                break
            end
        end
    end
end
--]]













-- example making healers go on top in raid:
--[[
hasuitRolePriorities = {
    ["TANK"]        = 2000,
    ["NONE"]        = 3000,
    ["DAMAGER"]     = 4000,
    ["HEALER"]      = 1000,
}
--]]







--[[
hasuitClassPriorities = { --less important: this also exists and this + role priorities get added together for each friendly unit to determine their priority, so a blood deathknight would get 200 from class and 1000 from tank, for a total of 1200. And if their role changes to dps they'd become 3200
    ["WARRIOR"]     = 200,
    ["PALADIN"]     = 200,
    ["ROGUE"]       = 200,
    ["DEATHKNIGHT"] = 200,
    ["MONK"]        = 200,
    ["DEMONHUNTER"] = 200,
    
    ["HUNTER"]      = 400,
    ["SHAMAN"]      = 400,
    ["DRUID"]       = 400,
    
    ["EVOKER"]      = 600,
    
    ["PRIEST"]      = 800,
    ["MAGE"]        = 800,
    ["WARLOCK"]     = 800,
    
    ["d/c"]         = 5000,
}
--]]













-- example arena frames sorting healer on top, then melee classes, then ranged:
--[[
local hasuitClassPriorities = hasuitClassPriorities
local hasuitSpecIsHealerTable = hasuitSpecIsHealerTable
local sort = sort
local function arenaSort(a,b)
    return a.customArenaPriority<b.customArenaPriority
end
arenaUnitFrames.sort = function() --the macros to target arena frames 1-5 this way are    /click hft1   to   /click hft5   and the focus macros are   /click hff1   etc, also if you didn't know the macros to target group frames are   /click d1-1   to d5-1 and d1-4 to d5-4, 20 frames can be macroed in total. d5-1 would be the 5th group member in a normal party
    for i=1,#arenaUnitFrames do
        local unitFrame = arenaUnitFrames[i]
        if not unitFrame.customArenaPriority then
            local customArenaPriority = hasuitClassPriorities[unitFrame.unitClass] + unitFrame.id
            local specId = unitFrame.specId
            if specId and hasuitSpecIsHealerTable[specId] then --role doesn't work well for arena units so check spec to see if they're healer instead
                customArenaPriority = customArenaPriority - 4000 --is healer so put that frame on the top. To put it on bottom you could do +4000 instead
            end
            unitFrame.customArenaPriority = customArenaPriority
        end
    end
    
    sort(arenaUnitFrames, arenaSort)
end
--]]









-- example changing cyclone @arena123 macros to always match the positions of the sorted arena frames: you should have macros named cyclone1 cyclone2 and cyclone3 for it to work, or however many you want. 
-- If you only want a cyclone healer macro you could make one named cyclone1 and then use the healer on top sorting for arena frames
-- This changes all instances of arena1, arena2, and arena3 in macros named cyclone1 2 or 3, so even things like /stopmacro [@arena1,noexists] will be changed
--[[
local EditMacro = EditMacro
local GetMacroBody = GetMacroBody
local gsub = gsub
local arenaUnits = {
    "arena1",
    "arena2",
    "arena3",
}
local function changeUnitsInMacro(macroName, previousUnit, currentUnit)
    local macroBody = GetMacroBody(macroName)
    if macroBody then
        local macroBody = gsub(macroBody, previousUnit, currentUnit)
        if macroBody then
            EditMacro(macroName, nil, nil, macroBody)
        end
    end
end
local resetMacrosOnLogin = {
    "arena%d*",
}
tinsert(hasuitDoThis_Player_Login, 1, function()
    for i=1,#arenaUnits do
        local currentUnit = arenaUnits[i]
        for j=1,#resetMacrosOnLogin do
            local previousUnit = resetMacrosOnLogin[j]
            
            
            
            changeUnitsInMacro("cyclone"..i, previousUnit, currentUnit) --to add more macros just duplicate this line and the one below, and change "cyclone" to whatever other macro name you want, so for example you could make entangle1 entangle2 and entangle3 macros and duplicate this line and change "cyclone"..i to "entangle"..i
            
            
            
        end
    end
end)
tinsert(arenaUnitFrames.onPositionsUpdated, function()
    for i=1,#arenaUnitFrames do
        local previousUnit = arenaUnits[i]
        if previousUnit then
            local currentUnit = arenaUnitFrames[i].unit
            if previousUnit~=currentUnit and currentUnit then
                arenaUnits[i] = currentUnit
                
                
                
                changeUnitsInMacro("cyclone"..i, previousUnit, currentUnit) --duplicate/change this too
                
                
                
            end
        end
    end
end)
--]]










-- example changing @party123 macros, similar to above, intended to be used with custom party/group sorting:
--[[
local EditMacro = EditMacro
local GetMacroBody = GetMacroBody
local gsub = gsub
local partyUnits = {
    "player",
    "party1",
    "party2",
    "party3",
    "party4",
}
local function changeUnitsInMacro(macroName, previousUnit, currentUnit)
    local macroBody = GetMacroBody(macroName)
    if macroBody then
        local macroBody = gsub(macroBody, previousUnit, currentUnit)
        if macroBody then
            EditMacro(macroName, nil, nil, macroBody)
        end
    end
end
local resetMacrosOnLogin = {
    "player",
    "party%d*",
    "raid%d*",
}
tinsert(hasuitDoThis_Player_Login, 1, function() --because macros aren't loaded until PLAYER_LOGIN
    for i=1,#partyUnits do
        local currentUnit = partyUnits[i]
        for j=1,#resetMacrosOnLogin do
            local previousUnit = resetMacrosOnLogin[j]
            
            
            
            changeUnitsInMacro("heal"..i, previousUnit, currentUnit) --to add more macros just duplicate this line and the one below, and change "heal" to whatever other macro name you want
            
            
            
        end
    end
end)
tinsert(groupUnitFrames.onPositionsUpdated, function()
    for i=1,#groupUnitFrames do
        local previousUnit = partyUnits[i]
        if previousUnit then
            local currentUnit = groupUnitFrames[i].unit
            if previousUnit~=currentUnit and currentUnit and currentUnit~="target" then
                partyUnits[i] = currentUnit
                
                
                
                changeUnitsInMacro("heal"..i, previousUnit, currentUnit) --duplicate/change this too
                
                
                
            end
        end
    end
end)
--]]
