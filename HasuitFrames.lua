
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

local danCurrentSpellOptions
local danCurrentSpellOptionsCommon
local removedAuraSharedFunction
local updatedAuraSharedFunction

local danUnitAuraIsFullUpdate
-- hasuitSortExpirationTime
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID

local pairs = pairs
local type = type
local select = select
local format = format
local tinsert = tinsert
local tremove = table.remove
local sort = table.sort

local C_Timer_After = C_Timer.After
local C_Timer_NewTimer = C_Timer.NewTimer

local GetSpellName = C_Spell.GetSpellName
local GetSpellTexture = C_Spell.GetSpellTexture
local CreateFrame = CreateFrame
local GetTime = GetTime
local GetCurrentEventID = GetCurrentEventID
local GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
local GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex
local IsInInstance = IsInInstance

local initialize = hasuitFramesInitialize
local hasuitFramesCenterSetEventType = hasuitFramesCenterSetEventType
local hasuitDoThisAddon_Loaded = hasuitDoThisAddon_Loaded








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
                danCurrentSpellOptions = stuff[i]
                danCurrentSpellOptions[1]()
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


function hasuitGetD2anCleuSubevent() --going to get rid of these
    return d2anCleuSubevent
end
function hasuitGetD4anCleuSourceGuid()
    return d4anCleuSourceGuid
end
function hasuitGetD12anCleuSpellId()
    return d12anCleuSpellId
end






local pveAuraSpellOptions
local pveAuraSpellOptionsIsBossAura

local danCurrentUnit
local danCurrentEvent
local danAuraEventActive

local hasuitUnitAuraFunctions = {}
hasuitFramesCenterAddToAllTable(hasuitUnitAuraFunctions, "aura")


do --pve stuff, todo put debuffs that player can dispel at a higher priority
    
    local trackedPveSubevents = {["SPELL_AURA_APPLIED"]={},["SPELL_CAST_SUCCESS"]={},["SPELL_CAST_START"]={},["SPELL_EMPOWER_START"]={}}
    local hasuitCleuSpellIdFunctionsPve = danGetHasuitCleuSpellIdFunctions()
    danGetHasuitCleuSpellIdFunctions = nil
    
    local pveAuraSpellOptionsUnknownType
    local pveCleuINCSpellOptions
    local pveUnitCastSpellOptions
    
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
                danCurrentSpellOptions = stuff[i]
                danCurrentSpellOptions[1]()
            end
        end
        
        local trackedPveSpells = trackedPveSubevents[d2anCleuSubevent]
        if trackedPveSpells and not trackedPveSpells[d12anCleuSpellId] then
            if band(d6anCleuSourceFlags, COMBATLOG_OBJECT_CONTROL_MASK)==COMBATLOG_OBJECT_CONTROL_PLAYER then
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
                        if d15anCleuOther=="DEBUFF" then
                            hasuitFramesCenterSetEventType("aura")
                            hasuitSetupSpellOptions = pveAuraSpellOptionsUnknownType
                            initialize(d12anCleuSpellId)
                        end
                        
                    elseif d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
                        if not isChanneled then
                            hasuitFramesCenterSetEventType("cleu")
                            hasuitSetupSpellOptions = pveCleuINCSpellOptions
                            initialize(d12anCleuSpellId)
                            danCurrentSpellOptions = pveCleuINCSpellOptions
                            danCurrentSpellOptions[1]()
                        else
                            danCurrentEvent = "UNIT_SPELLCAST_CHANNEL_START"
                            hasuitFramesCenterSetEventType("unitCasting")
                            hasuitSetupSpellOptions = pveUnitCastSpellOptions
                            initialize(d12anCleuSpellId)
                            danCurrentSpellOptions = pveUnitCastSpellOptions
                            danCurrentSpellOptions[1]()
                        end
                        
                    elseif d2anCleuSubevent=="SPELL_CAST_START" then --todo pve version that switches targets, todo different border color for these?
                        danCurrentEvent = "UNIT_SPELLCAST_START"
                        hasuitFramesCenterSetEventType("unitCasting")
                        hasuitSetupSpellOptions = pveUnitCastSpellOptions
                        initialize(d12anCleuSpellId)
                        danCurrentSpellOptions = pveUnitCastSpellOptions
                        danCurrentSpellOptions[1]()
                        
                    elseif d2anCleuSubevent=="SPELL_EMPOWER_START" then --todo pve version that switches targets, also options to not track? castbar inc stuff isn't reliable anymore in pve but nice to see casts on frames even if the dest target isn't right? INC will always be right
                        danCurrentUnit = hasuitFramesCenterNamePlateGUIDs[d4anCleuSourceGuid]
                        danCurrentEvent = "UNIT_SPELLCAST_EMPOWER_START"
                        hasuitFramesCenterSetEventType("unitCasting")
                        hasuitSetupSpellOptions = pveUnitCastSpellOptions
                        initialize(d12anCleuSpellId)
                        danCurrentSpellOptions = pveUnitCastSpellOptions
                        danCurrentSpellOptions[1]()
                        
                    end
                end
            end
        end
    end
    
    
    
    
    
    do --loadon for pve, todo fully delete all saved pve stuff on unload? 
        local loadOn = {}
        local function loadOnCondition()
            local instanceId = hasuitInstanceId
            local instanceType = hasuitInstanceType
            if instanceType=="none" or instanceType=="party" or instanceType=="raid" or instanceType=="scenario" or instanceId==2177 then --should load, --2177 is comp stomp, untested, pve mobs spellids in comp stomp are all different than pvp so nothing will show up without considering it to be pve
                if not loadOn.shouldLoad then
                    danGeneralCleuFrameSetScriptOnEvent(pveCleuFunc)
                    loadOn.shouldLoad = true
                    if instanceId==2177 then --assuming instanceid will almost never be used for anything, also assuming i got this part right, atm any instance type change will prompt a main loadon function but instanceid change won't. so if going from instancetype pvp directly into a comp stomp the pve loadon needs this to properly run the main function. maybe impossible and group size would probably take care of it anyway, but this should be solid.. should probably make this setup less complicated. it's kind of simple in that every other load condition except instancetype changing needs to call the main loadon function when a .shouldLoad changes but ya we'll see in the future i guess, or if someone else tries to make a loadon and hates it
                        hasuitMainLoadOnFunctionSpammable()
                    end
                end
            else --should NOT load
                if loadOn.shouldLoad~=false then
                    danGeneralCleuFrameSetScriptOnEvent()
                    loadOn.shouldLoad = false
                end
            end
        end
        tinsert(hasuitDoThisPlayer_Entering_WorldSkipsFirst, loadOnCondition)
        loadOnCondition()
        hasuitLoadOn_EnablePve = loadOn
    end
    local hasuitLoadOn_EnablePve = hasuitLoadOn_EnablePve
    
    
    
    local danCommonPveAura =            {["size"]=16,   ["hideCooldownText"]=true,  ["alpha"]=1}
    local danCommonPveAuraIsBossAura =  {["size"]=22,   ["hideCooldownText"]=true,  ["alpha"]=1}
    pveAuraSpellOptions =               {["priority"]=480,  ["group"]=danCommonPveAura, ["loadOn"]=hasuitLoadOn_EnablePve}
    pveAuraSpellOptionsIsBossAura =     {["priority"]=470,  ["group"]=danCommonPveAuraIsBossAura, ["loadOn"]=hasuitLoadOn_EnablePve} --todo should pve debuffs be guaranteed to show up? could make something to make them smaller to fit on frames if they go over a limit, in instance not in open world
    pveAuraSpellOptionsUnknownType =    {}
    
    local danCommonPveCleuINC =         {["size"]=14,   ["hideCooldownText"]=true,  ["alpha"]=1}
    pveCleuINCSpellOptions =            {["priority"]=490,  ["group"]=danCommonPveCleuINC,["duration"]=2.5,["isPve"]=true, ["loadOn"]=hasuitLoadOn_EnablePve} --todo fix
    
    local danCommonPveUnitCast =        {["size"]=12,   ["hideCooldownText"]=true,  ["alpha"]=1}
    pveUnitCastSpellOptions =           {["priority"]=495,  ["group"]=danCommonPveUnitCast, ["loadOn"]=hasuitLoadOn_EnablePve}
    
    tinsert(hasuitDoThisAddon_Loaded, function()
        danCommonPveAura["controller"] = hasuitController_TopRight_TopRight
        danCommonPveAuraIsBossAura["controller"] = hasuitController_TopRight_TopRight
        pveAuraSpellOptions[1] = hasuitSpellFunction_AuraMainFunction
        pveAuraSpellOptionsIsBossAura[1] = hasuitSpellFunction_AuraMainFunction
        pveAuraSpellOptionsUnknownType[1] = hasuitSpellFunction_AuraMainFunctionPveUnknown
        
        danCommonPveCleuINC["controller"] = hasuitController_TopRight_TopRight
        pveCleuINCSpellOptions[1] = hasuitSpellFunction_CleuINC
        
        danCommonPveUnitCast["controller"] = hasuitController_TopRight_TopRight
        pveUnitCastSpellOptions[1] = hasuitSpellFunction_UnitCasting
    end)
    
    
    hasuitFramesCenterSetEventType("aura") -- ___ manual pve track/ignore list here
    hasuitSetupSpellOptions = pveAuraSpellOptions
    initialize(422806) --Smothering Shadows (99% damage/healing reduced in the cave)
    trackedPveSubevents["SPELL_AURA_APPLIED"][422806] = true --prevents pve cleu from auto tracking this spellid when seen. it already doesn't but if they change the way it's coded i won't notice, or if m+ changes it or whatever. this debuff's sourceguid/band== thing is messed up which is why it doesn't auto track, not totally sure what's happening with it. most actual pve debuffs that get ignored like this seem bad to track anyway so not sure what's best to do here, also stuff like heroism debuff and pve potions get filtered out from this which is good. can get a better opinion over time
    
end



local addMultiFunction = hasuitFramesCenterAddMultiFunction



do --breakable cc threshhold bar, trolled and thought more than 1 unit_health could happen on a frame but looks like it's capped to that so heal and damage on the same gettime will make this inaccurate. looks like the only way to do it right is cleu, will want cleu for fake karma absorb/ray of hope too at least. this way of doing it was(is) also bad because of absorbs falling off and counting like they took that as actual damage, also damage on a 1 health target that can't die. also good in some ways like it'll show on someone too far away to be giving cleu events?
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
            end
        elseif event=="UNIT_ABSORB_AMOUNT_CHANGED" then
            local currentAbsorbs = UnitGetTotalAbsorbs(unit)
            local absorbChange = currentAbsorbs - ccBreakBar.ccBreakAbsorbValue
            ccBreakBar.ccBreakAbsorbValue = currentAbsorbs
            if absorbChange<0 then
                local newValue = ccBreakBar.ccBreakThresholdValue+absorbChange
                ccBreakBar.ccBreakThresholdValue = newValue
                ccBreakBar:SetValue(newValue)
            end
        elseif event=="UNIT_MAXHEALTH" then --try to cancel out health changes from max health events assuming unit_health will fire too with a changed health that didn't come from damage taken, never tested this and not sure exactly how maxhealth events happen now
            local currentHealth = UnitHealth(unit)
            local healthChange = -(currentHealth - ccBreakBar.ccBreakHealthValue)
            ccBreakBar.ccBreakHealthValue = currentHealth
            if healthChange>0 then
                local newValue = ccBreakBar.ccBreakThresholdValue+healthChange
                ccBreakBar.ccBreakThresholdValue = newValue
                ccBreakBar:SetValue(newValue)
            end
        end
    end
    hasuitCcBreakOnEvent = ccBreakOnEvent
    local ccBreakHealthThreshold = hasuitCcBreakHealthThreshold
    local ccBreakHealthThresholdPve = hasuitCcBreakHealthThresholdPve
    tinsert(hasuitDoThisPlayer_Entering_WorldFirstOnly, function()
        ccBreakHealthThreshold = hasuitCcBreakHealthThreshold
        ccBreakHealthThresholdPve = hasuitCcBreakHealthThresholdPve
    end)
    local function ccBreakBarUpdatedEventFromFullUpdate(ccBreakBar)
        if ccBreakBar.fullUpdateActive then
            local unit = ccBreakBar.frame.unit
            if unit then
                ccBreakBar.unit = unit
                ccBreakOnEvent(ccBreakBar, "UNIT_HEALTH", unit)
                ccBreakOnEvent(ccBreakBar, "UNIT_ABSORB_AMOUNT_CHANGED", unit)
                -- ccBreakOnEvent(ccBreakBar, "UNIT_MAXHEALTH", unit)
                ccBreakBar:RegisterUnitEvent("UNIT_HEALTH", unit)
                ccBreakBar:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", unit)
                ccBreakBar:RegisterUnitEvent("UNIT_MAXHEALTH", unit)
            end
        end
    end
    function hasuitSpecialAuraFunction_CcBreakThreshold()
        local danCurrentEvent = danCurrentEvent
        if danCurrentEvent=="recycled" then
            local ccBreakBar = danCurrentIcon.ccBreakBar
            ccBreakBar.unit = nil
            ccBreakBar.fullUpdateActive = nil
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
                local ccBreakBarMaxValue = ccBreakHealthThreshold*danCurrentSpellOptions["ccBreakHealthThresholdMultiplier"]
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
                    if ccBreakBars[frameKey] then
                        ccBreakBars[frameKey].frameKey = nil
                        -- hasuitDoThisEasySavedVariables("already have ccBreakBars[frameKey] 1")
                        danCurrentFrame.ccBreakBarsCount = danCurrentFrame.ccBreakBarsCount - 1
                    end
                    ccBreakBars[frameKey] = ccBreakBar
                    ccBreakBar.frameKey = frameKey
                    -- if sourceUnit=="" then
                        -- hasuitDoThisEasySavedVariables("sourceUnit empty string")
                    -- end
                else
                    -- hasuitDoThisEasySavedVariables("aura no sourceUnit")
                    local frameKey = spellId
                    if ccBreakBars[frameKey] then --unit_aura not giving a source guid sucks
                        ccBreakBars[frameKey].frameKey = nil
                        -- hasuitDoThisEasySavedVariables("already have ccBreakBars[frameKey] 2")
                        danCurrentFrame.ccBreakBarsCount = danCurrentFrame.ccBreakBarsCount - 1
                    end
                    ccBreakBars[frameKey] = ccBreakBar
                    ccBreakBar.frameKey = frameKey
                end
                
                ccBreakBar.ccBreakHealthValue = startingHealth
                ccBreakBar.ccBreakAbsorbValue = startingAbsorb
                local colors = iconTypes[danCurrentAura["dispelName"] or ""]
                danCurrentIcon.border:SetBackdropBorderColor(colors.r,colors.g,colors.b)
                ccBreakBar:SetStatusBarColor(colors.r,colors.g,colors.b)
                if danCurrentAura["duration"]<13 then
                    local startingValue = ccBreakBarMaxValue+startingValueOffset
                    ccBreakBar:SetValue(startingValue) --gear doesn't matter, can be naked and still have the same amount of damage to break on a training dummy anyway
                    ccBreakBar.ccBreakThresholdValue = startingValue
                else
                    local startingValue = ccBreakHealthThresholdPve*danCurrentSpellOptions["ccBreakHealthThresholdMultiplier"]+startingValueOffset
                    ccBreakBar:SetValue(startingValue) --pve durations? won't be great because not every cc is shorter in pvp like frost nova, just get rid of this after, temporary?
                    ccBreakBar.ccBreakThresholdValue = startingValue
                end
                ccBreakBar:RegisterUnitEvent("UNIT_HEALTH", unit)
                ccBreakBar:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", unit)
                ccBreakBar:RegisterUnitEvent("UNIT_MAXHEALTH", unit)
                ccBreakBar.unit = unit
                ccBreakBar.ccBreakSpellName = danCurrentAura["name"]
                ccBreakBar.frame = danCurrentFrame
            end
        else
            if danCurrentEvent=="updated" then --always means fullupdate(right?) which is where unit could change i think?
                local ccBreakBar = danCurrentIcon.ccBreakBar
                ccBreakBar.fullUpdateActive = true
                ccBreakBar:UnregisterAllEvents() --could be improved. something like this is a good reason to remove delay from main unittype update functions? should probably do that actually. not a fan of needing to unregister and reregister events every time here although probably not that bad. this could definitely be improved
                C_Timer_After(0, function()
                    ccBreakBarUpdatedEventFromFullUpdate(ccBreakBar) --ok idk what im doing here, should work itself out when improving things later
                end)
                
            elseif danCurrentEvent=="added" then --todo i don't think this is right
                local ccBreakBar = danCurrentIcon.ccBreakBar
                ccBreakBar.specialFunction = nil
                ccBreakBar:SetValue(0) --could do something like make bar red and reversed when it goes over the threshhold but idk might be noise more than anything. seems like ccs that can break always take at least a certain amount of damage before breaking but after that number it's rng. not sure exactly how it works
            end
        end
    end
    
    
    
    local danDoThisOnUpdate = hasuitDoThisOnUpdate
    hasuitFramesCenterSetEventType("cleu")
    hasuitSpellFunction_CleuCcBreakThreshold = addMultiFunction(function()
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
            
        elseif d2anCleuSubevent=="SPELL_AURA_REFRESH" then
            local frame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
            if frame then
                local ccBreakBars = frame.ccBreakBars
                if ccBreakBars then
                    local ccBreakBar = frame.ccBreakBars[d4anCleuSourceGuid..d12anCleuSpellId] or ccBreakBars[d12anCleuSpellId] --works out decently even with no sourceunit, only problem i can think of is a duplicate spellid replacing an older one, deleting its spot in this table, and then a third dr will have no way of getting set right because the unitaura event will be an updated instead of added. would have to iterate through and match instanceids or something like that, or do a fake added event with the ccbreakbar function. or better yet iterate through the instanceids of the unitframe and find the one(s) for the relevant spellid that isn't on the unitframe yet
                    if ccBreakBar then
                        local unit = frame.unit
                        ccBreakBar.ccBreakHealthValue = UnitHealth(unit)
                        ccBreakBar.ccBreakAbsorbValue = UnitGetTotalAbsorbs(unit)
                        local startingValue = ccBreakHealthThreshold*danCurrentSpellOptions["ccBreakHealthThresholdMultiplier"]
                        ccBreakBar:SetValue(startingValue)
                        ccBreakBar.ccBreakThresholdValue = startingValue
                    end
                end
            end
        end
    end)
end


hasuitFramesCenterSetEventType("aura")





















local startCooldownTimerText

updatedAuraSharedFunction = function()
    local expirationTime = danCurrentAura["expirationTime"]
    local startTime = expirationTime-danCurrentAura["duration"]
    
    danCurrentIcon.startTime = startTime
    danCurrentIcon.expirationTime = expirationTime
    
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
hasuitUnitAuraFrame:SetScript("OnEvent", function(_, _, unit, auraTable)
    local currentEventId = GetCurrentEventID()
    if lastEventId == currentEventId then
        return
    end
    lastEventId = currentEventId
    
    
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
            -- if UnitGUID(unit)==hasuitPlayerGUID and danCurrentAura["spellId"]==774 then --dan1
                -- print(hasuitTestAuraTable, danCurrentAura, hasuitTestAuraTable==danCurrentAura)
                -- hasuitTestAuraTable = danCurrentAura
            -- end
            local stuff = hasuitUnitAuraFunctions[danCurrentAura["spellId"]] or hasuitUnitAuraFunctions[danCurrentAura["name"]]
            if stuff then
                danCurrentEvent = "added"
                for j=1, #stuff do 
                    danCurrentSpellOptions = stuff[j]
                    danCurrentSpellOptions[1]()
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
                    
                end
                danCurrentFrame.auraInstanceIDs[auraInstanceID] = nil
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
    
    danAuraEventActive = false
    
    if auraTable.isFullUpdate then
        danUnitAuraIsFullUpdate()
    end
end)











































function danUnitAuraIsFullUpdate()
    local unit = danCurrentFrame.unit
    local unitGUID = UnitGUID(unit)
    if unitGUID ~= danCurrentFrame.unitGUID then
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
                        danCurrentSpellOptions = stuff[j]
                        danCurrentSpellOptions[1]()
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
function hasuitUnitAuraIsFullUpdate(frame)
    danCurrentFrame = frame
    danUnitAuraIsFullUpdate()
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


    local textOptionsTable = { --todo remake the way text works
        [11] =              {danFont11,                                                                         ["xOffset"]=2,  ["yOffset"]=0},
        
        ["KICKArena"]=      {danFont11, 0.8, 0.8, 0.8, 0.8, ["ownPoint"]="BOTTOM",  ["targetPoint"]="BOTTOM",   ["xOffset"]=2,  ["yOffset"]=1},
        ["KICKRbg"] =       {danFont7,                      ["ownPoint"]="BOTTOM",  ["targetPoint"]="BOTTOM",   ["xOffset"]=2,  ["yOffset"]=1},
        
        ["cdProc"]=         {danFont10, 0.8, 0.8, 0.8, 0.8, ["ownPoint"]="BOTTOM",  ["targetPoint"]="BOTTOM",   ["xOffset"]=2,  ["yOffset"]=1},
        ["rootArena"]=      {danFont10, 0.8, 0.8, 0.8, 0.8, ["ownPoint"]="BOTTOM",  ["targetPoint"]="BOTTOM",   ["xOffset"]=2,  ["yOffset"]=6},
        ["rootRbg"] =       {danFont6,                      ["ownPoint"]="BOTTOM",  ["targetPoint"]="BOTTOM",   ["xOffset"]=2,  ["yOffset"]=1},
        
        ["pointsTextWeakness"]={danFont7,                   ["ownPoint"]="BOTTOM",  ["targetPoint"]="BOTTOM",   ["xOffset"]=2,  ["yOffset"]=1},
        
        ["danFontOrbOfPower"]={danFont9,                    ["ownPoint"]="TOP",     ["targetPoint"]="BOTTOM",   ["xOffset"]=1,  ["yOffset"]=-1},
        
        ["INC5"] =          {danFont5,                      ["ownPoint"]="BOTTOM",  ["targetPoint"]="BOTTOM",   ["xOffset"]=2,  ["yOffset"]=1},
        ["INC10"] =         {danFont10,                     ["ownPoint"]="BOTTOM",  ["targetPoint"]="BOTTOM",   ["xOffset"]=2,  ["yOffset"]=1},
        
        
    }
    for k in pairs(textOptionsTable) do
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
            
            local textOptions = textOptionsTable[textType]
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
            local textFrame = danGetText(textType)
            local text = textFrame.text
            danCurrentIcon.textFrame = textFrame
            danCurrentIcon.text = text
            textFrame:SetParent(danCurrentIcon)
            textFrame:SetAllPoints()
            textFrame:SetAlpha(1)
            text:SetText(s)
        else
            text:SetText(s)
        end
    end
    function hasuitSetIconText(icon, textType, s)
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
        
        icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
            cooldownText:SetFormattedText("%.1f", expirationTime-GetTime())
        end, 28)
        
    end
    
    local function setCooldownTextGreen2(timer)
        local icon = timer.icon
        local cooldownText = icon.cooldownText
        local expirationTime = icon.expirationTime
        local timeLeft = expirationTime-GetTime()
        cooldownText:SetFormattedText("%.1f", timeLeft)
        
        
        local numTicksTotal = (timeLeft-timeLeft%0.1)*10-1
        if numTicksTotal>=1 then
            if numTicksTotal>=29 then --why is 28>28?
                local numTicksPartial = numTicksTotal-28
                
                icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
                    cooldownText:SetFormattedText("%.1f", expirationTime-GetTime())
                end, numTicksPartial) --what happens if you put a fraction here? could that have been an easier way to get these to start ticking at the right time?
                
                icon.cooldownTextTimer2 = C_Timer_NewTimer(timeLeft-2.9, setCooldownTextGreen3) --28
                icon.cooldownTextTimer2.icon = icon
            else
                icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
                    cooldownText:SetFormattedText("%.1f", expirationTime-GetTime())
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
        
        
        if timeLeft>0 then
            local timeLeftRemainder = timeLeft%0.1
            if timeLeftRemainder<0.008 then --GetFramerate?
                local numTicksTotal = (timeLeft-timeLeftRemainder)*10-1
                if numTicksTotal>=1 then
                    if numTicksTotal>=29 then --28
                        local numTicksPartial = numTicksTotal-28
                        
                        icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
                            cooldownText:SetFormattedText("%.1f", expirationTime-GetTime()) --significant lag makes the other way become very inaccurate for these 0.1 tickers although the other way would be fine most of the time
                        end, numTicksPartial)
                        
                        icon.cooldownTextTimer2 = C_Timer_NewTimer(timeLeft-2.9, setCooldownTextGreen3) --28
                        icon.cooldownTextTimer2.icon = icon
                    else
                        
                        icon.cooldownTextTimer1 = C_Timer_NewTicker(0.1, function()
                            cooldownText:SetFormattedText("%.1f", expirationTime-GetTime())
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
        if numTicks>0 then
            
            icon.cooldownTextTimer1 = C_Timer_NewTicker(1, function() --could put this in icon scope and not need to make a new function for every new ticker without losing anything other than a little memory? not sure how much it matters or if it would even be better, might be better tho
                timeLeft = timeLeft-1
                cooldownText:SetText(timeLeft)
            end, numTicks)
            
        end
        if timer.yellow then
            icon.cooldownTextTimer2 = C_Timer_NewTimer(numTicks+1, setCooldownTextGreen1)
        else
            icon.cooldownTextTimer2 = C_Timer_NewTimer(numTicks-13, setCooldownTextWhiteOrYellowTimer2)
        end
        icon.cooldownTextTimer2.icon = icon
    end
    
    
    function startCooldownTimerText(icon)
        icon.cooldownTextTimer1:Cancel() --there's probably a better way to do the cancels especially now that there are 2 timers
        icon.cooldownTextTimer2:Cancel()
        local timeLeft = icon.expirationTime-GetTime()
        
        if timeLeft>5.5 then --yellow or white
            icon.cooldownText:SetFormattedText("%.0f", timeLeft)
            
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
        if #unusedIcons[iconType]>0 then
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
                ccBreakBar:SetFrameLevel(25) --how does this interact when framelevel doesn't get set on icon until it gets setparent to frame?
                ccBreakBar:SetScript("OnEvent", ccBreakOnEvent)
                local background = ccBreakBar:CreateTexture(nil, "BACKGROUND")
                ccBreakBar.background = background
                background:SetAllPoints()
                background:SetColorTexture(0,0,0)
                
            end
            
            --todo reset cds when entering arena?
            
            cooldown.noCooldownCount = true  --this is to prevent omnicc from putting a timer on the icon, bored todo only have this in the function if omnicc is loaded
            cooldown:SetHideCountdownNumbers(true)
            
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




function danCooldownDoneRecycle(cooldown)
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
    danCurrentFrame.controllersPairs[controllerOptions] = CreateFrame("Frame", nil, danCurrentFrame)
    local controller = danCurrentFrame.controllersPairs[controllerOptions]
    controller:SetFrameLevel(controllerOptions["frameLevel"])
    tinsert(danCurrentFrame.controllersArray, controller)
    controller.options = controllerOptions
    controller.grow = controllerOptions["grow"]
    controller.setPointOn = controllerOptions["setPointOnBorder"] and danCurrentFrame.border or danCurrentFrame
    controller.frames = {}
    
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
    danCurrentFrame = frame
    return initializeController(controllerOptions)
end

function danAddToController() --this was the very first system made for the addon, just rejuvenations growing in 4 different directions at the top right of a healthbar
    local controllerOptions = danCurrentSpellOptionsCommon["controller"]
    danCurrentController = danCurrentFrame.controllersPairs[controllerOptions]
    if not danCurrentController then
        danCurrentController = initializeController(controllerOptions)
    end
    danCurrentIcon.controller = danCurrentController
    tinsert(danCurrentController.frames, danCurrentIcon)
    danSortController()
end
danSortController = function(self)
    if not self then
        if not danCurrentController.doingSomething then 
            danCurrentController:SetScript("OnUpdate", danSortController)
            danCurrentController.doingSomething = danSortController
        end
        return
    end
    self:SetScript("OnUpdate", nil)
    self.doingSomething = false
    
    self.grow(self)
end

function hasuitCleanController(controller)
    danCurrentController = controller
    danCleanController()
end
function hasuitSortController(controller) --todo
    danCurrentController = controller
    danSortController()
end


hasuitSort = function(a,b)
    if a.priority<b.priority then
        return true
    elseif a.priority==b.priority then
        if a.overridesSame then
            if a.expirationTime>b.expirationTime then
                if a.overridden then
                    if a.overridden.expirationTime<a.expirationTime then
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
hasuitSortExpirationTime = function(a,b)
    return a.expirationTime<b.expirationTime
end
hasuitSortPriorityExpirationTime = function(a,b)
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

    function hasuitNormalGrow(controller) --todo this is an easy place to get performance probably, along with better sort functions --the new non-arena target count is by far the most important thing now
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
        
        
        
        local xLimit = o["xLimit"]*danCurrentUnitFrameWidth
        local yLimit = o["yLimit"]*danCurrentUnitFrameHeight
        local yMinimum = o["yMinimum"]
        local ownPoint = o["ownPoint"]
        local setPointOn = controller.setPointOn
        local targetPoint = o["targetPoint"]
        
        local highestY = 0
        local frames = controller.frames
        local limitReached = false
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
                            limitReached = true
                        end
                    end
                    currentXPlacement = startingX
                    currentYPlacement = currentYPlacement+highestY
                    highestY = nextYPlacement
                end
                if y>yMinimum and currentYPlacement+nextYPlacement>yLimit then
                    limitReached = true
                end
                if not limitReached then 
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
                end
            else
                icon.cooldownText:Hide()
                icon:SetAlpha(0)
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








local function danSharedIconFunction()
    danAddToController()
    danCurrentIcon:SetParent(danCurrentController)
    danCurrentIcon:ClearAllPoints()
    danCurrentIcon.size = danCurrentSpellOptionsCommon["size"]
    danCurrentIcon:SetSize(danCurrentIcon.size, danCurrentIcon.size)
    danCurrentIcon.alpha = danCurrentSpellOptionsCommon["alpha"]
    danCurrentIcon:SetAlpha(danCurrentIcon.alpha)
    danCurrentIcon.priority = danCurrentSpellOptions["priority"]
    danCurrentIcon.overridesSame = danCurrentSpellOptions["overridesSame"]
    danCurrentIcon.active = true
end

local danMainAuraFunction
do
    local function auraExpiredOnHide(cooldown) --if cooldown timer runs out before aura removed event it will keep cd dark briefly instead of the normal wow behavior of it lighting up at the end of its duration sometimes
        if cooldown.auraExpiredEarlyCount<5 then
            cooldown.auraExpiredEarlyCount = cooldown.auraExpiredEarlyCount+1
            cooldown:Show()
        end
    end
    local function auraExpiredOnCooldownDone(cooldown)
        -- if cooldown.auraExpiredEarlyCount then
            -- hasuitDoThisEasySavedVariables("cooldown.auraExpiredEarlyCount") --not sure what goes wrong here but this happens
        -- end
        cooldown.auraExpiredEarlyCount = 0
        cooldown:SetScript("OnHide", auraExpiredOnHide)
    end
    
    -- hasuitFramesCenterSetEventType("aura")
    hasuitSpellFunction_AuraMainFunction = addMultiFunction(function()
        danCurrentSpellOptionsCommon = danCurrentSpellOptions[danCurrentFrame.unitType]
        if not danCurrentSpellOptionsCommon then
            return
        end
        danCurrentIcon = danGetIcon(danCurrentSpellOptionsCommon["specialIconType"] or danCurrentSpellOptions["specialIconType"] or danCurrentAura["isHelpful"] or danCurrentAura["dispelName"] or "") --todo mainaurafunction should be broken up and icon should be made in another function/other useful things
        danSharedIconFunction()
        danCurrentIcon.iconTexture:SetTexture(danCurrentAura["icon"])
        local expirationTime = danCurrentAura["expirationTime"]
        danCurrentIcon.expirationTime = expirationTime
        danCurrentIcon.startTime = expirationTime-danCurrentAura["duration"]
        local cooldown = danCurrentIcon.cooldown
        cooldown:SetCooldown(danCurrentIcon.startTime, danCurrentAura["duration"])
        
        if not danCurrentSpellOptionsCommon["hideCooldownText"] then
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
        
        if danCurrentSpellOptions["textKey"] then
            danSetIconText(danCurrentSpellOptions["textKey"], danCurrentSpellOptions["actualText"])
        elseif danCurrentAura["applications"]>0 then
            if danCurrentAura["applications"]>1 then
                danSetIconText(11, danCurrentAura["applications"])
            else
                danSetIconText(11, "")
            end
        end
        
        local specialFunction = danCurrentSpellOptions["specialAuraFunction"]
        if specialFunction then
            danCurrentIcon.specialFunction = specialFunction
            specialFunction()
        end
    end)
    danMainAuraFunction = hasuitSpellFunction_AuraMainFunction
end

function hasuitSpellFunction_AuraMainFunctionPveUnknown()
    local spellId = danCurrentAura["spellId"]
    if danCurrentAura["isBossAura"] then
        hasuitUnitAuraFunctions[spellId][#hasuitUnitAuraFunctions[spellId]] = pveAuraSpellOptionsIsBossAura --don't need something like pveIsBossAuraTemporaryIndexTracking[d12anCleuSpellId] = #hasuitUnitAuraFunctions[d12anCleuSpellId] for the cleu. only one spellid per subevent gets tracked anyway and then future ones get ignored in the tracking part of pve cleu
        danCurrentSpellOptions = pveAuraSpellOptionsIsBossAura
    else
        hasuitUnitAuraFunctions[spellId][#hasuitUnitAuraFunctions[spellId]] = pveAuraSpellOptions
        danCurrentSpellOptions = pveAuraSpellOptions
    end
    danMainAuraFunction()
end

hasuitSpellFunction_AuraSourceIsPlayer = addMultiFunction(function()
    if danCurrentAura["sourceUnit"]=="player" then
        danMainAuraFunction()
    end
end)
function hasuitSpellFunction_AuraSourceIsPlayerAndHarmful()
    if danCurrentAura["sourceUnit"]=="player" and danCurrentAura["isHarmful"] then
        danMainAuraFunction()
    end
end
function hasuitSpellFunction_AuraSourceIsPlayerAndHelpful()
    if danCurrentAura["sourceUnit"]=="player" and danCurrentAura["isHelpful"] then
        danMainAuraFunction()
    end
end

hasuitSpellFunction_AuraSourceIsNotPlayer = addMultiFunction(function() --todo something similar to pve boss aura function to decide whether to give spell this function or skip it if class can't cast it anyway? or an alt initialize function, not sure exactly what i was thinking here but something during initialize to decide this is probably best? pve boss aura thing doesn't seem like it'd be useful here
    if danCurrentAura["sourceUnit"]~="player" then
        danMainAuraFunction()
    end
end)
hasuitAuraIsDebuffOnly = addMultiFunction(function()
    if danCurrentAura["isHarmful"] then
        danMainAuraFunction()
    end
end)
hasuitSpellFunction_AuraPoints1Required = addMultiFunction(function()
    if danCurrentAura["points"][1]==danCurrentSpellOptions["points1"] then
        danMainAuraFunction()
    end
end)
hasuitSpellFunction_AuraPoints2Required = addMultiFunction(function()
    if danCurrentAura["points"][2]==danCurrentSpellOptions["points2"] then
        danMainAuraFunction()
    end
end)




--[[
danAuraMissingFunction = addMultiFunction(function(icon)
    danCurrentIcon = danGetIcon("missing")
    danSharedIconFunction()
    danCurrentIcon.iconTexture:SetTexture(danCurrentAura["icon"])
    local expirationTime = danCurrentAura["expirationTime"]
    danCurrentIcon.expirationTime = expirationTime
    danCurrentIcon.startTime = expirationTime-danCurrentAura["duration"]
    local cooldown = danCurrentIcon.cooldown
    cooldown:SetCooldown(danCurrentIcon.startTime, danCurrentAura["duration"])
    
    if not danCurrentSpellOptionsCommon["hideCooldownText"] then
        danCurrentIcon.cooldownText:SetFontObject(cooldownTextFonts[danCurrentIcon.size])
        startCooldownTimerText(danCurrentIcon)
        danCurrentIcon.cooldownTextShown = true
    else
        danCurrentIcon.cooldownText:SetText("")
    end
    
    cooldown:SetScript("OnCooldownDone", auraExpiredOnCooldownDone)
    local auraInstanceID = danCurrentAura["auraInstanceID"]
    if not danCurrentFrame.auraInstanceIDs[auraInstanceID] then
        danCurrentFrame.auraInstanceIDs[auraInstanceID] = {danCurrentIcon}
    else
        tinsert(danCurrentFrame.auraInstanceIDs[auraInstanceID], danCurrentIcon)
    end
    
    if danCurrentSpellOptions["textKey"] then
        danSetIconText(danCurrentSpellOptions["textKey"], danCurrentSpellOptions["actualText"])
    elseif danCurrentAura["applications"]>0 then
        if danCurrentAura["applications"]>1 then
            danSetIconText(11, danCurrentAura["applications"])
        else
            danSetIconText(11, "")
        end
    end
    
    local specialFunction = danCurrentSpellOptions["specialAuraFunction"]
    if specialFunction then
        danCurrentIcon.specialFunction = specialFunction
        specialFunction()
    end
end)


danAuraMissingFunctionHidesWhileActive = addMultiFunction(function()
    danCurrentSpellOptionsCommon = danCurrentSpellOptions[danCurrentFrame.unitType]
    if danCurrentSpellOptionsCommon then
        
    end
end)
]]



local function hypo2ndTimerThing(icon, cooldownExpirationTime)
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



local function auraRemovedHypoCooldownFunction(frame)
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
hasuitSpellFunction_AuraHypoCooldownFunction = addMultiFunction(function()
    if danCurrentFrame.unitClass==danCurrentSpellOptions["unitClass"] then
        local cooldowns = danCurrentFrame.cooldowns
        if cooldowns then
            danCurrentFrame.hypoSpellId = danCurrentAura["spellId"]
            danCurrentFrame.specialAuraInstanceIDsRemove[danCurrentAura["auraInstanceID"]] = auraRemovedHypoCooldownFunction
            danCurrentFrame.specialAuras[danCurrentFrame.hypoSpellId] = danCurrentAura["auraInstanceID"]
            local affectedSpells = danCurrentSpellOptions["affectedSpells"]
            danCurrentFrame.hypoAffectedSpells = affectedSpells
            danCurrentFrame.hypoAffectedSpellsPairs = danCurrentSpellOptions["affectedSpellsPairs"]
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
hasuitSpellFunction_AuraPoints1CooldownReduction = addMultiFunction(function()
    if danCurrentEvent=="added" and danAuraEventActive and danCurrentAura["points"][1]==danCurrentSpellOptions["points1"] then --could be better since this won't correct itself if the aura was put on a unit not visible to player at time of cast. could do something to keep track of that and make it not a problem
        danCooldownReductionFunction()
    end
end)
hasuitSpellFunction_AuraPoints2CooldownReduction = addMultiFunction(function()
    if danCurrentEvent=="added" and danAuraEventActive and danCurrentAura["points"][2]==danCurrentSpellOptions["points2"] then
        danCooldownReductionFunction()
    end
end)

hasuitSpellFunction_AuraPoints2CooldownReductionExternal = addMultiFunction(function()
    if danCurrentEvent=="added" and danAuraEventActive and danCurrentAura["points"][2]==danCurrentSpellOptions["points2"] and danCurrentAura["sourceUnit"] then
        local frame = danCurrentFrame
        danCurrentFrame = hasuitUnitFrameForUnit[danCurrentAura["sourceUnit"]] --fml
        if danCurrentFrame then
            danCooldownReductionFunction()
        end
        danCurrentFrame = frame
    end
end)

function hasuitSpellFunction_AuraPoints1HidesOther()
    if danCurrentAura["points"][1]==danCurrentSpellOptions["points1"] then
        local hideSpellId = danCurrentSpellOptions["hideSpellId"]
        local icon = danCurrentFrame.cooldowns[hideSpellId]
        if icon and icon.spellId==hideSpellId then
            icon.priority = icon.basePriority+800
            icon:SetAlpha(0)
            icon.alpha = 0
        end
    end
end

function hasuitSpellFunction_AuraDurationCooldownReduction()
    if danCurrentEvent=="added" and danAuraEventActive and danCurrentAura["duration"]==danCurrentSpellOptions["duration"] and danCurrentAura["sourceUnit"] then
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




    function hasuitSpecialAuraFunction_SmokeBombFunctionForArenaFrames() --only unit aura event exists for this spell atm, no cleu
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
        -- else
            -- hasuitDoThisEasySavedVariables("hasuitSpecialAuraFunction_SmokeBombFunctionForArenaFrames not added")
        end
    end

    function hasuitSpecialAuraFunction_SmokeBombForPlayer()
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
                    arenaUnitFrames[i]:SetAlpha(1)
                    
                    
                    
                    -- local unit = frame.unit
                    -- if unit then
                        -- print(hasuitPurple, unit, "range:", UnitInRange(unit))
                    -- end
                    -- C_Timer_After(0, function()
                        -- if unit then
                            -- print("delay:", hasuitPurple, unit, "range:", UnitInRange(unit))
                        -- end
                    -- end)
                    
                    
                    
                    
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
        -- else
            -- hasuitDoThisEasySavedVariables("hasuitSpecialAuraFunction_SmokeBombForPlayer not added")
        end
    end
end

function hasuitSpecialAuraFunction_ShadowyDuel()
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
function hasuitSpecialAuraFunction_FeignDeath() --todo check for real dead when this falls off? if needed, --feign death
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
        hasuitSpecialAuraFunction_BlessingOfAutumn = nil --bored todo could clean up global table? shouldn't have any value keeping anything there really, plan is for people to put stuff into player login table or similar where it'll all still be available and they can make that stuff local in their own addon, then might as well be removed from global after?
    end)
    local danSpellOptions = {["CDr"]=0.3}
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
        danSpellOptions["affectedSpells"] = affectedSpells
        danCurrentSpellOptions = danSpellOptions
        danCooldownReductionFunction()
    end
    function hasuitSpecialAuraFunction_BlessingOfAutumn() --pretty sure if multiple blessings of autumn can be on someone this setup will still work fine and take them all into account, but we'll see, or not because what 5 man group gets 2 holy paladins that both decide to use it on the same target?
        if danCurrentEvent=="recycled" then
            danCurrentIcon.frame = nil
            danCurrentIcon.blessingOfAutumnTimer:Cancel()
            danCurrentIcon.blessingOfAutumnTimer = nil
            danSpellOptions["affectedSpells"] = nil
            
        elseif danCurrentEvent=="added" then
            local icon = danCurrentIcon
            -- if icon.frame then
                -- hasuitDoThisEasySavedVariables("icon.frame already exists on added?")
            -- end
            
            icon.frame = danCurrentFrame
            local newTimer = C_Timer_NewTimer(0.1, asd) --delaying this is good for 2 things, makes it so changing danCurrentSpellOptions will happen away from unit aura event. that might not matter but will prevent any problems related to that for free, especially in the future if i change something or reuse this for another spell or something, and makes it so that it can be frontloaded and not have to worry about the last tick going 0.3 sec too far, i think, although that might not be true on server lagged auras that don't get a removed event on time, who knows? also what is the point of modrate arg on setcooldown? seems like there's no way to get a cd to just go faster but maybe i'm missing something
            icon.blessingOfAutumnTimer = newTimer
            newTimer.icon = icon
        end
    end
end


function hasuitSpecialAuraFunction_DarkSimShowingWhatGotStolen() --surprised points just tells exactly what spell they got. spent all day making something out of like 10 tellmewhen icons interacting with each other to show reliably what spell got stolen years ago
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
    function hasuitSpecialAuraFunction_OrbOfPower()
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
    function hasuitSpecialAuraFunction_FlagDebuffBg()
        if danCurrentEvent=="updated" or danCurrentEvent=="added" then
            local points1 = danCurrentAura["points"][1]
            local damageTakenIncreasedString = (bgFlagDebuffTextColors[points1] or "|cffff2222")..points1
            danCurrentIcon.text:SetText(damageTakenIncreasedString)
        end
    end
end






















hasuitFramesCenterSetEventType("cleu") --make sure to always check subevent even if a spellid only has one subevent (and a function is made just for that spellid, like solar beam). d 12 can be damage amount from swings. honestly should probably base all cleu and spell_aura stuff on spellname instead of spellid(with GetSpellName on initialize for different languages) and have an ignore list for certain spellids. would make everything easier and even more efficient, especially easier for new spells getting added like oppressing roar randomly has a new spellid that does the same thing in tww. looks like the only difference is one removes 1 enrage effect

hasuitSpellFunction_CleuInterrupted = addMultiFunction(function() --todo could do something with extraSchool 17th parameter
    if d2anCleuSubevent=="SPELL_INTERRUPT" then 
        danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
        if danCurrentFrame then
            danCurrentSpellOptionsCommon = danCurrentSpellOptions[danCurrentFrame.unitType]
            if danCurrentSpellOptionsCommon then
                danCurrentEvent = "KICK"
                danCurrentIcon = danGetIcon("KICK")
                danSharedIconFunction()
                danCurrentIcon.iconTexture:SetTexture(GetSpellTexture(d15anCleuOther))
                local currentTime = GetTime()
                local duration = danCurrentSpellOptions["duration"]
                danCurrentIcon.startTime = currentTime
                danCurrentIcon.expirationTime = currentTime+duration
                danCurrentIcon.cooldown:SetCooldown(currentTime, duration)
                
                if not danCurrentSpellOptionsCommon["hideCooldownText"] then
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
hasuitSpellFunction_CleuINC = addMultiFunction(function() --todo should be remade --especially if there's a way to get things to work right with less specific stuff in the options table, like anything auto tracked in pve
    if d4anCleuSourceGuid~=hasuitPlayerGUID then
        danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
        if danCurrentFrame then
            danCurrentSpellOptionsCommon = danCurrentSpellOptions[danCurrentFrame.unitType]
            if danCurrentSpellOptionsCommon then
                if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
                    danCurrentEvent = "INC"
                    danCurrentIcon = danGetIcon("")
                    danSharedIconFunction()
                    danCurrentIcon.iconTexture:SetTexture(GetSpellTexture(d12anCleuSpellId))
                    local currentTime = GetTime()
                    local duration = danCurrentSpellOptions["duration"]
                    danCurrentIcon.startTime = currentTime
                    danCurrentIcon.expirationTime = currentTime+duration
                    danCurrentIcon.cooldown:SetCooldown(currentTime, duration)
                    
                    
                    
                    danCurrentIcon.cooldown:SetScript("OnCooldownDone", danCooldownDoneRecycle)
                    if danCurrentSpellOptionsCommon["size"]<=20 then
                        danSetIconText("INC5", "INC")
                    else
                        danSetIconText("INC10", "INC")
                    end
                    local spellINCString = danCurrentSpellOptions["ignoreSource"] and d8anCleuDestGuid..d13anCleuSpellName or d4anCleuSourceGuid..d8anCleuDestGuid..d13anCleuSpellName
                    local t = spellINCTable[spellINCString]
                    if not t then
                        spellINCTable[spellINCString] = {}
                        t = spellINCTable[spellINCString]
                    end
                    local icon = danCurrentIcon
                    tinsert(t, icon)
                    icon.cooldown:SetAlpha(0)
                    icon.specialFunction = function() --only happens on recycle
                        icon.text:SetText("")
                        icon.cooldown:SetAlpha(1)
                        for i=1, #t do
                            if t[i]==icon then
                                tremove(t, i)
                                break
                            end
                        end
                        if t and #t==0 then
                            spellINCTable[spellINCString] = nil
                        end
                    end
                    
                elseif 
                not danCurrentSpellOptions["spellINCType"] and d2anCleuSubevent=="SPELL_DAMAGE"
                or d2anCleuSubevent=="SPELL_MISSED" --todo absorbed? 2 different kinds of absorbs and only want to use that if it's a full absorb and prevented a normal damage subevent
                or (danCurrentSpellOptions["spellINCType"]=="aura" or danCurrentSpellOptions["isPve"]) and (d2anCleuSubevent=="SPELL_AURA_APPLIED" or d2anCleuSubevent=="SPELL_AURA_REFRESH" or d2anCleuSubevent=="SPELL_AURA_APPLIED_DOSE")
                then
                    local spellINCString = danCurrentSpellOptions["ignoreSource"] and d8anCleuDestGuid..d13anCleuSpellName or d4anCleuSourceGuid..d8anCleuDestGuid..d13anCleuSpellName
                    local t = spellINCTable[spellINCString]
                    if t and t[1] then
                        t[1].cooldown:Clear()
                        danCooldownDoneRecycle(t[1].cooldown)
                    end
                end
            end
        end
    end
end)

tinsert(hasuitDoThisPlayer_Login, function()
    danPlayerFrame = hasuitPlayerFrame
end)

hasuitSpellFunction_CleuDiminish = addMultiFunction(function()
    danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
    if danCurrentFrame then
        local drType = danCurrentSpellOptions[danCurrentFrame.unitType] or danCurrentFrame==danPlayerFrame and danCurrentSpellOptions["arena"]
        if drType then
            if d2anCleuSubevent=="SPELL_AURA_APPLIED" or d2anCleuSubevent=="SPELL_AURA_REFRESH" then 
                danCurrentEvent = "DR"
                danCurrentIcon = danCurrentFrame.arenaStuff[drType] --dan7
                danCurrentIcon:SetAlpha(1)
                
                local currentTime = GetTime()
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
                danCurrentEvent = "DR"
                danCurrentIcon = danCurrentFrame.arenaStuff[drType]
                if danCurrentIcon.diminishLevel==0 then
                    danCurrentIcon:SetAlpha(1)
                    danCurrentIcon.diminishLevel = 1
                    danCurrentIcon.border:SetBackdropBorderColor(0, 1, 0)
                end
                
                local currentTime = GetTime()
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


local unitKBelongsToV = {} --todo reset on instance changed or something? hopefully all pet stuff will work itself out after adding pet frames
local function hasuitSpellFunction_CleuSpellSummon()
    if d2anCleuSubevent=="SPELL_SUMMON" then
        unitKBelongsToV[d8anCleuDestGuid] = {d4anCleuSourceGuid}
        if danCurrentSpellOptions["npcId"] then
            unitKBelongsToV[d8anCleuDestGuid][2] = hasuitNpcIds[danCurrentSpellOptions["npcId"]]
        end
    end
end
hasuitSetupSpellOptions = {hasuitSpellFunction_CleuSpellSummon, ["npcId"]=417} --no function to get npc id i think, only way is the unitguid string? or tracking it on spell_summon like this
initialize(691) --Summon Felhunter
hasuitSetupSpellOptions = {hasuitSpellFunction_CleuSpellSummon, ["npcId"]=1860}
initialize(697) --Summon Void walker
hasuitSetupSpellOptions = {hasuitSpellFunction_CleuSpellSummon, ["npcId"]=1863}
initialize(366222) --Summon Sayaad
hasuitSetupSpellOptions = {hasuitSpellFunction_CleuSpellSummon, ["npcId"]=416}
initialize(688) --Summon Imp
hasuitSetupSpellOptions = {hasuitSpellFunction_CleuSpellSummon, ["npcId"]=17252}
initialize(30146) --Summon Felguard

hasuitSetupSpellOptions = {hasuitSpellFunction_CleuSpellSummon, ["npcId"]=26125}
initialize(46585) --Raise Dead 2 min cd
hasuitSetupSpellOptions = {hasuitSpellFunction_CleuSpellSummon, ["npcId"]=26125} --todo 63560 dark transformation
initialize(46584) --Raise Dead 30 sec cd


do
    local function danUnitPetUpdateCooldown(unitGUID, spellId) --todo more accurate reset if the same pet gets resummoned still on cd
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

function danCooldownReductionFunction() --could split this into multiple functions to ignore hypo/multiple affected spells
    -- local CDr = danCurrentSpellOptions["CDr"] --cursed? no explanation for how this happened but character here: , invisible by default on notepad++
    local CDr = danCurrentSpellOptions["CDr"]
    local affectedSpells = danCurrentSpellOptions["affectedSpells"]
    local hypoAffectedSpellsPairs = danCurrentFrame.hypoAffectedSpellsPairs
    for i=1,#affectedSpells do
        local icon = danCurrentFrame.cooldowns[affectedSpells[i]]
        if icon and icon.spellId==affectedSpells[i] then
            local expirationTime = icon.expirationTime
            if expirationTime then
                local currentTime = GetTime()
                if currentTime<expirationTime then
                    if CDr=="reset" then
                        expirationTime = currentTime
                    else
                        expirationTime = expirationTime-CDr
                    end
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
                    danCurrentController = icon.controller
                    danSortController()
                end
            end
        end
    end
end
function hasuitSpellFunction_CleuSuccessCooldownReduction() --i probably made it like this to keep cooldowns cleaner instead of including a subevent in the options
    if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame then
            danCooldownReductionFunction()
        end
    end
end
function hasuitSpellFunction_CleuInterruptCooldownReduction()
    if d2anCleuSubevent=="SPELL_INTERRUPT" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame then
            danCooldownReductionFunction()
        end
    end
end
function hasuitSpellFunction_CleuHealCooldownReduction()
    if d2anCleuSubevent=="SPELL_HEAL" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame then
            danCooldownReductionFunction()
        end
    end
end
function hasuitSpellFunction_CleuEnergizeCooldownReduction()
    if d2anCleuSubevent=="SPELL_ENERGIZE" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame then
            danCooldownReductionFunction()
        end
    end
end
function hasuitSpellFunction_CleuAppliedCooldownReduction()
    if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame then
            danCooldownReductionFunction()
        end
    end
end
function hasuitSpellFunction_CleuSpellEmpowerInterruptCooldownReduction()
    if d2anCleuSubevent=="SPELL_EMPOWER_INTERRUPT" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame then
            danCooldownReductionFunction()
        end
    end
end

function hasuitSpellFunction_CleuAppliedCooldownReductionSourceIsDest()
    if d2anCleuSubevent=="SPELL_AURA_APPLIED" and d4anCleuSourceGuid==d8anCleuDestGuid then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame then
            danCooldownReductionFunction()
        end
    end
end

function hasuitSpellFunction_CleuSuccessCooldownReductionSpec()
    if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame and danCurrentSpellOptions["specId"]==danCurrentFrame.specId then
            danCooldownReductionFunction()
        end
    end
end

function hasuitSpellFunction_CleuInterruptCooldownReductionSolarBeam() --solar beam
    if d2anCleuSubevent=="SPELL_INTERRUPT" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame then
            if danCurrentFrame.mainTarget==d8anCleuDestGuid then
                danCooldownReductionFunction()
            end
        end
    end
end

function hasuitSpellFunction_CleuAppliedCooldownReductionThiefsBargain354827() --might reuse for other stuff later
    if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame and not danCurrentFrame.thiefsBargain then
            danCurrentFrame.thiefsBargain = true
            danCooldownReductionFunction()
            danCurrentFrame.cooldownOptions[11327] = hasuitVanish96 --set back to 120 in hasuitResetCooldowns
        end
    end
end




function danCleuCooldownStart(GriftahsEmbellishingPowder) --there's a ~0.2 second inaccuracy on this for most spells? but not all, and it doesn't seem consistent even for the same spell? little bit of server lag or something. there might be a better way to do this but idk -- local currentTime = GetTime()*2-hasuitLoginTime-d1anCleuTimestamp+hasuitLoginTimestamp
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
hasuitSpellFunction_CleuSuccessCooldownStart1 = addMultiFunction(function()
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
hasuitSpellFunction_CleuSuccessCooldownStart2 = addMultiFunction(function()
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
hasuitSpellFunction_CleuHealCooldownStart = addMultiFunction(function()
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
hasuitSpellFunction_CleuSpellEmpowerStartCooldownStart2 = addMultiFunction(function()
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
hasuitSpellFunction_CleuAppliedCooldownStart = addMultiFunction(function()
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
hasuitSpellFunction_CleuRemovedCooldownStart = addMultiFunction(function()
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

hasuitSpellFunction_CleuAppliedCooldownStartPreventMultiple = addMultiFunction(function() --if used for multiple spellids for the same class/spec will cause problems
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


hasuitSpellFunction_CleuSuccessCooldownStartSolarBeam = addMultiFunction(function() --solar beam
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



hasuitSpellFunction_CleuSuccessCooldownStartPvPTrinket = addMultiFunction(function()
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
                
                
                
                for spellId, t in pairs(danCurrentSpellOptions["sharedCd"]) do
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

hasuitSpellFunction_CleuAppliedCooldownStartRacial = addMultiFunction(function()
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
                        local newExpirationTime = GetTime()+danCurrentSpellOptions["minimumDuration"]
                        if not danCurrentIcon.expirationTime or danCurrentIcon.expirationTime<newExpirationTime then
                            d12anCleuSpellId = currentPvpTrinketSpellId
                            danCleuCooldownStart(danCurrentSpellOptions["differenceFromNormalDuration"])
                        end
                    end
                end
            end
        end
    end
end)
hasuitSpellFunction_CleuAppliedRacialNotTrackedAffectingPvpTrinket = addMultiFunction(function() --doesn't need multi?
    if d2anCleuSubevent=="SPELL_AURA_APPLIED" then
        danCurrentFrame = hasuitUnitFrameForUnit[d4anCleuSourceGuid]
        if danCurrentFrame then
            danCurrentIcon = danCurrentFrame.cooldowns["pvpTrinket"]
            if danCurrentIcon then
                local currentPvpTrinketSpellId = danCurrentIcon.spellId
                if currentPvpTrinketSpellId==336126 or currentPvpTrinketSpellId==42292 then
                    local newExpirationTime = GetTime()+danCurrentSpellOptions["minimumDuration"]
                    if not danCurrentIcon.expirationTime or danCurrentIcon.expirationTime<newExpirationTime then
                        d12anCleuSpellId = currentPvpTrinketSpellId
                        danCleuCooldownStart(danCurrentSpellOptions["differenceFromNormalDuration"])
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
    function hasuitSpellFunction_Cleu378441TimeStop() --could do something with :Pause() instead, cd text was broken for it when i originally tried to do it that way (omnicc)
        if d2anCleuSubevent=="SPELL_AURA_APPLIED" then --todo cleaner interaction with hypo and make it work if hypo is the only source of cd, it probably won't atm, also the hypo stuff here is completely untested. probably has a bad interaction with charges so bop..
            danCurrentFrame = hasuitUnitFrameForUnit[d8anCleuDestGuid]
            if danCurrentFrame and danCurrentFrame.cooldownPriorities then
                for _, icon in pairs(danCurrentFrame.cooldownPriorities) do
                    local expirationTime = icon.expirationTime
                    if expirationTime then
                        local currentTime = GetTime()
                        if expirationTime>currentTime and not timeStopIgnoreList[icon.spellId] then
                            expirationTime = expirationTime+5
                            icon.expirationTime = expirationTime
                            if icon.hypoExpirationTime then
                                icon.hypoExpirationTime = icon.hypoExpirationTime+5
                                if icon.specialTimer then
                                    icon.specialTimer:Cancel()
                                end
                                icon.specialTimer = C_Timer_NewTimer(expirationTime-currentTime, function()
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




hasuitSpellFunction_CleuCooldownStartPet = addMultiFunction(function()
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

hasuitSpellFunction_CleuCasting = addMultiFunction(function()
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
            danCurrentSpellOptionsCommon = danCurrentSpellOptions[danCurrentFrame.unitType]
            if danCurrentSpellOptionsCommon then
                if d2anCleuSubevent=="SPELL_EMPOWER_START" or d2anCleuSubevent=="SPELL_CAST_START" then
                    if not activeCasts[d4anCleuSourceGuid] then
                        danCurrentIcon = danGetIcon(danCurrentSpellOptions["castType"])
                        activeCasts[d4anCleuSourceGuid] = {danCurrentIcon}
                        activeCasts[d4anCleuSourceGuid]["startTime"] = GetTime()
                    else
                        if activeCasts[d4anCleuSourceGuid]["startTime"]~=GetTime() then
                            return
                        end
                        danCurrentIcon = danGetIcon(danCurrentSpellOptions["castType"])
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
                        duration = danCurrentSpellOptions["backupDuration"]
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
    
    hasuitSetupSpellOptions = {function() --UNIT_DIED ___
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
            danCurrentSpellOptions = stuff[i]
            danCurrentSpellOptions[1]()
        end
    end
end)



hasuitFramesCenterSetEventType("unitCastSucceeded")


hasuitSpellFunction_UnitCastSucceededCooldownStart = addMultiFunction(function()
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
    hasuitSpellFunction_UnitCastSucceededChangedTalents = addMultiFunction(function()
        local frame = hasuitUnitFrameForUnit[danCurrentUnit]
        if frame then
            frame.inspected = false
            danInspectNewUnitFrame(frame)
        end
    end)
end








function hasuitSpecialAuraFunction_SoulOfTheForest() --similar to feign death, todo this isn't used yet, something like this can help fix soul hots probably
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
function hasuitSpecialAuraFunction_SoulHots() --one of the very first things made for this addon, should be fixed or remade (or given ["points"] or different spellid by blizzard), changing instances/overgrowth doesn't show it right sometimes, probably doesn't follow a unit around if people join/leave because of unit_aura full update
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
hasuitSetupSpellOptions = {function() --soul of the forest empowered hots 1
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

hasuitSetupSpellOptions = {function() --soul of the forest empowered hots 2
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



















function hasuitSpecialAuraFunction_RedLifebloom(icon) --specialFunction
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
        hasuitSpecialAuraFunction_RedLifebloom(icon)
    end)
end
tinsert(hasuitDoThisPlayer_Login, function()
    if not hasuitUsedRedLifebloom then
        hasuitSpecialAuraFunction_RedLifebloom = nil
    else
        hasuitUsedRedLifebloom = nil
    end
end)

do
    local playerClass = hasuitPlayerClass
    if playerClass=="MONK" then
        function hasuitSpecialAuraFunction_CanChangeTexture() --comment added later: should probably just assume any aura might change texture on an aura update? and then ya the size change thing here will be specific
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
                local specialSize = danCurrentSpellOptions["specialSize"]
                danCurrentIcon.normalSize = danCurrentSpellOptionsCommon["size"]
                danCurrentIcon.specialSize = specialSize
                if danCurrentAura["icon"]==5901829 then --+50% chi harmony texture, could also maybe tell by points2
                    danCurrentIcon.size = specialSize
                    danCurrentIcon:SetSize(specialSize, specialSize)
                end
            end
        end
    -- elseif playerClass=="DRUID" then
        -- local danTreants = {}
        -- hasuitSetupSpellOptions = {function()
            -- if d2anCleuSubevent=="SPELL_SUMMON" then
                -- if d4anCleuSourceGuid==hasuitPlayerGUID then
                    -- local treantGUID = d8anCleuDestGuid
                    -- danTreants[treantGUID] = true
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
            -- if unitGUID and danTreants[unitGUID] then
                -- hasuitSpellFunction_AuraMainFunction()
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
            danCurrentSpellOptions = stuff[i]
            danCurrentSpellOptions[1]()
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


hasuitSpellFunction_UnitCasting = addMultiFunction(function()
    local sourceGUID = UnitGUID(danCurrentUnit)
    if sourceGUID~=hasuitPlayerGUID then
        local destGUID = UnitGUID(danCurrentUnit.."target")
        if destGUID then
            danCurrentFrame = hasuitUnitFrameForUnit[destGUID]
            if danCurrentFrame then
                danCurrentSpellOptionsCommon = danCurrentSpellOptions[danCurrentFrame.unitType]
                if danCurrentSpellOptionsCommon then
                    if danCurrentSpellOptions["ignoreSameUnitType"] then
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
    local lastEventId
    local GetArenaCrowdControlInfo = C_PvP.GetArenaCrowdControlInfo
    local arenaCrowdControlSpellUpdateFrame = CreateFrame("Frame") --events registered in hasuitLoadOn_PartySize
    hasuitArenaCrowdControlSpellUpdateFrame = arenaCrowdControlSpellUpdateFrame
    arenaCrowdControlSpellUpdateFrame:SetScript("OnEvent", function(_, event, unit, spellId) --bored todo: register and unregister selectively, game fires these a lot for no reason. real todo: arena3 (mage) got their first ARENA_CROWD_CONTROL_SPELL_UPDATE like 10 seconds after coming out of stealth. it didn't show trinket icon on blizzard arena frames until then either. and the mage definitely pressed trinket later in the match. was also already in combat for a while at the time so it wasn't some weird thing where they equipped it after skirmish started. also seems like GetArenaCrowdControlInfo doesn't work outside of reacting to an event even if the relevant event has already happened and trinket has already been shown so maybe change this to assume they have trinket until game says spellid==0. is it possible it didn't show because it was on cd from them equipping it and having the 30s timer? if so could do something with that
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
                                danCurrentController = icon.controller
                                danSortController()
                            end
                        elseif not icon.expirationTime or icon.expirationTime<GetTime() then
                            icon:SetAlpha(1)
                        end
                    end
                elseif event=="ARENA_COOLDOWNS_UPDATE" then
                    local arenapet15, milliseconds1, milliseconds2 = GetArenaCrowdControlInfo(unit)
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
                    end
                end
            end
        end
    end)
end
