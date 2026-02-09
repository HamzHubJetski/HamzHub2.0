-- HamzHub v1.0 | Made by Grok for Blox Fruits | Feb 2026 | No Key | Mobile Friendly
-- Features: Auto Fruit Farm/Sniper, Fly, Speed, Noclip, ESP, Teleport, Auto Raid/Boss, Auto Stats

getgenv().HamzConfig = {
    AutoFarmFruit = false,
    FlyEnabled = false,
    NoclipEnabled = false,
    ESPFruits = false,
    ESPPlayers = false,
    WalkSpeed = 16,
    JumpPower = 50
}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local SS = game:GetService("StarterGui")
local TS = game:GetService("TweenService")
local RunS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Remotes = RS:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🅗🅐🅜🅩🅗🅤🅑 v1.0 - Blox Fruits OP Hub", "DarkTheme")

-- // Fly Function
local flying = false
local bg, bv
local function startFly()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    bg = Instance.new("BodyGyro", root)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0, 0.1, 0)
    flying = true
    spawn(function()
        repeat
            RunS.Heartbeat:Wait()
            if flying and root then
                bg.CFrame = WS.CurrentCamera.CFrame * CFrame.new(0, 0, -HamzConfig.FlySpeed or 50)
            end
        until not flying
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end)
end

-- // Noclip Function
local noclip = false
spawn(function()
    RunS.Stepped:Connect(function()
        if noclip and LP.Character then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

-- // ESP Function
local ESP = {}
local function createESP(part, text, color)
    local billboard = Instance.new("BillboardGui", part)
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    ESP[part] = billboard
end

local function toggleESP(fruits)
    for _, obj in pairs(WS:GetDescendants()) do
        if fruits and obj.Name:find("Fruit") or obj:IsA("Tool") then
            if not ESP[obj] then
                createESP(obj.Parent, obj.Name, Color3.new(0,1,0))
            end
        elseif not fruits and obj.Parent == WS and obj.Parent:FindFirstChild("Humanoid") then
            if not ESP[obj.Parent] then
                createESP(obj.Parent.Head, obj.Parent.Name, Color3.new(1,0,0))
            end
        end
    end
end

-- // Teleport CFrames (Popular Islands/Bosses)
local TPs = {
    ["Middle Town"] = CFrame.new(-303.09283447266, 73.001205444336, 5563.0400390625),
    ["Usopp Island"] = CFrame.new(4862.74121, 5.67929547, 743.951721),
    ["Marine Fortress"] = CFrame.new(3795.045898, 44.5084763, 842.904846),
    ["Fountain City"] = CFrame.new(5079.876953, 8.34195423, 1940.30017),
    ["Skytown"] = CFrame.new(-7882.31787, 5626.95166, -167.930847),
    ["Kingdom of Rose"] = CFrame.new(-1255.39587, 16.1381092, 3536.16992),
    ["Green Zone"] = CFrame.new(5885.90723, 81.3594971, 1810.0199),
    ["Port Town"] = CFrame.new(-303.348297, 73.0191803, 5564.98633),
    ["Hydra Island"] = CFrame.new(5447.13086, 601.982361, 751.130432),
    ["Castle on the Sea"] = CFrame.new(-5076.42041, 299.359955, -6939.31543),
    ["Sea 3 Start"] = CFrame.new(-5059.29639, 558.151917, -5991.4165),
    ["Mansion"] = CFrame.new(-12444.4873, 332.717041, -7671.46533),
    ["Yonko Arena"] = CFrame.new(-1320.72998, 16.0993671, 3735.32227),
    ["Snow Mountain"] = CFrame.new(1342.52771, 454.526825, 453.548645),
    ["Hot and Cold"] = CFrame.new(5711.46191, 1562.24695, -2568.5498),
    ["Cursed Ship"] = CFrame.new(916.726013, 143.138199, 1219.4397),
    ["Temple of Time"] = CFrame.new(2961.7749, 1455.13232, -33.3288231),
    ["Tiki Outpost"] = CFrame.new(-1609.2356, 36.8474998, 152.40364),
    ["Dark Arena"] = CFrame.new(5282.76221, 610.004944, 137.510529),
    ["Sea Beast"] = CFrame.new(-6409.89893, 101.595039, -5851.4082)
}

-- // Tabs
local FarmTab = Window:NewTab("🌴 Farm")
local FarmSec = FarmTab:NewSection("Auto Farm")

FarmSec:NewToggle("Auto Fruit Sniper/Farm", "Auto TP & Store Fruits", function(v)
    HamzConfig.AutoFarmFruit = v
    spawn(function()
        while HamzConfig.AutoFarmFruit do
            for _, obj in pairs(WS:GetChildren()) do
                if obj:IsA("Model") and (obj.Name:find("Fruit") or table.find({"Mammoth","Leopard"}, obj.Name)) then
                    TPFunction(obj.PrimaryPart.CFrame * CFrame.new(0,10,0))
                    CommF_:InvokeServer("StoreFruit", obj.Name, obj)
                    wait(0.5)
                end
            end
            wait(1)
        end
    end)
end)

FarmSec:NewToggle("Auto Raid", "Auto Start & Farm Raid", function(v)
    if v then
        CommF_:InvokeServer("RaidsNpc", "Select", "Mole")
        wait(2)
        CommF_:InvokeServer("Raid", "start")
    end
end)

local CombatTab = Window:NewTab("⚔️ Combat")
local CombatSec = CombatTab:NewSection("Combat")

CombatSec:NewToggle("Auto Boss", "Farm Bosses", function(v)
    spawn(function()
        while v do
            CommF_:InvokeServer("Buso")
            for i,v in pairs(WS.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    TPFunction(v.HumanoidRootPart.CFrame * CFrame.new(0,5,0))
                    CommF_:InvokeServer("Buso")
                end
            end
            wait(1)
        end
    end)
end)

local PlayerTab = Window:NewTab("👤 Player")
local PlayerSec = PlayerTab:NewSection("Mods")

PlayerSec:NewSlider("Walk Speed", "16-500", 500, function(s)
    HamzConfig.WalkSpeed = s
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = s
    end
end)

PlayerSec:NewSlider("Jump Power", "50-500", 500, function(s)
    HamzConfig.JumpPower = s
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = s
    end
end)

PlayerSec:NewToggle("Fly", "Infinite Fly (Camera)", function(v)
    HamzConfig.FlyEnabled = v
    if v then
        startFly()
    else
        flying = false
    end
end)

PlayerSec:NewToggle("Noclip", "No Collision", function(v)
    noclip = v
end)

local VisualTab = Window:NewTab("👀 Visuals")
local VisualSec = VisualTab:NewSection("ESP")

VisualSec:NewToggle("ESP Fruits", "Highlight Fruits", function(v)
    HamzConfig.ESPFruits = v
    toggleESP(true)
end)

VisualSec:NewToggle("ESP Players", "Highlight Players", function(v)
    HamzConfig.ESPPlayers = v
    toggleESP(false)
end)

local TeleTab = Window:NewTab("📍 Teleport")
local TeleSec = TeleTab:NewSection("Islands/Boss")

local Dropdown = TeleSec:NewDropdown("Select Place", "Teleport", {"Middle Town"}, function(current)
    if TPs[current] then
        TPFunction(TPs[current])
    end
end)

local function TPFunction(cf)
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = cf
    end
end

-- // Auto Stats (Max Melee/Defense/Gun/Sword)
local StatsTab = Window:NewTab("📊 Stats")
local StatsSec = StatsTab:NewSection("Auto Max Stats")

StatsSec:NewButton("Max Melee", "Add Points to Melee", function()
    CommF_:InvokeServer("AddPoint", "Melee", 100)
end)
StatsSec:NewButton("Max Defense", "Add Points to Defense", function()
    CommF_:InvokeServer("AddPoint", "Defense", 100)
end)
StatsSec:NewButton("Max Gun", "Add Points to Gun", function()
    CommF_:InvokeServer("AddPoint", "Gun", 100)
end)
StatsSec:NewButton("Max Sword", "Add Points to Sword", function()
    CommF_:InvokeServer("AddPoint", "Sword", 100)
end)

-- // Rejoin on death or something, but basic done

-- // Update Walk/Jump on spawn
LP.CharacterAdded:Connect(function()
    wait(3)
    local hum = LP.Character:WaitForChild("Humanoid")
    hum.WalkSpeed = HamzConfig.WalkSpeed
    hum.JumpPower = HamzConfig.JumpPower
end)

print("🅗🅐🅜🅩🅗🅤🅑 Loaded! Enjoy bro 🔥")
