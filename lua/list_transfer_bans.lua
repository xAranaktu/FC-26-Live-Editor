-- This script will log all active transfer bans

DATE = require 'imports/core/date'
TRANSFER_BAN_MANAGER = require 'imports/core/managers/transfer_ban_manager'

local ban_end_date = DATE:new()

local all_bans = TRANSFER_BAN_MANAGER:GetAllBans()
for i=1, #all_bans do
    local transfer_ban = all_bans[i]
    
    ban_end_date:FromInt(transfer_ban.date_end)
    if transfer_ban.member_type == ENUM_TRANSFER_BAN_PLAYER then
        print(string.format(
            "PLAYER: %s (ID: %d) Transfer Banned Until %s",
            GetPlayerName(transfer_ban.id), transfer_ban.id, ban_end_date:ToString()
        ))
    else
        print(string.format(
            "TEAM: %s (ID: %d) Transfer Banned Until %s",
            GetTeamName(transfer_ban.id), transfer_ban.id, ban_end_date:ToString()
        ))
    end
end