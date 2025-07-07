local Silence = require("src.main.org.fr.valle.mp3slicer.models.silence")
local Song = require("src.main.org.fr.valle.mp3slicer.models.song")

local function split_mp3(input_mp3, songs, output_dir)
  for i, song in ipairs(songs) do
    print("traitement split de : ", song.startTime, song.endTime, song.title)
    if song.startTime and song.endTime and song.title then
      local output_name = string.format("%02d-%s.mp3", i, song.title:gsub(" ", "_"))
      local output_path = output_dir .. "/" .. output_name
      local command = string.format(
        'ffmpeg -y -i "%s" -ss %s -to %s -acodec copy "%s"',
        input_mp3, song.startTime, song.endTime, output_path
      )
      print("Découpage :", command)
      os.execute(command)
    end
  end
end

return {
  split_mp3 = split_mp3
}