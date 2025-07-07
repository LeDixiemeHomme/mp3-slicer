local Song = {}
Song.__index = Song

function Song.new(startTime, endTime, title)
  local self = setmetatable({}, Song)
  self.startTime = startTime
  self.endTime = endTime
  self.title = title
  return self
end

return Song