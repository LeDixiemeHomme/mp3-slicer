local time_util = require("src.main.org.fr.valle.mp3slicer.utils.time_util")

local Song = {}
Song.__index = Song

function Song.new(startTime, endTime, title)
  local self = setmetatable({}, Song)
  self.startTime = startTime
  self.endTime = endTime
  self.title = title
  return self
end

function Song:to_string()
  return string.format("Song: %s, Start: %s, End: %s", self.title or "Unknown", self.startTime or "0", self.endTime or "0")
end

function Song:is_too_close_from_time(time_to_compare, time_spacing)
  -- Compare les temps en HH:MM:SS ou MM:SS
  local time_in_seconds = time_util.time_to_seconds(self.startTime)
  local compare_in_seconds = time_util.time_to_seconds(time_to_compare)
  return math.abs(time_in_seconds - compare_in_seconds) < (time_util.time_to_seconds(time_spacing) or 0.1)
end

return Song