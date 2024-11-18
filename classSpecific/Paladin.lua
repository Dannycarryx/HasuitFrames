if hasuitPlayerClass~="PALADIN" then
    return
end
local initialize = hasuitFramesInitialize
local trackDiminishTypeAndTexture = hasuitFramesTrackDiminishTypeAndTexture






--Diminishing returns, goes in order right to left on arena frames, available DR types: stun, disorient, root, incapacitate, silence, disarm
trackDiminishTypeAndTexture("stun", 135963) --Hammer of Justice
trackDiminishTypeAndTexture("disorient", 571553) --Blinding Light
trackDiminishTypeAndTexture("incapacitate", 135942) --Repentance, you can add/delete or move drs around depending on what you want, just copy paste a line with the values you want, or remove the whole line for whatever you don't want to track

-- you can put a spell name in quotes instead of the number as long as it's in your spellbook. capitalization matters. example: trackDiminishTypeAndTexture("stun", "Mighty Bash"), if using a number here it needs to be the spell texture, not a spellId





-- hots from you are shown bottom right on friendly frames

--------------------------------hots 1
hasuitHots_1["group"]["hideCooldownText"]=true
hasuitSetupSpellOptions = hasuitHots_1
initialize(53563)   --Beacon of Light
initialize(156910)  --Beacon of Faith
initialize(200025)  --Beacon of Virtue



--------------------------------hots 2
hasuitHots_2["group"]["size"] = 18
hasuitHots_2["specialAuraFunction"]=hasuitSpecialAuraFunction_RedLifebloom --red here means reapplying the hot won't waste any duration (pretty sure). For lifebloom this is also the point where reapplying it causes it to bloom
-- hasuitHots_2["group"]["hideCooldownText"]=nil
hasuitSetupSpellOptions = hasuitHots_2
initialize(431381)  --Dawnlight --not sure if this should get the red function



--------------------------------hots 3
hasuitController_Hots3_BottomRight_BottomRight["xOffset"]=-38 --should have based offsets for the first 3 on relative sizes and stuff to not have to do this
hasuitSetupSpellOptions = hasuitHots_3
initialize(156322)  --Eternal Flame
initialize(461432)  --Eternal Flame?, should Sun Sear be tracked? random short hot after holy shock crit

hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=2,                     ["group"]=hasuitHots_3["group"]}
initialize(148039)  --Barrier of Faith



--------------------------------hots 4
hasuitController_Hots3_BottomRight_BottomRight["pushesOtherController"]=hasuitController_Hots4_BottomRight_BottomRight
hasuitSetupSpellOptions = hasuitHots_4
initialize(1044)    --Blessing of Freedom

hasuitSetupSpellOptions = {hasuitSpellFunction_AuraSourceIsPlayer,                 ["priority"]=2,                     ["group"]=hasuitHots_4["group"]}
initialize(388007)  --Blessing of Summer, similar to nature's vigil but external? and affects both healing and damage
initialize(388011)  --Blessing of Winter, mana over time
initialize(388010)  --Blessing of Autumn, cd reduction



--------------------------------hots 5, above hots 1/grows left
hasuitHots_5["group"]["size"]=16
hasuitHots_5["group"]["hideCooldownText"]=nil
hasuitHots_5[1] = hasuitSpellFunction_AuraMainFunction
hasuitSetupSpellOptions = hasuitHots_5
initialize(25771)   --Forbearance


--end hots



--aura mastery?
--hand of divinity, 90 sec cd 1.5 sec cast that buffs 2 holy lights/makes them instant





--------------------------------dots/debuffs from you, shown bottom left on enemy frames, subject to change
hasuitSetupSpellOptions = hasuitDots_
initialize(431380)  --Dawnlight
initialize(403695)  --Truth's Wake
