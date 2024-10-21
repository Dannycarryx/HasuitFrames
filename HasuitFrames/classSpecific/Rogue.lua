if hasuitPlayerClass~="ROGUE" then
	return
end

hasuitDiminishOptions["stun"] = { --available dr types: stun, fear, root, sheep, silence, disarm, showing more than 4 isn't a good idea for now
	["arena"] = 1, --position of the icon on arena frames, right to left
	["texture"] = 132298, --Kidney Shot
}
hasuitDiminishOptions["disorient"] = {
	["arena"] = 2,
	["texture"] = 136175, --Blind
}
hasuitDiminishOptions["incapacitate"] = {
	["arena"] = 3,
	["texture"] = 132310, --Sap
}
hasuitDiminishOptions["silence"] = { --to hide a DR you can remove it here, just don't leave a gap on ["arena"] = x, if you remove 3 then change the next one's ["arena"] = 4 to 3 etc
	["arena"] = 4,
	["texture"] = 132297, --Garrote
}



hasuitSetupFrameOptions = hasuitFramesOptionsClassSpecificHarmful --------------------------------dots/debuffs from you, shown bottom left on enemy frames
hasuitFramesInitialize(1111)








hasuitSetupFrameOptions = hasuitFramesOptionsClassSpecificHelpful --------------------------------hots/buffs from you, shown bottom right on friendly frames
hasuitFramesInitialize(1111)

