local time_util = require("src.main.org.fr.valle.mp3slicer.utils.time_util")
local Silence = require("src.main.org.fr.valle.mp3slicer.models.silence")

local function read_silences_from_ffmpeg_silence_output(output)
  local silences = {}
  local last_silence_start = nil
  for line in output:gmatch("[^\r\n]+") do
    local silence_start = line:match("silence_start: ([%d%.]+)")
    local silence_end = line:match("silence_end: ([%d%.]+)")
    if silence_start then
      last_silence_start = tonumber(silence_start)
    elseif silence_end and last_silence_start then
      table.insert(silences, 
        Silence.new(
          time_util.seconds_to_time(last_silence_start),
          time_util.seconds_to_time(tonumber(silence_end))
        )
      )
      last_silence_start = nil
    end
  end
  return silences
end

local function detect_silences_with_config(mp3_path, noise_threshold, duration)
  local command = string.format('ffmpeg -i "%s" -af silencedetect=noise=%sdB:d=%s -f null - 2>&1', mp3_path,
    noise_threshold, duration)
  local handle = io.popen(command)
  local output = handle:read("*a")
  handle:close()
  return read_silences_from_ffmpeg_silence_output(output)
end

local function detect_plausible_silences(input_mp3, inputs, db_in, duration_in)
  local expected_silences = #inputs
  print("Nombre de silences attendus :", expected_silences)

  -- 2. Boucle sur les valeurs de dB pour trouver la bonne config
  local founded_silences = {}
  for db = db_in.min, db_in.max, db_in.step do
    if #founded_silences ~= 0 then break end
    print("Test avec seuil dB :", db)
    for duration = duration_in.min, duration_in.max, duration_in.step do
      if #founded_silences ~= 0 then break end
      print("- Test avec duration s :", duration)
      local silences = detect_silences_with_config(input_mp3, db, duration)
      print("--- Nb de silences trouvé :", #silences)
      if #silences == expected_silences then
        print("----- FOUND !")
        for _, silence in ipairs(silences) do
          print(silence:to_string())
        end
        founded_silences = silences
        break
      end
    end
  end

  if #founded_silences == 0 then
    print("Impossible de trouver une configuration qui matche le nombre de morceaux.")
    os.exit(1)
  end
  return founded_silences
end

return {
  read_silences_from_ffmpeg_silence_output = read_silences_from_ffmpeg_silence_output,
  detect_silences_with_config = detect_silences_with_config,
  detect_plausible_silences = detect_plausible_silences
}
