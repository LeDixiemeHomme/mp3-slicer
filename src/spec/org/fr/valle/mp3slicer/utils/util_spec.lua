local util = require("src.main.org.fr.valle.mp3slicer.utils.util")

describe("util.time_to_seconds", function()
    it("convertit le temps MM:SS en secondes", function()
        assert.are.equal(util.time_to_seconds("02:30"), 150)
    end)

    it("convertit le temps HH:MM:SS en secondes", function()
        assert.are.equal(util.time_to_seconds("01:02:03"), 3723)
    end)

    it("convertit le temps en nombre", function()
        assert.are.equal(util.time_to_seconds("42"), 42)
    end)
end)

describe("util.read_starts_and_titles", function()
    it("lit les starts et titres depuis un fichier", function()
        -- Crée un fichier temporaire
        local f = io.open("test.txt", "w")
        f:write("00:00 Song One\n02:30 Song Two\n")
        f:close()
        local songs = util.read_starts_and_titles("test.txt")
        assert.are.equal(#songs, 2)
        assert.are.equal(songs[1].title, "Song One")
        assert.are.equal(songs[2].startTime, 150)
        os.remove("test.txt")
    end)
end)

describe("util.fromSeconds", function()
    it("convertit les secondes en format HH:MM:SS", function()
        assert.are.equal(util.fromSeconds(3661), "01:01:01")
    end)

    it("convertit les secondes en format MM:SS", function()
        assert.are.equal(util.fromSeconds(125), "00:02:05")
    end)

    it("gère les secondes inférieures à 60", function()
        assert.are.equal(util.fromSeconds(45), "00:00:45")
    end)

    it("gère les secondes cas concret", function()
        assert.are.equal(util.fromSeconds(147.572494), "00:02:27")
    end)
end)
