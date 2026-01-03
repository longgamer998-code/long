local Worlds = {}
Worlds.__index = Worlds

Worlds.WORLDS = {
    OLD_WORLD = {
        PlaceId = 2753915549,
        Name = "First Sea",
        Bosses = {"The Gorilla King", "Bobby", "Yeti", "Vice Admiral"},
        RaidBosses = {"Greybeard"}
    },
    NEW_WORLD = {
        PlaceId = 4442272183,
        Name = "Second Sea",
        Bosses = {"Diamond", "Jeremy", "Fajita", "Smoke Admiral"},
        RaidBosses = {"Cursed Captain", "Darkbeard", "Order"}
    },
    THREE_WORLD = {
        PlaceId = 7449423635,
        Name = "Third Sea",
        Bosses = {"Stone", "Island Empress", "Kilo Admiral", "Beautiful Pirate"},
        RaidBosses = {"rip_indra True Form", "Soul Reaper"}
    }
}

function Worlds.new()
    local self = setmetatable({}, Worlds)
    return self
end

function Worlds:GetCurrentWorld()
    local placeId = game.PlaceId
    
    for worldName, worldData in pairs(self.WORLDS) do
        if placeId == worldData.PlaceId then
            return worldName, worldData
        end
    end
    
    return "UNKNOWN", {Name = "Unknown World"}
end

function Worlds:IsOldWorld()
    return game.PlaceId == self.WORLDS.OLD_WORLD.PlaceId
end

function Worlds:IsNewWorld()
    return game.PlaceId == self.WORLDS.NEW_WORLD.PlaceId
end

function Worlds:IsThreeWorld()
    return game.PlaceId == self.WORLDS.THREE_WORLD.PlaceId
end

function Worlds:GetWorldName()
    local worldName, worldData = self:GetCurrentWorld()
    return worldData.Name
end

function Worlds:CanAccessWorld(targetWorld)
    local playerLevel = game.Players.LocalPlayer.Data.Level.Value
    
    if targetWorld == "NEW_WORLD" then
        return playerLevel >= 700
    elseif targetWorld == "THREE_WORLD" then
        return playerLevel >= 1500
    end
    
    return true
end

function Worlds:GetTeleportCFrame(worldName)
    local teleportCFrames = {
        OLD_WORLD = {
            MarineStart = CFrame.new(-2826.72998046875, 43.75429153442383, 3058.228271484375),
            PirateStart = CFrame.new(2821.66943359375, 44.040767669677734, -196.16729736328125)
        },
        NEW_WORLD = {
            Castle = CFrame.new(-5539.046875, 314.515380859375, -2961.635009765625),
            Cafe = CFrame.new(-382.2384033203125, 73.0458984375, 297.3563537597656)
        },
        THREE_WORLD = {
            Port = CFrame.new(-1249.7723388671875, 12.170019149780273, 3342.0966796875),
            Mansion = CFrame.new(-12471.052734375, 374.8586120605469, -7551.59814453125)
        }
    }
    
    return teleportCFrames[worldName]
end

return Worlds