



local tremove = tremove
local CreateFrame = CreateFrame
-- local danBackdrop = hasuit1PixelBorderBackdrop

local unusedCastBars = {}
function hasuitGetCastBar() --bored todo migrate danGetIcon to be with this in a file, maybe with initializeController and stuff like that too, leaving hasuitSpellFunction_ stuff together in HasuitFrames.lua? not sure if that should be split further into eventtypes. either way probably not worth the effort to do any of this
    if #unusedCastBars>0 then
        return tremove(unusedCastBars)
        
    else
        local castBar = CreateFrame("StatusBar")
        castBar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
        castBar.unusedTable = unusedCastBars
        
        local background = castBar:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints()
        background:SetColorTexture(0,0,0)
        
        local textOfSpellName = castBar:CreateFontString()
        castBar.textOfSpellName = textOfSpellName
        textOfSpellName:SetPoint("CENTER")
        
        -- local border = CreateFrame("Frame", nil, castBar, "BackdropTemplate")
        -- castBar.border = border
        -- border:SetBackdrop(danBackdrop)
        -- border:SetAllPoints()
        -- border:SetBackdropBorderColor(0,0,0)
        
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
local middleCastBarsController = CreateFrame("Frame", nil, hasuitFramesParent)
local controllerOptions = hasuitController_Separate_UpperScreenCastBars --hasuitMiddleCastBarsGrow/hasuitSpellFunction_UnitCastingMiddleCastBars
controllerOptions.controller = middleCastBarsController --controllerOptions seems pointless here, maybe for future separated controllers too, but it might be even better to get this system to be good and interchangeable with normal controllers somehow. should work on it again
middleCastBarsController.frames = {}
middleCastBarsController:SetFrameStrata("MEDIUM")
-- middleCastBarsController:SetFrameLevel(20)
middleCastBarsController.grow = hasuitMiddleCastBarsGrow
middleCastBarsController:SetPoint("TOP", UIParent, "CENTER", 0, 220)
middleCastBarsController:SetSize(1,1)
hasuitLocal2(middleCastBarsController)


hasuitLoadOn_PvpEnemyMiddleCastBars = {}
local hasuitLoadOn_PvpEnemyMiddleCastBars = hasuitLoadOn_PvpEnemyMiddleCastBars
local hasuitSpellFunction_UnitCastingMiddleCastBars = hasuitSpellFunction_UnitCastingMiddleCastBars




local danCommon = {controller=middleCastBarsController,    ["width"]=220,  ["height"]=36,  ["fontObject"]=hasuitCastBarFont20, r=1,    g=0,    b=0} --big red cc, width should stay even for all of these otherwise pixels can get ugly because of setpoint center in the grow function
hasuitBigRedMiddleCastBarsSpellOptions =            {hasuitSpellFunction_UnitCastingMiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}



local danCommon = {controller=middleCastBarsController,    ["width"]=200,  ["height"]=30,  ["fontObject"]=hasuitCastBarFont18, r=0.5,  g=1,    b=0} --medium greenish defensive
hasuitGreenishDefensiveMiddleCastBarsSpellOptions = {hasuitSpellFunction_UnitCastingMiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}



local danCommon = {controller=middleCastBarsController,    ["width"]=200,  ["height"]=30,  ["fontObject"]=hasuitCastBarFont18, r=1,    g=0.4,  b=0} --medium orange, stuff like searing glare, maybe add things like turn undead here for dks until a better system is made for that
hasuitOrangeMiddleCastBarsSpellOptions =            {hasuitSpellFunction_UnitCastingMiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}



local danCommon = {controller=middleCastBarsController,    ["width"]=180,  ["height"]=28,  ["fontObject"]=hasuitCastBarFont18, r=1,    g=1,    b=0} --medium yellow significant damage ability
hasuitYellowMiddleCastBarsSpellOptions =            {hasuitSpellFunction_UnitCastingMiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}



local danCommon = {controller=middleCastBarsController,    ["width"]=150,  ["height"]=20,  ["fontObject"]=hasuitCastBarFont15, r=0.7,  g=1,    b=0} --small yellowish misc
hasuitSmallMiscMiddleCastBarsSpellOptions =         {hasuitSpellFunction_UnitCastingMiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}



local danCommon = {controller=middleCastBarsController,    ["width"]=150,  ["height"]=20,  ["fontObject"]=hasuitCastBarFont15, r=0,    g=1,    b=0} --small green damage
hasuitSmallDamageMiddleCastBarsSpellOptions =       {hasuitSpellFunction_UnitCastingMiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}


-- initialized in general.lua








-- hasuitSetupSpellOptionsMulti = {
                          -- {hasuitSpellFunction_UnitCastingMiddleCastBars,    ["group"]=danCommon},
-- }
-- hasuitFramesInitializeMulti(8936) --hasuitSpellFunction_UnitCastingMiddleCastBars = addMultiFunction(function()

