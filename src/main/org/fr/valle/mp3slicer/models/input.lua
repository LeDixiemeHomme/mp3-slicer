local Input = {}
Input.__index = Input

function Input.new(startTime, title)
    local self = setmetatable({}, Input)
    self.startTime = startTime
    self.title = title
    return self
end

return Input