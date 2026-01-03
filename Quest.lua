local Quest = {}
Quest.__index = Quest

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

function Quest.new()
    local self = setmetatable({}, Quest)
    return self
end

function Quest:Init()
    print("Quest System Initialized")
end

function Quest:AcceptQuest(questName, questLevel)
    if not questName or not questLevel then return end
    
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questName, questLevel)
    end)
end

function Quest:AbandonQuest()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
    end)
end

function Quest:CheckQuestProgress()
    local questProgress = nil
    
    pcall(function()
        questProgress = ReplicatedStorage.Remotes.CommF_:InvokeServer("GetQuest")
    end)
    
    return questProgress
end

function Quest:IsQuestActive(questName)
    local progress = self:CheckQuestProgress()
    if progress then
        return progress.Name == questName
    end
    return false
end

function Quest:CompleteQuest()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("PlayerHunter")
    end)
end

function Quest:GetQuestReward(questName)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("GetQuestReward", questName)
    end)
end

function Quest:RedeemCode(code)
    pcall(function()
        ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
    end)
end

-- Common codes
Quest.Codes = {
    "SUB2GAMERROBOT_EXP1",
    "SUB2NOOBMASTER123",
    "Sub2Daigrock",
    "Axiore",
    "TantaiGaming",
    "STRAWHATMAINE",
    "SUB2OFFICIALNOOBIE",
    "SUB2UNCLEKIZARU",
    "Sub2CaptainMaui",
    "Enyu_is_Pro"
}

function Quest:RedeemAllCodes()
    for _, code in pairs(self.Codes) do
        self:RedeemCode(code)
        task.wait(1)
    end
end

return Quest