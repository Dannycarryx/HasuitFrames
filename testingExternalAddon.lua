
--needs the 
-- hasuitDoThisPlayer_Login = hasuitDoThisPlayer_Login or {}
-- tinsert(hasuitDoThisPlayer_Login, function()
	
-- end)
--thing

 --fixes middle icon if unitFrame height or width changes. had to make the grow function for it setpoint on something other than center or pixels bug and this seemed like a good excuse to make this system, could maybe have fixed differently, based on absolute position or something
 --first attempt to let people make custom functions that affect unitframes in their external addon. need to have a better idea of what i want this to be for otherwise should leave it for later, seems like a useful thing though

local danRemoveFunctionFromArray = hasuitRemoveUnitHealthControlNotSafe --should rename maybe?
local hasuitDoThisGroupUnitUpdate_Positions = hasuitDoThisGroupUnitUpdate_Positions
local hasuitDoThisGroupUnitUpdate_Positions_after = hasuitDoThisGroupUnitUpdate_Positions_after
local repositioningFunctionIsActive
local tinsert = tinsert
local floor = floor
-- local C_Timer_After = C_Timer.After


local customControllerSetupFunctions = hasuitController_Middle_Middle.customControllerSetupFunctions
if not customControllerSetupFunctions then
    customControllerSetupFunctions = {}
    hasuitController_Middle_Middle.customControllerSetupFunctions = customControllerSetupFunctions
end
tinsert(customControllerSetupFunctions, function(controller)
    controller.setPointOn.middleController = controller --setPointOn is unitFrame unless ["setPointOnBorder"] is true
end)--might want to just give every controller a .unitFrame?


local function customUpdateGroupUnitFrameFunction(unitFrame) --will update when frames actually change size if they were waiting on combat
    local middleController = unitFrame.middleController
    if middleController then
        local middleIcon = middleController.frames[1]
        if middleIcon then
            local setPointOn = middleController.setPointOn
            middleIcon:SetPoint("TOPLEFT", setPointOn, "TOPLEFT", floor(setPointOn.width/2-middleIcon.size/2), floor(-setPointOn.height/2+middleIcon.size/2)) --.height instead of hasuitRaidFrameHeight because of mana bar
        end
    end
end
local function removeAfter()
    danRemoveFunctionFromArray(hasuitDoThisGroupUnitUpdate_Positions, customUpdateGroupUnitFrameFunction) --this makes it only happen once when unitframe size changes and not spam future group updates
    repositioningFunctionIsActive = false
end
local function ifUnitFramesSizeChangesFunction()
    if hasuitInstanceType=="pvp" and not repositioningFunctionIsActive then --middle icon can only be active in bgs atm, hopefully hasuitInstanceType is always set correctly here. I think it will be. todo look into this, will actually be easy to see the exact earliest time that instancetype changes now that I think about it
        repositioningFunctionIsActive = true
        tinsert(hasuitDoThisGroupUnitUpdate_Positions, customUpdateGroupUnitFrameFunction)
        tinsert(hasuitDoThisGroupUnitUpdate_Positions_after, removeAfter)
    end
end
tinsert(hasuitDoThisGroup_Roster_UpdateWidthChanged.functions, ifUnitFramesSizeChangesFunction) --could check pixel perfect mode and prevent this/change middle grow function to setpoint on center instead of topleft because it'll do nothing useful if pixel perfect mode is off
tinsert(hasuitDoThisGroup_Roster_UpdateHeightChanged.functions, ifUnitFramesSizeChangesFunction)






-- tinsert(hasuitDoThisGroup_Roster_UpdateGroupSize_5.functions, function() --unitFrames will attach to raid buttons instead of party buttons and ignore combat if switching from group 5 to 6+, use this for that case if switching from 5 to 6+ might be relevant --actually they won't change size I think so this isn't needed
    -- if not repositioningFunctionIsActive then
        -- repositioningFunctionIsActive = true
        -- tinsert(hasuitDoThisGroupUnitUpdate, customUpdateGroupUnitFrameFunction) --needs a delay though too because this happens before size actually changes
        -- tinsert(hasuitDoThisGroupUnitUpdate_after, removeAfter)
    -- end
-- end)



