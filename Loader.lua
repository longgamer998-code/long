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

-- Hàm load module an toàn với fallback
local function safeLoad(moduleName, githubPath)
    local success, result = pcall(function()
        -- Thử load từ GitHub trước
        local url = "https://raw.githubusercontent.com/longgamer998-code/long/refs/heads/main/" .. githubPath
        return loadstring(game:HttpGet(url))()
    end)
    
    if success and result then
        print("✓ Đã tải " .. moduleName .. " từ GitHub")
        return result
    else
        -- Fallback: thử require từ local
        warn("⚠ Không thể tải " .. moduleName .. " từ GitHub, đang thử load local...")
        success, result = pcall(function()
            local modulePath = string.gsub(githubPath, "%.lua$", "")
            modulePath = string.gsub(modulePath, "/", ".")
            return require(script:WaitForChild(modulePath))
        end)
        
        if success and result then
            print("✓ Đã tải " .. moduleName .. " từ local")
            return result
        else
            error("❌ Không thể tải module: " .. moduleName)
        end
    end
end

-- Load Core Modules
local FarmCore = safeLoad("FarmCore", "FarmCore.lua")
local Teleport = safeLoad("Teleport", "Teleport.lua")
local Quest = safeLoad("Quest", "Quest.lua")

-- Load Config Modules
local Worlds = safeLoad("Worlds", "Worlds.lua")
local Monsters = safeLoad("Monsters", "Monsters.lua")
local Bosses = safeLoad("Bosses", "Bosses.lua")

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

-- Initialize systems (với kiểm tra nil)
if FarmCore and FarmCore.Init then
    FarmCore:Init()
else
    warn("⚠ FarmCore không có phương thức Init")
end

if Teleport and Teleport.Init then
    Teleport:Init()
else
    warn("⚠ Teleport không có phương thức Init")
end

if Quest and Quest.Init then
    Quest:Init()
else
    warn("⚠ Quest không có phương thức Init")
end

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

-- Load UI với fallback
local function loadUI()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/longgamer998-code/long/main/MainUI.lua"))()
    end)
    
    if not success then
        warn("⚠ Không thể tải UI từ GitHub, đang thử load local...")
        success, result = pcall(function()
            return require(script.UI.MainUI)
        end)
    end
    
    if not success then
        error("❌ Không thể tải UI Module")
    end
end

local success, errorMsg = pcall(loadUI)
if not success then
    warn("UI Load Error:", errorMsg)
end

print("╔══════════════════════════════════╗")
print("║   Switch Hub BF Premium Loaded   ║")
print("╚══════════════════════════════════╝")
