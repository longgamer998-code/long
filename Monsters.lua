local Monsters = {}
Monsters.__index = Monsters

-- Monster database organized by world and level range
Monsters.DATABASE = {
    OLD_WORLD = {
        {
            LevelRange = {1, 9},
            Ms = "Bandit [Lv. 5]",
            NameQuest = "BanditQuest1",
            QuestLv = 1,
            NameMon = "Bandit",
            CFrameQ = CFrame.new(1060.93835, 16.45507, 1547.78418),
            CFrameMon = CFrame.new(1038.55334, 41.29625, 1576.50989)
        },
        {
            LevelRange = {10, 14},
            Ms = "Monkey [Lv. 14]",
            NameQuest = "JungleQuest",
            QuestLv = 1,
            NameMon = "Monkey",
            CFrameQ = CFrame.new(-1601.65540, 36.85213, 153.38809),
            CFrameMon = CFrame.new(-1448.14465, 50.85199, 63.60719)
        },
        {
            LevelRange = {15, 29},
            Ms = "Gorilla [Lv. 20]",
            NameQuest = "JungleQuest",
            QuestLv = 2,
            NameMon = "Gorilla",
            CFrameQ = CFrame.new(-1601.65540, 36.85213, 153.38809),
            CFrameMon = CFrame.new(-1142.64880, 40.46235, -515.39227)
        },
        {
            LevelRange = {30, 39},
            Ms = "Pirate [Lv. 35]",
            NameQuest = "BuggyQuest1",
            QuestLv = 1,
            NameMon = "Pirate",
            CFrameQ = CFrame.new(-1140.17615, 4.75205, 3827.40576),
            CFrameMon = CFrame.new(-1201.08813, 40.62894, 3857.59668)
        },
        -- Add more monsters as needed
    },
    
    NEW_WORLD = {
        {
            LevelRange = {700, 724},
            Ms = "Raider [Lv. 700]",
            NameQuest = "Area1Quest",
            QuestLv = 1,
            NameMon = "Raider",
            CFrameQ = CFrame.new(-427.72568, 72.99635, 1835.94263),
            CFrameMon = CFrame.new(68.87457, 93.63564, 2429.67529)
        },
        {
            LevelRange = {725, 774},
            Ms = "Mercenary [Lv. 725]",
            NameQuest = "Area1Quest",
            QuestLv = 2,
            NameMon = "Mercenary",
            CFrameQ = CFrame.new(-427.72568, 72.99635, 1835.94263),
            CFrameMon = CFrame.new(-864.85010, 122.47105, 1453.15051)
        },
        -- Add more monsters as needed
    },
    
    THREE_WORLD = {
        {
            LevelRange = {1500, 1524},
            Ms = "Pirate Millionaire [Lv. 1500]",
            NameQuest = "PiratePortQuest",
            QuestLv = 1,
            NameMon = "Pirate Millionaire",
            CFrameQ = CFrame.new(-289.61752, 43.81901, 5580.09033),
            CFrameMon = CFrame.new(-435.68109, 189.69867, 5551.07568)
        },
        -- Add more monsters as needed
    }
}

function Monsters.new()
    local self = setmetatable({}, Monsters)
    return self
end

function Monsters:GetMonsterByLevel(level, specificMonster)
    local Worlds = require(script.Parent.Worlds)
    local worlds = Worlds.new()
    local worldName, worldData = worlds:GetCurrentWorld()
    
    -- If specific monster is selected
    if specificMonster and specificMonster ~= "" then
        return self:FindMonsterByName(specificMonster, worldName)
    end
    
    -- Get monsters for current world
    local worldMonsters = self.DATABASE[worldName] or {}
    
    -- Find monster by level range
    for _, monster in pairs(worldMonsters) do
        if level >= monster.LevelRange[1] and level <= monster.LevelRange[2] then
            return monster
        end
    end
    
    -- Return highest level monster if none found
    if #worldMonsters > 0 then
        return worldMonsters[#worldMonsters]
    end
    
    return nil
end

function Monsters:FindMonsterByName(monsterName, worldName)
    if not worldName then
        local Worlds = require(script.Parent.Worlds)
        local worlds = Worlds.new()
        worldName, _ = worlds:GetCurrentWorld()
    end
    
    local worldMonsters = self.DATABASE[worldName] or {}
    
    for _, monster in pairs(worldMonsters) do
        if string.find(monster.Ms, monsterName) then
            return monster
        end
    end
    
    -- Search in all worlds
    for _, worldMonsters in pairs(self.DATABASE) do
        for _, monster in pairs(worldMonsters) do
            if string.find(monster.Ms, monsterName) then
                return monster
            end
        end
    end
    
    return nil
end

function Monsters:GetAllMonsters(worldName)
    if worldName then
        return self.DATABASE[worldName] or {}
    else
        local allMonsters = {}
        for _, worldMonsters in pairs(self.DATABASE) do
            for _, monster in pairs(worldMonsters) do
                table.insert(allMonsters, monster.Ms)
            end
        end
        return allMonsters
    end
end

function Monsters:GetMonsterListForUI()
    local monsterList = {}
    
    for worldName, monsters in pairs(self.DATABASE) do
        for _, monster in pairs(monsters) do
            table.insert(monsterList, monster.Ms)
        end
    end
    
    return monsterList
end

return Monsters