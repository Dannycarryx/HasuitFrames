
if hasuitTestAllSpellTablesBefore then
    hasuitTestAllSpellTablesBefore()
end

local CreateFrame = CreateFrame
local hasuitFramesParent = CreateFrame("Frame", "hasuitFramesParent", UIParent)
hasuitFramesParent:SetIgnoreParentScale(true)
hasuitFramesParent:SetSize(1,1)
hasuitFramesParent:SetPoint("CENTER")
hasuitFramesParent:SetFrameStrata("LOW")
hasuitFramesParent:SetFrameLevel(11)

-- hasuitLoginTime = GetTime()
hasuitPlayerGUID = UnitGUID("player")
do
    local _, dan = UnitClass("player")
    hasuitPlayerClass = dan
end


hasuitOutOfRangeAlpha = 0.55
hasuitCcBreakHealthThreshold = 460000 --todo base it on level or patch or something? to not have to change this in the future
hasuitCcBreakHealthThresholdPve = 280000

hasuitClassColorsHexList = { --string.format("Hexadecimal: %X", number)
    ["DEATHKNIGHT"] = "|cffC41E3A",
    ["DEMONHUNTER"] = "|cffA330C9",
    ["DRUID"] = "|cffFF7C0A",
    ["EVOKER"] = "|cff33937F",
    ["HUNTER"] = "|cffAAD372",
    ["MAGE"] = "|cff3FC7EB",
    ["MONK"] = "|cff00FF98",
    ["PALADIN"] = "|cffF48CBA",
    ["PRIEST"] = "|cffFFFFFF",
    ["ROGUE"] = "|cffFFF468",
    ["SHAMAN"] = "|cff0070DD",
    ["WARLOCK"] = "|cff8788EE",
    ["WARRIOR"] = "|cffC69B6D",
}
hasuitRAID_CLASS_COLORS = {}

hasuitSpecIsHealerTable = {
    [105] = true, --resto druid
    [1468] = true, --preservation
    [270] = true, --mistweaver
    [65] = true, --holy paladin
    [256] = true, --disc
    [257] = true, --holy priest
    [264] = true, --rsham
}
hasuitCommonBackdrop = {
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
    edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
    edgeSize = 1,
}
hasuitUninterruptibleBorderSize = 5






hasuitUnitFrameForUnit = {}
hasuitFrameTypeUpdateCount = {}

hasuitUnitFramesForUnitType_Array = {
    {unitType="group"},
    {unitType="arena"},
    -- {unitType="pet"},
}
hasuitUnitFramesForUnitType = {} --pairs table pointing to unitTable s in hasuitUnitFramesForUnitType_Array, exists to set local groupUnitFrames etc in other files easier
do
    local hasuitUnitFramesForUnitType_Array = hasuitUnitFramesForUnitType_Array
    local hasuitUnitFramesForUnitType = hasuitUnitFramesForUnitType
    for i=1,#hasuitUnitFramesForUnitType_Array do
        local unitTable = hasuitUnitFramesForUnitType_Array[i]
        hasuitUnitFramesForUnitType[unitTable.unitType] = unitTable
    end
end

hasuitUpdateAllUnitsForUnitType = {}

hasuitFramesCenterNamePlateGUIDs = {}

hasuitTrackedRaceCooldowns = {}



hasuitSavedVariables = {} --for things in the future like keeping track of how long spent offline/update cooldowns of people from that if it was short enough, maybe fix pvp countdown after a reload





hasuitDoThis_Addon_Loaded = {} --not accessible from external addons
hasuitDoThis_UserOptionsLoaded = {} --not accessible from external addons, happens early on addon_loaded

hasuitDoThis_Player_Login = hasuitDoThis_Player_Login or {} --can sync any addons together here, give them these or other functions/run things in certain orders, other addon should do the same thing with hasuitDoThis_Player_Login = hasuitDoThis_Player_Login or {} so that it doesn't matter which addon loads first
hasuitDoThis_Player_Entering_WorldFirstOnly = {} --other stuff is accessible but you need to do it inside of the function you put into hasuitDoThis_Player_Login to make sure it doesn't matter which addon loads first. basically anything external should be 100% wrapped in the function you tinsert into hasuitDoThis_Player_Login and from there everything global made in my addon will be loaded and can be grabbed and used locally before it gets set nil. (Setting nil only removes the global pointer, anything grabbed to use locally will stay and can continue to be used.)
hasuitDoThis_Player_Entering_WorldSkipsFirst = {}

hasuitDoThis_Group_Roster_UpdateAlways = {}
hasuitDoThis_Group_Roster_UpdateGroupSizeChanged = {}
-- hasuitDoThis_Group_Roster_UpdateWidthChanged --tinsert into .functions
-- hasuitDoThis_Group_Roster_UpdateHeightChanged --tinsert into .functions
-- hasuitDoThis_Group_Roster_UpdateColumnsChanged --tinsert into .functions --not used atm
-- hasuitDoThis_Group_Roster_UpdateGroupSize_5 --tinsert into .functions
-- hasuitDoThis_Group_Roster_UpdateGroupSize_5_8 --tinsert into .functions

hasuitDoThis_Player_Target_Changed = {}




-- hasuitDoThis_OnUpdate(func)
-- hasuitDoThis_OnUpdatePosition1(func)

-- hasuitDoThis_AfterCombat(func)


-- unitFrame.customDanInspectedUnitFrame, table that gets unitFrame as arg1 when .specId gets updated from inspecting
-- controllerOptions.customControllerSetupFunctions, table that gets controller as arg1 when it gets created on a unitframe, once per controlleroptions per unitframe


-- hasuitDoThis_GroupUnitFramesUpdate_before = {} --normal
hasuitDoThis_GroupUnitFramesUpdate = {} --gives unitFrame as arg1
hasuitDoThis_GroupUnitFramesUpdate_after = {} --wipes at the end if it did anything
--these are for efficiently running functions on every group unitFrame every time there's a group update (usually group_roster_update but the function can come from unit_aura guid not matching or arena update stealing a group frame(s), or player_login
--the way it's set up allows for only running a function on every unitframe based on one condition changing and then not repeating the function on future group updates, until the condition you care about changes again
--example for properly using in testingExternalAddon.lua, will make a guide some time


-- hasuitDoThis_GroupUnitFramesUpdate_Positions_before = {} --normal, these wait for combat to drop
hasuitDoThis_GroupUnitFramesUpdate_Positions = {} --gives unitFrame as arg1
hasuitDoThis_GroupUnitFramesUpdate_Positions_after = {} --wipes at the end if it did anything



do --hasuitDoThis_EachUnitFrameForOneUpdate(func) --todo hasuitDoThis_GroupUnitFramesUpdate/hasuitDoThis_GroupUnitFramesUpdate_after should probably go after the sorting function? some way of limiting it better now that group update function can happen multiple times on the same gettime
    local tinsert = tinsert
    local danRemoveFunctionFromArray
    local hasuitDoThis_GroupUnitFramesUpdate = hasuitDoThis_GroupUnitFramesUpdate
    local hasuitDoThis_GroupUnitFramesUpdate_after = hasuitDoThis_GroupUnitFramesUpdate_after
    function hasuitLocal9(asd1)
        danRemoveFunctionFromArray = asd1
    end

    hasuitActiveCustomUnitFrameFunctions = {}
    local hasuitActiveCustomUnitFrameFunctions = hasuitActiveCustomUnitFrameFunctions
    function hasuitDoThis_EachUnitFrameForOneUpdate(customFunction) --to use properly it should probably be a named function, like don't do this:   hasuitDoThis_EachUnitFrameForOneUpdate(function(unitFrame) end)   do this instead:   local function asd(unitFrame) end hasuitDoThis_EachUnitFrameForOneUpdate(asd)   This way you can call it multiple times for the same function before a group update actually happens and it will prevent duplicates. Also this way you can clear it easily from the array without it actually happening from the group update by doing   hasuitActiveCustomUnitFrameFunctions[asd]()
        if not hasuitActiveCustomUnitFrameFunctions[customFunction] then
            local function removeAfter()
                danRemoveFunctionFromArray(hasuitDoThis_GroupUnitFramesUpdate, customFunction)
                hasuitActiveCustomUnitFrameFunctions[customFunction] = nil
            end
            tinsert(hasuitDoThis_GroupUnitFramesUpdate, customFunction)
            tinsert(hasuitDoThis_GroupUnitFramesUpdate_after, removeAfter)
            hasuitActiveCustomUnitFrameFunctions[customFunction] = removeAfter
        end
    end
end













local GetInstanceInfo = GetInstanceInfo

local mainLoadOnFunctionSpammable
local tinsert = table.insert
do
    local arenaEndedFunction
    function hasuitLocal10(asd)
        arenaEndedFunction = asd
    end
    local hasuitDoThis_Addon_Loaded = hasuitDoThis_Addon_Loaded
    local hasuitDoThis_Player_Login = hasuitDoThis_Player_Login
    local hasuitDoThis_Player_Entering_WorldFirstOnly = hasuitDoThis_Player_Entering_WorldFirstOnly
    local danFrame = CreateFrame("Frame")
    danFrame:RegisterEvent("ADDON_LOADED")
    danFrame:RegisterEvent("PLAYER_LOGIN")
    danFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    danFrame:SetScript("OnEvent", function(_,event,addonName)
        if event=="ADDON_LOADED" then
            if addonName=="HasuitFrames" then
                danFrame:UnregisterEvent("ADDON_LOADED")
                for i=1,#hasuitDoThis_Addon_Loaded do
                    hasuitDoThis_Addon_Loaded[i]()
                end
            end
            
        elseif event=="PLAYER_LOGIN" then
            danFrame:UnregisterEvent("PLAYER_LOGIN")
            for i=1,#hasuitDoThis_Player_Login do
                hasuitDoThis_Player_Login[i]()
            end
            
        elseif event=="PLAYER_ENTERING_WORLD" then
            for i=1,#hasuitDoThis_Player_Entering_WorldFirstOnly do
                hasuitDoThis_Player_Entering_WorldFirstOnly[i]()
            end
            mainLoadOnFunctionSpammable() --not really necessary since every groupsize loadon will also call this initially but oh well
            local hasuitDoThis_Player_Entering_WorldSkipsFirst = hasuitDoThis_Player_Entering_WorldSkipsFirst
            danFrame:SetScript("OnEvent", function()
                local _, instanceType, _, _, _, _, _, instanceId = GetInstanceInfo()
                hasuitGlobal_InstanceId = instanceId
                if instanceType~=hasuitGlobal_InstanceType then
                    if hasuitGlobal_InstanceType=="arena" then --WAS arena, still saw arenaLines bug once I think --should be fixed?, problem was danUpdateUnitSpecial not getting called when joining arena with same team/frames already exist i think. Now it checks once per main unitType update whether it's arena or not and loops through all group and arena frames if it is arena, making sure a line is made for each unit. Would do a lot of things differently if I remade UnitFrames2.lua
                        arenaEndedFunction()
                    end
                    hasuitGlobal_InstanceType = instanceType
                    mainLoadOnFunctionSpammable() --maybe just move this to loadons only to make it less confusing
                end
                for i=1,#hasuitDoThis_Player_Entering_WorldSkipsFirst do
                    hasuitDoThis_Player_Entering_WorldSkipsFirst[i]()
                end
            end)
            danFrame:RegisterEvent("WALK_IN_DATA_UPDATE") --delves?, maybe make this only happen once per gettime?
            
        end
    end)
end







do --hasuitDoThis_OnUpdate, hasuitDoThis_OnUpdatePosition1
    local danDoThis
    local danFrame = CreateFrame("Frame")
    local function onUpdateFunction()
        -- hasuitDoThis_OnUpdate_Active = true
        danFrame:SetScript("OnUpdate", nil)
        local temp = danDoThis
        danDoThis = nil
        for i=1,#temp do
            temp[i]()
        end
        -- hasuitDoThis_OnUpdate_Active = false
    end
    function hasuitDoThis_OnUpdate(func)
        if danDoThis then
            tinsert(danDoThis, func)
        else
            danDoThis = {func}
            danFrame:SetScript("OnUpdate", onUpdateFunction)
        end
    end
    function hasuitDoThis_OnUpdatePosition1(func)
        if danDoThis then
            tinsert(danDoThis, 1, func)
        else
            danDoThis = {func}
            danFrame:SetScript("OnUpdate", onUpdateFunction)
        end
    end
    -- function hasuitDoThis_OnUpdateSpecificPosition(func, index)
        -- if danDoThis then
            -- tinsert(danDoThis, index, func)
        -- else
            -- danDoThis = {func}
            -- danFrame:SetScript("OnUpdate", onUpdateFunction)
        -- end
    -- end
    -- function hasuitGetCurrentOnUpdateTable()
        -- return danDoThis
    -- end
end











do --hasuitDoThis_AfterCombat
    local danDoThis
    local danFrame = CreateFrame("Frame")
    function hasuitDoThis_AfterCombat(func)
        if danDoThis then
            tinsert(danDoThis, func)
        else
            danDoThis = {func}
            danFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        end
    end
    danFrame:SetScript("OnEvent", function()
        for i=1,#danDoThis do
            danDoThis[i]()
        end
        danDoThis = nil
        danFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end)
end

local GetNumGroupMembers = GetNumGroupMembers
do
    local danDoThisRelevantSizes = {}
    do
        local function getDoThisSizeTable(danSizeTable)
            local relevantGroupSizes = {functions={}}
            local j = 1
            for i=1,#danSizeTable do
                local relevantSize = danSizeTable[i]
                repeat
                    relevantGroupSizes[j] = relevantSize
                    j = j+1
                until j>relevantSize
            end
            tinsert(danDoThisRelevantSizes, relevantGroupSizes)
            return relevantGroupSizes
        end
        hasuitDoThis_Group_Roster_UpdateWidthChanged =       getDoThisSizeTable({5,8,15,20,24,28,32,36,40}) --todo make this kind of thing work the same way on a table like hasuitRaidFrameWidthForGroupSize? might be nice when useroptions can change frame size and stuff
        hasuitDoThis_Group_Roster_UpdateHeightChanged =      getDoThisSizeTable({8,10,15,40})
        -- hasuitDoThis_Group_Roster_UpdateColumnsChanged =     getDoThisSizeTable({5,8,20,24,28,32,36,40})
        hasuitDoThis_Group_Roster_UpdateGroupSize_5 =        getDoThisSizeTable({5,40})
        hasuitDoThis_Group_Roster_UpdateGroupSize_5_8 =      getDoThisSizeTable({5,8,40})
    end
    
    local hasuitDoThis_Group_Roster_UpdateAlways = hasuitDoThis_Group_Roster_UpdateAlways
    local hasuitDoThis_Group_Roster_UpdateGroupSizeChanged = hasuitDoThis_Group_Roster_UpdateGroupSizeChanged
    local danFrame = CreateFrame("Frame")
    danFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    tinsert(hasuitDoThis_Addon_Loaded, 1, function() --ends up being #2 (for now?)
        for i=1,#hasuitDoThis_Group_Roster_UpdateGroupSizeChanged do
            hasuitDoThis_Group_Roster_UpdateGroupSizeChanged[i]()
        end
        for i=1,#danDoThisRelevantSizes do
            local sizeTable = danDoThisRelevantSizes[i]
            sizeTable.activeRelevantSize = sizeTable[hasuitGlobal_GroupSize]
            local sizeFunctions = sizeTable.functions
            for j=1,#sizeFunctions do
                sizeFunctions[j]()
            end
        end
        for i=1,#hasuitDoThis_Group_Roster_UpdateAlways do
            hasuitDoThis_Group_Roster_UpdateAlways[i]()
        end
        
        
        -- do
            -- local columnsForGroupSize = hasuitRaidFrameColumnsForGroupSize
            -- tinsert(hasuitDoThis_Group_Roster_UpdateColumnsChanged.functions, 1, function()
                -- hasuitGlobal_RaidFrameColumns = columnsForGroupSize[hasuitGlobal_GroupSize]
            -- end)
        -- end
    end)
    
    local GetNumGroupMembers = GetNumGroupMembers
    local realGetNumGroupMembers = GetNumGroupMembers
    function hasuitMakeFakeGetNumGroupMembers(fakeFunction) --this was a mistake
        GetNumGroupMembers = fakeFunction or realGetNumGroupMembers
    end
    local danUpdateGroupUnitFrames
    function hasuitLocal8(asd1)
        danUpdateGroupUnitFrames = asd1
        return asd1
    end
    function hasuitGroupRosterUpdateFunction() --GROUP_ROSTER_UPDATE
        local groupSize = GetNumGroupMembers()
        if groupSize == 0 then
            groupSize = 1
        end
        if groupSize~=hasuitGlobal_GroupSize then
            hasuitGlobal_GroupSize = groupSize
            
            for i=1,#hasuitDoThis_Group_Roster_UpdateGroupSizeChanged do
                hasuitDoThis_Group_Roster_UpdateGroupSizeChanged[i]()
            end
            
            for i=1,#danDoThisRelevantSizes do
                local sizeTable = danDoThisRelevantSizes[i]
                local relevantSize = sizeTable[groupSize]
                if sizeTable.activeRelevantSize~=relevantSize then
                    sizeTable.activeRelevantSize = relevantSize
                    local sizeFunctions = sizeTable.functions
                    for j=1,#sizeFunctions do
                        sizeFunctions[j]()
                    end
                end
            end
        end
        for i=1,#hasuitDoThis_Group_Roster_UpdateAlways do --doesn't do anything atm
            hasuitDoThis_Group_Roster_UpdateAlways[i]()
        end
        danUpdateGroupUnitFrames() --instant now up to 2 times per gettime then it sets a C_Timer to go again after a delay. The way it works is a unittype update function can be triggered and then steal frames from a different unittype, then the update function for that unittype will go right afterward to try to fill things that got stolen, which can trigger the same unittype function from the beginning. Sometimes party and arena units can be the same thing so without some precaution it's probably possible to freeze the game. Sometimes frames got passed back and forth between shuffle rounds, switching places every gettime for a bit when new shuffle round. Would probably work the sameish way now, just got rid of the delay to hopefully make unit events more accurate when units change, at the cost of temporarily breaking a bunch of random things and having to figure out order of things again
    
    end
    
    local hasuitGroupRosterUpdateFunction = hasuitGroupRosterUpdateFunction
    function hasuitSetScriptTestGroupRosterUpdateFunction(fakeFunction)
        danFrame:SetScript("OnEvent", fakeFunction or hasuitGroupRosterUpdateFunction)
    end
end


do
    local C_Timer_After = C_Timer.After
    local hasuitGroupRosterUpdateFunction = hasuitGroupRosterUpdateFunction
    local groupUnitFrames = hasuitUnitFramesForUnitType["group"]
    local function checkAgainAfterLeavingGroup() --attempt to fix a bug where party doesn't update when leaving an instance group into a real group? idk
        local groupSize = GetNumGroupMembers()
        if groupSize==0 then
            groupSize = 1
        end
        if #groupUnitFrames~=groupSize then
            print(hasuitRed, "THING")
            hasuitGroupRosterUpdateFunction()
        end
    end
    local function checkAgainAfterLeavingGroup2()
        C_Timer_After(0, checkAgainAfterLeavingGroup)
    end
    local function checkAgainAfterLeavingGroup3()
        C_Timer_After(0, checkAgainAfterLeavingGroup2)
    end
    
    local danFrame = CreateFrame("Frame")
    danFrame:SetScript("OnEvent", function(_,event)
        C_Timer_After(0, checkAgainAfterLeavingGroup3)
    end)
    danFrame:RegisterEvent("GROUP_LEFT")
    danFrame:RegisterEvent("GROUP_JOINED")
end


-- do
    -- local danFrame = CreateFrame("Frame")
    -- danFrame:SetScript("OnEvent", function(...)
        -- print(...)
    -- end)
    -- danFrame:RegisterEvent("CVAR_UPDATE")
-- end


hasuitRaidFrameWidthForGroupSize = { --hasuitDoThis_Group_Roster_UpdateWidthChanged
    [0]=114,
    114,--1
    114,--2
    114,--3
    114,--4
    114,--5
    
    110,--6
    110,--7
    110,--8
    
    100,--9
    100,--10
    100,--11
    100,--12
    100,--13
    100,--14
    100,--15
    
    98,--16
    98,--17
    98,--18
    98,--19
    98,--20
    
    94,--21
    94,--22
    94,--23
    94,--24
    
    90,--25
    90,--26
    90,--27
    90,--28
    
    86,--29
    86,--30
    86,--31
    86,--32
    
    82,--33
    82,--34
    82,--35
    82,--36
    
    78,--37
    78,--38
    78,--39
    78,--40
}
hasuitRaidFrameHeightForGroupSize = { --hasuitDoThis_Group_Roster_UpdateHeightChanged
    [0]=90,--0 --bored todo make it so that hasuitGlobal_GroupSize can be 0 and not matter, maybe already could remove the check that makes it 1?
    90,--1
    90,--2
    90,--3
    90,--4
    90,--5
    90,--6
    90,--7
    90,--8
    
    83,--9
    83,--10, was 76 up to here
    
    63,--11
    63,--12
    63,--13
    63,--14
    63,--15 was 62
    
    49,--16
    49,--17
    49,--18
    49,--19
    49,--20
    49,--21
    49,--22
    49,--23
    49,--24
    49,--25
    49,--26
    49,--27
    49,--28
    49,--29
    49,--30
    49,--31
    49,--32
    49,--33
    49,--34
    49,--35
    49,--36
    49,--37
    49,--38
    49,--39
    49,--40
}
hasuitRaidFrameColumnsForGroupSize = { --hasuitDoThis_Group_Roster_UpdateColumnsChanged
    [0]=1,--0
    1,--1
    1,--2
    1,--3
    1,--4
    1,--5, columns up to here do nothing atm
    
    4,--6
    4,--7
    4,--8
    
    5,--9
    5,--10
    5,--11
    5,--12
    5,--13
    5,--14
    5,--15
    5,--16
    5,--17
    5,--18
    5,--19
    5,--20
    
    6,--21
    6,--22
    6,--23
    6,--24
    
    7,--25
    7,--26
    7,--27
    7,--28
    
    8,--29
    8,--30
    8,--31
    8,--32
    
    9,--33
    9,--34
    9,--35
    9,--36
    
    10,--37
    10,--38
    10,--39
    10,--40
}










local type = type
local pairs = pairs
local tremove = tremove

local allTable = {}
hasuitAllTable = allTable


local function mainLoadOnFunction()
    -- hasuitMainLoadOnFunctionSpammableActive = false
    for dan=1, #allTable do
        local loadedTable = allTable[dan][1]
        local unloadedTable = allTable[dan][2]
        for spellId, unloadedStuff in pairs(unloadedTable) do --not necessarily a spellId
            local loadedStuff
            local reloadCount = 0
            for i=#unloadedStuff, 1, -1 do
                local loadOn = unloadedStuff[i]["loadOn"]
                if not loadOn or loadOn.shouldLoad then
                    loadedStuff = loadedTable[spellId]
                    if not loadedStuff then
                        loadedTable[spellId] = {}
                        loadedStuff = loadedTable[spellId]
                    end
                    -- local loadFunction = unloadedStuff[i]["loadFunction"] --could do specific load/unload functions per spell like maybe clear an aura? probably won't ever have a good enough reason to uncomment these
                        -- if loadFunction then
                        -- loadFunction()
                    -- end
                    tinsert(loadedStuff, tremove(unloadedStuff, i))
                    reloadCount = reloadCount+1
                end
            end
            if not loadedStuff then 
                loadedStuff = loadedTable[spellId]
            end
            if loadedStuff then
                local numberOfAlreadyLoadedStuff = #loadedStuff-reloadCount
                if numberOfAlreadyLoadedStuff>0 then
                    for i=numberOfAlreadyLoadedStuff, 1, -1 do
                        local loadOn = loadedStuff[i]["loadOn"]
                        if loadOn and not loadOn.shouldLoad then
                            -- local unloadFunction = loadedStuff[i]["unloadFunction"]
                            -- if unloadFunction then
                                -- unloadFunction()
                            -- end
                            tinsert(unloadedStuff, tremove(loadedStuff, i))
                        end
                    end
                    if #loadedStuff==0 then
                        loadedTable[spellId] = nil
                    end
                end
            end
        end
    end
end
hasuitMainLoadOnFunction = mainLoadOnFunction
local GetTime = GetTime
local lastTime
local danPriorityOnUpdate = hasuitDoThis_OnUpdatePosition1
function mainLoadOnFunctionSpammable()
    local currentTime = GetTime()
    if lastTime~=currentTime then
        lastTime = currentTime
        -- hasuitMainLoadOnFunctionSpammableActive = true
        danPriorityOnUpdate(mainLoadOnFunction)
    end
end
hasuitMainLoadOnFunctionSpammable = mainLoadOnFunctionSpammable


local allTablePairsLoaded = {}
hasuitAllTablePairsLoaded = allTablePairsLoaded
local allTablePairsUnloaded = {}
hasuitAllTablePairsUnloaded = allTablePairsUnloaded
function hasuitFramesCenterAddToAllTable(tableForEventType, eventType)
    tinsert(allTable, {tableForEventType, {}})
    local dan = allTable[#allTable]
    allTablePairsLoaded[eventType] = dan[1]
    allTablePairsUnloaded[eventType] = dan[2]
end

local loadedTable
local unloadedTable
function hasuitFramesCenterSetEventType(eventType)
    loadedTable = allTablePairsLoaded[eventType]
    unloadedTable = allTablePairsUnloaded[eventType]
end

local functionsTableLoaded = {}
local functionsTableUnloaded = {}
function hasuitFramesCenterSetEventTypeFromFunction(func)
    loadedTable = functionsTableLoaded[func]
    unloadedTable = functionsTableUnloaded[func]
end

function hasuitFramesCenterAddMultiFunction(func)
    functionsTableLoaded[func] = loadedTable
    functionsTableUnloaded[func] = unloadedTable
    return func
end


local _, instanceType, _, _, _, _, _, instanceId = GetInstanceInfo()
hasuitGlobal_InstanceType = instanceType --none, arena, pvp, scenario, party, raid
hasuitGlobal_InstanceId = instanceId

local groupSize = GetNumGroupMembers()
if groupSize == 0 then
    groupSize = 1
end
hasuitGlobal_GroupSize = groupSize
hasuitGlobal_RaidFrameWidth = hasuitRaidFrameWidthForGroupSize[groupSize]
hasuitGlobal_RaidFrameHeight = hasuitRaidFrameHeightForGroupSize[groupSize]
-- hasuitGlobal_RaidFrameColumns = hasuitRaidFrameColumnsForGroupSize[groupSize]




function hasuitFramesInitialize(spellId) --not necessarily a spellId, todo should make a function to put all options of a controller into savedvariables sorted by priority or something like that? to make it easy to see what exactly is going on. automating priority here wouldn't be worth it i think
    local unloadedStuff = unloadedTable[spellId]
    if not unloadedStuff then
        unloadedTable[spellId] = {}
        unloadedStuff = unloadedTable[spellId]
    end
    
    local loadOn = hasuitSetupSpellOptions["loadOn"]
    if not loadOn or loadOn.shouldLoad then
        
        local loadedStuff = loadedTable[spellId]
        if not loadedStuff then
            loadedTable[spellId] = {}
            loadedStuff = loadedTable[spellId]
        end
        tinsert(loadedStuff, hasuitSetupSpellOptions)
    else
        tinsert(unloadedStuff, hasuitSetupSpellOptions)
    end
end

function hasuitFramesInitializeMulti(spellId, startI) --not necessarily a spellId
    for i=startI or 1, #hasuitSetupSpellOptionsMulti do
        local spellOptions = hasuitSetupSpellOptionsMulti[i]
        local unloadedTable = functionsTableUnloaded[spellOptions[1]]
        
        
        local unloadedStuff = unloadedTable[spellId]
        if not unloadedStuff then
            unloadedTable[spellId] = {}
            unloadedStuff = unloadedTable[spellId]
        end
        
        local loadOn = spellOptions["loadOn"]
        if not loadOn or loadOn.shouldLoad then
            local loadedTable = functionsTableLoaded[spellOptions[1]]
            
            local loadedStuff = loadedTable[spellId]
            if not loadedStuff then
                loadedTable[spellId] = {}
                loadedStuff = loadedTable[spellId]
            end
            tinsert(loadedStuff, spellOptions)
        else
            tinsert(unloadedStuff, spellOptions)
        end
    end
end


hasuitDiminishSpellOptionsTable = {}
hasuitTrackedDiminishSpells = {
    ["stun"]={},
    ["disorient"]={}, --fear
    ["root"]={},
    ["incapacitate"]={}, --sheep
    ["silence"]={},
    ["disarm"]={},
    -- ["knockback"]={},
}

do
    local print = print
    local GetSpellTexture = C_Spell.GetSpellTexture
    local diminishOptionsTable = hasuitDiminishSpellOptionsTable
    local drCount = 0
    local tonumber = tonumber
    function hasuitFramesTrackDiminishTypeAndTexture(drType, texture)
        if not diminishOptionsTable[drType] then
            if type(texture)=="string" then
                local pre = texture
                texture = GetSpellTexture(texture)
                if not texture then
                    if tonumber(pre) then
                        print("|cffff2222HasuitFrames error no texture for \""..pre.."\"|r. This looks like you need to remove the \"'s") --todo how to show which file/line this is coming from? Without needing people to add something to their private addon just for this. maybe something with debug --debugstack?
                    else
                        print("|cffff2222HasuitFrames error no texture for", pre, "|r. spell names have to be in current spellbook to get a texture from them. if you can't get a spell name to work try looking up the spell texture on wowhead. Click the icon there and the texture is the number to the right of ID:  , alternatively you can use /run print(C_Spell.GetSpellTexture(spell))")
                    end
                    return
                end
            end
            drCount = drCount+1
            diminishOptionsTable[drType] = {
                ["arena"] = drCount,
                ["texture"] = texture,
            }
        else
            print("|cffff2222HasuitFrames error attempting to track diminish type", drType, "twice, ignoring|r, everything should still work fine. Removing the duplicate will get rid of this error message")
        end
    end
end

local trackedDiminishSpells = hasuitTrackedDiminishSpells
local drSpellTable
function hasuitFramesCenterSetDrType(drType)
    drSpellTable = trackedDiminishSpells[drType]
end
function hasuitFramesInitializePlusDiminish(spellId)
    tinsert(drSpellTable, spellId)
    local unloadedStuff = unloadedTable[spellId]
    if not unloadedStuff then
        unloadedTable[spellId] = {}
        unloadedStuff = unloadedTable[spellId]
    end
    
    local loadOn = hasuitSetupSpellOptions["loadOn"]
    if not loadOn or loadOn.shouldLoad then
        
        local loadedStuff = loadedTable[spellId]
        if not loadedStuff then
            loadedTable[spellId] = {}
            loadedStuff = loadedTable[spellId]
        end
        tinsert(loadedStuff, hasuitSetupSpellOptions)
    else
        tinsert(unloadedStuff, hasuitSetupSpellOptions)
    end
end


local initializeMulti = hasuitFramesInitializeMulti
function hasuitFramesInitializeMultiPlusDiminish(spellId)
    -- hasuitDoThis_EasySavedVariables(spellId, danTestingCollectionTableDiminish)
    tinsert(drSpellTable, spellId)
    initializeMulti(spellId)
end

































local namePlateGUIDs = hasuitFramesCenterNamePlateGUIDs
local danUnitFrameForUnit = hasuitUnitFrameForUnit
local UnitGUID = UnitGUID

local hasuitFramesCenterGUIDTrackerNameplateAdded = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerNameplateAdded:RegisterEvent("NAME_PLATE_UNIT_ADDED")
hasuitFramesCenterGUIDTrackerNameplateAdded:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED")
hasuitFramesCenterGUIDTrackerNameplateAdded:SetScript("OnEvent", function(_, _, unit)
    local unitGUID = UnitGUID(unit)
    namePlateGUIDs[unitGUID] = unit
    danUnitFrameForUnit[unit] = danUnitFrameForUnit[unitGUID]
end)

local hasuitFramesCenterGUIDTrackerNameplateRemoved = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerNameplateRemoved:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
hasuitFramesCenterGUIDTrackerNameplateRemoved:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_REMOVED")
hasuitFramesCenterGUIDTrackerNameplateRemoved:SetScript("OnEvent", function(_, _, unit)
    namePlateGUIDs[UnitGUID(unit)] = nil
    danUnitFrameForUnit[unit] = nil
end)


do
    local hasuitDoThis_Player_Target_Changed = hasuitDoThis_Player_Target_Changed
    local danFrame = CreateFrame("Frame")
    danFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    danFrame:SetScript("OnEvent", function()
        local unitGUID = UnitGUID("target")
        if unitGUID then
            danUnitFrameForUnit["target"] = danUnitFrameForUnit[unitGUID]
        else
            danUnitFrameForUnit["target"] = nil
        end
        for i=1,#hasuitDoThis_Player_Target_Changed do
            hasuitDoThis_Player_Target_Changed[i]()
        end
    end)
end

local hasuitFramesCenterGUIDTrackerFocusChanged = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerFocusChanged:RegisterEvent("PLAYER_FOCUS_CHANGED")
hasuitFramesCenterGUIDTrackerFocusChanged:SetScript("OnEvent", function()
    local unitGUID = UnitGUID("focus")
    if unitGUID then
        danUnitFrameForUnit["focus"] = danUnitFrameForUnit[unitGUID]
    else
        danUnitFrameForUnit["focus"] = nil
    end
end)

local hasuitFramesCenterGUIDTrackerMouseoverChanged = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerMouseoverChanged:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
hasuitFramesCenterGUIDTrackerMouseoverChanged:SetScript("OnEvent", function()
    local unitGUID = UnitGUID("mouseover")
    if unitGUID then
        danUnitFrameForUnit["mouseover"] = danUnitFrameForUnit[unitGUID]
    else
        danUnitFrameForUnit["mouseover"] = nil
    end
end)

local hasuitFramesCenterGUIDTrackerSoftFriendChanged = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerSoftFriendChanged:RegisterEvent("PLAYER_SOFT_FRIEND_CHANGED") --not sure soft unit stuff will ever have a use, i don't think events ever fire for them, or mouseover, but who knows
hasuitFramesCenterGUIDTrackerSoftFriendChanged:SetScript("OnEvent", function()
    local unitGUID = UnitGUID("softfriend")
    if unitGUID then
        danUnitFrameForUnit["softfriend"] = danUnitFrameForUnit[unitGUID]
    else
        danUnitFrameForUnit["softfriend"] = nil
    end
end)

local hasuitFramesCenterGUIDTrackerSoftEnemyChanged = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerSoftEnemyChanged:RegisterEvent("PLAYER_SOFT_ENEMY_CHANGED")
hasuitFramesCenterGUIDTrackerSoftEnemyChanged:SetScript("OnEvent", function()
    local unitGUID = UnitGUID("softenemy")
    if unitGUID then
        danUnitFrameForUnit["softenemy"] = danUnitFrameForUnit[unitGUID]
    else
        danUnitFrameForUnit["softenemy"] = nil
    end
end)





local _G = _G
tinsert(hasuitDoThis_Player_Entering_WorldFirstOnly, function() --This is a list of global things you can grab and use in an external addon. If you want something to be global that isn't here let me know and I'll add it.
    C_Timer.After(0, function()
        if hasuitTestAllSpellTablesAfter then
            hasuitTestAllSpellTablesAfter()
        end
        
        -- things that stay global and don't get set nil:
        -- hasuitPlayerFrame
        -- hasuitGlobal_InstanceType
        -- hasuitGlobal_InstanceId
        -- hasuitGlobal_GroupSize
        -- hasuitGlobal_RaidFrameWidth
        -- hasuitGlobal_RaidFrameHeight
        -- hasuitGlobal_ScaleMultiplierFromScreenHeight
        
        -- hasuitGlobal_CooldownDisplayActiveGroup
        -- hasuitGlobal_KICKTextKey
        
        -- hasuitSavedUserOptions
        -- hasuitSavedVariables
        
        -- d1-1
        -- d5-1
        -- d1-4
        -- d5-4
        -- and in between, 20 total. These are for targeting macros to target by column/row in raid, or row/column in party. /click d1-1 etc
        
        -- SLASH_HasuitFrames#
        -- hasuitFont#
        -- hasuitUserOptionsFont#
        -- hasuitCooldownFont#
        -- hasuitCastBarFont#
        -- hasuitSetupSpellOptions --always changes before initialize
        -- hasuitFramesOptionsCloseButton --after /hf is used
        
        
        hasuitDoThis_Addon_Loaded = nil --not useful from outside?
        hasuitDoThis_UserOptionsLoaded = nil --not useful from outside?
        hasuitDoThis_Player_Login = nil
        hasuitDoThis_Player_Entering_WorldFirstOnly = nil
        hasuitDoThis_Player_Entering_WorldSkipsFirst = nil
        
        hasuitDoThis_Group_Roster_UpdateAlways = nil
        hasuitDoThis_Group_Roster_UpdateGroupSizeChanged = nil
        hasuitDoThis_Group_Roster_UpdateWidthChanged = nil
        hasuitDoThis_Group_Roster_UpdateHeightChanged = nil
        -- hasuitDoThis_Group_Roster_UpdateColumnsChanged = nil
        hasuitDoThis_Group_Roster_UpdateGroupSize_5 = nil
        hasuitDoThis_Group_Roster_UpdateGroupSize_5_8 = nil
        
        -- hasuitDoThis_GroupUnitFramesUpdate_before = nil
        hasuitDoThis_GroupUnitFramesUpdate = nil
        hasuitDoThis_GroupUnitFramesUpdate_after = nil
        -- hasuitDoThis_GroupUnitFramesUpdate_Positions_before = nil
        hasuitDoThis_GroupUnitFramesUpdate_Positions = nil
        hasuitDoThis_GroupUnitFramesUpdate_Positions_after = nil
        
        hasuitDoThis_OnUpdate = nil
        hasuitDoThis_OnUpdatePosition1 = nil
        -- hasuitDoThis_OnUpdateSpecificPosition = nil
        hasuitDoThis_AfterCombat = nil
        
        hasuitDoThis_Player_Target_Changed = nil
        hasuitUserOptionsOnChanged = nil
        
        hasuitRaidFrameWidthForGroupSize = nil
        hasuitRaidFrameHeightForGroupSize = nil
        hasuitRaidFrameColumnsForGroupSize = nil
        
        hasuitUnitFrameForUnit = nil
        hasuitUpdateAllUnitsForUnitType = nil
        hasuitTrackedRaceCooldowns = nil
        hasuitFramesCenterNamePlateGUIDs = nil
        
        hasuitFramesInitialize = nil
        hasuitFramesInitializeMulti = nil
        hasuitFramesInitializeMultiPlusDiminish = nil
        hasuitSetupSpellOptionsMulti = nil
        hasuitFramesCenterAddMultiFunction = nil
        hasuitFramesCenterSetEventTypeFromFunction = nil
        hasuitFramesCenterAddToAllTable = nil
        hasuitFramesCenterSetEventType = nil
        
        hasuitDiminishSpellOptionsTable = nil
        hasuitTrackedDiminishSpells = nil
        hasuitFramesTrackDiminishTypeAndTexture = nil
        hasuitFramesCenterSetDrType = nil
        hasuitFramesInitializePlusDiminish = nil
        
        
        hasuitLoadOn_EnablePve = nil
        hasuitLoadOn_InstanceTypeNone = nil
        hasuitLoadOn_BgOnly = nil
        hasuitLoadOn_NotArenaOnly = nil
        hasuitLoadOn_ArenaOnly = nil
        hasuitLoadOn_RootCleuBreakable = nil
        hasuitLoadOn_PartySize = nil
        hasuitLoadOn_CooldownDisplay = nil
        hasuitLoadOn_PvpEnemyMiddleCastBars = nil
        
        hasuitTrackedPveSubevents = nil
        
        
        hasuitSpellFunction_Cleu_CcBreakThreshold = nil
        hasuitSpellFunction_Cleu_Interrupted = nil
        hasuitSpellFunction_Cleu_INC = nil
        hasuitSpellFunction_Cleu_Diminish = nil
        hasuitSpellFunction_Cleu_SpellSummon = nil
        hasuitSpellFunction_Cleu_SuccessCooldownReduction = nil
        hasuitSpellFunction_Cleu_InterruptCooldownReduction = nil
        hasuitSpellFunction_Cleu_HealCooldownReduction = nil
        hasuitSpellFunction_Cleu_EnergizeCooldownReduction = nil
        hasuitSpellFunction_Cleu_AppliedCooldownReduction = nil
        hasuitSpellFunction_Cleu_SpellEmpowerInterruptCooldownReduction = nil
        hasuitSpellFunction_Cleu_AppliedCooldownReductionSourceIsDest = nil
        hasuitSpellFunction_Cleu_SuccessCooldownReductionSpec = nil
        hasuitSpellFunction_Cleu_InterruptCooldownReductionSolarBeam = nil
        hasuitSpellFunction_Cleu_AppliedCooldownReductionThiefsBargain354827 = nil
        hasuitSpellFunction_Cleu_SuccessCooldownStart1 = nil
        hasuitSpellFunction_Cleu_SuccessCooldownStart2 = nil
        hasuitSpellFunction_Cleu_HealCooldownStart = nil
        hasuitSpellFunction_Cleu_SpellEmpowerStartCooldownStart2 = nil
        hasuitSpellFunction_Cleu_AppliedCooldownStart = nil
        hasuitSpellFunction_Cleu_RemovedCooldownStart = nil
        hasuitSpellFunction_Cleu_AppliedCooldownStartPreventMultiple = nil
        hasuitSpellFunction_Cleu_SuccessCooldownStartSolarBeam = nil
        hasuitSpellFunction_Cleu_SuccessCooldownStartPvPTrinket = nil
        hasuitSpellFunction_Cleu_AppliedCooldownStartRacial = nil
        hasuitSpellFunction_Cleu_AppliedRacialNotTrackedAffectingPvpTrinket = nil
        hasuitSpellFunction_Cleu_378441TimeStop = nil
        hasuitSpellFunction_Cleu_CooldownStartPet = nil
        hasuitSpellFunction_Cleu_Casting = nil
        hasuitSpellFunction_Cleu_UNIT_DIED = nil
        hasuitSpellFunction_Cleu_SoulEmpoweredHots1 = nil
        hasuitSpellFunction_Cleu_SoulEmpoweredHots2 = nil
        
        hasuitSpellFunction_UnitCastSucceeded_CooldownStart = nil
        hasuitSpellFunction_UnitCastSucceeded_ChangedTalents = nil
        
        hasuitSpellFunction_UnitCasting_MiddleCastBars = nil
        hasuitSpellFunction_UnitCasting_IconsOnDest = nil
        
        hasuitSpellFunction_Aura_MainFunction = nil
        hasuitSpellFunction_Aura_MainFunctionPveUnknown = nil
        hasuitSpellFunction_Aura_SourceIsPlayer = nil
        hasuitSpellFunction_Aura_SourceIsNotPlayer = nil
        hasuitSpellFunction_Aura_Points1Required = nil
        hasuitSpellFunction_Aura_Points2Required = nil
        hasuitSpellFunction_Aura_HypoCooldownFunction = nil
        hasuitSpellFunction_Aura_Points1CooldownReduction = nil
        hasuitSpellFunction_Aura_Points2CooldownReduction = nil
        hasuitSpellFunction_Aura_Points2CooldownReductionExternal = nil
        hasuitSpellFunction_Aura_Points1HidesOther = nil
        hasuitSpellFunction_Aura_DurationCooldownReduction = nil
        
        hasuitSpecialAuraFunction_CcBreakThreshold = nil
        hasuitSpecialAuraFunction_CycloneTimerBar = nil
        hasuitSpecialAuraFunction_SmokeBombFunctionForArenaFrames = nil
        hasuitSpecialAuraFunction_SmokeBombForPlayer = nil
        hasuitSpecialAuraFunction_ShadowyDuel = nil
        hasuitSpecialAuraFunction_FeignDeath = nil
        hasuitSpecialAuraFunction_DarkSimShowingWhatGotStolen = nil
        hasuitSpecialAuraFunction_OrbOfPower = nil
        hasuitSpecialAuraFunction_FlagDebuffBg = nil
        hasuitSpecialAuraFunction_SoulOfTheForest = nil
        hasuitSpecialAuraFunction_SoulHots = nil
        hasuitSpecialAuraFunction_RedLifebloom = nil
        hasuitSpecialAuraFunction_CanChangeTexture = nil
        hasuitSpecialAuraFunction_AuraBlessingOfSac = nil
        hasuitSpecialAuraFunction_BlessingOfAutumn = nil
        hasuitBlessingOfAutumnIgnoreList = nil
        
        
        hasuitSetupSpellOptions_CycloneTimerBar = nil
        hasuitAddCycloneTimerBars = nil
        
        hasuitGetIcon = nil
        hasuitGetCastBar = nil
        
        hasuitOutOfRangeAlpha = nil
        
        hasuitGetD2anCleuSubevent = nil
        hasuitGetD4anCleuSourceGuid = nil
        hasuitGetD12anCleuSpellId = nil
        
        hasuitRestoreCooldowns = nil
        
        hasuitGroupRosterUpdateFunction = nil
        hasuitMakeFakeGetNumGroupMembers = nil
        hasuitSetScriptTestGroupRosterUpdateFunction = nil
        hasuitUpdateGroupUnitFrames = nil
        
        hasuitRemoveUnitHealthControlNotSafe = nil
        hasuitRemoveUnitHealthControlSafe = nil
        
        hasuitSort = nil
        hasuitSortExpirationTime = nil
        hasuitSortPriorityExpirationTime = nil
        
        hasuitNormalGrow = nil
        hasuitMiddleIconGrow = nil
        hasuitMiddleCastBarsGrow = nil
        
        hasuitTrinketCooldowns = nil
        hasuitDefensiveCooldowns = nil
        hasuitInterruptCooldowns = nil
        hasuitCrowdControlCooldowns = nil
        
        -- hasuitInitializeSeparateController = nil
        hasuitCleanController = nil
        hasuitInitializeController = nil
        hasuitSortController = nil
        hasuitAddToSeparateController = nil
        
        
        hasuitController_TopRight_TopRight = nil
        hasuitController_TopLeft_TopLeft = nil
        hasuitController_TopLeft_TopRight = nil
        hasuitController_BottomLeft_BottomRight = nil
        hasuitController_TopRight_TopLeft = nil
        hasuitController_BottomRight_BottomLeft = nil
        hasuitController_Middle_Middle = nil
        
        -- hasuitController_Separate_UpperScreenCastBars = nil
        hasuitController_CooldownsControllers = nil
        
        -- hasuitController_BottomRight_BottomRight = nil
        
        hasuitController_Hots1_BottomRight_BottomRight = nil
        hasuitController_Hots2_BottomRight_BottomRight = nil
        hasuitController_Hots3_BottomRight_BottomRight = nil
        hasuitController_Hots4_BottomRight_BottomRight = nil
        hasuitController_Hots5_BottomRight_BottomRight = nil
        hasuitController_Hots6_BottomRight_BottomRight = nil
        hasuitHots_1 = nil
        hasuitHots_2 = nil
        hasuitHots_3 = nil
        hasuitHots_4 = nil
        hasuitHots_5 = nil
        hasuitHots_6 = nil
        
        hasuitController_BottomLeft_BottomLeft = nil
        hasuitDots_ = nil
        
        
        
        hasuitBigRedMiddleCastBarsSpellOptions = nil
        hasuitGreenishDefensiveMiddleCastBarsSpellOptions = nil
        hasuitOrangeMiddleCastBarsSpellOptions = nil
        hasuitYellowMiddleCastBarsSpellOptions = nil
        hasuitSmallMiscMiddleCastBarsSpellOptions = nil
        hasuitUntrackedMiddleCastBarsSpellOptions = nil
        hasuitSmallDamageMiddleCastBarsSpellOptions = nil
        hasuitMiddleCastBarsAllowChannelingForSpellId = nil
        hasuitMiddleCastBarsAllowHostileNonPlayersForSpellId = nil
        
        hasuitDanCommonTopRightGroupDebuffs = nil
        hasuitDanCommonTopLeftArenaDebuffs = nil
        
        
        hasuitResetCooldowns = nil
        hasuitSetIconText = nil
        hasuitUnusedTextFrames = nil
        hasuitCcBreakHealthThreshold = nil
        hasuitCcBreakHealthThresholdPve = nil
        hasuitClassColorsHexList = nil
        hasuitPlayerGUID = nil
        hasuitPlayerClass = nil
        hasuitSpecIsHealerTable = nil
        hasuitFrameTypeUpdateCount = nil
        hasuitUnitFramesForUnitType_Array = nil
        hasuitUnitFramesForUnitType = nil
        hasuitStartCooldownTimerText = nil
        hasuitVanish96 = nil
        hasuitVanish120 = nil
        hasuitNpcIds = nil
        hasuitMainLoadOnFunctionSpammable = nil
        hasuitMainLoadOnFunction = nil
        hasuitUnitAuraIsFullUpdate = nil
        hasuitAllTable = nil
        hasuitAllTablePairsLoaded = nil
        hasuitAllTablePairsUnloaded = nil
        
        hasuitCooldownTextFonts = nil
        hasuit1PixelBorderBackdrop = nil
        hasuitCommonBackdrop = nil
        hasuitRAID_CLASS_COLORS = nil
        hasuitCastBarOnUpdateFunction = nil
        hasuitGeneralCastStartFrame = nil
        hasuitGeneralCastStartFrame_NoRangedKickForPlayer = nil
        hasuitGeneralCastStartFrame_PlayerHasRangedKick = nil
        hasuitPlayerCaresAboutRangedKickSometimes = nil
        
        hasuitMakeTestGroupFrames = nil
        hasuitDoThis_EachUnitFrameForOneUpdate = nil
        hasuitActiveCustomUnitFrameFunctions = nil
        
        _G["hasuitFramesParent"] = nil
        
        
        
        hasuitPartySort = nil --5 group members or less
        hasuitRaidSort = nil  --6 group members or more
        
        hasuitButtonForUnit = nil
        hasuitRolePriorities = nil
        hasuitClassPriorities = nil
        
        
        
        
        
        
        
        --things that might not be useful externally: --Many others should be moved to here too
        hasuitLocal1 = nil
        hasuitLocal2 = nil
        hasuitLocal3 = nil
        hasuitLocal5 = nil
        hasuitLocal6 = nil
        hasuitLocal7 = nil
        hasuitLocal8 = nil
        hasuitLocal9 = nil
        hasuitLocal10 = nil
        hasuitLocal11 = nil
        
        hasuitActiveScaleMultiplier = nil
        hasuitUninterruptibleBorderSize = nil
        
        
    end)
end)

