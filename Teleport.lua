local Teleport = {}
Teleport.__index = Teleport

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

function Teleport.new()
    local self = setmetatable({}, Teleport)
    return self
end

function Teleport:Init()
    print("Teleport System Initialized")
    _G.Stop_Tween = false
end

function Teleport:ToPosition(cframe, customSpeed)
    if not player.Character or not player.Character.HumanoidRootPart then
        return
    end
    
    if _G.Stop_Tween then
        return
    end
    
    local Distance = (cframe.Position - player.Character.HumanoidRootPart.Position).Magnitude
    local Speed = customSpeed or self:CalculateSpeed(Distance)
    
    if Distance > 2000 then
        self:SpecialTeleport(cframe)
        return
    end
    
    local tweenInfo = TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(player.Character.HumanoidRootPart, tweenInfo, {CFrame = cframe})
    
    tween:Play()
    
    -- Wait for completion or stop
    spawn(function()
        while tween.PlaybackState == Enum.PlaybackState.Playing do
            if _G.Stop_Tween then
                tween:Cancel()
                break
            end
            task.wait()
        end
    end)
end

function Teleport:ToMonster(monsterData)
    if monsterData and monsterData.CFrameMon then
        self:ToPosition(monsterData.CFrameMon)
    end
end

function Teleport:ToBoss(bossData)
    if bossData and bossData.CFrameBoss then
        self:ToPosition(bossData.CFrameBoss)
    end
end

function Teleport:ToQuest(questData)
    if questData and questData.CFrameQ then
        self:ToPosition(questData.CFrameQ)
    end
end

function Teleport:CalculateSpeed(distance)
    if distance < 250 then
        return 5000
    elseif distance < 500 then
        return 650
    elseif distance < 1000 then
        return 350
    else
        return 250
    end
end

function Teleport:SpecialTeleport(cframe)
    -- For long distance teleport (islands)
    _G.Stop_Tween = true
    player.Character.Humanoid:ChangeState(15) -- Dead state
    
    repeat task.wait(0.5)
        player.Character.HumanoidRootPart.CFrame = cframe
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
    until (cframe.Position - player.Character.HumanoidRootPart.Position).Magnitude < 1500
    
    task.wait(0.5)
    _G.Stop_Tween = false
end

function Teleport:RequestEntrance(position)
    ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", position)
end

-- Teleport to specific locations
function Teleport:ToSafeZone()
    local safeCFrame = CFrame.new(0, 100, 0)
    self:ToPosition(safeCFrame, 1000)
end

function Teleport:ToSpawn()
    local spawnPoint = player:GetJoinData().SpawnLocation
    if spawnPoint then
        self:ToPosition(spawnPoint.CFrame)
    end
end

function Teleport:Stop()
    _G.Stop_Tween = true
end

function Teleport:Resume()
    _G.Stop_Tween = false
end

return Teleport