local Song = require("src.main.org.fr.valle.mp3slicer.models.song")
local Input = require("src.main.org.fr.valle.mp3slicer.models.input")
local time_util = require("src.main.org.fr.valle.mp3slicer.utils.time_util")

local function read_starts_and_titles(path)
    local songs = {}
    for line in io.lines(path) do
        local time, title = line:match("^(%S+)%s+(.+)$")
        if time and title then
            local start_sec = time_util.time_to_seconds(time)
            table.insert(songs, Song.new(start_sec, nil, title))
        end
    end
    return songs
end

local function read_inputs(path)
    local inputs = {}
    for line in io.lines(path) do
        local time, title = line:match("^(%S+)%s+(.+)$")
        if time and title then
            local start_sec = time_util.time_to_seconds(time)
            table.insert(inputs, Input.new(start_sec, title))
        end
    end
    return inputs
end

return {
    read_starts_and_titles = read_starts_and_titles,
    read_inputs = read_inputs
}
