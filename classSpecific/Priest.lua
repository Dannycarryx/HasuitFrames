if hasuitPlayerClass~="PRIEST" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture

local loadOn_SpecIs_Holy = {}
local loadOn_SpecIs_Discipline = {}
local loadOn_SpecIs_Shadow = {}
local loggedInAsSpec = GetSpecialization() --this gives nil here unless it's a reload
loggedInAsSpec = loggedInAsSpec==1 and 256 or loggedInAsSpec==2 and 257 or loggedInAsSpec==3 and 258
if loggedInAsSpec==257 then --holy
    loadOn_SpecIs_Holy.shouldLoad = true
elseif loggedInAsSpec==258 then --shadow
    loadOn_SpecIs_Shadow.shouldLoad = true
else
    loadOn_SpecIs_Discipline.shouldLoad = true --defaults to disc
end




--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 237568) --Psychic Horror
trackDiminishTypeAndTexture("disorient", 136184) --Psychic Scream
trackDiminishTypeAndTexture("root", 537022) --Void Tendrils, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track
trackDiminishTypeAndTexture("incapacitate", 136071) --Polymorph, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId






-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
hasuitHots_1["loadOn"] = loadOn_SpecIs_Discipline
hasuitSetupSpellOptions = hasuitHots_1
initialize(194384)  --Atonement, disc loadon, should make this bigger?/move everything accordingly while disc

hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=1,                     ["group"]=hasuitHots_1["group"], ["loadOn"]=loadOn_SpecIs_Holy}
initialize(139)     --Renew, holy loadon

hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=1,                     ["group"]=hasuitHots_1["group"], ["loadOn"]=loadOn_SpecIs_Shadow}
initialize(17)      --Power Word: Shield, shadow loadon



--------------------------------hots 2
hasuitHots_2["loadOn"] = loadOn_SpecIs_Discipline
hasuitSetupSpellOptions = hasuitHots_2
initialize(139)     --Renew, disc loadon

hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=1,                     ["group"]=hasuitHots_2["group"], ["loadOn"]=loadOn_SpecIs_Holy}
initialize(41635)   --Prayer of Mending, holy loadon, can stick between swapping specs and cause an overlap with hots 3, but doesn't really matter? could chain push controllers but kind of inefficient?

hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=1,                     ["group"]=hasuitHots_2["group"], ["loadOn"]=loadOn_SpecIs_Shadow}
initialize(139)     --Renew, shadow loadon, people don't take this/prayer of mending for shadow? doesn't seem like there's anything else to show anyway



--------------------------------hots 3
hasuitHots_3["loadOn"] = loadOn_SpecIs_Discipline
hasuitHots_3["priority"] = 2
hasuitSetupSpellOptions = hasuitHots_3
initialize(41635)   --Prayer of Mending, disc loadon, idk how strong mending/renew/shield are or how they should be shown to begin with. Maybe mending is more of a trash debuff? maybe even if it's good it isn't very useful to show it in a prominent place on frames because you just press it on cd? No idea on this one, or how to prioritize renew vs shield

hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=1,                     ["group"]=hasuitHots_3["group"], ["loadOn"]=loadOn_SpecIs_Discipline}
initialize(17)      --Power Word: Shield, disc loadon
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=1,                     ["group"]=hasuitHots_3["group"], ["loadOn"]=loadOn_SpecIs_Holy}
initialize(17)      --Power Word: Shield, holy loadon
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=1,                     ["group"]=hasuitHots_3["group"], ["loadOn"]=loadOn_SpecIs_Shadow}
initialize(41635)   --Prayer of Mending, shadow loadon



--------------------------------hots 4
hasuitController_Hots3_BottomRight_BottomRight["pushesOtherController"]=hasuitController_Hots4_BottomRight_BottomRight --disc can have two icons active in hots 3 so this is needed
hasuitController_Hots4_BottomRight_BottomRight["xOffset"] = hasuitController_Hots4_BottomRight_BottomRight["xOffset"]+4 --none of the icons can get bigger for priest so this should go to the right a bit?
hasuitSetupSpellOptions = hasuitHots_4 --converge and share the same spells between all 3 specs from here on
initialize(10060)   --Power Infusion

hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=2,                     ["group"]=hasuitHots_4["group"]} --priority 2
initialize(64844)  --Divine Hymn, 30% healing increase from all sources for 25 sec? undispellable. Something like this should be visible from other healers in group but I think too spammy to be worth showing? Not sure what's best, maybe ideally show it on the priest that cast it but don't spam other frames?

hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=3,                     ["group"]=hasuitHots_4["group"]} --priority 3
initialize(121557)  --Angelic Feather
initialize(111759)  --Levitate



--------------------------------hots 5, above hots 1/grows left
-- hasuitSetupSpellOptions = hasuitHots_5
-- initialize(1111)    --

--end hots


--fade 10%?
-- Premonition of Piety heal increase/overheal redistribution?







--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
hasuitSetupSpellOptions = hasuitDots_
initialize(589)     --Shadow Word: Pain
initialize(204213)  --Purge the Wicked
initialize(375901)  --Mindgames

initialize(391403)  --Mind Flay: Insanity
initialize(15407)   --Mind Flay
initialize(335467)  --Devouring Plague
initialize(34914)   --Vampiric Touch
initialize(263165)  --Void Torrent









tinsert(hasuitDoThis_Player_Login, function() --first loadOns based on player spec
    local asd
    if not loggedInAsSpec then
        asd = true
        loggedInAsSpec = GetSpecialization() --seems like it's always set after player_login?
        loggedInAsSpec = loggedInAsSpec==1 and 256 or loggedInAsSpec==2 and 257 or loggedInAsSpec==3 and 258
    end
    
    local hasuitPlayerFrame = hasuitPlayerFrame
    local customDanInspectedUnitFrame = hasuitPlayerFrame.customDanInspectedUnitFrame
    if not customDanInspectedUnitFrame then
        customDanInspectedUnitFrame = {}
        hasuitPlayerFrame.customDanInspectedUnitFrame = customDanInspectedUnitFrame
    end
    
    -- local hasuitSpecialAuraFunction_RedLifebloom = hasuitSpecialAuraFunction_RedLifebloom
    local hasuitMainLoadOnFunctionSpammable = hasuitMainLoadOnFunctionSpammable
    local loadOn_SpecIs_Holy = loadOn_SpecIs_Holy
    local loadOn_SpecIs_Discipline = loadOn_SpecIs_Discipline
    local loadOn_SpecIs_Shadow = loadOn_SpecIs_Shadow
    local lastSpecId = not asd and loggedInAsSpec
    local function customDanInspectedUnitFrameFunction(unitFrame)
        local specId = unitFrame.specId
        if specId then --can this ever not be set?
            if specId==257 then --Holy
                if lastSpecId~=specId then
                    lastSpecId = specId
                    loadOn_SpecIs_Holy.shouldLoad = true
                    loadOn_SpecIs_Discipline.shouldLoad = false
                    loadOn_SpecIs_Shadow.shouldLoad = false
                    hasuitMainLoadOnFunctionSpammable()
                end
                return
                
            elseif specId==256 then --Discipline
                if lastSpecId~=specId then
                    lastSpecId = specId
                    loadOn_SpecIs_Holy.shouldLoad = false
                    loadOn_SpecIs_Discipline.shouldLoad = true
                    loadOn_SpecIs_Shadow.shouldLoad = false
                    hasuitMainLoadOnFunctionSpammable()
                end
                return
                
            elseif specId==258 then --Shadow
                if lastSpecId~=specId then
                    lastSpecId = specId
                    -- hasuitHots_1["specialAuraFunction"]=hasuitSpecialAuraFunction_RedLifebloom --should holy get the red function for renew?
                    loadOn_SpecIs_Holy.shouldLoad = false
                    loadOn_SpecIs_Discipline.shouldLoad = false
                    loadOn_SpecIs_Shadow.shouldLoad = true
                    hasuitMainLoadOnFunctionSpammable()
                end
                return
                
            end
        end --below probably does nothing
        if lastSpecId~=false then
            lastSpecId = false
            loadOn_SpecIs_Holy.shouldLoad = false
            loadOn_SpecIs_Discipline.shouldLoad = true --defaults to disc --should be shadow after loadOns can update auras that are already active
            loadOn_SpecIs_Shadow.shouldLoad = false
            hasuitMainLoadOnFunctionSpammable()
        end
    end
    tinsert(customDanInspectedUnitFrame, customDanInspectedUnitFrameFunction)
    
    if asd then --it's ugly but at least everything immediately updates/loads/unloads based on player spec when logging in. Something should be better to not have to go so far out of the way to achieve this. The best thing would be to make auras(and cleu/castbars maybe?) get hidden/shown/moved or whatever based on loadOn changing, and not need to wait for aura to actually time out to get affected by loadOn change. could fix deserter after doing that and simplify this file some, and it'll be useful in the future for other things. I'm not sure what the best way of doing this is but i'll think about it
        local previous2 = hasuitMainLoadOnFunctionSpammable
        hasuitMainLoadOnFunctionSpammable = hasuitMainLoadOnFunction --instant so it happens before unit_aura on login, ideally mainLoadOnFunction should get prevented from happening again onupdate right after this if not needed. atm it can happen 3x when logging in for priest which is pretty unnecessary but also doesn't matter that much. bored todo --this will work itself out after fixing better thing in comment above
        local previous1 = hasuitPlayerFrame.specId
        hasuitPlayerFrame.specId = loggedInAsSpec
        customDanInspectedUnitFrameFunction(hasuitPlayerFrame)
        hasuitPlayerFrame.specId = previous1
        hasuitMainLoadOnFunctionSpammable = previous2
    end
end)
