local Song = require("src.main.org.fr.valle.mp3slicer.models.song")
local Input = require("src.main.org.fr.valle.mp3slicer.models.input")

local function time_to_seconds(time_str)
    -- Supporte HH:MM:SS ou MM:SS
    local h, m, s
    if time_str:match("^%d+:%d+:%d+$") then
        h, m, s = time_str:match("^(%d+):(%d+):(%d+)$")
        return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
    elseif time_str:match("^%d+:%d+$") then
        m, s = time_str:match("^(%d+):(%d+)$")
        return tonumber(m) * 60 + tonumber(s)
    else
        return tonumber(time_str) or 0
    end
end

local function seconds_to_time(seconds)
    print("seconds_to_time called with:", seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    print("Converted to:", h, m, s)
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function read_starts_and_titles(path)
    local songs = {}
    for line in io.lines(path) do
        local time, title = line:match("^(%S+)%s+(.+)$")
        if time and title then
            local start_sec = time_to_seconds(time)
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
            local start_sec = time_to_seconds(time)
            table.insert(inputs, Input.new(start_sec, title))
        end
    end
    return inputs
end

local function read_silences_from_output(output)
  local silences = {}
  local last_silence_start = nil
  for line in output:gmatch("[^\r\n]+") do
    local silence_start = line:match("silence_start: ([%d%.]+)")
    local silence_end = line:match("silence_end: ([%d%.]+)")
    if silence_start then
      last_silence_start = tonumber(silence_start)
    elseif silence_end and last_silence_start then
      table.insert(silences, {
        startTime = seconds_to_time(last_silence_start),
        endTime = seconds_to_time(silence_end)
      })
      last_silence_start = nil
    end
  end
  return silences
end

return {
    read_starts_and_titles = read_starts_and_titles,
    time_to_seconds = time_to_seconds,
    seconds_to_time = seconds_to_time,
    read_silences_from_output = read_silences_from_output,
    read_inputs = read_inputs
}
