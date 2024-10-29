if hasuitPlayerClass~="MONK" then
    return
end
local initialize = hasuitFramesInitialize
local diminish = hasuitFramesTrackDiminishTypeAndTexture



--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
diminish("stun", 642414) --Leg Sweep
diminish("incapacitate", 629534) --Paralysis
diminish("root", 132316) --Disable, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: diminish("stun", "Mighty Bash")
diminish("disorient", 332402) --Song of Chi-Ji, you can delete or move drs around depending on what you want, just remove the whole line for whatever you don't want to track




hasuitSetupFrameOptions = hasuitFramesOptionsClassSpecificHarmful --------------------------------dots/debuffs from you, shown bottom left on enemy frames
initialize(411038) --Sphere of Despair






local normalGrow = hasuitNormalGrow

hasuitFramesOptionsClassSpecificHelpful = nil
danBottomRight_BottomRight  =   {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=1,   ["yLimit"]=0.33,["ownPoint"]="BOTTOMRIGHT",["targetPoint"]="BOTTOMRIGHT",["xOffset"]=0,["yOffset"]=0,["grow"]=normalGrow,["sort"]=danSortPriorityExpirationTime}

local commonHelpful = {["controller"]=danBottomRight_BottomRight,["size"]=18,   ["frameLevel"]=20,  ["hideCooldownText"]=false, ["alpha"]=1}
hasuitSetupFrameOptions = {auraSourceIsPlayer,  ["priority"]=-1,    ["group"]=commonHelpful, ["specialAuraFunction"]=redLifebloom} hasuitUsedRedLifebloom = true
initialize(124682) --Enveloping Mist

local commonHelpful = {["controller"]=danBottomRight_BottomRight,["size"]=15,   ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1}
hasuitSetupFrameOptions = {auraSourceIsPlayer,  ["priority"]=1, ["group"]=commonHelpful, ["specialAuraFunction"]=auraCanChangeTextureSpecialFunction, ["specialSize"]=18}
initialize(119611) --Renewing Mist

local commonHelpful = {["controller"]=danBottomRight_BottomRight,["size"]=15,   ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1}
hasuitSetupFrameOptions = {auraSourceIsPlayer,  ["priority"]=2, ["group"]=commonHelpful}
initialize(115175) --Soothing Mist



local danBottomRight_BottomRight2   =   {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=1,   ["yLimit"]=0.33,["ownPoint"]="BOTTOMRIGHT",["targetPoint"]="BOTTOMRIGHT",["xOffset"]=0,["yOffset"]=19,["grow"]=normalGrow,["sort"]=danSortPriorityExpirationTime}
local commonHelpful = {["controller"]=danBottomRight_BottomRight2,["size"]=15,  ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1}
hasuitSetupFrameOptions = {auraSourceIsPlayer,  ["priority"]=1, ["group"]=commonHelpful}
initialize("Chi Harmony") --Chi Harmony
initialize(205655) --Dome of Mist
initialize(353503) --Counteract Magic

hasuitSetupFrameOptions = {auraSourceIsPlayer,  ["priority"]=0, ["group"]=commonHelpful}
initialize(411036) --Sphere of Hope







hasuitFramesCenterSetEventType("cleu")

local danGetD2anCleuSubevent = hasuitGetD2anCleuSubevent
local danGetD4anCleuSourceGuid = hasuitGetD4anCleuSourceGuid
local playerGUID = hasuitPlayerGUID

do --helps time mana tea cancels
    local icon = hasuitGetIcon(true)
    icon:SetParent(hasuitFrameParent)
    icon:ClearAllPoints()
    icon:SetPoint("CENTER", UIParent, "CENTER", -74, -4)
    icon:SetSize(64, 64)
    -- icon.size = 64
    icon.iconTexture:SetTexture(614747)
    icon:SetFrameLevel(0)
    icon:SetAlpha(0)
    local cooldown = icon.cooldown
    cooldown:SetScript("OnCooldownDone", function()
        icon:SetAlpha(0)
    end)
    cooldown:SetReverse(true)
    
    icon.cooldown = nil
    icon.iconTexture = nil
    
    
    local iconText = cooldown:CreateFontString()
    iconText:SetFont("Fonts/FRIZQT__.TTF", 40, "OUTLINE")
    iconText:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -1, 1)
    local danManaTeaConsumed = 0
    hasuitSetupFrameOptions = {function()
        if danGetD4anCleuSourceGuid()==playerGUID then
            local d2anCleuSubevent = danGetD2anCleuSubevent()
            if d2anCleuSubevent=="SPELL_CAST_SUCCESS" then
                danManaTeaConsumed = 0
                icon:SetAlpha(1)
                iconText:SetText(danManaTeaConsumed)
                local _,_,_,startTimeMs,endTimeMs = UnitChannelInfo("player")
                local castDuration = (endTimeMs-startTimeMs)/1000
                cooldown:SetCooldown(GetTime(), castDuration)
            elseif d2anCleuSubevent=="SPELL_PERIODIC_ENERGIZE" then 
                danManaTeaConsumed = danManaTeaConsumed+1
                iconText:SetText(danManaTeaConsumed)
            elseif d2anCleuSubevent=="SPELL_AURA_REMOVED" then
                cooldown:Clear()
                icon:SetAlpha(0)
            end
        end
    end}
    initialize(115294) --mana tea channel
end

-- do --shows how many stacks of mana tea were consumed, used by my private weakaura called mana tea proc, todo
    -- local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
    -- local floor = math.floor
    -- danManaTeaProcDuration = 0
    -- hasuitSetupFrameOptions = {function()
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
    -- hasuitSetupFrameOptions = {function()
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




hasuitFramesCenterSetEventType("aura")