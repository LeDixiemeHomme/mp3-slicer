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
  return string.format("Song: %s, Start: %s, End: %s",
  self.title or "Unknown", self.startTime or "0", self.endTime or "0")
end

return Song