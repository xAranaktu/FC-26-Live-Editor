--- This script will keep yours players Sharpness at 99

require 'imports/career_mode/enums'
require 'imports/career_mode/helpers'


function MaxSharpness__OnEvent(events_manager, event_id, event)
    if (
        event_id == ENUM_CM_EVENT_MSG_DAY_PASSED or                 -- Every Day
        event_id == ENUM_CM_EVENT_MSG_ABOUT_TO_ENTER_PREMATCH or    -- Before match
        event_id == ENUM_CM_EVENT_MSG_POST_LOAD_PREPARE             -- After save load
    ) then
        UserTeamSetPlayersSharpness(100)
    end
end

AddEventHandler("post__CareerModeEvent", MaxSharpness__OnEvent)

-- Apply immidiately if script is executed after the career mode is loaded
if (IsInCM()) then
    UserTeamSetPlayersSharpness(100)
end