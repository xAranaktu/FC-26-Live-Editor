--- This script will keep your player fitness at 100 in player career mode

require 'imports/career_mode/enums'
require 'imports/career_mode/helpers'
FCECareerModeUserManager = require 'imports/career_mode/fcecareermodeusermanager'

function MaxVPROFitness__OnEvent(events_manager, event_id, event)
    if (
        event_id == ENUM_CM_EVENT_MSG_DAY_PASSED or                 -- Every Day
        event_id == ENUM_CM_EVENT_MSG_ABOUT_TO_ENTER_PREMATCH or    -- Before match
        event_id == ENUM_CM_EVENT_MSG_POST_LOAD_PREPARE             -- After save load
    ) then
        local cm_user_mgr = FCECareerModeUserManager:new()
        local VPRO_PLAYERID = cm_user_mgr:GetPAPID()
        if (VPRO_PLAYERID > 0) then
            SetPlayerFitness(VPRO_PLAYERID, 99)
        end
        
    end
end

AddEventHandler("post__CareerModeEvent", MaxVPROFitness__OnEvent)

-- Apply immidiately if script is executed after the career mode is loaded
if (IsInCM()) then
    local cm_user_mgr = FCECareerModeUserManager:new()
    local VPRO_PLAYERID = cm_user_mgr:GetPAPID()
    if (VPRO_PLAYERID > 0) then
        SetPlayerFitness(VPRO_PLAYERID, 99)
    end
end