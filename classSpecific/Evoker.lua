if hasuitPlayerClass~="EVOKER" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture

--todo aug




--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 4622477) --Terror of the Skies
trackDiminishTypeAndTexture("disorient", 1396974) --Sleep Walk
trackDiminishTypeAndTexture("root", 1016245) --Landslide, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track
trackDiminishTypeAndTexture("incapacitate", 136071) --Polymorph, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId

hasuitAddCycloneTimerBars(360806) --Sleep Walk





-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
hasuitHots_1["group"]["hideCooldownText"]=true
hasuitSetupSpellOptions = hasuitHots_1
initialize(364343)  --Echo, 2 essence instant cast: buffs next non-echo healing spell by 105%? casts an additional time and duplicates dream breath hot



--------------------------------hots 2
hasuitSetupSpellOptions = hasuitHots_2
initialize(366155)  --Reversion

hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,      ["priority"]=2, ["group"]=hasuitHots_2["group"]} --doing this to prevent it from switching places with other reversion randomly
initialize(367364)  --Reversion, echo duplicate? has a unique icon



--------------------------------hots 3
-- hasuitSetupSpellOptions = hasuitHots_3



--------------------------------hots 4
hasuitController_Hots4_BottomRight_BottomRight["xOffset"] = hasuitController_Hots2_BottomRight_BottomRight["xOffset"]-hasuitHots_2["group"]["size"]*2-2
hasuitSetupSpellOptions = hasuitHots_4
initialize(409895)  --Spiritbloom hot

hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,      ["priority"]=2, ["group"]=hasuitHots_4["group"]} --priority 2 instead of 1
initialize(355941)  --Dream Breath, should maybe show for others too in top-left?
initialize(376788)  --Dream Breath, 1/3rd as common? probably echo duplicate



------------------------------hots 5, above hots 1/grows left
hasuitSetupSpellOptions = hasuitHots_5
initialize(373267)  --Lifebind


--end hots


--dream projection?
--fury of the aspects? (lust)
--rescue absorb? probably shows but can't test
--spatial paradox? cast while moving/100% increased range
--call of ysera? 40%/100% buff to next dream breath/living flame after verdant embrace? 16 sec cd







--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
hasuitSetupSpellOptions = hasuitDots_
initialize(356995)  --Disintegrate
initialize(370452)  --Shattering Star, 20% damage taken increase from the evoker for 4 sec
initialize(357209)  --Fire Breath dot
initialize(441172)  --Melt Armor, from deep breath/talent for it



--permeating chill from disintegrate? 50% slow, 3 sec duration reapplied every tick, dispellable
