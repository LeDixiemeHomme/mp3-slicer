local Timecode = require("src.main.org.fr.valle.mp3slicer.models.timecode")

describe("Timecode.fromCmdFormat", function()
    it("convertit le temps en nombre", function()
        assert.are.same(Timecode.fromCmdFormat("2"), Timecode.new(0, 0, 2))
    end)

    it("convertit le temps en nombre", function()
        assert.are.same(Timecode.fromCmdFormat("42"), Timecode.new(0, 0, 42))
    end)

    it("convertit le temps MM:SS en secondes", function()
        assert.are.same(Timecode.fromCmdFormat("02:30"), Timecode.new(0, 2, 30))
    end)

    it("convertit le temps MM:SS en secondes", function()
        assert.are.same(Timecode.fromCmdFormat("2:30"), Timecode.new(0, 2, 30))
    end)

    it("convertit le temps HH:MM:SS en secondes", function()
        assert.are.same(Timecode.fromCmdFormat("01:02:03"), Timecode.new(1, 2, 3))
    end)

    it("convertit le temps HH:MM:SS en secondes", function()
        assert.are.same(Timecode.fromCmdFormat("1:02:3"), Timecode.new(1, 2, 3))
    end)
end)

describe("Timecode.fromSeconds", function()
    it("convertit les secondes en format HH:MM:SS", function()
        assert.are.same(Timecode.fromSeconds(3661), Timecode.fromCmdFormat("01:01:01"))
    end)

    it("convertit les secondes en format MM:SS", function()
        assert.are.same(Timecode.fromSeconds(125), Timecode.fromCmdFormat("00:02:05"))
    end)

    it("gère les secondes inférieures à 60", function()
        assert.are.same(Timecode.fromSeconds(45), Timecode.fromCmdFormat("00:00:45"))
    end)

    it("gère les secondes cas concret", function()
        assert.are.same(Timecode.fromSeconds(147.572494), Timecode.fromCmdFormat("00:02:27"))
    end)
end)

describe("Timecode:to_seconds", function()
    it("convertit le format HH:MM:SS en secondes", function()
        assert.are.equal(Timecode.new(1, 1, 1):to_seconds(), 3661)
    end)

    it("convertit le format MM:SS en secondes", function()
        assert.are.equal(Timecode.new(0, 2, 5):to_seconds(), 125)
    end)

    it("gère les secondes inférieures à 60", function()
        assert.are.equal(Timecode.new(0, 0, 45):to_seconds(), 45)
    end)

    it("gère les secondes cas concret", function()
        assert.are.equal(Timecode.new(0, 2, 27):to_seconds(), 147)
    end)
end)

describe("Timecode:to_string", function()
    it("formatte le temps en HH:MM:SS", function()
        assert.are.equal(Timecode.new(1, 1, 1):to_string(), "Timecode: 01:01:01")
    end)

    it("formatte le temps en MM:SS", function()
        assert.are.equal(Timecode.new(0, 2, 5):to_string(), "Timecode: 00:02:05")
    end)

    it("gère les secondes inférieures à 60", function()
        assert.are.equal(Timecode.new(0, 0, 45):to_string(), "Timecode: 00:00:45")
    end)

    it("gère les secondes cas concret", function()
        assert.are.equal(Timecode.new(0, 2, 27):to_string(), "Timecode: 00:02:27")
    end)
end)

describe("Timecode.to_cmd_format", function()
    it("formatte le temps en HH:MM:SS", function()
        assert.are.equal(Timecode.new(1, 1, 1):to_cmd_format(), "01:01:01")
    end)    

    it("formatte le temps en MM:SS", function()
        assert.are.equal(Timecode.new(0, 2, 5):to_cmd_format(), "00:02:05")
    end)    

    it("gère les secondes inférieures à 60", function()
        assert.are.equal(Timecode.new(0, 0, 45):to_cmd_format(), "00:00:45")
    end)
end)