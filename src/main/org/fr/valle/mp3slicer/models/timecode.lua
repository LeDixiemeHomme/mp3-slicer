local Timecode = {}
Timecode.__index = Timecode

function Timecode.new(hours, minutes, seconds)
    local self = setmetatable({}, Timecode)
    self.hours = hours or 0
    self.minutes = minutes or 0
    self.seconds = seconds or 0
    return self
end

function Timecode.fromCmdFormat(cmd_format)
    local h, m, s
    if cmd_format:match("^%d+:%d+:%d+$") then
        h, m, s = cmd_format:match("^(%d+):(%d+):(%d+)$")
        return Timecode.new(tonumber(h), tonumber(m), tonumber(s))
    elseif cmd_format:match("^%d+:%d+$") then
        m, s = cmd_format:match("^(%d+):(%d+)$")
        return Timecode.new(0, tonumber(m), tonumber(s))
    elseif cmd_format:match("^%d+$") then
        s = tonumber(cmd_format)
        return Timecode.new(0, 0, s)
    else
        return Timecode.new(0, 0, 0)
    end
end

function Timecode.fromSeconds(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    local self = setmetatable({}, Timecode)
    self.hours = tonumber(h) or 0
    self.minutes = tonumber(m) or 0
    self.seconds = tonumber(s) or 0
    return self
end

function Timecode:to_string()
    return string.format("Timecode: %02d:%02d:%02d", self.hours, self.minutes, self.seconds)
end

function Timecode:to_seconds()
    return self.hours * 3600 + self.minutes * 60 + self.seconds
end

function Timecode:to_cmd_format()
    return string.format("%02d:%02d:%02d", self.hours, self.minutes, self.seconds)
end

function Timecode:is_greater_than(other)
    if not other or not getmetatable(other) == Timecode then
        return false
    end
    return self:to_seconds() > other:to_seconds()
end

function Timecode:is_too_close_from_time(other, time_spacing)
    if not other or not getmetatable(other) == Timecode then
        return false
    end
    return math.abs(self:to_seconds() 
    - other:to_seconds())
    < (time_spacing:to_seconds() or 0.1)
end

return Timecode