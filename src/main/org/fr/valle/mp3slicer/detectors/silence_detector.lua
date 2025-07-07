local utils = require("src.main.org.fr.valle.mp3slicer.utils.util")

local function detect_silences(mp3_path, noise_threshold, duration)
  local command = string.format('ffmpeg -i "%s" -af silencedetect=noise=%sdB:d=%s -f null - 2>&1', mp3_path,
    noise_threshold, duration)
  local handle = io.popen(command)
  local output = handle:read("*a")
  handle:close()
  return utils.read_silences_from_output(output)
end

return {
  detect_silences = detect_silences
}
