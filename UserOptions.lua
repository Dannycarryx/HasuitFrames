


--the plan is to keep things here to a minimum and let people do real customization in their own private addon with the help of a guide/things being set up to make that as easy as possible and syncing to my addon with the player_login table. i think i want basically anything to be possible in that, including removing things that are normally in the addon like removing spellids or switching everything from topleft-topleft controller of arena with topright-topright(harder) or adding custom functions/spellids/spellnames or whatever else. a big thing is making it so people can add spells that are missing for their class too, or want to track something that i might not want to put in the main addon. this is a new idea after basically everything has already been made but won't be that hard i don't think, maybe more work to get unitframes to be easy to add custom functions to. could be cool. might need to be careful about errors in shared tables like onupdate/mid-unit_aura

-- todo InterfaceOptionsFrame_OpenToCategory? whatever way gets the addon into the normal list on default ui. not a fan of interacting with anything like that but probably best. do something like if clicking the button for my addon there it closes the default frames and does the same thing as /hf?



local screenHeight

local danCreateCheckButton
local danCreateEditBox
local danCreateNewHeader
local danSetPointAndDirection
local createPageBackground
local createOptionsPages = {
    function() --1
        createPageBackground(150)
        
        danSetPointAndDirection("TOP", "TOPLEFT", 160, 19, -25)
        danCreateNewHeader("party")
        danCreateEditBox("partyX", "X")
        danCreateEditBox("partyY", "Y")
        danCreateEditBox("partyTest", "Test Size")
        
        danSetPointAndDirection("TOP", "TOPLEFT", 360, 19, -25)
        danCreateNewHeader("arena")
        danCreateEditBox("arenaX", "X")
        danCreateEditBox("arenaY", "Y")
        danCreateEditBox("arenaTest", "Test Size")
        
        danSetPointAndDirection("TOP", "TOPLEFT", 560, 19, -25)
        danCreateNewHeader("raid")
        danCreateEditBox("raidX", "X")
        danCreateEditBox("raidY", "Y")
        danCreateEditBox("raidTest", "Test Size")
    end,
    function() --2
        createPageBackground(150)
        
        danSetPointAndDirection("TOP", "TOPLEFT", 390, 19, -25)
        danCreateNewHeader("group")
        danCreateEditBox("groupColoredBackgroundMinimum", "Colored Background Minimum Size")
        danCreateNewHeader("party")
        danCreateCheckButton("hideBlizzardParty", "Hide Default")
        
        danSetPointAndDirection("TOP", "TOPLEFT", 170, -61, -25)
        danCreateEditBox("scale", "scale")
        if screenHeight~=1080 then
            danCreateCheckButton("usePixelPerfectModifier", "pixel perfect?")
        end
        
        danSetPointAndDirection("TOP", "TOPLEFT", 480, 19, -25)
        danCreateNewHeader("arena")
        danCreateEditBox("arenaColoredBackgroundMinimum")
        danCreateNewHeader("arena")
        danCreateCheckButton("hideBlizzardArena")
        
        danSetPointAndDirection("TOP", "TOPLEFT", 570, -34, -25)
        danCreateNewHeader("raid")
        danCreateCheckButton("hideBlizzardRaid")
    end,
}


local print = print
local activeScaleMultiplier

local savedUserOptions
local userOptionsOnChanged = {} --or just clicked/pressed enter, value doesn't have to actually change
hasuitUserOptionsOnChanged = userOptionsOnChanged
tinsert(hasuitDoThis_Addon_Loaded, 1, function()
    savedUserOptions = hasuitSavedUserOptions
    if not savedUserOptions then --will need to have checks for any new options added after release, maybe there's a better way to set this up
        print("Welcome to HasuitFrames. If you're new I recommend looking at welcome.txt in the HasuitFrames addon folder. glhf")
        savedUserOptions = { --defaults ___
            ["partyX"]=-381,
            ["partyY"]=127, --old comment: number-hasuitRaidFrameHeightForGroupSize[5]-3?
            
            ["arenaX"]=381,
            ["arenaY"]=127,
            
            ["raidX"]=0,
            ["raidY"]=-215,
            
            
            ["groupColoredBackgroundMinimum"]=4, --todo option for pve only?
            ["arenaColoredBackgroundMinimum"]=0, --worked in a skirmish with a little bit of green background showing through sometimes
            
            ["hideBlizzardParty"]=true,
            ["hideBlizzardArena"]=true,
            ["hideBlizzardRaid"]=true,
            
            ["scale"]=1,
            -- ["usePixelPerfectModifier"]=false, --this exists, default is off, won't show as an option if screen height is 1080 because it'd be irrelevant
        }
        hasuitSavedUserOptions = savedUserOptions
    end
    savedUserOptions["partyTest"] = 3 --need to fix cds for party of 5, todo would also be nice to show them in test mode, very bored todo don't save this to savedvariables?
    savedUserOptions["arenaTest"] = 3
    savedUserOptions["raidTest"] = 8
    
    
    
    
    
    
    
    local danDoThisUserOptionsLoaded = hasuitDoThis_UserOptionsLoaded
    for i=1,#danDoThisUserOptionsLoaded do
        danDoThisUserOptionsLoaded[i]()
    end
    
    
    local scaleChangeFunction
    local width, height = GetPhysicalScreenSize() --idk what i'm doing here but maybe this is ok
    screenHeight = height
    local usePixelPerfectModifier
    if height==1080 then
        usePixelPerfectModifier = true
        activeScaleMultiplier = 0.71111111111111
    else
        local pixelPerfectMult = 768/height
        usePixelPerfectModifier = savedUserOptions["usePixelPerfectModifier"]
        activeScaleMultiplier = usePixelPerfectModifier and pixelPerfectMult or 0.71111111111111
        
        userOptionsOnChanged["usePixelPerfectModifier"] = function()
            usePixelPerfectModifier = savedUserOptions["usePixelPerfectModifier"]
            activeScaleMultiplier = usePixelPerfectModifier and pixelPerfectMult or 0.71111111111111 --GetDefaultScale?
            scaleChangeFunction()
        end
    end
    
    local pixelWarningMessage = "changing the scale from 1 could make some borders not show or show 2 pixels instead of 1 and stuff like that. will be improved eventually"
    hasuitFramesParent:SetScale(savedUserOptions["scale"]*activeScaleMultiplier)
    function scaleChangeFunction()
        local scale = savedUserOptions["scale"]
        if pixelWarningMessage and usePixelPerfectModifier and scale~=1 then
            print(pixelWarningMessage)
            pixelWarningMessage = nil
        end
        hasuitFramesParent:SetScale(scale*activeScaleMultiplier)
    end
    userOptionsOnChanged["scale"] = scaleChangeFunction
end)







local CreateFrame = CreateFrame

local danBackdrop = {
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
    edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
    edgeSize = 1,
}
local danFont25 = CreateFont("danUserOptionsFont25")
danFont25:SetFont("Fonts/FRIZQT__.TTF", 25, "OUTLINE")
local danFont16 = CreateFont("danUserOptionsFont16")
danFont16:SetFont("Fonts/FRIZQT__.TTF", 16, "OUTLINE")
local danFont14 = CreateFont("danUserOptionsFont14")
danFont14:SetFont("Fonts/FRIZQT__.TTF", 14, "OUTLINE")

local editBoxEscape
local currentEditBox
local currentOptionsPage
local currentOptionsPageIndex = 0
local changesMade
local danCreateNewRow
local currentCheckButton
do
    function editBoxEscape(editBox) --OnEscapePressed
        editBox:SetText(savedUserOptions[editBox.optionsKey])
        currentEditBox = nil
        editBox:ClearFocus()
    end
    local tonumber = tonumber
    local function editBoxEnter(editBox) --OnEnterPressed
        local currentText = editBox:GetText()
        local number = tonumber(currentText)
        if number then
            local previousValue = savedUserOptions[editBox.optionsKey]
            savedUserOptions[editBox.optionsKey] = number
            changesMade = changesMade or previousValue~=number
            editBox.optionsOnChangedFunction()
        else
            editBox:SetText(savedUserOptions[editBox.optionsKey])
        end
        currentEditBox = nil
        editBox:ClearFocus()
    end
    local function checkButtonMouseDown(checkButton) --checkButton OnMouseDown
        local isChecked = savedUserOptions[checkButton.optionsKey]
        if isChecked then
            checkButton.onOffText:SetText("off")
            checkButton:SetBackdropColor(0.8,0,0)
            savedUserOptions[checkButton.optionsKey] = false
        else
            checkButton.onOffText:SetText("on")
            checkButton:SetBackdropColor(0,0.8,0)
            savedUserOptions[checkButton.optionsKey] = true
        end
        changesMade = true
        checkButton.optionsOnChangedFunction()
    end
    local function editBoxMouseDown(editBox) --OnMouseDown
        currentEditBox = editBox
        editBox:SetFocus()
    end
    local yChange
    local x
    local y
    local ownPoint
    local targetPoint
    function danCreateEditBox(optionsKey, leftText)
        local editBox = CreateFrame("EditBox", nil, currentOptionsPage, "BackdropTemplate")
        editBox:SetBackdrop(danBackdrop)
        editBox:SetBackdropColor(0,0,0)
        editBox:SetBackdropBorderColor(0.5,0.5,0.5)
        y = y+yChange
        editBox:SetPoint(ownPoint, currentOptionsPage, targetPoint, x, y)
        editBox:SetSize(80,20)
        editBox:SetFontObject(danFont16)
        editBox:SetJustifyH("CENTER")
        editBox:SetAutoFocus(false)
        editBox:SetScript("OnEscapePressed", editBoxEscape)
        editBox:SetScript("OnEnterPressed", editBoxEnter)
        editBox:SetScript("OnMouseDown", editBoxMouseDown)
        editBox.optionsOnChangedFunction = userOptionsOnChanged[optionsKey]
        editBox.optionsKey = optionsKey
        editBox:SetText(savedUserOptions[optionsKey])
        if leftText then
            local nameText = editBox:CreateFontString()
            nameText:SetFontObject(danFont16)
            nameText:SetText(leftText)
            nameText:SetPoint("RIGHT", editBox, "LEFT", -1,1)
        end
        return editBox
    end
    function danCreateCheckButton(optionsKey, leftText)
        local checkButton = CreateFrame("Button", nil, currentOptionsPage, "BackdropTemplate")
        checkButton:SetBackdrop(danBackdrop)
        checkButton:SetBackdropBorderColor(0,0,0)
        y = y+yChange
        checkButton:SetPoint(ownPoint, currentOptionsPage, targetPoint, x, y)
        checkButton:SetSize(80,20)
        checkButton:SetScript("OnMouseDown", checkButtonMouseDown)
        checkButton.optionsOnChangedFunction = userOptionsOnChanged[optionsKey]
        checkButton.optionsKey = optionsKey
        local onOffText = checkButton:CreateFontString()
        checkButton.onOffText = onOffText
        onOffText:SetFontObject(danFont14)
        onOffText:SetPoint("CENTER")
        if savedUserOptions[checkButton.optionsKey] then
            onOffText:SetText("on")
            checkButton:SetBackdropColor(0,0.8,0)
        else
            onOffText:SetText("off")
            checkButton:SetBackdropColor(0.8,0,0)
        end
        if leftText then
            local nameText = checkButton:CreateFontString()
            nameText:SetFontObject(danFont16)
            nameText:SetText(leftText)
            nameText:SetPoint("RIGHT", checkButton, "LEFT", -1,1)
        end
        return checkButton
    end
    function danCreateNewHeader(headerText)
        local header = currentOptionsPage:CreateFontString()
        header:SetFontObject(danFont25)
        header:SetText(headerText)
        y = y+yChange-3
        header:SetPoint(ownPoint,currentOptionsPage,targetPoint,x,y)
    end
    function danSetPointAndDirection(setOwnPoint, setTargetPoint, setX, setY, setYChange)
        ownPoint = setOwnPoint
        targetPoint = setTargetPoint
        x = setX
        y = setY
        yChange = setYChange
    end
end

local danDoThisAfterCombat = hasuitDoThis_AfterCombat
local danDoThisOnUpdate = hasuitDoThis_OnUpdate
local InCombatLockdown = InCombatLockdown
local userOptionsFrame = CreateFrame("Frame", "hasuitFramesOptionsFrame", UIParent, "BackdropTemplate")
userOptionsFrame:SetPropagateKeyboardInput(true)
local userOptionsShown
local optionsPages = {}
local function hideUserOptionsFrame()
    userOptionsShown = false
    userOptionsFrame:Hide()
    if changesMade then
        if InCombatLockdown() then
            print("saved changes, applying after combat")
        else
            print("saved changes") --the messages could be improved
        end
    end
    changesMade = nil
    if currentEditBox then
        editBoxEscape(currentEditBox)
    end
    currentOptionsPage:Hide()
end
local function onKeyDown(optionsFrame, key)
    if key=="ESCAPE" then
        if InCombatLockdown() then
            hideUserOptionsFrame()
        else
            userOptionsFrame:SetPropagateKeyboardInput(false) --the point is to prevent default game menu from popping up when hitting escape but also be able to press keys (especially movement) with the options open. if in combat the function gets prevented but default menu usually doesn't open because player will have a target and escape prioritizes clearing target over opening menu. i'd prefer that the frame only cared about escape but not sure how to do that
            hideUserOptionsFrame()
            danDoThisOnUpdate(function()
                if not InCombatLockdown() then
                    userOptionsFrame:SetPropagateKeyboardInput(true)
                else
                    danDoThisAfterCombat(function()
                        userOptionsFrame:SetPropagateKeyboardInput(true)
                    end)
                end
            end)
        end
    end
end
function createPageBackground(height)
    currentOptionsPage = CreateFrame("Frame", nil, userOptionsFrame, "BackdropTemplate")
    currentOptionsPage:SetBackdrop(danBackdrop)
    currentOptionsPage:SetHeight(height)
    currentOptionsPage:SetBackdropColor(0.2,0.2,0.2,0.4)
    currentOptionsPage:SetBackdropBorderColor(0,0,0)
    tinsert(optionsPages, currentOptionsPage)
    currentOptionsPage:SetPoint("TOPLEFT", userOptionsFrame, "BOTTOMLEFT")
    currentOptionsPage:SetPoint("TOPRIGHT", userOptionsFrame, "BOTTOMRIGHT")
end





local highestPage = #createOptionsPages
local function nextPage()
    if currentEditBox then
        editBoxEscape(currentEditBox)
    end
    currentOptionsPageIndex = currentOptionsPageIndex+1
    if currentOptionsPage then
        currentOptionsPage:Hide()
    end
    if optionsPages[currentOptionsPageIndex] then
        currentOptionsPage = optionsPages[currentOptionsPageIndex]
        currentOptionsPage:Show()
    else
        if createOptionsPages[currentOptionsPageIndex] then
            createOptionsPages[currentOptionsPageIndex]()
            createOptionsPages[currentOptionsPageIndex] = nil
        else
            currentOptionsPageIndex = currentOptionsPageIndex<=highestPage and currentOptionsPageIndex+1 or 1
            currentOptionsPage = optionsPages[currentOptionsPageIndex]
            currentOptionsPage:Show()
        end
    end
end

local function openMainOptions()
    if not userOptionsShown then
        userOptionsFrame:Show()
        currentOptionsPageIndex = 1
        currentOptionsPage = optionsPages[1]
        currentOptionsPage:Show()
        userOptionsShown = true
    else
        hideUserOptionsFrame()
    end
end
local function openMainOptionsFirst()
    userOptionsShown = true
    userOptionsFrame:SetClampedToScreen(true) --Frame:SetClampRectInsets(left, right, top, bottom)
    userOptionsFrame:SetIgnoreParentScale(true)
    userOptionsFrame:SetScale(0.71111111111111)
    userOptionsFrame:SetBackdrop(danBackdrop)
    userOptionsFrame:SetSize(710,30)
    userOptionsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
    userOptionsFrame:SetFrameStrata("HIGH")
    userOptionsFrame:SetBackdropColor(0,0,0,0.8)
    userOptionsFrame:SetBackdropBorderColor(0,0,0)
    userOptionsFrame:SetMovable(true)
    userOptionsFrame:EnableMouse(true)
    userOptionsFrame:RegisterForDrag("LeftButton", "RightButton")
    userOptionsFrame:SetScript("OnDragStart", function(optionsFrame)
        optionsFrame:StartMoving()
    end)
    userOptionsFrame:SetScript("OnDragStop", function(optionsFrame)
        optionsFrame:StopMovingOrSizing()
    end)
    userOptionsFrame:SetScript("OnKeyDown", onKeyDown)
    
    local closeButton = CreateFrame("Button", "hasuitFramesOptionsCloseButton", userOptionsFrame, "BackdropTemplate")
    closeButton:SetBackdrop(danBackdrop)
    closeButton:SetBackdropColor(0.8,0,0)
    closeButton:SetBackdropBorderColor(0,0,0)
    closeButton:SetSize(50,50)
    local text = closeButton:CreateFontString()
    text:SetFontObject(danFont25)
    text:SetText("x")
    text:SetPoint("CENTER",1,1)
    closeButton:SetPoint("TOPRIGHT",userOptionsFrame,"TOPRIGHT")
    closeButton:SetFrameLevel(3)
    closeButton:EnableMouse(true)
    closeButton:RegisterForClicks("AnyDown")
    closeButton:SetScript("OnClick", hideUserOptionsFrame)
    
    local nextButton = CreateFrame("Button", "hasuitFramesOptionsNextButton", userOptionsFrame, "BackdropTemplate") --i don't like this being top right but kind of want different pages to be able to be different heights and not have to click in different spots to hit next page button, not sure
    nextButton:SetBackdrop(danBackdrop)
    nextButton:SetBackdropColor(0,0.2,0.4)
    nextButton:SetBackdropBorderColor(0,0,0)
    nextButton:SetSize(50,40)
    local text = nextButton:CreateFontString()
    text:SetFontObject(danFont16)
    text:SetText("->")
    text:SetPoint("CENTER",1,1)
    text:SetJustifyH("CENTER")
    nextButton:SetPoint("TOPRIGHT",closeButton,"TOPLEFT")
    nextButton:SetFrameLevel(3)
    nextButton:EnableMouse(true)
    nextButton:RegisterForClicks("AnyDown")
    nextButton:SetScript("OnClick", nextPage)
    
    nextPage()
    
    SlashCmdList.HasuitFrames = openMainOptions
end

SLASH_HasuitFrames1 = "/hf" --capitalization doesn't matter
SLASH_HasuitFrames2 = "/hasuitframes"
SLASH_HasuitFrames3 = "/hasuit"
SLASH_HasuitFrames4 = "/hasuit frames"
SlashCmdList.HasuitFrames = openMainOptionsFirst

