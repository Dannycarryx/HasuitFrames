if hasuitPlayerClass~="DRUID" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture






--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 132114) --Mighty Bash
trackDiminishTypeAndTexture("disorient", 136022) --Cyclone
trackDiminishTypeAndTexture("root", 136100) --Entangling Roots, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId
trackDiminishTypeAndTexture("incapacitate", 136071) --Polymorph, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track

hasuitAddCycloneTimerBars(33786) --Cyclone





-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
hasuitHots_1["specialAuraFunction"]=hasuitSpecialAuraFunction_RedLifebloom
hasuitSetupSpellOptions = hasuitHots_1
initialize(188550)  --lifebloom
initialize(33763)   --lifebloom, todo only cd text if low duration?

local danCommon = {["controllerOptions"]=hasuitController_Hots1_BottomRight_BottomRight,["size"]=14,["alpha"]=1,    ["hideCooldownText"]=true}
hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,      ["priority"]=2, ["group"]=danCommon} --applying a real lifebloom at the end of one of these doesn't make it bloom so that's why there's no red function. not 100% sure that's best but ya
initialize(290754)  --Lifebloom from Full Bloom (early spring) --also applying this on the end of a real lifebloom doesn't make the real lifebloom bloom either



--------------------------------hots 2
hasuitHots_2["specialIconType"]="optionalBorder"
hasuitHots_2["specialAuraFunction"]=hasuitSpecialAuraFunction_SoulHots
hasuitSetupSpellOptions = hasuitHots_2
initialize(8936)    --regrowth



--------------------------------hots 3
hasuitController_Hots3_BottomRight_BottomRight["sort"]=hasuitSortExpirationTime
hasuitHots_3["specialIconType"]="optionalBorder"
hasuitHots_3["specialAuraFunction"]=hasuitSpecialAuraFunction_SoulHots
hasuitHots_3["group"]["hideCooldownText"]=nil --todo only show timer text while playing germ?
hasuitSetupSpellOptions = hasuitHots_3 --the way rejuv/germ are set up here allows for optimizing double soul rejuv, as in showing the durations/order to make decisions easier to get both up consistently. It can be complicated though
initialize(774)     --rejuvenation
initialize(155777)  --germination



--------------------------------hots 4
hasuitController_Hots3_BottomRight_BottomRight["pushesOtherController"]=hasuitController_Hots4_BottomRight_BottomRight
hasuitHots_4["specialIconType"]="optionalBorder"
hasuitHots_4["specialAuraFunction"]=hasuitSpecialAuraFunction_SoulHots
hasuitSetupSpellOptions = hasuitHots_4
initialize(48438)   --wild growth

hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,      ["priority"]=2, ["group"]=hasuitHots_4["group"]} --difference is priority 2 instead of 1, and no special icon stuff for soul
initialize(383193)  --Grove Tending
initialize(157982)  --Tranquility



--------------------------------hots 5, above hots 1/grows left
hasuitSetupSpellOptions = hasuitHots_5
initialize(439530)  --Symbiotic Blooms
initialize(391891)  --adaptive swarm

hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,      ["priority"]=2, ["group"]=hasuitHots_5["group"]} 
initialize(1215515)  --Insurance!
-- initialize(200389)  --cult

hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,      ["priority"]=3, ["group"]=hasuitHots_5["group"]} 
initialize(468152)  --Reactive Resin

-- local danCommon = {["controllerOptions"]=hasuitController_Hots5_BottomRight_BottomRight,["size"]=10,["alpha"]=1,    ["hideCooldownText"]=true}
-- hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,      ["priority"]=4, ["group"]=danCommon,    ["loadOn"]=hasuitLoadOn_PartySize}
-- initialize(429222)  --Minor Cenarion Ward

--end hots







--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
hasuitSetupSpellOptions = hasuitDots_
initialize(202347)  --Stellar Flare
initialize(164812)  --Moonfire --ruined by treants
initialize(164815)  --Sunfire
initialize(1079)    --Rip
initialize(155722)  --Rake
initialize(391889)  --Adaptive Swarm dot







-- hasuitFramesCenterSetEventType("cleu")
-- hasuitSetupSpellOptions = {hasuitTempSwiftmend}
-- initialize(18562)
-- hasuitFramesCenterSetEventType("aura")



--[[
hasuitFramesCenterSetEventType("cleu")
hasuitSetupSpellOptions = {hasuitSpellFunction_Cleu_TestingHealingNumbers}
initialize(774) --
-- initialize(155777) --germ
-- initialize(188550)  --lifebloom
-- initialize(33763) --lifebloom
-- initialize(422090) --treant nourish
-- initialize(8936) --regr
-- initialize(50464) --Nourish proc
-- initialize(5176) --Wrath
-- initialize(190984)--Wrath
-- initialize(474683)--Aessina's Renewal
hasuitFramesCenterSetEventType("aura")
--]]






























-- local hasuitPlayerGUID = hasuitPlayerGUID
-- hasuitFramesCenterSetEventType("cleu")
-- hasuitSetupSpellOptions = {["loadOn"]=danLoadOnPvpTalentsInstance,function() --danHeartProcIsOnCooldown --the single very first thing made for the addon. it was a more basic setup with just this function + cleu setting danHeartProcIsOnCooldown for 60 sec, and combined with a function in my keybinding addon that changed a macro based on that out of combat or something. the addon sat untouched just doing that one thing for months before i slowly started adding new things to it and eventually really committed to working on it
    -- if d4anCleuSourceGuid==hasuitPlayerGUID then 
        -- if d2anCleuSubevent == "SPELL_AURA_APPLIED" then 
            -- danHeartProcIsOnCooldown = true
            -- C_Timer.After(60, function()
                -- if not C_UnitAuras.GetPlayerAuraBySpellID(426790) then  --Call of the Elder Druid aka heart of the wild proc
                    -- danHeartProcIsOnCooldown = false
                -- end
            -- end)
        -- elseif d2anCleuSubevent == "SPELL_AURA_REMOVED" then
            -- danHeartProcIsOnCooldown = false
        -- end
    -- end
-- end}
-- initialize(426790) --Call of the Elder Druid








-- local lastBloomTime = hasuitLoginTime
-- local lifebloomCastTime = 0
-- local bloomTime
-- local bloomCount = 0
-- hasuitSetupSpellOptions = {function()
    -- if d4anCleuSourceGuid==hasuitPlayerGUID then 
        -- if d2anCleuSubevent == "SPELL_CAST_SUCCESS" then
            -- local currentTime = GetServerTime()
            -- if bloomTime==currentTime then
                -- danPrint(danGreen("bloom"), "time since last bloom", math.floor(currentTime-lastBloomTime))
                -- lastBloomTime = currentTime
                -- bloomCount = bloomCount+1
            -- else
                -- lifebloomCastTime = currentTime
            -- end
        -- end
    -- end
-- end}
-- initialize(188550) --lifebloom
-- initialize(33763 ) --lifebloom
-- hasuitSetupSpellOptions = {function()
    -- if d4anCleuSourceGuid==hasuitPlayerGUID then 
        -- if d2anCleuSubevent == "SPELL_HEAL" then
            -- local currentTime = GetServerTime()
            -- if lifebloomCastTime==currentTime then
                -- danPrint(danGreen("bloom"), "time since last bloom", math.floor(currentTime-lastBloomTime))
                -- lastBloomTime = currentTime
                -- bloomCount = bloomCount+1
            -- else
                -- bloomTime = currentTime
            -- end
        -- end
    -- end
-- end}
-- initialize(33778 )--lifebloom
