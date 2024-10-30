if hasuitPlayerClass~="PRIEST" then
    return
end

hasuitDiminishSpellOptionsTable["stun"] = { --available dr types: stun, fear, root, sheep, silence, disarm, showing more than 4 isn't a good idea for now
    ["arena"] = 1, --position of the icon on arena frames, right to left
    ["texture"] = 237568, --Psychic Horror
}
hasuitDiminishSpellOptionsTable["disorient"] = {
    ["arena"] = 2,
    ["texture"] = 136184, --Psychic Scream
}
hasuitDiminishSpellOptionsTable["root"] = {
    ["arena"] = 3,
    ["texture"] = 537022, --Void Tendrils
}
hasuitDiminishSpellOptionsTable["incapacitate"] = { --to hide a DR you can remove it here, just don't leave a gap on ["arena"] = x, if you remove 3 then change the next one's ["arena"] = 4 to 3 etc
    ["arena"] = 4,
    ["texture"] = 136071, --Polymorph
}



hasuitSetupSpellOptions = hasuitFramesSpellOptionsClassSpecificHarmful --------------------------------dots/debuffs from you, shown bottom left on enemy frames
hasuitFramesInitialize(589) --Shadow Word: Pain








hasuitSetupSpellOptions = hasuitFramesSpellOptionsClassSpecificHelpful --------------------------------hots/buffs from you, shown bottom right on friendly frames
hasuitFramesInitialize(139) --Renew

