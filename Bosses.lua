local Bosses = {}
Bosses.__index = Bosses

Bosses.DATABASE = {
    ["The Gorilla King [Lv. 25] [Boss]"] = {
        MsBoss = "The Gorilla King [Lv. 25] [Boss]",
        NameBoss = "The Gorilla King",
        NameQuestBoss = "JungleQuest",
        QuestLvBoss = 3,
        CFrameQBoss = CFrame.new(-1604.12012, 36.85211, 154.23732),
        CFrameBoss = CFrame.new(-1223.52808, 6.27936, -502.29266),
        World = "OLD_WORLD",
        RecommendedLevel = 25
    },
    ["Bobby [Lv. 55] [Boss]"] = {
        MsBoss = "Bobby [Lv. 55] [Boss]",
        NameBoss = "Bobby",
        NameQuestBoss = "BuggyQuest1",
        QuestLvBoss = 3,
        CFrameQBoss = CFrame.new(-1139.59717, 4.75205, 3825.16211),
        CFrameBoss = CFrame.new(-1147.65173, 32.59663, 4156.02588),
        World = "OLD_WORLD",
        RecommendedLevel = 55
    },
    ["Yeti [Lv. 110] [Boss]"] = {
        MsBoss = "Yeti [Lv. 110] [Boss]",
        NameBoss = "Yeti",
        NameQuestBoss = "SnowQuest",
        QuestLvBoss = 3,
        CFrameQBoss = CFrame.new(1384.90247, 87.30783, -1296.68250),
        CFrameBoss = CFrame.new(1221.73560, 138.04691, -1488.84082),
        World = "OLD_WORLD",
        RecommendedLevel = 110
    },
    ["Vice Admiral [Lv. 130] [Boss]"] = {
        MsBoss = "Vice Admiral [Lv. 130] [Boss]",
        NameBoss = "Vice Admiral",
        NameQuestBoss = "MarineQuest2",
        QuestLvBoss = 2,
        CFrameQBoss = CFrame.new(-5035.42285, 28.65204, 4324.50293),
        CFrameBoss = CFrame.new(-5078.45898, 99.65207, 4402.16650),
        World = "OLD_WORLD",
        RecommendedLevel = 130
    },
    ["Diamond [Lv. 750] [Boss]"] = {
        MsBoss = "Diamond [Lv. 750] [Boss]",
        NameBoss = "Diamond",
        NameQuestBoss = "Area1Quest",
        QuestLvBoss = 3,
        CFrameQBoss = CFrame.new(-424.08008, 73.00558, 1836.91589),
        CFrameBoss = CFrame.new(-1736.26587, 198.62773, -236.41286),
        World = "NEW_WORLD",
        RecommendedLevel = 750
    },
    ["Jeremy [Lv. 850] [Boss]"] = {
        MsBoss = "Jeremy [Lv. 850] [Boss]",
        NameBoss = "Jeremy",
        NameQuestBoss = "Area2Quest",
        QuestLvBoss = 3,
        CFrameQBoss = CFrame.new(632.69861, 73.10559, 918.66632),
        CFrameBoss = CFrame.new(2203.76953, 448.96603, 752.73108),
        World = "NEW_WORLD",
        RecommendedLevel = 850
    },
    ["Stone [Lv. 1550] [Boss]"] = {
        MsBoss = "Stone [Lv. 1550] [Boss]",
        NameBoss = "Stone",
        NameQuestBoss = "PiratePortQuest",
        QuestLvBoss = 3,
        CFrameQBoss = CFrame.new(-290, 44, 5577),
        CFrameBoss = CFrame.new(-1085, 40, 6779),
        World = "THREE_WORLD",
        RecommendedLevel = 1550
    },
    ["Island Empress [Lv. 1675] [Boss]"] = {
        MsBoss = "Island Empress [Lv. 1675] [Boss]",
        NameBoss = "Island Empress",
        NameQuestBoss = "AmazonQuest2",
        QuestLvBoss = 3,
        CFrameQBoss = CFrame.new(5443, 602, 752),
        CFrameBoss = CFrame.new(5659, 602, 244),
        World = "THREE_WORLD",
        RecommendedLevel = 1675
    },
    ["Soul Reaper [Lv. 2100] [Raid Boss]"] = {
        MsBoss = "Soul Reaper [Lv. 2100] [Raid Boss]",
        NameBoss = "Soul Reaper",
        CFrameBoss = CFrame.new(-9515.62109, 315.92554, 6691.12012),
        World = "THREE_WORLD",
        RecommendedLevel = 2100,
        IsRaid = true
    }
}

function Bosses.new()
    local self = setmetatable({}, Bosses)
    return self
end

function Bosses:GetBoss(bossName)
    return self.DATABASE[bossName]
end

function Bosses:GetAllBosses()
    local bossList = {}
    for bossName, _ in pairs(self.DATABASE) do
        table.insert(bossList, bossName)
    end
    table.sort(bossList)
    return bossList
end

function Bosses:GetBossesByWorld(worldName)
    local filteredBosses = {}
    
    for bossName, bossData in pairs(self.DATABASE) do
        if bossData.World == worldName then
            table.insert(filteredBosses, bossName)
        end
    end
    
    table.sort(filteredBosses)
    return filteredBosses
end

function Bosses:GetRaidBosses()
    local raidBosses = {}
    
    for bossName, bossData in pairs(self.DATABASE) do
        if bossData.IsRaid then
            table.insert(raidBosses, bossName)
        end
    end
    
    table.sort(raidBosses)
    return raidBosses
end

function Bosses:GetRecommendedBoss(playerLevel)
    local recommended = nil
    local closestDiff = math.huge
    
    for bossName, bossData in pairs(self.DATABASE) do
        if not bossData.IsRaid then
            local diff = math.abs(bossData.RecommendedLevel - playerLevel)
            if diff < closestDiff then
                closestDiff = diff
                recommended = bossName
            end
        end
    end
    
    return recommended
end

function Bosses:CanFightBoss(bossName, playerLevel)
    local bossData = self:GetBoss(bossName)
    if not bossData then return false end
    
    if bossData.IsRaid then
        return playerLevel >= (bossData.RecommendedLevel or 1000)
    end
    
    return playerLevel >= (bossData.RecommendedLevel - 50)
end

return Bosses