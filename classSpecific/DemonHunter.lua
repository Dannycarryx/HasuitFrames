if hasuitPlayerClass~="DEMONHUNTER" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture






--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 135795) --Chaos Nova
trackDiminishTypeAndTexture("incapacitate", 1380368) --Imprison
trackDiminishTypeAndTexture("disorient", 1418287) --Sigil of Misery, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track

--you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId

--todo track silence for vengeance?



-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
-- hasuitSetupSpellOptions = hasuitHots_1
-- initialize(1111)    --

--end hots







--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
-- hasuitSetupSpellOptions = hasuitDots_
-- initialize(1111)    --


