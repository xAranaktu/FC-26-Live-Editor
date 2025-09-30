-- This script will transfer ban all teams
TRANSFER_BAN_MANAGER = require 'imports/core/managers/transfer_ban_manager'

-- Get Teams Table
local teams_table = LE.db:GetTable("teams")
local current_record = teams_table:GetFirstRecord()
local teamid = 0

while current_record > 0 do
    teamid = teams_table:GetRecordFieldValue(current_record, "teamid")
    TRANSFER_BAN_MANAGER:AddTeam(teamid, 20990101)

    current_record = teams_table:GetNextValidRecord()
end

TRANSFER_BAN_MANAGER:Save()
MessageBox("Done", "Done")
