local Song = require("src.main.org.fr.valle.mp3slicer.models.song")
local Timecode = require("src.main.org.fr.valle.mp3slicer.models.timecode")

local Silence = {}
Silence.__index = Silence

function Silence.new(startTime, endTime)
    local self = setmetatable({}, Silence)
    self.startTime = startTime
    self.endTime = endTime
    return self
end

function Silence:to_string()
    return string.format("Silence: Start: %s, End: %s", self.startTime:to_cmd_format() or "0", self.endTime:to_cmd_format() or "0")
end

function Silence:is_too_close_from_time(time_to_compare, time_spacing)
  -- Compare les temps en HH:MM:SS ou MM:SS
  local time_in_seconds = Timecode(self.startTime):to_seconds()
  local compare_in_seconds = Timecode(time_to_compare):to_seconds()
  return math.abs(time_in_seconds - compare_in_seconds) < (Timecode(time_spacing):to_seconds() or 0.1)
end

local function make_songs(silences, titles, globalStartTime, globalEndTime)
    local songs = {}
    local n = #silences

    if n == 0 then
        -- Aucun silence, un seul morceau global
        table.insert(songs, Song.new(globalStartTime, globalEndTime, titles[1] or "Unknown Title"))
        return songs
    end

    -- Premier morceau : du début global au début du premier silence
    table.insert(songs, Song.new(
        globalStartTime,
        silences[1].startTime,
        titles[1] or "Unknown Title"
    ))

    -- Morceaux intermédiaires
    for i = 1, n - 1 do
        table.insert(songs, Song.new(
            silences[i].endTime,
            silences[i + 1].startTime,
            titles[i + 1] or "Unknown Title"
        ))
    end

    -- Dernier morceau : de la fin du dernier silence à la fin globale
    table.insert(songs, Song.new(
        silences[n].endTime,
        globalEndTime,
        titles[n + 1] or "Unknown Title"
    ))

    return songs
end

Silence.make_songs = make_songs

return Silence