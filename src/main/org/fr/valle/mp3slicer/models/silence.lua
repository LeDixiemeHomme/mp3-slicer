local Song = require("src.main.org.fr.valle.mp3slicer.models.song")

local Silence = {}
Silence.__index = Silence

function Silence.new(startTime, endTime)
    local self = setmetatable({}, Silence)
    self.startTime = startTime
    self.endTime = endTime
    return self
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