if hasuitPlayerClass~="SHAMAN" then
	return
end

hasuitDiminishOptions["stun"] = { --available dr types: stun, fear, root, sheep, silence, disarm, showing more than 4 isn't a good idea for now
	["arena"] = 1, --position of the icon on arena frames, right to left
	["texture"] = 136013, --Capacitor Totem
}
hasuitDiminishOptions["incapacitate"] = {
	["arena"] = 2,
	["texture"] = 237579, --Hex
}
hasuitDiminishOptions["root"] = {
	["arena"] = 3,
	["texture"] = 136100, --Entangling Roots/Earthgrab
}
hasuitDiminishOptions["disorient"] = { --to hide a DR you can remove it here, just don't leave a gap on ["arena"] = x, if you remove 3 then change the next one's ["arena"] = 4 to 3 etc
	["arena"] = 4,
	["texture"] = 136022, --Cyclone
}



hasuitSetupFrameOptions = hasuitFramesOptionsClassSpecificHarmful --------------------------------dots/debuffs from you, shown bottom left on enemy frames
hasuitFramesInitialize(1111)








hasuitSetupFrameOptions = hasuitFramesOptionsClassSpecificHelpful --------------------------------hots/buffs from you, shown bottom right on friendly frames
hasuitFramesInitialize(1111)

