if hasuitPlayerClass~="MONK" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture






--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 642414) --Leg Sweep
trackDiminishTypeAndTexture("incapacitate", 629534) --Paralysis
trackDiminishTypeAndTexture("root", 132316) --Disable, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId
trackDiminishTypeAndTexture("disorient", 332402) --Song of Chi-Ji, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track

-- hasuitAddCycloneTimerBars(1111) --song of chi-ji? not sure if there's a delay after that finishes though and also rarely played. todo this only when playing the talent





-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
hasuitHots_1["specialAuraFunction"]=hasuitSpecialAuraFunction_RedLifebloom
hasuitSetupSpellOptions = hasuitHots_1
initialize(124682)  --Enveloping Mist, 30-40%, mostly seen as 40%



--------------------------------hots 2
hasuitHots_2["specialSize"]=18
hasuitHots_2["specialAuraFunction"]=hasuitSpecialAuraFunction_CanChangeTexture
hasuitSetupSpellOptions = hasuitHots_2
initialize(119611)  --Renewing Mist, why does the tooltip in pvp say 4% healing increase? maybe this sucks



--------------------------------hots 3
hasuitController_Hots2_BottomRight_BottomRight["pushesOtherController"]=hasuitController_Hots3_BottomRight_BottomRight --because renewing mist can change size
hasuitSetupSpellOptions = hasuitHots_3
initialize(115175)  --Soothing Mist --buffs enveloping or something?



--------------------------------hots 4
hasuitController_Hots4_BottomRight_BottomRight["xMinimum"] = 1 --probably not needed but want this to always show even if it's hanging off the side of the unitFrame a little bit?
hasuitController_Hots4_BottomRight_BottomRight["yMinimum"] = 2 --^
hasuitSetupSpellOptions = hasuitHots_4
initialize(198533)  --Soothing Mist from statue, todo fake duration? buffs enveloping or something the same way as normal soothing, or that's how it worked last xpac. Fun fact you can split the beams if you los the statue to buff two envelops at once. Preferably re-cast soothing to give the statue higher duration before lining it

hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,                 ["priority"]=2,                     ["group"]=hasuitHots_4["group"]} --priority 2 instead of 1
initialize(116841)  --Tiger's Lust



--------------------------------hots 5, above hots 1/grows left
hasuitSetupSpellOptions = hasuitHots_5
initialize(411036)  --Sphere of Hope, 15%



--------------------------------hots 6, left of hots 5/grows left
hasuitSetupSpellOptions = hasuitHots_6
initialize(353503)  --Counteract Magic, 10% per stack up to 3?

hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,                 ["priority"]=2,                     ["group"]=hasuitHots_6["group"]} --priority 2 instead of 1
initialize(205655)  --Dome of Mist, 40% while absorb lasts? this is passive now, also for some reason my data collection addon shows enveloping mist as undispellable but that can't be right. Or actually it's showing it as undispellable in the first half of the season. Recently it shows as dispellable again?

--end hots

--should show yu'lon as a defensive buff on monk's frame when up? --todo?







--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
hasuitSetupSpellOptions = hasuitDots_
initialize(411038)  --Sphere of Despair
initialize(117952)  --Crackling Jade Lightning
initialize(116095)  --Disable 50% slow














-- initialize(423439)  --Chi Harmony --doesn't exist anymore?





-- local hasuitController_BottomRight_BottomRight2   = {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=1,   ["yLimit"]=0.33,["ownPoint"]="BOTTOMRIGHT", ["targetPoint"]="BOTTOMRIGHT",  ["xOffset"]=0,  ["yOffset"]=19, ["frameLevel"]=21,  ["sort"]=hasuitSortPriorityExpirationTime,  ["grow"]=normalGrow}
-- local danCommonHelpful = {["controllerOptions"]=hasuitController_BottomRight_BottomRight2,["size"]=15,    ["hideCooldownText"]=true,  ["alpha"]=1}
-- hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,      ["priority"]=1,     ["group"]=danCommonHelpful}










-- hasuitFramesCenterSetEventType("cleu")

-- local danGetD2anCleuSubevent = hasuitGetD2anCleuSubevent
-- local danGetD4anCleuSourceGuid = hasuitGetD4anCleuSourceGuid
-- local playerGUID = hasuitPlayerGUID

-- do --helps time mana tea cancels, todo special class page in options to enable/disable this? and make the thing below in the addon instead of weakauras and put on that page too. Should probably wait until a more common set of stuff gets made for middle of screen before doing this
    -- local icon = hasuitGetIcon(true)
    -- icon:SetParent(hasuitFramesParent)
    -- icon:ClearAllPoints()
    -- icon:SetPoint("CENTER", UIParent, "CENTER", -74, -4)
    -- icon:SetSize(64, 64)
    -- icon.iconTexture:SetTexture(614747)
    -- icon:SetFrameLevel(0)
    -- icon:SetAlpha(0)
    -- local cooldown = icon.cooldown
    -- cooldown:SetScript("OnCooldownDone", function()
        -- icon:SetAlpha(0)
    -- end)
    -- cooldown:SetReverse(true)
    
    -- icon.cooldown = nil
    -- icon.iconTexture = nil
    
    
    -- local iconText = cooldown:CreateFontString()
    -- iconText:SetFont("Fonts/FRIZQT__.TTF", 40, "OUTLINE")
    -- iconText:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -1, 1)
    -- local danManaTeaConsumed = 0
    -- hasuitSetupSpellOptions = {function()
        -- if danGetD4anCleuSourceGuid()==playerGUID then
            -- local d2anCleuSubevent = danGetD2anCleuSubevent()
            -- if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
                -- danManaTeaConsumed = 0
                -- icon:SetAlpha(1)
                -- iconText:SetText(danManaTeaConsumed)
                -- local _,_,_,startTimeMs,endTimeMs = UnitChannelInfo("player")
                -- local castDuration = (endTimeMs-startTimeMs)/1000
                -- cooldown:SetCooldown(GetTime(), castDuration)
            -- elseif d2anCleuSubevent=="SPELL_PERIODIC_ENERGIZE" then 
                -- danManaTeaConsumed = danManaTeaConsumed+1
                -- iconText:SetText(danManaTeaConsumed)
            -- elseif d2anCleuSubevent=="SPELL_AURA_REMOVED" then
                -- cooldown:Clear()
                -- icon:SetAlpha(0)
            -- end
        -- end
    -- end}
    -- initialize(115294) --mana tea channel
-- end





-- do --shows how many stacks of mana tea were consumed, used by my private weakaura called mana tea proc, todo
    -- local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
    -- local floor = math.floor
    -- danManaTeaProcDuration = 0
    -- hasuitSetupSpellOptions = {function()
        -- if danGetD4anCleuSourceGuid()==playerGUID then
            -- local d2anCleuSubevent = danGetD2anCleuSubevent()
            -- if d2anCleuSubevent=="SPELL_AURA_APPLIED" or d2anCleuSubevent=="SPELL_AURA_REFRESH" then 
                -- danManaTeaProcDuration = floor(GetPlayerAuraBySpellID(197908)["duration"]+0.5) --mana tea 30%
            -- else
                -- danManaTeaProcDuration = 0
            -- end
        -- end
    -- end}
    -- initialize(197908) --mana tea 30%
-- end

-- do --prints mana spent per spell? --commented out to not spam monks
    -- local GetSpellPowerCost = C_Spell.GetSpellPowerCost
    -- local GetSpellName = C_Spell.GetSpellName
    -- local function danGetSpellCost(spellId)
        -- local t = GetSpellPowerCost(spellId)
        -- if not t then
            -- return 0
        -- end
        -- for i=1,#t do
            -- if t[i]["hasRequiredAura"] then
                -- return t[i]["cost"]
            -- end
        -- end
        -- for i=1,#t do
            -- local cost = t[i]["cost"]
            -- if cost~=0 then
                -- return cost
            -- end
        -- end
        -- return 0
    -- end
    
    -- local danGetD12anCleuSpellId = hasuitGetD12anCleuSpellId
    -- hasuitSetupSpellOptions = {function()
        -- if danGetD4anCleuSourceGuid()==playerGUID then 
            -- if danGetD2anCleuSubevent()=="SPELL_CAST_SUCCESS" then
                -- local d12anCleuSpellId = danGetD12anCleuSpellId()
                -- print(danGetSpellCost(d12anCleuSpellId), GetSpellName(d12anCleuSpellId))
            -- end
        -- end
    -- end}
    -- initialize(124682) --"Enveloping Mist"
    -- initialize(116670) --"Vivify"
    -- initialize(115151) --"Renewing Mist"
    -- initialize(322101) --"Expel Harm", wrong now? shows 0
    -- initialize(107428) --"Rising Sun Kick"
    -- initialize(101546) --"Spinning Crane Kick", wrong now? shows 0
    -- initialize(115450) --"Detox"
    -- initialize(191837) --"Essence Font"
    -- initialize(322118) --"Yu'lon"
    -- initialize(115310) --"Revival"
    -- initialize(388615) --"Restoral"
-- end




-- hasuitFramesCenterSetEventType("aura")