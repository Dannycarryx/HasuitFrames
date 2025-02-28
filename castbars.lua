



local hasuitSpellFunction_UnitCasting_MiddleCastBars = hasuitSpellFunction_UnitCasting_MiddleCastBars
local tremove = tremove
local CreateFrame = CreateFrame
local hasuitUninterruptibleBorderSize = hasuitUninterruptibleBorderSize
local uninterruptibleBorderBackdrop = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = hasuitUninterruptibleBorderSize}
local hasuitFramesParent = hasuitFramesParent

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
        
        
        local arenaNumberBox = castBar:CreateTexture(nil, "BACKGROUND") --just experimenting, not sure what's best but should do something like this for ranged kicks?
        castBar.arenaNumberBox = arenaNumberBox
        arenaNumberBox:SetPoint("LEFT", castBar, "RIGHT", 1, 0)
        
        local arenaNumberText = castBar:CreateFontString() --should make sure the pixels are good here. if everything is even they should be?
        castBar.arenaNumberText = arenaNumberText
        arenaNumberText:SetPoint("CENTER", arenaNumberBox, "CENTER")
        
        
        local uninterruptibleBorder = CreateFrame("Frame", nil, castBar, "BackdropTemplate")
        castBar.uninterruptibleBorder = uninterruptibleBorder
        uninterruptibleBorder:SetBackdrop(uninterruptibleBorderBackdrop)
        uninterruptibleBorder:SetPoint("TOPLEFT",-hasuitUninterruptibleBorderSize,0)
        uninterruptibleBorder:SetBackdropBorderColor(0.5,0.5,0.5)
        
        castBar.arenaNumberBoxShowing = true
        uninterruptibleBorder:SetPoint("BOTTOMRIGHT", arenaNumberBox, "BOTTOMRIGHT", hasuitUninterruptibleBorderSize, 0)
        
        
        return castBar
        
    end
end
hasuitMiddleCastBarsAllowChannelingForSpellId = { --should this be an ignore list instead?
    [20578]=true,   --Cannibalize
    [357208]=true,  --Fire Breath
    [382266]=true,  --Fire Breath
    [359073]=true,  --Eternity Surge
    [382411]=true,  --Eternity Surge
    [396286]=true,  --Upheaval
    [408092]=true,  --Upheaval
    [353128]=true,  --Arcanosphere
    [198100]=true,  --Kleptomania
    [436358]=true,  --Demolish
    [115175]=true,  --Soothing Mist
    [47757]=true,   --Penance
    [47758]=true,   --Penance
}
hasuitMiddleCastBarsAllowHostileNonPlayersForSpellId = {
    [118905]=true,  --Static Charge --doesn't work because it almost only shows up in cleu. unit_spellcast is rare for this
    [6358]=true,    --Seduction
}

hasuitLocal1(hasuitMiddleCastBarsAllowChannelingForSpellId, hasuitMiddleCastBarsAllowHostileNonPlayersForSpellId)


do --instanceType only arena
    -- local enableMiddleCastBars
    
    local loadOn = {}
    local function loadOnCondition()
        -- if hasuitGlobal_InstanceType=="arena" and enableMiddleCastBars then --should load
        if hasuitGlobal_InstanceType=="arena" then --should load
            -- if not loadOn.shouldLoad then
                loadOn.shouldLoad = true
            -- end
        else --should NOT load
            -- if loadOn.shouldLoad then
                loadOn.shouldLoad = false
            -- end
        end
    end
    tinsert(hasuitDoThis_Player_Entering_WorldSkipsFirst, loadOnCondition)
    loadOnCondition()
    hasuitLoadOn_PvpEnemyMiddleCastBars = loadOn
    
    
    
end
local hasuitLoadOn_PvpEnemyMiddleCastBars = hasuitLoadOn_PvpEnemyMiddleCastBars





-- most controllers are attached to individual unitFrames, but this one is separated from unitFrames and in the upper middle of the screen, and created differently. It allows things from multiple units to all be combined there, instead of on unitFrames
-- hasuitController_Separate_UpperScreenCastBars = {} --middle castbars
local middleCastBarsController = CreateFrame("Frame", nil, hasuitFramesParent)
-- local controllerOptions = hasuitController_Separate_UpperScreenCastBars --hasuitSpellFunction_UnitCasting_MiddleCastBars
-- controllerOptions.controller = middleCastBarsController --controllerOptions seems pointless here, maybe for future separated controllers too, but it might be even better to get this system to be good and interchangeable with normal controllers somehow. should work on it again
middleCastBarsController.frames = {}
-- middleCastBarsController:SetFrameStrata("MEDIUM")
-- middleCastBarsController:SetFrameLevel(20)
middleCastBarsController:SetSize(1,1)





local middleCastBarsFrames = middleCastBarsController.frames
function hasuitMiddleCastBarsGrow(controller) --hasuitSpellFunction_UnitCasting_MiddleCastBars
    local nonArenaCount = 0
    for i=1, #middleCastBarsFrames do
        local castBar = middleCastBarsFrames[i]
        local arenaNumber = castBar.unitFrame and castBar.unitFrame.arenaNumber
        if arenaNumber then
            castBar:SetPoint("CENTER", controller, "TOP", 0, -arenaNumber*70)
        else
            castBar:SetPoint("CENTER", controller, "TOP", 0, 15+nonArenaCount*(castBar.height+1))
            nonArenaCount = nonArenaCount+1
        end
    end
end
middleCastBarsController.grow = hasuitMiddleCastBarsGrow





local hasuitCastBarFont26 = CreateFont("hasuitCastBarFont26")
local hasuitCastBarFont24 = CreateFont("hasuitCastBarFont24")
local hasuitCastBarFont20 = CreateFont("hasuitCastBarFont20")
local hasuitCastBarFont18 = CreateFont("hasuitCastBarFont18")
local hasuitCastBarFont14 = CreateFont("hasuitCastBarFont14")
hasuitCastBarFont26:SetFont("Fonts/FRIZQT__.TTF", 26, "OUTLINE")
hasuitCastBarFont24:SetFont("Fonts/FRIZQT__.TTF", 24, "OUTLINE")
hasuitCastBarFont20:SetFont("Fonts/FRIZQT__.TTF", 20, "OUTLINE")
hasuitCastBarFont18:SetFont("Fonts/FRIZQT__.TTF", 18, "OUTLINE")
hasuitCastBarFont14:SetFont("Fonts/FRIZQT__.TTF", 14, "OUTLINE")




 --todo should have more options, also should keep an array of all of these spelloptions to be able to change them all depending on conditions, like activate and move important castbars in rbgs, activate all hostile tracking in pve and move to a third position, etc


local danCommon = {controller=middleCastBarsController, ["width"]=220,  ["height"]=36,  ["fontObject"]=hasuitCastBarFont20, ["fontObjectArenaBox"]=hasuitCastBarFont26, r=1,    g=0,    b=0} --big red cc, width should stay even for all of these otherwise pixels can get ugly because of setpoint center in the grow function
hasuitBigRedMiddleCastBarsSpellOptions =            {hasuitSpellFunction_UnitCasting_MiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}



local danCommon = {controller=middleCastBarsController, ["width"]=220,  ["height"]=30,  ["fontObject"]=hasuitCastBarFont18, ["fontObjectArenaBox"]=hasuitCastBarFont24, r=0.5,  g=1,    b=0} --medium greenish defensive
hasuitGreenishDefensiveMiddleCastBarsSpellOptions = {hasuitSpellFunction_UnitCasting_MiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}



local danCommon = {controller=middleCastBarsController, ["width"]=220,  ["height"]=30,  ["fontObject"]=hasuitCastBarFont18, ["fontObjectArenaBox"]=hasuitCastBarFont24, r=1,    g=0.4,  b=0} --medium orange, stuff like searing glare, maybe add things like turn undead here for dks until a better system is made for that
hasuitOrangeMiddleCastBarsSpellOptions =            {hasuitSpellFunction_UnitCasting_MiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}



local danCommon = {controller=middleCastBarsController, ["width"]=220,  ["height"]=28,  ["fontObject"]=hasuitCastBarFont18, ["fontObjectArenaBox"]=hasuitCastBarFont24, r=1,    g=1,    b=0} --medium yellow significant damage ability
hasuitYellowMiddleCastBarsSpellOptions =            {hasuitSpellFunction_UnitCasting_MiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}



local danCommon = {controller=middleCastBarsController, ["width"]=220,  ["height"]=20,  ["fontObject"]=hasuitCastBarFont14, ["fontObjectArenaBox"]=hasuitCastBarFont20, r=0.7,  g=1,    b=0} --small yellowish misc
hasuitSmallMiscMiddleCastBarsSpellOptions =         {hasuitSpellFunction_UnitCasting_MiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}


local danCommon = {controller=middleCastBarsController, ["width"]=220,  ["height"]=20,  ["fontObject"]=hasuitCastBarFont14, ["fontObjectArenaBox"]=hasuitCastBarFont20, r=0.7,  g=1,    b=0} --small yellowish misc
hasuitUntrackedMiddleCastBarsSpellOptions =         {hasuitSpellFunction_UnitCasting_MiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon} --for people with ranged kicks to see untracked casts, todo ignore list?
if hasuitLocal7 then
    hasuitLocal7(hasuitUntrackedMiddleCastBarsSpellOptions)
end

local danCommon = {controller=middleCastBarsController, ["width"]=220,  ["height"]=20,  ["fontObject"]=hasuitCastBarFont14, ["fontObjectArenaBox"]=hasuitCastBarFont20, r=0,    g=1,    b=0} --small green damage
hasuitSmallDamageMiddleCastBarsSpellOptions =       {hasuitSpellFunction_UnitCasting_MiddleCastBars,["loadOn"]=hasuitLoadOn_PvpEnemyMiddleCastBars,   ["arena"]=danCommon}


-- initialized in general.lua






--[[
tinsert(hasuitDoThis_Addon_Loaded, function()
    hasuitSetupSpellOptionsMulti = {
                              -- {hasuitSpellFunction_UnitCasting_MiddleCastBars,    ["group"]=hasuitBigRedMiddleCastBarsSpellOptions["arena"]},
                              -- {hasuitSpellFunction_UnitCasting_MiddleCastBars,    ["group"]=hasuitGreenishDefensiveMiddleCastBarsSpellOptions["arena"]},
                              -- {hasuitSpellFunction_UnitCasting_MiddleCastBars,    ["group"]=hasuitOrangeMiddleCastBarsSpellOptions["arena"]},
                              -- {hasuitSpellFunction_UnitCasting_MiddleCastBars,    ["group"]=hasuitYellowMiddleCastBarsSpellOptions["arena"]},
                              -- {hasuitSpellFunction_UnitCasting_MiddleCastBars,    ["group"]=hasuitSmallMiscMiddleCastBarsSpellOptions["arena"]},
                              -- {hasuitSpellFunction_UnitCasting_MiddleCastBars,    ["group"]=hasuitUntrackedMiddleCastBarsSpellOptions["arena"]},
                              {hasuitSpellFunction_UnitCasting_MiddleCastBars,    ["group"]=hasuitSmallDamageMiddleCastBarsSpellOptions["arena"]},
    }
    hasuitFramesInitializeMulti(8936) --    hasuitSpellFunction_UnitCasting_MiddleCastBars = addMultiFunction(function()                         , hasuitSpellFunction_UnitCasting_IconsOnDest = addMultiFunction(function()
end)
--]]








tinsert(hasuitDoThis_UserOptionsLoaded, function() --useroptions stuff for positioning
    local savedUserOptions = hasuitSavedUserOptions
    local userOptionsOnChanged = hasuitUserOptionsOnChanged
    
    
    local C_Timer_NewTimer= C_Timer.NewTimer
    local hasuitCleanController = hasuitCleanController
    local hasuitGetCastBar = hasuitGetCastBar
    local hasuitAddToSeparateController = hasuitAddToSeparateController
    local hasuitCastBarOnUpdateFunction = hasuitCastBarOnUpdateFunction
    local hasuitCastBarFont20 = hasuitCastBarFont20
    
    local fakeCastBars
    local testCastBarsTimer
    local function testCastBarsTimerFunction()
        for i=1,#fakeCastBars do
            local fakeCastBar = fakeCastBars[i]
            fakeCastBar.unitFrame = nil
            fakeCastBar.active = false
            fakeCastBar:SetAlpha(0)
            fakeCastBar:SetScript("OnUpdate", nil)
        end
        hasuitCleanController(middleCastBarsController)
        fakeCastBars = nil
        testCastBarsTimer = nil
    end
    local function updateControllerPosition()
        middleCastBarsController:SetPoint("TOP", UIParent, "CENTER", savedUserOptions["middleCastBarsX"], savedUserOptions["middleCastBarsY"])
    end
    local function updateMiddleCastBarsFromUserOptions()
        if not testCastBarsTimer then
            fakeCastBars = {}
            testCastBarsTimer = C_Timer_NewTimer(5, testCastBarsTimerFunction)
            for i=1,3 do
                local frameIsNew = #unusedCastBars==0
                local fakeCastBar = hasuitGetCastBar()
                if frameIsNew then
                    fakeCastBar:SetSize(220, 36)
                    
                    local textOfSpellName = fakeCastBar.textOfSpellName
                    textOfSpellName:SetFontObject(hasuitCastBarFont20)
                    textOfSpellName:SetText("Cyclone")
                    fakeCastBar:SetStatusBarColor(1,0,0)
                    
                    local arenaNumberBox = fakeCastBar.arenaNumberBox
                    arenaNumberBox:SetSize(36, 36)
                    arenaNumberBox:SetColorTexture(1,0.49,0.04)
                    
                    local arenaNumberText = fakeCastBar.arenaNumberText
                    arenaNumberText:SetFontObject(hasuitCastBarFont20)
                    
                elseif not fakeCastBar.arenaNumberBoxShowing then
                    local arenaNumberBox = fakeCastBar.arenaNumberBox
                    local arenaNumberText = fakeCastBar.arenaNumberText
                    
                    arenaNumberBox:SetAlpha(1)
                    arenaNumberText:SetAlpha(1)
                    
                    if not arenaNumberText:GetFontObject() then
                        arenaNumberBox:SetSize(36, 36)
                        arenaNumberBox:SetColorTexture(1,0.49,0.04)
                        arenaNumberText:SetFontObject(hasuitCastBarFont20)
                    end
                    
                    fakeCastBar.arenaNumberBoxShowing = true
                    fakeCastBar.uninterruptibleBorder:SetPoint("BOTTOMRIGHT", arenaNumberBox, "BOTTOMRIGHT", hasuitUninterruptibleBorderSize, 0)
                    
                end
                
                fakeCastBar.arenaNumberText:SetText(i)
                
                fakeCastBar:SetAlpha(1)
                fakeCastBar:SetParent(hasuitFramesParent)
                fakeCastBar:SetFrameLevel(10)
                fakeCastBar.active = true
                hasuitAddToSeparateController(middleCastBarsController, fakeCastBar)
                fakeCastBar.unitFrame = {arenaNumber=i}
                tinsert(fakeCastBars, fakeCastBar)
                
                fakeCastBar:SetMinMaxValues(0, 5)
                fakeCastBar.currentValue = 0
                fakeCastBar:SetScript("OnUpdate", hasuitCastBarOnUpdateFunction)
                
                fakeCastBar.uninterruptibleBorder:SetAlpha(0)
                
            end
        else
            testCastBarsTimer:Cancel()
            testCastBarsTimer = C_Timer_NewTimer(5, testCastBarsTimerFunction)
            for i=1,#fakeCastBars do
                local fakeCastBar = fakeCastBars[i]
                fakeCastBar.currentValue = 0
            end
        end
        updateControllerPosition()
    end
    userOptionsOnChanged["middleCastBarsX"] = updateMiddleCastBarsFromUserOptions
    userOptionsOnChanged["middleCastBarsY"] = updateMiddleCastBarsFromUserOptions
    updateControllerPosition()
end)
