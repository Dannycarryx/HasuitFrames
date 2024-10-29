
local hasuitPlayerGUID = hasuitPlayerGUID





local manaBarHeight = 4
local arenaWidth = hasuitRaidFrameWidthForGroupSize[3]
local arenaHeight = hasuitRaidFrameHeightForGroupSize[3]



local partyX
local partyY

local raidX
local raidY
local raidYForPlayerRaidUnit

local arenaX
local arenaY

local groupColoredBackgroundMinimum
local arenaColoredBackgroundMinimum



local groupUnitFrames = hasuitUnitFramesForUnitType["group"]
local arenaUnitFrames = hasuitUnitFramesForUnitType["arena"]
local changeUnitTypeColorBackgrounds
local danCurrentUnitTable
local danCurrentGroupSize = hasuitGroupSize
local danCurrentPartySize = GetNumSubgroupMembers()

local InCombatLockdown = InCombatLockdown
local updateArenaPositions
local updatingGroupPositions
local danUpdateGroupPositionsButtons

tinsert(hasuitDoThisUserOptionsLoaded, function()
	local savedUserOptions = hasuitSavedUserOptions
	local userOptionsOnChanged = hasuitUserOptionsOnChanged
	local danRunAfterCombat = hasuitDoThisAfterCombat
	
	
	
	local function updateGroupPositions()
		if not InCombatLockdown() then
			danUpdateGroupPositionsButtons()
		elseif not updatingGroupPositions then
			updatingGroupPositions = true
			danRunAfterCombat(danUpdateGroupPositionsButtons)
		end
	end
	
	
	
	partyX = savedUserOptions["partyX"]
	userOptionsOnChanged["partyX"] = function()
		partyX = savedUserOptions["partyX"]
		updateGroupPositions()
	end
	partyY = savedUserOptions["partyY"]
	userOptionsOnChanged["partyY"] = function()
		partyY = savedUserOptions["partyY"]
		updateGroupPositions()
	end
	
	raidX = savedUserOptions["raidX"]
	userOptionsOnChanged["raidX"] = function()
		raidX = savedUserOptions["raidX"]
		updateGroupPositions()
	end
	raidY = savedUserOptions["raidY"]
	raidYForPlayerRaidUnit = raidY-12
	userOptionsOnChanged["raidY"] = function()
		raidY = savedUserOptions["raidY"]
		raidYForPlayerRaidUnit = raidY-12
		updateGroupPositions()
	end
	
	
	local updatingArenaPositions
	local function arenaPositions2()
		updatingArenaPositions = nil
		updateArenaPositions()
	end
	local function arenaPositionsAsd()
		arenaX = savedUserOptions["arenaX"]
		arenaY = savedUserOptions["arenaY"]
		if not InCombatLockdown() then
			updateArenaPositions()
		elseif not updatingArenaPositions then
			updatingArenaPositions = true
			danRunAfterCombat(arenaPositions2)
		end
	end
	arenaX = savedUserOptions["arenaX"]
	userOptionsOnChanged["arenaX"] = arenaPositionsAsd
	arenaY = savedUserOptions["arenaY"]
	userOptionsOnChanged["arenaY"] = arenaPositionsAsd
	
	
	
	groupColoredBackgroundMinimum = savedUserOptions["groupColoredBackgroundMinimum"]
	userOptionsOnChanged["groupColoredBackgroundMinimum"] = function()
		groupColoredBackgroundMinimum = savedUserOptions["groupColoredBackgroundMinimum"]
		danCurrentUnitTable = groupUnitFrames
		changeUnitTypeColorBackgrounds(groupColoredBackgroundMinimum>0 and danCurrentGroupSize>=groupColoredBackgroundMinimum)
	end
	
	
	
	arenaColoredBackgroundMinimum = savedUserOptions["arenaColoredBackgroundMinimum"]
	userOptionsOnChanged["arenaColoredBackgroundMinimum"] = function()
		arenaColoredBackgroundMinimum = savedUserOptions["arenaColoredBackgroundMinimum"]
		danCurrentUnitTable = arenaUnitFrames
		changeUnitTypeColorBackgrounds(arenaColoredBackgroundMinimum>0 and #arenaUnitFrames>=arenaColoredBackgroundMinimum)
	end
	
	
	
	local makeTestGroupFrames = hasuitMakeTestGroupFrames
	userOptionsOnChanged["partyTest"] = function()
		makeTestGroupFrames(savedUserOptions["partyTest"])
	end
	local makeTestArenaFrames = hasuitMakeTestArenaFrames
	userOptionsOnChanged["arenaTest"] = function()
		makeTestArenaFrames(savedUserOptions["arenaTest"])
	end
	userOptionsOnChanged["raidTest"] = function()
		makeTestGroupFrames(savedUserOptions["raidTest"])
	end
	
	
	
	
	-- CHANGE = savedUserOptions["CHANGE"]
	-- userOptionsOnChanged["CHANGE"] = function()
		-- CHANGE = savedUserOptions["CHANGE"]
		-- updateGroupUnitFrames()
	-- end
end)




local frameWidthForGroupSize = hasuitRaidFrameWidthForGroupSize
local numColumnsForGroupSize = hasuitRaidFrameColumnsForGroupSize
local frameHeightForGroupSize = hasuitRaidFrameHeightForGroupSize

local danGetHealthBar
local unusedHealthBars = {}

local danGetPowerBar
local unusedPowerBars = {}


local danAddGroupUnits

local hasuitUnitFrameForUnit = hasuitUnitFrameForUnit

local hasuitButtonForUnit = {}
local hasuitFramesCenterNamePlateGUIDs = hasuitFramesCenterNamePlateGUIDs

local healthBarsCreated = 0
-- local powerBarsCreated = 0

local tinsert = table.insert
local tremove = table.remove
local sort = table.sort
local floor = math.floor
local pairs = pairs
local select = select
local format = string.format
local wipe = table.wipe
local C_Timer_After = C_Timer.After
local CreateFrame = CreateFrame
local IsInInstance = IsInInstance
local UnitIsUnit = UnitIsUnit
local GetSpellName = C_Spell.GetSpellName
local GetSpellTexture = C_Spell.GetSpellTexture
local UnitRace = UnitRace
local GetCurrentEventID = GetCurrentEventID

local powerBarOnEvent
local danEnablePowerBar
local danDisablePowerBar
local danUpdateClassColor3
local danFullPowerUpdate

local darkenedClassColorsForColorBackground = 0.45
local outOfRangeAlpha = hasuitOutOfRangeAlpha
local arenaSpecIconAlpha = 0.45


local rolePriorities
local classPriorities
local danUpdatePriority
local danUpdateFrameRole

local danUpdateHealthAndAbsorbValues

local danBorder = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1}

local danIsRaidUnit

local numberOfGroupFrames = 0


local UnitExists = UnitExists
local danExists = UnitExists("player")

local updateFrameUnit

local unitsToAddToTable = {}

local danUnitAuraIsFullUpdate = hasuitUnitAuraIsFullUpdate

local danInitializeArenaSpecialIcons

local danRemoveUnitHealthControlNotSafe
local UnitHealth = UnitHealth
local danCurrentUnitHealth








--todo imaginary party/arena frames for world pvp, optional target/focus frame for bgs?, ability to give high priority to specific units by alt-ctrl-shift-right clicking their frame or something









local updateArena

local danClassColors = hasuitClassColorsHexList
local danRAID_CLASS_COLORS = {}

local RAID_CLASS_COLORS = RAID_CLASS_COLORS
for unitClass in pairs(danClassColors) do
	local colors = RAID_CLASS_COLORS[unitClass]
	danRAID_CLASS_COLORS[unitClass] = {
		r=colors.r,
		g=colors.g,
		b=colors.b,
	}
end
danRAID_CLASS_COLORS["d/c"] = {
	r=0.3,
	g=0.3,
	b=0.3,
}
danClassColors["d/c"] = "|cff7F7F7F"


local danGetUnit_HealthFunctionColorBackground

local danSetScriptRangeMaybe

local danCurrentFrame
local danCurrentUnit
local danPlayerFrame

local disableColorBackgroundForFrame
local enableColorBackgroundForFrame
local colorBackgroundTableRed
local colorBackgroundTableGreen
local colorBackgroundTableBlue
do
	local danUnitRangeFrame = CreateFrame("Frame")
	danUnitRangeFrame:RegisterEvent("UNIT_IN_RANGE_UPDATE")
	local danInRangeNormal
	local danInRangeColoredBackgrounds
	
	function danSetScriptRangeMaybe()
		danUnitRangeFrame:SetScript("OnEvent", danInRangeNormal)
	end

	do
		local lastEventId
		function danInRangeNormal(_, _, unit, inRange)
			local currentEventId = GetCurrentEventID()
			if lastEventId == currentEventId then
				return
			end
			lastEventId = currentEventId
			
			local frame = hasuitUnitFrameForUnit[unit]
			if frame then
				if inRange then
					frame:SetAlpha(1)
				else
					frame:SetAlpha(outOfRangeAlpha)
				end
			end
		end
	end

	local danColorVehicleEventsFrame
	local UnitInVehicle = UnitInVehicle

	local function colorBackgroundsFirstRun()
		danColorVehicleEventsFrame = CreateFrame("Frame")
		do -- ___ vehicle
			local lastEventId
			local UnitInVehicle = UnitInVehicle
			danColorVehicleEventsFrame:SetScript("OnEvent", function(_,event,unit) --gets a bunch of args i think
				local currentEventId = GetCurrentEventID()
				if lastEventId == currentEventId then
					return
				end
				lastEventId = currentEventId
				
				local frame = hasuitUnitFrameForUnit[unit]
				if frame then
					local blackCount = frame.blackCount
					if blackCount then
						if UnitInVehicle(unit) then
							if not frame.blackCheckVehicle then
								frame.blackCheckVehicle = true
								frame.blackCount = blackCount+1
								if blackCount==0 then --was 0
									frame.background:SetColorTexture(0,0,0)
									danRemoveUnitHealthControlNotSafe(frame.otherUnitHealthFunctions, frame.colorBackground)
								end
							end
						else
							if frame.blackCheckVehicle then
								frame.blackCheckVehicle = false
								frame.blackCount = blackCount-1
								if blackCount==1 then --was 1
									danCurrentUnitHealth = UnitHealth(unit) --todo test scope stuff, does this make things worse than keeping all unit_health stuff closer together?
									frame.colorBackground()
									tinsert(frame.otherUnitHealthFunctions, frame.colorBackground) --danGiveUnitHealthControl
								end
							end
						end
					end
				end
			end)
		end
		do -- ___ range, UNIT_DIED/dead function also has similar checks like these
			local lastEventId
			function danInRangeColoredBackgrounds(_, _, unit, inRange)
				local currentEventId = GetCurrentEventID()
				if lastEventId == currentEventId then
					return
				end
				lastEventId = currentEventId
				
				local frame = hasuitUnitFrameForUnit[unit]
				if frame then
				
					if inRange then
						frame:SetAlpha(1)
						
						local blackCount = frame.blackCount
						if blackCount then
							if frame.blackCheckRange then
								frame.blackCheckRange = false
								frame.blackCount = blackCount-1
								if blackCount==1 then --was 1
									danCurrentUnitHealth = UnitHealth(unit)
									frame.colorBackground()
									tinsert(frame.otherUnitHealthFunctions, frame.colorBackground) --danGiveUnitHealthControl
								end
							end
						end
					else
						frame:SetAlpha(outOfRangeAlpha)
						
						local blackCount = frame.blackCount
						if blackCount then
							if not frame.blackCheckRange then
								frame.blackCheckRange = true
								frame.blackCount = blackCount+1
								if blackCount==0 then --was 0
									frame.background:SetColorTexture(0,0,0)
									danRemoveUnitHealthControlNotSafe(frame.otherUnitHealthFunctions, frame.colorBackground)
								end
							end
						end
					end
				end
			end
		end
		for unitClass in pairs(danClassColors) do
			local colors = danRAID_CLASS_COLORS[unitClass]
			danRAID_CLASS_COLORS[unitClass.."dark"] = {
				r = colors.r*darkenedClassColorsForColorBackground,
				g = colors.g*darkenedClassColorsForColorBackground,
				b = colors.b*darkenedClassColorsForColorBackground,
			}
		end
		danRAID_CLASS_COLORS["d/cdark"] = {
			r = 0.22,
			g = 0.22,
			b = 0.22,
		}
		
		colorBackgroundTableRed = {}
		colorBackgroundTableGreen = {}
		colorBackgroundTableBlue = {}
		
		for i=0,25 do --not sure what i like better here
			colorBackgroundTableRed[i] = 1
			colorBackgroundTableGreen[i] = 0
			colorBackgroundTableBlue[i] = 0.4*((25-i)/25)
		end
		for i=26,50 do
			colorBackgroundTableRed[i] = 1
			colorBackgroundTableGreen[i] = (i-25)/25
			colorBackgroundTableBlue[i] = 0
		end
		for i=51,90 do
			colorBackgroundTableRed[i] = floor(((1-(i-50)/40)+.0005)*1000)/1000
			colorBackgroundTableGreen[i] = 1
			colorBackgroundTableBlue[i] = 0
		end
		for i=91,100 do
			colorBackgroundTableRed[i] = 0
			colorBackgroundTableGreen[i] = 1
			colorBackgroundTableBlue[i] = 0
		end
		
		
		-- for i=0,50 do
			-- colorBackgroundTableRed[i] = 1
			-- colorBackgroundTableGreen[i] = i/50
			-- colorBackgroundTableBlue[i] = 0
		-- end
		-- for i=51,100 do
			-- colorBackgroundTableRed[i] = 1-(i-51)/51
			 -- -- -- colorBackgroundTableRed[i] = floor(((1-(i-51)/51)+.0005)*1000)/1000 --don't think this does anything useful
			-- colorBackgroundTableGreen[i] = 1
			-- colorBackgroundTableBlue[i] = 0
		-- end
	end

	function enableColorBackgroundForFrame()
		local blackCount = 0
		if not UnitInRange(danCurrentUnit) then --player frame gets corrected from broken(?) range function later, --todo other stuff like unit_phase and big range can set frame low opacity without doing these checks properly, i think that's what's wrong anyway
			danCurrentFrame.blackCheckRange = true
			blackCount = blackCount+1
		end
		if danCurrentFrame.dead then
			danCurrentFrame.blackCheckDead = true
			blackCount = blackCount+1
		end
		if UnitInVehicle(danCurrentUnit) then
			danCurrentFrame.blackCheckVehicle = true
			blackCount = blackCount+1
		end
		danCurrentFrame.blackCount = blackCount
		local colorBackgroundFunction = danGetUnit_HealthFunctionColorBackground(danCurrentFrame, danCurrentFrame.background)
		danCurrentFrame.colorBackground = colorBackgroundFunction
		if blackCount==0 then
			local percentHealth = floor(((UnitHealth(danCurrentUnit)+UnitGetTotalAbsorbs(danCurrentUnit))/UnitHealthMax(danCurrentUnit))*100)
			if percentHealth > 100 then 
				percentHealth = 100
			end
			danCurrentFrame.background:SetColorTexture(colorBackgroundTableRed[percentHealth], colorBackgroundTableGreen[percentHealth], colorBackgroundTableBlue[percentHealth])
			tinsert(danCurrentFrame.otherUnitHealthFunctions, colorBackgroundFunction) --danGiveUnitHealthControl
		else
			danCurrentFrame.background:SetColorTexture(0,0,0)
		end
	end


	function disableColorBackgroundForFrame()
		if danCurrentFrame.blackCount==0 then
			danCurrentFrame.background:SetColorTexture(0,0,0)
			danRemoveUnitHealthControlNotSafe(danCurrentFrame.otherUnitHealthFunctions, danCurrentFrame.colorBackground)
		end
		danCurrentFrame.colorBackground = nil
		danCurrentFrame.blackCount = nil
		
		danCurrentFrame.blackCheckVehicle = nil
		danCurrentFrame.blackCheckDead = nil
		danCurrentFrame.blackCheckRange = nil
	end


	do
		local colorTypeCount = 0
		function changeUnitTypeColorBackgrounds(enable)
			if enable and not danCurrentUnitTable.colorBackgroundEnabled then
				if colorBackgroundsFirstRun then
					colorBackgroundsFirstRun()
					colorBackgroundsFirstRun = nil
				end
				danCurrentUnitTable.colorBackgroundEnabled = true
				for i=1, #danCurrentUnitTable do
					danCurrentFrame = danCurrentUnitTable[i]
					danCurrentUnit = danCurrentFrame.unit
					enableColorBackgroundForFrame()
					danUpdateClassColor3(danCurrentFrame)
				end
				colorTypeCount = colorTypeCount+1
				
				if colorTypeCount==1 then
					danColorVehicleEventsFrame:RegisterEvent("UNIT_ENTERING_VEHICLE")
					danColorVehicleEventsFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
					danColorVehicleEventsFrame:RegisterEvent("UNIT_EXITING_VEHICLE")
					danColorVehicleEventsFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
					danUnitRangeFrame:SetScript("OnEvent", danInRangeColoredBackgrounds)
				end
				
			elseif not enable and danCurrentUnitTable.colorBackgroundEnabled then
				danCurrentUnitTable.colorBackgroundEnabled = nil
				for i=1, #danCurrentUnitTable do
					danCurrentFrame = danCurrentUnitTable[i]
					disableColorBackgroundForFrame()
					danUpdateClassColor3(danCurrentFrame)
				end
				colorTypeCount = colorTypeCount-1
				
				if colorTypeCount==0 then
					danColorVehicleEventsFrame:UnregisterAllEvents()
					danUnitRangeFrame:SetScript("OnEvent", danInRangeNormal)
				end
			end
		end
	end
end


-- danHighPriorityCount = 2
-- danHighPriorityCount=danHighPriorityCount-0.000000001
















local hasuitFrameParent = hasuitFrameParent


function danGetHealthBar()
	if #unusedHealthBars>0 then
		-- danPrintPurple2("danGetHealthBar", "active: "..healthBarsCreated-#unusedHealthBars, "inactive: "..#unusedHealthBars)
		return tremove(unusedHealthBars)
	else
		-- danPrintPurple("danGetHealthBar+1", "active: "..healthBarsCreated-#unusedHealthBars, "inactive: "..#unusedHealthBars)
		healthBarsCreated = healthBarsCreated+1
		
		local frame = CreateFrame("StatusBar", nil, hasuitFrameParent) --SetFrameLevel of parent is 11
		frame.id = healthBarsCreated
		
		frame:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
		
		frame.controllersPairs = {}
		frame.controllersArray = {}
		frame.auraInstanceIDs = {}
		
		frame.border = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		
		local targetedCountText = frame.border:CreateFontString() --the text below should maybe be parent = border too
		frame.targetedCountText = targetedCountText
		targetedCountText:SetPoint("CENTER", frame, "CENTER", 1, 1)
		targetedCountText:SetFont("Fonts/FRIZQT__.TTF", 12, "OUTLINE")
		targetedCountText:SetIgnoreParentAlpha(true)
		
		local border = frame.border
		border:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
		border:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 1, 1)
		border:SetFrameLevel(25)
		border:SetBackdrop(danBorder)
		border:SetBackdropBorderColor(0, 0, 0)
		border.frame = frame
		
		frame.text = frame:CreateFontString()
		frame.text:SetPoint("CENTER", border, "CENTER", 0, 6)
		frame.text:SetFont("Fonts/FRIZQT__.TTF", 12, "OUTLINE")
		
		frame.text2 = frame:CreateFontString()
		frame.text2:SetPoint("CENTER", border, "CENTER", 0, -6)
		frame.text2:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
		frame.text2:SetTextColor(0.5, 0.5, 0.5)
		
		frame.background = frame:CreateTexture(nil, "BACKGROUND")
		frame.background:SetAllPoints()
		frame.background:SetIgnoreParentAlpha(true)
		
		local absorbBar = CreateFrame("StatusBar", nil, frame)
		frame.absorbBar = absorbBar
		absorbBar:SetStatusBarTexture("Interface\\RaidFrame\\Shield-Fill")
		absorbBar:SetFrameLevel(12)
		absorbBar.frame = frame
		
		local overAbsorbBar = CreateFrame("StatusBar", nil, frame)
		frame.overAbsorbBar = overAbsorbBar
		overAbsorbBar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
		overAbsorbBar:SetFrameLevel(13)
		overAbsorbBar:SetFillStyle("REVERSE")
		
		return frame
	end
end

function danGetPowerBar()
	if #unusedPowerBars>0 then
		-- danPrintTeal2("danGetPowerBar", "active: "..powerBarsCreated-#unusedPowerBars, "inactive: "..#unusedPowerBars)
		return tremove(unusedPowerBars)
	else
		-- danPrintTeal("danGetPowerBar+1", "active: "..powerBarsCreated-#unusedPowerBars, "inactive: "..#unusedPowerBars)
		-- powerBarsCreated = powerBarsCreated+1
		
		local powerBar = CreateFrame("StatusBar")
		powerBar:SetHeight(manaBarHeight)
		powerBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Fill")
		powerBar:SetFrameStrata("LOW")
		powerBar:SetFrameLevel(14)
		powerBar.background = powerBar:CreateTexture(nil, "BACKGROUND")
		powerBar.background:SetAllPoints()
		powerBar.background:SetColorTexture(0,0,0)
		powerBar.background:SetIgnoreParentAlpha(true)
		powerBar:SetScript("OnEvent", powerBarOnEvent)
		return powerBar
	end
end




























































local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local updateTargetBorder
do
	local danFindBorderUnit
	if danEnableActionBarTargeting then --is this something i should teach people to set up? it was complicated and time consuming before but now it's that + a lot of knowledge to set it up at all with the 255 macro limit, might be cool but also might get the tech that only i use nerfed, like adaptive swarm spread. maybe for the better though since it borders on cheating anyway and i've had second thoughts about using it lately. was cooler back when i made the setup in wod where i just used default ui. now the castbar addon kind of makes it too good and it would be impossible to use effectively in modern wow without the addon since the auto target thing is very broken/spammed by a bunch of dots and random stuff for no reason. realistically it might be cool for blizzard to just let addons tell who something is being cast on but not totally convinced of that. i might make a keybinding addon to release eventually and could make the setup for people easy with that, maybe better to wait for that and not get people to invest a bunch of time into something that gets nerfed and then have to switch everything back
		ActionBarController:UnregisterEvent("ACTIONBAR_PAGE_CHANGED") --game lagged horribly every actionbar change without doing this in dragonflight i think?, not sure if still a problem but probably
		local actionBarPage = GetActionBarPage()
		local actionBarUpdateFrame = CreateFrame("Frame")
		actionBarUpdateFrame:SetScript("OnEvent", function()
			actionBarPage = GetActionBarPage()
			updateTargetBorder()
		end)
		actionBarUpdateFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
		
		local danActionBarUnitList = {
			{"player"},
			{"party1"},
			{"party2", "partypet1"},
			{"party3", "partypet1", "partypet2"},
			{"party4", "partypet2"},
		}
		function danFindBorderUnit()
			if actionBarPage==6 then
				return "target", 1, 1, 1, 1
			else
				local unitList = danActionBarUnitList[actionBarPage]
				for i=1, #unitList do
					local unit=unitList[i]
					if UnitExists(unit) and not UnitCanAttack("player", unit) and not UnitIsDeadOrGhost(unit) then --todo update as units res/un-mind control etc. right now if i press 3 to heal party2 but they were mc'd and un mind control it probably won't update the border for the new actionbar target
						return unit, 0.106, 0.851, 1, 0.4
					end
				end
			end
		end
		
	else
		function danFindBorderUnit()
			return "target", 1, 1, 1, 1
		end
	end
	
	
	local lastFrameBorderUpdated
	function updateTargetBorder()
		local unit, red, green, blue, alpha = danFindBorderUnit()
		local border
		if unit then
			local unitGUID = UnitGUID(unit)
			local frame = hasuitUnitFrameForUnit[unitGUID]
			if frame then
				border = frame.border
				border:SetBackdropBorderColor(red, green, blue, alpha)
			end
		end
		if lastFrameBorderUpdated and lastFrameBorderUpdated~=border then
			lastFrameBorderUpdated:SetBackdropBorderColor(0, 0, 0)
		end
		lastFrameBorderUpdated = border
	end
	
	tinsert(hasuitDoThisPlayer_Target_Changed, updateTargetBorder)
end























local unitDiedFunction = hasuitUnitDiedFunction
hasuitUnitDiedFunction = nil

local danCurrentUnitGUID
local danCurrentUnitType

local danCurrentMaxHealth
local danCurrentAbsorbs

local UnitHealthMax = UnitHealthMax
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs

local danGetUnit_HealthFunctionMain
local danGetUnit_HealthFunctionAbsorbs
local danAbsorbFunction


function hasuitUnitFrameMakeHealthBarMain()
	danCurrentFrame = danGetHealthBar()
	danCurrentFrame:Show()
	
	danCurrentFrame:RegisterUnitEvent("UNIT_HEALTH", danCurrentUnit)
	
	local border = danCurrentFrame.border
	border:RegisterUnitEvent("UNIT_IN_RANGE_UPDATE", danCurrentUnit)
	border:RegisterUnitEvent("UNIT_DISTANCE_CHECK_UPDATE", danCurrentUnit)
	
	local dan = {}
	danCurrentFrame.otherUnitHealthFunctions = dan
	danCurrentFrame:SetScript("OnEvent", danGetUnit_HealthFunctionMain(dan))
	
	local absorbBar = danCurrentFrame.absorbBar
	absorbBar:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", danCurrentUnit)
	absorbBar:SetScript("OnEvent", danAbsorbFunction)
	absorbBar.healthFunctionAbsorbs = danGetUnit_HealthFunctionAbsorbs(absorbBar, danCurrentFrame)
	
	danSetSize()
	danInitialHealthAndAbsorbsFunction()
	
	danCurrentFrame.unit = danCurrentUnit
	hasuitUnitFrameForUnit[danCurrentUnit] = danCurrentFrame
	
	tinsert(danCurrentUnitTable, danCurrentFrame)
	danCurrentFrame.unitType = danCurrentUnitType
	
	if danCurrentUnitGUID then
		danCurrentFrame.unitGUID = danCurrentUnitGUID
		hasuitUnitFrameForUnit[danCurrentUnitGUID] = danCurrentFrame
	end
	
	if danCurrentUnitTable.colorBackgroundEnabled then
		enableColorBackgroundForFrame()
	else
		danCurrentFrame.background:SetColorTexture(0,0,0)
	end
	
	danUpdateUnitSpecial[danCurrentUnitType]()
	
	
	if UnitIsDeadOrGhost(danCurrentUnit) then
		unitDiedFunction(danCurrentFrame)
	end
	
	
	danCurrentFrame:SetPoint("TOP", hasuitButtonForUnit[danCurrentUnit], "TOP", 0, -1)
	
	
end


function danRemoveUnitHealthControlNotSafe(oldOtherUnitHealthFunctions, healthFunction) --unregisterevent --just don't use it on a unit_health event. it can prevent other functions in the table from going and give an error
	for i=#oldOtherUnitHealthFunctions,1,-1 do
		if healthFunction==oldOtherUnitHealthFunctions[i] then
			tremove(oldOtherUnitHealthFunctions, i)
			return
		end
	end
end
hasuitRemoveUnitHealthControlNotSafe = danRemoveUnitHealthControlNotSafe
local danRemoveUnitHealthControlSafe
do
	local function danEmpty()
	end
	function danRemoveUnitHealthControlSafe(oldOtherUnitHealthFunctions, healthFunction)
		for i=#oldOtherUnitHealthFunctions,1,-1 do
			if healthFunction==oldOtherUnitHealthFunctions[i] then
				if i==#oldOtherUnitHealthFunctions then
					tremove(oldOtherUnitHealthFunctions, i)
				else
					oldOtherUnitHealthFunctions[i] = danEmpty
					C_Timer_After(0, function()
						danRemoveUnitHealthControlNotSafe(oldOtherUnitHealthFunctions, danEmpty)
					end)
				end
				return
			end
		end
	end
	hasuitRemoveUnitHealthControlSafe = danRemoveUnitHealthControlSafe
end





local danGetUnit_HealthFunctionLines

local healthBarLineOnEvent
local hasuitHealthBarTargetLinesForUnits
local danMakeHealthBarTargetLine
local danHideTargetLines
do
	local danLineHeight = 5
	function healthBarLineOnEvent(line, event, unit)
		if event=="UNIT_TARGET" then
			local show
			local unitTargetGUID = UnitGUID(unit.."target")
			if unitTargetGUID then
				local attachToFrame = hasuitUnitFrameForUnit[unitTargetGUID]
				if attachToFrame and (attachToFrame.unitType=="group" and line.unitType=="arenaLine" or attachToFrame.unitType=="arena" and line.unitType=="groupLine") then
					show = true
					local unitTarget = attachToFrame.unit --weird bug(?) with just using unit.."target" for registering events here. it registers unit and target as two individual units. todo test if this could get a single frame to listen to many unitevents
					line:SetParent(attachToFrame)
					line:SetFrameLevel(15)
					line:SetPoint("TOP", attachToFrame, "CENTER", 0, -danLineHeight*line.lineNumber) --todo
					line:SetMinMaxValues(0, UnitHealthMax(unitTarget))
					line:SetValue(UnitHealth(unitTarget))
					if line.oldOtherUnitHealthFunctionsLines then --.shown
						line:UnregisterEvent("UNIT_MAXHEALTH") --is this needed?
						danRemoveUnitHealthControlNotSafe(line.oldOtherUnitHealthFunctionsLines, line.healthFunctionLines)
					else
						line:SetAlpha(1)
					end
					line.oldOtherUnitHealthFunctionsLines = attachToFrame.otherUnitHealthFunctions
					tinsert(attachToFrame.otherUnitHealthFunctions, line.healthFunctionLines) --danGiveUnitHealthControl
					line:RegisterUnitEvent("UNIT_MAXHEALTH", unitTarget)
					
					if not line.colorSet then --todo make healer target line shorter? or something but probably not hide completely
						local unitClass = UnitClassBase(unit)
						if unitClass then
							line.colorSet = true --very bored todo, set color properly once per line per shuffle round
						else
							unitClass = "d/c"
						end
						local colors = danRAID_CLASS_COLORS[unitClass]
						line:SetStatusBarColor(colors.r,colors.g,colors.b) --todo would making a function for each color that returns 3 things and just putting that here be better?
					end
					
				end
			end
			if not show and line.oldOtherUnitHealthFunctionsLines then
				line:SetAlpha(0)
				line:UnregisterEvent("UNIT_MAXHEALTH")
				danRemoveUnitHealthControlNotSafe(line.oldOtherUnitHealthFunctionsLines, line.healthFunctionLines)
				line.oldOtherUnitHealthFunctionsLines = nil
			end
		else --UNIT_MAXHEALTH
			line:SetMinMaxValues(0, UnitHealthMax(unit))
			line:SetValue(UnitHealth(unit))
		end
	end
		
	hasuitHealthBarTargetLinesForUnits = {}
	local danNumberOfGroupLines = 0
	local danNumberOfArenaLines = 0
	local danLineWidth = hasuitRaidFrameWidthForGroupSize[3] --todo do something when useroptions can change size
	function danMakeHealthBarTargetLine() --target indicator healthbars in arena
		local line = danGetHealthBar()
		line:SetAlpha(0)
		line:Show()
		line:SetSize(danLineWidth, danLineHeight)
		line.border:Hide()
		line.background:Hide()
		hasuitHealthBarTargetLinesForUnits[danCurrentUnit] = line
		line.unitType = danCurrentUnitType.."Line"
		line:RegisterUnitEvent("UNIT_TARGET", danCurrentUnit)
		line.healthFunctionLines = danGetUnit_HealthFunctionLines(line)
		line:SetScript("OnEvent", healthBarLineOnEvent)
		if danCurrentUnitType=="group" then
			line.lineNumber = danNumberOfGroupLines
			danNumberOfGroupLines = danNumberOfGroupLines+1
		else --danCurrentUnitType=="arena"
			line.lineNumber = danNumberOfArenaLines
			danNumberOfArenaLines = danNumberOfArenaLines+1
		end
		healthBarLineOnEvent(line, "UNIT_TARGET", danCurrentUnit)
	end
	
	function danHideTargetLines()
		for _, line in pairs(hasuitHealthBarTargetLinesForUnits) do
			line.color = nil --to prevent miscolored overabsorb bars unless adding that to lines later
			line.border:Show()
			line.background:Show()
			
			if line.oldOtherUnitHealthFunctionsLines then
				danRemoveUnitHealthControlNotSafe(line.oldOtherUnitHealthFunctionsLines, line.healthFunctionLines)
				line.oldOtherUnitHealthFunctionsLines = nil
			end
			line.healthFunctionLines = nil
			
			line.colorSet = nil
			line.lineNumber = nil
			line:SetParent(hasuitFrameParent)
			line:Hide()
			danHideUnitFrame2(line) --todo get rid of here? or really it should work itself out after making a proper system for recycling unusual stuff and including "arenaLines" and "groupLines" with the main unitframes table
		end
		danNumberOfGroupLines = 0
		danNumberOfArenaLines = 0
		hasuitHealthBarTargetLinesForUnits = {}
	end
end







local danCurrentUnitFrameWidth
local danCurrentUnitFrameWidthPlus2
local danCurrentUnitFrameWidthPlus3
do
	local frameWidthForGroupSize = hasuitRaidFrameWidthForGroupSize --todo update group size/button stuff here
	tinsert(hasuitDoThisGroup_Roster_UpdateWidthChanged.functions, 1, function()
		danCurrentUnitFrameWidth = frameWidthForGroupSize[danCurrentGroupSize]
		danCurrentUnitFrameWidthPlus2 = danCurrentUnitFrameWidth+2
		danCurrentUnitFrameWidthPlus3 = danCurrentUnitFrameWidth+3
		hasuitRaidFrameWidth = danCurrentUnitFrameWidth
	end)
end

local danCurrentUnitFrameHeight
local danCurrentUnitFrameHeightPlus2
local danCurrentUnitFrameHeightPlus3
do
	local frameHeightForGroupSize = hasuitRaidFrameHeightForGroupSize
	tinsert(hasuitDoThisGroup_Roster_UpdateHeightChanged.functions, 1, function()
		danCurrentUnitFrameHeight = frameHeightForGroupSize[danCurrentGroupSize]
		danCurrentUnitFrameHeightPlus2 = danCurrentUnitFrameHeight+2
		danCurrentUnitFrameHeightPlus3 = danCurrentUnitFrameHeight+3
		hasuitRaidFrameHeight = danCurrentUnitFrameHeight
	end)
end











function danSetSize()
	local height = danCurrentFrame.powerBar and (danCurrentUnitFrameHeight-manaBarHeight) or danCurrentUnitFrameHeight
	danCurrentFrame:SetSize(danCurrentUnitFrameWidth, height)
	danCurrentFrame.border:SetHeight(danCurrentUnitFrameHeightPlus2)
	danCurrentFrame.absorbBar:SetSize(danCurrentUnitFrameWidth, height)
	danCurrentFrame.overAbsorbBar:SetSize(danCurrentUnitFrameWidth, height)
	
	danCurrentFrame.width = danCurrentUnitFrameWidth
	danCurrentFrame.height = height
end

local danCooldownDoneRecycle = hasuitCooldownDoneRecycle
hasuitCooldownDoneRecycle = nil
local danRequestsInspection = {}
local danIsInspecting = 0

local danUnusedRoleIcons = {}

function danHideUnitFrame2(frame)
	local unitGUID = frame.unitGUID
	if unitGUID then
		if frame == hasuitUnitFrameForUnit[unitGUID] then
			hasuitUnitFrameForUnit[unitGUID] = nil
		end
		frame.unitGUID = nil
	end
	
	frame.unit = nil
	frame:SetScript("OnUpdate", nil)
	
	local controllersArray = frame.controllersArray
	for i=1, #controllersArray do
		local frames = controllersArray[i].frames
		for j=1, #frames do
			local cooldown = frames[j].cooldown
			cooldown:Clear()
			danCooldownDoneRecycle(cooldown)
		end
	end
	
	frame:UnregisterAllEvents()
	frame.role = nil
	
	if frame.roleIcon then
		frame.roleIcon:SetAlpha(0)
		tinsert(danUnusedRoleIcons, frame.roleIcon)
		frame.roleIcon = nil
	end
	
	frame.unitType = nil
	frame.number = nil
	frame.text:SetText("")
	frame.text2:SetText("")
	frame.broken = nil
	frame.made = nil
	frame.thiefsBargain = nil
	
	if frame.targetOf then
		frame.targetedCountText:SetText("")
		frame.targetOf = nil
	end
	
	local arenaStuff = frame.arenaStuff
	if arenaStuff then
		for i=#arenaStuff,1,-1 do
			local diminishIcon = arenaStuff[i]
			diminishIcon.border:SetAlpha(0)
			diminishIcon.diminishLevel = nil
			diminishIcon:SetAlpha(0)
			diminishIcon.cooldown:Clear()
			
			tinsert(hasuitUnusedIcons[diminishIcon.iconType], tremove(arenaStuff, i))
		end
		if frame.arenaSpecIcon then
			frame.arenaSpecIcon:SetAlpha(0)
			tinsert(hasuitUnusedIcons[frame.arenaSpecIcon.iconType], frame.arenaSpecIcon)
			frame.arenaSpecIcon = nil
			frame.arenaSpec = nil
		end
		frame.arenaStuff = nil
	end
	frame.specId = nil
	frame.cooldowns = nil
	frame.cooldownOptions = nil
	frame.cooldownPriorities = nil
	frame.cooldownsDisabled = nil
	if frame.specialAuras then
		if frame.hypoSpellId then
			frame.hypoSpellId = nil
			frame.hypoAffectedSpells = nil
			frame.hypoAffectedSpellsPairs = nil
		elseif frame.soulTable then
			local dan = frame.soulOtherTables
			for i=1,#dan do
				dan[i][unitGUID]=nil
			end
			frame.soulTable = nil
			frame.disableSoul = nil
		end
		frame.specialAuras = nil
		frame.specialAuraInstanceIDsRemove = {} --todo i forgot what this even does, causes errors sometimes if setting to nil?
	end
	frame.inspected = nil
	if danRequestsInspection[frame] then
		danRequestsInspection[frame] = nil
		danIsInspecting = danIsInspecting-1
	end
	
	frame.border:UnregisterAllEvents()
	
	local absorbBar = frame.absorbBar
	if absorbBar.absorbing then
		absorbBar:SetValue(0)
		frame.overAbsorbBar:SetValue(0)
		absorbBar.absorbing = nil
		absorbBar.healthFunctionAbsorbs = nil
	end
	frame.dead = nil
	
	absorbBar:SetScript("OnEvent", nil)
	absorbBar:UnregisterAllEvents()
	if frame.healAbsorbing then
		frame.healAbsorbing = nil
		frame.healAbsorbText:SetText("")
	end
	
	
	-- if frame.updatingColor then
		-- frame:SetScript("OnUpdate", nil)
	-- end
	-- frame.updatingColor = nil
	
	if frame.colorBackground then
		danCurrentFrame = frame
		disableColorBackgroundForFrame()
	end
	
	frame.hideTimer = nil
	frame.updated = nil
	frame.unitClass = nil
	frame.unitRace = nil
	frame.seen = nil
	frame.unitName = nil
	frame.unitClassSet = nil
	frame.unitNameSet = nil
	
	
	local powerBar = frame.powerBar
	if powerBar then
		powerBar:Hide()
		powerBar:UnregisterAllEvents()
		tinsert(unusedPowerBars, powerBar)
		frame.powerBar = nil
	end
	
	tinsert(unusedHealthBars, frame)
end




function danUpdateClassColor3(frame)
	frame.updatingColor = false
	frame:SetScript("OnUpdate", nil)
	
	local healthBarColor
	if UnitIsConnected(frame.unit) or frame.unitType=="arena" and (hasuitArenaGatesActive or not UnitIsVisible(frame.unit)) then
		healthBarColor = frame.unitClass
	else
		healthBarColor = "d/c"
	end
	if frame.colorBackground then
		healthBarColor = healthBarColor.."dark"
		
		if healthBarColor ~= frame.color then
			frame.color = healthBarColor
			local colors = danRAID_CLASS_COLORS[healthBarColor]
			local r = colors.r
			local g = colors.g
			local b = colors.b
			frame:SetStatusBarColor(r,g,b)
			frame.overAbsorbBar:SetStatusBarColor(r,g,b)
		end
		
	else
		if healthBarColor ~= frame.color then
			frame.color = healthBarColor
			local colors = danRAID_CLASS_COLORS[healthBarColor]
			frame:SetStatusBarColor(colors.r,colors.g,colors.b)
			frame.overAbsorbBar:SetStatusBarColor(colors.r,colors.g,colors.b)
		end
	end
end


local danAddSpecializationCooldowns
function danUpdateClass(frame)
	local failed
	if not frame.unitClassSet then
		local unitClass = UnitClassBase(frame.unit) or "d/c"
		if unitClass~="d/c" then
			danCurrentFrame = frame
			danCurrentUnitType = frame.unitType
			if hasuitCooldownDisplayActiveGroup then
				local _, race = UnitRace(danCurrentFrame.unit)
				if race and hasuitTrackedRaceCooldowns[race] then
					danCurrentFrame.unitRace = race
					danAddSpecializationCooldowns(race, true)
				end
				danAddSpecializationCooldowns("general", true)
				danAddSpecializationCooldowns(unitClass, true)
				danCurrentFrame.cooldownsDisabled = nil
			else
				danCurrentFrame.cooldownsDisabled = true
			end
			frame.unitClassSet = true
			frame.unitClass = unitClass
		else
			frame.unitClass = unitClass
			failed = true
		end
	end
	if not frame.unitNameSet then
		local unitName = UnitNameUnmodified(frame.unit) or "Unknown"
		if unitName~="Unknown" then
			frame.unitNameSet = true
		else
			failed = true
		end
		-- frame.unitName = danClassColors[frame.unitClass]..unitName.."|r"
		frame.unitName = unitName
	end
	if not failed then
		frame.colorFunction = danUpdateClassColor3
	else
		frame.colorFunction = danUpdateClass
	end
	danUpdateClassColor3(frame)
end


local danGetRoleIcon
do
	local danSetAtlasThing = GetMicroIconForRoleEnum(Enum.LFGRole.Tank)
	function danGetRoleIcon()
		if #danUnusedRoleIcons>0 then
			return tremove(danUnusedRoleIcons)
		else
			local roleIcon = CreateFrame("Frame")
			
			roleIcon = hasuitFrameParent:CreateTexture()
			roleIcon:SetSize(16,16)
			roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
			roleIcon:SetAtlas(danSetAtlasThing)
			
			return roleIcon
		end
	end
end




rolePriorities = {
	["TANK"] 	= 1000,
	["NONE"] 	= 2000,
	["DAMAGER"] = 3000,
	["HEALER"] 	= 4000,
}
classPriorities = { --todo spec priorities
	["WARRIOR"] 	= 200,
	["PALADIN"] 	= 200,
	["ROGUE"] 		= 200,
	["DEATHKNIGHT"] = 200,
	["MONK"] 		= 200,
	["DEMONHUNTER"] = 200,
	
	["HUNTER"] 		= 400,
	["SHAMAN"] 		= 400,
	["DRUID"] 		= 400,
	
	["EVOKER"] 		= 600,
	
	["PRIEST"] 		= 800,
	["MAGE"] 		= 800,
	["WARLOCK"]		= 800,
	
	["d/c"]			= 5000,
}

function danUpdateFrameRole2(skipLastHalf)
	-- danPrint("danUpdateFrameRole2")
	local role = UnitGroupRolesAssigned(danCurrentUnit)
	if danCurrentFrame.role ~= role then 
		if role == "TANK" then 
			if not danCurrentFrame.roleIcon then
				local roleIcon = danGetRoleIcon()
				danCurrentFrame.roleIcon = roleIcon
				roleIcon:SetPoint("BOTTOMLEFT", danCurrentFrame, "BOTTOMLEFT", 1, 1)
				roleIcon:SetParent(danCurrentFrame.border)
				roleIcon:SetAlpha(1)
			end
		elseif danCurrentFrame.roleIcon then
			danCurrentFrame.roleIcon:SetAlpha(0)
			tinsert(danUnusedRoleIcons, danCurrentFrame.roleIcon)
			danCurrentFrame.roleIcon = nil
		end
		danCurrentFrame.role = role
	end
	if not skipLastHalf and danCurrentFrame~=danPlayerFrame then
		if role == "HEALER" or danCurrentFrame.unitClass=="DEATHKNIGHT" then 
			danEnablePowerBar2()
		else
			danDisablePowerBar2()
		end
		danCurrentFrame.priority = classPriorities[danCurrentFrame.unitClass] + rolePriorities[danCurrentFrame.role] + danCurrentFrame.id
	end
end






function powerBarOnEvent(powerBar, event, unit)
	if event=="UNIT_POWER_FREQUENT" then 
		powerBar:SetValue(UnitPower(unit))
		
	elseif event=="UNIT_MAXPOWER" then 
		powerBar:SetMinMaxValues(0, UnitPowerMax(unit))
		powerBar:SetValue(UnitPower(unit))
		
	else --UNIT_DISPLAYPOWER
		danFullPowerUpdate(powerBar, unit)
		
	end
end

function danFullPowerUpdate(powerBar, unit)
	powerBar:SetMinMaxValues(0, UnitPowerMax(unit))
	powerBar:SetValue(UnitPower(unit))
	local _, powerType = UnitPowerType(unit)
	if not powerType then
		return
	end
	local color = PowerBarColor[powerType]
	powerBar:SetStatusBarColor(color.r, color.g, color.b)
	return true
end








function danEnablePowerBar2() --height gets set once here and once on roster update, todo
	local powerBar = danCurrentFrame.powerBar
	if not powerBar then
		local height = danCurrentFrame.height
		if not height then
			return
		else
			height = height-manaBarHeight
		end
		danCurrentFrame:SetHeight(height)
		danCurrentFrame.height = height
		danCurrentFrame.absorbBar:SetHeight(height)
		danCurrentFrame.overAbsorbBar:SetHeight(height)
		
		danCurrentFrame.powerBar = danGetPowerBar()
		powerBar = danCurrentFrame.powerBar
		powerBar:SetPoint("TOPLEFT", danCurrentFrame, "BOTTOMLEFT")
		powerBar:SetPoint("TOPRIGHT", danCurrentFrame, "BOTTOMRIGHT")
		powerBar:SetParent(danCurrentFrame)
		powerBar:Show()
		powerBar:RegisterUnitEvent("UNIT_POWER_FREQUENT", danCurrentUnit)
		powerBar:RegisterUnitEvent("UNIT_MAXPOWER", danCurrentUnit)
		powerBar:RegisterUnitEvent("UNIT_DISPLAYPOWER", danCurrentUnit)
	end
	danFullPowerUpdate(powerBar, danCurrentUnit)
end

function danDisablePowerBar2()
	local powerBar = danCurrentFrame.powerBar
	if not powerBar then
		return
	end

	local height = danCurrentFrame.height+manaBarHeight
	danCurrentFrame:SetHeight(height)
	danCurrentFrame.height = height
	danCurrentFrame.absorbBar:SetHeight(height)
	danCurrentFrame.overAbsorbBar:SetHeight(height)

	powerBar:Hide()
	powerBar:UnregisterAllEvents()
	tinsert(unusedPowerBars, powerBar)
	danCurrentFrame.powerBar = nil
end















function danGetUnit_HealthFunctionMain(otherUnitHealthFunctions)
	return function(frame, _, unit) --gets directly SetScript("OnEvent", danGetUnit_HealthFunctionMain(otherUnitHealthFunctions)) for unit_health(the only event registered for that kind of frame) on every main frame so like group and arena dancurrentframe, should go through and make sure dancurrentframe only gets used for those kinds of main unitframes, todo change frame's name everywhere to unitframe? and dancurrentframe to dancurrentunitframe
		danCurrentUnitHealth = UnitHealth(unit)
		frame:SetValue(danCurrentUnitHealth)
		for i=1,#otherUnitHealthFunctions do
			otherUnitHealthFunctions[i]()
		end
	end
end
function danGetUnit_HealthFunctionLines(frame)
	return function() --line.healthFunctionLines() --lines are from the same pool of frames as main unitframes but are only in arena/act differently and get recycled afterward to be usable as main unitframes. arenaLine seems like a confusing name because some of them are really partyLines and have that unitType. maybe rename lineHealthBarTargetIndicator or something
		frame:SetValue(danCurrentUnitHealth)
	end
end
do
	local function getColorsForBackground(unit, maxHealth)
		local percentHealth = floor(((danCurrentUnitHealth+UnitGetTotalAbsorbs(unit))/maxHealth)*100)
		if percentHealth > 100 then 
			percentHealth = 100
		end
		return colorBackgroundTableRed[percentHealth], colorBackgroundTableGreen[percentHealth], colorBackgroundTableBlue[percentHealth]
	end

	function danGetUnit_HealthFunctionColorBackground(frame, background) --bored todo prevent it from changing color to exact same color?
		return function() --frame.colorBackground()
			background:SetColorTexture(getColorsForBackground(frame.unit, frame.maxHealth))
		end
	end
end
--danGetUnit_HealthFunctionAbsorbs below --absorbBar.healthFunctionAbsorbs()
--checkDead in unitDiedFunction --frame.dead() --todo name some things better and more consistently like sometimes icons are frame




do
	local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
	function danAbsorbFunction(absorbBar, event, unit)
		local absorbs = UnitGetTotalAbsorbs(unit)
		if absorbs>0 then
			danCurrentUnitHealth = UnitHealth(unit)
			danCurrentMaxHealth = UnitHealthMax(unit)
			local frame = absorbBar.frame
			
			
			if not absorbBar.absorbing then
				absorbBar.absorbing = true
				
				tinsert(frame.otherUnitHealthFunctions, absorbBar.healthFunctionAbsorbs) --danGiveUnitHealthControl
				absorbBar:RegisterUnitEvent("UNIT_MAXHEALTH", unit) --always UNIT_ABSORB_AMOUNT_CHANGED
				
				local absorbBarXOffset = danCurrentUnitFrameWidth*danCurrentUnitHealth/danCurrentMaxHealth --todo something to always setpoint integer well? tried something like that and it just made it worse. not sure what the best way to do these bars is. the absorb bars are one of the few things that weren't completely remade from my old raidframe addon that was just healthbars/absorb bars
				absorbBar:SetPoint("TOP", frame, "TOP", absorbBarXOffset, 0)
				frame.overAbsorbBar:SetPoint("RIGHT", frame, "RIGHT", absorbBarXOffset-danCurrentUnitFrameWidth, 0)
				absorbBar:SetMinMaxValues(0, danCurrentMaxHealth)
				frame.overAbsorbBar:SetMinMaxValues(0, danCurrentMaxHealth)
				
			elseif event=="UNIT_MAXHEALTH" then
				local absorbBarXOffset = danCurrentUnitFrameWidth*danCurrentUnitHealth/danCurrentMaxHealth
				absorbBar:SetPoint("TOP", frame, "TOP", absorbBarXOffset, 0)
				frame.overAbsorbBar:SetPoint("RIGHT", frame, "RIGHT", absorbBarXOffset-danCurrentUnitFrameWidth, 0)
				absorbBar:SetMinMaxValues(0, danCurrentMaxHealth)
				frame.overAbsorbBar:SetMinMaxValues(0, danCurrentMaxHealth)
				
			end
			
			if event=="UNIT_ABSORB_AMOUNT_CHANGED" and frame.blackCount==0 then --bored todo, make this stuff more efficient. maybe rework health/absorb bars to change frame size instead of needing to setpoint a bunch?
				frame.colorBackground()
			end
			
			local missingHealth = danCurrentMaxHealth-danCurrentUnitHealth
			if absorbs>missingHealth then 
				absorbBar:SetValue(missingHealth) --do values need to get set on max health update?
				if absorbs<=danCurrentMaxHealth then  --maybe get rid of this check somehow?
					frame.overAbsorbBar:SetValue(absorbs-missingHealth)
				else
					frame.overAbsorbBar:SetValue(danCurrentMaxHealth-missingHealth)
				end
			else
				absorbBar:SetValue(absorbs)
				frame.overAbsorbBar:SetValue(0)
			end
			return true
			
		elseif absorbBar.absorbing then
			local frame = absorbBar.frame
			absorbBar:SetValue(0)
			frame.overAbsorbBar:SetValue(0)
			
			danRemoveUnitHealthControlNotSafe(frame.otherUnitHealthFunctions, absorbBar.healthFunctionAbsorbs)
			absorbBar:UnregisterEvent("UNIT_MAXHEALTH")
			
			absorbBar.absorbing = false
		end
	end
	
	local function danAbsorbUnitHealthOnly(absorbBar, unit)
		local absorbs = UnitGetTotalAbsorbs(unit)
		local maxHealth = UnitHealthMax(unit)
		local frame = absorbBar.frame
		
		local absorbBarXOffset = danCurrentUnitFrameWidth*danCurrentUnitHealth/maxHealth
		absorbBar:SetPoint("TOP", frame, "TOP", absorbBarXOffset, 0)
		frame.overAbsorbBar:SetPoint("RIGHT", frame, "RIGHT", absorbBarXOffset-danCurrentUnitFrameWidth, 0)
		
		local missingHealth = maxHealth-danCurrentUnitHealth
		if absorbs>missingHealth then 
			absorbBar:SetValue(missingHealth)
			if absorbs<=maxHealth then
				frame.overAbsorbBar:SetValue(absorbs-missingHealth)
			else
				frame.overAbsorbBar:SetValue(maxHealth-missingHealth)
			end
		else
			absorbBar:SetValue(absorbs)
			frame.overAbsorbBar:SetValue(0)
		end
	end
	function danGetUnit_HealthFunctionAbsorbs(absorbBar, frame)
		return function() --absorbBar.healthFunctionAbsorbs()
			danAbsorbUnitHealthOnly(absorbBar, frame.unit)
		end
	end
end


function danInitialHealthAndAbsorbsFunction()
	if not danAbsorbFunction(danCurrentFrame.absorbBar, "initial", danCurrentUnit) then
		danCurrentMaxHealth = UnitHealthMax(danCurrentUnit)
		if danCurrentMaxHealth==0 then
			danCurrentMaxHealth = 1
			danCurrentUnitHealth = 1
		else
			danCurrentUnitHealth = UnitHealth(danCurrentUnit)
		end
	end
	danCurrentFrame:SetMinMaxValues(0, danCurrentMaxHealth)
	danCurrentFrame:SetValue(danCurrentUnitHealth)
	danCurrentFrame.maxHealth = danCurrentMaxHealth --todo?
end














do
	local GetNumSubgroupMembers = GetNumSubgroupMembers
	tinsert(hasuitDoThisGroup_Roster_UpdateGroupSizeChanged, 1, function()
		danCurrentGroupSize = hasuitGroupSize
		danCurrentPartySize = GetNumSubgroupMembers()
		
		danCurrentUnitTable = groupUnitFrames
		changeUnitTypeColorBackgrounds(groupColoredBackgroundMinimum>0 and danCurrentGroupSize>=groupColoredBackgroundMinimum) --bugged during a shuffle transition where group size was 4 and someone was d/ced for 1 frame, dark color stuck on the one that was d/ced, so i moved this out of group roster update unsafe function and changed a few things with updating existing units so should be good now? the problem was probably with updating existing units and probably not this
	end)
end



local numberOfTrackedDrs
local arenaDiminishTextures = {}

local updatingGroupRoster
local hasuitUpdateGroupRosterUnsafe

tinsert(hasuitDoThisPlayer_Login, 1, function()
	do
		local buttonUnits = { --todo improve groupsize changing in combat
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
			
			"party1",
			"party2",
			"party3",
			"party4",
			
			"arena1",
			"arena2",
			"arena3",
			"arena4",
			"arena5",
			"player",
			
			"raid1",
			"raid2",
			"raid3",
			"raid4",
			"raid5",
			"target",
			-- "player2", --for raid?, not made yet, todo
		}
		
		for x=1,5 do
			for y=1,4 do
				local clickButton = CreateFrame("Button", "d"..x.."-"..y, hasuitFrameParent, "SecureUnitButtonTemplate") --danclick, for macros to target frames, /click d1-1 will always target player (should just be /target [@player] to be safe with relog in combat until that gets fixed), /click d5-1 will target lowest frame in a party(usually party4 but if group is <6 and not everyone is in party it should target whatever that raid unit is at the bottom), /click d1-2 will target first unit of row 2(unitframe directly below player frame) etc, bored todo option to enable/disable? probably not worth the space in useroptions although that could be a way to make people aware that it's even a feature
				clickButton:RegisterForClicks("AnyDown")
				clickButton:SetAttribute("*type1", "target")
				clickButton:SetAttribute("toggleForVehicle", true) --trying this out
			end
		end
		local GetMouseButtonClicked = GetMouseButtonClicked
		local IsMouseButtonDown = IsMouseButtonDown
		local MouselookStop = MouselookStop
		local MouselookStart = MouselookStart
		local danOnUpdateMouseUpCheckFrame = CreateFrame("Frame")
		local function danOnUpdateMouseUpCheck()
			if not IsMouseButtonDown() then
				MouselookStop()
				danOnUpdateMouseUpCheckFrame:SetScript("OnUpdate", nil)
			end
		end
		
		for i=1,#buttonUnits do
			local unit = buttonUnits[i]
			local button = CreateFrame("Button", nil, hasuitFrameParent, "SecureUnitButtonTemplate")
			hasuitButtonForUnit[unit] = button
			button:SetFrameStrata("LOW")
			button:SetFrameLevel(10)
			
			
			button:RegisterForClicks("AnyDown")
			button:SetAttribute("*type1", "target")
			button:SetAttribute("unit", unit)
			button:SetScript("OnMouseDown", function()
				danOnUpdateMouseUpCheckFrame:SetScript("OnUpdate", danOnUpdateMouseUpCheck)
				local mouseButtonClicked = GetMouseButtonClicked()
				if mouseButtonClicked=="LeftButton" or mouseButtonClicked=="RightButton" then
					MouselookStart()
				end
			end)
			
			
			if i<36 then --raid
				button:SetAttribute("*type2", "target")
				RegisterUnitWatch(button) --raid
			elseif i<40 then --party
				button:SetAttribute("*type2", "target")
				RegisterAttributeDriver(button, "state-visibility", "[@raid6,exists][@"..unit..",noexists]hide;show") --party, thx to VerzOCE for the tip about RegisterAttributeDriver/RegisterUnitWatch randomly in my stream
			elseif i<45 then --arena
				button:SetAttribute("*type2", "focus")
				RegisterUnitWatch(button)
			else
				button:SetAttribute("*type2", "target")
				RegisterUnitWatch(button)
			end
		end
		
		local arenaWidthPlusTwo = arenaWidth+2
		local arenaHeightPlusTwo = arenaHeight+2
		local arenaHeightasd = arenaHeightPlusTwo+1
		function updateArenaPositions()
			for i=1,5 do
				local unit = "arena"..i
				local button = hasuitButtonForUnit[unit]
				button:SetSize(arenaWidthPlusTwo,arenaHeightPlusTwo)
				button:SetPoint("TOP", UIParent, "CENTER", arenaX, arenaY-i*arenaHeightasd)
			end
		end
		updateArenaPositions()
	end
	
	
	
	
	
	danCurrentUnit = "player"
	danCurrentUnitGUID = hasuitPlayerGUID
	danCurrentUnitType = "group"
	danCurrentUnitTable = groupUnitFrames
	
	if groupColoredBackgroundMinimum>0 and danCurrentGroupSize>=groupColoredBackgroundMinimum then
		changeUnitTypeColorBackgrounds(true)
	else
		danSetScriptRangeMaybe()
	end
	
	hasuitUnitFrameMakeHealthBarMain()
	danPlayerFrame = danCurrentFrame
	hasuitPlayerFrame = danPlayerFrame
	danPlayerFrame.updatingColor = true
	danPlayerFrame.colorFunction = nil --works itself out for color background updating color3, other things like unit_flags will go through afterward on playerframe but setscript onupdate to nil from this and updatingColor back to true at the same time
	danPlayerFrame.priority = 0
	danPlayerFrame.number = 0
	danPlayerFrame.updated = hasuitFrameTypeUpdateCount["group"]
	
	danPlayerFrame.border:SetScript("OnEvent", function()
		danPlayerFrame:SetAlpha(1)
	end)
	
	
	danPlayerFrame.arenaStuff = {} --todo
	local arenaStuff = danPlayerFrame.arenaStuff
	for i=1,numberOfTrackedDrs do
		arenaStuff[i] = hasuitGetIcon("optionalBorder")
		local diminishIcon = arenaStuff[i]
		diminishIcon:SetParent(danPlayerFrame)
		diminishIcon:ClearAllPoints()
		diminishIcon:SetSize(23, 23)
		diminishIcon.size = 23
		diminishIcon.cooldownText:SetFontObject(hasuitCooldownTextFonts[23])
		diminishIcon:SetAlpha(0)
		diminishIcon.cooldown:SetScript("OnCooldownDone", function()
			diminishIcon:SetAlpha(0)
			diminishIcon.diminishLevel = 0
			diminishIcon.active = false
		end)
		diminishIcon.iconTexture:SetTexture(arenaDiminishTextures[i])
		diminishIcon:SetPoint("BOTTOMRIGHT", danPlayerFrame, "TOPRIGHT", -1-(i-1)*24, 1)
		diminishIcon.diminishLevel = 0
		diminishIcon.border:SetAlpha(1)
	end
	
	
	if hasuitInstanceType=="arena" then
		danHideTargetLines() --just to hide playertarget
	end
	
	
	
	C_Timer_After(0, function()
		danCurrentFrame = danPlayerFrame
		danCurrentUnit = "player"
		danEnablePowerBar2()
	end)
	hasuitUpdateGroupRosterUnsafe()
	
end)


local playerRaidUnit
do
	
	local danDoThis = hasuitDoThisGroup_Roster_UpdateAlways
	local danDoThisGroupSizeChanged = hasuitDoThisGroup_Roster_UpdateGroupSizeChanged
	local danDoThisRelevantSizes = hasuitDoThisRelevantSizes
	
	
	local targetGUID
	local lastFrames = {}
	function hasuitMakeTestGroupFrames(number)
		if hasuitInstanceType=="arena" then
			return
		end
		if number>40 then
			number = 40
		elseif number<1 then
			number = 1
		end
		danCurrentUnitType = "group"
		danCurrentUnitTable = groupUnitFrames
		
		playerRaidUnit = playerRaidUnit or "raid1"
		local actualGroupSize = GetNumGroupMembers()
		if actualGroupSize == 0 then
			actualGroupSize = 1
		end
		
		if number<actualGroupSize then
			number = actualGroupSize
		end
		
		
		if number~=hasuitGroupSize then
			hasuitGroupSize = number
			
			for i=1,#danDoThisGroupSizeChanged do
				danDoThisGroupSizeChanged[i]()
			end
			
			for i=1,#danDoThisRelevantSizes do
				local sizeTable = danDoThisRelevantSizes[i]
				local relevantSize = sizeTable[number]
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
		
		
		
		
		local updatedPlus1 = hasuitFrameTypeUpdateCount["group"]+1
		hasuitFrameTypeUpdateCount["group"] = updatedPlus1
		
		
		if targetGUID and targetGUID~=true then --made first fake frame "target" to be able to test things on a dummy easily like root/root ccbreakbar/loadon switching text around/unloading ccbreakbar on roots only etc. can test a bunch of stuff super easily this way, might be misleading for other people though because some stuff won't get tracked if spell is from player or things like that. not sure if ideal because of that? todo maybe disable for release and only use fake raid units. also probably get rid of the party broken text for tests? that'll probably just be confusing
			local unitGUID = targetGUID
			if unitGUID then
				for i=1,#groupUnitFrames do
					local frame = groupUnitFrames[i]
					if frame.unitGUID==unitGUID then 
						if frame.unit=="target" then
							frame.unitGUID = nil
						else
							hasuitUnitFrameForUnit[unitGUID] = frame
						end
					end
				end
			end
		end
		targetGUID = nil
		
		for i=1,#groupUnitFrames do
			local frame = groupUnitFrames[i]
			local unitGUID = frame.unitGUID
			if unitGUID and hasuitUnitFrameForUnit[unitGUID]==frame and UnitExists(frame.unit) then
				frame.updated = updatedPlus1
			end
		end
		
		hasuitHideInactiveFrames()
		for i=1,#lastFrames do --to skip the 10 second hide/recycle timer if calling test function multiple times. could have something that auto skips it if there are too many frames made, like if dropping a 40man raid, joining a different one with different unitguids, and repeating as many times in 10 seconds could end up with a big excess of frames that will never get used
			local frame = lastFrames[i]
			if frame.updated ~= updatedPlus1 then
				danHideUnitFrame2(frame)
				frame.specialAuraInstanceIDsRemove = {}
			end
		end
		
		lastFrames = {}
		for i=actualGroupSize+1,number do
			
			local unit
			if targetGUID then
				unit = "raid"..i
			else
				unit = "target"
				targetGUID = UnitGUID("target") or true
			end
			
			danCurrentUnit = unit
			danCurrentUnitGUID = UnitGUID(unit)
			
			hasuitUnitFrameMakeHealthBarMain()
			local frame = danCurrentFrame
			hasuitUnitFrameForUnit[unit] = frame
			frame.updatingColor = true
			frame.colorFunction = nil
			frame.priority = i+10000
			frame.number = i+10000
			frame.updated = updatedPlus1+1
			C_Timer_After(0, function()
				frame:SetAlpha(1)
			end)
			tinsert(lastFrames, frame)
		end
	end
end


local GetArenaOpponentSpec = GetArenaOpponentSpec
local GetNumArenaOpponentSpecs = GetNumArenaOpponentSpecs
do
	local fakeSpec
	local next = next
	local realGetArenaOpponentSpec = GetArenaOpponentSpec
	local function fakeGetArenaOpponentSpec(i)
		local realSpec = realGetArenaOpponentSpec(i)
		fakeSpec = next(hasuitSpecIsHealerTable, fakeSpec) or next(hasuitSpecIsHealerTable)
		return realSpec and realSpec~=0 and realSpec or fakeSpec
	end
	GetArenaOpponentSpec = fakeGetArenaOpponentSpec
	local realGetNumArenaOpponentSpecs = GetNumArenaOpponentSpecs
	local function fakeGetNumArenaOpponentSpecs()
		local realNumber = realGetNumArenaOpponentSpecs()
		return hasuitArenaTestNumber>realNumber and hasuitArenaTestNumber or realNumber
	end
	function hasuitMakeTestArenaFrames(number)
		if hasuitInstanceType=="arena" then
			return
		end
		GetNumArenaOpponentSpecs = fakeGetNumArenaOpponentSpecs
		GetArenaOpponentSpec = fakeGetArenaOpponentSpec
		if number>5 then
			number = 5
		elseif number<0 then
			number = 0
		end
		hasuitArenaTestNumber = number
		
		hasuitFrameTypeUpdateCount["arena"] = hasuitFrameTypeUpdateCount["arena"]+1
		hasuitHideInactiveFrames()
		for i=1,#arenaUnitFrames do
			local frame = arenaUnitFrames[i]
			if not UnitExists(frame.unit) then
				danHideUnitFrame2(frame)
				frame.specialAuraInstanceIDsRemove = {}
			end
		end
		
		danUpdateArenaFramesUnsafe()
		
		GetArenaOpponentSpec = realGetArenaOpponentSpec
		GetNumArenaOpponentSpecs = realGetNumArenaOpponentSpecs
	end
end















do --temporary? maybe not
	local lastEventId
	local danUnitHealAbsorbFrame = CreateFrame("Frame")
	danUnitHealAbsorbFrame:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
	danUnitHealAbsorbFrame:SetScript("OnEvent", function(_, _, unit)
		local currentEventId = GetCurrentEventID()
		if lastEventId == currentEventId then
			return
		end
		lastEventId = currentEventId
		
		
		local frame = hasuitUnitFrameForUnit[unit]
		if frame then
		
		
			local healAbsorbs = UnitGetTotalHealAbsorbs(unit)
			if healAbsorbs>0 then
				local asd = healAbsorbs*100/UnitHealthMax(unit)
				if asd>15 then
					if not frame.healAbsorbText then
						frame.healAbsorbText = frame.overAbsorbBar:CreateFontString()
						frame.healAbsorbText:SetPoint("CENTER", frame.border, "CENTER", 0, 0)
						frame.healAbsorbText:SetFont("Fonts/FRIZQT__.TTF", 16, "OUTLINE")
						frame.healAbsorbText:SetTextColor(1,0,0)
					end
					frame.healAbsorbing = true
					frame.healAbsorbText:SetText(format("%.0f", asd).."%")
				elseif frame.healAbsorbing then
					frame.healAbsorbText:SetText(format("%.0f", asd).."%")
				end
			elseif frame.healAbsorbing then
				frame.healAbsorbText:SetText("")
				frame.healAbsorbing = nil
			end
		end
	end)
end










do
	local function idkman(frame) --not sure this does anything useful. don't remember how it ended up only being in unit_phase
		danCurrentFrame = frame
		danCurrentUnit = frame.unit
		danInitialHealthAndAbsorbsFunction()
		if not frame.updatingColor then
			frame.updatingColor = true
			frame:SetScript("OnUpdate", frame.colorFunction)
		end
	end
	local lastEventId
	local danUnitPhaseFrame = CreateFrame("Frame")
	danUnitPhaseFrame:RegisterEvent("UNIT_PHASE") --bored todo clean stuff up, switch unitframes to make healthbars not the main frame
	danUnitPhaseFrame:SetScript("OnEvent", function(_, _, unit)
		local frame = hasuitUnitFrameForUnit[unit]
		if frame then
			local currentEventId = GetCurrentEventID()
			if lastEventId == currentEventId then
				return
			end
			lastEventId = currentEventId
		
			
			if frame.unitType~="arena" then
				C_Timer_After(0, function()
					idkman(frame)
				end)
				if UnitInRange(unit) then
					frame:SetAlpha(1)
				else
					frame:SetAlpha(outOfRangeAlpha)
				end
			else
				danCurrentFrame = frame
				danCurrentUnit = unit
				arenaInRange()
			end
		end
	end)
end



do
	local lastEventId
	local danUnitBigRangeFrame = CreateFrame("Frame")
	danUnitBigRangeFrame:RegisterEvent("UNIT_DISTANCE_CHECK_UPDATE")
	danUnitBigRangeFrame:SetScript("OnEvent", function(_, _, unit, inBigRange)
		danCurrentFrame = hasuitUnitFrameForUnit[unit]
		if danCurrentFrame then
			local currentEventId = GetCurrentEventID()
			if lastEventId == currentEventId then
				return
			end
			lastEventId = currentEventId
		
			
			if inBigRange then
				if danCurrentFrame.unitType~="arena" then
					if UnitInRange(unit) then
						danCurrentFrame:SetAlpha(1)
					else
						danCurrentFrame:SetAlpha(outOfRangeAlpha)
					end
				else
					danCurrentUnit = unit
					arenaInRange()
				end
			else
				danCurrentFrame:SetAlpha(outOfRangeAlpha)
			end
			
			
		end
		
		
		
	end)
end












do
	local lastEventId
	local danUnitMaxHealthFrame = CreateFrame("Frame")
	danUnitMaxHealthFrame:RegisterEvent("UNIT_MAXHEALTH") --todo maybe don't need to do anything with unit_health from these events anymore? seemed like every max health was firing a separate unit_health after, also this event seems like it fires twice on the same frame for the same unit with the same max health a ton (every time?), with different event ids
	danUnitMaxHealthFrame:SetScript("OnEvent", function(_, _, unit)
		local currentEventId = GetCurrentEventID()
		if lastEventId == currentEventId then
			return
		end
		lastEventId = currentEventId
		
		
		local frame = hasuitUnitFrameForUnit[unit]
		if frame then
			
			
			local maxHealth = UnitHealthMax(unit)
			frame.maxHealth = maxHealth
			frame:SetMinMaxValues(0, maxHealth)
			danCurrentUnitHealth = UnitHealth(unit)
			frame:SetValue(danCurrentUnitHealth)
			
			if frame.blackCount==0 then --bored todo? could make the same system as unit health for max health/absorbs but there's less of a benefit from it
				frame.colorBackground()
			end
			
			if frame.healAbsorbing then
				frame.healAbsorbText:SetText(format("%.0f", UnitGetTotalHealAbsorbs(unit)*100/maxHealth).."%")
			end
			
			if frame.dead then
				if maxHealth>=1e6 then --copied in other file ctrlf 1e6
					frame.text2:SetFormattedText("%.1fm", maxHealth/1e6)
				elseif maxHealth>=1e3 then
					frame.text2:SetFormattedText("%.0fk", maxHealth/1e3)
				else
					frame.text2:SetText(maxHealth)
				end
			end
		end
	end)
end


local danUnitDisconnectedFrame = CreateFrame("Frame")
danUnitDisconnectedFrame:RegisterEvent("UNIT_NAME_UPDATE")
danUnitDisconnectedFrame:RegisterEvent("UNIT_CONNECTION")
danUnitDisconnectedFrame:RegisterEvent("UNIT_PHASE")
danUnitDisconnectedFrame:RegisterEvent("UNIT_FLAGS")
danUnitDisconnectedFrame:RegisterEvent("UNIT_FACTION")
danUnitDisconnectedFrame:RegisterEvent("PARTY_MEMBER_DISABLE")
danUnitDisconnectedFrame:RegisterEvent("PARTY_MEMBER_ENABLE")
local function danUnitDisconnectedFunction(_, _, unit)
	local frame = hasuitUnitFrameForUnit[unit]
	if frame and not frame.updatingColor then
		frame.updatingColor = true
		frame:SetScript("OnUpdate", frame.colorFunction)
	end
end
danUnitDisconnectedFrame:SetScript("OnEvent", danUnitDisconnectedFunction)








local partyBroken
local partyBrokenTable = {}
local function partyBrokenFunction()
	if partyBroken then
		for k, v in pairs(partyBrokenTable) do
			if v.unit and v.broken then
				v.text:SetText("|cffff6f6f"..v.unit) --hasuitRed2
			end
		end
	end
end
local function partyFixedFunction()
	for k, v in pairs(partyBrokenTable) do
		if v.unit and v.broken then
			v.text:SetText("")
			v.broken = false
		end
	end
	partyBrokenTable = {}
end


function danSortGroup()
	if danCurrentGroupSize<6 then
		if danCurrentGroupSize-danCurrentPartySize>1 then
			partyBroken = true --partybroken thing could be improved
			partyFixedFunction()
			for i=2,#groupUnitFrames do
				local frame = groupUnitFrames[i]
				frame.number = i+5
				partyBrokenTable[i] = frame
				frame.broken = true
			end
		elseif partyBroken then
			partyBroken = nil
			partyFixedFunction()
		end
		if partyBroken then
			for i=1,danCurrentPartySize do
				partyBrokenTable[i] = nil
				hasuitUnitFrameForUnit["party"..i].number = i
			end
			partyBrokenFunction()
		else
			for i=1,danCurrentPartySize do
				hasuitUnitFrameForUnit["party"..i].number = i
			end
		end
		
		danPlayerFrame.number = 0
		
		sort(groupUnitFrames, function(a,b)
			return a.number<b.number
		end)
	else
		if partyBroken then
			partyBroken = nil
			partyFixedFunction()
		end
		
		danPlayerFrame.priority = 0
		
		sort(groupUnitFrames, function(a,b)
			return a.priority<b.priority
		end)
	end
end


local danCurrentArenaSpec
function danUpdateExistingUnit() --dan4
	local insert
	if danCurrentFrame.hideTimer then
		insert = true
		danCurrentFrame:Show()
		danCurrentFrame.hideTimer:Cancel()
		danCurrentFrame.hideTimer = nil
	end
	
	local oldUnitType = danCurrentFrame.unitType
	if oldUnitType~=danCurrentUnitType then
		insert = true
		if oldUnitType=="arena" then
			if danCurrentFrame.arenaSpecIcon then
				danCurrentFrame.arenaSpecIcon:SetAlpha(0)
			end
			
		elseif danCurrentUnitType=="arena" then
			if danCurrentFrame.arenaSpecIcon then
				danCurrentFrame.arenaSpecIcon:SetAlpha(arenaSpecIconAlpha)
			end
		end
		if danCurrentFrame.targetOf then
			if danCurrentUnitType~="group" then
				danCurrentFrame.targetedCountText:SetText("")
				danCurrentFrame.targetOf = nil
			end
		end
		hasuitUpdateAllUnitsForUnitType[oldUnitType]()
		danCurrentFrame.unitType = danCurrentUnitType
	end
	
	if insert then
		tinsert(danCurrentUnitTable, danCurrentFrame)
		if danCurrentUnitTable.colorBackgroundEnabled then
			if not danCurrentFrame.colorBackground then
				enableColorBackgroundForFrame()
			end
		else
			if danCurrentFrame.colorBackground then
				disableColorBackgroundForFrame()
			end
		end
	end
	
	danCurrentFrame:UnregisterEvent("UNIT_HEALTH")
	danCurrentFrame:RegisterUnitEvent("UNIT_HEALTH", danCurrentUnit)
	
	local border = danCurrentFrame.border
	border:UnregisterEvent("UNIT_IN_RANGE_UPDATE") --bored todo actually use this as intended since it's forced anyway?
	border:UnregisterEvent("UNIT_DISTANCE_CHECK_UPDATE")
	border:RegisterUnitEvent("UNIT_IN_RANGE_UPDATE", danCurrentUnit)
	border:RegisterUnitEvent("UNIT_DISTANCE_CHECK_UPDATE", danCurrentUnit)
	
	local absorbBar = danCurrentFrame.absorbBar
	absorbBar:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
	absorbBar:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", danCurrentUnit)
	
	
	local oldUnit = danCurrentFrame.unit
	if oldUnit~=danCurrentUnit and hasuitUnitFrameForUnit[oldUnit]==danCurrentFrame then
		hasuitUnitFrameForUnit[oldUnit] = nil
	end
	
	
	danCurrentFrame.unit = danCurrentUnit
	hasuitUnitFrameForUnit[danCurrentUnit] = danCurrentFrame
	
	local powerBar = danCurrentFrame.powerBar
	if powerBar then
		powerBar:UnregisterAllEvents()
		powerBar:RegisterUnitEvent("UNIT_POWER_FREQUENT", danCurrentUnit)
		powerBar:RegisterUnitEvent("UNIT_MAXPOWER", danCurrentUnit)
		powerBar:RegisterUnitEvent("UNIT_DISPLAYPOWER", danCurrentUnit)
	end
	
	danUpdateUnitSpecial[danCurrentUnitType]()
	
	
	danCurrentFrame:SetPoint("TOP", hasuitButtonForUnit[danCurrentUnit], "TOP", 0, -1)
	
end



local danUpdatingRole = true
local danUpdateArenaFramesPriority
local danUpdatingArenaFrames
do
	local danPlayerRolesAssignedFrame = CreateFrame("Frame")
	danPlayerRolesAssignedFrame:SetScript("OnEvent", function()
		danUpdatingRole = true
	end)
	danPlayerRolesAssignedFrame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
	
	local hasuitDoThisGroup_Roster_UpdateAlways = hasuitDoThisGroup_Roster_UpdateAlways
	
	local danDoThisOnUpdate = hasuitDoThisOnUpdate
	danDoThisOnUpdate(function()
		local rosterUpdateFunction = hasuitUpdateAllUnitsForUnitType["group"]
		tinsert(hasuitDoThisGroup_Roster_UpdateAlways, rosterUpdateFunction)
	end)
	
	
	function danUpdateArenaFramesPriority()
		if not danUpdatingArenaFrames then
			danUpdatingArenaFrames = true
			danDoThisOnUpdate(danUpdateArenaFramesUnsafe)
		end
	end
	
	do
		local function hasuitUpdateGroupRosterSafe()
			if not updatingGroupRoster then
				updatingGroupRoster = true
				danDoThisOnUpdate(hasuitUpdateGroupRosterUnsafe)
			end
		end
		local function danUpdateArenaFramesSafe()
			if not danUpdatingArenaFrames then
				danUpdatingArenaFrames = true
				danDoThisOnUpdate(danUpdateArenaFramesUnsafe)
			end
		end
		
		hasuitUpdateAllUnitsForUnitType = {}
		hasuitUpdateAllUnitsForUnitType["group"] = hasuitUpdateGroupRosterSafe
		hasuitUpdateAllUnitsForUnitType["arena"] = danUpdateArenaFramesSafe
	end
end


local targetOfCountActive
local danInspectNewUnitFrame

hasuitFrameTypeUpdateCount["group"] = 0
hasuitFrameTypeUpdateCount["arena"] = 10000000
danUpdateUnitSpecial = {}
danUpdateUnitSpecial["group"] = function()
	if not danCurrentFrame.made then --just an extension of the healthbar make function, does this once and stays with the frame even if unittype changes, until recycle --not sure i like it being like this though
		danCurrentFrame.cooldowns = {}
		danCurrentFrame.cooldownOptions = {}
		danCurrentFrame.cooldownPriorities = {} --bored todo only do stuff like this if it will be used?
		danCurrentFrame.specialAuras = {}
		danCurrentFrame.specialAuraInstanceIDsRemove = {}
		danUpdateClass(danCurrentFrame)
		danUpdateFrameRole2()
		
		danCurrentFrame.made = true
	else
		
		danInitialHealthAndAbsorbsFunction()
		
	end
	
	
	if targetOfCountActive then
		danCurrentFrame.targetOf = {}
	else
		if danCurrentFrame.targetOf then
			danCurrentFrame.targetedCountText:SetText("")
			danCurrentFrame.targetOf = nil
		end
	end
	
	if hasuitInstanceType=="arena" then --bored todo, should only need to check hasuitInstanceType once?, not for multiple frames each roster update, here and arenaframes
		if not hasuitHealthBarTargetLinesForUnits[danCurrentUnit] then
			danMakeHealthBarTargetLine()
		else
			hasuitHealthBarTargetLinesForUnits[danCurrentUnit].colorSet = false
		end
	end
	
	
	if not danCurrentFrame.inspected then
		danInspectNewUnitFrame(danCurrentFrame)
	end
	if UnitInRange(danCurrentUnit) then
		danCurrentFrame:SetAlpha(1)
	else
		danCurrentFrame:SetAlpha(outOfRangeAlpha)
	end
	danUnitAuraIsFullUpdate(danCurrentFrame)
	
end


local hasuitFramesInitialize = hasuitFramesInitialize
local danCleuDiminish = danCleuDiminish
local trackedDiminishSpells = hasuitTrackedDiminishSpells
tinsert(hasuitDoThisAddon_Loaded, function()
	hasuitFramesCenterSetEventType("cleu")
	local drLoadOn
	do --dr loadon
		local loadOn = {}
		local function loadOnCondition()
			local instanceType = hasuitInstanceType
			if instanceType=="none" or instanceType=="arena" or instanceType=="pvp" then --should load
				if not loadOn.shouldLoad then
					loadOn.shouldLoad = true
				end
			else --should NOT load
				if loadOn.shouldLoad~=false then
					loadOn.shouldLoad = false
				end
			end
		end
		tinsert(hasuitDoThisPlayer_Entering_WorldSkipsFirst, loadOnCondition)
		loadOnCondition() --these are redundant i think, should get rid of them when changing initialize function? or probably already could
		drLoadOn = loadOn
	end
	for drType, options in pairs(hasuitDiminishOptions) do
		arenaDiminishTextures[options["arena"]] = options["texture"]
		options[1] = danCleuDiminish
		options["loadOn"] = drLoadOn
		hasuitSetupFrameOptions = options
		local drSpellTable = trackedDiminishSpells[drType]
		for i=1,#drSpellTable do
			hasuitFramesInitialize(drSpellTable[i])
		end
	end
	numberOfTrackedDrs = #arenaDiminishTextures
end)

function danInitializeArenaSpecialIcons()
	danCurrentFrame.arenaStuff = {}
	local arenaStuff = danCurrentFrame.arenaStuff
	for i=1,numberOfTrackedDrs do
		arenaStuff[i] = hasuitGetIcon("optionalBorder")
		local diminishIcon = arenaStuff[i]
		diminishIcon:SetParent(danCurrentFrame)
		diminishIcon:ClearAllPoints()
		diminishIcon:SetSize(19, 19)
		diminishIcon.size = 19
		diminishIcon.cooldownText:SetFontObject(hasuitCooldownTextFonts[19])
		diminishIcon:SetFrameLevel(18)
		diminishIcon:SetAlpha(0)
		diminishIcon.cooldown:SetScript("OnCooldownDone", function()
			diminishIcon:SetAlpha(0)
			diminishIcon.diminishLevel = 0
			diminishIcon.active = false
		end)
		diminishIcon.iconTexture:SetTexture(arenaDiminishTextures[i])
		diminishIcon:SetPoint("BOTTOMRIGHT", danCurrentFrame, "BOTTOMRIGHT", -1-(i-1)*20, 1)
		diminishIcon.diminishLevel = 0
		diminishIcon.border:SetAlpha(1)
	end
end

function danInitializeArenaSpecIcon()
	local specIcon = danCurrentFrame.arenaSpecIcon
	if not specIcon then
		specIcon = hasuitGetIcon(true)
		danCurrentFrame.arenaSpecIcon = specIcon
	end
	specIcon:SetParent(danCurrentFrame)
	specIcon:ClearAllPoints()
	specIcon:SetSize(28, 28)
	specIcon.size = 28
	specIcon:SetFrameLevel(18)
	specIcon:SetAlpha(arenaSpecIconAlpha)
	-- local texture = select(4, GetSpecializationInfoByID(danCurrentArenaSpec))
	local texture = select(4, GetSpecializationInfoForSpecID(danCurrentArenaSpec))
	specIcon.iconTexture:SetTexture(texture)
	specIcon:SetPoint("LEFT", danCurrentFrame.border, "RIGHT", 1, 0)
	
	
	local frame = danCurrentFrame
	C_Timer_After(0, function()
		if specIcon:GetAlpha()==0 and frame.unitType=="arena" then
			specIcon:SetAlpha(arenaSpecIconAlpha) --idk, probably something to do with arena group update function being complicated
		end
	end)
end

local arenaSpecIsHealerTable = hasuitSpecIsHealerTable
function arenaInRange()
	if not hasuitArenaGatesActive and UnitInRange(danCurrentUnit) then
		danCurrentFrame:SetAlpha(1)
	else
		danCurrentFrame:SetAlpha(outOfRangeAlpha)
	end
end
danUpdateUnitSpecial["arena"] = function()
	if not danCurrentFrame.made then
		danCurrentFrame.cooldowns = {}
		danCurrentFrame.cooldownOptions = {}
		danCurrentFrame.cooldownPriorities = {}
		danCurrentFrame.specialAuras = {}
		danCurrentFrame.specialAuraInstanceIDsRemove = {}
		
		danCurrentFrame.made = true
	end
	
	
	if hasuitInstanceType=="arena" then
		if not hasuitHealthBarTargetLinesForUnits[danCurrentUnit] then
			danMakeHealthBarTargetLine()
		else
			hasuitHealthBarTargetLinesForUnits[danCurrentUnit].colorSet = false
		end
	end
	
	
	if not danCurrentFrame.arenaStuff then
		danInitializeArenaSpecialIcons()
	end
	if danCurrentArenaSpec then
		danInitializeArenaSpecIcon()
		if not danCurrentFrame.arenaSpec then
			danCurrentFrame.arenaSpec = danCurrentArenaSpec
			if not danCurrentFrame.specId then
				danAddSpecializationCooldowns(danCurrentArenaSpec)
				danCurrentFrame.specId = danCurrentArenaSpec
			end
			if arenaSpecIsHealerTable[danCurrentArenaSpec] then --events get unregistered and re-registered if powerbar already on frame in updateexistingunit right before this
				danEnablePowerBar2()
			else
				danDisablePowerBar2()
			end
			if not danCurrentFrame.unitClassSet then
				local unitClass = select(6, GetSpecializationInfoByID(danCurrentArenaSpec))
				danAddSpecializationCooldowns("general", true)
				danAddSpecializationCooldowns(unitClass, true)
				danCurrentFrame.cooldownsDisabled = nil
				danCurrentFrame.unitClass = unitClass
				danCurrentFrame.unitClassSet = true
			end
		end
		danUpdateClass(danCurrentFrame)
		danUpdateFrameRole2("skipLastHalf") --todo role stuff could be better, just added this here to give prot specs a tank icon
	else
		danUpdateClass(danCurrentFrame)
		danUpdateFrameRole2()
	end
	arenaInRange()
	danUnitAuraIsFullUpdate(danCurrentFrame)
end

do
	local unusedTextFrames = hasuitUnusedTextFrames
	local hasuitSetIconText = hasuitSetIconText
	local function recycle(icon)
		icon.basePriority = nil
		icon.spellId = nil
		if icon.specialTimer then
			icon.specialTimer:Cancel()
			icon.specialTimer = nil
		end
		if icon.alpha~=1 and icon.alpha~=0 then
			icon.iconTexture:SetDesaturated(false)
		end
		
		local textFrame = icon.textFrame
		if textFrame then
			textFrame:SetAlpha(0)
			icon.text:SetText("")
			tinsert(unusedTextFrames[textFrame.textType], textFrame)
			icon.text = nil
			icon.textFrame = nil
		end
		
		if icon.maxCharges then
			icon.charges = nil
			icon.maxCharges = nil
			icon.duration = nil
			icon.cooldown:SetAlpha(1)
		end
		
		icon.cooldownTextTimer1:Cancel()
		icon.cooldownTextTimer2:Cancel()
		icon.cooldownText:SetText("")
		
		
		icon.cooldownText:ClearAllPoints()
		icon.cooldownText:SetPoint("CENTER", icon, "CENTER", 1, 0)
		
		
		icon.recycle = nil
	end
	local function danRecycleCooldownIcon(icon)
		icon.active = false
		icon:SetAlpha(0)
		icon.cooldown:Clear()
		icon.recycle(icon)
		
		hasuitCleanController(icon.controller)
	end
	hasuitRecycleCooldownIcon = danRecycleCooldownIcon
	hasuitDoThisRandomFunctionAsd(danRecycleCooldownIcon)
	hasuitDoThisRandomFunctionAsd = nil
	local function cooldownOnCooldownDone(cooldown)
		local icon = cooldown.parentIcon
		-- icon.alpha = 1
		local charges = icon.charges
		if charges then
			if charges<icon.maxCharges then
				charges = charges+1
				icon.charges = charges
				icon.text:SetText(charges)
			end
			if charges<icon.maxCharges then
				local duration = icon.duration
				if icon.cdrLeftOver then
					duration = duration-icon.cdrLeftOver
				end
				local currentTime = GetTime()
				icon.startTime = currentTime
				icon.expirationTime = currentTime+duration
				cooldown:SetCooldown(currentTime, duration)
				
				hasuitStartCooldownTimerText(icon)
				
			else
				icon.charges = false
			end
			
			-- if charges>0 then --was centering cd text if spell cast with 0 charges, like right before the cd was going to finish and it gets -1 charges briefly
			if charges>0 and icon.priority==256 then
				charges = false
				cooldown:SetAlpha(0.4)
				icon.cooldownText:ClearAllPoints()
				icon.cooldownText:SetPoint("CENTER", icon, "CENTER", 1, 0)
			end
		end
		
		if not charges then
			icon:SetAlpha(icon.alpha)
			if icon.priority<=256 then
				icon.priority = icon.basePriority
			end
			local controller = icon.controller
			if controller.doingSomething then
				controller.doingSomething(controller) --todo some kind of reliable way to do this once after everything has happened and without waiting until the next frame?
			else
				controller.grow(controller)
			end
		end
	end
	function hasuitHypoCooldownTimerDone(icon) --todo spell school interrupted puts spells on cd
		if icon.specialTimer then
			icon.specialTimer:Cancel()
			icon.specialTimer = nil
		end
		if icon.hypoExpirationTime and icon.expirationTime and icon.expirationTime<icon.hypoExpirationTime then
			cooldownOnCooldownDone(icon.cooldown)
		end
	end
	hasuitCooldownOnCooldownDone = cooldownOnCooldownDone
	-- local cooldownsControllers = hasuitCooldownsControllers --temporary?
	function danAddSpecializationCooldowns(specId, isClassUpdate)
		for i=1,#hasuitCooldownsControllers do
			local controllerOptions = hasuitCooldownsControllers[i]
			local unitTypeStuff = controllerOptions[danCurrentUnitType]
			if unitTypeStuff then
				local specCooldowns = unitTypeStuff["specCooldowns"][specId]
				local oldSpecCooldowns = not isClassUpdate and unitTypeStuff["specCooldowns"][danCurrentFrame.specId]
				local newSpellIds = {}
				if specCooldowns then
					local controller = danCurrentFrame.controllersPairs[controllerOptions]
					if not controller then
						controller = hasuitInitializeController(danCurrentFrame, controllerOptions)
					end
					local defaultSize = unitTypeStuff["size"]
					controller.unitTypeStuff = unitTypeStuff
					for j=1,#specCooldowns do
						local cooldownOptions = specCooldowns[j]
						local priority = cooldownOptions["priority"] or cooldownOptions[danCurrentUnitType]
						if priority then
							local icon = danCurrentFrame.cooldownPriorities[priority]
							local spellId = cooldownOptions["spellId"]
							newSpellIds[spellId] = true
							if not icon then
								icon = hasuitGetIcon("trueNoReverse")
								icon:SetParent(danCurrentFrame)
								icon:ClearAllPoints()
								
								local size = cooldownOptions["size"] or defaultSize
								icon.size = size
								icon:SetSize(size, size)
								icon.cooldownText:SetFontObject(hasuitCooldownTextFonts[size])
								
								local maxCharges = cooldownOptions["charges"]
								if maxCharges then
									icon.maxCharges = maxCharges
									if maxCharges>1 then
										hasuitSetIconText(icon, 11, maxCharges)
									else
										hasuitSetIconText(icon, 11, "")
									end
								else
									
									if cooldownOptions["pvpTrinket"] then
										danCurrentFrame.cooldowns["pvpTrinket"] = icon
									else
										if cooldownOptions["specialText"] then
											hasuitSetIconText(icon, "cdProc", cooldownOptions["specialText"]) --make sure to not allow two of these until text system gets remade
										end
									end
									
									icon.cooldownText:ClearAllPoints()
									icon.cooldownText:SetPoint("BOTTOM", icon, "TOP", 1, 1)
									if cooldownOptions["isPrimary"] then --only ice block and divine shield atm
										icon.isPrimary = true
									end
									
								end
								
								local alpha = cooldownOptions["startAlpha"] or 1
								icon:SetAlpha(alpha)
								icon.alpha = alpha
								
								if alpha==1 then
									icon.priority = priority
								elseif alpha==0 then
									icon.priority = priority+800
								else
									icon.iconTexture:SetDesaturated(true)
									icon.priority = priority+450
								end
								icon.basePriority = priority
								icon.active = true
								icon.iconTexture:SetTexture(GetSpellTexture(spellId))
								icon.spellId = spellId
								icon.recycle = recycle
								
								icon.cooldown:SetScript("OnCooldownDone", cooldownOnCooldownDone)
								icon.controller = controller
								tinsert(controller.frames, icon)
								danCurrentFrame.cooldownPriorities[priority] = icon
							else
								if spellId==icon.spellId then
									local maxCharges = cooldownOptions["charges"]
									if maxCharges then
										if icon.charges then
											local charges = icon.charges+(maxCharges-icon.maxCharges)
											if charges<0 then
												icon.charges = 0
											else
												icon.charges = charges
											end
											if icon.charges>0 then
												icon:SetAlpha(1)
												icon.cooldown:SetAlpha(0.34)
												icon.priority = priority
											elseif icon.priority ~= 256 then
												icon.priority = 256
												icon:SetAlpha(0.5)
												icon.cooldown:SetAlpha(1)
												
												icon.cooldownText:ClearAllPoints()
												icon.cooldownText:SetPoint("BOTTOM", icon, "TOP", 1, 1)
											end
										end
										icon.maxCharges = maxCharges
										if maxCharges>1 then
											icon.text:SetText((icon.charges or maxCharges))
										else
											icon.text:SetText("")
										end
									end
									local alpha = cooldownOptions["startAlpha"] or 1
									
									if alpha==0 then
										icon.priority = priority+800
										icon:SetAlpha(0)
									elseif alpha<1 then
										if icon.alpha==1 then
											icon.iconTexture:SetDesaturated(true)
										end
										icon.priority = priority+450
										icon:SetAlpha(alpha)
									elseif icon.priority~=256 then
										icon:SetAlpha(alpha)
										icon.priority = priority
									end
									icon.alpha = alpha
									
									if icon.specialTimer then
										icon.specialTimer:Cancel()
										icon.specialTimer = nil
									end
								end
							end
							danCurrentFrame.cooldowns[spellId] = icon
							danCurrentFrame.cooldownOptions[spellId] = cooldownOptions
						end
					end
					hasuitSortController(controller)
				end
				if oldSpecCooldowns then
					for j=1,#oldSpecCooldowns do
						local oldSpellId = oldSpecCooldowns[j]["spellId"]
						if not newSpellIds[oldSpellId] then
							danCurrentFrame.cooldowns[oldSpellId] = nil
							danCurrentFrame.cooldownOptions[oldSpellId] = nil
						end
					end
					local priorities = {}
					for spellId, cooldownOptions in pairs(danCurrentFrame.cooldownOptions) do
						priorities[cooldownOptions["priority"] or cooldownOptions[danCurrentUnitType]] = true
					end
					for priority, icon in pairs(danCurrentFrame.cooldownPriorities) do
						if not priorities[priority] then
							if icon then
								danRecycleCooldownIcon(icon)
								priorities[priority] = true
							end
						else
							priorities[priority] = nil
						end
					end
					for priority in pairs(priorities) do
						danCurrentFrame.cooldownPriorities[priority] = nil
					end
				end
			end
		end
	end
end

function hasuitRestoreCooldowns(frame)
	if frame.cooldownsDisabled then
		frame.cooldownsDisabled = nil
		danCurrentFrame = frame
		danCurrentUnitType = frame.unitType
		if danCurrentFrame.unitRace then
			danAddSpecializationCooldowns(danCurrentFrame.unitRace, true)
		end
		if frame.unitClassSet then
			danAddSpecializationCooldowns("general", true)
			danAddSpecializationCooldowns(frame.unitClass, true)
		end
		if frame.specId then
			danAddSpecializationCooldowns(frame.specId)
		end
	end
end






local C_Timer_NewTimer = C_Timer.NewTimer
local function danPlayerSpellFrameTalentsShown()
	if PlayerSpellsFrame then
		local danPlayerSpellsFrame = PlayerSpellsFrame
		danPlayerSpellFrameTalentsShown = function()
			return danPlayerSpellsFrame:IsShown() and danPlayerSpellsFrame.TalentsFrame:IsShown()
		end
		return danPlayerSpellFrameTalentsShown()
	end
end
do
	local danInspectRegistered
	local danInspectFrame = CreateFrame("Frame")
	local NotifyInspect = NotifyInspect
	local CanInspect = CanInspect
	local function delayedNotify(frame)
		if not danInspectRegistered then
			-- hasuitDoThisEasySavedVariables("not danInspectRegistered")
			danInspectFrame:RegisterEvent("INSPECT_READY")
			danInspectRegistered = true
		end
		NotifyInspect(frame.unit) --probably only need the delay for unitcast succeeded stuff? for player spec changed event could probably not do this delay, wasn't checking that event when i needed the delay
	end
	local danInspectTimer = C_Timer_NewTimer(0,function()end)
	
	local function danInspect()
		local deleteTheseUnits
		for frame in pairs(danRequestsInspection) do
			if frame.unitType=="group" or CanInspect(frame.unit) then
				if not danInspectRegistered then
					danInspectFrame:RegisterEvent("INSPECT_READY")
					danInspectRegistered = true
				end
				if danPlayerSpellFrameTalentsShown() then
					C_Timer_After(0, function()
						delayedNotify(frame)
					end)
				else
					NotifyInspect(frame.unit)
				end
				
				break
			else
				if not deleteTheseUnits then
					deleteTheseUnits = {}
				end
				tinsert(deleteTheseUnits, frame)
			end
		end
		
		danInspectTimer:Cancel()
		if deleteTheseUnits then
			for i=1,#deleteTheseUnits do
				danRequestsInspection[deleteTheseUnits[i]] = nil
				danIsInspecting = danIsInspecting-1
			end
			if danIsInspecting~=0 then
				danInspectTimer = C_Timer_NewTimer(5, danInspect)
			end
		else
			danInspectTimer = C_Timer_NewTimer(5, danInspect)
		end
		
	end

	function danInspectNewUnitFrame(frame)
		if not danRequestsInspection[frame] then
			danRequestsInspection[frame] = true
			danIsInspecting = danIsInspecting+1
			if danIsInspecting==1 then
				danInspect()
			end
		end
	end
	hasuitInspectNewUnitFrame = danInspectNewUnitFrame
	
	
	local ClearInspectPlayer = ClearInspectPlayer
	local function danClearInspectPlayer()
		if danPlayerSpellFrameTalentsShown() then
			return
		end
		if InspectFrame and InspectFrame:IsShown() then
			return
		end
		ClearInspectPlayer()
	end
	danInspectFrame:SetScript("OnEvent", function(_,_,unitGUID)
		danCurrentFrame = hasuitUnitFrameForUnit[unitGUID]
		if danCurrentFrame and danRequestsInspection[danCurrentFrame] then
			local specId = GetInspectSpecialization(danCurrentFrame.unit)
			danCurrentFrame.inspected = true
			danRequestsInspection[danCurrentFrame] = nil
			danIsInspecting = danIsInspecting-1
			if danCurrentFrame.specId~=specId then
				if hasuitCooldownDisplayActiveGroup then
					danCurrentUnitType = danCurrentFrame.unitType
					danAddSpecializationCooldowns(specId)
				else
					danCurrentFrame.cooldownsDisabled = true
				end
				danCurrentFrame.specId = specId
			end
			if danIsInspecting==0 then
				C_Timer_After(0, danClearInspectPlayer)
			end
		end
		if danIsInspecting~=0 then
			danInspect()
		else
			danInspectFrame:UnregisterEvent("INSPECT_READY")
			danInspectRegistered = false
		end
	end)
end


do
	local lastEventId
	local danSpecFrame = CreateFrame("Frame")
	danSpecFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	danSpecFrame:SetScript("OnEvent", function(_,_,unit)
		local currentEventId = GetCurrentEventID()
		if lastEventId == currentEventId then
			return
		end
		lastEventId = currentEventId
		
		local frame = hasuitUnitFrameForUnit[unit]
		if frame then
			frame.inspected = false
			danInspectNewUnitFrame(frame)
		end
	end)
end
hasuitFramesCenterSetEventType("unitCastSucceeded")
hasuitSetupFrameOptions = {danUnitCastSucceededChangedTalents}
danUnitCastSucceededChangedTalents = nil
hasuitFramesInitialize(200749) --Activating Specialization, maybe not needed now that spec change event is being tracked, todo?
hasuitFramesInitialize(384255) --Changing Talents




local lastRaidSize = 0
local lastPartySize = 0
function danUpdateGroupUnits(groupType, number, lastNumber)
	if number<lastNumber then
		number = lastNumber
	end
	local updateCount = hasuitFrameTypeUpdateCount[danCurrentUnitType]+1
	hasuitFrameTypeUpdateCount[danCurrentUnitType] = updateCount
	for i=1, number do
		danCurrentUnit = groupType..i
		if UnitExists(danCurrentUnit) then --could use unitguid as a proxy for this? not sure about that actually since player can not exist but give a guid on login sometimes, might be better to do that though
			danCurrentUnitGUID = UnitGUID(danCurrentUnit)
			danCurrentFrame = hasuitUnitFrameForUnit[danCurrentUnitGUID]
			
			if not danCurrentFrame then
				hasuitUnitFrameMakeHealthBarMain()
			else
				if hasuitUnitFrameForUnit[danCurrentUnit]~=danCurrentFrame then --could be improved a bit but this/arena's equivalent were the hardest things in the addon to get to work right. need a good reason to try to optimize anything here more than it already is --the way it could be improved is doing something with unitguid and reducing how often danUpdateExistingUnit happens but i forget exactly. i tried before and just couldn't get it to work right that way
					if danCurrentFrame~=danPlayerFrame then
						danUpdateExistingUnit() --this whole system should be reorganized where it's easier to see everything happening to a frame? could work on that when adding more unit types like pets/fake party/fake arena(both of these in world pvp/maybe optionally bgs)/boss units/bg opponents/nameplates(? might be unrelated here)
					else
						hasuitUnitFrameForUnit[danCurrentUnit] = danCurrentFrame
						playerRaidUnit = danCurrentUnit
					end
				end
				if danUpdatingRole then
					danUpdateFrameRole2()
				end
				
				if not danCurrentFrame.updatingColor then
					danCurrentFrame.updatingColor = true
					danCurrentFrame:SetScript("OnUpdate", danCurrentFrame.colorFunction)
				end
			end
			danCurrentFrame.updated = updateCount
		else
			hasuitUnitFrameForUnit[danCurrentUnit] = nil
		end
	end
	danUpdatingRole = false
end

function danUpdateArenaFramesUnsafe()
	danUpdatingArenaFrames = false
	danCurrentUnitType = "arena"
	danCurrentUnitTable = arenaUnitFrames
	
	local updateCount = hasuitFrameTypeUpdateCount[danCurrentUnitType]+1
	hasuitFrameTypeUpdateCount[danCurrentUnitType] = updateCount
	
	local numArenaOpponents = GetNumArenaOpponentSpecs()
	if numArenaOpponents==0 then 
		numArenaOpponents = GetNumArenaOpponents()
	end
	
	changeUnitTypeColorBackgrounds(arenaColoredBackgroundMinimum>0 and numArenaOpponents>=arenaColoredBackgroundMinimum)
	
	for i=1, numArenaOpponents do
		danCurrentArenaSpec = GetArenaOpponentSpec(i)
		danCurrentUnit = "arena"..i
		if danCurrentArenaSpec and danCurrentArenaSpec~=0 or UnitExists(danCurrentUnit) then --not sure if danCurrentArenaSpec can be 0 or not, don't remember how this got there
			danCurrentUnitGUID = UnitGUID(danCurrentUnit)
			if danCurrentUnitGUID then
				danCurrentFrame = hasuitUnitFrameForUnit[danCurrentUnitGUID]
			else
				
				
				
				danCurrentFrame = hasuitUnitFrameForUnit[danCurrentUnit]
				if danCurrentFrame and danCurrentFrame.unitGUID then
					danCurrentFrame = nil
				end
				
				
				
			end
			
			if not danCurrentFrame then
				hasuitUnitFrameMakeHealthBarMain()
			else
				if hasuitUnitFrameForUnit[danCurrentUnit]~=danCurrentFrame or danCurrentFrame.arenaSpec~=danCurrentArenaSpec then
					danUpdateExistingUnit()
				end
				
				
				if not danCurrentFrame.updatingColor then
					danCurrentFrame.updatingColor = true
					danCurrentFrame:SetScript("OnUpdate", danCurrentFrame.colorFunction)
				end
				
				
			end
			danCurrentFrame.updated = updateCount
		end
	end
	
	hasuitHideInactiveFrames()
	updateTargetBorder()
end




function danUpdateOtherUnits(groupType, number, lastNumber)
	if number<lastNumber then
		number = lastNumber
	end
	for i=1, number do
		danCurrentUnit = groupType..i
		if UnitExists(danCurrentUnit) then
			hasuitUnitFrameForUnit[danCurrentUnit] = hasuitUnitFrameForUnit[UnitGUID(danCurrentUnit)]
		else
			hasuitUnitFrameForUnit[danCurrentUnit] = nil
		end
		
	end
end


function hasuitHideInactiveFrames()
	for unitType, unitTable in pairs(hasuitUnitFramesForUnitType) do
		for i=#unitTable,1,-1 do
			local frame = unitTable[i]
			if frame.unitType~=unitType then
				tremove(unitTable, i)
			elseif frame.updated ~= hasuitFrameTypeUpdateCount[unitType] then
				tremove(unitTable, i)
				frame.inspected = false
				if frame.updatingColor then
					frame.updatingColor = nil
					frame:SetScript("OnUpdate", nil)
				end
				local unit = frame.unit
				if hasuitUnitFrameForUnit[unit]==frame then
					hasuitUnitFrameForUnit[unit] = nil
				end
				frame:Hide()
				frame.hideTimer = C_Timer_NewTimer(10, function()
					if frame.updated ~= hasuitFrameTypeUpdateCount[frame.unitType] then --doesn't do anything now i think
						danHideUnitFrame2(frame)
					end
				end)
			end
		end
	end
end
local danRunAfterCombat = hasuitDoThisAfterCombat
function hasuitUpdateGroupRosterUnsafe()
	updatingGroupRoster = false
	
	danCurrentUnitType = "group"
	danCurrentUnitTable = groupUnitFrames
	
	local raid1Exists = UnitExists("raid1")
	if not raid1Exists and danUpdatingRole then
		danCurrentFrame = danPlayerFrame
		danCurrentUnit = "player"
		danUpdateFrameRole2()
	end
	
	if not raid1Exists or hasuitInstanceType=="arena" then
		danUpdateGroupUnits("party", danCurrentPartySize, lastPartySize)
		lastPartySize = danCurrentPartySize
		
		if raid1Exists then
			danUpdateOtherUnits("raid", danCurrentGroupSize, lastRaidSize)
			lastRaidSize = danCurrentGroupSize
		else
			if lastRaidSize~=0 then
				danUpdateOtherUnits("raid", 0, lastRaidSize)
				lastRaidSize = 0
			end
		end
		
	else
		danUpdateGroupUnits("raid", danCurrentGroupSize, lastRaidSize)
		danUpdateOtherUnits("party", danCurrentPartySize, lastPartySize)
		lastPartySize = danCurrentPartySize
		lastRaidSize = danCurrentGroupSize
	end
	danPlayerFrame.updated = hasuitFrameTypeUpdateCount["group"]
	danPlayerFrame:SetAlpha(1)
	local blackCount = danPlayerFrame.blackCount
	if blackCount then
		if danPlayerFrame.blackCheckRange then
			danPlayerFrame.blackCheckRange = false
			danPlayerFrame.blackCount = blackCount-1
			if blackCount==1 then --was 1
				danCurrentUnitHealth = UnitHealth(danPlayerFrame.unit)
				danPlayerFrame.colorBackground()
				tinsert(danPlayerFrame.otherUnitHealthFunctions, danPlayerFrame.colorBackground) --danGiveUnitHealthControl
			end
		end
	end
	
	hasuitHideInactiveFrames()
	
	
	for unitGUID, unit in pairs(hasuitFramesCenterNamePlateGUIDs) do --probably just coincidental that there are never problems here, forgot about making sure these always get set after all unit updates are finished (arena frames). should probably separate this from group and do it after any unit type update?/all updates are complete and not spam it for no reason? todo
		hasuitUnitFrameForUnit[unit] = hasuitUnitFrameForUnit[unitGUID]
	end
	
	local unitGUID = UnitGUID("target")
	if unitGUID then
		hasuitUnitFrameForUnit["target"] = hasuitUnitFrameForUnit[unitGUID]
	else
		hasuitUnitFrameForUnit["target"] = nil
	end
	
	local unitGUID = UnitGUID("focus")
	if unitGUID then
		hasuitUnitFrameForUnit["focus"] = hasuitUnitFrameForUnit[unitGUID]
	else
		hasuitUnitFrameForUnit["focus"] = nil
	end
	
	local unitGUID = UnitGUID("mouseover")
	if unitGUID then
		hasuitUnitFrameForUnit["mouseover"] = hasuitUnitFrameForUnit[unitGUID]
	else
		hasuitUnitFrameForUnit["mouseover"] = nil
	end
	
	local unitGUID = UnitGUID("softfriend")
	if unitGUID then
		hasuitUnitFrameForUnit["softfriend"] = hasuitUnitFrameForUnit[unitGUID]
	else
		hasuitUnitFrameForUnit["softfriend"] = nil
	end
	
	local unitGUID = UnitGUID("softenemy")
	if unitGUID then
		hasuitUnitFrameForUnit["softenemy"] = hasuitUnitFrameForUnit[unitGUID]
	else
		hasuitUnitFrameForUnit["softenemy"] = nil
	end
	
	
	danSortGroup()
	
	
	if not InCombatLockdown() then
		danUpdateGroupPositionsButtons()
	elseif not updatingGroupPositions then
		updatingGroupPositions = true
		danRunAfterCombat(danUpdateGroupPositionsButtons)
	end
	
	updateTargetBorder() --todo different color on blue map?
end


do
	local partyWasBroken
	local lastRaidSize2 = 0
	function danUpdateGroupPositionsButtons() --should handle people leaving well? but not joining, todo? can look broken if group size changes size/columns in combat atm but probably rare. should never make game unplayable even when that happens?
		updatingGroupPositions = false
		if danCurrentGroupSize<=5 then
			for i=1, #groupUnitFrames do
				danCurrentFrame = groupUnitFrames[i]
				danSetSize()
				
				local button = hasuitButtonForUnit[danCurrentFrame.unit]
				button:SetSize(danCurrentUnitFrameWidthPlus2,danCurrentUnitFrameHeightPlus2)
				button:SetPoint("TOP", UIParent, "CENTER", partyX, partyY-i*danCurrentUnitFrameHeightPlus3)
				
				local macroTargetFrame = _G["d"..i.."-1"] --danclick
				if macroTargetFrame then
					macroTargetFrame:SetAttribute("unit", danCurrentFrame.unit)
				end
			end
			if partyBroken then
				for i=#groupUnitFrames+1,lastRaidSize2 do --maybe should just make it so if group is broken it disregards party units, problem is i want people to be able to use the built in binds for targeting party if size<6 for whatever party units exist
					hasuitButtonForUnit["raid"..i]:SetPoint("TOP", UIParent, "CENTER", 0, -10000)
				end
				partyWasBroken = true
				lastRaidSize2 = danCurrentGroupSize
				
				
			else
				if partyWasBroken then
					local dan = lastRaidSize2>=5 and lastRaidSize2 or 5
					for i=1,dan do
						hasuitButtonForUnit["raid"..i]:SetPoint("TOP", UIParent, "CENTER", 0, -10000) --todo
					end
					partyWasBroken = nil
					lastRaidSize2 = 0
				else
					if lastRaidSize2~=0 then
						for i=1,lastRaidSize2 do
							hasuitButtonForUnit["raid"..i]:SetPoint("TOP", UIParent, "CENTER", 0, -10000) --todo
						end
						lastRaidSize2 = 0
					end
				end
			end
			
			
		else
			
			local maxColumnsMinus1 = numColumnsForGroupSize[danCurrentGroupSize]-1
			local startX = raidX+floor(-danCurrentUnitFrameWidthPlus3*maxColumnsMinus1/2)+1

			
			local numGroupFrames = #groupUnitFrames
			
			local row=0
			local i=1
			while i<=numGroupFrames do
				for column=0, maxColumnsMinus1 do
					danCurrentFrame = groupUnitFrames[i]
					if danCurrentFrame then
						i = i + 1
						danSetSize()
						local y=raidY-danCurrentUnitFrameHeightPlus3*row
						local x=startX+danCurrentUnitFrameWidthPlus3*column
						
						local button = hasuitButtonForUnit[danCurrentFrame.unit]
						button:SetSize(danCurrentUnitFrameWidthPlus2,danCurrentUnitFrameHeightPlus2)
						button:SetPoint("TOP", UIParent, "CENTER", x, y)
						
						local macroTargetFrame = _G["d"..column+1 .."-"..row+1] --danclick
						if macroTargetFrame then
							macroTargetFrame:SetAttribute("unit", danCurrentFrame.unit)
						end
						
					else
						break
					end
				end
				row = row+1
			end
			
			local button = hasuitButtonForUnit[playerRaidUnit]
			button:SetSize(danCurrentUnitFrameWidthPlus2,danCurrentUnitFrameHeightPlus2)
			button:SetPoint("TOP", UIParent, "CENTER", startX-danCurrentUnitFrameWidthPlus3, raidYForPlayerRaidUnit-danCurrentUnitFrameHeightPlus3)
			
			for i=i,lastRaidSize2 do
				hasuitButtonForUnit["raid"..i]:SetPoint("TOP", UIParent, "CENTER", 0, -10000) --todo, just shoving out of the way for now
			end
			lastRaidSize2 = danCurrentGroupSize
			
			partyWasBroken = nil
		end
	end
end




do
	local targetCountBruteForceTicker
	local C_Timer_NewTicker = C_Timer.NewTicker
	local UnitIsPlayer = UnitIsPlayer
	local UnitGUID = UnitGUID
	local UnitReaction = UnitReaction
	local function danUpdateAllFramesTargetCountBruteForce() --todo make something cleaner/based on unit_target, big thing
		for sourceUnitGUID, unit in pairs(hasuitFramesCenterNamePlateGUIDs) do
			local currentReaction = UnitReaction("player", unit)
			if currentReaction and currentReaction<5 then
				local unitTargetGUID = UnitGUID(unit.."target")
				if unitTargetGUID then
					local frame = hasuitUnitFrameForUnit[unitTargetGUID]
					if frame then
						frame.targetOf[sourceUnitGUID] = UnitIsPlayer(unit)
					end
				end
			end
		end
		local currentReaction = UnitReaction("player", "target")
		if currentReaction and currentReaction<5 then
			local unitTargetGUID = UnitGUID("targettarget")
			if unitTargetGUID then
				local frame = hasuitUnitFrameForUnit[unitTargetGUID]
				if frame then
					frame.targetOf[UnitGUID("target")] = UnitIsPlayer("target")
				end
			end
		end
		local currentReaction = UnitReaction("player", "focus")
		if currentReaction and currentReaction<5 then
			local unitTargetGUID = UnitGUID("focustarget")
			if unitTargetGUID then
				local frame = hasuitUnitFrameForUnit[unitTargetGUID]
				if frame then
					frame.targetOf[UnitGUID("focus")] = UnitIsPlayer("focus")
				end
			end
		end
		local currentReaction = UnitReaction("player", "mouseover")
		if currentReaction and currentReaction<5 then
			local unitTargetGUID = UnitGUID("mouseovertarget")
			if unitTargetGUID then
				local frame = hasuitUnitFrameForUnit[unitTargetGUID]
				if frame then
					frame.targetOf[UnitGUID("mouseover")] = UnitIsPlayer("mouseover")
				end
			end
		end
		local groupUnitFrames = groupUnitFrames
		for i=1,#groupUnitFrames do
			local unit = groupUnitFrames[i].unit.."target"
			local currentReaction = UnitReaction("player", unit)
			if currentReaction and currentReaction<5 then
				local unitTargetGUID = UnitGUID(unit.."target")
				if unitTargetGUID then
					local frame = hasuitUnitFrameForUnit[unitTargetGUID]
					if frame then
						frame.targetOf[UnitGUID(unit)] = UnitIsPlayer(unit)
					end
				end
			end
		end
		
		for i=1,#groupUnitFrames do
			local frame = groupUnitFrames[i]
			local targetedCountPlayer = 0
			local targetedCountNpc = 0
			for sourceUnitGUID, unitIsPlayer in pairs(frame.targetOf) do
				if unitIsPlayer then
					targetedCountPlayer = targetedCountPlayer+1
				else
					targetedCountNpc = targetedCountNpc+1
				end
			end
			if targetedCountPlayer~=0 then
				-- if targetedCountPlayer>3 then
					-- frame.targetedCountText:SetTextColor(1,0.2,0)
				-- elseif targetedCountPlayer==3 then
					-- frame.targetedCountText:SetTextColor(1,0.433,0)
				-- elseif targetedCountPlayer==2 then
					-- frame.targetedCountText:SetTextColor(1,0.667,0)
				-- elseif targetedCountPlayer==1 then
					-- frame.targetedCountText:SetTextColor(1,0.9,0)
				-- end
				if targetedCountPlayer>5 then --not sure i like the color changing here. maybe just do white text and ignore non-player in pvp instances/do something that makes sense in open world
					frame.targetedCountText:SetTextColor(1,0.2,0)
				elseif targetedCountPlayer==5 then
					frame.targetedCountText:SetTextColor(1,0.3,0)
				elseif targetedCountPlayer==4 then
					frame.targetedCountText:SetTextColor(1,0.5,0)
				elseif targetedCountPlayer==3 then
					frame.targetedCountText:SetTextColor(1,0.75,0)
				elseif targetedCountPlayer==2 then
					frame.targetedCountText:SetTextColor(0.75,1,0)
				elseif targetedCountPlayer==1 then
					frame.targetedCountText:SetTextColor(0,1,0)
				end
				frame.targetedCountText:SetText(targetedCountPlayer)
			elseif targetedCountNpc~=0 then
				frame.targetedCountText:SetTextColor(1,1,1)
				frame.targetedCountText:SetText(targetedCountNpc)
			else
				frame.targetedCountText:SetText("")
			end
			frame.targetOf = {}
		end
	end
	local function seeIfTargetCountBruteForceShouldLoad()
		if not targetCountBruteForceTicker then
			if hasuitInstanceType~="arena" then
				targetOfCountActive = true
				targetCountBruteForceTicker = C_Timer_NewTicker(0.15, danUpdateAllFramesTargetCountBruteForce)
				local groupUnitFrames = groupUnitFrames
				for i=1,#groupUnitFrames do
					groupUnitFrames[i].targetOf = {}
				end
			end
			
		else
			if hasuitInstanceType=="arena" then
				targetOfCountActive = false
				targetCountBruteForceTicker:Cancel()
				targetCountBruteForceTicker = nil
				local groupUnitFrames = groupUnitFrames
				for i=1,#groupUnitFrames do
					local frame = groupUnitFrames[i]
					frame.targetedCountText:SetText("")
					frame.targetOf = nil
				end
			end
			
		end
	end
	tinsert(hasuitDoThisPlayer_Login, function()
		if true then --todo option to disable? not sure it's even worth the space in options but it would probably make the addon use 1/3rd cpu/memory in rbgs
			seeIfTargetCountBruteForceShouldLoad()
			tinsert(hasuitDoThisPlayer_Entering_WorldSkipsFirst, seeIfTargetCountBruteForceShouldLoad)
		end
	end)
end


















local firstSeen
local function delayedGatesFunction()
	if not firstSeen then
		firstSeen = true
		local numArenaOpponents = GetNumArenaOpponentSpecs()
		if numArenaOpponents==0 then 
			numArenaOpponents = GetNumArenaOpponents()
		end
		for i=1, numArenaOpponents do
			if not UnitIsVisible("arena"..i) then
				local frame = hasuitUnitFrameForUnit["arena"..i]
				frame.text:SetText("stealth")
			end
		end
	end
end
local function gatesOpeningFunction()
	if hasuitArenaGatesActive~=false then
		hasuitArenaGatesActive = false
		firstSeen = false
		C_Timer_After(0.5, delayedGatesFunction)
		
		local numArenaOpponents = GetNumArenaOpponentSpecs() --bored todo
		if numArenaOpponents==0 then 
			numArenaOpponents = GetNumArenaOpponents() --^
		end
		for i=1, numArenaOpponents do
			local frame = hasuitUnitFrameForUnit["arena"..i]
			if frame then
				local icon = frame.cooldowns and frame.cooldowns["pvpTrinket"]
				if icon and icon.spellId~=0 then
					icon:SetAlpha(0)
				end
			else
				C_Timer_After(0, function()
					local icon = frame.cooldowns and frame.cooldowns["pvpTrinket"]
					if icon and icon.spellId~=0 then
						icon:SetAlpha(0)
					end
				end)
			end
		end
	end
end


danArenaUpdateFrame = CreateFrame("Frame")
local tempTrackedArenaUnits = { --todo
	["arena1"] = true,
	["arena2"] = true,
	["arena3"] = true,
	["arena4"] = true,
	["arena5"] = true,
}
local function tempHideArenaStuff(arenaStuff)
	local arenaStuff = danCurrentFrame.arenaStuff
	for i=#arenaStuff,1,-1 do
		local diminishIcon = arenaStuff[i]
		diminishIcon.diminishLevel = 0
		diminishIcon:SetAlpha(0)
		
		diminishIcon.cooldownTextTimer1:Cancel()
		diminishIcon.cooldownTextTimer2:Cancel()
		
		diminishIcon.cooldown:Clear()
	end
end
local danRefreshFramesInShuffle
do
	local notDead = hasuitNotDead
	hasuitNotDead = nil
	function danRefreshFramesInShuffle()
		-- danPrint("danRefreshFramesInShuffle")
		danCurrentUnitType = "group"
		for i=#groupUnitFrames,1,-1 do
			danCurrentFrame = groupUnitFrames[i]
			danCurrentUnit = danCurrentFrame.unit
			-- danCurrentUnitGUID = UnitGUID(danCurrentUnit)
			danInitialHealthAndAbsorbsFunction()
			if danCurrentFrame.dead then
				notDead(danCurrentFrame)
			end
			if danCurrentFrame.powerBar then
				danFullPowerUpdate(danCurrentFrame.powerBar, danCurrentUnit)
			end
			danCurrentFrame:SetAlpha(1)
			if danCurrentFrame.arenaStuff then
				tempHideArenaStuff()
			end
			if danCurrentFrame.text:GetText()=="unseen" then --rare, happened when shuffle round ended and someone was in a shadowy duel
				danCurrentFrame.text:SetText("")
			end
			
			hasuitResetCooldowns(danCurrentFrame)
			
			
			
			
		end
		for i=#arenaUnitFrames,1,-1 do
			danCurrentFrame = arenaUnitFrames[i]
			danCurrentFrame.seen = false
			local _, maxValue = danCurrentFrame:GetMinMaxValues()
			danCurrentFrame:SetAlpha(outOfRangeAlpha)
			danCurrentFrame:SetValue(maxValue)
			if danCurrentFrame.dead then
				notDead(danCurrentFrame)
			end
			tempHideArenaStuff()
			if danCurrentFrame.powerBar then
				if danCurrentFrame.unitClass=="DEATHKNIGHT" then
					danDisablePowerBar2()
				else
					danCurrentFrame.powerBar:SetStatusBarColor(0, 0, 1)
				end
			end
			
			hasuitResetCooldowns(danCurrentFrame)
			
			
		end
		for _, line in pairs(hasuitHealthBarTargetLinesForUnits) do
			if line.oldOtherUnitHealthFunctionsLines then
				line:SetAlpha(0)
				line:UnregisterEvent("UNIT_MAXHEALTH")
				danRemoveUnitHealthControlNotSafe(line.oldOtherUnitHealthFunctionsLines, line.healthFunctionLines)
				line.oldOtherUnitHealthFunctionsLines = nil
			end
		end
	end
end


local function arenaUnitSeen()
	if firstSeen==false then
		delayedGatesFunction()
	end
	danInitialHealthAndAbsorbsFunction()
	if danCurrentFrame.powerBar then
		danFullPowerUpdate(danCurrentFrame.powerBar, danCurrentUnit)
	end
	if not danCurrentFrame.unitGUID and not hasuitArenaGatesActive and danCurrentUnitGUID then
		danCurrentFrame.unitGUID = danCurrentUnitGUID
		hasuitUnitFrameForUnit[danCurrentUnitGUID] = danCurrentFrame
	end
	if not danCurrentFrame.seen then
		danCurrentFrame.seen = true
		if not danCurrentFrame.unitRace then --todo
			local _, race = UnitRace(danCurrentUnit)
			if race and hasuitTrackedRaceCooldowns[race] then
				danCurrentFrame.unitRace = race
				danCurrentUnitType = "arena"
				danAddSpecializationCooldowns(race, true)
			end
		end
		danUnitDisconnectedFunction(_, _, danCurrentUnit)
	end
end

danArenaUpdateFrame:RegisterEvent("PVP_MATCH_STATE_CHANGED")
danArenaUpdateFrame:RegisterEvent("PVP_MATCH_INACTIVE") --leaving a skirmish didn't do PVP_MATCH_STATE_CHANGED, and PVP_MATCH_INACTIVE happened after loading screen enabled
danArenaUpdateFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
function updateArena(_, event, arg1, arg2) --bored todo this should be remade, one of the few things that survived from UnitFrames1
	if event=="PLAYER_ENTERING_BATTLEGROUND" then --fixing/avoiding potential problems with an arena frame with the wrong class getting used, can happen if frames fail to hide like a wargame that ended 3v1 in the starting gates and then the 1 frame persisted and caused the next game to show 2 ferals when it should've been 1 feral 1 pally
		if #arenaUnitFrames~=0 then
			hasuitFrameTypeUpdateCount["arena"] = hasuitFrameTypeUpdateCount["arena"]+1
			hasuitHideInactiveFrames()
		end
	end
	if event=="ARENA_OPPONENT_UPDATE" then
		if tempTrackedArenaUnits[arg1] then
			if arg2=="seen" then --unstealth or hunter coming back from feign(/resurrect?)
				danCurrentFrame = hasuitUnitFrameForUnit[arg1]
				if not danCurrentFrame then 
					danUpdateArenaFramesPriority()
				else
					danCurrentUnit = arg1
					danCurrentUnitGUID = UnitGUID(arg1)
					arenaUnitSeen()
					arenaInRange()
					healthBarLineOnEvent(hasuitHealthBarTargetLinesForUnits[arg1], "UNIT_TARGET", arg1)
					danCurrentFrame.text:SetText("")
				end
			elseif arg2=="unseen" then --stealth or hunter feign (or death?) --is this reliable? didn't think it used to be
				danCurrentFrame = hasuitUnitFrameForUnit[arg1]
				if not danCurrentFrame then 
					danUpdateArenaFramesPriority()
				else
					if not danCurrentFrame.dead then
						danCurrentFrame.text:SetText("unseen")
					end
					danCurrentFrame:SetAlpha(outOfRangeAlpha)
				end
			elseif arg2=="destroyed" then --left the arena
				danCurrentFrame = hasuitUnitFrameForUnit[arg1]
				if danCurrentFrame then
					danCurrentFrame:SetAlpha(outOfRangeAlpha)
					danCurrentFrame.text:SetText("left")
				end
			end
		end
	elseif event=="ARENA_PREP_OPPONENT_SPECIALIZATIONS" and hasuitArenaGatesActive then
		local numArenaOpponents = GetNumArenaOpponentSpecs()
		if numArenaOpponents==0 then 
			numArenaOpponents = GetNumArenaOpponents()
		end
		for i=1, numArenaOpponents do
			if not hasuitUnitFrameForUnit["arena"..i] then
				danUpdateArenaFramesPriority()
				break
			end
		end
		
	elseif event=="PVP_MATCH_STATE_CHANGED" or event=="PLAYER_ENTERING_BATTLEGROUND" or event=="PVP_MATCH_INACTIVE" then
		if hasuitInstanceType=="arena" then
			local state = C_PvP.GetActiveMatchState()
			if state==2 then --starting gates
				if hasuitArenaGatesActive~=nil then
					C_Timer_After(3, danRefreshFramesInShuffle)
				end
			elseif state==5 or event=="PVP_MATCH_INACTIVE" then
				if hasuitArenaGatesActive~=nil then
					hasuitArenaGatesActive = nil
					danArenaUpdateFrame:RegisterEvent("LOADING_SCREEN_ENABLED")
					danArenaUpdateFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
				end
				return
			end
			if hasuitArenaGatesActive==nil then
				danArenaUpdateFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
				danUpdateArenaFramesPriority()
			end
			if state==3 then --Engaged
				danArenaUpdateFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
				gatesOpeningFunction()
			else
				danArenaUpdateFrame:UnregisterEvent("ARENA_OPPONENT_UPDATE")
				hasuitArenaGatesActive = true
			end
		end
		
	elseif event=="LOADING_SCREEN_ENABLED" or event=="LOADING_SCREEN_DISABLED" then --arena ended
		firstSeen = nil
		hasuitFrameTypeUpdateCount["arena"] = hasuitFrameTypeUpdateCount["arena"]+1
		-- for i=1,#arenaUnitFrames do --not sure this is needed anymore
			-- hasuitUnitFrameForUnit[arenaUnitFrames[i].unit] = nil
			-- hasuitUnitFrameForUnit["arena"..i] = nil
		-- end
		hasuitHideInactiveFrames() --shouldn't need to go through every unit type table here? todo
		
		danHideTargetLines()
		
		danArenaUpdateFrame:UnregisterEvent("LOADING_SCREEN_ENABLED")
		danArenaUpdateFrame:UnregisterEvent("LOADING_SCREEN_DISABLED")
		danArenaUpdateFrame:UnregisterEvent("ARENA_OPPONENT_UPDATE")
		danArenaUpdateFrame:UnregisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
		
	end
end
danArenaUpdateFrame:SetScript("OnEvent", updateArena)










do
	local function danInspectAllGroup2() --not sure this is needed for anyone but player but i assume it'd work the same way. spec can change from entering/leaving group instance. i haven't looked closely at the events when this happens but the normal ones don't fire, ACTIVE_PLAYER_SPECIALIZATION_CHANGED/SPECIALIZATION_CHANGE_CAST_FAILED didn't help
		for i=1,#groupUnitFrames do
			local frame = groupUnitFrames[i]
			frame.inspected = false
			danInspectNewUnitFrame(frame)
		end
	end
	local function danInspectAllGroup()
		C_Timer_After(0, danInspectAllGroup2)
	end
	tinsert(hasuitDoThisPlayer_Entering_WorldSkipsFirst, function()
		danPlayerFrame:SetAlpha(1)
		updateTargetBorder()
		C_Timer_After(0, danInspectAllGroup)
		
		local blackCount = danPlayerFrame.blackCount
		if blackCount then
			if danPlayerFrame.blackCheckRange then
				danPlayerFrame.blackCheckRange = false
				danPlayerFrame.blackCount = blackCount-1
				if blackCount==1 then --was 1
					danCurrentUnitHealth = UnitHealth(danPlayerFrame.unit)
					danPlayerFrame.colorBackground()
					tinsert(danPlayerFrame.otherUnitHealthFunctions, danPlayerFrame.colorBackground) --danGiveUnitHealthControl
				end
			end
		end
	end)
end

