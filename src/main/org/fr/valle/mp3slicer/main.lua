local input_util = require("src.main.org.fr.valle.mp3slicer.utils.input_util")
local silence_detector = require("src.main.org.fr.valle.mp3slicer.detectors.silence_detector")
local splitter = require("src.main.org.fr.valle.mp3slicer.providers.splitter")
local Silence = require("src.main.org.fr.valle.mp3slicer.models.silence")

local input_mp3 = "src/main/ressources/data/input Swordlender - Where Heathens Roam.mp3"
local input_txt = "src/main/ressources/input/starts-and-titles Swordlender - Where Heathens Roam.txt"
local song_duration = "00:36:37"
local output_dir = "src/main/ressources/output Swordlender - Where Heathens Roam"
local db = { min = -35, max = -30, step = 5 }
local duration = { min = 0.4, max = 0.5, step = 0.1 }

-- local input_mp3 = "src/main/ressources/data/input Swordlender - Struggles of a King.mp3"
-- local input_txt = "src/main/ressources/input/starts-and-titles Swordlender - Struggles of a King.txt"
-- local song_duration = "00:36:12"
-- local output_dir = "src/main/ressources/output Swordlender - Struggles of a King"
-- local db = { min = -45, max = -30, step = 5 }
-- local duration = { min = 0.1, max = 0.5, step = 0.1 }
-- local db = { min = -35, max = -30, step = 5 }
-- local duration = { min = 0.5, max = 0.5, step = 0.1 }

-- 1. Lire les starts et titres
local inputs = input_util.read_inputs(input_txt)

local plausible_silences = silence_detector.detect_plausible_silences(input_mp3, inputs, db, duration)

local titles = {}
for _, input in ipairs(inputs) do
    table.insert(titles, input.title)
end

local songs = Silence.make_songs(plausible_silences, titles, "00:00:00", song_duration)

-- 3. Découper la chanson
splitter.split_mp3(input_mp3, songs, output_dir, song_duration, "00:00:30")
