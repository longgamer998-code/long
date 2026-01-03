local FarmCore = {}
FarmCore.__index = FarmCore

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local Teleport = require(script.Parent.Teleport)
local Quest = require(script.Parent.Quest)
local Monsters = require(script.Parent.Parent.Config.Monsters)
local Bosses = require(script.Parent.Parent.Config.Bosses)

function FarmCore.new()
    local self = setmetatable({}, FarmCore)
    return self
end

function FarmCore:Init()
    print("FarmCore Initialized")
    
    -- Auto Farm Thread
    spawn(function()
        while task.wait() do
            if _G.Setting_table.Auto_Farm then
                self:AutoFarm()
            end
        end
    end)
    
    -- Auto Boss Thread
    spawn(function()
        while task.wait() do
            if _G.Setting_table.Auto_Farm_Boss then
                self:AutoBoss()
            end
        end
    end)
    
    -- Fast Attack Thread
    spawn(function()
        while task.wait(_G.Fast_Delay or 0.3) do
            if _G.Setting_table.FastAttack then
                self:FastAttack()
            end
        end
    end)
end

function FarmCore:AutoFarm()
    local Lv = player.Data.Level.Value
    local monsterData = Monsters:GetMonsterByLevel(Lv, _G.SelectMonster)
    
    if monsterData then
        -- Auto Quest
        if monsterData.NameQuest and monsterData.QuestLv then
            Quest:AcceptQuest(monsterData.NameQuest, monsterData.QuestLv)
        end
        
        -- Teleport to monster
        if monsterData.CFrameMon then
            Teleport:ToPosition(monsterData.CFrameMon)
        end
        
        -- Attack monster
        self:AttackTarget(monsterData.NameMon)
    end
end

function FarmCore:AutoBoss()
    if _G.SelectBoss then
        local bossData = Bosses:GetBoss(_G.SelectBoss)
        if bossData then
            if bossData.NameQuestBoss and bossData.QuestLvBoss then
                Quest:AcceptQuest(bossData.NameQuestBoss, bossData.QuestLvBoss)
            end
            
            if bossData.CFrameBoss then
                Teleport:ToPosition(bossData.CFrameBoss)
            end
            
            self:AttackTarget(bossData.NameBoss)
        end
    end
end

function FarmCore:AttackTarget(targetName)
    local target = self:FindTarget(targetName)
    if target and player.Character then
        local humanoid = player.Character.Humanoid
        local hrp = player.Character.HumanoidRootPart
        
        -- Face target
        hrp.CFrame = CFrame.new(hrp.Position, target.Position)
        
        -- Use skills if enabled
        if _G.Setting_table.SkillZ then
            self:UseSkill("Z")
        end
        if _G.Setting_table.Melee_A then
            self:UseSkill("X")
        end
        if _G.Setting_table.Defense_A then
            self:UseSkill("C")
        end
    end
end

function FarmCore:FindTarget(targetName)
    for _, npc in pairs(Workspace.NPCs:GetChildren()) do
        if string.find(npc.Name, targetName) then
            return npc.HumanoidRootPart
        end
    end
    for _, npc in pairs(Workspace.Enemies:GetChildren()) do
        if string.find(npc.Name, targetName) then
            return npc.HumanoidRootPart
        end
    end
    return nil
end

function FarmCore:FastAttack()
    pcall(function()
        local CombatFramework = require(ReplicatedStorage:WaitForChild("CombatFramework"))
        local Camera = Workspace.CurrentCamera
        
        if CombatFramework then
            local activeController = CombatFramework.activeController
            if activeController then
                for i = 1, 100 do
                    if activeController.timeToNextAttack <= 0 then
                        activeController.timeToNextAttack = 0
                        activeController.hitboxMagnitude = 50
                        activeController:attack()
                    end
                end
            end
        end
    end)
end

function FarmCore:UseSkill(key)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
end

function FarmCore:EquipWeapon(weaponName)
    local backpack = player.Backpack
    local character = player.Character
    
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool.Name == weaponName then
                character.Humanoid:EquipTool(tool)
                return true
            end
        end
    end
    return false
end

function FarmCore:GetBestWeapon()
    local backpack = player.Backpack
    local bestTool = nil
    local highestDmg = 0
    
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local damage = tool:FindFirstChild("Damage") and tool.Damage.Value or 0
                if damage > highestDmg then
                    highestDmg = damage
                    bestTool = tool.Name
                end
            end
        end
    end
    
    return bestTool or "Combat"
end

return FarmCore