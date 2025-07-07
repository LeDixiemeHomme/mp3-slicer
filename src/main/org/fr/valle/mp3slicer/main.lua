local utils = require("src.main.org.fr.valle.mp3slicer.utils.util")
local silence_detector = require("src.main.org.fr.valle.mp3slicer.detectors.silence_detector")
local splitter = require("src.main.org.fr.valle.mp3slicer.providers.splitter")
local Silence = require("src.main.org.fr.valle.mp3slicer.models.silence")

local input_mp3 = "src/main/ressources/data/input.mp3"
local input_txt = "src/main/ressources/input/starts-and-titles.txt"
local output_dir = "src/main/ressources/output"

local silence_db_min = -35
local silence_db_max = -30
local silence_db_step = 5

local silence_duration_min = 0.4
local silence_duration_max = 0.5
local silence_duration_step = 0.1

local song_duration = "00:36:37"

-- 1. Lire les starts et titres
local inputs = utils.read_inputs(input_txt)
local expected_silences = #inputs - 1
print("Nombre de silences attendus :", expected_silences)

-- 2. Boucle sur les valeurs de dB pour trouver la bonne config
local found = false
local matching_configs = {}
local found_silences = {}
for db = silence_db_min, silence_db_max, silence_db_step do
    print("Test avec seuil dB :", db)
    for duration = silence_duration_min, silence_duration_max, silence_duration_step do
        print("- Test avec duration s :", duration)
        local silences = silence_detector.detect_silences(input_mp3, db, duration)
        print("--- Nb de silences trouvé :", #silences)
        if #silences == expected_silences then
            print("----- FOUND !")
            for i, silence in ipairs(silences) do
                local startTime = silence.startTime
                local endTime = silence.endTime
                print("ite:", i, "startTime:", startTime, "endTime:", endTime)
                print(string.format("Silence %d: start=%s, end=%s", i, startTime, endTime))
            end
            table.insert(matching_configs, { db = db, duration = duration })
            found = true
            found_silences = silences
            break
        end
        if found then
            break
        end
    end
    if found then
        break
    end
end

if not found then
    print("Impossible de trouver une configuration qui matche le nombre de morceaux.")
    os.exit(1)
end

local titles = {}
for _, input in ipairs(inputs) do
    table.insert(titles, input.title)
end

local songs = Silence.make_songs(found_silences, titles, "00:00:00", song_duration)

-- 3. Découper la chanson
splitter.split_mp3(input_mp3, songs, output_dir)
