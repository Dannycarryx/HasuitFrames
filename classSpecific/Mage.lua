if hasuitPlayerClass~="MAGE" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture


--todo aoe barriers from mage? anything else?



--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 132298) --Kidney Shot
trackDiminishTypeAndTexture("incapacitate", 136071) --Polymorph
trackDiminishTypeAndTexture("disorient", 136184) --Psychic Scream, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track
trackDiminishTypeAndTexture("root", 135848) --Frost Nova, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId

-- hasuitAddCycloneTimerBars(118, C_Spell.GetSpellName(118)) --Polymorph, todo ring of frost?
hasuitAddCycloneTimerBars(118) --Polymorph, todo ring of frost?





-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
-- hasuitSetupSpellOptions = hasuitHots_1
-- initialize(1111)    --

--end hots







--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
-- hasuitSetupSpellOptions = hasuitDots_
-- initialize(1111)    --

