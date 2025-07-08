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
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    local ok, result = pcall(string.format, "%02d:%02d:%02d", h, m, s)
    if ok then
        return result
    else
        print("Erreur attrapée lors de seconds_to_time avec :", seconds, h, m, s)
    end
end

return {
    time_to_seconds = time_to_seconds,
    seconds_to_time = seconds_to_time
}
