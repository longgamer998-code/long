--[[
    Switch Hub BF Premium - Loader
    Tổ chức lại từ Xenon.lua
]]

if not game:IsLoaded() then 
    repeat game.Loaded:Wait()
    until game:IsLoaded() 
end

repeat wait(1)
    pcall(function()
        if game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam") then
            if game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Visible == true then
                if _G.Team == "Marines" then
                    for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.MouseButton1Click)) do
                        v.Function()
                    end
                else
                    for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.MouseButton1Click)) do
                        v.Function()
                    end
                end
            end
        end
    end)
until game.Players.LocalPlayer.Neutral == false

if _G.Fast_Delay == nil then
    _G.Fast_Delay = 0.3
end

-- Anti AFK
local VirtualUser = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

spawn(function()
    while wait(3) do
        game:GetService'VirtualUser':CaptureController()
    end
end)

-- Load Core Modules
local FarmCore = require(script.Core.FarmCore)
local Teleport = require(script.Core.Teleport)
local Quest = require(script.Core.Quest)

-- Load Config Modules
local Worlds = require(script.Config.Worlds)
local Monsters = require(script.Config.Monsters)
local Bosses = require(script.Config.Bosses)

-- Global Settings
_G.Color = Color3.fromRGB(68, 202, 186)
_G.Setting_table = {
    Auto_Farm = false,
    FastAttack = true,
    Auto_Buso = true,
    Auto_Ken = true,
    Show_Damage = true,
    NoClip = true,
    Save_Member = true,
    Melee_A = true,
    Defense_A = true,
    SkillZ = true,
    Rejoin = true,
    Anti_AFK = true,
    K_MAX = 50,
    Chest_Lock = 50,
    Delay_C = 15
}

-- Check current world
local placeId = game.PlaceId
if placeId == 2753915549 then
    _G.Old_World = true
elseif placeId == 4442272183 then
    _G.New_World = true
elseif placeId == 7449423635 then
    _G.Three_World = true
end

-- Initialize systems
FarmCore:Init()
Teleport:Init()
Quest:Init()

-- Rejoin system
spawn(function()
    while true do wait()
        getgenv().rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(Kick)
            if not _G.TP_Ser and _G.Rejoin then
                if Kick.Name == 'ErrorPrompt' and Kick:FindFirstChild('MessageArea') and Kick.MessageArea:FindFirstChild("ErrorFrame") then
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                    wait(50)
                end
            end
        end)
    end
end)

-- Load UI
local success, errorMsg = pcall(function()
    require(script.UI.MainUI)
end)

if not success then
    warn("UI Load Error:", errorMsg)
end

print("╔══════════════════════════════════╗")
print("║   Switch Hub BF Premium Loaded   ║")
print("╚══════════════════════════════════╝")
