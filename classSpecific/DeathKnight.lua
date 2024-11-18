if hasuitPlayerClass~="DEATHKNIGHT" then
	return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture






--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 538558) --Asphyxiate
trackDiminishTypeAndTexture("silence", 136214) --Strangulate
trackDiminishTypeAndTexture("disorient", 135836) --Blinding Sleet, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track
trackDiminishTypeAndTexture("root", 135842) --Deathchill, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId


--todo more dk dots maybe?



-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
hasuitSetupSpellOptions = hasuitHots_1
initialize(48707)  --Anti-Magic Shell, these show top-left already
initialize(410358)  --Anti-Magic Shell external



--------------------------------hots 2
hasuitSetupSpellOptions = hasuitHots_2
initialize(444741)  --Anti-Magic Shell external, guardian?
initialize(454863)  --Lesser Anti-Magic Shell?


--end hots







--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
hasuitSetupSpellOptions = hasuitDots_
initialize(194310)    --Festering Wound


