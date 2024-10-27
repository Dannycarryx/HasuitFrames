




-- GetScreenHeight
-- GetScreenWidth
-- GetBuildInfo

local hasuitFrameParent = CreateFrame("Frame", "hasuitFrameParent", UIParent)
hasuitFrameParent:SetIgnoreParentScale(true)
hasuitFrameParent:SetScale(0.71111112833023)
hasuitFrameParent:SetSize(1,1)
hasuitFrameParent:SetPoint("CENTER")
hasuitFrameParent:SetFrameStrata("LOW")
hasuitFrameParent:SetFrameLevel(11)

hasuitLoginTime = GetTime()
hasuitPlayerGUID = UnitGUID("player")
hasuitPlayerClass = UnitClassBase("player")
-- hasuitInstanceType is set below

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

hasuitRed = "|cffff2222"
hasuitRed2 = "|cffff6f6f"
hasuitGreen = "|cff00ff00"
hasuitGreen2 = "|cff77ff77"
hasuitYellow = "|cffffff00"
hasuitGrey = "|cffa1a1a1"
hasuitOrange = "|cffffba00"
hasuitOrange2 = "|cffeecb22"
hasuitPurple = "|cffbf00ff"
hasuitPurple2 = "|cffc9a0dc"
hasuitTeal = "|cff00cccc" 
hasuitTeal2 = "|cff66cdcd"
hasuitBlack = "|cff000000"
hasuitBlue = "|cff5555ff"

hasuitSpecIsHealerTable = {
	[105] = true, --resto druid
	[1468] = true, --preservation
	[270] = true, --mistweaver
	[65] = true, --holy paladin
	[256] = true, --disc
	[257] = true, --holy priest
	[264] = true, --rsham
}



-- function dw(...)
	-- local t = {...}
	-- for _, v in pairs(t) do
		-- danPrint(hasuitPurple2..tostring(v).."|r")
	-- end
-- end

local C_Timer_After = C_Timer.After

hasuitTraceGetDanPrintFunction = hasuitTraceGetDanPrintFunction or function()return function()end end

local danFileName = "center.lua"
local danPrint = function()end
local danPrintPurple = danPrint
local danPrintPurple2 = danPrint
local danPrintTeal = danPrint
local danPrintTeal2 = danPrint

-- C_Timer_After(0, function()
	-- danPrint = hasuitTraceGetDanPrintFunction(hasuitGreen2, hasuitGreen2, false, danFileName)
	-- danPrintPurple = hasuitTraceGetDanPrintFunction(hasuitPurple, hasuitPurple, false, danFileName)
	-- danPrintPurple2 = hasuitTraceGetDanPrintFunction(hasuitPurple2, hasuitPurple2, false, danFileName)
	-- danPrintTeal = hasuitTraceGetDanPrintFunction(hasuitTeal, hasuitTeal, false, danFileName)
	-- danPrintTeal2 = hasuitTraceGetDanPrintFunction(hasuitTeal2, hasuitTeal2, false, danFileName)
-- end)

-- local danPrint = function(...)danPrint(danFileName, ...)end

-- local UnitGUID = function(unit)
	-- danPrint("UnitGUID"..danFileName, unit)
	-- return UnitGUID(unit)
-- end




hasuitUnitFrameForUnit = {}
hasuitFrameTypeUpdateCount = {}

hasuitUnitFramesForUnitType = {
	["group"] = {},
	["pet"] = {},
    ["arena"] = {},
}
-- hasuitUnitFrameMakeHealthBarForUnitType = {}

hasuitFramesCenterNamePlateGUIDs = {}

hasuitTrackedRaceCooldowns = {}



hasuitSavedVariables = {}

hasuitSavedEasyChecks = {}





hasuitDoThisAddon_Loaded = {}
hasuitDoThisPlayer_Login = hasuitDoThisPlayer_Login or {} --can sync any addons together here, give them these or other functions/run things in certain orders
hasuitDoThisPlayer_Entering_WorldFirstOnly = {}
hasuitDoThisPlayer_Entering_WorldSkipsFirst = {}

hasuitDoThisGroup_Roster_UpdateAlways = {}
hasuitDoThisGroup_Roster_UpdateGroupSizeChanged = {}
-- hasuitDoThisGroup_Roster_UpdateWidthChanged
-- hasuitDoThisGroup_Roster_UpdateHeightChanged
-- hasuitDoThisGroup_Roster_UpdateColumnsChanged
-- hasuitDoThisGroup_Roster_UpdateGroupSize_5
-- hasuitDoThisGroup_Roster_UpdateGroupSize_5_8

hasuitDoThisPlayer_Target_Changed = {}

-- hasuitDoThisOnUpdate(func)
-- hasuitDoThisOnUpdatePosition1(func)

-- hasuitDoThisAfterCombat(func)


-- hasuitDoThisEasySavedVariables(key, optionalTable)

















local GetInstanceInfo = GetInstanceInfo

local mainLoadOnFunctionSpammable
local tinsert = table.insert
do
	local danDoThisAddonLoaded = hasuitDoThisAddon_Loaded
	local danDoThisPlayerLogin = hasuitDoThisPlayer_Login
	local danDoThisEnteringFirst = hasuitDoThisPlayer_Entering_WorldFirstOnly
	local danFrame = CreateFrame("Frame")
	danFrame:RegisterEvent("ADDON_LOADED")
	danFrame:RegisterEvent("PLAYER_LOGIN")
	danFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	danFrame:SetScript("OnEvent", function(_,event,addonName)
		if event=="ADDON_LOADED" then
			if addonName=="HasuitFrames" then
				danFrame:UnregisterEvent("ADDON_LOADED")
				for i=1,#danDoThisAddonLoaded do
					danDoThisAddonLoaded[i]()
				end
			end
			
		elseif event=="PLAYER_LOGIN" then
			danFrame:UnregisterEvent("PLAYER_LOGIN")
			for i=1,#danDoThisPlayerLogin do
				danDoThisPlayerLogin[i]()
			end
			
		elseif event=="PLAYER_ENTERING_WORLD" then
			for i=1,#danDoThisEnteringFirst do
				danDoThisEnteringFirst[i]()
			end
			mainLoadOnFunctionSpammable() --not really necessary since every groupsize influenced loadon will also call this initially, not clean but not sure how to improve that significantly, even if bored. just going to leave this here in case all groupsize stuff gets abandoned later or something else changes, who knows
			local danDoThisEnteringWorld = hasuitDoThisPlayer_Entering_WorldSkipsFirst
			hasuitDoThisPlayer_Entering_WorldSkipsFirst = nil
			danFrame:SetScript("OnEvent", function() -- danPrint(danGreen(loadedCount).." loaded", danYellow(totalCount-loadedCount), "unloaded")
				local _, instanceType, _, _, _, _, _, instanceId = GetInstanceInfo()
				hasuitInstanceId = instanceId
				if instanceType~=hasuitInstanceType then
					hasuitInstanceType = instanceType
					mainLoadOnFunctionSpammable()
				end
				for i=1,#danDoThisEnteringWorld do
					danDoThisEnteringWorld[i]()
				end
			end)
			
		end
	end)
end







do --hasuitDoThisOnUpdate, hasuitDoThisOnUpdatePosition1
	local danDoThis
	local danFrame = CreateFrame("Frame")
	local function onUpdateFunction()
		local temp = danDoThis
		danDoThis = nil
		for i=1,#temp do
			temp[i]() --kind of catastrophic if an error happens here
		end
		if not danDoThis then
			danFrame:SetScript("OnUpdate", nil) --new setup makes it so inserting to position 1 mid-onupdate doesn't break anything? is there a good way to not have to setscript onupdate an extra time if adding to the table mid-onupdate?
		end
	end
	function hasuitDoThisOnUpdate(func)
		if danDoThis then
			tinsert(danDoThis, func)
		else
			danDoThis = {func}
			danFrame:SetScript("OnUpdate", onUpdateFunction)
		end
	end
	function hasuitDoThisOnUpdatePosition1(func)
		if danDoThis then
			tinsert(danDoThis, 1, func)
		else
			danDoThis = {func}
			danFrame:SetScript("OnUpdate", onUpdateFunction)
		end
	end
	-- function hasuitDoThisOnUpdateSpecificPosition(func, index)
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











do --hasuitDoThisAfterCombat
	local danDoThis
	local danFrame = CreateFrame("Frame")
	function hasuitDoThisAfterCombat(func)
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
	hasuitDoThisRelevantSizes = danDoThisRelevantSizes
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
		hasuitDoThisGroup_Roster_UpdateWidthChanged =		getDoThisSizeTable({5,8,15,20,24,28,32,36,40})
		hasuitDoThisGroup_Roster_UpdateHeightChanged =		getDoThisSizeTable({8,10,15,40})
		hasuitDoThisGroup_Roster_UpdateColumnsChanged =		getDoThisSizeTable({5,8,20,24,28,32,36,40})
		hasuitDoThisGroup_Roster_UpdateGroupSize_5 =		getDoThisSizeTable({5,40})
		hasuitDoThisGroup_Roster_UpdateGroupSize_5_8 =		getDoThisSizeTable({5,8,40})
	end
	
	local danDoThisOnUpdate = hasuitDoThisOnUpdate
	local danDoThis = hasuitDoThisGroup_Roster_UpdateAlways
	local danDoThisGroupSizeChanged = hasuitDoThisGroup_Roster_UpdateGroupSizeChanged
	local danFrame = CreateFrame("Frame")
	danFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	tinsert(hasuitDoThisAddon_Loaded, 1, function()
		hasuitSavedUserOptions = hasuitSavedUserOptions
		for i=1,#danDoThisGroupSizeChanged do
			danDoThisGroupSizeChanged[i]()
		end
		for i=1,#danDoThisRelevantSizes do
			local sizeTable = danDoThisRelevantSizes[i]
			sizeTable.activeRelevantSize = sizeTable[hasuitGroupSize]
			local sizeFunctions = sizeTable.functions
			for j=1,#sizeFunctions do
				sizeFunctions[j]()
			end
		end
		for i=1,#danDoThis do
			danDoThis[i]()
		end
		
		
		-- danDoThisOnUpdate(function()
			-- danFrame:RegisterEvent("GROUP_ROSTER_UPDATE") --prevents group_roster_update stuff from going twice on the same frame as player_login for no reason, maybe bad? --todo if alt f4ing player can log in and no group units will exist until after combat so have to do something to load frames preemptively. for now you can reload after logging in and the game will give the correct numbers
		-- end)
		
		do
			local columnsForGroupSize = hasuitRaidFrameColumnsForGroupSize
			tinsert(hasuitDoThisGroup_Roster_UpdateColumnsChanged.functions, 1, function()
				hasuitRaidFrameColumns = columnsForGroupSize[hasuitGroupSize]
				print("columns changed: ", hasuitRaidFrameColumns)
			end)
		end
	end)
	local function groupRosterUpdateFunction()
		local groupSize = GetNumGroupMembers()
		if groupSize == 0 then
			groupSize = 1
		end
		if groupSize~=hasuitGroupSize then
			hasuitGroupSize = groupSize
			
			for i=1,#danDoThisGroupSizeChanged do
				danDoThisGroupSizeChanged[i]()
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
		for i=1,#danDoThis do
			danDoThis[i]()
		end
	end
	danFrame:SetScript("OnEvent", groupRosterUpdateFunction) --GROUP_ROSTER_UPDATE
	
	
end


hasuitRaidFrameWidthForGroupSize = { --hasuitDoThisGroup_Roster_UpdateWidthChanged
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
hasuitRaidFrameHeightForGroupSize = { --hasuitDoThisGroup_Roster_UpdateHeightChanged
	[0]=90,--0 --bored todo make it so that hasuitGroupSize can be 0 and not matter, maybe already could remove the check that makes it 1?
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
hasuitRaidFrameColumnsForGroupSize = { --hasuitDoThisGroup_Roster_UpdateColumnsChanged
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





do --hasuitDoThisEasySavedVariables
	local danSavedEasyChecks = hasuitSavedEasyChecks
	tinsert(hasuitDoThisAddon_Loaded, function()
		if next(danSavedEasyChecks) then
			print(hasuitRed, "danSavedEasyChecks before addon loaded")
			for k, v in pairs(danSavedEasyChecks) do
				print(k, v)
			end
			hasuitDoThisOnUpdate(function()
				hasuitDoThisEasySavedVariables("danSavedEasyChecks before addon loaded")
			end)
		end
		danSavedEasyChecks = hasuitSavedEasyChecks
	end)
	function hasuitDoThisEasySavedVariables(key, optionalTable)
		local danSavedTable = optionalTable or danSavedEasyChecks
		danSavedTable[key] = (danSavedTable[key] or 0)+1
	end
end





local type = type
local pairs = pairs
local tremove = tremove

local allTable = {}

-- local loadedCount = 0
-- local totalCount = 0


local function mainLoadOnFunction()
	-- local loadedTablesRemoved = 0
	-- local previousLoadedCount = loadedCount
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
					-- local loadFunction = unloadedStuff[i]["loadFunction"] --could do specific load/unload functions per spell like maybe clear an aura? probably won't ever have an actual use for these
						-- if loadFunction then
						-- loadFunction()
					-- end
					-- loadedCount = loadedCount+1
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
							-- loadedCount = loadedCount-1
							tinsert(unloadedStuff, tremove(loadedStuff, i))
						end
					end
					if #loadedStuff==0 then
						-- loadedTablesRemoved = loadedTablesRemoved+1
						loadedTable[spellId] = nil
					end
				end
			end
		end
	end
	-- reportString = reportString.."\n"..danGreen(loadedCount).." loaded "..danYellow((totalCount-loadedCount)).." unloaded"
	-- local difference = loadedCount-previousLoadedCount
	-- if difference>0 then
		-- reportString = reportString..", +"..danGreen(difference)
	-- elseif difference<0 then
		-- reportString = reportString..", "..danYellow(difference)
	-- end
	-- if loadedTablesRemoved>0 then
		-- reportString = reportString..", "..danYellow(loadedTablesRemoved).." loaded tables set nil"
	-- end
	-- danPrint(reportString)
end
local GetTime = GetTime
local lastTime
local danPriorityOnUpdate = hasuitDoThisOnUpdatePosition1
function mainLoadOnFunctionSpammable()
	local currentTime = GetTime()
	if lastTime~=currentTime then
		lastTime = currentTime
		danPriorityOnUpdate(mainLoadOnFunction)
	end
end
hasuitMainLoadOnFunctionSpammable = mainLoadOnFunctionSpammable

-- local temporaryEventTypeTrackingTable = {}

local allTablePairsLoaded = {}
local allTablePairsUnloaded = {}
function hasuitFramesCenterAddToAllTable(tableForEventType, eventType)
	tinsert(allTable, {tableForEventType, {}})
	local dan = allTable[#allTable]
	allTablePairsLoaded[eventType] = dan[1]
	allTablePairsUnloaded[eventType] = dan[2]
	-- temporaryEventTypeTrackingTable[dan[2]] = eventType
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
hasuitInstanceType = instanceType
hasuitInstanceId = instanceId

local groupSize = GetNumGroupMembers()
if groupSize == 0 then
	groupSize = 1
end
hasuitGroupSize = groupSize
hasuitRaidFrameWidth = hasuitRaidFrameWidthForGroupSize[groupSize]
hasuitRaidFrameHeight = hasuitRaidFrameHeightForGroupSize[groupSize]
hasuitRaidFrameColumns = hasuitRaidFrameColumnsForGroupSize[groupSize]


-- local danTestingCollectionTable = {
	-- ["normalInitialize"]={},
	-- ["drInitialize"]={},
-- }
-- local danTestingCollectionTableNormal = danTestingCollectionTable["normalInitialize"]
-- local danTestingCollectionTableDiminish = danTestingCollectionTable["drInitialize"]

function hasuitFramesInitialize(spellId) --not necessarily a spellId, todo should make a function to put all options of a controller into savedvariables sorted by priority or something like that? to make it easy to see what exactly is going on. automating priority here wouldn't be worth it i think
	-- local testing = danTestingCollectionTableNormal[temporaryEventTypeTrackingTable[unloadedTable]]
	-- if not testing then
		-- danTestingCollectionTableNormal[temporaryEventTypeTrackingTable[unloadedTable]] = {}
		-- testing = danTestingCollectionTableNormal[temporaryEventTypeTrackingTable[unloadedTable]]
	-- end
	-- hasuitDoThisEasySavedVariables(spellId, testing)
	
	local unloadedStuff = unloadedTable[spellId]
	if not unloadedStuff then
		unloadedTable[spellId] = {}
		unloadedStuff = unloadedTable[spellId]
	end
	
	local loadOn = hasuitSetupFrameOptions["loadOn"]
	if not loadOn or loadOn.shouldLoad then
		
		local loadedStuff = loadedTable[spellId]
		if not loadedStuff then
			loadedTable[spellId] = {}
			loadedStuff = loadedTable[spellId]
		end
		tinsert(loadedStuff, hasuitSetupFrameOptions)
		-- if spellId==188550 then 
			-- danPrint(loadOn and loadOn.shouldLoad, "load", 188550)
		-- end
		-- loadedCount = loadedCount+1
		-- totalCount = totalCount+1
	else
		-- if spellId==188550 then 
			-- danPrint(loadOn and loadOn.shouldLoad, "don't load", 188550)
		-- end
		tinsert(unloadedStuff, hasuitSetupFrameOptions)
		-- totalCount = totalCount+1 --just do #table?
	end
end

function hasuitFramesInitializeMulti(spellId, doForOne) --not necessarily a spellId
	-- local i1
	-- if doForOne then
		-- i1 = doForOne
	-- else
		-- i1 = 1
		-- doForOne = #hasuitSetupFrameOptionsMulti
	-- end
	-- for i=i1, doForOne do
	for i=doForOne or 1, doForOne or #hasuitSetupFrameOptionsMulti do
		local options = hasuitSetupFrameOptionsMulti[i]
		local unloadedTable = functionsTableUnloaded[options[1]]
		
		
		-- local testing = danTestingCollectionTableNormal[temporaryEventTypeTrackingTable[unloadedTable]]
		-- if not testing then
			-- danTestingCollectionTableNormal[temporaryEventTypeTrackingTable[unloadedTable]] = {}
			-- testing = danTestingCollectionTableNormal[temporaryEventTypeTrackingTable[unloadedTable]]
		-- end
		-- hasuitDoThisEasySavedVariables(spellId, testing)
		
		
		
		local unloadedStuff = unloadedTable[spellId]
		if not unloadedStuff then
			unloadedTable[spellId] = {}
			unloadedStuff = unloadedTable[spellId]
		end
		
		local loadOn = options["loadOn"]
		if not loadOn or loadOn.shouldLoad then
			local loadedTable = functionsTableLoaded[options[1]]
			
			local loadedStuff = loadedTable[spellId]
			if not loadedStuff then
				loadedTable[spellId] = {}
				loadedStuff = loadedTable[spellId]
			end
			tinsert(loadedStuff, options)
			-- loadedCount = loadedCount+1
			-- totalCount = totalCount+1
		else
			tinsert(unloadedStuff, options)
			-- totalCount = totalCount+1 --todo just do #table?
		end
	end
end


hasuitDiminishOptions = {}
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
	local GetSpellTexture = C_Spell.GetSpellTexture
	local diminishOptions = hasuitDiminishOptions
	local drCount = 0
	function hasuitFramesTrackDiminishTypeAndTexture(drType, texture)
		if not diminishOptions[drType] then
			if type(texture)=="string" then
				local pre = texture
				texture = GetSpellTexture(texture)
				if not texture then
					print(hasuitRed, "error no texture for", pre, "|r. spell names have to be in current spellbook to get a texture from them. if you can't get a spell name to work try looking up the spell texture on wowhead. Click the icon there and the texture is the number to the right of ID: ")
					return
				end
			end
			drCount = drCount+1
			diminishOptions[drType] = {
				["arena"] = drCount,
				["texture"] = texture,
			}
			-- print(drType, drCount, texture)
		else
			print(hasuitRed, "error attempting to track diminish type", drType, "twice, ignoring")
		end
	end
end

local trackedDiminishSpells = hasuitTrackedDiminishSpells
local drSpellTable
function hasuitFramesCenterSetDrType(drType)
	drSpellTable = trackedDiminishSpells[drType]
end
function hasuitFramesInitializePlusDiminish(spellId)
	-- local testing = danTestingCollectionTableNormal[temporaryEventTypeTrackingTable[unloadedTable]]
	-- if not testing then
		-- danTestingCollectionTableNormal[temporaryEventTypeTrackingTable[unloadedTable]] = {}
		-- testing = danTestingCollectionTableNormal[temporaryEventTypeTrackingTable[unloadedTable]]
	-- end
	-- hasuitDoThisEasySavedVariables(spellId, testing)
	-- hasuitDoThisEasySavedVariables(spellId, danTestingCollectionTableDiminish)
	
	tinsert(drSpellTable, spellId)
	local unloadedStuff = unloadedTable[spellId]
	if not unloadedStuff then
		unloadedTable[spellId] = {}
		unloadedStuff = unloadedTable[spellId]
	end
	
	local loadOn = hasuitSetupFrameOptions["loadOn"]
	if not loadOn or loadOn.shouldLoad then
		
		local loadedStuff = loadedTable[spellId]
		if not loadedStuff then
			loadedTable[spellId] = {}
			loadedStuff = loadedTable[spellId]
		end
		tinsert(loadedStuff, hasuitSetupFrameOptions)
	else
		tinsert(unloadedStuff, hasuitSetupFrameOptions)
	end
end


local initializeMulti = hasuitFramesInitializeMulti
function hasuitFramesInitializeMultiPlusDiminish(spellId)
	-- hasuitDoThisEasySavedVariables(spellId, danTestingCollectionTableDiminish)
	tinsert(drSpellTable, spellId)
	initializeMulti(spellId)
end


--[[
do --testing
	-- local danDoThisOnUpdate = hasuitDoThisOnUpdate
	-- local GetSpellName = C_Spell.GetSpellName
	-- local tostring = tostring
	-- local function danTesting(table1, table2, differenceTable, initializeType)
		-- for eventType, spellIdTable in pairs(table1[initializeType]) do
			-- local table2EventTypeTable = table2[initializeType]
			-- if table2EventTypeTable then
				-- local table2SpellIdTable = table2EventTypeTable[eventType]
				-- if table2SpellIdTable then
					-- for spellId, count in pairs(spellIdTable) do
						-- local count2 = table2SpellIdTable[spellId]
						-- if count~=count2 then
							-- tinsert(differenceTable, tostring(initializeType)..", "..tostring(eventType)..", "..tostring(spellId)..", "..tostring(GetSpellName(spellId) or nil)..", "..tostring(count)..", "..tostring(count2))
							-- danDoThisOnUpdate(function()
								-- print(initializeType, eventType, hasuitRed2, spellId, count, count2)
							-- end)
						-- else
							-- print(initializeType, eventType, hasuitGreen, spellId, count, count2)
						-- end
					-- end
				-- else
					-- print(hasuitRed, eventType)
				-- end
			-- else
				-- print(hasuitRed, initializeType)
			-- end
		-- end
		-- danDoThisOnUpdate(function()
			-- print(" ")
		-- end)
		-- tinsert(differenceTable, " ")
	-- end
	
	-- tinsert(hasuitDoThisAddon_Loaded, function() --collection, save tables between addon versions to compare, one at a time and then check the difference after, or could just check on the 2nd load. collection should be commented out after finished
		-- hasuitSavedTestingOld = danTestingCollectionTable
		-- hasuitSavedTestingNew = danTestingCollectionTable
	-- end)
	
	
	-- tinsert(hasuitDoThisAddon_Loaded, function() --compare
		-- local old = hasuitSavedTestingOld
		-- local new = hasuitSavedTestingNew
		-- local differenceTable = {}
		-- danTesting(new, old, differenceTable, "normalInitialize")
		-- danTesting(old, new, differenceTable, "normalInitialize")
		-- hasuitSavedTestingDifference = differenceTable
	-- end)
	
	
	
	local function danTestCheckAllSpells()
		local totalUnloaded = 0
		local totalLoaded = 0
		local spellsPerFunction = {}
		for dan=1, #allTable do
			local loadedTable = allTable[dan][1]
			local unloadedTable = allTable[dan][2]
			for spellId, unloadedStuff in pairs(unloadedTable) do
				for i=#unloadedStuff, 1, -1 do
					local options = unloadedStuff[i]
					local func = options[1]
					if danCleuDiminish~=func then
						hasuitDoThisEasySavedVariables(tostring(spellId)..", ", hasuitSavedTestingDifference["unloaded"])
						spellsPerFunction[func] = spellsPerFunction[func] or {}
						spellsPerFunction[func][spellId] = (spellsPerFunction[func][spellId] or 0)+1
					end
					totalUnloaded = totalUnloaded+1
				end
				local loadedStuff = loadedTable[spellId]
				if loadedStuff then
					if #loadedStuff>0 then
						for i=#loadedStuff, 1, -1 do
							local options = loadedStuff[i]
							local func = options[1]
							if danCleuDiminish~=func then
								hasuitDoThisEasySavedVariables(tostring(spellId)..", ", hasuitSavedTestingDifference["loaded"])
								spellsPerFunction[func] = spellsPerFunction[func] or {}
								spellsPerFunction[func][spellId] = (spellsPerFunction[func][spellId] or 0)+1
							end
							totalLoaded = totalLoaded+1
						end
					end
				end
			end
			for func, spellIdTable in pairs(spellsPerFunction) do
				for spellId, count in pairs(spellIdTable) do
					if count~=1 then
						hasuitDoThisEasySavedVariables(tostring(spellId)..", ", hasuitSavedTestingDifference["~=1"])
						print(spellId, hasuitRed2,count)
					end
				end
			end
		end
		print("total unloaded", hasuitOrange, totalUnloaded)
		print("total loaded",  hasuitGreen, totalLoaded)
	end
	tinsert(hasuitDoThisAddon_Loaded, function()
		hasuitSavedTestingDifference = {["loaded"]={},["unloaded"]={},["~=1"]={}}
		C_Timer.After(0, function()
			C_Timer.After(0, function()
				C_Timer.After(0, danTestCheckAllSpells)
			end)
		end)
	end)
	
	
end
]]

































local hasuitFramesCenterNamePlateGUIDs = hasuitFramesCenterNamePlateGUIDs
local hasuitUnitFrameForUnit = hasuitUnitFrameForUnit
local UnitGUID = UnitGUID

local hasuitFramesCenterGUIDTrackerNameplateAdded = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerNameplateAdded:RegisterEvent("NAME_PLATE_UNIT_ADDED")
hasuitFramesCenterGUIDTrackerNameplateAdded:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED")
hasuitFramesCenterGUIDTrackerNameplateAdded:SetScript("OnEvent", function(_, _, unit)
	local unitGUID = UnitGUID(unit)
	hasuitFramesCenterNamePlateGUIDs[unitGUID] = unit
	-- local frame = hasuitUnitFrameForUnit[unitGUID]
	-- if frame then
		hasuitUnitFrameForUnit[unit] = hasuitUnitFrameForUnit[unitGUID]
	-- end
end)

local hasuitFramesCenterGUIDTrackerNameplateRemoved = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerNameplateRemoved:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
hasuitFramesCenterGUIDTrackerNameplateRemoved:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_REMOVED")
hasuitFramesCenterGUIDTrackerNameplateRemoved:SetScript("OnEvent", function(_, _, unit)
	hasuitFramesCenterNamePlateGUIDs[UnitGUID(unit)] = nil
	hasuitUnitFrameForUnit[unit] = nil
end)


do
	local danDoThis = hasuitDoThisPlayer_Target_Changed
	local danFrame = CreateFrame("Frame")
	danFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	danFrame:SetScript("OnEvent", function()
		local unitGUID = UnitGUID("target")
		if unitGUID then
			hasuitUnitFrameForUnit["target"] = hasuitUnitFrameForUnit[unitGUID]
		else
			hasuitUnitFrameForUnit["target"] = nil
		end
		for i=1,#danDoThis do
			danDoThis[i]()
		end
	end)
end

local hasuitFramesCenterGUIDTrackerFocusChanged = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerFocusChanged:RegisterEvent("PLAYER_FOCUS_CHANGED")
hasuitFramesCenterGUIDTrackerFocusChanged:SetScript("OnEvent", function()
	local unitGUID = UnitGUID("focus")
	if unitGUID then
		hasuitUnitFrameForUnit["focus"] = hasuitUnitFrameForUnit[unitGUID]
	else
		hasuitUnitFrameForUnit["focus"] = nil
	end
end)

local hasuitFramesCenterGUIDTrackerMouseoverChanged = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerMouseoverChanged:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
hasuitFramesCenterGUIDTrackerMouseoverChanged:SetScript("OnEvent", function()
	local unitGUID = UnitGUID("mouseover")
	if unitGUID then
		hasuitUnitFrameForUnit["mouseover"] = hasuitUnitFrameForUnit[unitGUID]
	else
		hasuitUnitFrameForUnit["mouseover"] = nil
	end
end)

local hasuitFramesCenterGUIDTrackerSoftFriendChanged = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerSoftFriendChanged:RegisterEvent("PLAYER_SOFT_FRIEND_CHANGED") --not sure soft unit stuff will ever have a use, i don't think events ever fire for them, or mouseover, but who knows
hasuitFramesCenterGUIDTrackerSoftFriendChanged:SetScript("OnEvent", function()
	local unitGUID = UnitGUID("softfriend")
	if unitGUID then
		hasuitUnitFrameForUnit["softfriend"] = hasuitUnitFrameForUnit[unitGUID]
	else
		hasuitUnitFrameForUnit["softfriend"] = nil
	end
end)

local hasuitFramesCenterGUIDTrackerSoftEnemyChanged = CreateFrame("Frame")
hasuitFramesCenterGUIDTrackerSoftEnemyChanged:RegisterEvent("PLAYER_SOFT_ENEMY_CHANGED")
hasuitFramesCenterGUIDTrackerSoftEnemyChanged:SetScript("OnEvent", function()
	local unitGUID = UnitGUID("softenemy")
	if unitGUID then
		hasuitUnitFrameForUnit["softenemy"] = hasuitUnitFrameForUnit[unitGUID]
	else
		hasuitUnitFrameForUnit["softenemy"] = nil
	end
end)




tinsert(hasuitDoThisPlayer_Entering_WorldFirstOnly, function() --make a table of all things that should self destruct instead of keeping track of everything individually to set nil here?
	C_Timer_After(0, function()
		hasuitDoThisAddon_Loaded = nil
		hasuitDoThisPlayer_Login = nil
		hasuitDoThisPlayer_Entering_WorldFirstOnly = nil
		
		hasuitDoThisGroup_Roster_UpdateAlways = nil
		hasuitDoThisGroup_Roster_UpdateGroupSizeChanged = nil
		hasuitDoThisGroup_Roster_UpdateWidthChanged = nil
		hasuitDoThisGroup_Roster_UpdateHeightChanged = nil
		hasuitDoThisGroup_Roster_UpdateColumnsChanged = nil
		hasuitDoThisGroup_Roster_UpdateGroupSize_5 = nil
		hasuitDoThisGroup_Roster_UpdateGroupSize_5_8 = nil
		
		hasuitDoThisOnUpdate = nil
		hasuitDoThisOnUpdatePosition1 = nil
		-- hasuitDoThisOnUpdateSpecificPosition = nil
		-- hasuitGetCurrentOnUpdateTable = nil
		hasuitDoThisPlayerTargetChanged = nil
		hasuitDoThisAfterCombat = nil
		
		-- hasuitDoThisEasySavedVariables = nil
		
		
		hasuitFramesInitializeMulti = nil
		hasuitFramesInitializeMultiPlusDiminish = nil
		hasuitSetupFrameOptionsMulti = nil
		hasuitFramesCenterAddMultiFunction = nil
		functionsTableLoaded = nil
		functionsTableUnloaded = nil
		hasuitFramesCenterSetEventTypeFromFunction = nil
		hasuitFramesCenterAddToAllTable = nil
		-- hasuitFramesCenterSetEventType = nil
		
		hasuitDiminishOptions = nil
		hasuitTrackedDiminishSpells = nil
		hasuitFramesTrackDiminishTypeAndTexture = nil
		hasuitFramesCenterSetDrType = nil
		hasuitFramesInitializePlusDiminish = nil
		
		hasuitFramesOptionsClassSpecificHarmful = nil
		hasuitFramesOptionsClassSpecificHelpful = nil
		-- danBottomRight_BottomRight = nil
		
		hasuitOutOfRangeAlpha = nil
		
		hasuitGetD2anCleuSubevent = nil
		hasuitGetD4anCleuSourceGuid = nil
		hasuitGetD12anCleuSpellId = nil
	end)
end)


