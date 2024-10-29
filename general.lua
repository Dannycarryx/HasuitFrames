
local GetSpellName = C_Spell.GetSpellName
local initializePlusDiminish = hasuitFramesInitializePlusDiminish
local initializeMulti = hasuitFramesInitializeMulti
local initializeMultiPlusDiminish = hasuitFramesInitializeMultiPlusDiminish
local initialize = hasuitFramesInitialize
local hasuitFramesCenterSetEventType = hasuitFramesCenterSetEventType


-- danLoadOnPvpTalentsInstance = hasuitFramesCenterAddLoadingProfile({
    -- ["instanceType"]={["none"]=true,["arena"]=true,["pvp"]=true},
-- })




do --instanceType none
    local loadOn = {}
    local function loadOnCondition()
        if hasuitInstanceType=="none" then --should load
            loadOn.shouldLoad = true
        else --should NOT load
            loadOn.shouldLoad = false
        end
    end
    tinsert(hasuitDoThisPlayer_Entering_WorldSkipsFirst, loadOnCondition)
    loadOnCondition()
    hasuitLoadOnInstanceTypeNone = loadOn
end
local loadOnNone = hasuitLoadOnInstanceTypeNone
do --instanceType pvp, (bg only)
    local loadOn = {}
    local function loadOnCondition()
        if hasuitInstanceType=="pvp" then --should load
            loadOn.shouldLoad = true
        else --should NOT load
            loadOn.shouldLoad = false
        end
    end
    tinsert(hasuitDoThisPlayer_Entering_WorldSkipsFirst, loadOnCondition)
    loadOnCondition()
    hasuitLoadOnBgOnly = loadOn
end
local loadOnBgOnly = hasuitLoadOnBgOnly

do --arena or not arena loadons
    local loadOn = {}
    local loadOn2 = {}
    local function loadOnCondition()
        if hasuitInstanceType~="arena" then --should load
            if not loadOn.shouldLoad then
                loadOn.shouldLoad = true
                loadOn2.shouldLoad = false
            end
        else --should NOT load
            if loadOn.shouldLoad~=false then
                loadOn.shouldLoad = false
                loadOn2.shouldLoad = true
            end
        end
    end
    tinsert(hasuitDoThisPlayer_Entering_WorldSkipsFirst, loadOnCondition)
    loadOnCondition()
    hasuitLoadOnNotArenaOnly = loadOn
    hasuitLoadOnArenaOnly = loadOn2
end
local loadOnArenaOnly = hasuitLoadOnArenaOnly
local loadOnNotArenaOnly = hasuitLoadOnNotArenaOnly



























local normalGrow = hasuitNormalGrow
local danSort = hasuitSort


danTopRight_TopRight        =   {["xDirection"]=-1, ["yDirection"]= -1, ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=0.49,["yLimit"]=0.45,["ownPoint"]="TOPRIGHT",    ["targetPoint"]="TOPRIGHT",                                 ["xOffset"]=0,  ["yOffset"]=0,  ["grow"]=normalGrow,    ["sort"]=danSort}
danTopLeft_TopLeft          =   {["xDirection"]=1,  ["yDirection"]= -1, ["xMinimum"]=2, ["yMinimum"]=2, ["xLimit"]=0.49,["yLimit"]=0.45,["ownPoint"]="TOPLEFT",     ["targetPoint"]="TOPLEFT",                                  ["xOffset"]=0,  ["yOffset"]=0,  ["grow"]=normalGrow,    ["sort"]=danSort}

-- danBottomRight_BottomRight at the bottom of file
-- danBottomLeft_BottomLeft ^

danTopLeft_TopRight         =   {["xDirection"]=1,  ["yDirection"]= -1, ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=2,   ["yLimit"]=0.6, ["ownPoint"]="TOPLEFT",     ["targetPoint"]="TOPRIGHT",     ["setPointOnBorder"]=true,  ["xOffset"]=0,  ["yOffset"]=0,  ["grow"]=normalGrow,    ["sort"]=danSort}
danBottomLeft_BottomRight   =   {["xDirection"]=1,  ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=2,   ["yLimit"]=0.6, ["ownPoint"]="BOTTOMLEFT",  ["targetPoint"]="BOTTOMRIGHT",  ["setPointOnBorder"]=true,  ["xOffset"]=0,  ["yOffset"]=0,  ["grow"]=normalGrow,    ["sort"]=danSort}

danTopRight_TopLeft         =   {["xDirection"]=-1, ["yDirection"]= -1, ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=2,   ["yLimit"]=0.6, ["ownPoint"]="TOPRIGHT",    ["targetPoint"]="TOPLEFT",      ["setPointOnBorder"]=true,  ["xOffset"]=0,  ["yOffset"]=0,  ["grow"]=normalGrow,    ["sort"]=danSort}
danBottomRight_BottomLeft   =   {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=2,   ["yLimit"]=0.6, ["ownPoint"]="BOTTOMRIGHT", ["targetPoint"]="BOTTOMLEFT",   ["setPointOnBorder"]=true,  ["xOffset"]=0,  ["yOffset"]=0,  ["grow"]=normalGrow,    ["sort"]=danSort}


danMiddleMiddle             =   {["xDirection"]=0,  ["yDirection"]= 0,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=0,   ["yLimit"]=0,   ["ownPoint"]="CENTER",      ["targetPoint"]="CENTER",                                   ["xOffset"]=0,  ["yOffset"]=0,  ["grow"]=normalGrow,    ["sort"]=danSort}




--framelevel should go on controllers?

local danCommonTopLeftGroup         =   {["controller"]=danTopLeft_TopLeft,     ["size"]=16,    ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1,  }
local danCommonTopLeftGroupAlpha40  =   {["controller"]=danTopLeft_TopLeft,     ["size"]=16,    ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=0.4,}

local commonTopRightArena           =   {["controller"]=danTopRight_TopRight,   ["size"]=16,    ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1,  }
local commonTopRightArenaAlpha40    =   {["controller"]=danTopRight_TopRight,   ["size"]=16,    ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=0.4,}





local bigGroupDebuffsParty = {
    47, --1
    45, --2
    43, --3
    43, --4, no cooldown text here and below
    41, --5
    39, --6
    30, --7
}
local commonBigGroupDebuffs = {}
local commonBigBottomLeftArena = {}
for i=1,3 do
    commonBigGroupDebuffs[i]    = {["hideCooldownText"]=false, ["alpha"]=1, ["frameLevel"]=20,}
    commonBigBottomLeftArena[i] = {["hideCooldownText"]=false, ["alpha"]=1, ["frameLevel"]=20,  ["controller"]=danBottomRight_BottomLeft,   ["size"]=bigGroupDebuffsParty[i],}
end
for i=4,7 do
    commonBigGroupDebuffs[i]    = {["hideCooldownText"]=true,  ["alpha"]=1, ["frameLevel"]=20,}
    commonBigBottomLeftArena[i] = {["hideCooldownText"]=true,  ["alpha"]=1, ["frameLevel"]=20,  ["controller"]=danBottomRight_BottomLeft,   ["size"]=bigGroupDebuffsParty[i],}
end


local rootOptionsBreakable1   = {danMainAuraFunction,   ["priority"]=-29,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[6], ["arena"]=commonBigBottomLeftArena[6],  ["actualText"]="root", ["specialAuraFunction"]=hasuitSpecialAuraCcBreakThreshold, ["specialIconType"]="ccBreak",["ccBreakHealthThresholdMultiplier"]=1} --roots that break, threshold bar shown for <6
local rootOptionsBreakable175 = {danMainAuraFunction,   ["priority"]=-29,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[6], ["arena"]=commonBigBottomLeftArena[6],  ["actualText"]="root", ["specialAuraFunction"]=hasuitSpecialAuraCcBreakThreshold, ["specialIconType"]="ccBreak",["ccBreakHealthThresholdMultiplier"]=1.75}
local rootOptions2            = {danMainAuraFunction,   ["priority"]=-29,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[6], ["arena"]=commonBigBottomLeftArena[6],  ["actualText"]="root",} --roots no threshold, --text will be completely redone eventually, it sucks right now

local rootOptionsBreakableCleuPartLoadon        =   {}
local rootOptionsBreakable1CleuPartOptions      =   {hasuitCleuCcBreakThreshold,["loadOn"]=rootOptionsBreakableCleuPartLoadon,["ccBreakHealthThresholdMultiplier"]=1}
local rootOptionsBreakable175CleuPartOptions    =   {hasuitCleuCcBreakThreshold,["loadOn"]=rootOptionsBreakableCleuPartLoadon,["ccBreakHealthThresholdMultiplier"]=1.75}
do
    local bigGroupDebuffsRaid = { --bigGroupDebuffsRaidForSize,
               -- 1,  2,  3,  4,  5,  6,  7  --no cooldown text 4+
        [8] =   {26, 24, 22, 20, 18, 16, 14 },
        [40] =  {22, 21, 20, 17, 15, 13, 10 }, --todo system for changing sizes of things based on frame size, and system for changing scale of everything while keeping every number an integer
    }
    local lastGroupSize = 0
    local sizeTable = hasuitDoThisGroup_Roster_UpdateGroupSize_5_8
    local mainLoadOnFunctionSpammable = hasuitMainLoadOnFunctionSpammable
    local function danRbgFunction()
        local bigGroupDebuffsRaidForSize = bigGroupDebuffsRaid[sizeTable.activeRelevantSize]
        if lastGroupSize<6 then
            hasuitKICKTextKey = "KICKRbg"
            rootOptionsBreakable1["textKey"] = "rootRbg"
            rootOptionsBreakable175["textKey"] = "rootRbg"
            rootOptions2["textKey"] = "rootRbg"
            for i=1,#commonBigGroupDebuffs do
                local options = commonBigGroupDebuffs[i]
                options["size"]=bigGroupDebuffsRaidForSize[i]
                options["controller"]=danTopRight_TopRight
            end
            if rootOptionsBreakableCleuPartLoadon.shouldLoad~=false then --check doesn't do anything yet
                rootOptionsBreakable1["specialIconType"] = nil
                rootOptionsBreakable1["specialAuraFunction"] = nil
                rootOptionsBreakable175["specialIconType"] = nil
                rootOptionsBreakable175["specialAuraFunction"] = nil
                rootOptionsBreakableCleuPartLoadon.shouldLoad = false
                mainLoadOnFunctionSpammable()
            end
        else
            for i=1,#commonBigGroupDebuffs do
                commonBigGroupDebuffs[i]["size"]=bigGroupDebuffsRaidForSize[i]
            end
        end
        lastGroupSize = sizeTable.activeRelevantSize
    end
    local hasuitSpecialAuraCcBreakThreshold = hasuitSpecialAuraCcBreakThreshold
    tinsert(sizeTable.functions, function()
        if hasuitGroupSize>5 then
            danRbgFunction()
        else
            hasuitKICKTextKey = "KICKArena"
            rootOptionsBreakable1["textKey"] = "rootArena"
            rootOptionsBreakable175["textKey"] = "rootArena"
            rootOptions2["textKey"] = "rootArena"
            for i=1,#commonBigGroupDebuffs do
                local options = commonBigGroupDebuffs[i]
                options["size"]=bigGroupDebuffsParty[i]
                options["controller"]=danBottomLeft_BottomRight
            end
            lastGroupSize = 5
            if not rootOptionsBreakableCleuPartLoadon.shouldLoad then --todo instance type conditions
                rootOptionsBreakable1["specialIconType"] = "ccBreak"
                rootOptionsBreakable1["specialAuraFunction"] = hasuitSpecialAuraCcBreakThreshold
                rootOptionsBreakable175["specialIconType"] = "ccBreak"
                rootOptionsBreakable175["specialAuraFunction"] = hasuitSpecialAuraCcBreakThreshold
                rootOptionsBreakableCleuPartLoadon.shouldLoad = true
                mainLoadOnFunctionSpammable()
            end
        end
    end)
end


local commonBigBottomLeftArenaDefensivesSize35 = {["controller"]=danBottomRight_BottomLeft, ["size"]=35,    ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1,["specialIconType"]="greenBorder"}
local commonBigBottomLeftArenaDefensivesSize30 = {["controller"]=danBottomRight_BottomLeft, ["size"]=30,    ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1,["specialIconType"]="greenBorder"}
local commonBigBottomLeftArenaDefensivesSize25 = {["controller"]=danBottomRight_BottomLeft, ["size"]=25,    ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1,["specialIconType"]="greenBorder"}



--todo should change priorities of things and what shows based on whether i'm healer or warrior or whatever, like nether ward/ams aren't as important for a warrior and casters don't care as much about bop etc. 
--making casts more visible and who they're coming from will be important for people with ranged kicks

--todo special player cc above raidframe in groups >5
--todo something to get 100% accurate interrupt durations on player
--todo display dispellable buffs on arena if player has purge
--todo motw missing and similar if player can cast, maybe use it topright-topleft of arena for certain player debuffs
--arcane intellect
--fort
--anything else?


hasuitFramesCenterSetEventType("aura")

hasuitFramesCenterSetDrType("disorient") --fear
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-80,                           ["group"]=commonBigGroupDebuffs[1], ["arena"]=commonBigBottomLeftArena[1]} --immune cc, BIG CC DEBUFFS ___
initializePlusDiminish(33786) --Cyclone
initializePlusDiminish(710) --Banish

hasuitFramesCenterSetDrType("incapacitate") --sheep
initializePlusDiminish(221527) --imprison immune
initializePlusDiminish(203337) --freezing trap

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-75,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[1], ["arena"]=commonBigBottomLeftArena[1],  ["specialIconType"]="greenBorder"} --immune friendly cc
initialize(378441) --time stop (friendly buff)

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-72,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[1], ["arena"]=commonBigBottomLeftArena[1]} --BIG BUFFS ___
initialize(456574) --Cinder Nectar
initialize(GetSpellName(216339)) --Drink
initialize(GetSpellName(167152)) --Refreshment
initialize(GetSpellName(216338)) --Food
initialize(GetSpellName(308433)) --Food & Drink


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-69,["loadOn"]=loadOnArenaOnly,["group"]=commonBigGroupDebuffs[1], ["arena"]=commonBigBottomLeftArena[1], ["specialAuraFunction"]=hasuitShadowyDuelFunction} --rogue, --todo make something so that duel aura doesn't hide, maybe prevent other auras from hiding too
initialize(207736) --Shadowy Duel
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-69,["loadOn"]=loadOnNotArenaOnly,["group"]=commonBigGroupDebuffs[1],["arena"]=commonBigBottomLeftArena[1]} --rogue
initialize(207736) --Shadowy Duel


hasuitFramesCenterSetDrType("stun")
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-63,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[1], ["arena"]=commonBigBottomLeftArena[1]} --STUNS
initializePlusDiminish(202244) --Overrun
initializePlusDiminish(203123) --Maim
initializePlusDiminish(5211) --Mighty Bash
initializePlusDiminish(377048) --Absolute Zero
initializePlusDiminish(221562) --Asphyxiate
initializePlusDiminish(108194) --Asphyxiate, is this still in the game? blood i think, never seen
initializePlusDiminish(179057) --Chaos Nova
initializePlusDiminish(211881) --Fel Eruption
initializePlusDiminish(372245) --Terror of the Skies
initializePlusDiminish(357021) --Consecutive Concussion exists again
initializePlusDiminish(119381) --Leg Sweep
initializePlusDiminish(853) --Hammer of Justice
initializePlusDiminish(64044) --Psychic Horror
initializePlusDiminish(1833) --Cheap Shot
initializePlusDiminish(408) --Kidney Shot
initializePlusDiminish(89766) --axe toss stun
initializePlusDiminish(30283) --Shadowfury
-- initializePlusDiminish("Warpath") --?
initializePlusDiminish(385954) --Shield Charge
initializePlusDiminish(132168) --Shockwave
initializePlusDiminish(132169) --Storm Bolt
initializePlusDiminish(91800) --Gnaw
initializePlusDiminish(91797) --Monstrous Blow
initializePlusDiminish(212337) --Powerful Smash, haven't seen
initializePlusDiminish(212336) --Smash, haven't seen
initializePlusDiminish(118345) --Pulverize
initializePlusDiminish(287712) --Haymaker
initializePlusDiminish(255723) --Bull Rush
initializePlusDiminish(20549) --War Stomp
initializePlusDiminish(24394) --Intimidation
initializePlusDiminish(163505) --Rake
initializePlusDiminish(287254) --Dead of Winter, (remorseless winter) --these are old and unchecked here and below
initializePlusDiminish(200166) --metamorphosis
initializePlusDiminish(208618) --illidan's grasp
initializePlusDiminish(389831) --snowdrift
initializePlusDiminish(202346) --double barrel
initializePlusDiminish(385149) --exorcism
initializePlusDiminish(255941) --wake of ashes
initializePlusDiminish(200200) --holy word: chastise, stun
initializePlusDiminish(118905) --static charge
initializePlusDiminish(77505 ) --earthquake
initializePlusDiminish(117526) --binding shot
initializePlusDiminish(171017) --Meteor Strike, haven't seen
initializePlusDiminish(408544) --Seismic Slam, seen once in pre-season, evoker stun
initializePlusDiminish(19136) --Stormbolt, av?

hasuitFramesCenterSetDrType("incapacitate") --sheep
initializePlusDiminish(6789) --Mortal Coil
initializePlusDiminish(197214) --Sundering --does this dr?

initialize(22703) --Infernal Awakening --from summon infernal
-- initialize("Blasphemous Existence") --?, from summon infernal?
initialize(213688) --Fel Cleave
initialize(213491) --demonic trample
initialize(208645) --also demonic trample?
initialize("Fel Charge") --?, check for dr? haven't seen
initialize(22911 ) --charge, av, 2 sec stun
initialize(19128) --Knockdown, Drek'Thar in av
-- hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-63,["overridesSame"]=true,["pet"]=commonBigGroupDebuffs[1]}
-- initialize(32752) --Summoning Disorientation, warlock pets friendly buff while summoning another demon


hasuitFramesCenterSetDrType("stun")
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-60,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[1], ["arena"]=commonBigBottomLeftArena[1]} --CC can break, channeled
initializePlusDiminish(305485) --Lightning Lasso

hasuitFramesCenterSetDrType("disorient") --fear
initializePlusDiminish(605) --Mind Control


hasuitSetupFrameOptionsMulti = { --CC can break threshold *1
                          {danMainAuraFunction,         ["priority"]=-57,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[2], ["arena"]=commonBigBottomLeftArena[2], ["specialAuraFunction"]=hasuitSpecialAuraCcBreakThreshold, ["specialIconType"]="ccBreak",["ccBreakHealthThresholdMultiplier"]=1},
                          {hasuitCleuCcBreakThreshold,["ccBreakHealthThresholdMultiplier"]=1},
}
initializeMultiPlusDiminish(360806) --Sleep Walk
initializeMultiPlusDiminish(1513) --Scare Beast
initializeMultiPlusDiminish(10326) --Turn Evil
initializeMultiPlusDiminish(5246) --Intimidating Shout
initializeMultiPlusDiminish(316595) --Intimidating Shout cower
initializeMultiPlusDiminish(316593) --Intimidating Shout cower2, this one has points 5, 5, 0, the other one doesn't have points. one of these knocks back and the other doesn't, other than that identical i think
-- initializeMultiPlusDiminish("Mesmerize") --?
initializeMultiPlusDiminish(6358) --Seduction
initializeMultiPlusDiminish(130616) --Fear, rare, tremble in place talent probably, shares a talent point with 60% increase to breaking so easy to track unless they just don't have either which will be true a lot of the time
-- initializeMultiPlusDiminish("Frightening Shout") --?
initializeMultiPlusDiminish(207167) --blinding sleet
initializeMultiPlusDiminish(207685) --sigil of misery
hasuitFramesCenterSetDrType("incapacitate") --sheep
initializeMultiPlusDiminish(82691 ) --ring of frost
initializeMultiPlusDiminish(GetSpellName(277784)) --Hex
hasuitFramesCenterSetDrType("disorient") --fear
initializeMulti(87204) --Sin and Punishment --no dr
initializeMulti(358861) --Void Volley: Horrify, no dr

hasuitSetupFrameOptionsMulti = { --CC can break threshold *1.75
                          {danMainAuraFunction,         ["priority"]=-57,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[2], ["arena"]=commonBigBottomLeftArena[2], ["specialAuraFunction"]=hasuitSpecialAuraCcBreakThreshold, ["specialIconType"]="ccBreak",["ccBreakHealthThresholdMultiplier"]=1.75}, --could combine specialAuraFunction and specialIconType in a more efficient way i think, after breaking up mainaurafunction
                          {hasuitCleuCcBreakThreshold,  ["ccBreakHealthThresholdMultiplier"]=1.75},
}
initializeMultiPlusDiminish(8122) --Psychic Scream --todo system for changing this to *1 per relevant frame if they're playing void tendrils. not in aura points, so much stuff in points that could never matter (and could never be made sense of, like 3 0s 2 1s and a -100 in random order) and then stuff that actually matters isn't there half the time, also so many points are the same 100% of the time. doesn't that kind of defeat the purpose?
--todo something with Incessant Screams? "Psychic Scream creates an image of you at your location. After 4 sec, the image will let out a Psychic Scream.",
--todo Idol of Y'Shaarj makes fear not break if mindbender used on a feared target?

hasuitSetupFrameOptionsMulti = { --CC can break threshold *1.6
                          {danMainAuraFunction,         ["priority"]=-57,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[2], ["arena"]=commonBigBottomLeftArena[2], ["specialAuraFunction"]=hasuitSpecialAuraCcBreakThreshold, ["specialIconType"]="ccBreak",["ccBreakHealthThresholdMultiplier"]=1.6},
                          {hasuitCleuCcBreakThreshold,  ["ccBreakHealthThresholdMultiplier"]=1.6},
}
initializeMultiPlusDiminish(118699) --Fear, nightmare, not always taken (especially in real 3s?)
initializeMultiPlusDiminish(5484) --Howl of Terror, nightmare?

--rigid ice 80% on frost nova but no1 takes it
--Cacophonous Roar 200% on intimidating shout but no1 takes it? seems good
--Forger of Mountains 200% and -30 sec on landslide, very rarely taken. there's no way this talent isn't worth taking most of the time, even more true with Cacophonous

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-57,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[2], ["arena"]=commonBigBottomLeftArena[2]} --CC can break any damage
initializePlusDiminish(31661) --Dragon's Breath
initializePlusDiminish(198909) --Song of Chi-Ji
initializePlusDiminish(105421) --Blinding Light
-- initializePlusDiminish("Dominate Mind") --?
initializePlusDiminish(427773) --Blind
initializePlusDiminish(2094) --Blind


hasuitFramesCenterSetDrType("incapacitate") --sheep
initializePlusDiminish("Hibernate") --?
initializePlusDiminish(213691) --Scatter Shot
initializePlusDiminish(GetSpellName(118)) --Polymorph
initializePlusDiminish(GetSpellName(383121)) --Mass Polymorph, rare so not sure if there are other spellids
initializePlusDiminish(115078) --Paralysis
initializePlusDiminish(20066) --Repentance
initializePlusDiminish(1776) --Gouge
initializePlusDiminish(6770) --Sap
initializePlusDiminish(107079) --Quaking Palm
initializePlusDiminish(99) --Incapacitating Roar
initializePlusDiminish(217832) --imprison
initializePlusDiminish(3355  ) --freezing trap
initializePlusDiminish(200196) --holy word: chastise, incap


hasuitFramesCenterSetDrType("silence")
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-54,["overridesSame"]=true,    ["group"]=commonBigGroupDebuffs[3], ["arena"]=commonBigBottomLeftArena[3]} --silences
initializePlusDiminish(47476) --Strangulate
initializePlusDiminish(392061) --Wailing Arrow --can this silence anymore? looks like only pve and wailing arrow is also an interrupt todo
initializePlusDiminish(356727) --"Spider Venom", 2nd
initializePlusDiminish(15487) --Silence
initializePlusDiminish(1330) --Garrote - Silence
initializePlusDiminish(204490) --sigil of silence
initializePlusDiminish(217824) --shield of virtue
initializePlusDiminish(374776) --Tightening Grasp, blood dk? not sure if this drs

initialize(81261) --Solar Beam, no dr
initialize(196364) --unstable affliction silence
initialize(410065) --reactive resin


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-51,                           ["group"]=commonBigGroupDebuffs[2], ["arena"]=commonBigBottomLeftArena[2]}
initialize(410201) --Searing Glare
initialize(445134) --Shape of Flame, next attack will miss, physical debuff, from devastation


hasuitFramesCenterSetEventType("cleu")

hasuitSetupFrameOptions = {danCleuInterrupted,          ["priority"]=-48,["duration"]=2,            ["group"]=commonBigGroupDebuffs[4], ["arena"]=commonBigBottomLeftArena[4],} --interrupts, hasuitKICKTextKey = "KICKArena" or "KICKRbg" gets set in loading profile above
initialize(91807) --Shambling Rush
initialize(57994) --Wind Shear
hasuitSetupFrameOptions = {danCleuInterrupted,          ["priority"]=-48,["duration"]=3,            ["group"]=commonBigGroupDebuffs[4], ["arena"]=commonBigBottomLeftArena[4],} --, todo low priority spell schools, maybe hide completely
initialize(47528) --Mind Freeze
initialize(183752) --Disrupt
initialize(147362) --Counter Shot
initialize(398388) --Wailing Arrow
initialize(187707) --Muzzle
initialize(93985) --Skull Bash
initialize(116705) --Spear Hand Strike
initialize(96231) --Rebuke
initialize(31935) --Avenger's Shield with prot pvp talent not against player
initialize(6552) --Pummel
initialize(1766) --Kick
hasuitSetupFrameOptions = {danCleuInterrupted,          ["priority"]=-48,["duration"]=4,            ["group"]=commonBigGroupDebuffs[4], ["arena"]=commonBigBottomLeftArena[4],}
initialize(351338) --Quell
initialize(217824) --Shield of Virtue, maybe wrong spellid?, this is a silence for sure
initialize(347008) --axe toss interrupt
hasuitSetupFrameOptions = {danCleuInterrupted,          ["priority"]=-48,["duration"]=5,            ["group"]=commonBigGroupDebuffs[4], ["arena"]=commonBigBottomLeftArena[4],}
initialize(97547) --Solar Beam
initialize(2139) --Counterspell
initialize(19647) --Spell Lock
initialize(132409) --Spell Lock
hasuitSetupFrameOptions = {danCleuInterrupted,          ["priority"]=-48,["duration"]=6,            ["group"]=commonBigGroupDebuffs[4], ["arena"]=commonBigBottomLeftArena[4],}
initialize(386071) --Disrupting Shout


hasuitFramesCenterSetEventType("aura")

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-45,                           ["group"]=commonBigGroupDebuffs[5], ["arena"]=commonBigBottomLeftArena[5],} --misc
initialize(372048) --Oppressing Roar
initialize(406971) --Oppressing Roar
initialize(383005) --Chrono Loop
initialize(80240) --Havoc

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-42,                           ["group"]=commonBigGroupDebuffs[6], ["arena"]=commonBigBottomLeftArena[6],} --misc
initialize(353293) --Shadow Rift
-- initialize("Spear of Bastion") --?



hasuitFramesCenterSetDrType("root")
hasuitSetupFrameOptionsMulti = {
    rootOptionsBreakable1, --roots with damage threshold, ["textKey"] = "rootArena" or "rootRbg" gets set in loading profile above
    rootOptionsBreakable1CleuPartOptions,
}
initializeMultiPlusDiminish(339) --Entangling Roots
initializeMultiPlusDiminish(102359) --Mass Entanglement
initializeMultiPlusDiminish(355689) --Landslide
initializeMultiPlusDiminish(122) --Frost Nova
initializeMultiPlusDiminish(33395) --Freeze
initializeMultiPlusDiminish(378760) --Frostbite
initializeMultiPlusDiminish(356738) --Earth Unleashed
initializeMultiPlusDiminish(64695) --Earthgrab
initializeMultiPlusDiminish(199042) --Thunderstruck
initializeMultiPlusDiminish(386770) --freezing cold
initializeMultiPlusDiminish(116706) --disable
initializeMultiPlusDiminish(324382) --Clash
initializeMultiPlusDiminish(285515) --surge of power
initializeMultiPlusDiminish(233395) --Deathchill
initializeMultiPlusDiminish(454787) --Ice Prison
initializeMultiPlusDiminish(162480) --steel trap? might not exist anymore
initializeMultiPlusDiminish(393456) --Entrapment
initializeMulti(157997) --Ice Nova, self-dr? could add something to track this for mages or at least make an easy way for them to add stuff to track it themselves
initializeMulti(91807) --Shambling Rush, no dr, breaks

hasuitSetupFrameOptionsMulti = { --higher damage threshold
    rootOptionsBreakable175,
    rootOptionsBreakable175CleuPartOptions,
}
initializeMultiPlusDiminish(228600) --Glacial Spike

hasuitSetupFrameOptions = rootOptions2 --roots don't break or instantly break
initializePlusDiminish(114404) --Void Tendril's Grasp, todo track the relevant void tendril's health instead of normal cc break threshold?
initializePlusDiminish(212638) --Tracker's Net --says any damage breaks it? somehow only seen once
initializePlusDiminish(451517) --Catch Out, hunter, no broken subevents, When a target affected by Sentinel deals damage to you, they are rooted for 3 sec. May only occur every 1 min per target.
initialize(105771) --charge, no dr
initialize(370970) --the hunt
initialize(190925) --Harpoon
initialize(356356) --Warbringer
initialize(45334) --Immobilized, from bear wild charge root, no dr and doesn't break to damage
initialize(81210) --Net, from ashran?
-- initialize(424752) --Piercing Howl, only a 70% slow now
--todo Entangling Vortex



hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-27,["loadOn"]=loadOnNotArenaOnly, ["group"]=commonBigGroupDebuffs[6], ["arena"]=commonBigBottomLeftArena[6]}
initialize(212183) --Smoke Bomb, moved down in priority because range opacity works well enough now + small bug with it being higher than other stuff like cheap shot when there isn't enough room on the frame, ends up weirdly merging/cd text from cheap shot/garrote shows on top of smoke bomb like it belongs to it. It probably belongs down here ideally anyway now --although i think i don't like it in rbgs now, maybe change border or something in rbgs to show it idk
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-27,["loadOn"]=loadOnArenaOnly,    ["group"]=commonBigGroupDebuffs[6],                                         ["specialAuraFunction"]=danSmokeBombSpecialFunctionForPlayer} --bomb on friendly
initialize(212183) --Smoke Bomb
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-27,["loadOn"]=loadOnArenaOnly,                                        ["arena"]=commonBigBottomLeftArena[6],  ["specialAuraFunction"]=danSmokeBombSpecialFunctionForArenaFrames} --bomb on arena, game's range events are broken so this tries to work around it
initialize(212183) --Smoke Bomb



hasuitFramesCenterSetDrType("disarm")
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-26,["overridesSame"]=true,        ["group"]=commonBigGroupDebuffs[6], ["arena"]=commonBigBottomLeftArena[6],} --END CC DEBUFFS ___
initializePlusDiminish(209749) --Faerie Swarm
initializePlusDiminish(233759) --Grapple Weapon
initializePlusDiminish(207777) --Dismantle
initializePlusDiminish(236077) --Disarm
initializePlusDiminish(325153)--exploding keg


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-24,                       ["group"]=commonBigGroupDebuffs[7], ["arena"]=commonBigBottomLeftArena[7],}
initialize("Duel") --?
initialize(394119) --Blackjack (30%)
initialize(410598) --Soul Rip (25%)
initialize(77606) --Dark Simulacrum stealing next
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-24,                       ["group"]=commonBigGroupDebuffs[7], ["arena"]=commonBigBottomLeftArena[7],["specialAuraFunction"]=hasuitDarkSimShowingWhatGotStolenSpecialFunction,["specialIconType"]="greenBorder"}
initialize(77616) --Dark Simulacrum has something stolen, untested, not sure exactly where to show this, should probably just make a controller for stuff to show in the middle of the screen? and probably not care about friendly stolen, but this for now, todo


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=257,                       ["group"]=commonBigGroupDebuffs[7], ["arena"]=commonBigBottomLeftArena[7],} --todo
initialize(356723) --scorpid venom, 1st
initialize(289959) --dead of winter
initialize(389823) --snowdrift dot/buildup --bored todo this could be normal cd swipe(auras are reversed), makes more sense that way although probably just a bad idea since it's an aura and those are meant to be reversed
initialize(117405) --binding shot, todo timer like solar beam, todo hide after stun

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=258,                       ["group"]=commonBigGroupDebuffs[7],     }
initialize(442804) --Curse of the Satyr
initialize(2812) --Denounce, can't crit
-- initialize("Divine Plea")
hasuitSetupFrameOptions = {hasuitAuraPoints1Required,   ["priority"]=258,   ["points1"]=-20,    ["group"]=commonBigGroupDebuffs[7], ["arena"]=commonBigBottomLeftArena[7], ["textKey"]="pointsTextWeakness", ["actualText"]="20%"}
initialize(1714) --Curse of Tongues only 20% casting speed (ignore 10%) --todo improve dispellable debuffs display, stuff like tongues/wound/whatever that might not be worth to dispel alone but knowing multiple different things are there can change things. should make some kind of display for % healing reduction too
hasuitSetupFrameOptions = {hasuitAuraPoints2Required,   ["priority"]=258,   ["points2"]=-100,   ["group"]=commonBigGroupDebuffs[7], ["arena"]=commonBigBottomLeftArena[7], ["textKey"]="pointsTextWeakness", ["actualText"]="100%"}
initialize(702) --Curse of Weakness only 100% crit

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=259,                       ["group"]=commonBigGroupDebuffs[7],     }
initialize(356730) --viper venom --3rd, 20% dam/healing

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=260,                       ["group"]=commonBigGroupDebuffs[7],     }
initialize(15007) --Resurrection Sickness






































hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-19,                       ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize35} --SMALL BUFFS ___
initialize(27827) --Spirit of Redemption death
-- initialize(211319) --Restitution, todo
initialize(215769) --Spirit of Redemption cast
initialize(642) --Divine Shield
initialize(45438) --Ice Block
initialize(414658) --Ice Cold
initialize(31224) --Cloak of Shadows, todo Veil of Midnight bop
initialize(362486) --Keeper of the Grove
initialize(196555) --Netherwalk
initialize(186265) --Aspect of the Turtle
initialize(409293) --Burrow
initialize(408558) --Phase Shift





hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-17,                       ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize35}
initialize(353319) --Peaceweaver
initialize(48707) --Anti-Magic Shell
initialize(410358) --Anti-Magic Shell, external from pvp talent?
initialize(444741) --Anti-Magic Shell, from unit type: guardian?
initialize(204018) --Blessing of Spellwarding
initialize(8178) --Grounding Totem
initialize(248519)--Interlope, does this belong here?
initialize("Guided Meditation") --?
initialize(212295) --Nether Ward
initialize(23920) --spell reflection --can stack twice? from rebound

-- hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-16,                       ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize35}
-- initialize("Ethereal Form") --?

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-15,["overridesSame"]=true,["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize35} --todo make better
initialize(1022) --Blessing of Protection
initialize(199507) --Spreading The Word: Protection, 30% physical wall after bop from honor talent, todo text to differentiate from gift of the naaru or some way of doing that? ` they look the same on friendly frames i think


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-13,                   ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize35} --todo track 212704 357140 384100 lichborne, 384100?, 384102 for fear classes, fear immunity, todo Demolish casting immune to stuns, no unitaura. also ultimate Penitence absorb doesn't show cc immunity perfectly so new thing that shows casts as a buff will be useful for that too. oh and whether that's interruptible or not might help track it better
initialize(377362) --Precognition
initialize(378464) --Nullifying Shroud
initialize(442204) --Breath of Eons, immune to cc for 3.75 sec
initialize(403631) --Breath of Eons, immune to cc for 6 sec
initialize(433874) --Deep Breath, immune to cc for 3.75 sec
initialize(357210) --deep breath
initialize(359816) --dream flight, immune for 6 sec
initialize("Nimble Brew") --?
initialize(213610) --Holy Ward
initialize(446035) --Bladestorm
initialize(227847) --Bladestorm
initialize(389774) --Bladestorm
initialize(421453) --Ultimate Penitence absorb(cc immunity?) todo improve this since basing this on the absorb buff isn't perfect
-- initialize(436358) --Demolish, immune to stuns/knockbacks? todo there's no unit_aura for this. it gets cleu applied though for some reason, along with channel start and cast success
-- initialize("Adaptation") --adapted is the debuff, todo maybe? no unitaura for this
initialize(354610) --glimpse
initialize(269513) --Death from Above?
initialize(206803) --Rain from Above 1 sec immunity
initialize(329543) --Divine Ascension 1 sec immunity
initialize(126389) --Goblin Glider
initialize(294384) --Horde Glider
initialize(294383) --Alliance Glider

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-10,                   ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize25}
initialize(456499) --Absolute Serenity, immune to incap, disorient, snare, and root
-- todo Fear No Evil 50% shorter fears on paladins


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-9,                    ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize35}
initialize(47788) --Guardian Spirit, todo
initialize(31850) --Ardent Defender, todo similar to guardian spirit?

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-7,                    ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize35}
initialize(6940 ) --blessing of sac
initialize(199448)  --blessing of sacrifice 100%? todo text or show the difference



hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-5,                    ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize35}
initialize(48792) --Icebound Fortitude
initialize(198144) --Ice Form
initialize(212800) --Blur
initialize(118038) --Die by the Sword
initialize(210256) --Blessing of Sanctuary
initialize(5277) --Evasion
initialize(120954) --Fortifying Brew, todo show 25% dodge




hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-3,                    ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize30}
initialize(386397) --Battle-Scarred Veteran, prot warrior 80% damage reduction and healing increase falling under 30% health
initialize(871) --Shield Wall
initialize(61336) --Survival Instincts
initialize(202748) --Survival Tactics, todo fake absorb bar, same with touch of karma?
initialize(125174)  --touch of karma
initialize(342246) --Alter Time
initialize(113862)  --greater invisibility 60% dam reduc
initialize(232708) --Ray of Hope, todo
initialize(232707) --Ray of Hope
initialize(47585) --Dispersion
initialize(363916) --Obsidian Scales, labeled friendly only?
initialize(370984) --Emerald Communion
initialize(45182) --Cheating Death
initialize(86659) --Guardian of Ancient Kings
initialize(393108) --Guardian of Ancient Kings, 4 sec proc? the other spellid has 4 sec procs though too
initialize(225080) --Reincarnation --todo put center instead?
initialize(207498) --Ancestral Protection
initialize(255234) --Totemic Revival


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-2,                    ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize25}
initialize(22812) --Barkskin
initialize(200851) --Rage of the Sleeper
initialize(116888) --Shroud of Purgatory
initialize(353362) --Dematerialize
initialize(122278) --Dampen Harm
initialize(122783) --Diffuse Magic
initialize(264735) --Survival of the Fittest
initialize("Prismatic Cloak") --?
initialize(198111) --Temporal Shield
initialize(33206) --Pain Suppression
initialize(108271) --Astral Shift
initialize(104773) --Unending Resolve
initialize(329042) --Emerald Slumber, seen once pre-season
initialize("Zen Meditation") --?
initialize(184364) --Enraged Regeneration
initialize(498) --Divine Protection
initialize(403876) --Divine Protection
initialize(389539) --Sentinel
-- initialize("Eye for an Eye") --?, doesn't exist anymore?
initialize(55233) --Vampiric Blood

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-2,                    ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize25}
initialize(454863) --Lesser Anti-Magic Shell --30% partial_cc reduction 



hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=1,["overridesSame"]=true,["group"]=danCommonTopLeftGroup,  ["arena"]=commonBigBottomLeftArenaDefensivesSize25}
initialize(374348)  --renewing blaze
initialize(374349)  --renewing blaze hot

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=3,                     ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize25}
initialize(102342) --Ironbark
initialize(147833) --Intervene
initialize(53480) --Roar of Sacrifice
initialize(357170)--Time Dilation, 50% of damage is being delayed and dealt to you over time.
initialize(443526)--Premonition of Solace, 15-21% damage reduction? and an absorb?


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=8,                     ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize25,}
initialize(58984) --Shadowmeld
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=9,                     ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} --stealths, todo, what was this todo for?, should maybe make stealths show left of arena frames with important defensives?
initialize(5215) --Prowl
initialize(102547) --Prowl, maybe from feral incarn? should really switch to spell name based (almost) everything assuming it works fine in other languages. there are always going to be new random spellids for the same thing popping up over time, an ignore list for certain spellids would probably be a way better system. not to mention having an extra unwanted icon is a lot better than missing an icon that should be there, and new stuff not showing when it should will be way more common than new stuff showing when it shouldn't, unrelated todo could be nice to base cooldown stuff on unit aura as much as possible because when enemy presses something while stealthed it won't show the cd, even if the aura for the cd is showing on them when they come out and tracking is based on cleu applied, also preventing auras from disappearing on frames when they go stealth would be nice
initialize(199483) --Camouflage
initialize(1784) --Stealth? uncommon
initialize(115191) --Stealth
initialize(11327) --Vanish
initialize(414664)  --Mass Invisibility
initialize(114018)--shroud of concealment
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=9,                     ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,  ["specialAuraFunction"]=hasuitFeignDeath}
initialize(5384)--Feign Death, track Lifebind?

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=10,                    ["group"]=danCommonTopLeftGroupAlpha40,["arena"]=commonTopRightArenaAlpha40,}
initialize(32612) --Invisibility, 66 is the 3 sec pre-invis buff todo lower opacity?
initialize(110960)  --greater invisibility invis --todo override, should make a better override system


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=12,                    ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,}
initialize(213871) --Bodyguard
initialize("Avert Harm") --?
initialize(49039) --Lichborne
initialize(116849) --Life Cocoon
initialize(184662) --Shield of Vengeance
initialize(22842) --Frenzied Regeneration
initialize(326808) --Rune of Sanguination, todo cooldown, is Shroud of Purgatory related?
initialize(388013) --Blessing of Spring, 30% healing taken/15% healing increased, todo could do something to show summer like a dot? maybe show winter similarly with innervate? not sure it should be shown at all though. it isn't purgable


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=40,                    ["group"]=danCommonTopLeftGroup,    ["arena"]=commonBigBottomLeftArenaDefensivesSize25}
initialize(256948) --Spatial Rift
initialize(206804) --Rain from Above glide

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=45,                                                        ["arena"]=commonBigBottomLeftArenaDefensivesSize25}
initialize(236321) --War Banner, todo show this? --50% partial_cc reduction
initialize(432180) --dance of the wind, stacking dodge from monk, todo stacks
initialize(357714) --Void Volley, the 3 sec helpful buff, not sure this is the best place to show this


hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=50,                ["group"]=danCommonTopLeftGroup,        ["arena"]=commonBigBottomLeftArenaDefensivesSize25}
initialize(188501) --Spectral Sight, todo could do something with shadow sight timers/show the debuff on people if stealthed



hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=55,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} 
initialize(32216) --Victorious, warrior impending?

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=55,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} 
initialize(15286) --Vampiric Embrace
initialize(333889) --Fel Domination
initialize(55342)   --Mirror Image

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=60,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,}
initialize(209426)  --Darkness --todo make a timer for stuff like this barrier and beam etc, like normal aura icons
initialize(145629) --Anti-Magic Zone
initialize(81782) --Power Word: Barrier
initialize(354704) --Grove Protection

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=65,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} 
initialize(124682) --enveloping mist

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=66,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} 
initialize(102352) --main healing cenarion Ward
hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=70,                ["group"]=danCommonTopLeftGroupAlpha40,["arena"]=commonTopRightArenaAlpha40,} 
initialize(102351) --40% alpha idle cenarion Ward

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=75,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} 
initialize(115175) --soothing mist
initialize(200652) --tyr's deliverance
initialize(148039) --Barrier of Faith
initialize(188550) --lifebloom
initialize(33763) --lifebloom

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=80,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,  ["specialAuraFunction"]=soulHotsSpecialFunction, ["specialIconType"]="optionalBorder"}
initialize(774) --rejuvenation
initialize(155777) --germination

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=81,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} 
-- initialize(974) --Earth Shield, ele/enh?
initialize(383648) --Earth Shield, resto?
initialize(61295) --Riptide
initialize(363502) --Dream Flight

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=82,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} 
initialize(139) --Renew
initialize(290754) --Lifebloom from Full Bloom (early spring), todo show the difference between this and normal lifebloom? either green border or smaller not sure

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=84,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,["specialAuraFunction"]=blessingOfAutumnSpecialFunction} 
initialize(388010) --Blessing of Autumn, 30% cd reduction on all abilities for 30 sec? not sure if this should be showing or to make something to put the timer on something other than an aura icon

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=85,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} --329267 or 385391 20% magic damage reduction from spell reflect?
initialize(185311) --Crimson Vial
initialize(194679) --Rune Tap
initialize(5487) --Bear Form
-- initialize("Defensive Stance") --worth to track? --didn't it get buffed by 5% recently?
initialize(GetSpellName(59547)) --Gift of the Naaru
-- initialize(262080) --Empowered Healthstone, 30% hot over 6 sec, does this exist? what is 462156 Emergency Healthstone? hopefully that wasn't from tracking during comp stomp on accident. 462156 has been seen a single time since tww release

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=90,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,}
initialize(114052)  --resto ascendance, should track stuff like this in a different way probably? or add more
initialize(31884) --Avenging Wrath
initialize(47536) --Rapture

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=95,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,}
initialize(378081) --Nature's Swiftness shaman
initialize(132158) --Nature's Swiftness Druid

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=97,                ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena, ["specialAuraFunction"]=hasuitSoulOfTheForest}
initialize(114108) --Soul of the Forest


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=100,               ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,}
initialize(387636) --Soulburn: Healthstone, 20% 12 sec health increase? --todo about to fall off? or is that lame. maybe avoid things that play the game for you like that, also not sure that's much of a thing anymore except on rally, maybe emblem
initialize(12975) --Last Stand
initialize(345231) --Gladiator's Emblem
initialize(392956) --Fortitude of the Bear, 20% 10 sec health increase + heal for that amount
initialize(388035) --Fortitude of the Bear, pet only?
initialize(19236) --Desperate Prayer
initialize(377088) --Rush of Vitality

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=105,               ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} 
initialize(205655) --Dome of Mist
initialize(353503) --Counteract Magic
initialize(97463) --Rallying Cry
-- initialize(33891) --Incarnation: Tree of Life, todo show timer of 117679 somehow, could do something like icon turns red if actual tree is missing but incarn is up, todo show which is the main 30 sec duration and which is a proc?

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=107,               ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,} 
initialize(370889) --Twin Guardian (rescue absorb)
initialize(17) --Power Word: Shield
-- initialize(235450) --Prismatic Barrier, todo something for -24% magic duration or whatever it is?
-- initialize(414663) --Prismatic Barrier
-- initialize(11426) --Ice Barrier, 50% slow to melee
-- initialize(414661) --Ice Barrier
-- initialize(235313) --Blazing Barrier, todo something to show big thorns pvp talent 800%?
-- initialize(414662) --Blazing Barrier, todo smaller icons for these and in general

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=110,               ["group"]=danCommonTopLeftGroup,    ["arena"]=commonTopRightArena,}
initialize(381755) --earth elemental 15% bonus health
-- initialize(386237) --Fade to Nothing, 10% damage reduction
-- initialize(586) --Fade, todo tell if it's 10% or useless from points[1]
initialize(20578) --Cannibalize









hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=115,               ["group"]=danCommonTopLeftGroup,        }    --PET DEFENSIVES, todo
initialize(7870) --Lesser Invisibility, succubus pet
initialize(96243) --Invisibility, pet?
initialize("Play Dead")
initialize("Soulburn: Health Funnel")
initialize("Agile Reflexes")
initialize("Ancient Hide")
initialize("Bristle")
initialize("Bulwark")
initialize("Catlike Reflexes")
initialize("Defense Matrix")
initialize("Dragon's Guile")
initialize("Feather Flurry")
initialize("Fleethoof")
initialize("Gastric Bloat")
initialize("Gruff")
initialize("Harden Carapace")
initialize("Harden Skin")
initialize("Hardy")
initialize("Huddle")
initialize("Niuzao's Fortitude")
initialize("Obsidian Skin")
initialize("Primal Agility")
initialize("Protective Bile")
initialize("Putrid Bulwark")
initialize("Scale Shield")
initialize("Serpent's Swiftness")
initialize(17767) --Shadow Bulwark
initialize(132413) --Shadow Bulwark
initialize("Shadow Shield")
initialize("Shell Shield")
initialize("Shimmering Scales")
initialize("Silverback")
initialize("Solid Shell")
initialize("Spirit Walk")
initialize("Stone Armor")
initialize("Swarm of Flies")
initialize("Thick Fur")
initialize("Thick Hide")
initialize("Void Shield")
initialize("Winged Agility")
initialize("Mend Pet")
initialize("Feast")

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=120,                       ["group"]=danCommonTopLeftGroup,        } --END SMALL BUFFS ___
initialize(61684) --pet dash
initialize(24450) --pet Prowl











local middleGroupImportantMisc  =   {["controller"]=danMiddleMiddle,                ["size"]=21,    ["frameLevel"]=21,  ["hideCooldownText"]=true,  ["alpha"]=1,    }

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=150,["loadOn"]=loadOnBgOnly,["group"]=middleGroupImportantMisc,        ["specialAuraFunction"]=danAuraFlagDebuffSpecialFunctionBg, ["textKey"]="danFontOrbOfPower", ["actualText"]=""} --textkey stuff to prevent it from getting stack text normally --this doesn't prevent anything? but oh well
initialize(46392)--Focused Assault
initialize(46393) --Brutal Assault

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=153,["loadOn"]=loadOnBgOnly,["group"]=middleGroupImportantMisc,        ["specialAuraFunction"]=danAuraOrbOfPowerSpecialFunction} --debuff doesn't have stacks so can do it differently than wsg/twin peaks debuffs
initialize(121177) --Orb of Power
initialize(121176) --Orb of Power
initialize(121175) --Orb of Power
initialize(121164) --Orb of Power

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=155,["loadOn"]=loadOnBgOnly,["group"]=middleGroupImportantMisc,        } --BG DEBUFFS ___
initialize(34976) --Netherstorm Flag
initialize(156621) --Alliance Flag
initialize(156618) --Horde Flag
initialize(434339) --Deephaul Crystal, new bg's flag
initialize(231529) --Purple Dunkball
initialize(231813) --Green Dunkball
initialize(231814) --Orange Dunkball





hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-100,["loadOn"]=loadOnBgOnly,["group"]=danCommonTopLeftGroup,      } --leaf, above other buffs top left 
initialize(GetSpellName(23493)) --Restoration, leaf on flag maps
initialize(422968) --Rune of Frequency, 50% cd reduction for 30 sec

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=160,["loadOn"]=loadOnBgOnly,["group"]=danCommonTopLeftGroup,       } --BG BUFFS ___
initialize(24378)   --rbg berserking?
initialize(240466)  --rbg berserking?
initialize(314058)  --rbg berserking?
initialize(296576)  --rbg berserking?
-- initialize("No Falling Damage") --seething shore. this is just a permanent buff and there are no buffs indicating who's falling or on the ship other than a parachute for the last tiny bit that someone's falling. could make some timers for each unit based on the spirit healer/when people die in rated. that would be nice tech to have for all bgs --will be very easy actually
initialize(66657) --Parachute
initialize(55001) --Parachute
initialize(68298) --Parachute
initialize(294701) --Speed Up?
initialize(23451) --Speed
initialize(23978) --Speed














































local dotDebuffsArena = {
    18,
    17,
    14,
    13,
    12,
}
local dotDebuffsRbg = {
    12,
    11,
    10,
    10,
    10,
}

local danCommonTopRightGroupDebuffs = {}
local danCommonTopLeftArenaDebuffs = {} --could set ["arena"] to nil
for i=1,5 do
    danCommonTopRightGroupDebuffs[i]    =  {["controller"]=danTopRight_TopRight,   ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1,    }
    danCommonTopLeftArenaDebuffs[i]     =  {["controller"]=danTopLeft_TopLeft,     ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1,    }
end


do --groupSize 5 or less
    local loadOn = {}
    local mainLoadOnFunctionSpammable = hasuitMainLoadOnFunctionSpammable
    local function loadOnCondition()
        if hasuitGroupSize<=5 then --should load
            if not loadOn.shouldLoad then
                loadOn.shouldLoad = true
                mainLoadOnFunctionSpammable()
                for i=1,5 do
                    danCommonTopRightGroupDebuffs[i]["size"] = dotDebuffsArena[i]
                    danCommonTopLeftArenaDebuffs[i]["size"] = dotDebuffsArena[i] --todo maybe get rid of these for arena, might do something with making frames in bgs later might not. --actually ya what does this line even do atm? nothing exists for arena units outside of arena not going to mess with it because it's what sets the size initially but ya
                end
            end
        else --should NOT load
            if loadOn.shouldLoad~=false then
                loadOn.shouldLoad = false
                mainLoadOnFunctionSpammable()
                for i=1,5 do
                    danCommonTopRightGroupDebuffs[i]["size"] = dotDebuffsRbg[i] --todo turn this kind of setup into an easier to use function
                    danCommonTopLeftArenaDebuffs[i]["size"] = dotDebuffsRbg[i]
                end
            end
        end
    end
    tinsert(hasuitDoThisGroup_Roster_UpdateGroupSize_5.functions, loadOnCondition)
    loadOnCondition()
    hasuitLoadOnPartySize = loadOn
end


hasuitFramesCenterSetEventType("cleu")

hasuitSetupFrameOptions = {danCleuINC,                  ["priority"]=-22,               ["group"]=commonBigGroupDebuffs[7],         ["arena"]=commonBigBottomLeftArena[7],  ["ignoreSource"]=true,  ["duration"]=2.5,["spellINCType"]="aura",   } --SPELL INC ___
initialize(89766) --axe toss stun
initialize(119914) --axe toss cast success
hasuitSetupFrameOptions = {danCleuINC,                  ["priority"]=-22,               ["group"]=commonBigGroupDebuffs[7],         ["arena"]=commonBigBottomLeftArena[7],  ["duration"]=2.5,["spellINCType"]="aura",   }
initialize(6789) --Mortal Coil
initialize(107570) --Storm Bolt cast and damage, damage unused here
initialize(132169) --Storm Bolt aura

hasuitSetupFrameOptions = {danCleuINC,                  ["priority"]=-21,               ["group"]=commonBigGroupDebuffs[7],         ["arena"]=commonBigBottomLeftArena[7],  ["duration"]=2.5,["spellINCType"]="aura",   }
initialize(212638) --tracker's net
initialize(213691) --Scatter Shot


hasuitSetupFrameOptionsMulti = { --priority_1
                          {danCleuINC,                  ["priority"]=186,               ["group"]=danCommonTopRightGroupDebuffs[1], ["arena"]=danCommonTopLeftArenaDebuffs[1],  ["duration"]=2.5,},
                          {danUnitCasting,              ["priority"]=186,               ["group"]=danCommonTopRightGroupDebuffs[1], ["arena"]=danCommonTopLeftArenaDebuffs[1],  },
}
initializeMulti(203286) --Greater Pyroblast cast/success/damage, what's 450421 from? damage only but from npc once/guardian 7x and never from a player, 203286 has 8 spell damage total too all from a player
initializeMulti(203155) --Sniper Shot
initializeMulti(117014) --Elemental Blast
initializeMulti(274283) --Full Moon
initializeMulti(199786) --Glacial Spike cast
initializeMulti(116858) --Chaos Bolt
initializeMulti(370965) --The Hunt
initializeMulti(410126, 2) --Searing Glare cast --todo --__priority_1 cast-only
initializeMulti(357208, 2) --fire breath cast --todo
initializeMulti(382266, 2) --fire breath cast2? --todo
initializeMulti(198100, 2) --Kleptomania, todo update target based on cleu spellsteal
hasuitSetupFrameOptions = hasuitSetupFrameOptionsMulti[1]
initialize(280719) --Secret Technique, success
initialize(280720) --Secret Technique, damage
initialize(282449) --Secret Technique, success and damage from guardian
initialize(228600) --Glacial Spike damage/aura
initialize(370970) --the hunt root
hasuitSetupFrameOptions = {danCleuCasting,              ["priority"]=186,               ["group"]=danCommonTopRightGroupDebuffs[1], ["arena"]=danCommonTopLeftArenaDebuffs[1],  ["castType"]="channel", ["backupDuration"]=1.6,}
initialize(359073) --eternity surge --todo inc based on dest guid for cleu
initialize(382411) --eternity surge --359077 is damage
initialize(408092) --Upheaval cast, 396286 rare cast?, 396288 damage, todo cc category for knocked in the air like this?


hasuitSetupFrameOptionsMulti = { --priority_2
                          {danCleuINC,                  ["priority"]=300,               ["group"]=danCommonTopRightGroupDebuffs[2], ["arena"]=danCommonTopLeftArenaDebuffs[2],  ["duration"]=2.5,},
                          {danUnitCasting,              ["priority"]=300,               ["group"]=danCommonTopRightGroupDebuffs[2], ["arena"]=danCommonTopLeftArenaDebuffs[2],  },
}
initializeMulti(133) --Fireball
initializeMulti(11366) --Pyroblast
initializeMulti(116) --frostbolt cast
initializeMulti(228597, 1) --frostbolt damage
initializeMulti(30455, 1) -- Ice Lance cast success, todo only track if this will do significant damage? might want to tone down some stuff here, especially for someone new to the addon. there should be levels of how much chaos there should be that can be selected in options, probably with the default being at max and a recommendation to lower it
initializeMulti(228598, 1) -- Ice Lance damage
initializeMulti(431044) --Frostfire Bolt
initializeMulti(468655, 1) --Frostfire Bolt damage/aura
initializeMulti(51505) --Lava Burst cast
initializeMulti(285452, 1) --Lava Burst damage
initializeMulti(29722) --Incinerate --todo track if big dam somehow? that could be very useful for a bunch of stuff but very specific and probably short term effectiveness. probably reserve that for things that are either weak/normal sometimes and very strong sometimes depending on an aura or whatever. some things like chaos bolt could get a % modifier number on the icon that changes based on how many procs they get, like a trinket proc adds a 1.13 multiplier/weapon enchant adds another etc, or could possibly do that for all non-dot casts as long as it doesn't obscure the icon texture too much
initializeMulti(210714) --Icefury
initializeMulti(274281) --New Moon
initializeMulti(274282) --Half Moon
initializeMulti(384110) --Wrecking Throw cast
initializeMulti(394354, 1) --Wrecking Throw damage
initializeMulti(64382) --Shattering Throw cast
initializeMulti(394352, 1) --Shattering Throw missed?
initializeMulti(64380, 1) --Shattering Throw dispel?
initializeMulti(392060) --Wailing Arrow cast
initializeMulti(392058, 1) --Wailing Arrow damage
initializeMulti(19434) --aimed shot
initializeMulti(48181) --Haunt
initializeMulti(228260) --Void Eruption --does this have a travel time?
initializeMulti(6353) --Soul Fire
initializeMulti(104316) --Call Dreadstalkers cast
initializeMulti(193331, 1) --Call Dreadstalkers spell_summon
initializeMulti(193332, 1) --Call Dreadstalkers spell_summon
initializeMulti(5176) --Wrath
initializeMulti(190984) --Wrath
-- initializeMulti("Nether Portal") --?
initializeMulti(153561, 1) --Meteor, cast success, 117588 is meteor from pet?, --__instant inc
initializeMulti(351140, 1) --Meteor, cast damage
initializeMulti(44425, 1) --Arcane Barrage, cast success and damage
initializeMulti(434021, 1) --Arcane Barrage, uncommon spell damage
initializeMulti(370452, 1) --Shattering Star, todo spell_cast_success doesn't happen at the right time. need unit_spellcast_succeeded
initializeMulti(257541, 1) --Phoenix Flames, cast success
initializeMulti(257542, 1) --Phoenix Flames, damage
initializeMulti(78674, 1) --Starsurge
initializeMulti(197626, 1) --Starsurge resto?
initializeMulti(375982, 1) --Primordial Wave spell_cast_success
initializeMulti(375984, 1) --Primordial Wave spell_damage
initializeMulti(305392, 1) --?, Chill Streak cast success
initializeMulti(204167, 1) --?, Chill Streak damage
initializeMulti(357212, 1) --pyre spell_damage
initializeMulti(357211, 1) --pyre spell_cast_success
hasuitSetupFrameOptions = {danCleuINC,                  ["priority"]=300,               ["group"]=danCommonTopRightGroupDebuffs[2], ["arena"]=danCommonTopLeftArenaDebuffs[2],  ["duration"]=2.5,   ["spellINCType"]="aura",}
initialize(212431) --Explosive Shot

initializeMulti(386997, 2) --Soul Rot --priority_2 cast-only
initializeMulti(34914, 2) --Vampiric Touch
initializeMulti(391109, 2) --Dark Ascension, this makes void volleys fly around and cc people? also buffs non-periodic by 20% and generates 30 insanity should do something to show friendly cc casts more clearly, or audio for it. enemy cc spellcasts are going to show in middle cast bars i think
initializeMulti(376103, 2) --Radiant Spark
initializeMulti(375901, 2) --Mindgames
initializeMulti(214621, 2) --Schism
initializeMulti(348, 2) --Immolate cast/direct damage
initializeMulti(407466, 2)--Mind Spike: Insanity
initializeMulti(73510, 2) --Mind Spike
initializeMulti(194153, 2) --Starfire
initializeMulti(202347, 2) --Stellar Flare
initializeMulti(390612, 2) --Frost Bomb
initializeMulti(5143, 2) --Arcane Missiles
initializeMulti(395160, 2) --Eruption
initializeMulti(198013, 2) --Eye Beam --todo eye beam causes 2 channel start events on the same frame and no cleu cast event. will need a significant change to the setup to get this to not show 2
initializeMulti(212084, 2) --Fel Devastation, channel
initializeMulti(436358, 2) --Demolish, channel
initializeMulti(353082, 2) --Ring of Fire
initializeMulti(113656, 2) --Fists of Fury, channel --todo track Heavy-Handed Strikes 100% parry buff
initializeMulti("Rune of Power", 2) --?, Rune of Power, don't think this exists anymore?
initializeMulti(191634, 2) --Stormkeeper
initializeMulti(353128, 2) --?, Arcanosphere, channel
initializeMulti(365350, 2) --Arcane Surge
initializeMulti(324536, 2) --Malefic Rapture, todo proper targets inc icon
initializeMulti(368847, 2) --?, Firestorm
initializeMulti(278350, 2) --Vile Taint --30 sec cd aoe dot affliction?
hasuitFramesCenterSetEventType("unitCasting")
hasuitSetupFrameOptions = {danUnitCasting,              ["priority"]=300,               ["group"]=danCommonTopRightGroupDebuffs[2], ["arena"]=danCommonTopLeftArenaDebuffs[2],  ["ignoreSameUnitType"]=true,}
initialize(361469) --Living Flame, there's a guardian (did i mean pres? ah no the unit type is guardian, not the spec) version of this 401382
initialize(431443) --Chrono Flames
initialize(47758) --Penance --todo get correct dest unit from cast success
initialize(373129) --Dark Reprimand
hasuitSetupFrameOptions = {danUnitCasting,              ["priority"]=300,                                                           ["arena"]=danCommonTopLeftArenaDebuffs[2]} --same as priority_2, less important on arena frames
initialize(342938) --Unstable Affliction cast arena
initialize(316099) --Unstable Affliction cast arena

hasuitSetupFrameOptions = {danUnitCasting,              ["priority"]=-74,               ["group"]=danCommonTopRightGroupDebuffs[3]} --special cast-only priority_0 for unstable affliction, smaller but higher priority todo?: should be less important for people who have no ability to dispel it, but maybe hard to get that exactly right and keep it right over time
initialize(342938) --Unstable Affliction cast group
initialize(316099) --Unstable Affliction cast group, todo guess target based on combat log and show even when unit not seen. could base target on what was more recent between a cleu event or a unit_target event to try to guess focus casts? not perfect, but ya knowing a ua is coming in an rbg is especially important


hasuitSetupFrameOptions = {danUnitCasting,              ["priority"]=301,               ["group"]=danCommonTopRightGroupDebuffs[3], ["arena"]=danCommonTopLeftArenaDebuffs[3],  } --priority_3 cast-only
initialize(14914) --Holy Fire
initialize(8092) --Mind Blast
initialize(450983) --Void Blast
initialize(450215) --Void Blast
initialize(585) --Smite
initialize(27243) --Seed of Corruption
initialize(105174) --Hand of Gul'dan
initialize(353753) --Bonds of Fel
initialize(188443) --Chain Lightning
initialize(188196) --Lightning Bolt
initialize(461404) --Chi Burst
initialize(101546) --Spinning Crane Kick, channel
initialize(190356) --Blizzard
initialize(30451) --Arcane Blast
initialize(436344) --Azerite Surge from new race earthen




-- hasuitSetupFrameOptions = {danCleuINC,   ["duration"]=2.5,                           ["priority"]=256,               ["group"]=danCommonTopRightGroupDebuffs[3], ["arena"]=danCommonTopLeftArenaDebuffs[3],  }
-- initialize("Kill Shot")
-- initialize("Wrath")
-- initialize("Steady Shot")
-- initialize(686) --shadow bolt
-- initialize("Hand of Gul'dan")
-- initialize("Fel Lance")
-- initialize("Unravel")
-- initialize("Arcane Shot")
-- initialize("Barbed Shot")
-- initialize("Chimaera Shot")
-- initialize("Comet Storm")
-- initialize("Flurry")
-- initialize("Ice Lance")
-- initialize("Hammer of Wrath")
-- initialize("Ebonbolt") --removed?
-- initialize("Doom Bolt") --?

-- hasuitSetupFrameOptions = {danCleuINC,   ["duration"]=2.5,                           ["priority"]=198,               ["group"]=danCommonTopRightGroupDebuffs[2], ["arena"]=danCommonTopLeftArenaDebuffs[2],  }

-- hasuitSetupFrameOptions = {danCleuINC,   ["duration"]=2.5,                           ["priority"]=300,               ["group"]=danCommonTopRightGroupDebuffs[5], ["arena"]=danCommonTopLeftArenaDebuffs[5],  }
-- initialize("Wind Arrow")
-- initialize("Lava Burst Overload")
-- initialize("Icefury Overload")
-- initialize("Elemental Blast Overload")
-- initialize("Lightning Bolt Overload")
-- initialize("Chain Lightning Overload")

-- initialize("Convoke the Spirits")
-- initialize("Barrage")
-- initialize("Channel Demonfire") --?

-- initialize("Fury of the Eagle")
-- initialize("Scorch")
-- initialize("Judgment")
-- initialize("Power Word: Solace")
-- initialize("Shadow Word: Death")
-- initialize("Shadowy Apparition")
-- initialize("Shadowy Apparitions")
-- initialize("Poisoned Knife")
-- initialize("Shuriken Toss")
-- initialize("Arcane Orb") --no dest
-- initialize(115098) --chi wave
-- initialize("Chakrams")
-- initialize("Death Chakram")






































hasuitFramesCenterSetEventType("aura")

hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=-73,                   ["group"]=danCommonTopRightGroupDebuffs[4],     } --DOTs/damage debuffs ___ todo different priority for dispel protection stuff if player actually has dispel
initialize(316099)--unstable affliction dot group
initialize(342938)--unstable affliction dot group


hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=210,                   ["group"]=danCommonTopRightGroupDebuffs[1], ["arena"]=danCommonTopLeftArenaDebuffs[1],}
initialize(257044) --Rapid Fire
initialize(205021) --Ray of Frost
initialize(417537) --Oblivion, warlock 3 sec channel/debuff pvp talent
initialize(263165) --Void Torrent



hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=213,["overridesSame"]=true,["group"]=danCommonTopRightGroupDebuffs[1],["arena"]=danCommonTopLeftArenaDebuffs[1],} --big mortal strike effects, todo text
initialize(199845) --Psyflay
initialize(198819) --sharpen (Mortal Strike) --these were 221 priority
initialize(288849) --Crypt Fever (healing extends dot) --todo lower priority if not healer?


hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=215,                   ["group"]=danCommonTopRightGroupDebuffs[1], ["arena"]=danCommonTopLeftArenaDebuffs[1],}
initialize(360194) --Deathmark

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=220,                   ["group"]=danCommonTopRightGroupDebuffs[1], ["arena"]=danCommonTopLeftArenaDebuffs[1],}
initialize(390612) --Frost Bomb
initialize(212431) --Explosive Shot
initialize(320338) --essence break
initialize(393480) --sentinel from hunter




-- hasuitSetupFrameOptions = {auraSourceIsNotPlayer,    ["priority"]=242,["overridesSame"]=true,["group"]=danCommonTopRightGroupDebuffs[3], ["arena"]=danCommonTopLeftArenaDebuffs[3],} --other mortal strike effects
-- initialize("Mortal Dance")
-- initialize("Mortal Wounds")
-- initialize(235090) --mortal strike
-- initialize("Fel Fissure")
-- initialize("Legion Strike")
-- initialize("Mortal Cleave")
-- initialize("Malevolent Strikes")
-- initialize(16856) --mortal strike
-- initialize("Slaughterhouse")
-- initialize(394327) --wound poison




hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=234,                   ["group"]=danCommonTopRightGroupDebuffs[2], ["arena"]=danCommonTopLeftArenaDebuffs[2],}
initialize(210824) --Touch of the Magi --todo track how much these will hit for
initialize(385060) --Odyn's Fury
initialize(385408) --sepsis
initialize(385627) --kingsbane


hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=235,                   ["group"]=danCommonTopRightGroupDebuffs[2], ["arena"]=danCommonTopLeftArenaDebuffs[2],}
-- initialize(376104) --?, Radiant Spark Vulnerability, don't think this exists anymore
initialize(343721) --Final Reckoning
-- initialize("Nether Portal") --?


hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=240,                   ["group"]=danCommonTopRightGroupDebuffs[2], ["arena"]=danCommonTopLeftArenaDebuffs[2],}
initialize(343527) --Execution Sentence
initialize(208086) --Colossus Smash
-- initialize("Warbreaker") --? seems like the debuff for this is colossus smash? but the cast/damage is named this
initialize(397364) --Thunderous Roar
initialize(356995) --Disintegrate
initialize(198590) --Drain Soul
initialize(234153) --Drain Life

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=241,                   ["group"]=danCommonTopRightGroupDebuffs[3], ["arena"]=danCommonTopLeftArenaDebuffs[3],} --mortal strike effect, healing reduction
initialize(356528) --Necrotic Wound

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=244,                   ["group"]=danCommonTopRightGroupDebuffs[3], ["arena"]=danCommonTopLeftArenaDebuffs[3],}
initialize(335467) --Devouring Plague
hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=245,                                                               ["arena"]=danCommonTopLeftArenaDebuffs[4]}
initialize(316099)--unstable affliction dot arena
initialize(342938)--unstable affliction dot arena
hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=246,                   ["group"]=danCommonTopRightGroupDebuffs[4], ["arena"]=danCommonTopLeftArenaDebuffs[4],}
initialize(34914) --vampiric touch
initialize(188389) --Flame Shock
initialize(202347) --Stellar Flare


hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=250,                   ["group"]=danCommonTopRightGroupDebuffs[3], ["arena"]=danCommonTopLeftArenaDebuffs[3],}
-- initialize("Bane of Fragility") --?
initialize(206940) --Mark of Blood
initialize(48181) --Haunt
initialize(386997) --Soul Rot
-- initialize("Bane of Shadows") --?
initialize(207771) --?, Fiery Brand, dealing 40% less damage to dh that cast it? not dispellable, todo? important to know if this is on player and what it does


hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=255,                   ["group"]=danCommonTopRightGroupDebuffs[3], ["arena"]=danCommonTopLeftArenaDebuffs[3],}
initialize(274838) --Feral Frenzy
initialize(131894) --A Murder of Crows
initialize(430703) --Black Arrow
initialize(205179) --Phantom Singularity
initialize(200548) --Bane of Havoc
initialize(244813) --Living Bomb
initialize(217694) --Living Bomb


hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=262,                   ["group"]=danCommonTopRightGroupDebuffs[4], ["arena"]=danCommonTopLeftArenaDebuffs[4],}
initialize(343294) --Soul Reaper
initialize(353807) --Bonds of Fel
initialize(157736) --Immolate
initialize(375901) --Mindgames
initialize(391403) --Mind Flay: Insanity
initialize(15407) --Mind Flay

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=263,                   ["group"]=danCommonTopRightGroupDebuffs[4], ["arena"]=danCommonTopLeftArenaDebuffs[4],}
initialize(391889) --adaptive swarm dot

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=265,                   ["group"]=danCommonTopRightGroupDebuffs[4], ["arena"]=danCommonTopLeftArenaDebuffs[4],}
initialize(353084) --Ring of Fire
initialize(114923) --Nether Tempest
initialize(589) --Shadow Word: Pain
initialize(204213) --Purge the Wicked
initialize(146739) --Corruption
initialize(445474) --Wither, replaces corruption
initialize(603) --Doom
initialize(27243) --Seed of Corruption
initialize(411038) --Sphere of Despair
initialize(164812) --Moonfire
initialize(164815) --Sunfire

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=270,                   ["group"]=danCommonTopRightGroupDebuffs[5], ["arena"]=danCommonTopLeftArenaDebuffs[5],} --todo 370817 shocking disclosure preventing vanish/meld?
initialize(1079) --Rip
initialize(1943) --Rupture
initialize(360826) --Rupture from deathmark
initialize(269747) --Wildfire Bomb --todo these
initialize(259495) --Wildfire Bomb
initialize(426836) --Wildfire
initialize(422376) --Wildfire
initialize(394036) --Serrated Bone Spike
initialize(207407) --?, Soul Carver, dh dot? never seen
-- initialize(393831) --?, Fel Devastation, this is like demolish, no unit_aura but has cleu applied and the same other events
initialize(115994) --Unholy Blight
initialize(124280) --touch of karma dot
initialize(434473) --Bombardments, maybe should be higher?

hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=271,                   ["group"]=danCommonTopRightGroupDebuffs[5], ["arena"]=danCommonTopLeftArenaDebuffs[5],}
initialize(353759) --deep breath dot
-- initialize(271788) --Serpent Sting?


hasuitSetupFrameOptions = {auraSourceIsNotPlayer,       ["priority"]=275,                   ["group"]=danCommonTopRightGroupDebuffs[5], ["arena"]=danCommonTopLeftArenaDebuffs[5],} --END DOTs/damage debuffs ___ --should improve the categorization. the way i chose ___ stuff to begin with with based on what i had in weakauras but forgot about and haven't used. could be nice to do a ctrl-f
initialize(198688) --Dagger in the Dark


hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=280,                   ["group"]=danCommonTopRightGroupDebuffs[5], ["arena"]=danCommonTopLeftArenaDebuffs[5],}
initialize(GetSpellName(8326)) --Ghost, todo bigger/15 sec timer in rbgs?

-- hasuitSetupFrameOptions = {danMainAuraFunction,         ["priority"]=3,["loadOn"]=loadOnNone,["group"]=danCommonTopRightGroupDebuffs[5],        } --deserter
-- initialize(GetSpellName(26013)) --Deserter --todo these need to get removed when entering instance since they're so long, then can uncomment, surprised it's needed, seems like it'll work itself out after getting the order of loadons/everything else right?
-- initialize(GetSpellName(71041)) --Dungeon Deserter
-- initialize(158263) --Craven (arena deserter)






















hasuitFramesCenterSetEventType("aura")


danBottomLeft_BottomLeft    =   {["xDirection"]=1,  ["yDirection"]= 1,  ["xMinimum"]=2, ["yMinimum"]=3, ["xLimit"]=0,   ["yLimit"]=0,   ["ownPoint"]="BOTTOMLEFT",["targetPoint"]="BOTTOMLEFT",["xOffset"]=0,["yOffset"]=0,["grow"]=normalGrow,["sort"]=danSortPriorityExpirationTime}
local commonHarmful = {["controller"]=danBottomLeft_BottomLeft,["size"]=15, ["frameLevel"]=20,  ["hideCooldownText"]=true,  ["alpha"]=1}
hasuitFramesOptionsClassSpecificHarmful = {auraSourceIsPlayer,["priority"]=1, ["arena"]=commonHarmful, ["loadOn"]=loadOnArenaOnly} --i'm thinking about not showing debuffs bottom left at all and doing something different/using that space to show another dr like typhoon, so this is subject to change


danBottomRight_BottomRight  =   {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=1,   ["yLimit"]=0.33,["ownPoint"]="BOTTOMRIGHT",["targetPoint"]="BOTTOMRIGHT",["xOffset"]=0,["yOffset"]=0,["grow"]=normalGrow,["sort"]=danSortPriorityExpirationTime}
local commonHelpful = {["controller"]=danBottomRight_BottomRight,["size"]=15,   ["frameLevel"]=20,  ["hideCooldownText"]=true,["alpha"]=1}
hasuitFramesOptionsClassSpecificHelpful = {auraSourceIsPlayer,["priority"]=1, ["group"]=commonHelpful} --pretty awful for any healer i think, a specific setup per class/spec is preferred. might make something new to show hots with fixed position based on spellid but only need 1 controller, although maybe the current setup like i use on druid is fine







