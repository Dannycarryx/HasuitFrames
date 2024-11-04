



local tremove = tremove
local CreateFrame = CreateFrame

hasuitUnusedCastBars = {}
local unusedCastBars = hasuitUnusedCastBars
function hasuitGetCastBar() --bored todo migrate danGetIcon to be with this in a file, maybe with initializeController and stuff like that too, leaving hasuitSpellFunction_ stuff together in HasuitFrames.lua? not sure if that should be split further into eventtypes. either way probably not worth the effort to do any of this
    if #unusedCastBars>0 then
        return tremove(unusedCastBars)
        
    else
        local castBar = CreateFrame("StatusBar")
        castBar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
        castBar:SetHeight(3)
        castBar:SetFrameLevel(25)
        castBar:SetScript("OnEvent", ccBreakOnEvent)
        castBar.unusedTable = unusedCastBars
        
        local background = castBar:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints()
        background:SetColorTexture(0,0,0)
        
        local textOfSpellName = castBar:CreateFontString()
        castBar.textOfSpellName = textOfSpellName
        textOfSpellName:SetPoint("CENTER", castBar, "CENTER") --maybe no 2nd or 3rd arg needed
        
        
        return castBar
        
    end
end
hasuitLocal1(hasuitGetCastBar)


hasuitCastBarFont20 = CreateFont("hasuitCastBarFont20")
hasuitCastBarFont18 = CreateFont("hasuitCastBarFont18")
hasuitCastBarFont15 = CreateFont("hasuitCastBarFont15")

hasuitCastBarFont20:SetFont("Fonts/FRIZQT__.TTF", 20, "OUTLINE")
hasuitCastBarFont18:SetFont("Fonts/FRIZQT__.TTF", 18, "OUTLINE")
hasuitCastBarFont15:SetFont("Fonts/FRIZQT__.TTF", 15, "OUTLINE")


-- most controllers are attached to individual unitFrames, but this one is separated from unitFrames and in the upper middle of the screen, and created differently. It allows things from multiple units to all be combined there, instead of on unitFrames
hasuitController_Separate_UpperScreenCastBars = {} --middle castbars
local controller = CreateFrame("Frame", nil, hasuitFramesParent)
local controllerOptions = hasuitController_Separate_UpperScreenCastBars --hasuitMiddleCastBarsGrow/hasuitSpellFunction_UnitCastingMiddleCastBars
controllerOptions.controller = controller --controllerOptions seems pointless here, maybe for future separated controllers too, but it might be even better to get this system to be good and interchangeable with normal controllers somehow. should work on it again
controller.frames = {}
controller:SetFrameStrata("MEDIUM")
controller:SetFrameLevel(20)
controller.grow = hasuitMiddleCastBarsGrow
controller:SetPoint("TOP", UIParent, "CENTER", 0, 220)
controller:SetSize(1,1)
hasuitLocal2(controller)






danCommonMiddleCastBars1 =  {controller=controller, ["width"]=220,  ["height"]=36,  ["fontObject"]=hasuitCastBarFont20, r=1,    g=0,    b=0,    ["ignoreChanneling"]=true} --different from controllerOptions. That's all handled in the grow function for this
danCommonMiddleCastBars2 =  {controller=controller, ["width"]=200,  ["height"]=30,  ["fontObject"]=hasuitCastBarFont18, r=1,    g=0.9,  b=0,    ["ignoreChanneling"]=true}
danCommonMiddleCastBars3 =  {controller=controller, ["width"]=200,  ["height"]=30,  ["fontObject"]=hasuitCastBarFont18, r=1,    g=0.9,  b=0,    ["ignoreChanneling"]=true}
danCommonMiddleCastBars4 =  {controller=controller, ["width"]=150,  ["height"]=20,  ["fontObject"]=hasuitCastBarFont15, r=0.7,  g=1,    b=0,    ["ignoreChanneling"]=true}
danCommonMiddleCastBars5 =  {controller=controller, ["width"]=150,  ["height"]=20,  ["fontObject"]=hasuitCastBarFont15, r=0.7,  g=1,    b=0,    ["ignoreChanneling"]=true}

hasuitBigRedMiddleCastBarsSpellOptions =    {hasuitSpellFunction_UnitCastingMiddleCastBars, ["arena"]=danCommonMiddleCastBars1} --these get used in general.lua
hasuitBigGreenMiddleCastBarsSpellOptions =  {hasuitSpellFunction_UnitCastingMiddleCastBars, ["arena"]=danCommonMiddleCastBars2}
hasuitYellowMiddleCastBarsSpellOptions =    {hasuitSpellFunction_UnitCastingMiddleCastBars, ["arena"]=danCommonMiddleCastBars3}
hasuitRootMiddleCastBarsSpellOptions =      {hasuitSpellFunction_UnitCastingMiddleCastBars, ["arena"]=danCommonMiddleCastBars4}
hasuitMiscMiddleCastBarsSpellOptions =      {hasuitSpellFunction_UnitCastingMiddleCastBars, ["arena"]=danCommonMiddleCastBars5} --^

-- initialized in general.lua





tinsert(hasuitDoThisAddon_Loaded, function()
    hasuitBigRedMiddleCastBarsSpellOptions["loadOn"]=hasuitLoadOn_ArenaOnly --maybe move loadons that can move to their own file, before initializing anything. Could move all actually just leave the condition function behind if needed
    hasuitBigGreenMiddleCastBarsSpellOptions["loadOn"]=hasuitLoadOn_ArenaOnly
    hasuitYellowMiddleCastBarsSpellOptions["loadOn"]=hasuitLoadOn_ArenaOnly
    hasuitRootMiddleCastBarsSpellOptions["loadOn"]=hasuitLoadOn_ArenaOnly
    hasuitMiscMiddleCastBarsSpellOptions["loadOn"]=hasuitLoadOn_ArenaOnly
end)










-- hasuitSetupSpellOptionsMulti = {
                          -- {hasuitSpellFunction_UnitCastingMiddleCastBars,    ["group"]=danCommonMiddleCastBars1},
-- }
-- hasuitFramesInitializeMulti(8936) --r, uncomment sourceGUID==hasuitPlayerGUID too

