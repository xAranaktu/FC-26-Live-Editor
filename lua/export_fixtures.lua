MEMORY = require 'imports/core/memory'
require 'imports/other/helpers'
require 'imports/services/enums'

assert(IsInCM(), "Script must be executed in career mode")

local columns = {
    "competition",
    "compobjid",
    "hometeamid",
    "awayteamid",
    "hometeam",
    "homescore",
    "awayscore",
    "awayteam",
    "date",
    "time"
}

function GetFCEDataManager() 
    local IFCEInterface = GetPlugin(ENUM_djb2IFCEInterface_CLSS)
    -- print(string.format("IFCEInterface* = 0x%X", IFCEInterface))
    
    return MEMORY:ReadMultilevelPointer(IFCEInterface, {0x18, 0x10, 0x08, 0x00})
end

function GetValidStandings()
    local result = {}

    local FCEDataManager = GetFCEDataManager()
    local StandingsDataList = MEMORY:ReadPointer(FCEDataManager + 0x88)
    
    -- print(string.format("StandingsDataList* = 0x%X", StandingsDataList))
    
    local itemSize = 0x18 -- sizeof(StandingsData)
    local mBegin = MEMORY:ReadPointer(StandingsDataList + 0x28)
    local max_items_count = MEMORY:ReadInt(StandingsDataList + 0x1C) - 1
    
    local mCurrent = 0
    for i = 0, max_items_count do
        mCurrent = mBegin + (itemSize*i)

        local is_used = MEMORY:ReadBool(mCurrent + 0x16)
        local mTeamId = MEMORY:ReadInt(mCurrent + 0x04)
        if is_used and mTeamId > 0 then
            local StandingsData = {}
            -- print(string.format("StandingsData* = 0x%X", mCurrent))
            StandingsData["mId"] = MEMORY:ReadShort(mCurrent + 0x00)
            StandingsData["mCompObjId"] = MEMORY:ReadShort(mCurrent + 0x02)
            StandingsData["mTeamId"] = mTeamId  -- MEMORY:ReadInt(mCurrent + 0x04)
            StandingsData["mTeamIndex"] = MEMORY:ReadChar(mCurrent + 0x08)
            StandingsData["mHomeWins"] = MEMORY:ReadChar(mCurrent + 0x09)
            StandingsData["mHomeDraws"] = MEMORY:ReadChar(mCurrent + 0x0A)
            StandingsData["mHomeLosses"] = MEMORY:ReadChar(mCurrent + 0x0B)
            StandingsData["mHomeGoalsFor"] = MEMORY:ReadChar(mCurrent + 0x0C)
            StandingsData["mHomeGoalsAgainst"] = MEMORY:ReadChar(mCurrent + 0x0D)
            StandingsData["mAwayWins"] = MEMORY:ReadChar(mCurrent + 0x0E)
            StandingsData["mAwayDraws"] = MEMORY:ReadChar(mCurrent + 0x0F)
            StandingsData["mAwayLosses"] = MEMORY:ReadChar(mCurrent + 0x10)
            StandingsData["mAwayGoalsFor"] = MEMORY:ReadChar(mCurrent + 0x11)
            StandingsData["mAwayGoalsAgainst"] = MEMORY:ReadChar(mCurrent + 0x12)
            StandingsData["mPoints"] = MEMORY:ReadShort(mCurrent + 0x14)
        
            table.insert(result, StandingsData)
        end
    end
    
    return result
end

function GetStandingsByIndex(idx)
    local StandingsData = {}

    local FCEDataManager = GetFCEDataManager()
    local StandingsDataList = MEMORY:ReadPointer(FCEDataManager + 0x88)
    
    local itemSize = 0x18 -- sizeof(StandingsData)
    local mBegin = MEMORY:ReadPointer(StandingsDataList + 0x28)
    
    local mCurrent = mBegin + (itemSize*idx)
    
    StandingsData["mId"] = MEMORY:ReadShort(mCurrent + 0x00)
    StandingsData["mCompObjId"] = MEMORY:ReadShort(mCurrent + 0x02)
    StandingsData["mTeamId"] = MEMORY:ReadInt(mCurrent + 0x04)
    StandingsData["mTeamIndex"] = MEMORY:ReadChar(mCurrent + 0x08)
    StandingsData["mHomeWins"] = MEMORY:ReadChar(mCurrent + 0x09)
    StandingsData["mHomeDraws"] = MEMORY:ReadChar(mCurrent + 0x0A)
    StandingsData["mHomeLosses"] = MEMORY:ReadChar(mCurrent + 0x0B)
    StandingsData["mHomeGoalsFor"] = MEMORY:ReadChar(mCurrent + 0x0C)
    StandingsData["mHomeGoalsAgainst"] = MEMORY:ReadChar(mCurrent + 0x0D)
    StandingsData["mAwayWins"] = MEMORY:ReadChar(mCurrent + 0x0E)
    StandingsData["mAwayDraws"] = MEMORY:ReadChar(mCurrent + 0x0F)
    StandingsData["mAwayLosses"] = MEMORY:ReadChar(mCurrent + 0x10)
    StandingsData["mAwayGoalsFor"] = MEMORY:ReadChar(mCurrent + 0x11)
    StandingsData["mAwayGoalsAgainst"] = MEMORY:ReadChar(mCurrent + 0x12)
    StandingsData["mPoints"] = MEMORY:ReadShort(mCurrent + 0x14)
    
    return StandingsData
end

function GetValidFixtures()
    local result = {}

    local FCEDataManager = GetFCEDataManager()
    local FixtureDataList = MEMORY:ReadPointer(FCEDataManager + 0x60)
    
    -- print(string.format("FixtureDataList* = 0x%X", FixtureDataList))
    
    local itemSize = 0x18 -- sizeof(FixtureData)
    local mBegin = MEMORY:ReadPointer(FixtureDataList + 0x28)
    local max_items_count = MEMORY:ReadInt(FixtureDataList + 0x1C) - 1
    
    local mCurrent = 0
    for i = 0, max_items_count do
        mCurrent = mBegin + (itemSize*i)

        local is_used = MEMORY:ReadBool(mCurrent + 0x14)

        if is_used then
            local FixtureData = {}
            -- print(string.format("FixtureData* = 0x%X", mCurrent))
            FixtureData["mDate"] = MEMORY:ReadInt(mCurrent + 0x00)
            FixtureData["mTime"] = MEMORY:ReadShort(mCurrent + 0x04)
            FixtureData["mId"] = MEMORY:ReadShort(mCurrent + 0x06)
            FixtureData["mCompObjId"] = MEMORY:ReadShort(mCurrent + 0x08)
            FixtureData["mHomeStandingId"] = MEMORY:ReadShort(mCurrent + 0x0A)
            FixtureData["mAwayStandingId"] = MEMORY:ReadShort(mCurrent + 0x0C)
            FixtureData["mMatchGroupId"] = MEMORY:ReadChar(mCurrent + 0x0E)
            FixtureData["mHomeScore"] = MEMORY:ReadChar(mCurrent + 0x0F)
            FixtureData["mHomePenalties"] = MEMORY:ReadChar(mCurrent + 0x10)
            FixtureData["mAwayScore"] = MEMORY:ReadChar(mCurrent + 0x11)
            FixtureData["mAwayPenalties"] = MEMORY:ReadChar(mCurrent + 0x12)
            FixtureData["mGameCompletion"] = MEMORY:ReadBool(mCurrent + 0x13)
        
            table.insert(result, FixtureData)
        end
    end
    
    return result
end

local valid_standings = GetValidStandings()
local valid_fixtures = GetValidFixtures()

local file_created_tracker = {}

local desktop_path = string.format("%s\\Desktop", os.getenv('USERPROFILE'))
local current_date = GetCurrentDate()


for i = 1, #valid_fixtures do
    local FixtureData = valid_fixtures[i]
    local compobjid = FixtureData["mCompObjId"]
    local compname = GetCompetitionNameByObjID(compobjid)
    
    local file_path = string.format("%s\\FIXTURES_%s_%02d_%02d_%04d.csv", desktop_path, compname, current_date.day, current_date.month, current_date.year)
    
    if not file_created_tracker[compobjid] then
        local file = io.open(file_path, "w+")
        io.output(file)
        io.write(table.concat(columns, ","))
        io.write("\n")
        io.close(file)
        file_created_tracker[compobjid] = true
    end

    local HomeStandingsData = GetStandingsByIndex(FixtureData["mHomeStandingId"])
    local AwayStandingsData = GetStandingsByIndex(FixtureData["mAwayStandingId"])
    
    local home_teamid = HomeStandingsData["mTeamId"]
    local away_teamid = AwayStandingsData["mTeamId"]
    
    local hometeam_name = GetTeamName(home_teamid)
    local awayteam_name = GetTeamName(away_teamid)
        
    local home_score = "TBD"
    local away_score = "TBD"
    
    if FixtureData["mGameCompletion"] then
        home_score = tostring(FixtureData["mHomeScore"])
        away_score = tostring(FixtureData["mAwayScore"])
    end
    
    local _date = FixtureData["mDate"]
    local _time = FixtureData["mTime"]
    
    local line = string.format( "%s,%d,%d,%d,%s,%s,%s,%s,%d,%d\n",  compname, compobjid, home_teamid, away_teamid, hometeam_name, home_score, away_score, awayteam_name, _date, _time)
    
    local afile = io.open(file_path, "a")
    io.output(afile)
    io.write(line)
    io.close(afile)
end
