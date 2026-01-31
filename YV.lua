local isRunning = true
_G.functionConnections = _G.functionConnections or {}

local LocalPlayer = game:GetService("Players").LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
repeat task.wait() until game:IsLoaded()

local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
hrp.CFrame = CFrame.new(1653.3216552734375, -16.953155517578125, -529.6856079101562)

local function antiAdminKick()
    local adminNames = {
        "FEARLESS4654", "jbear314", "amogus12342920", "kumamikan1", 
        "RedRubyyy611", "whyrally", "Davydevv", "HagahZet", 
        "alvis220", "na3k7", "fakest_reallty", "Bogdanpro55555", 
        "Suponjibobu00", "Realsigmadeepseek"
    }
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and table.find(adminNames, v.Name) then
            LocalPlayer:Kick("[YV Admin] 反管理踢出 管理员用户名为: " .. v.Name)
        end
    end
    local conn = Players.PlayerAdded:Connect(function(v)
        if not isRunning then return end
        if v ~= LocalPlayer and table.find(adminNames, v.Name) then
            LocalPlayer:Kick("[YV Admin] 反管理踢出 管理员用户名为: " .. v.Name)
        end
    end)
    table.insert(_G.functionConnections, conn)
end
task.spawn(antiAdminKick)

local armorConn = RunService.Heartbeat:Connect(function()
    if not isRunning then return end
    pcall(function()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not (humanoid and humanoid.Health>35) then return end
        local devv = require(ReplicatedStorage.devv)
        local itemModule = devv.load("v3item")
        local inv = itemModule.inventory.items
        local hasVest = false
        for _,v in next,inv do
            if v.name=="Light Vest" then
                hasVest = true
                if (LocalPlayer:GetAttribute("armor") or 0)<=0 then
                    devv.load("Signal").FireServer("equip",v.guid)
                    devv.load("Signal").FireServer("useConsumable",v.guid)
                    devv.load("Signal").FireServer("removeItem",v.guid)
                end
                break
            end
        end
        if not hasVest then devv.load("Signal").InvokeServer("attemptPurchase","Light Vest") end
    end)
end)
table.insert(_G.functionConnections, armorConn)

local maskTask = task.spawn(function()
    while task.wait(0.01) do
        if not isRunning then break end
        pcall(function()
            local devv = require(ReplicatedStorage.devv)
            if not char:FindFirstChild("Hockey Mask") then
                devv.load("Signal").InvokeServer("attemptPurchase","Hockey Mask")
                local itemModule = devv.load("v3item")
                local inv = itemModule.inventory.items
                for _,v in next,inv do
                    if v.name=="Hockey Mask" then
                        devv.load("Signal").FireServer("equip",v.guid)
                        devv.load("Signal").FireServer("wearMask",v.guid)
                        break
                    end
                end
            end
        end)
    end
end)

local item = require(ReplicatedStorage.devv).load("v3item")
local function safeGetInventory()
    return item.inventory and item.inventory.items or {}
end
local fistsId = (function()
    for _, v in pairs(safeGetInventory()) do
        if v.name == "Fists" then return v.guid end
    end
    return nil
end)()
if fistsId then require(ReplicatedStorage.devv).load("Signal").FireServer("equip", fistsId) end

local stats = {
    totalItems = 0, moneyPrinters = 0, balloons = 0, rareGems = 0, serverHops = 0
}
local dataKey = "YV_Farm_" .. LocalPlayer.UserId
pcall(function()
    local saved = HttpService:JSONDecode(readfile(dataKey))
    if saved then stats = saved end
end)
local function saveStats()
    pcall(function() writefile(dataKey, HttpService:JSONEncode(stats)) end)
end

-- 完全还原原始UI文字样式
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YV_Farm"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.05, 0)
MainFrame.Size = UDim2.new(0.9, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.05
MainFrame.ZIndex = 2
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local BorderFrame = Instance.new("Frame")
BorderFrame.Name = "BorderFrame"
BorderFrame.Parent = MainFrame
BorderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BorderFrame.Size = UDim2.new(1, 0, 1, 0)
BorderFrame.ZIndex = 1
BorderFrame.ClipsDescendants = true

local BorderCorner = Instance.new("UICorner")
BorderCorner.CornerRadius = UDim.new(0, 12)
BorderCorner.Parent = BorderFrame

local BorderGradient = Instance.new("UIGradient")
BorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(128, 0, 255)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 128, 0)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 128))
})
BorderGradient.Rotation = 45
BorderGradient.Parent = BorderFrame

local InnerFrame = Instance.new("Frame")
InnerFrame.Name = "InnerFrame"
InnerFrame.Parent = MainFrame
InnerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
InnerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
InnerFrame.Size = UDim2.new(0.96, 0, 0.96, 0)
InnerFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
InnerFrame.ZIndex = 3

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(0, 10)
InnerCorner.Parent = InnerFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = InnerFrame
TitleLabel.AnchorPoint = Vector2.new(0.5, 0)
TitleLabel.Position = UDim2.new(0.5, 0, 0.03, 0)
TitleLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "YV 自动农场"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextStrokeTransparency = 0.8
TitleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "StatsLabel"
StatsLabel.Parent = InnerFrame
StatsLabel.AnchorPoint = Vector2.new(0.5, 0)
StatsLabel.Position = UDim2.new(0.5, 0, 0.15, 0)
StatsLabel.Size = UDim2.new(0.9, 0, 0.75, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsLabel.TextSize = 14
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.TextYAlignment = Enum.TextYAlignment.Top
StatsLabel.TextStrokeTransparency = 0.9
StatsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
StatsLabel.TextWrapped = true

local GlowEffect = Instance.new("Frame")
GlowEffect.Name = "GlowEffect"
GlowEffect.Parent = BorderFrame
GlowEffect.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
GlowEffect.Size = UDim2.new(1, 0, 1, 0)
GlowEffect.BackgroundTransparency = 0.7
GlowEffect.ZIndex = 0

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 12)
GlowCorner.Parent = GlowEffect

local glowTween = TweenService:Create(GlowEffect, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {BackgroundTransparency = 0.9})
glowTween:Play()

local borderTween = TweenService:Create(BorderGradient, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
borderTween:Play()

local balloonNames = {"Bunny Balloon","Ghost Balloon","Clover Balloon","Bat Balloon","Gold Clover Balloon","Golden Rose","Black Rose","Heart Balloon","Snowflake Balloon","Skull Balloon"}
local rareGemNames = {"Gold Cup","Gold Crown","Dark Matter Gem","Void Gem","Diamond"}
local function getMoneyPrinterCount()
    local c = 0
    for _, v in pairs(safeGetInventory()) do
        if v.name == "Money Printer" then c += v.count or 1 end
    end
    return c
end
local function getBalloonCount()
    local c = 0
    for _, v in pairs(safeGetInventory()) do
        for _, b in ipairs(balloonNames) do
            if v.name == b then c += v.count or 1 end
        end
    end
    return c
end
local function getRareGemCount()
    local c = 0
    for _, v in pairs(safeGetInventory()) do
        for _, g in ipairs(rareGemNames) do
            if v.name == g then c += v.count or 1 end
        end
    end
    return c
end

local function updateUI()
    StatsLabel.Text = string.format(
        "目标物品: %d次\n印钞机: %d次\n气球: %d个\n稀有宝石: %d个\n换服次数: %d次\n背包印钞机: %d个\n背包气球: %d个\n背包稀有宝石: %d个",
        stats.totalItems, stats.moneyPrinters, stats.balloons, stats.rareGems, stats.serverHops,
        getMoneyPrinterCount(), getBalloonCount(), getRareGemCount()
    )
    saveStats()
end
updateUI()
task.spawn(function() while true do updateUI() task.wait(1) end end)

local targetItems = {
    "Money Printer", "Blue Candy Cane", "Bunny Balloon", "Ghost Balloon", "Clover Balloon", "Bat Balloon",
    "Gold Clover Balloon", "Golden Rose", "Black Rose", "Heart Balloon", "Diamond Ring", "Diamond",
    "Void Gem", "Dark Matter Gem", "Rollie", "NextBot Grenade", "Nuclear Missile Launcher", "Suitcase Nuke",
    "Helicopter", "Trident", "Golden Cup", "One Dollar Ballon", "Snowflake Balloon", "Skull Balloon",
    "Gold Cup", "Gold Crown"
}
local forbiddenZone = Vector3.new(352.884, 13.028, -1353.053)
local forbiddenRadius = 80
local serverHopInterval = 1
local scriptStart = os.time()
local collected = {}

local function TPServer()
    stats.serverHops += 1
    updateUI()
    local success, serverData = pcall(function()
        return HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
    end)
    if not (success and serverData and serverData.data) then
        task.wait(0.5)
        TPServer()
        return
    end
    local validServers = {}
    for _, server in ipairs(serverData.data) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            table.insert(validServers, server.id)
        end
    end
    if #validServers == 0 then
        task.wait(1)
        TPServer()
        return
    end
    local teleportSuccess = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, validServers[math.random(1, #validServers)])
    end)
    if not teleportSuccess then
        task.wait(0.5)
        TPServer()
    end
end

RunService.RenderStepped:Connect(function()
    if os.time() - scriptStart >= serverHopInterval then
        TPServer()
        scriptStart = os.time()
    end
    local itemPickups = workspace:FindFirstChild("Game")
    itemPickups = itemPickups and itemPickups:FindFirstChild("Entities")
    itemPickups = itemPickups and itemPickups:FindFirstChild("ItemPickup")
    if not itemPickups then return end
    for _, folder in pairs(itemPickups:GetChildren()) do
        for _, item in pairs(folder:GetChildren()) do
            if not (item:IsA("MeshPart") or item:IsA("Part")) then continue end
            if (item.Position - forbiddenZone).Magnitude <= forbiddenRadius then continue end
            local prompt = item:FindFirstChildOfClass("ProximityPrompt")
            if not prompt then continue end
            for _, target in pairs(targetItems) do
                if prompt.ObjectText ~= target then continue end
                prompt.RequiresLineOfSight = false
                prompt.HoldDuration = 0
                hrp.CFrame = CFrame.new(item.Position.X, item.Position.Y - char.Humanoid.HipHeight, item.Position.Z)
                fireproximityprompt(prompt, 10)
                if not collected[item] then
                    collected[item] = true
                    stats.totalItems += 1
                    if target == "Money Printer" then
                        stats.moneyPrinters += 1
                    elseif table.find(balloonNames, target) then
                        stats.balloons += 1
                    elseif table.find(rareGemNames, target) then
                        stats.rareGems += 1
                    end
                    updateUI()
                end
                task.wait(0.1)
            end
        end
    end
end)

