if hasuitPlayerClass~="WARLOCK" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture


--todo gateway debuff on friendly? and dots



--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 607865) --Shadowfury
trackDiminishTypeAndTexture("disorient", 136183) --Fear
trackDiminishTypeAndTexture("incapacitate", 607853) --Mortal Coil, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track

--you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId

--warlock doesn't have roots anymore right?

hasuitAddCycloneTimerBars(5782) --Fear, todo seduce if playing the pet?


-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
-- hasuitSetupSpellOptions = hasuitHots_1
-- initialize(1111)    --

--end hots







--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
-- hasuitSetupSpellOptions = hasuitDots_
-- initialize(1111)    --


