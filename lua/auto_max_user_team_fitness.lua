--- This script will keep yours players Fitness at 100
require 'imports/career_mode/enums'
require 'imports/career_mode/helpers'

function MaxFitness__OnEvent(events_manager, event_id, event)
    if (
        event_id == ENUM_CM_EVENT_MSG_DAY_PASSED or                 -- Every Day
        event_id == ENUM_CM_EVENT_MSG_ABOUT_TO_ENTER_PREMATCH or    -- Before match
        event_id == ENUM_CM_EVENT_MSG_POST_LOAD_PREPARE             -- After save load
    ) then
        UserTeamSetPlayersFitness(100)
    end
end

AddEventHandler("post__CareerModeEvent", MaxFitness__OnEvent)

-- Apply immidiately if script is executed after the career mode is loaded
if (IsInCM()) then
    UserTeamSetPlayersFitness(100)
end