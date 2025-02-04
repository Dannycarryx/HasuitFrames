if hasuitPlayerClass~="SHAMAN" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture






--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 1385911) --Lightning Lasso, (136013 is Capacitor Totem)
trackDiminishTypeAndTexture("incapacitate", 237579) --Hex
trackDiminishTypeAndTexture("root", 136100) --Earthgrab, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track
trackDiminishTypeAndTexture("disorient", 136183) --Fear, you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId

hasuitAddCycloneTimerBars(51514, C_Spell.GetSpellName(51514)) --Hex





-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
hasuitHots_1["group"]["hideCooldownText"]=true
hasuitSetupSpellOptions = hasuitHots_1
initialize(974)     --Earth Shield
initialize(383648)  --Earth Shield



--------------------------------hots 2
hasuitHots_2["group"]["size"] = 18
hasuitHots_2["group"]["hideCooldownText"]=nil
hasuitSetupSpellOptions = hasuitHots_2
initialize(61295)   --Riptide
initialize(204362)  --Heroism 10 sec/20% from ele/enh?
initialize(204361)  --Bloodlust 10 sec/20% from ele/enh?



--------------------------------hots 3
hasuitController_Hots3_BottomRight_BottomRight["xOffset"] = hasuitController_Hots3_BottomRight_BottomRight["xOffset"]-3
hasuitSetupSpellOptions = {hasuitSpellFunction_Aura_SourceIsPlayer,                 ["priority"]=0,                     ["group"]=hasuitHots_3["group"]} --priority 0 instead of 1
initialize(382024)  --Earthliving Weapon --should this show? here?

hasuitSetupSpellOptions = hasuitHots_3
initialize(114893)  --Stone Bulwark
initialize(462844)  --Stone Bulwark
initialize(325174)  --Spirit Link Totem



--------------------------------hots 4
hasuitController_Hots3_BottomRight_BottomRight["pushesOtherController"]=hasuitController_Hots4_BottomRight_BottomRight
hasuitSetupSpellOptions = hasuitHots_4
initialize(546)     --Water Walking



------------------------------hots 5, above hots 1/grows left
-- hasuitSetupSpellOptions = hasuitHots_5
-- initialize(1111)    --

--end hots


--heroism?
--water shield?
--is there anything to track from surging totem?/healing rain





--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
hasuitSetupSpellOptions = hasuitDots_
initialize(188389)  --Flame Shock
initialize(196840)  --Frost Shock
initialize(342240)  --Ice Strike enh 50% slow

