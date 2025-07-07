local Silence = require("src.main.org.fr.valle.mp3slicer.models.silence")

describe("silence.make_songs", function()
    it("should create songs from silences with titles", function()
        local silences = {
            Silence.new(30, 31),
            Silence.new(60, 61),
            Silence.new(120, 121)
        }
        local titles = {"Song A", "Song B", "Song C", "Song D"}
        local globalStartTime = 0
        local globalEndTime = 180

        local songs = Silence.make_songs(silences, titles, globalStartTime, globalEndTime)

        assert.are.equal(#songs, 4)
        assert.are.equal(songs[1].startTime, 0)
        assert.are.equal(songs[1].endTime, 30)
        assert.are.equal(songs[1].title, "Song A")
        
        assert.are.equal(songs[2].startTime, 31)
        assert.are.equal(songs[2].endTime, 60)
        assert.are.equal(songs[2].title, "Song B")
        
        assert.are.equal(songs[3].startTime, 61)
        assert.are.equal(songs[3].endTime, 120)
        assert.are.equal(songs[3].title, "Song C")
        
        assert.are.equal(songs[4].startTime, 121)
        assert.are.equal(songs[4].endTime, 180)
        assert.are.equal(songs[4].title, "Song D")
    end)

    it("should handle no silences", function()
        local silences = {}
        local titles = {"Global Song"}
        local globalStartTime = 0
        local globalEndTime = 180

        local songs = Silence.make_songs(silences, titles, globalStartTime, globalEndTime)

        assert.are.equal(#songs, 1)
        assert.are.equal(songs[1].startTime, 0)
        assert.are.equal(songs[1].endTime, 180)
        assert.are.equal(songs[1].title, "Global Song")
    end)
end)