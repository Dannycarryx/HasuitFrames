
local hasuitUnitFrameForUnit = hasuitUnitFrameForUnit
local groupUnitFrames = hasuitUnitFramesForUnitType["group"]
local arenaUnitFrames = hasuitUnitFramesForUnitType["arena"]


local hasuitPlayerGUID = hasuitPlayerGUID

local danCurrentIcon
local danCurrentController
local danCurrentFrame --after a bit of testing i realized that setting a file wide local variable and then having multiple functions use it one after another without passing it as an argument is just worse than passing a variable around multiple times from one function to another. The entire addon was made with that assumption that passing a variable around multiple times to different functions was creating a new thing every time for no reason but ya idk how it actually works. it's still a good way to do cleu though according to the test i did. also probably good for unit_aura added/updated/removed. not sure if good for anything else, needs something where a variable gets set but may or may not be needed, but if variable will always get used in the function it should just be an arg
local danCurrentAura --oh well it gives the addon character

local danGetIcon
local danCooldownDoneRecycle

local unusedIcons = {}
hasuitUnusedIcons = unusedIcons

local danCleanController
local danSortController
local danAddToController

local iconFramesCreated = 0
local danBackdrop

local danCurrentFrameOptions
local danCurrentFrameOptionsCommon
local removedAuraSharedFunction
local updatedAuraSharedFunction

local danUpdateAurasForFrame
-- danSort
-- danSortExpirationTime
-- normalGrow
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID

-- local setmetatable = setmetatable 
local pairs = pairs
local type = type
local select = select
local format = format
-- local tostring = tostring
-- local tinsert = table.insert --is this any different than tinsert = tinsert? probably slightly worse actually
local tinsert = tinsert
local tremove = table.remove
local sort = table.sort
-- local tconcat = table.concat

local C_Timer_After = C_Timer.After
local C_Timer_NewTimer = C_Timer.NewTimer

local GetSpellName = C_Spell.GetSpellName
local GetSpellTexture = C_Spell.GetSpellTexture
local CreateFrame = CreateFrame
local GetTime = GetTime
--GetTickTime?
local GetCurrentEventID = GetCurrentEventID
local GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
local GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex
local IsInInstance = IsInInstance
-- local UnitPlayerControlled = UnitPlayerControlled

local initialize = hasuitFramesInitialize
local hasuitFramesCenterSetEventType = hasuitFramesCenterSetEventType
local hasuitDoThisAddon_Loaded = hasuitDoThisAddon_Loaded


local danFileName = "HasuitFrames.lua"
local danPrint = function()end
local danPrintPurple = danPrint
local danPrintPurple2 = danPrint
local danPrintTeal = danPrint
local danPrintTeal2 = danPrint

-- C_Timer.After(0, function()
	-- danPrint = hasuitTraceGetDanPrintFunction(hasuitGreen2, hasuitGreen2, false, danFileName)
	-- danPrintPurple = hasuitTraceGetDanPrintFunction(hasuitPurple, hasuitPurple, false, danFileName)
	-- danPrintPurple2 = hasuitTraceGetDanPrintFunction(hasuitPurple2, hasuitPurple2, false, danFileName)
	-- danPrintTeal = hasuitTraceGetDanPrintFunction(hasuitTeal, hasuitTeal, false, danFileName)
	-- danPrintTeal2 = hasuitTraceGetDanPrintFunction(hasuitTeal2, hasuitTeal2, false, danFileName)
-- end)






local danGeneralCleuFrameSetScriptOnEvent
local danGetHasuitCleuSpellIdFunctions

local d1anCleuTimestamp, d2anCleuSubevent, d3anCleuHideCaster, d4anCleuSourceGuid, d5anCleuSourceName, d6anCleuSourceFlags, d7anCleuSourceRaidFlags, d8anCleuDestGuid, d9anCleuDestName, 
d10anCleuDestFlags, d11anCleuDestRaidFlags, d12anCleuSpellId, d13anCleuSpellName, d14anCleuSpellSchool, d15anCleuOther, d16anCleuOther, d17anCleuOther --these were originally all global and it worked well scattering functions all over. made sense to just put all the cleu functions in this file and make these local though
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

do
	local hasuitCleuSpellIdFunctions = {}
	hasuitFramesCenterAddToAllTable(hasuitCleuSpellIdFunctions, "cleu")
	local hasuitGeneralCleuFrame = CreateFrame("Frame")
	hasuitGeneralCleuFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	local function hasuitGeneralCleuFrameFunction()
		d1anCleuTimestamp, d2anCleuSubevent, d3anCleuHideCaster, d4anCleuSourceGuid, d5anCleuSourceName, d6anCleuSourceFlags, d7anCleuSourceRaidFlags, d8anCleuDestGuid, d9anCleuDestName, 
		d10anCleuDestFlags, d11anCleuDestRaidFlags, d12anCleuSpellId, d13anCleuSpellName, d14anCleuSpellSchool, d15anCleuOther, d16anCleuOther, d17anCleuOther = CombatLogGetCurrentEventInfo()
		
		
		local stuff = hasuitCleuSpellIdFunctions[d12anCleuSpellId] or hasuitCleuSpellIdFunctions[d13anCleuSpellName] --be careful to not initialize a spellid and a spellname for the same spell
		if stuff then
			for i=1, #stuff do 
				danCurrentFrameOptions = stuff[i]
				danCurrentFrameOptions[1]()
			end
		end
	end
	-- hasuitGeneralCleuFrame:SetScript("OnEvent", function()
		-- hasuitLoginTimestamp = CombatLogGetCurrentEventInfo()+hasuitLoginTime-GetTime()
		-- hasuitGeneralCleuFrameFunction()
		-- hasuitGeneralCleuFrame:SetScript("OnEvent", hasuitGeneralCleuFrameFunction)
	-- end)
	function danGeneralCleuFrameSetScriptOnEvent(pveCleuFunc)
		hasuitGeneralCleuFrame:SetScript("OnEvent", pveCleuFunc or hasuitGeneralCleuFrameFunction)
	end
	function danGetHasuitCleuSpellIdFunctions()
		return hasuitCleuSpellIdFunctions
	end
end


function hasuitGetD2anCleuSubevent() --this setup is probably not the way to go? should probably have people's private addon have its own cleu frame? and keep all relevant functions for the main addon in the same file with the local variables
	return d2anCleuSubevent
end
function hasuitGetD4anCleuSourceGuid()
	return d4anCleuSourceGuid
end
function hasuitGetD12anCleuSpellId()
	return d12anCleuSpellId
end






local pveAuraOptions
local pveAuraOptionsIsBossAura

local danCurrentUnit
local danCurrentEvent
local danAuraEventActive

local hasuitUnitAuraFunctions = {}
hasuitFramesCenterAddToAllTable(hasuitUnitAuraFunctions, "aura")


do --pve stuff, todo put debuffs that player can dispel at a higher priority
	
	local trackedPveSubevents = {["SPELL_AURA_APPLIED"]={},["SPELL_CAST_SUCCESS"]={},["SPELL_CAST_START"]={},["SPELL_EMPOWER_START"]={}}
	local hasuitCleuSpellIdFunctionsPve = danGetHasuitCleuSpellIdFunctions()
	danGetHasuitCleuSpellIdFunctions = nil
	
	local pveAuraOptionsUnknownType
	local cleuINCOptions
	local unitCastOptions
	
	local isChanneled
	local band = bit.band
	local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
	local COMBATLOG_OBJECT_CONTROL_MASK = COMBATLOG_OBJECT_CONTROL_MASK
	local function pveCleuFunc() --seems to work pretty well? weird though. example 434830 is coded so that player is the source of the cast for unit_aura and unit_spellcast_succeeded but source/dest are empty strings on cleu success and empty string for source/normal dest for spell_aura_applied
		d1anCleuTimestamp, d2anCleuSubevent, d3anCleuHideCaster, d4anCleuSourceGuid, d5anCleuSourceName, d6anCleuSourceFlags, d7anCleuSourceRaidFlags, d8anCleuDestGuid, d9anCleuDestName, 
		d10anCleuDestFlags, d11anCleuDestRaidFlags, d12anCleuSpellId, d13anCleuSpellName, d14anCleuSpellSchool, d15anCleuOther, d16anCleuOther, d17anCleuOther = CombatLogGetCurrentEventInfo()
		
		
		local stuff = hasuitCleuSpellIdFunctionsPve[d12anCleuSpellId] or hasuitCleuSpellIdFunctionsPve[d13anCleuSpellName]
		if stuff then
			for i=1, #stuff do 
				danCurrentFrameOptions = stuff[i]
				danCurrentFrameOptions[1]()
			end
		end
		
		local trackedPveSpells = trackedPveSubevents[d2anCleuSubevent]
		if trackedPveSpells and not trackedPveSpells[d12anCleuSpellId] then
			if band(d6anCleuSourceFlags, COMBATLOG_OBJECT_CONTROL_MASK)==COMBATLOG_OBJECT_CONTROL_PLAYER then
				-- if d4anCleuSourceGuid=="" then
					-- danPrintBig("dan1", d12anCleuSpellId, d13anCleuSpellName, d14anCleuSpellSchool, d15anCleuOther, d16anCleuOther, d17anCleuOther)
				-- end
				trackedPveSpells[d12anCleuSpellId] = true
			else
				
				if d8anCleuDestGuid=="" then
					danCurrentUnit = hasuitFramesCenterNamePlateGUIDs[d4anCleuSourceGuid] --todo boss units/target/focus? won't work at all for someone with nameplates disabled although who would play seriously with no nameplates? todo recommend nameplates if they aren't enabled probably
					if danCurrentUnit then
						if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
							if select(8, UnitChannelInfo(danCurrentUnit))==d12anCleuSpellId then
								isChanneled = true
								d8anCleuDestGuid = UnitGUID(danCurrentUnit.."target") or ""
							else
								isChanneled = false
							end
						else
							d8anCleuDestGuid = UnitGUID(danCurrentUnit.."target") or ""
						end
					end
				end
				if hasuitUnitFrameForUnit[d8anCleuDestGuid] then --stuff with no dest could end up never getting on the ignore list which could cause a bit of extra computer stuff for no reason? made like this to catch stuff like a cast started with a pet being the dest or something like that (and pets currently being untracked), not that cast started is reliable anyway but dest success could be on an untracked unit the first time but still something that could get tracked later
					trackedPveSpells[d12anCleuSpellId] = true
					if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
						-- if d15anCleuOther=="DEBUFF" or d4anCleuSourceGuid=="" then
						if d15anCleuOther=="DEBUFF" then
							-- if d4anCleuSourceGuid=="" then
								-- danPrintBig("dan2", d12anCleuSpellId, d13anCleuSpellName, d14anCleuSpellSchool, d15anCleuOther, d16anCleuOther, d17anCleuOther)
							-- end
							hasuitFramesCenterSetEventType("aura")
							hasuitSetupFrameOptions = pveAuraOptionsUnknownType
							initialize(d12anCleuSpellId)
						end
						
					elseif d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
						if not isChanneled then
							hasuitFramesCenterSetEventType("cleu")
							hasuitSetupFrameOptions = cleuINCOptions
							initialize(d12anCleuSpellId)
							danCurrentFrameOptions = cleuINCOptions
							danCurrentFrameOptions[1]()
						else
							danCurrentEvent = "UNIT_SPELLCAST_CHANNEL_START"
							hasuitFramesCenterSetEventType("unitCasting")
							hasuitSetupFrameOptions = unitCastOptions
							initialize(d12anCleuSpellId)
							danCurrentFrameOptions = unitCastOptions
							danCurrentFrameOptions[1]()
						end
						
					elseif d2anCleuSubevent=="SPELL_CAST_START" then --todo pve version that switches targets, todo different border color for these?
						danCurrentEvent = "UNIT_SPELLCAST_START"
						hasuitFramesCenterSetEventType("unitCasting")
						hasuitSetupFrameOptions = unitCastOptions
						initialize(d12anCleuSpellId)
						danCurrentFrameOptions = unitCastOptions
						danCurrentFrameOptions[1]()
						
					elseif d2anCleuSubevent=="SPELL_EMPOWER_START" then --todo pve version that switches targets, also options to not track? castbar inc stuff isn't reliable anymore in pve but nice to see casts on frames even if the dest target isn't right? INC will always be right
						danCurrentUnit = hasuitFramesCenterNamePlateGUIDs[d4anCleuSourceGuid]
						danCurrentEvent = "UNIT_SPELLCAST_EMPOWER_START"
						hasuitFramesCenterSetEventType("unitCasting")
						hasuitSetupFrameOptions = unitCastOptions
						initialize(d12anCleuSpellId)
						danCurrentFrameOptions = unitCastOptions
						danCurrentFrameOptions[1]()
						
					end
				end
			end
		end
	end
	
	
	danLoadOnEnablePve = hasuitFramesCenterAddLoadingProfile({ --todo fully delete all saved pve stuff on unload? shouldn't make much of a difference but will lower memory after pveing/being out of instance, and make the main load/unload function faster
		["instanceType"]={["none"]=true,["party"]=true,["raid"]=true,["scenario"]=true},
		
		
		["loadedFunction"]=function()
			danGeneralCleuFrameSetScriptOnEvent(pveCleuFunc)
		end,
		["unloadedFunction"]=danGeneralCleuFrameSetScriptOnEvent,
	})
	local danLoadOnEnablePve = danLoadOnEnablePve
	
	
	local auraOptionsCommon =			{["size"]=16,	["frameLevel"]=20,	["hideCooldownText"]=true,	["alpha"]=1}
	local auraOptionsIsBossAuraCommon =	{["size"]=22,	["frameLevel"]=20,	["hideCooldownText"]=true,	["alpha"]=1}
	pveAuraOptions =					{["priority"]=480,	["group"]=auraOptionsCommon, ["loadOn"]=danLoadOnEnablePve}
	pveAuraOptionsIsBossAura =			{["priority"]=470,	["group"]=auraOptionsIsBossAuraCommon, ["loadOn"]=danLoadOnEnablePve} --todo should pve debuffs be guaranteed to show up? could make something to make them smaller to fit on frames if they go over a limit, in instance not in open world
	pveAuraOptionsUnknownType =			{}
	
	local cleuINCOptionsCommon =		{["size"]=14,	["frameLevel"]=20,	["hideCooldownText"]=true,	["alpha"]=1}
	cleuINCOptions =					{["priority"]=490,["group"]=cleuINCOptionsCommon,["duration"]=2.5,["isPve"]=true, ["loadOn"]=danLoadOnEnablePve} --todo fix
	
	local unitCastOptionsCommon =		{["size"]=12,	["frameLevel"]=20,	["hideCooldownText"]=true,	["alpha"]=1}
	unitCastOptions =					{["priority"]=495,["group"]=unitCastOptionsCommon, ["loadOn"]=danLoadOnEnablePve}
	
	tinsert(hasuitDoThisAddon_Loaded, function()
		auraOptionsCommon["controller"] = danTopRight_TopRight
		auraOptionsIsBossAuraCommon["controller"] = danTopRight_TopRight
		pveAuraOptions[1] = danMainAuraFunction
		pveAuraOptionsIsBossAura[1] = danMainAuraFunction
		pveAuraOptionsUnknownType[1] = danMainAuraFunctionPveUnknown
		
		cleuINCOptionsCommon["controller"] = danTopRight_TopRight
		cleuINCOptions[1] = danCleuINC
		
		unitCastOptionsCommon["controller"] = danTopRight_TopRight
		unitCastOptions[1] = danUnitCasting
	end)
	
	
	hasuitFramesCenterSetEventType("aura") -- ___ manual pve track/ignore list here
	hasuitSetupFrameOptions = pveAuraOptions
	initialize(422806) --Smothering Shadows (99% damage/healing reduced in the cave)
	trackedPveSubevents["SPELL_AURA_APPLIED"][422806] = true --prevents pve cleu from auto tracking this spellid when seen. it already doesn't but if they change the way it's coded i won't notice, or if m+ changes it or whatever. this debuff's sourceguid/band== thing is messed up which is why it doesn't auto track, not totally sure what's happening with it. most actual pve debuffs that get ignored like this seem bad to track anyway so not sure what's best to do here, also stuff like heroism debuff and pve potions get filtered out from this which is good. can get a better opinion over time
	
end



local addMultiFunction = hasuitFramesCenterAddMultiFunction



do --breakable cc threshhold bar, trolled and thought more than 1 unit_health could happen on a frame but looks like it's capped to that so heal and damage on the same gettime will make this inaccurate. looks like the only way to do it right is cleu, will want cleu for fake karma absorb/ray of hope too at least. this way of doing it was(is) also bad because of absorbs falling off and counting like they took that as actual damage, also damage on a 1 health target that can't die
	local iconTypes
	tinsert(hasuitDoThisAddon_Loaded, function()
		iconTypes = hasuitIconTypes
		hasuitIconTypes = nil
	end)
	local UnitHealth = UnitHealth
	local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
	local function ccBreakOnEvent(ccBreakBar, event, unit)
		if event=="UNIT_HEALTH" then
			local currentHealth = UnitHealth(unit)
			local healthChange = currentHealth - ccBreakBar.ccBreakHealthValue
			ccBreakBar.ccBreakHealthValue = currentHealth
			if healthChange<0 then
				local newValue = ccBreakBar.ccBreakThresholdValue+healthChange
				ccBreakBar.ccBreakThresholdValue = newValue
				ccBreakBar:SetValue(newValue)
				
				
				-- ccBreakBar.totalChanged = ccBreakBar.totalChanged+healthChange
				
				-- print(ccBreakBar.ccBreakSpellName..ccBreakBar.temporaryCountasd, string.format("%.0fk", -healthChange/1000))
			end
		elseif event=="UNIT_ABSORB_AMOUNT_CHANGED" then
			local currentAbsorbs = UnitGetTotalAbsorbs(unit)
			local absorbChange = currentAbsorbs - ccBreakBar.ccBreakAbsorbValue
			ccBreakBar.ccBreakAbsorbValue = currentAbsorbs
			if absorbChange<0 then
				local newValue = ccBreakBar.ccBreakThresholdValue+absorbChange
				ccBreakBar.ccBreakThresholdValue = newValue
				ccBreakBar:SetValue(newValue)
				
				
				-- ccBreakBar.totalChanged = ccBreakBar.totalChanged+absorbChange
				
				-- print(ccBreakBar.ccBreakSpellName..ccBreakBar.temporaryCountasd, string.format("%.0fk", -absorbChange/1000))
			end
		elseif event=="UNIT_MAXHEALTH" then --try to cancel out health changes from max health events assuming unit_health will fire too with a changed health that didn't come from damage taken, never tested this and not sure exactly how maxhealth events happen now
			local currentHealth = UnitHealth(unit)
			local healthChange = -(currentHealth - ccBreakBar.ccBreakHealthValue)
			ccBreakBar.ccBreakHealthValue = currentHealth
			if healthChange>0 then
				local newValue = ccBreakBar.ccBreakThresholdValue+healthChange
				ccBreakBar.ccBreakThresholdValue = newValue
				ccBreakBar:SetValue(newValue)
				
				
				-- ccBreakBar.totalChanged = ccBreakBar.totalChanged+healthChange
				
				-- print(ccBreakBar.ccBreakSpellName..ccBreakBar.temporaryCountasd, string.format("%.0fk", -healthChange/1000), "max health")
			end
		end
	end
	-- local temporaryCountasd = 0
	hasuitCcBreakOnEvent = ccBreakOnEvent
	local ccBreakHealthThreshold = hasuitCcBreakHealthThreshold
	local ccBreakHealthThresholdPve = hasuitCcBreakHealthThresholdPve
	tinsert(hasuitDoThisPlayer_Entering_WorldFirstOnly, function()
		ccBreakHealthThreshold = hasuitCcBreakHealthThreshold
		ccBreakHealthThresholdPve = hasuitCcBreakHealthThresholdPve
	end)
	function hasuitSpecialAuraCcBreakThreshold()
		local danCurrentEvent = danCurrentEvent --probably good? should test. danCurrentEvent might still make sense to use like this like cleu things. what are those called? the stuff currenteventinfo returns. not sure if there's a difference between doing it like this and passing it as an arg to specialFunction(). probably cleaner to do it as an arg. could also break up the special function but would be harder to work with, more memory, and not sure it would really make it faster at all anyway. actually todo specialaurafunction should probably get removed and replaced by changing options[1] to a function that does mainaurafunction like normal and then whatever special thing. i'd like to break mainaura function up some anyway at the cost of an extra function call every time, but the extra control and being able to be more specific would probably be about as efficient or even better, and easier to work with? not totally sure
		if danCurrentEvent=="recycled" then
			local ccBreakBar = danCurrentIcon.ccBreakBar
			local unit = ccBreakBar.unit
			ccBreakBar.unit = nil
			ccBreakBar:UnregisterAllEvents()
			local frame = ccBreakBar.frame
			local frameKey = ccBreakBar.frameKey
			if frameKey then
				ccBreakBar.frameKey = nil
				frame.ccBreakBars[frameKey] = nil
				local frameCcBreakBarsCount = frame.ccBreakBarsCount - 1
				frame.ccBreakBarsCount = frameCcBreakBarsCount
				if frameCcBreakBarsCount==0 then
					frame.ccBreakBars = nil
					frame.ccBreakBarsCount = nil
				end
			end
			
		elseif danAuraEventActive then
			if danCurrentEvent=="added" then
				local unit = danCurrentFrame.unit
				local startingValueOffset = 0
				local startingHealth = UnitHealth(unit)
				local startingAbsorb = UnitGetTotalAbsorbs(unit)
				local preStartingHealth = danCurrentFrame.ccBreakPreStartingHealth
				local ccBreakBarMaxValue = ccBreakHealthThreshold*danCurrentFrameOptions["ccBreakHealthThresholdMultiplier"]
				if preStartingHealth then
					local change = startingHealth-preStartingHealth
					if change<0 then
						startingValueOffset = change
					end
					local change = startingAbsorb-danCurrentFrame.ccBreakPreStartingAbsorb
					if change<0 then
						startingValueOffset = startingValueOffset+change
					end
					if startingValueOffset<-ccBreakBarMaxValue then
						danCurrentIcon.specialFunction = nil
						return
					end
				end
				local ccBreakBars = danCurrentFrame.ccBreakBars
				if not ccBreakBars then
					ccBreakBars = {}
					danCurrentFrame.ccBreakBars = ccBreakBars
					danCurrentFrame.ccBreakBarsCount = 1
				else
					danCurrentFrame.ccBreakBarsCount = danCurrentFrame.ccBreakBarsCount+1
				end
				local spellId = danCurrentAura["spellId"]
				local sourceUnit = danCurrentAura["sourceUnit"]
				local ccBreakBar = danCurrentIcon.ccBreakBar
				ccBreakBar:SetMinMaxValues(0, ccBreakBarMaxValue)
				if sourceUnit then
					local frameKey = UnitGUID(sourceUnit)..spellId
					if ccBreakBars[frameKey] then --unit_aura not giving a source guid sucks
						ccBreakBars[frameKey].frameKey = nil
						hasuitDoThisEasySavedVariables("already have ccBreakBars[frameKey] 1")
						danCurrentFrame.ccBreakBarsCount = danCurrentFrame.ccBreakBarsCount - 1
					end
					ccBreakBars[frameKey] = ccBreakBar
					ccBreakBar.frameKey = frameKey
					if sourceUnit=="" then
						hasuitDoThisEasySavedVariables("sourceUnit empty string")
					end
				else
					hasuitDoThisEasySavedVariables("aura no sourceUnit")
					local frameKey = spellId
					if ccBreakBars[frameKey] then --unit_aura not giving a source guid sucks
						ccBreakBars[frameKey].frameKey = nil
						hasuitDoThisEasySavedVariables("already have ccBreakBars[frameKey] 2")
						danCurrentFrame.ccBreakBarsCount = danCurrentFrame.ccBreakBarsCount - 1
					end
					ccBreakBars[frameKey] = ccBreakBar
					ccBreakBar.frameKey = frameKey
				end
				
				ccBreakBar.ccBreakHealthValue = startingHealth
				ccBreakBar.ccBreakAbsorbValue = startingAbsorb
				-- temporaryCountasd = temporaryCountasd+1
				-- ccBreakBar.temporaryCountasd = temporaryCountasd
				local colors = iconTypes[danCurrentAura["dispelName"] or ""]
				danCurrentIcon.border:SetBackdropBorderColor(colors.r,colors.g,colors.b)
				ccBreakBar:SetStatusBarColor(colors.r,colors.g,colors.b)
				-- ccBreakBar:SetStatusBarColor(1,1,1)
				if danCurrentAura["duration"]<13 then
					local startingValue = ccBreakBarMaxValue+startingValueOffset
					ccBreakBar:SetValue(startingValue) --gear doesn't matter, can be naked and still have the same amount of damage to break on a training dummy anyway
					ccBreakBar.ccBreakThresholdValue = startingValue
				else
					local startingValue = ccBreakHealthThresholdPve*danCurrentFrameOptions["ccBreakHealthThresholdMultiplier"]+startingValueOffset
					ccBreakBar:SetValue(startingValue) --pve durations? won't be great because not every cc is shorter in pve like frost nova, just get rid of this after temporary?
					ccBreakBar.ccBreakThresholdValue = startingValue
				end
				ccBreakBar:RegisterUnitEvent("UNIT_HEALTH", unit)
				ccBreakBar:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", unit)
				ccBreakBar:RegisterUnitEvent("UNIT_MAXHEALTH", unit)
				ccBreakBar.unit = unit
				-- ccBreakBar.totalChanged = 0
				ccBreakBar.ccBreakSpellName = danCurrentAura["name"]
				ccBreakBar.frame = danCurrentFrame
			end
		else
			if danCurrentEvent=="updated" then --always means fullupdate(right?) which is where unit could change i think? although this might need to be delayed so that unitframe has a chance to actually update its unit. todo make sure this works right, i think it doesn't need the delay here
				local ccBreakBar = danCurrentIcon.ccBreakBar
				local unit = ccBreakBar.unit
				if unit then
					if unit~=ccBreakBar.frame.unit then
						ccBreakBar:UnregisterAllEvents()
						ccBreakBar:RegisterUnitEvent("UNIT_HEALTH", unit)
						ccBreakBar:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", unit)
						ccBreakBar:RegisterUnitEvent("UNIT_MAXHEALTH", unit)
					end
				else --tabbed out and forgot what i was gonna do with this
					hasuitDoThisEasySavedVariables("hasuitSpecialAuraCcBreakThreshold updated not unit")
				end
			elseif danCurrentEvent=="added" then
				local ccBreakBar = danCurrentIcon.ccBreakBar
				ccBreakBar.specialFunction = nil
				ccBreakBar:SetValue(0) --could do something like make bar red and reversed when it goes over the threshhold but idk might be noise more than anything. seems like ccs that can break always take at least a certain amount of damage before breaking but after that number it's rng. not sure exactly how it works. if i can get the total count to be 100% accurate and know when it breaks from damage could keep a saved minimum to know where the rng starts and could keep data points to know if the chance increases as more damage is taken
			end
		end
	end
	
	
	
	hasuitFramesCenterSetEventType("cleu")
	local danDoThisOnUpdate = hasuitDoThisOnUpdate
	hasuitCleuCcBreakThreshold = addMultiFunction(function()
		if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
			local frame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
			if frame and not frame.ccBreakPreStartingHealth then
				local unit = frame.unit
				frame.ccBreakPreStartingHealth = UnitHealth(unit)
				frame.ccBreakPreStartingAbsorb = UnitGetTotalAbsorbs(unit)
				danDoThisOnUpdate(function() --based on assumption that damage can happen between cleu aura applied and unit_aura
					frame.ccBreakPreStartingHealth = nil
					frame.ccBreakPreStartingAbsorb = nil
				end)
			end
			
		-- elseif d2anCleuSubevent=="SPELL_AURA_REMOVED" then
			-- local frame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
			-- if frame then
				-- local ccBreakBars = frame.ccBreakBars
				-- if ccBreakBars then
					-- local ccBreakBar = frame.ccBreakBars[d4anCleuSourceGuid..d12anCleuSpellId] or ccBreakBars[d12anCleuSpellId]
					-- if ccBreakBar then
						-- ccBreakBar:UnregisterAllEvents()
						--[[
						-- local unit = frame.unit
						
						-- local currentHealth = UnitHealth(unit)
						-- local currentAbsorbs = UnitGetTotalAbsorbs(unit)
						-- local change = currentHealth+currentAbsorbs-ccBreakBar.ccBreakHealthValue-ccBreakBar.ccBreakAbsorbValue
						-- if change<0 then
							-- print(ccBreakBar.ccBreakSpellName..ccBreakBar.temporaryCountasd, hasuitGreen, string.format("%.0fk", -(ccBreakBar.totalChanged+change)/1000))
						-- else
							-- print(ccBreakBar.ccBreakSpellName..ccBreakBar.temporaryCountasd, hasuitOrange, string.format("%.0fk", -(ccBreakBar.totalChanged+change)/1000))
						-- end
						]]
					-- end
				-- end
			-- end
			
		elseif d2anCleuSubevent=="SPELL_AURA_REFRESH" then
			local frame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
			if frame then
				local ccBreakBars = frame.ccBreakBars
				if ccBreakBars then
					-- local ccBreakBar = frame.ccBreakBars[d4anCleuSourceGuid..d12anCleuSpellId] or ccBreakBars["noSourceUnit"..d12anCleuSpellId] --wait why did i make it like this?
					-- local ccBreakBar = frame.ccBreakBars[d4anCleuSourceGuid~="" and d4anCleuSourceGuid..d12anCleuSpellId or "noSourceUnit"..d12anCleuSpellId]
					local ccBreakBar = frame.ccBreakBars[d4anCleuSourceGuid..d12anCleuSpellId] or ccBreakBars[d12anCleuSpellId] --works out decently even with no sourceunit, only problem i can think of is a duplicate spellid replacing an older one, deleting its spot in this table, and then a third dr will have no way of getting set right because the unitaura event will be an updated instead of added. would have to iterate through and match instanceids or something like that, or do a fake added event with the ccbreakbar function. or better yet iterate through the instanceids of the unitframe and find the one(s) for the relevant spellid that isn't on the unitframe yet
					if ccBreakBar then
						local unit = frame.unit
						ccBreakBar.ccBreakHealthValue = UnitHealth(unit)
						ccBreakBar.ccBreakAbsorbValue = UnitGetTotalAbsorbs(unit)
						local startingValue = ccBreakHealthThreshold*danCurrentFrameOptions["ccBreakHealthThresholdMultiplier"]
						ccBreakBar:SetValue(startingValue)
						ccBreakBar.ccBreakThresholdValue = startingValue --added later, this is needed right? also won't work right for pve but not sure i care about that to begin with
						-- ccBreakBar.totalChanged = 0
					end
				end
			end
		end
	end)
end


hasuitFramesCenterSetEventType("aura")





















local startCooldownTimerText

updatedAuraSharedFunction = function()
	-- danPrint("updatedAuraSharedFunction")
	local expirationTime = danCurrentAura["expirationTime"]
	local startTime = expirationTime-danCurrentAura["duration"]
	
	danCurrentIcon.startTime = startTime
	danCurrentIcon.expirationTime = expirationTime
	
	--dan4
	danCurrentIcon.cooldown:SetCooldown(startTime, danCurrentAura["duration"])
	if danCurrentIcon.cooldownTextShown then
		startCooldownTimerText(danCurrentIcon)
	end
	
	local applications = danCurrentAura["applications"]
	if applications>0 then
		local text = danCurrentIcon.text
		if text then --added check for text existing because an error happened once. plan is to rework text and stuff like that should work itself out
			if applications>1 then
				text:SetText(applications)
			else
				text:SetText("") --error was here
			end
		end
	end
	if danCurrentIcon.specialFunction then 
		danCurrentIcon.specialFunction()
	end
	danCurrentController = danCurrentIcon.controller
	danSortController()
end















local lastEventId
local hasuitUnitAuraFrame = CreateFrame("Frame")
hasuitUnitAuraFrame:RegisterEvent("UNIT_AURA")
hasuitUnitAuraFrame:SetScript("OnEvent", function(_, _, unit, auraTable) --auraInstanceIDs change for auras with no way of following it or even reliably saying it's the same aura that got its id changed after it decides there should be a full update? sucks for tracking soul hots that don't have any way of identifying other than the druid having soul when they cast it or doing math on the tooltip. actually todo unit name in tooltip might exist and be consistent even if the aura table doesn't have a source unit? also check to see if aura table stays the same even if instanceid changes
	local currentEventId = GetCurrentEventID()
	if lastEventId == currentEventId then
		return
	end
	lastEventId = currentEventId --bored todo should change everything to registerunitevent probably? or maybe just the more common events like this
	
	
	danCurrentFrame = hasuitUnitFrameForUnit[unit]
	if not danCurrentFrame then
		return --could have a function for units with no unitframe here
	end
	
	danAuraEventActive = true
	
	-- for auraEventType, auras in pairs(auraTable) do --old way, this way is probably significantly worse every time even if there's only 1 auraEventType
	local addedAuras = auraTable.addedAuras
	if addedAuras then
		for i=1, #addedAuras do
			danCurrentAura = addedAuras[i]
			-- if UnitGUID(unit)==hasuitPlayerGUID and danCurrentAura["spellId"]==774 then
				-- print(hasuitTestAuraTable, danCurrentAura, hasuitTestAuraTable==danCurrentAura)
				-- hasuitTestAuraTable = danCurrentAura
			-- end
			local stuff = hasuitUnitAuraFunctions[danCurrentAura["spellId"]] or hasuitUnitAuraFunctions[danCurrentAura["name"]]
			if stuff then
				danCurrentEvent = "added"
				for j=1, #stuff do 
					danCurrentFrameOptions = stuff[j]
					danCurrentFrameOptions[1]()
				end
			end
		end
	end
	
	local removedAuras = auraTable.removedAuraInstanceIDs
	if removedAuras then
		for i=1, #removedAuras do
			local auraInstanceID = removedAuras[i]
			local icons = danCurrentFrame.auraInstanceIDs[auraInstanceID]
			if icons then
				-- danCurrentEvent = "removed"
				for i=1, #icons do
					local cooldown = icons[i].cooldown
					if cooldown.auraExpiredEarlyCount then
						cooldown.auraExpiredEarlyCount = nil
						cooldown:SetScript("OnHide", nil)
					end
					
					cooldown:Clear()
					danCooldownDoneRecycle(cooldown)
					
					-- danPrint("recycle8")
				end
				danCurrentFrame.auraInstanceIDs[auraInstanceID] = nil
				-- icons = nil
			else
				local specialRemoveFunction = danCurrentFrame.specialAuraInstanceIDsRemove[auraInstanceID]
				if specialRemoveFunction then
					specialRemoveFunction(danCurrentFrame)
					danCurrentFrame.specialAuraInstanceIDsRemove[auraInstanceID] = nil
				end
			end
		end
	end
	
	local updatedAuras = auraTable.updatedAuraInstanceIDs
	if updatedAuras then
		for i=1, #updatedAuras do
			local icons = danCurrentFrame.auraInstanceIDs[updatedAuras[i]]
			if icons then 
				danCurrentAura = GetAuraDataByAuraInstanceID(unit, updatedAuras[i])
				if danCurrentAura then 
					danCurrentEvent = "updated"
					for j=1, #icons do
						danCurrentIcon = icons[j]
						if not danCurrentIcon.differentRemoveFunction then
							updatedAuraSharedFunction()
						end
					end
				end
			end
		end
	end
	
	danAuraEventActive = false --any better/worse than nil?
	
	if auraTable.isFullUpdate then --could maybe just put this at the top and return if true? not sure if anything else ever happens if it's a full update, or if there's any reason to care even if stuff does happen, although some stuff cares whether it's a real event or a fullupdate and those can happen in the same unitaura event i'm pretty sure, so maybe don't do this
		danUpdateAurasForFrame()
	end
end)











































function danUpdateAurasForFrame()
	local unit = danCurrentFrame.unit
	local unitGUID = UnitGUID(unit)
	if unitGUID ~= danCurrentFrame.unitGUID then
		-- hasuitDoThisEasySavedVariables("unitGUID ~= danCurrentFrame.unitGUID")
		hasuitUpdateAllUnitsForUnitType[danCurrentFrame.unitType]()
		return
	end
	
	local frameAuraInstanceIDs = danCurrentFrame.auraInstanceIDs
	local recentlyChecked = {}
	
	for i=1,2 do
		local danFilter = i==2 and "HARMFUL" or nil
		for i=1,255 do
			danCurrentAura = GetAuraDataByIndex(unit, i, danFilter)
			if not danCurrentAura then
				break
			end
			local stuff = hasuitUnitAuraFunctions[danCurrentAura["spellId"]] or hasuitUnitAuraFunctions[danCurrentAura["name"]]
			if stuff then
				local auraInstanceID = danCurrentAura["auraInstanceID"]
				local icons = frameAuraInstanceIDs[auraInstanceID]
				if icons then
					danCurrentEvent = "updated"
					for j=1, #icons do
						danCurrentIcon = icons[j]
						updatedAuraSharedFunction()
					end
				else --looking at this later, shouldn't there need to be something for danCurrentFrame.specialAuraInstanceIDsRemove[auraInstanceID]? i want to redo stuff related to that and hypo
					danCurrentEvent = "added"
					for j=1, #stuff do
						danCurrentFrameOptions = stuff[j]
						danCurrentFrameOptions[1]()
					end
				end
				recentlyChecked[auraInstanceID] = true
			end
		end
	end
	local iconsToRemove = {}
	for auraInstanceID in pairs(frameAuraInstanceIDs) do
		if not recentlyChecked[auraInstanceID] then
			tinsert(iconsToRemove, auraInstanceID)
		end
	end
	for i=1,#iconsToRemove do
		local auraInstanceID = iconsToRemove[i]
		local icons = frameAuraInstanceIDs[auraInstanceID]
		-- danCurrentEvent = "removed"
		for i=1, #icons do
			local cooldown = icons[i].cooldown
			if cooldown.auraExpiredEarlyCount then
				cooldown.auraExpiredEarlyCount = nil
				cooldown:SetScript("OnHide", nil)
			end
			
			cooldown:Clear()
			danCooldownDoneRecycle(cooldown)
		end
		frameAuraInstanceIDs[auraInstanceID] = nil
	end
end
function hasuitUpdateAurasForFrame(frame)
	danCurrentFrame = frame
	danUpdateAurasForFrame()
end






























local unusedTextFrames
local danSetIconText
do
	--GetFontInfo
	unusedTextFrames = {}
	hasuitUnusedTextFrames = unusedTextFrames

	local danFont5 = CreateFont("danFont5")
	danFont5:SetFont("Fonts/FRIZQT__.TTF", 5, "OUTLINE")
	local danFont6 = CreateFont("danFont6")
	danFont6:SetFont("Fonts/FRIZQT__.TTF", 6, "OUTLINE")
	local danFont7 = CreateFont("danFont7")
	danFont7:SetFont("Fonts/FRIZQT__.TTF", 7, "OUTLINE")

	local danFont9 = CreateFont("danFont9")
	danFont9:SetFont("Fonts/FRIZQT__.TTF", 9, "OUTLINE")
	local danFont10 = CreateFont("danFont10")
	danFont10:SetFont("Fonts/FRIZQT__.TTF", 10, "OUTLINE")
	local danFont11 = CreateFont("danFont11")
	danFont11:SetFont("Fonts/FRIZQT__.TTF", 11, "OUTLINE")


	local textTypes = { --todo remake the way text works
		[11] = 				{danFont11, ["xOffset"]=2,	["yOffset"]=0},
		
		["KICKArena"]=	{danFont11,	0.8, 0.8, 0.8, 0.8,		["ownPoint"]="BOTTOM",	["targetPoint"]="BOTTOM",	["xOffset"]=2,	["yOffset"]=1},
		["KICKRbg"] =	{danFont7,							["ownPoint"]="BOTTOM",	["targetPoint"]="BOTTOM",	["xOffset"]=2,	["yOffset"]=1},
		
		["cdProc"]=		{danFont10,	0.8, 0.8, 0.8, 0.8,		["ownPoint"]="BOTTOM",	["targetPoint"]="BOTTOM",	["xOffset"]=2,	["yOffset"]=1},
		["rootArena"]=	{danFont10,	0.8, 0.8, 0.8, 0.8,		["ownPoint"]="BOTTOM",	["targetPoint"]="BOTTOM",	["xOffset"]=2,	["yOffset"]=6},
		["rootRbg"] =	{danFont6,							["ownPoint"]="BOTTOM",	["targetPoint"]="BOTTOM",	["xOffset"]=2,	["yOffset"]=1},
		
		["pointsTextWeakness"]={danFont7,					["ownPoint"]="BOTTOM",	["targetPoint"]="BOTTOM",	["xOffset"]=2,	["yOffset"]=1},
		
		["danFontOrbOfPower"]={danFont9,					["ownPoint"]="TOP",		["targetPoint"]="BOTTOM",	["xOffset"]=1,	["yOffset"]=-1},
		
		["INC5"] =		{danFont5,							["ownPoint"]="BOTTOM",	["targetPoint"]="BOTTOM",	["xOffset"]=2,	["yOffset"]=1},
		["INC10"] =		{danFont10,							["ownPoint"]="BOTTOM",	["targetPoint"]="BOTTOM",	["xOffset"]=2,	["yOffset"]=1},
		
		
	}
	for k in pairs(textTypes) do
		unusedTextFrames[k] = {}
	end


	-- local textFramesCreated = 0
	local function danGetText(textType) --todo more full recycle when going to pve instance from pvp or something, will probably have a bunch of stuff that won't get re-used otherwise
		if #unusedTextFrames[textType]>0 then
			-- danPrintTeal2("danGetText", "active: "..textFramesCreated-#unusedTextFrames[textType], "inactive: "..#unusedTextFrames[textType])
			return tremove(unusedTextFrames[textType])
		else
			-- danPrintTeal("danGetText+1", "active: "..textFramesCreated-#unusedTextFrames[textType], "inactive: "..#unusedTextFrames[textType])
			-- textFramesCreated = textFramesCreated+1
			
			local textOptions = textTypes[textType]
			local textFrame = CreateFrame("Frame")
			textFrame.textType = textType
			textFrame.text = textFrame:CreateFontString()
			textFrame.text:SetFontObject(textOptions[1])
			textFrame.text:SetPoint(textOptions["ownPoint"] or "BOTTOMRIGHT", textFrame, textOptions["targetPoint"] or "BOTTOMRIGHT", textOptions["xOffset"], textOptions["yOffset"])
			if textOptions[2] then
				textFrame.text:SetTextColor(textOptions[2], textOptions[3], textOptions[4])
			end
			if textOptions[5] then
				textFrame.text:SetAlpha(textOptions[5])
			end
			return textFrame
		end
	end
	function danSetIconText(textType, s)
		local text = danCurrentIcon.text
		if not text then
			-- danPrint("danSetIconText")
			local textFrame = danGetText(textType)
			local text = textFrame.text
			danCurrentIcon.textFrame = textFrame
			danCurrentIcon.text = text
			textFrame:SetParent(danCurrentIcon)
			textFrame:SetAllPoints()
			textFrame:SetAlpha(1)
			text:SetText(s)
		else
			hasuitDoThisEasySavedVariables("danCurrentIcon.textFrame", s)
			text:SetText(s)
		end
	end
	function hasuitSetIconText(icon, textType, s)
		-- danPrint("hasuitSetIconText")
		danCurrentIcon = icon
		danSetIconText(textType, s)
	end
end




local iconTypes = {
	["Curse"] = DebuffTypeColor["Curse"],
	["Disease"] = DebuffTypeColor["Disease"],
	["Magic"] = DebuffTypeColor["Magic"],
	["Poison"] = DebuffTypeColor["Poison"],
	[""] = DebuffTypeColor[""],
	["unitCasting"] = DebuffTypeColor[""],
	["channel"] = DebuffTypeColor[""],
	["KICK"] = {r=0.5, g=0.5, b=0.5},
	["greenBorder"] = {r=0, g=0.9, b=0},
}
hasuitIconTypes = iconTypes
for k in pairs(iconTypes) do
	unusedIcons[k] = {}
end
unusedIcons["optionalBorder"] = {}
unusedIcons[true] = {}
unusedIcons["trueNoReverse"] = {}
unusedIcons["ccBreak"] = {}





do --cooldown timer text
	local C_Timer_NewTimer = C_Timer.NewTimer
	local C_Timer_NewTicker = C_Timer.NewTicker
	local GetTime = GetTime
	
	
	local function setCooldownTextGreen3(timer) --bored todo clean up, more stuff should be in the start function for when setting timer2 isn't necessary, at least one of these timer functions shouldn't even exist
		local icon = timer.icon
		local cooldownText = icon.cooldownText
		local expirationTime = icon.expirationTime
		cooldownText:SetFormattedText("%.1f", expirationTime-GetTime())
		-- dw(expirationTime-GetTime())
		
		icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
			cooldownText:SetFormattedText("%.1f", expirationTime-GetTime())
			-- dw(expirationTime-GetTime())
		end, 28)
		
	end
	
	local function setCooldownTextGreen2(timer)
		local icon = timer.icon
		local cooldownText = icon.cooldownText
		local expirationTime = icon.expirationTime
		local timeLeft = expirationTime-GetTime()
		cooldownText:SetFormattedText("%.1f", timeLeft)
		-- dw(timeLeft)
		
		
		local numTicksTotal = (timeLeft-timeLeft%0.1)*10-1
		if numTicksTotal>=1 then
			-- danPrint(numTicksTotal)
			if numTicksTotal>=29 then --why is 28>28?
				-- danPrint(numTicksTotal)
				local numTicksPartial = numTicksTotal-28
				
				icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
					cooldownText:SetFormattedText("%.1f", expirationTime-GetTime())
					-- dw(expirationTime-GetTime())
				end, numTicksPartial) --what happens if you put a fraction here? could that have been an easier way to get these to start ticking at the right time?
				
				icon.cooldownTextTimer2 = C_Timer_NewTimer(timeLeft-2.9, setCooldownTextGreen3) --28
				icon.cooldownTextTimer2.icon = icon
			else
				icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
					cooldownText:SetFormattedText("%.1f", expirationTime-GetTime())
					-- dw(expirationTime-GetTime())
				end, numTicksTotal)
				
			end
		end
	end
	
	local function setCooldownTextGreen1(timer) --C_Timers seem to drift so this is an attempt to make it accurate enough with 0.1 precision to be good without having to check gettime more than needed, although something new needs to be done because this still isn't great for trying to time reclones
		local icon = timer.icon
		local cooldownText = icon.cooldownText
		cooldownText:SetTextColor(0,1,0)
		local expirationTime = icon.expirationTime
		local timeLeft = expirationTime-GetTime()
		cooldownText:SetFormattedText("%.1f", timeLeft)
		-- dw(expirationTime-GetTime())
		
		
		if timeLeft>0 then
			local timeLeftRemainder = timeLeft%0.1
			if timeLeftRemainder<0.008 then --todo GetFramerate?
				local numTicksTotal = (timeLeft-timeLeftRemainder)*10-1
				if numTicksTotal>=1 then
					if numTicksTotal>=29 then --28
						local numTicksPartial = numTicksTotal-28
						
						icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
							cooldownText:SetFormattedText("%.1f", expirationTime-GetTime()) --significant lag makes the other way become very inaccurate for these 0.1 tickers although the other way would be fine most of the time
							-- dw(expirationTime-GetTime())
						end, numTicksPartial)
						
						icon.cooldownTextTimer2 = C_Timer_NewTimer(timeLeft-2.9, setCooldownTextGreen3) --28
						icon.cooldownTextTimer2.icon = icon
					else
						
						icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
							cooldownText:SetFormattedText("%.1f", expirationTime-GetTime())
							-- dw(expirationTime-GetTime())
						end, numTicksTotal)
						
					end
				end
			else
				icon.cooldownTextTimer2 = C_Timer_NewTimer(timeLeftRemainder, setCooldownTextGreen2)
				icon.cooldownTextTimer2.icon = icon
			end
		end
	end
	
	
	local function setCooldownTextWhiteOrYellowTimer2(timer) --todo set new ticker at 19 because it drifts so far sometimes that the seconds counter gets off by 1, not sure how that's actually happening but that seems like the kind of thing that affects different computers differently? ideally if bored could just make my own C_Timer stuff but not sure how or if it's possible to make it the same way they made it. could make something central that does GetTime on every frame that could help control all timers more accurately/sync seconds countdowns to keep everything slightly less chaotic 
		local icon = timer.icon
		icon.cooldownText:SetTextColor(1,1,0)
		icon.cooldownTextTimer2 = C_Timer_NewTimer(14, setCooldownTextGreen1)
		icon.cooldownTextTimer2.icon = icon
	end
	
	local function setCooldownTextWhiteOrYellowTimer(timer)
		local icon = timer.icon
		local timeLeft = timer.timeLeftInitial
		local numTicks = timeLeft-6
		local cooldownText = icon.cooldownText
		cooldownText:SetText(timeLeft)
		-- dw(icon.expirationTime-GetTime())
		if numTicks>0 then
			
			icon.cooldownTextTimer1 = C_Timer_NewTicker(1, function() --could put this in icon scope and not need to make a new function for every new ticker without losing anything other than a little memory? not sure how much it matters or if it would even be better, might be better tho
				timeLeft = timeLeft-1
				cooldownText:SetText(timeLeft)
				-- dw(icon.expirationTime-GetTime())
			end, numTicks)
			
		end
		if timer.yellow then
			icon.cooldownTextTimer2 = C_Timer_NewTimer(numTicks+1, setCooldownTextGreen1) --may need to cancel the previous one too? or something to get it to be garbage collected. probably not
		else
			icon.cooldownTextTimer2 = C_Timer_NewTimer(numTicks-13, setCooldownTextWhiteOrYellowTimer2)
		end
		icon.cooldownTextTimer2.icon = icon
	end
	
	
	function startCooldownTimerText(icon) --dan2
		icon.cooldownTextTimer1:Cancel() --there's probably a better way to do the cancels especially now that there are 2 timers
		icon.cooldownTextTimer2:Cancel()
		local timeLeft = icon.expirationTime-GetTime()
		
		if timeLeft>5.5 then --yellow or white
			icon.cooldownText:SetFormattedText("%.0f", timeLeft)
			-- dw(timeLeft)
			
			local timeLeftRemainder = timeLeft%1
			if timeLeftRemainder==0 then
				timeLeftRemainder = 1
			end
			icon.cooldownTextTimer2 = C_Timer_NewTimer(timeLeftRemainder, setCooldownTextWhiteOrYellowTimer)
			local cooldownTextTimer2 = icon.cooldownTextTimer2
			cooldownTextTimer2.icon = icon
			cooldownTextTimer2.timeLeftInitial = timeLeft-timeLeftRemainder
			
			if timeLeft>19.5 then --white
				icon.cooldownText:SetTextColor(1,1,1)
			else --yellow
				icon.cooldownText:SetTextColor(1,1,0)
				cooldownTextTimer2.yellow = true
			end
			
		else --green, easier to read than red in a lot of cases without doing something like changing shadow color to white, which might also be good? could also do orange instead of red or something, or unrelated match color with border color if there is one. could also give each iconType its own cd text color(s)
			
			icon.cooldownText:SetFormattedText("%.1f", timeLeft)
			-- dw(timeLeft)
			icon.cooldownText:SetTextColor(0,1,0)
			if timeLeft>0 then
				icon.cooldownTextTimer2 = C_Timer_NewTimer(timeLeft%0.1, setCooldownTextGreen1) --should maybe be setCooldownTextGreen2 instead? SetTextColor sets twice like this and maybe other reason
				icon.cooldownTextTimer2.icon = icon
			end
			
		end
	end
	hasuitStartCooldownTimerText = startCooldownTimerText
end







local cooldownTextFonts = {
	[7]=5,
	[8]=5,
	[9]=6,
	[10]=6,
	[11]=6,
	[12]=6,
	[13]=6,
	[14]=6,
	[15]=7,
	[16]=7,
	[17]=8,
	[18]=8,
	[19]=9,
	[20]=9,
	[21]=10,
	[22]=10,
	[23]=10,
	[24]=11,
	[25]=11,
	[26]=11,
	
	[28]=11,
	
	[30]=12,
	
	[35]=13,
	
	[39]=14,
	
	[41]=14,
	
	[43]=15,
	
	[45]=15,
	
	[47]=16,
}
do
	local temp = {}
	for iconSize, fontSize in pairs(cooldownTextFonts) do
		if not temp[fontSize] then
			local asd = CreateFont("hasuitCooldownFont"..fontSize) --needs a unique name, --todo Subsequently changing the font object will affect the text displayed on every widget it was assigned to.?
			cooldownTextFonts[iconSize] = asd
			asd:SetFont("Fonts/FRIZQT__.TTF", fontSize, "OUTLINE")
			temp[fontSize] = asd
		else
			cooldownTextFonts[iconSize] = temp[fontSize]
		end
	end
	hasuitCooldownTextFonts = cooldownTextFonts
end



do
	local ccBreakOnEvent = hasuitCcBreakOnEvent
	hasuitCcBreakOnEvent = nil
	
	local danCooldownFontAsd = cooldownTextFonts[22]
	local cooldownTextTimerAsd = C_Timer_NewTimer(0, function()end)
	cooldownTextTimerAsd:Cancel()

	function danGetIcon(iconType) --todo aura hide checks whether the aura is active and if not hides like normal, if it still is cooldown:setscript(hide, show()) something like this to prevent icons lighting up briefly when cooldown is done but no remove event
		if #unusedIcons[iconType]>0 then --would ~= be better?
			-- danPrintTeal2("danGetIcon"..tostring(iconType), "active: "..iconFramesCreated-#unusedIcons[iconType], "inactive: "..#unusedIcons[iconType])
			return tremove(unusedIcons[iconType])
		else
			-- danPrintTeal("danGetIcon+1"..tostring(iconType), "active: "..iconFramesCreated-#unusedIcons[iconType], "inactive: "..#unusedIcons[iconType])
			iconFramesCreated = iconFramesCreated+1
			
			local icon = CreateFrame("Frame")
			if iconType=="optionalBorder" or iconType=="ccBreak" then
				icon.border = CreateFrame("Frame", nil, icon, "BackdropTemplate")
				icon.border:SetBackdrop(danBackdrop)
				icon.border:SetAllPoints()
				icon.border:SetAlpha(0)
			else
				local colors = iconTypes[iconType]
				if colors then
					icon.border = CreateFrame("Frame", nil, icon, "BackdropTemplate")
					icon.border:SetBackdrop(danBackdrop)
					icon.border:SetBackdropBorderColor(colors.r, colors.g, colors.b)
					icon.border:SetAllPoints()
				end
			end
			icon.iconType = iconType
			
			icon.iconTexture = icon:CreateTexture(nil, "BACKGROUND") --set the iconTexture draw layer lower, todo mixin cooldown and backdrop and make every icon just 1 frame?, don't even need to make an extra one for text
			icon.iconTexture:SetAllPoints()
			-- icon.iconTexture:SetPoint("TOPLEFT", icon, "TOPLEFT", 1, -1)
			-- icon.iconTexture:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -1, 1)
			
			icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
			local cooldown = icon.cooldown
			cooldown.parentIcon = icon
			cooldown:SetPoint("TOPLEFT", 1, -1)
			cooldown:SetPoint("BOTTOMRIGHT", -1, 1)
			cooldown:SetDrawBling(false)
			cooldown:SetDrawEdge(false)
			if iconType~="trueNoReverse" and iconType~="unitCasting" then
				cooldown:SetReverse(true)
			else
				cooldown:SetReverse(false)
			end
			cooldown:SetAlpha(1)
			
			
			if iconType=="channel" then --todo make a better function to return icons that won't check this all the time for no reason?
				icon.castingInfo = UnitChannelInfo
				
			elseif iconType=="unitCasting" then
				icon.castingInfo = UnitCastingInfo
				
			elseif iconType=="ccBreak" then
				icon.border:SetAlpha(1)
				local ccBreakBar = CreateFrame("StatusBar", nil, icon)
				icon.ccBreakBar = ccBreakBar
				ccBreakBar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
				ccBreakBar:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT", 2, 2)
				ccBreakBar:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
				ccBreakBar:SetHeight(3)
				ccBreakBar:SetFrameLevel(22) --how does this interact when framelevel doesn't get set on icon until it gets setparent to frame?
				ccBreakBar:SetScript("OnEvent", ccBreakOnEvent)
				-- ccBreakBar.totalChanged = 0
				local background = ccBreakBar:CreateTexture(nil, "BACKGROUND")
				ccBreakBar.background = background
				background:SetAllPoints()
				background:SetColorTexture(0,0,0)
				
			end
			
			--todo reset cds when entering arena?
			
			cooldown.noCooldownCount = true  --this is to prevent omnicc from putting a timer on the icon, bored todo only have this in the function if omnicc is loaded
			cooldown:SetHideCountdownNumbers(true)
			
			--dan1
			icon.cooldownText = cooldown:CreateFontString()
			local cooldownText = icon.cooldownText
			cooldownText:SetIgnoreParentAlpha(true)
			cooldownText:SetPoint("CENTER", icon, "CENTER", 1, 0)
			cooldownText:SetFontObject(danCooldownFontAsd) --just to prevent an error
			icon.cooldownTextTimer1 = cooldownTextTimerAsd
			icon.cooldownTextTimer2 = cooldownTextTimerAsd
			
			return icon
		end
	end
end
hasuitGetIcon = danGetIcon




function danCooldownDoneRecycle(cooldown) --dan5
	-- danPrint("danCooldownDoneRecycle")
	-- danPrint("recycle6")
	danCurrentIcon = cooldown.parentIcon
	danCurrentIcon.active = false
	danCurrentIcon:SetAlpha(0)
	
	if danCurrentIcon.cooldownTextShown then --not ideal, but neither is anything else here. recycling could be a way cooler system
		danCurrentIcon.cooldownTextTimer1:Cancel()
		danCurrentIcon.cooldownTextTimer2:Cancel()
		danCurrentIcon.cooldownTextShown = false
		danCurrentIcon.cooldownText:SetText("")
	end
	
	danCurrentEvent = "recycled"
	if danCurrentIcon.specialFunction then
		danCurrentIcon.specialFunction()
		danCurrentIcon.specialFunction = nil
	end
	if danCurrentIcon.recycle then
		danCurrentIcon.recycle(danCurrentIcon)
	end
	
	if danCurrentIcon.overridesSame then
		local overrode = danCurrentIcon.overrode
		if danCurrentIcon.overridden then
			danCurrentIcon.cooldownText:Show() --sketchy
		end
		if overrode then
			overrode.cooldownText:Show() --sketchy
			overrode.overridden = false
			danCurrentIcon.overrode = nil
		end
		danCurrentIcon.overridden = nil
		danCurrentIcon.overridesSame = nil
	end
	
	local textFrame = danCurrentIcon.textFrame
	if textFrame then
		textFrame:SetAlpha(0)
		tinsert(unusedTextFrames[textFrame.textType], textFrame)
		danCurrentIcon.text = nil
		danCurrentIcon.textFrame = nil
	end
	
	danCurrentController = danCurrentIcon.controller
	danCleanController()
end

hasuitCooldownDoneRecycle = danCooldownDoneRecycle





	





danCleanController = function(self)
	-- danPrint("danCleanController")
	if not self then
		if danCurrentController.doingSomething ~= danCleanController then 
			danCurrentController:SetScript("OnUpdate", danCleanController)
			danCurrentController.doingSomething = danCleanController
		end
		return
	end
	local frames = self.frames
	for i=#frames, 1, -1 do
		if not frames[i].active then
			tinsert(unusedIcons[frames[i].iconType], tremove(frames, i))
		end
	end
	danSortController(self)
end
local function initializeController(controllerOptions)
	-- danPrint("initializeController")
	danCurrentFrame.controllersPairs[controllerOptions] = CreateFrame("Frame")
	local controller = danCurrentFrame.controllersPairs[controllerOptions]
	tinsert(danCurrentFrame.controllersArray, controller)
	controller.options = controllerOptions
	controller.grow = controllerOptions["grow"]
	-- controller.parent = danCurrentFrame
	controller.setPointOn = controllerOptions["setPointOnBorder"] and danCurrentFrame.border or danCurrentFrame
	controller.frames = {}
	
	-- controller.growCount = 0
	-- controller.growCountTime = 0
	
	if controllerOptions["controlsOther"] then
		local controller2 = danCurrentFrame.controllersPairs[controllerOptions["controlsOther"]]
		if not controller2 then
			controller.controller2 = initializeController(controllerOptions["controlsOther"])
		else
			controller.controller2 = controller2
		end
	end
	return controller
end
function hasuitInitializeController(frame, controllerOptions)
	-- danPrint("hasuitInitializeController")
	danCurrentFrame = frame
	return initializeController(controllerOptions)
end

function danAddToController()
	-- danPrint("danAddToController")
	local controllerOptions = danCurrentFrameOptionsCommon["controller"]
	danCurrentController = danCurrentFrame.controllersPairs[controllerOptions]
	if not danCurrentController then
		danCurrentController = initializeController(controllerOptions)
	-- else 
		-- danCurrentController.setPointOn = controllerOptions["setPointOnBorder"] and danCurrentFrame.border or danCurrentFrame --was when trinkets were on border for group but not arena, but this seems like it was a terrible way to do it anyway? unrelated controllers should have been made on frame creation and be able to be separated from frame, or done differently somehow. this was the very first system made for the addon, just rejuvenations growing in 4 different directions at the top right of a healthbar
	end
	danCurrentIcon.controller = danCurrentController
	tinsert(danCurrentController.frames, danCurrentIcon)
	danSortController()
end
-- local function delayOtherControllers(controller)--does this do anything?
	-- local theThing = controller.doingSomething
	-- if theThing == "sorting" then
		-- controller:SetScript("OnUpdate", nil)
		-- controller:SetScript("OnUpdate", danSortController)
	-- elseif theThing == "cleaning" then
		-- controller:SetScript("OnUpdate", nil)
		-- controller:SetScript("OnUpdate", danCleanController)
	-- end
	-- if controller.controller2 then
		-- delayOtherControllers(controller.controller2)
	-- end
-- end
danSortController = function(self)
	-- danPrint("danSortController")
	if not self then
		if not danCurrentController.doingSomething then 
			danCurrentController:SetScript("OnUpdate", danSortController)
			danCurrentController.doingSomething = danSortController
			-- if danCurrentController.controller2 then
				-- delayOtherControllers(danCurrentController.controller2)
			-- end
		end
		return
	end
	self:SetScript("OnUpdate", nil)
	self.doingSomething = false
	
	self.grow(self)
end

function hasuitCleanController(controller)
	-- danPrint("hasuitSortController(controller)")
	danCurrentController = controller
	danCleanController()
end
function hasuitSortController(controller) --todo
	-- danPrint("hasuitSortController(controller)")
	danCurrentController = controller
	danSortController()
end


danSort = function(a,b)
	-- danPrint("danSort")
	if a.priority<b.priority then
		return true
	elseif a.priority==b.priority then
		if a.overridesSame then
			if a.expirationTime>b.expirationTime then
				if a.overridden then
					if a.overridden.expirationTime<a.expirationTime then --this shouldn't be like this. why did this have to work when i made it
						a.overridden = false
					end
				end
				b.overridden = a
				a.overrode = b
				return true
			else --<=, i feel like that should be in one of the checks for x.overridden = false
				if b.overridden then
					if b.overridden.expirationTime<b.expirationTime then
						b.overridden = false
					end
				end
				a.overridden = b
				b.overrode = a
			end
		elseif a.startTime>b.startTime then
			return true
		end
	end
end
danSortExpirationTime = function(a,b)
	-- danPrint("danSortExpirationTime")
	return a.expirationTime<b.expirationTime
end
danSortPriorityExpirationTime = function(a,b)
	if a.priority<b.priority then
		return true
	elseif a.priority==b.priority then
		return a.expirationTime<b.expirationTime
	end
end
danBackdrop = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1}





do
	local danCurrentUnitFrameWidth
	tinsert(hasuitDoThisGroup_Roster_UpdateWidthChanged.functions, function()
		danCurrentUnitFrameWidth = hasuitRaidFrameWidth
	end)
	local danCurrentUnitFrameHeight
	tinsert(hasuitDoThisGroup_Roster_UpdateHeightChanged.functions, function()
		danCurrentUnitFrameHeight = hasuitRaidFrameHeight
	end)

	function normalGrow(controller) --todo this is an easy place to get performance probably, along with better sort functions --the new non-arena target count is by far the most important thing now
		-- danPrint("normalGrow")
		local o = controller.options
		local currentXPlacement = controller.currentXPlacement
		local xDirection = o["xDirection"]
		local yDirection = o["yDirection"]
		local xOffset = o["xOffset"]
		local yOffset = o["yOffset"]
		local xMinimum = o["xMinimum"]
		local startingX = (xDirection+xOffset)*xDirection
		if currentXPlacement then
			if currentXPlacement < startingX then
				currentXPlacement = startingX
			end
			startingX = currentXPlacement
		else
			currentXPlacement = startingX
		end
		currentYPlacement = (yDirection+yOffset)*yDirection
		
		
		-- if controller.growCountTime==GetTime() then
			-- controller.growCount = controller.growCount+1
			-- if controller.controller2 then
				--danPrint(danRed(danTick), "controlling", controller.growCount)
			-- else
				--danPrint(danRed(danTick), "normal     ", controller.growCount)
			-- end
		-- end
		-- controller.growCountTime=GetTime()
		
		
		
		local xLimit = o["xLimit"]*danCurrentUnitFrameWidth
		local yLimit = o["yLimit"]*danCurrentUnitFrameHeight
		local yMinimum = o["yMinimum"]
		local ownPoint = o["ownPoint"]
		local setPointOn = controller.setPointOn
		local targetPoint = o["targetPoint"]
		
		local highestY = 0
		local frames = controller.frames
		local limitReached = false
		-- controller.doingSomething = false
		sort(frames, o["sort"])
		local x=1
		local y=1
		local controller2Placement = 0
		local lastXPlacement = 0
		for i=1, #frames do 
			local icon = frames[i]
			if not icon.overridden then
				local nextXPlacement = (1+icon.size)
				local nextYPlacement = (1+icon.size)
				if x>xMinimum and currentXPlacement+nextXPlacement>xLimit then
					y=y+1
					x=1
					if i==1 then
						currentYPlacement = controller.currentYPlacement
						startingX = controller.lastXPlacement
						if startingX+nextXPlacement>xLimit then
							--danPrint("xlimit")
							limitReached = true
						end
					end
					currentXPlacement = startingX
					currentYPlacement = currentYPlacement+highestY
					highestY = nextYPlacement
				end
				if y>yMinimum and currentYPlacement+nextYPlacement>yLimit then
					limitReached = true
					--danPrint("limit reached", i-1, currentYPlacement+nextYPlacement)
				end
				if not limitReached then 
					-- danPrint("setpoint icon normal")
					icon:SetAlpha(icon.alpha)
					icon:SetPoint(ownPoint, setPointOn, targetPoint, currentXPlacement*xDirection, currentYPlacement*yDirection)
					x=x+1
					currentXPlacement = currentXPlacement+nextXPlacement
					lastXPlacement = currentXPlacement
					if controller2Placement<currentXPlacement then
						controller2Placement = currentXPlacement
					end
					if highestY < nextYPlacement then
						highestY = nextYPlacement
					end
				else
					icon:SetAlpha(0)
					-- danPrint("limit reached")
				end
			else
				icon.cooldownText:Hide()
				icon:SetAlpha(0)
				-- danPrint("icon.overridden")
			end
		end
		local controller2 = controller.controller2
		if controller2 then
			controller2.lastXPlacement = lastXPlacement
			controller2.currentXPlacement = controller2Placement or currentXPlacement
			controller2.currentYPlacement = currentYPlacement
			if controller2.doingSomething then 
				controller2.doingSomething(controller2)
			else
				controller2.grow(controller2)
			end
		end
	end
end





-- function fixedPositionGrow(controller) --prob wont work
	-- local o = controller.options
	-- local frames = controller.frames
	-- local currentLength = #frames
	
	-- local lastLength = controller.lastLength or 0
	-- local difference = currentLength-lastLength
	-- if difference>0 then 
		-- for i=lastLength+1, currentLength do
			-- local icon = frames[i]
			-- icon:SetPoint(o["ownPoint"], controller.parent, o["targetPoint"], o["xDirection"]+o["xOffset"]+o["xDirection"]*(1+icon.size)*icon.priority, o["yOffset"]+o["yDirection"])
		-- end
	-- elseif difference==0 and currentLength>0 then
		-- local icon = frames[currentLength]
		-- icon:SetPoint(o["ownPoint"], controller.parent, o["targetPoint"], o["xDirection"]+o["xOffset"]+o["xDirection"]*(1+icon.size)*icon.priority, o["yOffset"]+o["yDirection"])
	-- end
	-- controller.lastLength = currentLength
-- end





local function danSharedIconFunction()
	-- danPrint("danSharedIconFunction")
	danCurrentIcon:SetParent(danCurrentFrame)
	danCurrentIcon:ClearAllPoints()
	danCurrentIcon.size = danCurrentFrameOptionsCommon["size"]
	danCurrentIcon:SetSize(danCurrentIcon.size, danCurrentIcon.size)
	danCurrentIcon:SetFrameLevel(danCurrentFrameOptionsCommon["frameLevel"])
	danCurrentIcon.alpha = danCurrentFrameOptionsCommon["alpha"]
	danCurrentIcon:SetAlpha(danCurrentIcon.alpha)
	danCurrentIcon.priority = danCurrentFrameOptions["priority"]
	danCurrentIcon.overridesSame = danCurrentFrameOptions["overridesSame"]
	danCurrentIcon.active = true
	danAddToController()
end

do
	local function auraExpiredOnHide(cooldown) --if cooldown timer runs out before aura removed event it will keep cd dark briefly instead of the normal wow behavior of it lighting up at the end of its duration sometimes
		if cooldown.auraExpiredEarlyCount<5 then
			-- if cooldown.auraExpiredEarlyCount>0 then
				-- print("cd showed dan1", cooldown.auraExpiredEarlyCount)
			-- end
			cooldown.auraExpiredEarlyCount = cooldown.auraExpiredEarlyCount+1
			cooldown:Show()
		-- else
			-- print(hasuitBlue, "cooldown.auraExpiredEarlyCount>5")
		end
	end
	local function auraExpiredOnCooldownDone(cooldown)
		if cooldown.auraExpiredEarlyCount then
			-- print(hasuitRed, "cooldown.auraExpiredEarlyCount", cooldown.auraExpiredEarlyCount)
			hasuitDoThisEasySavedVariables("cooldown.auraExpiredEarlyCount")
		end
		cooldown.auraExpiredEarlyCount = 0
		cooldown:SetScript("OnHide", auraExpiredOnHide)
	end
	
	-- hasuitFramesCenterSetEventType("aura")
	danMainAuraFunction = addMultiFunction(function()
		-- danPrint("danMainAuraFunction")
		danCurrentFrameOptionsCommon = danCurrentFrameOptions[danCurrentFrame.unitType]
		if not danCurrentFrameOptionsCommon then
			return
		end
		danCurrentIcon = danGetIcon(danCurrentFrameOptionsCommon["specialIconType"] or danCurrentFrameOptions["specialIconType"] or danCurrentAura["isHelpful"] or danCurrentAura["dispelName"] or "") --todo mainaurafunction should be broken up and icon should be made in another function/other useful things
		danSharedIconFunction()
		danCurrentIcon.iconTexture:SetTexture(danCurrentAura["icon"])
		local expirationTime = danCurrentAura["expirationTime"]
		danCurrentIcon.expirationTime = expirationTime
		danCurrentIcon.startTime = expirationTime-danCurrentAura["duration"]
		local cooldown = danCurrentIcon.cooldown
		cooldown:SetCooldown(danCurrentIcon.startTime, danCurrentAura["duration"])
		
		--dan3
		if not danCurrentFrameOptionsCommon["hideCooldownText"] then
			danCurrentIcon.cooldownText:SetFontObject(cooldownTextFonts[danCurrentIcon.size])
			startCooldownTimerText(danCurrentIcon)
			danCurrentIcon.cooldownTextShown = true
		else
			danCurrentIcon.cooldownText:SetText("") --todo improve
		end
		
		cooldown:SetScript("OnCooldownDone", auraExpiredOnCooldownDone)
		local auraInstanceID = danCurrentAura["auraInstanceID"]
		if not danCurrentFrame.auraInstanceIDs[auraInstanceID] then
			danCurrentFrame.auraInstanceIDs[auraInstanceID] = {danCurrentIcon}
		else
			tinsert(danCurrentFrame.auraInstanceIDs[auraInstanceID], danCurrentIcon)
		end
		
		if danCurrentFrameOptions["textKey"] then
			danSetIconText(danCurrentFrameOptions["textKey"], danCurrentFrameOptions["actualText"])
		elseif danCurrentAura["applications"]>0 then
			if danCurrentAura["applications"]>1 then
				danSetIconText(11, danCurrentAura["applications"])
			else
				danSetIconText(11, "")
			end
		end
		
		local specialFunction = danCurrentFrameOptions["specialAuraFunction"]
		if specialFunction then
			danCurrentIcon.specialFunction = specialFunction
			specialFunction()
		end
	end)
end

function danMainAuraFunctionPveUnknown()
	local spellId = danCurrentAura["spellId"]
	if danCurrentAura["isBossAura"] then
		hasuitUnitAuraFunctions[spellId][#hasuitUnitAuraFunctions[spellId]] = pveAuraOptionsIsBossAura --don't need something like pveIsBossAuraTemporaryIndexTracking[d12anCleuSpellId] = #hasuitUnitAuraFunctions[d12anCleuSpellId] for the cleu. only one spellid per subevent gets tracked anyway and then future ones get ignored in the tracking part of pve cleu
		danCurrentFrameOptions = pveAuraOptionsIsBossAura
	else
		hasuitUnitAuraFunctions[spellId][#hasuitUnitAuraFunctions[spellId]] = pveAuraOptions
		danCurrentFrameOptions = pveAuraOptions
	end
	danMainAuraFunction()
end

auraSourceIsPlayer = addMultiFunction(function()
	-- danPrint("auraSourceIsPlayer")
	if danCurrentAura["sourceUnit"]=="player" then
		danMainAuraFunction()
	end
end)
function auraSourceIsPlayerAndHarmful()
	if danCurrentAura["sourceUnit"]=="player" and danCurrentAura["isHarmful"] then
		danMainAuraFunction()
	end
end
function auraSourceIsPlayerAndHelpful()
	if danCurrentAura["sourceUnit"]=="player" and danCurrentAura["isHelpful"] then
		danMainAuraFunction()
	end
end

auraSourceIsNotPlayer = addMultiFunction(function() --todo something similar to pve boss aura function to decide whether to give spell this function or skip it if class can't cast it anyway? or an alt initialize function, not sure exactly what i was thinking here but something during initialize to decide this is probably best? pve boss aura thing doesn't seem like it'd be useful here
	-- danPrint("auraSourceIsNotPlayer")
	if danCurrentAura["sourceUnit"]~="player" then
		danMainAuraFunction()
	end
end)
auraIsDebuffOnly = addMultiFunction(function()
	-- danPrint("auraIsDebuffOnly")
	if danCurrentAura["isHarmful"] then
		danMainAuraFunction()
	end
end)
hasuitAuraPoints1Required = addMultiFunction(function()
	-- danPrint("hasuitAuraPoints2Required")
	if danCurrentAura["points"][1]==danCurrentFrameOptions["points1"] then
		danMainAuraFunction()
	end
end)
hasuitAuraPoints2Required = addMultiFunction(function()
	-- danPrint("hasuitAuraPoints2Required")
	if danCurrentAura["points"][2]==danCurrentFrameOptions["points2"] then
		danMainAuraFunction()
	end
end)




--[[
danAuraMissingFunction = addMultiFunction(function(icon)
	-- danPrint("danAuraMissingFunction")
	danCurrentIcon = danGetIcon("missing")
	danSharedIconFunction()
	danCurrentIcon.iconTexture:SetTexture(danCurrentAura["icon"])
	local expirationTime = danCurrentAura["expirationTime"]
	danCurrentIcon.expirationTime = expirationTime
	danCurrentIcon.startTime = expirationTime-danCurrentAura["duration"]
	local cooldown = danCurrentIcon.cooldown
	cooldown:SetCooldown(danCurrentIcon.startTime, danCurrentAura["duration"])
	
	--dan3
	if not danCurrentFrameOptionsCommon["hideCooldownText"] then
		danCurrentIcon.cooldownText:SetFontObject(cooldownTextFonts[danCurrentIcon.size])
		startCooldownTimerText(danCurrentIcon)
		danCurrentIcon.cooldownTextShown = true
	else
		danCurrentIcon.cooldownText:SetText("") --todo improve
	end
	
	cooldown:SetScript("OnCooldownDone", auraExpiredOnCooldownDone)
	local auraInstanceID = danCurrentAura["auraInstanceID"]
	if not danCurrentFrame.auraInstanceIDs[auraInstanceID] then
		danCurrentFrame.auraInstanceIDs[auraInstanceID] = {danCurrentIcon}
	else
		tinsert(danCurrentFrame.auraInstanceIDs[auraInstanceID], danCurrentIcon)
	end
	
	if danCurrentFrameOptions["textKey"] then
		danSetIconText(danCurrentFrameOptions["textKey"], danCurrentFrameOptions["actualText"])
	elseif danCurrentAura["applications"]>0 then
		if danCurrentAura["applications"]>1 then
			danSetIconText(11, danCurrentAura["applications"])
		else
			danSetIconText(11, "")
		end
	end
	
	local specialFunction = danCurrentFrameOptions["specialAuraFunction"]
	if specialFunction then
		danCurrentIcon.specialFunction = specialFunction
		specialFunction()
	end
end)


danAuraMissingFunctionHidesWhileActive = addMultiFunction(function()
	danCurrentFrameOptionsCommon = danCurrentFrameOptions[danCurrentFrame.unitType]
	if danCurrentFrameOptionsCommon then
		
	end
end)
]]



function hypo2ndTimerThing(icon, cooldownExpirationTime)
	-- danPrint("hypo2ndTimerThing")
	if icon.hypoExpirationTime>cooldownExpirationTime then
		if icon.priority==256 and not icon.isPrimary then
			local currentTime = GetTime()
			if cooldownExpirationTime>currentTime then
				if icon.specialTimer then
					icon.specialTimer:Cancel()
				end
				icon.specialTimer = C_Timer_NewTimer(cooldownExpirationTime-currentTime, function()
					hasuitHypoCooldownTimerDone(icon)
				end)
			elseif cooldownExpirationTime==currentTime then
				icon:SetAlpha(icon.alpha)
				icon.priority = icon.basePriority
			end
		end
		return true
	end
end



function auraRemovedHypoCooldownFunction(frame)
	-- danPrint("auraRemovedHypoCooldownFunction")
	local cooldowns = frame.cooldowns
	if cooldowns then
		local affectedSpells = frame.hypoAffectedSpells
		for i=1,#affectedSpells do
			local affectedIcon = cooldowns[affectedSpells[i]]
			if affectedIcon and affectedIcon.spellId==affectedSpells[i] then
				affectedIcon.hypoExpirationTime = nil
				local expirationTime = affectedIcon.expirationTime
				if not expirationTime or expirationTime<=GetTime() then
					affectedIcon.expirationTime = GetTime()
					affectedIcon.cooldown:Clear()
					hasuitCooldownOnCooldownDone(affectedIcon.cooldown)
				else
					affectedIcon.cooldown:SetCooldown(affectedIcon.startTime, expirationTime-affectedIcon.startTime)
				end
			end
		end
	end
	frame.hypoAffectedSpells = nil
	frame.hypoAffectedSpellsPairs = nil
	frame.specialAuras[frame.hypoSpellId] = nil
	frame.hypoSpellId = nil
end
danAuraHypoCooldownFunction = addMultiFunction(function()
	-- danPrint("danAuraHypoCooldownFunction")
	if danCurrentFrame.unitClass==danCurrentFrameOptions["unitClass"] then
		local cooldowns = danCurrentFrame.cooldowns
		if cooldowns then
			danCurrentFrame.hypoSpellId = danCurrentAura["spellId"]
			danCurrentFrame.specialAuraInstanceIDsRemove[danCurrentAura["auraInstanceID"]] = auraRemovedHypoCooldownFunction
			danCurrentFrame.specialAuras[danCurrentFrame.hypoSpellId] = danCurrentAura["auraInstanceID"]
			local affectedSpells = danCurrentFrameOptions["affectedSpells"]
			danCurrentFrame.hypoAffectedSpells = affectedSpells
			danCurrentFrame.hypoAffectedSpellsPairs = danCurrentFrameOptions["affectedSpellsPairs"]
			for i=1,#affectedSpells do
				local affectedIcon = cooldowns[affectedSpells[i]]
				if affectedIcon and affectedIcon.spellId==affectedSpells[i] then
					affectedIcon.hypoExpirationTime = danCurrentAura["expirationTime"]
					if not affectedIcon.expirationTime or hypo2ndTimerThing(affectedIcon, affectedIcon.expirationTime) then
						affectedIcon.cooldown:SetCooldown(danCurrentAura["expirationTime"]-danCurrentAura["duration"], danCurrentAura["duration"]) --not really ideal, if enemy mage dies with hypo and rezzes this won't realize the mage lost hypo I think, maybe other problems I'm not thinking of
						if affectedIcon.isPrimary and affectedIcon.priority~=256 then --divine shield and ice block, want it to stay high opacity and normal priority if pally external or cold snap but act like hypo effect is a real cd if it completely prevents the use
							affectedIcon.priority = 256
							affectedIcon:SetAlpha(0.5)
						end
						danCurrentController = affectedIcon.controller
						danSortController()
					end
				end
			end
		end
	end
end)

local danCooldownReductionFunction
danAuraPoints1CooldownReduction = addMultiFunction(function()
	-- danPrint("danAuraPoints1CooldownReduction")
	if danCurrentEvent=="added" and danAuraEventActive and danCurrentAura["points"][1]==danCurrentFrameOptions["points1"] then --could be better since this won't correct itself if the aura was put on a unit not visible to player at time of cast. could do something to keep track of that and make it not a problem
		danCooldownReductionFunction()
	end
end)
danAuraPoints2CooldownReduction = addMultiFunction(function()
	-- danPrint("danAuraPoints2CooldownReduction")
	if danCurrentEvent=="added" and danAuraEventActive and danCurrentAura["points"][2]==danCurrentFrameOptions["points2"] then
		danCooldownReductionFunction()
	end
end)

danAuraPoints2CooldownReductionExternal = addMultiFunction(function()
	-- danPrint("danAuraPoints2CooldownReduction")
	if danCurrentEvent=="added" and danAuraEventActive and danCurrentAura["points"][2]==danCurrentFrameOptions["points2"] and danCurrentAura["sourceUnit"] then
		local frame = danCurrentFrame
		danCurrentFrame = hasuitUnitFrameForUnit[danCurrentAura["sourceUnit"]] --fml
		if danCurrentFrame then
			danCooldownReductionFunction()
		end
		danCurrentFrame = frame
	end
end)

danAuraPoints1HidesOther = addMultiFunction(function() --doesn't need the multifunction part
	-- danPrint("danAuraPoints1HidesOther")
	if danCurrentAura["points"][1]==danCurrentFrameOptions["points1"] then
		local hideSpellId = danCurrentFrameOptions["hideSpellId"]
		local icon = danCurrentFrame.cooldowns[hideSpellId]
		if icon and icon.spellId==hideSpellId then
			icon.priority = icon.basePriority+800
			icon:SetAlpha(0)
			icon.alpha = 0
		end
	end
end)

function danAuraDurationCooldownReduction()
	-- danPrint("danAuraDurationCooldownReduction")
	if danCurrentEvent=="added" and danAuraEventActive and danCurrentAura["duration"]==danCurrentFrameOptions["duration"] and danCurrentAura["sourceUnit"] then
		local frame = danCurrentFrame
		danCurrentFrame = hasuitUnitFrameForUnit[danCurrentAura["sourceUnit"]]
		if danCurrentFrame then
			danCooldownReductionFunction()
		end
		danCurrentFrame = frame
	end
end


local outOfRangeAlpha = hasuitOutOfRangeAlpha
local danPlayerFrame

do --smoke bomb, technically not going to be reliable if player is in a different bomb than other players, could be condensed probably, just realized maybe IsSpellInRange or something like that isn't bugged..? would have been easier than this, although spells would have to be per class and subject to change
	local UnitInRange = UnitInRange
	local function smokeBombRangeMissingOnTarget(frame) --todo different border for friendly bomb? also todo timer for bomb auras, make it look like a normal aura instead of duration 0, should be easy
		if not frame.hideTimer then
			if hasuitArenaGatesActive then
				frame:SetAlpha(outOfRangeAlpha)
			else
				if frame.bombIsFriendly then
					if GetPlayerAuraBySpellID(212183) then --Smoke Bomb
						if UnitIsVisible(frame.unit) then
							frame:SetAlpha(1) --guessing for now, todo not sure the best way to do this since range event/function is meaningless here and unitaura event happens after broken range event. maybe setscript onupdate for each arena frame on unitcast success for the duration of the bomb to get an accurate range before smoke bomb aura event. is it possible to use nameplateOccludedAlphaMult? only problem might be that's based on camera i think so could cause wrong thing to happen if camera is at a certain angle of a pillar or whatever, unrelated if that could be used to tell if someone is out of los that could be good in something like alterac valley
						else
							frame:SetAlpha(outOfRangeAlpha)
						end
					else
						if frame.shadowyDuel and GetPlayerAuraBySpellID(207736) then --shadowy duel
							frame:SetAlpha(1)
						else
							if UnitInRange(frame.unit) then
								frame:SetAlpha(1)
							else
								frame:SetAlpha(outOfRangeAlpha)
							end
						end
					end
				else
					if GetPlayerAuraBySpellID(212183) then --Smoke Bomb
						frame:SetAlpha(outOfRangeAlpha)
					else
						if frame.shadowyDuel and GetPlayerAuraBySpellID(207736) then --shadowy duel
							frame:SetAlpha(1)
						else
							if UnitInRange(frame.unit) then
								frame:SetAlpha(1)
							else
								frame:SetAlpha(outOfRangeAlpha)
							end
						end
					end
				end
			end
		end
	end
	local function smokeBombRangeActiveOnTarget(frame)
		if hasuitArenaGatesActive then
			frame:SetAlpha(outOfRangeAlpha)
		else
			if frame.bombIsFriendly then
				-- if GetPlayerAuraBySpellID(212183) then --Smoke Bomb
					frame:SetAlpha(1)
				-- else
					-- frame:SetAlpha(1) --guessing like above, can't easily tell if unit is in range or not, don't have to worry about invisible here i don't think
				-- end
			else
				if GetPlayerAuraBySpellID(212183) then --Smoke Bomb
					frame:SetAlpha(1)
				else
					frame:SetAlpha(outOfRangeAlpha)
				end
			end
		end
	end




	function danSmokeBombSpecialFunctionForArenaFrames() --only unit aura event exists for this spell atm, no cleu
		if danCurrentEvent=="recycled" then
			local frame = danCurrentIcon.frame
			smokeBombRangeMissingOnTarget(frame)
			
			frame.bombIsFriendly = nil
			frame.bombIsActive = nil
			danCurrentIcon.frame = nil
			
		elseif danCurrentEvent=="added" then
			local sourceFrame = danCurrentAura["sourceUnit"] and hasuitUnitFrameForUnit[danCurrentAura["sourceUnit"]]
			danCurrentFrame.bombIsFriendly = sourceFrame and sourceFrame.unitType=="group"
			danCurrentFrame.bombIsActive = true
			danCurrentIcon.frame = danCurrentFrame
			
			smokeBombRangeActiveOnTarget(danCurrentFrame)
		else
			hasuitDoThisEasySavedVariables("danSmokeBombSpecialFunctionForArenaFrames not added")
		end
	end

	function danSmokeBombSpecialFunctionForPlayer()
		if danCurrentEvent=="recycled" then
			for i=1,#arenaUnitFrames do
				if arenaUnitFrames[i].bombIsActive then
					smokeBombRangeActiveOnTarget(arenaUnitFrames[i])
				else
					smokeBombRangeMissingOnTarget(arenaUnitFrames[i])
				end
			end
			
		elseif danCurrentFrame~=danPlayerFrame then
			danCurrentIcon.specialFunction = nil
			
		-- else --added, updated doesn't exist for this spellid --for now? don't think there will be a problem even if the game sends an "updated" for an aura i don't have tracked yet because the instance id won't be tracked, it'll just get ignored
		elseif danCurrentEvent=="added" then 
			local sourceFrame = sourceUnit and hasuitUnitFrameForUnit[sourceUnit]
			local sourceUnit = danCurrentAura["sourceUnit"]
			if sourceFrame and sourceFrame.unitType=="group" then --friendly bomb on player
				for i=1,#arenaUnitFrames do
					local frame = arenaUnitFrames[i]
					frame:SetAlpha(1)
					
					
					
					local unit = frame.unit
					if unit then
						print(hasuitPurple, unit, "range:", UnitInRange(unit))
					end
					C_Timer_After(0, function()
						if unit then
							print("delay:", hasuitPurple, unit, "range:", UnitInRange(unit))
						end
					end)
					
					
					
					
				end
			else --enemy bomb on player
				for i=1,#arenaUnitFrames do
					if arenaUnitFrames[i].bombIsActive then
						smokeBombRangeActiveOnTarget(arenaUnitFrames[i])
					else
						smokeBombRangeMissingOnTarget(arenaUnitFrames[i])
					end
				end
			end
		else
			hasuitDoThisEasySavedVariables("danSmokeBombSpecialFunctionForPlayer not added")
		end
	end
end

function hasuitShadowyDuelFunction()
	if danCurrentEvent=="recycled" then
		danCurrentIcon.frame.shadowyDuel = nil
		danCurrentIcon.frame = nil
		
	elseif danCurrentFrame.unitType~="arena" then
		danCurrentIcon.specialFunction = nil
		
	else
		danCurrentIcon.frame = danCurrentFrame
		danCurrentFrame.shadowyDuel = true
		if GetPlayerAuraBySpellID(207736) then --shadowy duel
			local frame = danCurrentFrame
			C_Timer_After(0, function()
				if not hasuitArenaGatesActive then
					if GetPlayerAuraBySpellID(207736) then --shadowy duel
						if not frame.bombIsActive or frame.bombIsFriendly or GetPlayerAuraBySpellID(212183) then --Smoke Bomb
							frame:SetAlpha(1)
						end
					end
				end
			end)
		end
	end
end

local hideCooldown
local danCleuCooldownStart
function hasuitFeignDeath() --todo check for real dead when this falls off? if needed, --feign death
	if danCurrentEvent=="recycled" then
		local frame = danCurrentIcon.frame --as a reminder, danCurrentFrame isn't set if OnCooldownDone is the reason for the recycle
		
		frame.feignDeath = nil
		danCurrentIcon.frame = nil
		
		local cooldowns = frame.cooldowns
		if cooldowns then
			local danCharacterIcon = danCurrentIcon
			danCurrentIcon = cooldowns[202748] --Survival Tactics, different danCurrentIcon responsible for cd
			if danCurrentIcon then
				local expirationTime = danCurrentIcon.expirationTime
				if expirationTime and expirationTime>GetTime() then --checks that survival tactics is actually taken as a talent -- should do something related to frame.feignDeath being set to GetTime when seen to check for really old feign deaths that sat for longer than the 31 sec cd so icon doesn't get hidden when they actually have the talent idk. could happen outside of arena
					local previousFrame = danCurrentFrame
					danCurrentFrame = frame --don't need to set danCurrentFrame back after because it will always be the same frame as the one the cd belongs to(? im scared of this after the tww beta incident) actually i'm doing it anyway
					d12anCleuSpellId = 202748
					danCleuCooldownStart(-1)
					danCurrentFrame = previousFrame
				else
					hideCooldown(danCurrentIcon)
				end
			end
			danCurrentIcon = danCharacterIcon
		end
		
		
	else
		danCurrentIcon.frame = danCurrentFrame
		danCurrentFrame.feignDeath = true
		
	end
end

do
	local blessingOfAutumnIgnoreList
	tinsert(hasuitDoThisPlayer_Entering_WorldFirstOnly, function()
		blessingOfAutumnIgnoreList = hasuitBlessingOfAutumnIgnoreList
		hasuitBlessingOfAutumnIgnoreList = nil
		blessingOfAutumnSpecialFunction = nil --bored todo could clean up global table? shouldn't have any value keeping anything there really, plan is for people to put stuff into player login table or similar where it'll all still be available and they can make that stuff local in their own addon, then might as well be removed from global after?
	end)
	local danOptions = {["CDr"]=0.3}
	local function asd(timer) --might just work well as is without anything extra needing to be done, one potential problem is enemy stealthing, could fix that easily if a new system is made related to that or todo?: if the fullupdate just gets ignored if enemy is known to have used stealth ability, the setscript hide thing should get disabled for those icons?, other problem is just remembering to add relevant stuff to the ignore list, not sure of a good way to automate that
		local icon = timer.icon
		local newTimer = C_Timer_NewTimer(1, asd)
		icon.blessingOfAutumnTimer = newTimer
		newTimer.icon = icon
		danCurrentFrame = icon.frame
		local affectedSpells = {}
		for _, coolIcon in pairs(danCurrentFrame.cooldownPriorities) do --this could obviously be improved a lot, but this way there's no need to worry about someone changing talents or something like that with autumn already up, or someone new joining or loadon loading or whatever else, or needing to keep this small thing in mind when making new things in the future (probably)
			if coolIcon.priority==256 or coolIcon.charges then
				local spellId = coolIcon.spellId
				if not blessingOfAutumnIgnoreList[spellId] then
					tinsert(affectedSpells, spellId)
				end
			end
		end
		danOptions["affectedSpells"] = affectedSpells
		danCurrentFrameOptions = danOptions
		danCooldownReductionFunction()
	end
	function blessingOfAutumnSpecialFunction() --pretty sure if multiple blessings of autumn can be on someone this setup will still work fine and take them all into account, but we'll see, or not because what 5 man group gets 2 holy paladins that both decide to use it on the same target?
		if danCurrentEvent=="recycled" then
			danCurrentIcon.frame = nil
			danCurrentIcon.blessingOfAutumnTimer:Cancel()
			danCurrentIcon.blessingOfAutumnTimer = nil
			danOptions["affectedSpells"] = nil
			
		elseif danCurrentEvent=="added" then
			local icon = danCurrentIcon
			if icon.frame then
				hasuitDoThisEasySavedVariables("icon.frame already exists on added?")
			end
			
			icon.frame = danCurrentFrame
			local newTimer = C_Timer_NewTimer(0.1, asd) --delaying this is good for 2 things, makes it so changing danCurrentFrameOptions will happen away from unit aura event. that might not matter but will prevent any problems related to that for free, especially in the future if i change something or reuse this for another spell or something, and makes it so that it can be frontloaded and not have to worry about the last tick going 0.3 sec too far, i think, although that might not be true on server lagged auras that don't get a removed event on time, who knows? also what is the point of modrate arg on setcooldown? seems like there's no way to get a cd to just go faster but maybe i'm missing something
			icon.blessingOfAutumnTimer = newTimer
			newTimer.icon = icon
		end
	end
end


function hasuitDarkSimShowingWhatGotStolenSpecialFunction() --surprised points just tells exactly what spell they got. spent all day making something out of like 10 tellmewhen icons interacting with each other to show reliably what spell got stolen years ago
	-- danPrint("hasuitDarkSimShowingWhatGotStolenSpecialFunction")
	danCurrentIcon.iconTexture:SetTexture(GetSpellTexture(danCurrentAura["points"][1])) --whole function is untested
	danSetIconText(hasuitKICKTextKey, "stolen")
	danCurrentIcon.specialFunction = nil
end






do
	local orbsTextColors = {
		[30] = "|cff00ff00",
		[60] = "|cff7fff00",
		[90] = "|cffffff00",
		[120] = "|cffff7f00",
		[150] = "|cffff7f00",
		
		[180] = "|cffff6633",
		[210] = "|cffff5533",
		[240] = "|cffff4433",
		[270] = "|cffff3333",
	}
	function danAuraOrbOfPowerSpecialFunction()
		if danCurrentEvent=="updated" then
			local points2 = danCurrentAura["points"][2]
			local damageTakenIncreasedString = (orbsTextColors[points2] or "|cffff2222")..points2
			danCurrentIcon.text:SetText(damageTakenIncreasedString)
			
		elseif danCurrentEvent=="added" then
			local points2 = danCurrentAura["points"][2]
			local damageTakenIncreasedString = (orbsTextColors[points2] or "|cffff2222")..points2
			danSetIconText("danFontOrbOfPower", damageTakenIncreasedString)
			
		end
	end
end
do
	local bgFlagDebuffTextColors = {
		[10] = "|cff55ff00",
		[20] = "|cffaaff00",
		[30] = "|cffffff00",
		[40] = "|cffffcc00",
		
		[50] = "|cffff9900",
		[60] = "|cffff7733",
		[70] = "|cffff6633",
		[80] = "|cffff5533",
		[90] = "|cffff4433",
		[100] ="|cffff3333",
	}
	function danAuraFlagDebuffSpecialFunctionBg()
		if danCurrentEvent=="updated" or danCurrentEvent=="added" then
			local points1 = danCurrentAura["points"][1]
			local damageTakenIncreasedString = (bgFlagDebuffTextColors[points1] or "|cffff2222")..points1
			danCurrentIcon.text:SetText(damageTakenIncreasedString) --should there be a % sign to make it more clear to people that might not understand what the numbers mean at first? leaning toward no
		end
	end
end






















hasuitFramesCenterSetEventType("cleu") --make sure to always check subevent even if a spellid only has one subevent (and a function is made just for that spellid, like solar beam). d 12 can be damage amount from swings. honestly should probably base all cleu and spell_aura stuff on spellname instead of spellid(with GetSpellName on initialize for different languages) and have an ignore list for certain spellids. would make everything easier and even more efficient, especially easier for new spells getting added like oppressing roar randomly has a new spellid that does the same thing in tww. looks like the only difference is one removes 1 enrage effect

danCleuInterrupted = addMultiFunction(function() --todo could do something with extraSchool 17th parameter
	-- danPrint("danCleuInterrupted")
	if d2anCleuSubevent=="SPELL_INTERRUPT" then 
		danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
		if danCurrentFrame then
			danCurrentFrameOptionsCommon = danCurrentFrameOptions[danCurrentFrame.unitType]
			if danCurrentFrameOptionsCommon then
				danCurrentEvent = "KICK"
				danCurrentIcon = danGetIcon("KICK")
				danSharedIconFunction()
				danCurrentIcon.iconTexture:SetTexture(GetSpellTexture(d15anCleuOther))
				local currentTime = GetTime()
				local duration = danCurrentFrameOptions["duration"]
				danCurrentIcon.startTime = currentTime
				danCurrentIcon.expirationTime = currentTime+duration
				danCurrentIcon.cooldown:SetCooldown(currentTime, duration)
				
				if not danCurrentFrameOptionsCommon["hideCooldownText"] then
					danCurrentIcon.cooldownText:SetFontObject(cooldownTextFonts[danCurrentIcon.size])
					startCooldownTimerText(danCurrentIcon)
					danCurrentIcon.cooldownTextShown = true
				else
					danCurrentIcon.cooldownText:SetText("") --todo improve
				end
				
				danCurrentIcon.cooldown:SetScript("OnCooldownDone", danCooldownDoneRecycle)
				danSetIconText(hasuitKICKTextKey, "KICK")
			end
		end
	end
end)
local spellINCTable = {}
danCleuINC = addMultiFunction(function() --todo should be remade --especially if there's a way to get things to work right with less specific stuff in the options table, like anything auto tracked in pve
	-- danPrint("danCleuINC")
	if d4anCleuSourceGuid~=hasuitPlayerGUID then
		danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
		if danCurrentFrame then
			danCurrentFrameOptionsCommon = danCurrentFrameOptions[danCurrentFrame.unitType]
			if danCurrentFrameOptionsCommon then
				if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
					danCurrentEvent = "INC"
					danCurrentIcon = danGetIcon("")
					danSharedIconFunction()
					danCurrentIcon.iconTexture:SetTexture(GetSpellTexture(d12anCleuSpellId))
					local currentTime = GetTime()
					local duration = danCurrentFrameOptions["duration"]
					danCurrentIcon.startTime = currentTime
					danCurrentIcon.expirationTime = currentTime+duration
					danCurrentIcon.cooldown:SetCooldown(currentTime, duration)
					
					-- if not danCurrentFrameOptionsCommon["hideCooldownText"] then
						-- danCurrentIcon.cooldownText:SetFontObject(cooldownTextFonts[danCurrentIcon.size])
						-- startCooldownTimerText(danCurrentIcon)
						-- danCurrentIcon.cooldownTextShown = true
					-- end
					
					
					
					danCurrentIcon.cooldown:SetScript("OnCooldownDone", danCooldownDoneRecycle)
					if danCurrentFrameOptionsCommon["size"]<=20 then
						danSetIconText("INC5", "INC")
					else
						danSetIconText("INC10", "INC")
					end
					local spellINCString = danCurrentFrameOptions["ignoreSource"] and d8anCleuDestGuid..d13anCleuSpellName or d4anCleuSourceGuid..d8anCleuDestGuid..d13anCleuSpellName
					local t = spellINCTable[spellINCString]
					if not t then
						spellINCTable[spellINCString] = {}
						t = spellINCTable[spellINCString]
					end
					local icon = danCurrentIcon
					tinsert(t, icon)
					icon.cooldown:SetAlpha(0)
					-- danPrint("danCleuINC()", d2anCleuSubevent, d13anCleuSpellName, d12anCleuSpellId, danCurrentFrame.unit, spellINCString)
					icon.specialFunction = function() --only happens on recycle
						-- danPrint("icon.specialFunction")
						icon.text:SetText("")
						icon.cooldown:SetAlpha(1)
						for i=1, #t do
							if t[i]==icon then
								tremove(t, i)
								break
							end
						end
						if t and #t==0 then
							spellINCTable[spellINCString] = nil --don't need to make and delete so many tables all the time like this
							-- t = nil
						end
					end
					
				elseif 
				not danCurrentFrameOptions["spellINCType"] and d2anCleuSubevent=="SPELL_DAMAGE"
				or d2anCleuSubevent=="SPELL_MISSED" --todo absorbed? 2 different kinds of absorbs and only want to use that if it's a full absorb and prevented a normal damage subevent
				or (danCurrentFrameOptions["spellINCType"]=="aura" or danCurrentFrameOptions["isPve"]) and (d2anCleuSubevent=="SPELL_AURA_APPLIED" or d2anCleuSubevent=="SPELL_AURA_REFRESH" or d2anCleuSubevent=="SPELL_AURA_APPLIED_DOSE")
				then
					-- print("dan2", GetSpellName(d12anCleuSpellId))
					local spellINCString = danCurrentFrameOptions["ignoreSource"] and d8anCleuDestGuid..d13anCleuSpellName or d4anCleuSourceGuid..d8anCleuDestGuid..d13anCleuSpellName
					-- danPrint("danCleuINC()", d2anCleuSubevent, d13anCleuSpellName, d12anCleuSpellId, danCurrentFrame.unit, spellINCString)
					local t = spellINCTable[spellINCString]
					if t and t[1] then
						t[1].cooldown:Clear()
						danCooldownDoneRecycle(t[1].cooldown)
						-- danPrint("recycle4")
					end
				end
			end
		end
	end
end)

tinsert(hasuitDoThisPlayer_Login, function()
	danPlayerFrame = hasuitPlayerFrame
end)

danCleuDiminish = addMultiFunction(function()
	-- danPrintBig("danCleuDiminish pre", hasuitUnitFrameForUnit[d8anCleuDestGuid] and hasuitUnitFrameForUnit[d8anCleuDestGuid].unit, d8anCleuDestGuid)
	danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
	if danCurrentFrame then
		local drType = danCurrentFrameOptions[danCurrentFrame.unitType] or danCurrentFrame==danPlayerFrame and danCurrentFrameOptions["arena"]
		if drType then
			-- danPrintBig(drType)
			if d2anCleuSubevent=="SPELL_AURA_APPLIED" or d2anCleuSubevent=="SPELL_AURA_REFRESH" then 
				-- danPrintBig("success"..d2anCleuSubevent)
				danCurrentEvent = "DR"
				danCurrentIcon = danCurrentFrame.arenaStuff[drType] --dan7
				danCurrentIcon:SetAlpha(1)
				
				local currentTime = GetTime()
				-- danCurrentIcon.startTime = currentTime
				danCurrentIcon.expirationTime = currentTime+22
				danCurrentIcon.cooldown:SetCooldown(currentTime, 22) --bored todo accurate additions based on aura duration
				danCurrentIcon.active = true
				
				startCooldownTimerText(danCurrentIcon) --somehow the text got set to 2.7 1 tick after getting set to 22 on a yellow->red dr, must mean there was an extra timer running somewhere that didn't get canceled? or i have no idea. very rare, fixed itself 1 sec later when it turned to 21, everything else was completely normal. potentially a bug with c_timer ticker and not even my fault? but who knows. actually wait this is probably from the c_timer drift of the timer1 ticker disagreeing with timer2 and creating a new ticker and overwriting rid of the pointer to the original, leaving it to finish its last tick after setting a completely new timer. 90% sure that's what happened. if there's a loose ticker briefly every time i would've noticed it before. is it worth canceling the old one on the transition every time? or just leave it like this. feel like this bug is like a fun easter egg if you see it. golden kappa of bugs. something should actually be done to make the last ~3 sec more accurate though, like making a newtimer every ~0.1 sec instead of using a ticker. that would probably be equivalent to checking gettime onupdate right? without using $1mil of electricity on a number = number-0.1. --ah i saw it again with 2.8 this time on a hot, maybe not golden kappa
				
				
				
				local diminishLevel = danCurrentIcon.diminishLevel+1
				if diminishLevel==1 then
					danCurrentIcon.border:SetBackdropBorderColor(0, 1, 0)
				elseif diminishLevel==2 then
					danCurrentIcon.border:SetBackdropBorderColor(1, 1, 0)
				else
					danCurrentIcon.border:SetBackdropBorderColor(1, 0, 0)
				end
				danCurrentIcon.diminishLevel = diminishLevel
				
				
			elseif d2anCleuSubevent=="SPELL_AURA_REMOVED" then
				-- danPrintBig("success"..d2anCleuSubevent)
				danCurrentEvent = "DR"
				danCurrentIcon = danCurrentFrame.arenaStuff[drType]
				if danCurrentIcon.diminishLevel==0 then
					danCurrentIcon:SetAlpha(1)
					danCurrentIcon.diminishLevel = 1
					danCurrentIcon.border:SetBackdropBorderColor(0, 1, 0)
				end
				
				local currentTime = GetTime()
				-- danCurrentIcon.startTime = currentTime
				danCurrentIcon.expirationTime = currentTime+19
				danCurrentIcon.cooldown:SetCooldown(currentTime, 19)
				danCurrentIcon.active = true
				
				startCooldownTimerText(danCurrentIcon)
			end
		end
	end
end)




hasuitNpcIds = {
	[417] = 19647, --felhunter
	[416] = 89808, --imp
	[1860] = 17767, --void walker
	[1863] = 6358, --succubus
	[17252] = 119914, --felguard
}


local unitKBelongsToV = {} --todo reset on instance changed or something?
local function danCleuSpellSummon()
	-- danPrint("danCleuSpellSummon")
	if d2anCleuSubevent=="SPELL_SUMMON" then
		unitKBelongsToV[d8anCleuDestGuid] = {d4anCleuSourceGuid}
		if danCurrentFrameOptions["npcId"] then
			unitKBelongsToV[d8anCleuDestGuid][2] = hasuitNpcIds[danCurrentFrameOptions["npcId"]]
		end
	end
end
hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=417}
initialize(691) --Summon Felhunter
hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=1860}
initialize(697) --Summon Void walker
hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=1863}
initialize(366222) --Summon Sayaad
hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=416}
initialize(688) --Summon Imp
hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=17252}
initialize(30146) --Summon Felguard

hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=26125}
initialize(46585) --Raise Dead 2 min cd
hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=26125} --todo 63560 dark transformation
initialize(46584) --Raise Dead 30 sec cd

-- hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=17252} --no function to get npc id i think, only way is the unitguid string? or tracking it on spell_summon like this
-- initialize(111898) --Grimoire: Felguard

-- hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=103673}
-- initialize(205180) --Summon Darkglare
-- hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=135002}
-- initialize(265187) --Summon Demonic Tyrant
-- hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=0}--asd
-- initialize(1122) --Summon Infernal
-- hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=135816}
-- initialize(264119) --Summon Vilefiend
-- hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=55659}
-- initialize(104317) --Wild Imp
-- hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=143622}
-- initialize(279910) --Wild Imp
-- hasuitSetupFrameOptions = {danCleuSpellSummon, ["npcId"]=143622}
-- initialize("Hand of Gul'dan") --?


do
	local lastEventId
	local danFrame = CreateFrame("Frame")
	danFrame:RegisterEvent("UNIT_PET")
	danFrame:SetScript("OnEvent", function(_,_,unit)
		local currentEventId = GetCurrentEventID()
		if lastEventId == currentEventId then
			return
		end
		lastEventId = currentEventId
		
		local unitPet = unit.."pet"
		local unitPetGUID = UnitGUID(unitPet)
		if unitPetGUID then
			if hasuitUnitFrameForUnit[unitPetGUID] then --mind control turns people into a pet and then the game sends events for that pet unit before the same event for arena units, todo after pet frames are properly made look at this again and make sure to consider finding someone already mind controlled when a frame gets created for them
				hasuitUnitFrameForUnit[unitPet] = hasuitUnitFrameForUnit[unitPetGUID]
			else
				local asd = unitKBelongsToV[unitPetGUID]
				if asd and asd[2] then
					danUnitPetUpdateCooldown(asd[1], asd[2])
				else
					unitKBelongsToV[unitPetGUID] = {UnitGUID(unit)}
					if UnitClassBase(unit)=="WARLOCK" then
						local npcId = select(6, strsplit("-", unitPetGUID)) --UnitCreatureFamily is localized, todo could make savedvariables to remember? and reset it if language changes
						local spellId = hasuitNpcIds[npcId]
						if spellId then
							danUnitPetUpdateCooldown(UnitGUID(unit), spellId)
							unitKBelongsToV[unitPetGUID][2] = spellId
						end
					end
				end
			end
		else
			hasuitUnitFrameForUnit[unitPet] = nil
		end
	end)
end

function danUnitPetUpdateCooldown(unitGUID, spellId) --todo more accurate reset if the same pet gets resummoned still on cd
	-- danPrint("danUnitPetUpdateCooldown", unitGUID, spellId)
	local frame = hasuitUnitFrameForUnit[unitGUID]
	if frame then
		local icon = frame.cooldowns and frame.cooldowns[spellId]
		if icon then
			icon.iconTexture:SetTexture(GetSpellTexture(spellId))
			if icon.priority==256 then
				icon.priority = icon.basePriority
				icon.cooldown:Clear()
				-- icon.alpha = 1
				icon:SetAlpha(icon.alpha)
				danCurrentController = icon.controller
				danSortController()
			end
		end
	end
end
function danCooldownReductionFunction() --could split this into multiple functions to ignore hypo/multiple affected spells
	-- danPrint("danCooldownReductionFunction")
	-- local CDr = danCurrentFrameOptions["CDr"] --cursed? no explanation for how this happened but character here: , invisible by default on notepad++
	local CDr = danCurrentFrameOptions["CDr"]
	local affectedSpells = danCurrentFrameOptions["affectedSpells"]
	local hypoAffectedSpellsPairs = danCurrentFrame.hypoAffectedSpellsPairs
	for i=1,#affectedSpells do
		local icon = danCurrentFrame.cooldowns[affectedSpells[i]]
		if icon and icon.spellId==affectedSpells[i] then
			local expirationTime = icon.expirationTime
			if expirationTime then
				local currentTime = GetTime()
				if currentTime<expirationTime then
					-- danCurrentEvent = "CDr"
					if CDr=="reset" then
						expirationTime = currentTime
					else
						expirationTime = expirationTime-CDr
					end
					-- icon.expirationTime = expirationTime --was here
					if hypoAffectedSpellsPairs and hypoAffectedSpellsPairs[affectedSpells[i]] then
						if hypo2ndTimerThing(icon, expirationTime) then
							expirationTime = icon.hypoExpirationTime
						end
					end
					icon.expirationTime = expirationTime
					if currentTime>=expirationTime then
						icon.cooldown:Clear()
						if not icon.charges then
							hasuitCooldownOnCooldownDone(icon.cooldown)
						else
							icon.cdrLeftOver = currentTime-expirationTime
							hasuitCooldownOnCooldownDone(icon.cooldown)
							icon.cdrLeftOver = nil
						end
					else
						icon.cooldown:SetCooldown(icon.startTime, expirationTime-icon.startTime)
						
						startCooldownTimerText(icon)
						
					end
					-- danPrint("danCooldownReductionFunction()")
					danCurrentController = icon.controller
					danSortController()
				end
			end
		end
	end
end
function danCleuSuccessCooldownReduction() --i probably made it like this to keep cooldowns cleaner instead of including a subevent in the options
	-- danPrint("danCleuSuccessCooldownReduction")
	if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCooldownReductionFunction()
		end
	end
end
function danCleuInterruptCooldownReduction()
	-- danPrint("danCleuInterruptCooldownReduction")
	if d2anCleuSubevent=="SPELL_INTERRUPT" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCooldownReductionFunction()
		end
	end
end
function danCleuHealCooldownReduction()
	-- danPrint("danCleuSuccessCooldownReduction")
	if d2anCleuSubevent=="SPELL_HEAL" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCooldownReductionFunction()
		end
	end
end
function danCleuEnergizeCooldownReduction()
	-- danPrint("danCleuSuccessCooldownReduction")
	if d2anCleuSubevent=="SPELL_ENERGIZE" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCooldownReductionFunction()
		end
	end
end
function danCleuAppliedCooldownReduction()
	-- danPrint("danCleuAppliedCooldownReduction")
	if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCooldownReductionFunction()
		end
	end
end
function danCleuSpellEmpowerInterruptCooldownReduction()
	-- danPrint("danCleuSpellEmpowerInterruptCooldownReduction")
	if d2anCleuSubevent=="SPELL_EMPOWER_INTERRUPT" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCooldownReductionFunction()
		end
	end
end

function danCleuAppliedCooldownReductionSourceIsDest()
	-- danPrint("danCleuSuccessCooldownReduction")
	if d2anCleuSubevent=="SPELL_AURA_APPLIED" and d4anCleuSourceGuid==d8anCleuDestGuid then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCooldownReductionFunction()
		end
	end
end

function danCleuSuccessCooldownReductionSpec()
	-- danPrint("danCleuSuccessCooldownReductionSpec")
	if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame and danCurrentFrameOptions["specId"]==danCurrentFrame.specId then
			danCooldownReductionFunction()
		end
	end
end

function danCleuInterruptCooldownReductionSolarBeam() --solar beam
	-- danPrint("danCleuInterruptCooldownReductionSolarBeam")
	if d2anCleuSubevent=="SPELL_INTERRUPT" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			if danCurrentFrame.mainTarget==d8anCleuDestGuid then
				danCooldownReductionFunction()
			end
		end
	end
end

function danCleuAppliedCooldownReductionThiefsBargain354827() --might reuse for other stuff later
	-- danPrint("danCleuAppliedCooldownReductionThiefsBargain354827")
	if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame and not danCurrentFrame.thiefsBargain then
			danCurrentFrame.thiefsBargain = true
			danCooldownReductionFunction()
			danCurrentFrame.cooldownOptions[11327] = hasuitVanish96 --set back to 120 in hasuitResetCooldowns
		end
	end
end




function danCleuCooldownStart(GriftahsEmbellishingPowder) --there's a ~0.2 second inaccuracy on this for most spells? but not all -- local currentTime = GetTime()*2-hasuitLoginTime-d1anCleuTimestamp+hasuitLoginTimestamp --(for reference i've seen griftah's spellcast event twice as many times as lifebloom in pvp instances this xpac while not ever having it on any of my characters and only playing rdruid, new and improved with +2 sparkle and the same event spam. that's literally the spell description, +2 Sparkle. if you can see it it will be multiple pages worth of the same event from the same unit all in a row sometimes and i think i remember it firing along with every single spell being cast in some circumstances)
	-- danPrint("danCleuCooldownStart")
	danCurrentEvent = "CD"
	
	if danCurrentIcon.spellId~=d12anCleuSpellId then
		danCurrentIcon.iconTexture:SetTexture(GetSpellTexture(d12anCleuSpellId))
		danCurrentIcon.spellId = d12anCleuSpellId
	end
	
	if danCurrentIcon.alpha~=1 then
		danCurrentIcon.alpha = 1
		danCurrentIcon.iconTexture:SetDesaturated(false)
	end
	local cooldownOptions = danCurrentFrame.cooldownOptions[d12anCleuSpellId]
	local maxCharges = cooldownOptions["charges"]
	if not maxCharges then
		
		
		local currentTime = GetTime()
		local duration = GriftahsEmbellishingPowder+cooldownOptions["duration"]
		danCurrentIcon.startTime = currentTime
		danCurrentIcon.expirationTime = currentTime+duration
		danCurrentIcon.cooldown:SetCooldown(currentTime, duration)
		
		startCooldownTimerText(danCurrentIcon)
		
		danCurrentIcon.priority = 256
		danCurrentIcon:SetAlpha(0.5)
	else
		if not danCurrentIcon.charges then
			danCurrentIcon.charges = maxCharges-1
			danCurrentIcon.maxCharges = maxCharges
			
			
			local currentTime = GetTime()
			local duration = GriftahsEmbellishingPowder+cooldownOptions["duration"]
			danCurrentIcon.startTime = currentTime
			danCurrentIcon.expirationTime = currentTime+duration
			danCurrentIcon.cooldown:SetCooldown(currentTime, duration)
			
			startCooldownTimerText(danCurrentIcon)
			
		else
			danCurrentIcon.charges = danCurrentIcon.charges-1
		end
		
		
		if maxCharges>1 then
			danCurrentIcon.text:SetText(danCurrentIcon.charges)
		else
			danCurrentIcon.text:SetText("")
		end
		
		danCurrentIcon.duration = cooldownOptions["duration"]
		if danCurrentIcon.charges>0 then
			danCurrentIcon:SetAlpha(1)
			danCurrentIcon.cooldown:SetAlpha(0.34)
		else
			danCurrentIcon.priority = 256
			danCurrentIcon:SetAlpha(0.5)
			danCurrentIcon.cooldown:SetAlpha(1)
			
			danCurrentIcon.cooldownText:ClearAllPoints()
			danCurrentIcon.cooldownText:SetPoint("BOTTOM", danCurrentIcon, "TOP", 1, 1)
		end
	end
	
	danCurrentController = danCurrentIcon.controller
	danSortController()
end
danCleuSuccessCooldownStart1 = addMultiFunction(function()
	-- danPrint("danCleuSuccessCooldownStart1")
	if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				danCleuCooldownStart(0)
			end
		end
	end
end)
danCleuSuccessCooldownStart2 = addMultiFunction(function()
	-- danPrint("danCleuSuccessCooldownStart2")
	if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				danCleuCooldownStart(-0.167)
			end
		end
	end
end)
danCleuHealCooldownStart = addMultiFunction(function()
	-- danPrint("danCleuHealCooldownStart")
	if d2anCleuSubevent=="SPELL_HEAL" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				danCleuCooldownStart(-0.167)
			end
		end
	end
end)
danCleuSpellEmpowerStartCooldownStart2 = addMultiFunction(function()
	-- danPrint("danCleuSpellEmpowerStartCooldownStart")
	if d2anCleuSubevent=="SPELL_EMPOWER_START" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				danCleuCooldownStart(-0.167)
			end
		end
	end
end)
danCleuAppliedCooldownStart = addMultiFunction(function()
	-- danPrint("danCleuAppliedCooldownStart")
	if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				danCleuCooldownStart(0)
			end
		end
	end
end)
danCleuRemovedCooldownStart = addMultiFunction(function()
	-- danPrint("danCleuRemovedCooldownStart")
	if d2anCleuSubevent=="SPELL_AURA_REMOVED" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				danCleuCooldownStart(0)
			end
		end
	end
end)

danCleuAppliedCooldownStartPreventMultiple = addMultiFunction(function() --if used for multiple spellids for the same class/spec will cause problems
	if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			if not danCurrentFrame.cdCleuAuraStarted then
				local frame = danCurrentFrame
				frame.cdCleuAuraStarted = true
				C_Timer_After(5, function()
					frame.cdCleuAuraStarted = nil
				end)
				danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
				if danCurrentIcon then
					danCleuCooldownStart(0)
				end
			end
		end
	end
end)


danCleuSuccessCooldownStartSolarBeam = addMultiFunction(function() --solar beam
	-- danPrint("danCleuSuccessCooldownStart2")
	if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				danCleuCooldownStart(-0.167)
				
				local frame = danCurrentFrame
				frame.mainTarget = d8anCleuDestGuid
				C_Timer_After(0, function()
					frame.mainTarget = nil
				end)
			end
		end
	end
end)



danCleuSuccessCooldownStartPvPTrinket = addMultiFunction(function()
	-- danPrint("danCleuSuccessCooldownStartPvPTrinket")
	if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				if danCurrentFrame.specId and hasuitSpecIsHealerTable[danCurrentFrame.specId] then
					danCleuCooldownStart(-30.167)
				else
					danCleuCooldownStart(-0.167)
				end
				
				
				
				for spellId, t in pairs(danCurrentFrameOptions["sharedCd"]) do
					danCurrentIcon = danCurrentFrame.cooldowns[spellId]
					if danCurrentIcon then
						local newExpirationTime = GetTime()+t["minimumDuration"]
						if not danCurrentIcon.expirationTime or danCurrentIcon.expirationTime<newExpirationTime then
							d12anCleuSpellId = spellId
							danCleuCooldownStart(t["differenceFromNormalDuration"])
						end
					end
				end
			end
		end
	end
end)

danCleuAppliedCooldownStartRacial = addMultiFunction(function()
	-- danPrint("danCleuAppliedCooldownStartRacial")
	if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				danCleuCooldownStart(-0.167)
				
				danCurrentIcon = danCurrentFrame.cooldowns["pvpTrinket"]
				if danCurrentIcon then
					local currentPvpTrinketSpellId = danCurrentIcon.spellId
					if currentPvpTrinketSpellId==336126 or currentPvpTrinketSpellId==42292 then
						local newExpirationTime = GetTime()+danCurrentFrameOptions["minimumDuration"]
						if not danCurrentIcon.expirationTime or danCurrentIcon.expirationTime<newExpirationTime then
							d12anCleuSpellId = currentPvpTrinketSpellId
							danCleuCooldownStart(danCurrentFrameOptions["differenceFromNormalDuration"])
						end
					end
				end
			end
		end
	end
end)
danCleuAppliedRacialNotTrackedAffectingPvpTrinket = addMultiFunction(function() --doesn't need multi?
	-- danPrint("danCleuAppliedRacialNotTrackedAffectingPvpTrinket")
	if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
		danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns["pvpTrinket"]
			if danCurrentIcon then
				local currentPvpTrinketSpellId = danCurrentIcon.spellId
				if currentPvpTrinketSpellId==336126 or currentPvpTrinketSpellId==42292 then
					local newExpirationTime = GetTime()+danCurrentFrameOptions["minimumDuration"]
					if not danCurrentIcon.expirationTime or danCurrentIcon.expirationTime<newExpirationTime then
						d12anCleuSpellId = currentPvpTrinketSpellId
						danCleuCooldownStart(danCurrentFrameOptions["differenceFromNormalDuration"])
					end
				end
			end
		end
	end
end)








do
	local timeStopIgnoreList = { --not tested since making cd text
		[378441] = true, --Time Stop, not sure if this would get ignored by other dragon's time stop. putting this here does nothing for self time stop because aura applied happens before success for self cast. Could do cdAura instead and initialize the cd first
	}
	function danCleu378441TimeStop() --could do something with :Pause() instead, cd text was broken for it when i originally tried to do it that way (omnicc)
		-- danPrint("danCleu378441TimeStop")
		if d2anCleuSubevent=="SPELL_AURA_APPLIED" then --todo cleaner interaction with hypo and make it work if hypo is the only source of cd, it probably won't atm, also the hypo stuff here is completely untested. probably has a bad interaction with charges so bop..
			danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
			if danCurrentFrame and danCurrentFrame.cooldownPriorities then
				for _, icon in pairs(danCurrentFrame.cooldownPriorities) do
					local expirationTime = icon.expirationTime
					if expirationTime then
						local currentTime = GetTime()
						if expirationTime>currentTime and not timeStopIgnoreList[icon.spellId] then
							expirationTime = expirationTime+5
							-- danPrint("danCleu378441TimeStop start", danCurrentFrame.unit)
							icon.expirationTime = expirationTime
							if icon.hypoExpirationTime then
								icon.hypoExpirationTime = icon.hypoExpirationTime+5
								if icon.specialTimer then
									icon.specialTimer:Cancel()
								end
								icon.specialTimer = C_Timer_NewTimer(expirationTime-currentTime, function()
									-- danPrint("icon.specialTimer done", "danAuraHypoCooldownFunction() from time stop added")
									hasuitHypoCooldownTimerDone(icon)
								end)
								if expirationTime<icon.hypoExpirationTime then
									expirationTime = icon.hypoExpirationTime
								end
							end
							icon.cooldown:SetCooldown(icon.startTime, expirationTime-icon.startTime)
							
							startCooldownTimerText(icon)
							
							icon.timeStopTime = currentTime
						end
					end
				end
			end
		elseif d2anCleuSubevent=="SPELL_AURA_REMOVED" then
			danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
			if danCurrentFrame and danCurrentFrame.cooldownPriorities then
				for _, icon in pairs(danCurrentFrame.cooldownPriorities) do
					if icon.timeStopTime then
						local elapsed = GetTime()-icon.timeStopTime
						if elapsed<4.95 then
							elapsed = 5-elapsed
							local expirationTime = icon.expirationTime-elapsed
							icon.expirationTime = expirationTime
							if icon.hypoExpirationTime then
								icon.hypoExpirationTime = icon.hypoExpirationTime-elapsed
								if icon.specialTimer then
									icon.specialTimer:Cancel()
								end
								icon.specialTimer = C_Timer_NewTimer(icon.expirationTime-GetTime(), function()
									-- danPrint("icon.specialTimer done", "danAuraHypoCooldownFunction() from time stop removed")
									hasuitHypoCooldownTimerDone(icon)
								end)
								if expirationTime<icon.hypoExpirationTime then
									expirationTime = icon.hypoExpirationTime
								end
							end
							icon.cooldown:SetCooldown(icon.startTime, expirationTime-icon.startTime)
							
							startCooldownTimerText(icon)
							
						end
						icon.timeStopTime = nil
					end
				end
			end
		end
	end
end




danCleuCooldownStartPet = addMultiFunction(function()
	-- danPrint("danCleuCooldownStartPet")
	if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
		local asd=unitKBelongsToV[d4anCleuSourceGuid]
		if asd then
			danCurrentFrame = hasuitUnitFrameForUnit[asd[1]]
		else
			danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		end
		if danCurrentFrame then
			danCurrentIcon = danCurrentFrame.cooldowns[d12anCleuSpellId]
			if danCurrentIcon then
				danCleuCooldownStart(-0.167)
			end
		end
	end
end)


local activeCasts = {}

danCleuCasting = addMultiFunction(function()
	-- danPrint("danCleuCasting")
	if d4anCleuSourceGuid~=hasuitPlayerGUID then
		local sourceFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
		local sourceUnit = sourceFrame and sourceFrame.unit
		if d8anCleuDestGuid and d8anCleuDestGuid~="" then 
			danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
		elseif sourceFrame then
			local destGUID = UnitGUID(sourceUnit.."target")
			if destGUID then
				danCurrentFrame = hasuitUnitFrameForUnit[destGUID]
			end
		end
		
		if danCurrentFrame then
			danCurrentFrameOptionsCommon = danCurrentFrameOptions[danCurrentFrame.unitType]
			if danCurrentFrameOptionsCommon then
				if d2anCleuSubevent=="SPELL_EMPOWER_START" or d2anCleuSubevent=="SPELL_CAST_START" then
					if not activeCasts[d4anCleuSourceGuid] then
						danCurrentIcon = danGetIcon(danCurrentFrameOptions["castType"])
						activeCasts[d4anCleuSourceGuid] = {danCurrentIcon}
						activeCasts[d4anCleuSourceGuid]["startTime"] = GetTime()
					else
						if activeCasts[d4anCleuSourceGuid]["startTime"]~=GetTime() then
							return
						end
						danCurrentIcon = danGetIcon(danCurrentFrameOptions["castType"])
						tinsert(activeCasts[d4anCleuSourceGuid], danCurrentIcon)
					end
					
					danSharedIconFunction()
					
					local duration
					local _, _, texture, startTime, endTime
					if sourceUnit then
						_, _, texture, startTime, endTime = danCurrentIcon.castingInfo(sourceUnit)
						startTime = startTime/1000
						endTime = endTime/1000
						duration = endTime-startTime
					else
						startTime = GetTime()
						duration = danCurrentFrameOptions["backupDuration"]
						endTime = startTime+duration
						texture = GetSpellTexture(d12anCleuSpellId)
					end
					danCurrentIcon.iconTexture:SetTexture(texture)
					danCurrentIcon.startTime = startTime
					danCurrentIcon.expirationTime = endTime
					danCurrentIcon.cooldown:SetCooldown(startTime, duration)
					
					local sourceGUID = d4anCleuSourceGuid
					danCurrentIcon.cooldown:SetScript("OnCooldownDone", function(cooldown) --bored todo probably better to have one function outside and put sourceguid as a variable on cooldown
						activeCasts[sourceGUID] = nil
						danCooldownDoneRecycle(cooldown)
						-- danPrint("recycle3")
					end)
				end
			end
		end
	end
end)








do
	local danRemoveUnitHealthControlSafe
	local danRemoveUnitHealthControlNotSafe
	tinsert(hasuitDoThisAddon_Loaded, function()
		danRemoveUnitHealthControlSafe = hasuitRemoveUnitHealthControlSafe
		danRemoveUnitHealthControlNotSafe = hasuitRemoveUnitHealthControlNotSafe
		hasuitRemoveUnitHealthControlSafe = nil
		hasuitRemoveUnitHealthControlNotSafe = nil
	end)
	
	local function notDead(frame)
		frame.text:SetText("")
		frame.text2:SetText("")
		danRemoveUnitHealthControlSafe(frame.otherUnitHealthFunctions, frame.dead)
		frame.dead = nil
		local blackCount = frame.blackCount --should have probably made checks like this share a function, all checks like this that look similar are the same i think, no small difference between 1 dead background check and another
		if blackCount then
			if frame.blackCheckDead then --not needed?
				frame.blackCheckDead = false
				frame.blackCount = blackCount-1
				if blackCount==1 then --was 1
					frame.colorBackground()
					tinsert(frame.otherUnitHealthFunctions, frame.colorBackground) --danGiveUnitHealthControl
				end
			end
		end
	end
	hasuitNotDead = notDead
	local UnitIsDeadOrGhost = UnitIsDeadOrGhost
	local danClassColors = hasuitClassColorsHexList
	
	local danDoThisOnUpdate = hasuitDoThisOnUpdate
	
	local function unitDiedFunction(frame)
		
		-- if frame.targetOf then
			-- C_Timer_After(0, function()
				-- frame.targetedCountText:SetText("")
			-- end)
		-- end
		
		frame.text:SetText(danClassColors[frame.unitClass]..frame.unitName) --bored todo make .unitName this string to begin with, forgot why i changed it away from that, probably when frames were just completely breaking after trying to make unit died function with old unit_health setup
		
		local maxHealth = frame.maxHealth
		if maxHealth>=1e6 then --copied in other file ctrlf 1e6
			frame.text2:SetFormattedText("%.1fm", maxHealth/1e6) --the one thing ai contributed, me realizing this could be used instead of 1000000. was wondering if there's a more efficient way to do this
		elseif maxHealth>=1e3 then
			frame.text2:SetFormattedText("%.0fk", maxHealth/1e3)
		else
			frame.text2:SetText(maxHealth)
		end
		
		local function checkDead() --frame.dead(), checked on unit_health
			if not UnitIsDeadOrGhost(frame.unit) then --not sure but seems like this returns true briefly after unit releases and rezzes in a dungeon sometimes? either that or something else causes dead text to not clear in that situation. could delay the check or something? but not much of a problem since any unit_health will clear it afterward
				notDead(frame)
			end
		end
		frame.dead = checkDead
		tinsert(frame.otherUnitHealthFunctions, checkDead) --danGiveUnitHealthControl
		
		local blackCount = frame.blackCount
		if blackCount then
			if not frame.blackCheckDead then --also not needed?
				frame.blackCheckDead = true
				frame.blackCount = blackCount+1
				if blackCount==0 then --was 0
					frame.background:SetColorTexture(0,0,0)
					danRemoveUnitHealthControlNotSafe(frame.otherUnitHealthFunctions, frame.colorBackground)
				end
			end
		end
	end
	hasuitUnitDiedFunction = unitDiedFunction
	
	hasuitSetupFrameOptions = {function() --UNIT_DIED ___
		if d2anCleuSubevent=="UNIT_DIED" then
			local frame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
			if frame then 
				if UnitIsDeadOrGhost(frame.unit) and not frame.feignDeath and not frame.dead then --maybe hunters can die twice? todo prevent text on feign? on allies at least. could maybe cheese feign death and make it still show healthbar like nothing happened, but not really in the spirit of the game, not sure if damage subevents keep happening on a feigned target
					unitDiedFunction(frame)
				end
			end
		end
	end}
	initialize(false) --if d12anCleuSpellId or d13anCleuSpellName are false, so far 100% of unit_died subevents have had d 13==false and d 12~=false, a lot more efficient than old way of initializing -1 and 1 to 20 or whatever covered everything, -1 happens every swing_damage?, 17 is power word:shield, false is mostly just unit_died and swing missed
end





































-- local danCurrentUnit
local hasuitUnitCastSucceededFunctions = {}
hasuitFramesCenterAddToAllTable(hasuitUnitCastSucceededFunctions, "unitCastSucceeded")

local hasuitUnitCastSucceededFrame = CreateFrame("Frame")
hasuitUnitCastSucceededFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") --todo use this for INC to be able to get correct icons like green incinerate
local lastEventId
hasuitUnitCastSucceededFrame:SetScript("OnEvent", function(_, event, unit, castId, spellId)
	local currentEventId = GetCurrentEventID()
	if lastEventId == currentEventId then
		return
	end
	lastEventId = currentEventId
	
	-- local stuff = hasuitUnitCastSucceededFunctions[spellId] or hasuitUnitCastSucceededFunctions[GetSpellName(spellId)] --was wasting a lot
	local stuff = hasuitUnitCastSucceededFunctions[spellId]
	if stuff then
		danCurrentUnit = unit
		d12anCleuSpellId = spellId
		danCurrentEvent = event
		for i=1, #stuff do 
			danCurrentFrameOptions = stuff[i]
			danCurrentFrameOptions[1]()
		end
	end
end)



hasuitFramesCenterSetEventType("unitCastSucceeded")


danUnitCastSucceededCooldownStart = addMultiFunction(function()
	-- danPrint("danUnitCastSucceededCooldownStart")
	danCurrentFrame = hasuitUnitFrameForUnit[danCurrentUnit]
	danCurrentIcon = danCurrentFrame and danCurrentFrame.cooldowns[d12anCleuSpellId]
	if danCurrentIcon then
		danCleuCooldownStart(-0.167)
	end
end)

do
	local danInspectNewUnitFrame
	tinsert(hasuitDoThisAddon_Loaded, function()
		danInspectNewUnitFrame = hasuitInspectNewUnitFrame
		hasuitInspectNewUnitFrame = nil
	end)
	danUnitCastSucceededChangedTalents = addMultiFunction(function()
		-- danPrint("danUnitCastSucceededChangedTalents")
		local frame = hasuitUnitFrameForUnit[danCurrentUnit]
		if frame then
			frame.inspected = false
			danInspectNewUnitFrame(frame)
		end
	end)
end








function hasuitSoulOfTheForest() --similar to feign death, todo this isn't used yet, something like this can help fix soul hots probably
	if danCurrentEvent=="recycled" then
		danCurrentIcon.frame.hasSoul = nil
		danCurrentIcon.frame = nil
		
	else
		danCurrentIcon.frame = danCurrentFrame
		danCurrentFrame.hasSoul = true
		
	end
end





local activeSoulHots = {}
local bigRejuvSizeIncrease = 3
function soulHotsSpecialFunction() --one of the very first things made for this addon, should be fixed or remade (or given ["points"] or different spellid by blizzard), changing instances/overgrowth doesn't show it right sometimes, probably doesn't follow a unit around if people join/leave because of unit_aura full update
	if danCurrentEvent=="recycled" then
		danCurrentIcon.soul = nil
		danCurrentIcon.border:SetAlpha(0)
		danCurrentIcon.unitGUID = nil
		return
	elseif danCurrentEvent=="added" then
		danCurrentIcon.unitGUID = danCurrentFrame.unitGUID
		danCurrentIcon.border:SetBackdropBorderColor(0, 1, 0)
	end
		
	local spellId = danCurrentAura["spellId"]
	local sourceGUID = danCurrentAura["sourceUnit"] and UnitGUID(danCurrentAura["sourceUnit"])
	local destGUID = danCurrentIcon.unitGUID
	local startTime = sourceGUID and activeSoulHots[sourceGUID] and activeSoulHots[sourceGUID][destGUID..spellId]
	if startTime then
		if not danCurrentIcon.soul then 
			danCurrentIcon.soul = true
			if sourceGUID==hasuitPlayerGUID then
				if spellId==774 or spellId==155777 then --rejuv, germination
					local newSize = danCurrentIcon.size+bigRejuvSizeIncrease
					danCurrentIcon.size = newSize
					danCurrentIcon:SetSize(newSize, newSize) --gets called once earlier for no reason and immediately called again if this is aura added
				end
			end
			danCurrentIcon.border:SetAlpha(1)
		end
	elseif danCurrentIcon.soul then
		danCurrentIcon.soul = false
		if sourceGUID==hasuitPlayerGUID then
			if spellId==774 or spellId==155777 then --rejuv, germination
				local newSize = danCurrentIcon.size-bigRejuvSizeIncrease
				danCurrentIcon.size = newSize
				danCurrentIcon:SetSize(newSize, newSize)
			end
		end
		danCurrentIcon.border:SetAlpha(0)
	end
end

local danSoulTime = {}
local danSoulAbility = {}
local sourceHasSoul = {}
hasuitFramesCenterSetEventType("cleu")
hasuitSetupFrameOptions = {function() --soul of the forest empowered hots
	local frame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
	if frame and frame.disableSoul then
		return
	end
	local currentTime = GetTime()
	if d2anCleuSubevent == "SPELL_CAST_SUCCESS" then
		if sourceHasSoul[d4anCleuSourceGuid] then
			danSoulTime[d4anCleuSourceGuid] = currentTime
			danSoulAbility[d4anCleuSourceGuid] = d12anCleuSpellId
		end
	elseif d2anCleuSubevent == "SPELL_AURA_APPLIED" or d2anCleuSubevent=="SPELL_AURA_REFRESH" then
		local danSoulTime = danSoulTime[d4anCleuSourceGuid]
		if danSoulTime and danSoulTime+0.5>=currentTime and danSoulAbility[d4anCleuSourceGuid]==d12anCleuSpellId or d4anCleuSourceGuid==d8anCleuDestGuid and sourceHasSoul[d4anCleuSourceGuid] then
			if not activeSoulHots[d4anCleuSourceGuid] then
				activeSoulHots[d4anCleuSourceGuid] = {}
			end
			activeSoulHots[d4anCleuSourceGuid][d8anCleuDestGuid..d12anCleuSpellId] = currentTime
			
		else
			if activeSoulHots[d4anCleuSourceGuid] and activeSoulHots[d4anCleuSourceGuid][d8anCleuDestGuid..d12anCleuSpellId] then
				activeSoulHots[d4anCleuSourceGuid][d8anCleuDestGuid..d12anCleuSpellId] = nil
			end
		end
	end
end}
initialize(8936) --regrowth
initialize(774) --rejuvenation
initialize(155777) --germination
initialize(48438) --wild growth


hasuitSetupFrameOptions = {function()
	if d2anCleuSubevent == "SPELL_AURA_APPLIED" then
		sourceHasSoul[d4anCleuSourceGuid] = true
	elseif d2anCleuSubevent == "SPELL_AURA_REMOVED" then --todo do something about unit becoming unseen and losing soul? might work itself out after remaking soul stuff
		sourceHasSoul[d4anCleuSourceGuid] = nil
	end
end}
initialize(114108) --soul of the forest


local soulLoadingFrame = CreateFrame("Frame")
soulLoadingFrame:SetScript("OnEvent", function(_, event) --todo
	if event=="LOADING_SCREEN_ENABLED" then
		for sourceGUID, hasSoul in pairs(sourceHasSoul) do
			local frame = hasuitUnitFrameForUnit[sourceGUID]
			if frame then
				frame.disableSoul = true
			else
				sourceHasSoul[sourceGUID] = nil
			end
		end
	else
		for sourceGUID, hasSoul in pairs(sourceHasSoul) do
			local frame = hasuitUnitFrameForUnit[sourceGUID]
			if frame then
				C_Timer.After(0, function()
					frame.disableSoul = nil
				end)
			else
				sourceHasSoul[sourceGUID] = nil
			end
		end
	end
end)
soulLoadingFrame:RegisterEvent("LOADING_SCREEN_ENABLED")
soulLoadingFrame:RegisterEvent("LOADING_SCREEN_DISABLED")



















function redLifebloom(icon) --specialFunction
	-- danPrint("redLifebloom")
	if icon then
		icon.red = true
		icon.iconTexture:SetVertexColor(1, 0.55, 0.55)
		return
	elseif danCurrentEvent == "recycled" then
		if danCurrentIcon.timer then
			danCurrentIcon.timer:Cancel()
			danCurrentIcon.timer = nil
		end
		if danCurrentIcon.red then
			danCurrentIcon.iconTexture:SetVertexColor(1, 1, 1)
			danCurrentIcon.red = nil
		end
		return
	end
	
	if danCurrentIcon.timer then
		danCurrentIcon.timer:Cancel()
		danCurrentIcon.timer = nil --is this the best way to do this?
	end
	
	local elapsedTime = GetTime()-danCurrentIcon.startTime
	local timerTime = 0.7*danCurrentAura["duration"]-elapsedTime
	if timerTime <= 0 then
		danCurrentIcon.red = true
		danCurrentIcon.iconTexture:SetVertexColor(1, 0.55, 0.55)
		return
	elseif danCurrentIcon.red then
		danCurrentIcon.iconTexture:SetVertexColor(1, 1, 1)
		danCurrentIcon.red = nil
	end
	danCurrentIcon.expectedTime = GetTime()+timerTime
	local icon = danCurrentIcon
	danCurrentIcon.timer = C_Timer_NewTimer(timerTime, function()
		redLifebloom(icon)
	end)
end
tinsert(hasuitDoThisPlayer_Login, function()
	if not hasuitUsedRedLifebloom then
		redLifebloom = nil
	else
		hasuitUsedRedLifebloom = nil
	end
end)

do
	local playerClass = hasuitPlayerClass
	if playerClass=="MONK" then
		function auraCanChangeTextureSpecialFunction() --comment added later: should probably just assume any aura might change texture on an aura update? and then ya the size change thing here will be specific
			if danCurrentEvent=="updated" then
				if danCurrentAura["icon"]==627487 then
					if danCurrentIcon.size~=danCurrentIcon.normalSize then
						danCurrentIcon.iconTexture:SetTexture(danCurrentAura["icon"])
						local size = danCurrentIcon.normalSize
						danCurrentIcon.size = size
						danCurrentIcon:SetSize(size, size)
					end
				else
					if danCurrentIcon.size~=danCurrentIcon.specialSize then
						danCurrentIcon.iconTexture:SetTexture(danCurrentAura["icon"])
						local size = danCurrentIcon.specialSize
						danCurrentIcon.size = size
						danCurrentIcon:SetSize(size, size)
					end
				end
				
			elseif danCurrentEvent=="recycled" then
				danCurrentIcon.normalSize = nil
				danCurrentIcon.specialSize = nil
				
			else --"added"
				local specialSize = danCurrentFrameOptions["specialSize"]
				danCurrentIcon.normalSize = danCurrentFrameOptionsCommon["size"]
				danCurrentIcon.specialSize = specialSize
				if danCurrentAura["icon"]==5901829 then --+50% chi harmony texture, could also maybe tell by points2
					danCurrentIcon.size = specialSize
					danCurrentIcon:SetSize(specialSize, specialSize)
				end
			end
		end
	-- elseif playerClass=="DRUID" then
		-- local danTreants = {}
		-- hasuitSetupFrameOptions = {function()
			-- if d2anCleuSubevent=="SPELL_SUMMON" then
				-- if d4anCleuSourceGuid==hasuitPlayerGUID then
					-- local treantGUID = d8anCleuDestGuid
					-- danTreants[treantGUID] = true
					-- print(treantGUID)
					-- C_Timer_After(20, function()
						-- danTreants[treantGUID] = nil
					-- end)
				-- end
			-- end
		-- end}
		-- initialize(102693) --Grove Guardians
		-- function danTreantsMinorCenarionWard()
			-- local sourceUnit = danCurrentAura["sourceUnit"]
			-- local unitGUID = sourceUnit and UnitGUID(sourceUnit)
			-- print(unitGUID)
			-- if unitGUID and danTreants[unitGUID] then
				-- print(3)
				-- danMainAuraFunction()
			-- end
		-- end
	end

end
















-- hasuitGeneralCastFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
-- hasuitGeneralCastFrame:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")

-- hasuitGeneralCastFrame:RegisterEvent("UNIT_SPELLCAST_RETICLE_TARGET")
-- hasuitGeneralCastFrame:RegisterEvent("UNIT_SPELLCAST_RETICLE_CLEAR")





local hasuitCastSpellIdFunctions = {}
hasuitFramesCenterAddToAllTable(hasuitCastSpellIdFunctions, "unitCasting")
local hasuitGeneralCastStartFrame = CreateFrame("Frame")
hasuitGeneralCastStartFrame:RegisterEvent("UNIT_SPELLCAST_START")
hasuitGeneralCastStartFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
hasuitGeneralCastStartFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")

local lastEventId
hasuitGeneralCastStartFrame:SetScript("OnEvent", function(_, event, unit, castId, spellId)
	local currentEventId = GetCurrentEventID()
	if lastEventId == currentEventId then
		return
	end
	lastEventId = currentEventId
	
	local stuff = hasuitCastSpellIdFunctions[spellId] or hasuitCastSpellIdFunctions[GetSpellName(spellId)] --todo get rid of name here?
	if stuff then
		danCurrentUnit = unit
		danCurrentEvent = event
		for i=1, #stuff do 
			danCurrentFrameOptions = stuff[i]
			danCurrentFrameOptions[1]()
		end
	end
end)









do
	local danFrame = CreateFrame("Frame")
	danFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
	danFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	danFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
	danFrame:SetScript("OnEvent", function(_, event, unit, castId, spellId)
		local sourceGUID = UnitGUID(unit)
		local sourceCastTable = activeCasts[sourceGUID]
		if sourceCastTable then
			for i=1,#sourceCastTable do
				sourceCastTable[i].cooldown:Clear()
				danCooldownDoneRecycle(sourceCastTable[i].cooldown)
				-- danPrint("recycle2")
			end
			activeCasts[sourceGUID] = nil
		end
	end)
end

do
	local danFrame = CreateFrame("Frame")
	danFrame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	danFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	danFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE")
	local lastEventId
	danFrame:SetScript("OnEvent", function(_, event, unit) --could do based on castid too
		local currentEventId = GetCurrentEventID()
		if lastEventId == currentEventId then
			return
		end
		
		local sourceGUID = UnitGUID(unit)
		local sourceCastTable = activeCasts[sourceGUID]
		if sourceCastTable then
			lastEventId = currentEventId
			for i=1,#sourceCastTable do
				local icon = sourceCastTable[i]
				
				local _, _, _, startTime, endTime = icon.castingInfo(unit)
				if startTime then --startTime was nil once
					startTime = startTime/1000
					endTime = endTime/1000
					local duration = endTime-startTime
					icon.startTime = startTime
					icon.expirationTime = endTime
					icon.cooldown:SetCooldown(startTime, duration)
				end
			end
		end
	end)
end


hasuitFramesCenterSetEventType("unitCasting")


danUnitCasting = addMultiFunction(function()
	-- danPrint("danUnitCasting")
	local sourceGUID = UnitGUID(danCurrentUnit)
	if sourceGUID~=hasuitPlayerGUID then
		local destGUID = UnitGUID(danCurrentUnit.."target")
		if destGUID then
			danCurrentFrame = hasuitUnitFrameForUnit[destGUID]
			if danCurrentFrame then
				danCurrentFrameOptionsCommon = danCurrentFrameOptions[danCurrentFrame.unitType]
				if danCurrentFrameOptionsCommon then
					if danCurrentFrameOptions["ignoreSameUnitType"] then
						if hasuitUnitFrameForUnit[sourceGUID] and hasuitUnitFrameForUnit[sourceGUID].unitType==danCurrentFrame.unitType then
							return
						end
					end
					
					if not activeCasts[sourceGUID] then
						if danCurrentEvent=="UNIT_SPELLCAST_START" then
							danCurrentIcon = danGetIcon("unitCasting")
						else
							danCurrentIcon = danGetIcon("channel")
						end
						activeCasts[sourceGUID] = {danCurrentIcon}
						activeCasts[sourceGUID]["startTime"] = GetTime()
					else
						if activeCasts[sourceGUID]["startTime"]~=GetTime() then
							return
						end
						if danCurrentEvent=="UNIT_SPELLCAST_START" then
							danCurrentIcon = danGetIcon("unitCasting")
						else
							danCurrentIcon = danGetIcon("channel")
						end
						tinsert(activeCasts[sourceGUID], danCurrentIcon)
					end
					
					danSharedIconFunction()
					
					local _, _, texture, startTime, endTime = danCurrentIcon.castingInfo(danCurrentUnit)
					
					if not startTime then
						for i=#activeCasts[sourceGUID], 1, -1 do
							local icon = activeCasts[sourceGUID][i]
							icon.cooldown:Clear()
							danCooldownDoneRecycle(icon.cooldown)
						end
						-- danPrint("recycle12")
						activeCasts[sourceGUID] = nil
						return
					end
					
					
					startTime = startTime/1000
					endTime = endTime/1000
					local duration = endTime-startTime
					danCurrentIcon.startTime = startTime
					danCurrentIcon.expirationTime = endTime
					danCurrentIcon.cooldown:SetCooldown(startTime, duration)
					
					danCurrentIcon.iconTexture:SetTexture(texture)
					danCurrentIcon.cooldown:SetScript("OnCooldownDone", function(cooldown)
						activeCasts[sourceGUID] = nil
						danCooldownDoneRecycle(cooldown)
						-- danPrint("recycle1")
					end)
				end
			end
		end
	end
end)













function hideCooldown(icon)
	icon.priority = icon.basePriority+800
	icon:SetAlpha(0)
	icon.alpha = 0
	danCurrentController = icon.controller
	danSortController()
end


do
	--C_PvP.RequestCrowdControlSpell
	--LOSS_OF_CONTROL_UPDATE
	--LOSS_OF_CONTROL_ADDED
	
	local lastEventId
	local GetArenaCrowdControlInfo = C_PvP.GetArenaCrowdControlInfo
	local arenaCrowdControlSpellUpdateFrame = CreateFrame("Frame") --events registered in danCooldownDisplayLoadOn
	hasuitArenaCrowdControlSpellUpdateFrame = arenaCrowdControlSpellUpdateFrame
	arenaCrowdControlSpellUpdateFrame:SetScript("OnEvent", function(_, event, unit, spellId) --bored todo: register and unregister selectively, game fires these a lot for no reason. real todo: arena3 (mage) got their first ARENA_CROWD_CONTROL_SPELL_UPDATE like 10 seconds after coming out of stealth. it didn't show trinket icon on blizzard arena frames until then either. and the mage definitely pressed trinket later in the match. was also already in combat for a while at the time so it wasn't some weird thing where they equipped it after skirmish started. also seems like GetArenaCrowdControlInfo doesn't work outside of reacting to an event even if the relevant event has already happened and trinket has already been shown so maybe change this to assume they have trinket until game says spellid==0. is it possible it didn't show because it was on cd from them equipping it and having the 30s timer? if so could do something with that
		-- danPrint("arenaCrowdControlSpellUpdateFrame", unit..event)
		
		local currentEventId = GetCurrentEventID()
		if lastEventId == currentEventId then
			return
		end
		lastEventId = currentEventId
		
		local frame = hasuitUnitFrameForUnit[unit]
		if frame then
			local icon = frame.cooldowns and frame.cooldowns["pvpTrinket"]
			if icon then
				if event=="ARENA_CROWD_CONTROL_SPELL_UPDATE" then
					if icon.spellId~=spellId then
						icon.iconTexture:SetTexture(GetSpellTexture(spellId))
						icon.spellId = spellId
					end
					
					-- danPrint("GetArenaCrowdControlInfo", GetArenaCrowdControlInfo(unit), unit)
					if spellId==0 then
						if icon.priority<256 then --256 means on cd, 450+base means desaturated(irrelevant here), 800+base means hidden
							hideCooldown(icon)
						end
						
					else
						if icon.priority>50 then --pvp trinket is base -10
							if icon.priority~=256 then
								icon.priority = icon.basePriority
								icon:SetAlpha(1)
								icon.alpha = 1
								-- icon.iconTexture:SetTexture(GetSpellTexture(spellId))
								danCurrentController = icon.controller
								danSortController()
							end
						elseif not icon.expirationTime or icon.expirationTime<GetTime() then
							icon:SetAlpha(1)
							-- icon.iconTexture:SetTexture(GetSpellTexture(spellId))
						end
					end
				elseif event=="ARENA_COOLDOWNS_UPDATE" then
					local arenapet15, milliseconds1, milliseconds2 = GetArenaCrowdControlInfo(unit)
					-- danPrint(event, unit, arenapet15, spellId, milliseconds1, milliseconds2, GetTime(), icon.startTime, icon.expirationTime)
					if arenapet15 then
						if icon.spellId~=arenapet15 then
							icon.iconTexture:SetTexture(GetSpellTexture(arenapet15))
							icon.spellId = arenapet15
						end
					end
					if milliseconds2 then
						milliseconds2 = milliseconds2/1000
						if milliseconds2-GetTime()<1 then --this is needed or trinkets will get low opacity randomly when not used
							return
						end
						milliseconds1 = milliseconds1/1000
						icon.startTime = milliseconds1
						icon.expirationTime = milliseconds1+milliseconds2
						icon.cooldown:SetCooldown(milliseconds1, milliseconds2)
						
						danCurrentController = icon.controller
						danSortController()
						
						startCooldownTimerText(icon)
						icon:SetAlpha(0.5)
					-- elseif arenapet15 then
						-- icon.alpha = 1
						-- icon:SetAlpha(1)
					end
				end
			end
		end
	end)
end
