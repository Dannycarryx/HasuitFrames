if hasuitPlayerClass~="DRUID" then
    return
end
local initialize = hasuitFramesInitialize
local diminish = hasuitFramesTrackDiminishTypeAndTexture



--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
diminish("stun", 132114) --Mighty Bash
diminish("disorient", 136022) --Cyclone
diminish("root", 136100) --Entangling Roots, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: diminish("stun", "Mighty Bash")
diminish("incapacitate", 136071) --Polymorph, you can delete or move drs around depending on what you want, just remove the whole line for whatever you don't want to track




hasuitSetupSpellOptions = hasuitFramesSpellOptionsClassSpecificHarmful --------------------------------dots/debuffs from you, shown bottom left on enemy frames --this whole setup with the comments in every class file is going to get changed. and the plan is to allow people to have a personal addon where i have a guide on how to add things to my tables and controllers/use my functions to make stuff/whatever, so that there can be a huge amount of customization and no need to worry about addon updates changing custom stuff. doing it like that skips needing to make a gui for it and cooler anyway? not sure what the best way is to enable sharing custom stuff but that could be cool too
initialize(202347) --Stellar Flare
initialize(164812) --Moonfire
initialize(164815) --Sunfire
initialize(1079) --Rip
initialize(155722) --Rake
initialize(391889) --Adaptive Swarm dot















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








local normalGrow = hasuitNormalGrow
local danSort = hasuitSort

local danController_BottomRight_BottomRightHots1 =  {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=0,   ["yLimit"]=0,   ["ownPoint"]="BOTTOMRIGHT", ["targetPoint"]="BOTTOMRIGHT",  ["xOffset"]=  0,["yOffset"]= 0, ["frameLevel"]=21,  ["sort"]=danSort,   ["grow"]=normalGrow} --todo combine these controllers and change how it grows instead?
local danController_BottomRight_BottomRightHots2 =  {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=0,   ["yLimit"]=0,   ["ownPoint"]="BOTTOMRIGHT", ["targetPoint"]="BOTTOMRIGHT",  ["xOffset"]=-16,["yOffset"]= 0, ["frameLevel"]=21,  ["sort"]=danSort,   ["grow"]=normalGrow}
local danController_BottomRight_BottomRightHots3 =  {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=2, ["yMinimum"]=1, ["xLimit"]=1,   ["yLimit"]=1,   ["ownPoint"]="BOTTOMRIGHT", ["targetPoint"]="BOTTOMRIGHT",  ["xOffset"]=-32,["yOffset"]= 0, ["frameLevel"]=21,  ["sort"]=hasuitSortExpirationTime,["grow"]=normalGrow}
local danController_BottomRight_BottomRightHots4 =  {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=0, ["yMinimum"]=0, ["xLimit"]=1,   ["yLimit"]=0.45,["ownPoint"]="BOTTOMRIGHT", ["targetPoint"]="BOTTOMRIGHT",  ["xOffset"]=-57,["yOffset"]= 0, ["frameLevel"]=21,  ["sort"]=danSort,   ["grow"]=normalGrow}

local danController_BottomRight_BottomRightHots5 =  {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=1,   ["yLimit"]=1,   ["ownPoint"]="BOTTOMRIGHT", ["targetPoint"]="BOTTOMRIGHT",  ["xOffset"]=  0,["yOffset"]= 16,["frameLevel"]=21,  ["sort"]=danSort,   ["grow"]=normalGrow}
-- local danController_BottomRight_BottomRightHots6 =  {["xDirection"]=-1, ["yDirection"]= 1,  ["xMinimum"]=1, ["yMinimum"]=1, ["xLimit"]=0,   ["yLimit"]=0,   ["ownPoint"]="BOTTOMRIGHT", ["targetPoint"]="BOTTOMRIGHT",  ["xOffset"]=-16,["yOffset"]= 16,["frameLevel"]=21,  ["sort"]=danSort,   ["grow"]=normalGrow}

danController_BottomRight_BottomRightHots3["controlsOther"]=danController_BottomRight_BottomRightHots4


hasuitFramesCenterSetEventType("aura")

local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots1, ["size"]=15, ["alpha"]=1,    }
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=0,                                 ["group"]=danCommon,    ["specialAuraFunction"]=hasuitSpecialAuraFunction_RedLifebloom,}
initialize(188550   ) --lifebloom
initialize(33763    ) --lifebloom, todo only cd text if low duration?


local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots2, ["size"]=15, ["alpha"]=1,    ["hideCooldownText"]=true,  ["specialIconType"]="optionalBorder"}
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=1,                                 ["group"]=danCommon,    ["specialAuraFunction"]=hasuitSpecialAuraFunction_SoulHots}
initialize(8936     ) --regrowth


local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots3, ["size"]=15, ["alpha"]=1,                                ["specialIconType"]="optionalBorder"} --todo only show timer text if playing germ? need to see it at 22 sec+ or whatever the new number is to optimize soul rejuv/double soul rejuv. I forget exactly how that all works since shadowlands but ya the setup here and how rejuv/germ get sorted based on duration allows for optimizing it 100%. maybe the only improvement would be showing tenths of seconds around important numbers but wouldn't fit well and wouldn't make sense if people don't know why it's like that, and wouldn't be trivial to make
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=2,                                 ["group"]=danCommon,    ["specialAuraFunction"]=hasuitSpecialAuraFunction_SoulHots}
initialize(774      ) --rejuvenation
initialize(155777   ) --germination




local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots4, ["size"]=14, ["alpha"]=1,    ["hideCooldownText"]=true,  ["specialIconType"]="optionalBorder"}
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=4,                                 ["group"]=danCommon,    ["specialAuraFunction"]=hasuitSpecialAuraFunction_SoulHots}
initialize(48438    ) --wild growth


local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots4, ["size"]=13, ["alpha"]=1,    ["hideCooldownText"]=true,  }
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=4,                                 ["group"]=danCommon}
initialize(290754) --Lifebloom from Full Bloom (early spring)


local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots4, ["size"]=13, ["alpha"]=1,    ["hideCooldownText"]=true,  }
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=5,["loadOn"]=hasuitLoadOn_PartySize,["group"]=danCommon,   }
initialize(383193) --Grove Tending
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=6,["loadOn"]=hasuitLoadOn_PartySize,["group"]=danCommon,   }
local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots4, ["size"]=13, ["alpha"]=1,    ["hideCooldownText"]=true,  }
-- initialize("Cultivation")
-- initialize("Spring Blossoms")
local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots4, ["size"]=12, ["alpha"]=1,    ["hideCooldownText"]=true,  }
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=7,["loadOn"]=hasuitLoadOn_PartySize,["group"]=danCommon,   }
initialize(157982) --Tranquility

-- local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots4, ["size"]=12, ["alpha"]=1,  ["hideCooldownText"]=true,  }
-- hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=7,                             ["group"]=danCommon,}
-- initialize(157982) --todo hide stacks




local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots5, ["size"]=14, ["alpha"]=1,    ["hideCooldownText"]=true,  }
hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=0,["loadOn"]=hasuitLoadOn_PartySize,["group"]=danCommon,           }
-- initialize(391891    ) --adaptive swarm
initialize(429222) --"Minor Cenarion Ward"

-- local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots6, ["size"]=15, ["alpha"]=1,     ["hideCooldownText"]=true,  }
-- hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=1,                             ["group"]=danCommon,}
-- initialize(102352    ) --cenarion ward after proc
-- local danCommon = {["controllerOptions"]=danController_BottomRight_BottomRightHots6, ["size"]=15, ["alpha"]=0.4, ["hideCooldownText"]=true,    }
-- hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,      ["priority"]=1,                             ["group"]=danCommon,}
-- initialize(102351    ) --cenarion ward low alpha


