if hasuitPlayerClass~="ROGUE" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture






--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 132298) --Kidney Shot
trackDiminishTypeAndTexture("disorient", 136175) --Blind
trackDiminishTypeAndTexture("incapacitate", 132310) --Sap, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track
trackDiminishTypeAndTexture("silence", 132297) --Garrote, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId






-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
hasuitSetupSpellOptions = hasuitHots_1
initialize(221630)  --Tricks of the Trade

--end hots







--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
-- hasuitSetupSpellOptions = hasuitDots_
-- initialize(1111)  --


