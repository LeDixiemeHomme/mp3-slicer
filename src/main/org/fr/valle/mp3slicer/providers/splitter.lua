local command_to_format = 'ffmpeg -y -loglevel error -i "%s" -ss %s -to %s -acodec copy "%s"'

local function split_mp3(input_mp3, songs, output_dir, song_duration, max_time_spacing_from_end)
  os.execute('mkdir -p "' .. output_dir .. '"')

  for i, song in ipairs(songs) do
    print("traitement split de : ",
      song.startTime:to_string(),
      song.endTime:to_string(),
      song.title
    )

    if song.startTime:is_too_close_from_time(song_duration, max_time_spacing_from_end) then
      print("Ignorer car trop proche < :", max_time_spacing_from_end, song:to_string())
      -- elseif song:is_too_close_from_time("00:00:00", max_time_spacing_from_end) then
      --   print("Ignorer car trop proche < :", max_time_spacing_from_end, song:to_string())
    else
      local output_name = string.format("%02d-%s.mp3", i, song.title:gsub(" ", "_"))
      local output_path = output_dir .. "/" .. output_name
      local command = string.format(
        command_to_format, input_mp3, song.startTime:to_cmd_format(), song.endTime:to_cmd_format(), output_path
      )
      print("Découpage : ", command)

      local success, exit_type, exit_code = os.execute(command)

      if not success then
        print("Erreur Découpage :", exit_type, exit_code, i, song:to_string())
      end
    end
  end
end

return {
  split_mp3 = split_mp3
}
