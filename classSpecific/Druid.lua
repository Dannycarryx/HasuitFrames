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




hasuitSetupFrameOptions = hasuitFramesOptionsClassSpecificHarmful --------------------------------dots/debuffs from you, shown bottom left on enemy frames --this whole setup with the comments in every class file is going to get changed. and the plan is to allow people to have a personal addon where i have a guide on how to add things to my tables and controllers/use my functions to make stuff/whatever, so that there can be a huge amount of customization and no need to worry about addon updates changing custom stuff. doing it like that skips needing to make a gui for it and cooler anyway? not sure what the best way is to enable sharing custom stuff but that could be cool too
initialize(202347) --Stellar Flare
initialize(164812) --Moonfire
initialize(164815) --Sunfire
initialize(1079) --Rip
initialize(155722) --Rake
initialize(391889) --Adaptive Swarm dot
















-- hasuitFramesCenterSetEventType("cleu")
-- hasuitSetupFrameOptions = {["loadOn"]=danLoadOnPvpTalentsInstance,function() --danHeartProcIsOnCooldown --the single very first thing made for the addon. it was a more basic setup with just this function + cleu setting danHeartProcIsOnCooldown for 60 sec, and combined with a function in my keybinding addon that changed a macro based on that out of combat or something. the addon sat untouched just doing that one thing for months before i slowly started adding new things to it and eventually really committed to working on it
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
-- hasuitSetupFrameOptions = {function()
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
-- hasuitSetupFrameOptions = {function()
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









local danBottomRightHots1		=	{["xDirection"]=-1,	["yDirection"]=	1,	["xMinimum"]=1,	["yMinimum"]=1,	["xLimit"]=0,	["yLimit"]=0,	["ownPoint"]="BOTTOMRIGHT",	["targetPoint"]="BOTTOMRIGHT",	["xOffset"]=	0,	["yOffset"]= 0,		["grow"]=normalGrow,	["sort"]=danSort,		} --todo combine these controllers and change how it grows instead?
local danBottomRightHots2		=	{["xDirection"]=-1,	["yDirection"]=	1,	["xMinimum"]=1,	["yMinimum"]=1,	["xLimit"]=0,	["yLimit"]=0,	["ownPoint"]="BOTTOMRIGHT",	["targetPoint"]="BOTTOMRIGHT",	["xOffset"]=	-16,["yOffset"]= 0,		["grow"]=normalGrow,	["sort"]=danSort,		}
local danBottomRightHots3		=	{["xDirection"]=-1,	["yDirection"]=	1,	["xMinimum"]=2,	["yMinimum"]=1,	["xLimit"]=1,	["yLimit"]=1,	["ownPoint"]="BOTTOMRIGHT",	["targetPoint"]="BOTTOMRIGHT",	["xOffset"]=	-32,["yOffset"]= 0,		["grow"]=normalGrow,	["sort"]=danSortExpirationTime,	}
local danBottomRightHots4		=	{["xDirection"]=-1,	["yDirection"]=	1,	["xMinimum"]=0,	["yMinimum"]=0,	["xLimit"]=1,	["yLimit"]=0.45,["ownPoint"]="BOTTOMRIGHT",	["targetPoint"]="BOTTOMRIGHT",	["xOffset"]=	-57,["yOffset"]= 0,		["grow"]=normalGrow,	["sort"]=danSort,		}

local danBottomRightHots5		=	{["xDirection"]=-1,	["yDirection"]=	1,	["xMinimum"]=1,	["yMinimum"]=1,	["xLimit"]=1,	["yLimit"]=1,	["ownPoint"]="BOTTOMRIGHT",	["targetPoint"]="BOTTOMRIGHT",	["xOffset"]=	0,	["yOffset"]= 16,	["grow"]=normalGrow,	["sort"]=danSort,		}
local danBottomRightHots6		=	{["xDirection"]=-1,	["yDirection"]=	1,	["xMinimum"]=1,	["yMinimum"]=1,	["xLimit"]=0,	["yLimit"]=0,	["ownPoint"]="BOTTOMRIGHT",	["targetPoint"]="BOTTOMRIGHT",	["xOffset"]=	-16,["yOffset"]= 16,	["grow"]=normalGrow,	["sort"]=danSort,		}

danBottomRightHots3["controlsOther"]=danBottomRightHots4


hasuitFramesCenterSetEventType("aura")

local common = {["controller"]=danBottomRightHots1,["size"]=15,	["frameLevel"]=21,	["alpha"]=1,	}
hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=0,								["group"]=common,				["specialAuraFunction"]=redLifebloom,} hasuitUsedRedLifebloom = true
initialize(188550	) --lifebloom
initialize(33763	) --lifebloom, todo only cd text if low duration?


local common = {["controller"]=danBottomRightHots2,	["size"]=15,	["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=1, ["specialIconType"]="optionalBorder"} --what's the difference between local common here and not having local? seems like if anything it would be better to do it like this, or maybe significantly better
hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=1,								["group"]=common,					["specialAuraFunction"]=soulHotsSpecialFunction}
initialize(8936		) --regrowth


local common = {["controller"]=danBottomRightHots3,	["size"]=15,	["frameLevel"]=21,	["alpha"]=1, ["specialIconType"]="optionalBorder"} --todo only show timer text if playing germ? need to see it at 22 sec+ or whatever the new number is to optimize soul rejuv/double soul rejuv. I forget exactly how that all works since shadowlands but ya the setup here and how rejuv/germ get sorted based on duration allows for optimizing it 100%. maybe the only improvement would be showing tenths of seconds around important numbers but wouldn't fit well and wouldn't make sense if people don't know why it's like that, and wouldn't be trivial to make
hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=2,								["group"]=common,				["specialAuraFunction"]=soulHotsSpecialFunction}
initialize(774		) --rejuvenation
initialize(155777	) --germination




local common = {["controller"]=danBottomRightHots4,	["size"]=14,	["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=1, ["specialIconType"]="optionalBorder"}
hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=4,								["group"]=common,				["specialAuraFunction"]=soulHotsSpecialFunction}
initialize(48438	) --wild growth


local common = {["controller"]=danBottomRightHots4,	["size"]=13,	["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=1}
hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=4,								["group"]=common}
initialize(290754) --Lifebloom from Full Bloom (early spring)


local common = {["controller"]=danBottomRightHots4,	["size"]=13,	["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=1,	}
hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=5,["loadOn"]=hasuitLoadOnPartySize,["group"]=common,	}
initialize("Grove Tending")
hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=6,["loadOn"]=hasuitLoadOnPartySize,["group"]=common,	}
local common = {["controller"]=danBottomRightHots4,	["size"]=13,	["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=1,	}
-- initialize("Cultivation")
-- initialize("Spring Blossoms")
local common = {["controller"]=danBottomRightHots4,	["size"]=12,		["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=1,	}
hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=7,["loadOn"]=hasuitLoadOnPartySize,["group"]=common,	}
initialize("Tranquility")

-- local common = {["controller"]=danBottomRightHots4,	["size"]=12,	["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=1,}
-- hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=7,								["group"]=common,}
-- initialize("Tranquility") --todo hide stacks




local common = {["controller"]=danBottomRightHots5,	["size"]=14,	["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=1,	}
hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=0,["loadOn"]=hasuitLoadOnPartySize,["group"]=common,			}
-- initialize(391891	) --adaptive swarm
initialize(429222) --"Minor Cenarion Ward"

-- local common = {["controller"]=danBottomRightHots6,	["size"]=15,	["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=1,	}
-- hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=1,								["group"]=common,}
-- initialize(102352	) --cenarion ward after proc
-- local common = {["controller"]=danBottomRightHots6,	["size"]=15,	["frameLevel"]=21,	["hideCooldownText"]=true,	["alpha"]=0.4,	}
-- hasuitSetupFrameOptions = {auraSourceIsPlayer,			["priority"]=1,								["group"]=common,}
-- initialize(102351	) --cenarion ward low alpha


