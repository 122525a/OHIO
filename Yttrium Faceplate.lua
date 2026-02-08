local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local SelectedPlayer = nil
local TeleportOffset = CFrame.new(0, 0, 3)
local isTeleporting = false
local continuousTeleport = false
local continuousThread = nil
local bladeaura = false
local antiAdmin = false
local antiAdminThread = nil
-- 新增：检测同脚本用户相关变量
local detectYttrium = false
local detectYttriumThread = nil
local playerConnections = {}
local playerTagMap = {}
local TargetURL = "https://raw.githubusercontent.com/122525a/OHIO/refs/heads/main/wearedevs%E7%99%BD%E5%90%8D%95.lua"
local NameMap = {}
-- 新增：作者在线警示条相关变量【修复后】
local authorWarnUI = nil
local warnLabel1, warnLabel2 = nil, nil -- 双标签实现无缝循环
local AUTHOR_NAME = "lyyanddmc" -- 作者用户名
local isAuthorInServer = false

-- 管理员名单
local AdminNames = {
    "FEARLESS4654", "jbear314", "amogus12342920", "kumamikan1",
    "RedRubyyy611", "whyrally", "Davydevv", "HagahZet",
    "alvis220", "na3k7", "fakest_reallty", "Bogdanpro55555",
    "Suponjibobu00", "Realsigmadeepseek"
}

-- 飞镖光环相关变量初始化
local load, Signal, FireServer, InvokeServer, GUID, v3item, Raycast, inventory
pcall(function()
    load = require(ReplicatedStorage.devv).load
    Signal = load("Signal")
    FireServer = Signal.FireServer
    InvokeServer = Signal.InvokeServer
    GUID = load("GUID")
    v3item = load("v3item")
    Raycast = load("Raycast")
    inventory = v3item.inventory
end)

-- 新增：获取UI父容器
local function GetUIParent()
    local success, parent = pcall(function() return game:GetService("CoreGui") end)
    if success and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- 清理旧UI
for _, gui in pairs(GetUIParent():GetChildren()) do
    if gui.Name == "XA_LuaWare" or gui.Name == "AuthorWarnUI" or gui.Name == "YttriumDetectUI" then gui:Destroy() end
end

-- 主UI容器
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XA_LuaWare"
ScreenGui.Parent = GetUIParent()
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 主框架
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
SideBar.Size = UDim2.new(0, 8, 0, 300)

local SideBarCorner = Instance.new("UICorner")
SideBarCorner.CornerRadius = UDim.new(0, 6)
SideBarCorner.Parent = SideBar

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 20, 0, 10)
TabContainer.Size = UDim2.new(0, 260, 0, 280)

local GeneralSection = Instance.new("Frame")
GeneralSection.Parent = TabContainer
GeneralSection.BackgroundTransparency = 1
GeneralSection.Size = UDim2.new(1, 0, 1, 0)

local ContainerLayout = Instance.new("UIListLayout")
ContainerLayout.Parent = GeneralSection
ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContainerLayout.Padding = UDim.new(0, 8)

-- 玩家选择下拉框
local DropFrame = Instance.new("Frame")
DropFrame.Parent = GeneralSection
DropFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
DropFrame.Size = UDim2.new(1, 0, 0, 32)

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = DropFrame

local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Parent = DropFrame
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
SelectedLabel.Size = UDim2.new(0.8, 0, 1, 0)
SelectedLabel.Font = Enum.Font.GothamSemibold
SelectedLabel.Text = "选择玩家"
SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedLabel.TextSize = 14
SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left

local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = DropFrame
OpenBtn.BackgroundTransparency = 1
OpenBtn.Size = UDim2.new(1, 0, 1, 0)
OpenBtn.Text = ""

local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Parent = GeneralSection
ListFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 60)
ListFrame.Size = UDim2.new(1, 0, 0, 100)
ListFrame.Visible = false
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ListFrame

local function RefreshPlayers()
    for _, c in pairs(ListFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local AllBtn = Instance.new("TextButton")
    AllBtn.Parent = ListFrame
    AllBtn.Size = UDim2.new(1, 0, 0, 25)
    AllBtn.Font = Enum.Font.Gotham
    AllBtn.Text = "All"
    AllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AllBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 75)
    AllBtn.MouseButton1Click:Connect(function()
        SelectedLabel.Text = "All"
        SelectedPlayer = "All"
        ListFrame.Visible = false
    end)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local Btn = Instance.new("TextButton")
            Btn.Parent = ListFrame
            Btn.Size = UDim2.new(1, 0, 0, 25)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = p.DisplayName .. " (" .. p.Name .. ")"
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 45, 75)
            Btn.MouseButton1Click:Connect(function()
                SelectedLabel.Text = p.Name
                SelectedPlayer = p
                ListFrame.Visible = false
            end)
        end
    end
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

OpenBtn.MouseButton1Click:Connect(function()
    ListFrame.Visible = not ListFrame.Visible
    if ListFrame.Visible then RefreshPlayers() end
end)

-- 工具函数
local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

-- 传送核心函数
local function teleportToPlayer(targetPlr)
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart")
    if localHRP and targetHRP then
        localHRP.CFrame = targetHRP.CFrame * TeleportOffset
    end
end

local function batchTeleport()
    if isTeleporting then return end
    isTeleporting = true
    local playerList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(playerList, p)
        end
    end
    playerList = shuffleTable(playerList)
    for _, p in ipairs(playerList) do
        teleportToPlayer(p)
        task.wait(1)
    end
    isTeleporting = false
end

local function stopContinuousTeleport()
    if continuousThread then
        task.cancel(continuousThread)
        continuousThread = nil
    end
    continuousTeleport = false
end

local function startContinuousTeleport()
    stopContinuousTeleport()
    continuousTeleport = true
    continuousThread = task.spawn(function()
        while continuousTeleport and SelectedPlayer and SelectedPlayer ~= "All" do
            teleportToPlayer(SelectedPlayer)
            task.wait(0.01)
        end
        continuousTeleport = false
    end)
end

-- 单次传送按钮
local ButtonFrame = Instance.new("TextButton")
ButtonFrame.Parent = GeneralSection
ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
ButtonFrame.Size = UDim2.new(1, 0, 0, 32)
ButtonFrame.AutoButtonColor = false
ButtonFrame.Font = Enum.Font.GothamSemibold
ButtonFrame.Text = "传送"
ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonFrame.TextSize = 14
ButtonFrame.TextXAlignment = Enum.TextXAlignment.Left

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ButtonFrame

ButtonFrame.MouseButton1Click:Connect(function()
    if continuousTeleport then stopContinuousTeleport() end
    if SelectedPlayer == "All" then
        batchTeleport()
    elseif SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        teleportToPlayer(SelectedPlayer)
    end
end)

-- 锁定传送开关
local ToggleFrame = Instance.new("TextButton")
ToggleFrame.Parent = GeneralSection
ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
ToggleFrame.AutoButtonColor = false
ToggleFrame.Font = Enum.Font.GothamSemibold
ToggleFrame.Text = "锁定传送"
ToggleFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFrame.TextSize = 14
ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleFrame

local Indicator1 = Instance.new("Frame")
Indicator1.Parent = ToggleFrame
Indicator1.AnchorPoint = Vector2.new(1, 0.5)
Indicator1.Position = UDim2.new(0.95, 0, 0.5, 0)
Indicator1.Size = UDim2.new(0, 20, 0, 20)
Indicator1.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

local IndicatorCorner1 = Instance.new("UICorner")
IndicatorCorner1.CornerRadius = UDim.new(0, 4)
IndicatorCorner1.Parent = Indicator1

ToggleFrame.MouseButton1Click:Connect(function()
    if SelectedPlayer and SelectedPlayer ~= "All" then
        continuousTeleport = not continuousTeleport
        Indicator1.BackgroundColor3 = continuousTeleport and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
        if continuousTeleport then
            startContinuousTeleport()
        else
            stopContinuousTeleport()
        end
    end
end)

-- 飞镖光环开关
local BladeToggle = Instance.new("TextButton")
BladeToggle.Parent = GeneralSection
BladeToggle.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
BladeToggle.Size = UDim2.new(1, 0, 0, 32)
BladeToggle.AutoButtonColor = false
BladeToggle.Font = Enum.Font.GothamSemibold
BladeToggle.Text = "   飞镖光环"
BladeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
BladeToggle.TextSize = 14
BladeToggle.TextXAlignment = Enum.TextXAlignment.Left

local BladeCorner = Instance.new("UICorner")
BladeCorner.CornerRadius = UDim.new(0, 6)
BladeCorner.Parent = BladeToggle

local Indicator2 = Instance.new("Frame")
Indicator2.Parent = BladeToggle
Indicator2.AnchorPoint = Vector2.new(1, 0.5)
Indicator2.Position = UDim2.new(0.95, 0, 0.5, 0)
Indicator2.Size = UDim2.new(0, 20, 0, 20)
Indicator2.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

local IndicatorCorner2 = Instance.new("UICorner")
IndicatorCorner2.CornerRadius = UDim.new(0, 4)
IndicatorCorner2.Parent = Indicator2

BladeToggle.MouseButton1Click:Connect(function()
    bladeaura = not bladeaura
    Indicator2.BackgroundColor3 = bladeaura and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
end)

-- 飞行功能按钮
local FlyButton = Instance.new("TextButton")
FlyButton.Parent = GeneralSection
FlyButton.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
FlyButton.Size = UDim2.new(1, 0, 0, 32)
FlyButton.AutoButtonColor = false
FlyButton.Font = Enum.Font.GothamSemibold
FlyButton.Text = "   飞行（先绕过才能执行）"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 14
FlyButton.TextXAlignment = Enum.TextXAlignment.Left

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 6)
FlyCorner.Parent = FlyButton

FlyButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/122525a/OHIO/refs/heads/main/lyy%E9%A3%9E%E8%A1%8C%EF%BC%88%E5%85%88%E7%BB%95%E8%BF%87%E9%A3%9E%E8%A1%8C%EF%BC%89.lua"))()
    end)
end)

-- 反管理开关
local AntiAdminToggle = Instance.new("TextButton")
AntiAdminToggle.Parent = GeneralSection
AntiAdminToggle.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
AntiAdminToggle.Size = UDim2.new(1, 0, 0, 32)
AntiAdminToggle.AutoButtonColor = false
AntiAdminToggle.Font = Enum.Font.GothamSemibold
AntiAdminToggle.Text = "   反管理"
AntiAdminToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAdminToggle.TextSize = 14
AntiAdminToggle.TextXAlignment = Enum.TextXAlignment.Left

local AntiAdminCorner = Instance.new("UICorner")
AntiAdminCorner.CornerRadius = UDim.new(0, 6)
AntiAdminCorner.Parent = AntiAdminToggle

local Indicator3 = Instance.new("Frame")
Indicator3.Parent = AntiAdminToggle
Indicator3.AnchorPoint = Vector2.new(1, 0.5)
Indicator3.Position = UDim2.new(0.95, 0, 0.5, 0)
Indicator3.Size = UDim2.new(0, 20, 0, 20)
Indicator3.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

local IndicatorCorner3 = Instance.new("UICorner")
IndicatorCorner3.CornerRadius = UDim.new(0, 4)
IndicatorCorner3.Parent = Indicator3

-- 反管理核心检测函数
local function checkAdminPlayers()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            for _, adminName in pairs(AdminNames) do
                if v.Name == adminName then
                    LocalPlayer:Kick("[Yttrium Hub] 反管理踢出 管理员用户名为: " .. v.Name)
                    return
                end
            end
        end
    end
end

local function stopAntiAdmin()
    if antiAdminThread then
        task.cancel(antiAdminThread)
        antiAdminThread = nil
    end
    antiAdmin = false
end

local function startAntiAdmin()
    stopAntiAdmin()
    antiAdmin = true
    antiAdminThread = task.spawn(function()
        while antiAdmin do
            checkAdminPlayers()
            task.wait(0.1)
        end
    end)
    checkAdminPlayers()
end

AntiAdminToggle.MouseButton1Click:Connect(function()
    antiAdmin = not antiAdmin
    Indicator3.BackgroundColor3 = antiAdmin and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    if antiAdmin then
        startAntiAdmin()
    else
        stopAntiAdmin()
    end
end)

-- 新增：1. 检测同脚本用户核心函数（复用检测同脚本.lua逻辑）
local function fetchYttriumNames()
    local success, response = pcall(function()
        return HttpService:GetAsync(TargetURL, true, 10)
    end)
    if not success then
        warn("URL加载失败，使用内置备用名单")
        local backupNames = {
            "lyyanddmc",
            "ehejxeixe",
            "dialogue1473",
            "qweasz9850",
            "Ohuozyz",
            "AXFyig",
            "p",
            "p",
            "rtjstrjg"
        }
        for _, name in ipairs(backupNames) do
            NameMap[name] = true
        end
        return
    end
    table.clear(NameMap)
    for line in response:gmatch("[^\r\n]+") do
        local userName = line:trim()
        if userName ~= "" then
            NameMap[userName] = true
        end
    end
end

local function isYttriumUser(player)
    return NameMap[player.Name] == true
end

local function updateNametag(player, textLabel)
    local character = player.Character
    if not character then
        textLabel.Visible = false
        playerTagMap[player.UserId] = false
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local targetHead = character:FindFirstChild("Head")
    local LocalCharacter = LocalPlayer.Character
    local LocalHead = LocalCharacter and LocalCharacter:FindFirstChild("Head")
    if not humanoid or not targetHead or not LocalHead or humanoid.Health <= 0 then
        textLabel.Visible = false
        return
    end
    local distance = (LocalHead.Position - targetHead.Position).Magnitude
    textLabel.Text = string.format("Yttrium用户: %s\n血量: %d/%d\n距离: %.1fm", player.Name, math.floor(humanoid.Health), math.floor(humanoid.MaxHealth), distance)
    textLabel.Visible = true
end

local function createNametag(player)
    if player == LocalPlayer or not isYttriumUser(player) or playerTagMap[player.UserId] then return end
    playerConnections[player] = playerConnections[player] or {}
    playerTagMap[player.UserId] = true
    local function setupCharacter(character)
        if not character then 
            playerTagMap[player.UserId] = false
            return 
        end
        local head = character:WaitForChild("Head", 10)
        if not head then 
            playerTagMap[player.UserId] = false
            return 
        end
        for _, oldTag in ipairs(head:GetChildren()) do
            if oldTag.Name == "YttriumNametag" then
                oldTag:Destroy()
            end
        end
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "YttriumNametag"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 80)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 8
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.TextStrokeTransparency = 0.3
        textLabel.BackgroundTransparency = 1
        textLabel.TextYAlignment = Enum.TextYAlignment.Top
        textLabel.Parent = billboard
        local heartbeatConn = RunService.Heartbeat:Connect(function()
            if not character.Parent or not player.Parent then
                heartbeatConn:Disconnect()
                billboard:Destroy()
                playerTagMap[player.UserId] = false
                return
            end
            updateNametag(player, textLabel)
        end)
        table.insert(playerConnections[player], heartbeatConn)
        local characterRemovedConn = character.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                billboard:Destroy()
                heartbeatConn:Disconnect()
                characterRemovedConn:Disconnect()
                playerTagMap[player.UserId] = false
            end
        end)
        table.insert(playerConnections[player], characterRemovedConn)
    end
    if player.Character then
        setupCharacter(player.Character)
    end
    local charAddedConn = player.CharacterAdded:Connect(setupCharacter)
    table.insert(playerConnections[player], charAddedConn)
end

local function removeNametag(player)
    if playerConnections[player] then
        for _, conn in ipairs(playerConnections[player]) do
            if conn.Connected then conn:Disconnect() end
        end
        playerConnections[player] = nil
    end
    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            local nametag = head:FindFirstChild("YttriumNametag")
            if nametag then nametag:Destroy() end
        end
    end
    playerTagMap[player.UserId] = false
end

local function stopDetectYttrium()
    if detectYttriumThread then
        task.cancel(detectYttriumThread)
        detectYttriumThread = nil
    end
    detectYttrium = false
    for _, p in pairs(Players:GetPlayers()) do
        removeNametag(p)
    end
    table.clear(playerConnections)
    table.clear(playerTagMap)
end

local function startDetectYttrium()
    stopDetectYttrium()
    detectYttrium = true
    fetchYttriumNames()
    detectYttriumThread = task.spawn(function()
        repeat task.wait(30)
            fetchYttriumNames()
        until not detectYttrium
    end)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createNametag(player)
            local leavingConn = player.AncestryChanged:Connect(function(_, parent)
                if parent == nil and detectYttrium then
                    removeNametag(player)
                    leavingConn:Disconnect()
                end
            end)
            table.insert(playerConnections[player] or {}, leavingConn)
        end
    end
    Players.PlayerAdded:Connect(function(player)
        if not detectYttrium then return end
        task.wait(0.5)
        createNametag(player)
        local leavingConn = player.AncestryChanged:Connect(function(_, parent)
            if parent == nil and detectYttrium then
                removeNametag(player)
                leavingConn:Disconnect()
            end
        end)
        table.insert(playerConnections[player] or {}, leavingConn)
    end)
    LocalPlayer.CharacterAdded:Connect(function()
        if not detectYttrium then return end
        task.wait(0.5)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and isYttriumUser(player) then
                createNametag(player)
            end
        end
    end)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and detectYttrium then
            player.CharacterAdded:Connect(function()
                playerTagMap[player.UserId] = false
                task.wait(0.2)
                createNametag(player)
            end)
        end
    end
end

-- 新增：检测同脚本用户开关按钮（集成到主UI）
local DetectYttriumToggle = Instance.new("TextButton")
DetectYttriumToggle.Parent = GeneralSection
DetectYttriumToggle.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
DetectYttriumToggle.Size = UDim2.new(1, 0, 0, 32)
DetectYttriumToggle.AutoButtonColor = false
DetectYttriumToggle.Font = Enum.Font.GothamSemibold
DetectYttriumToggle.Text = "   检测同脚本用户"
DetectYttriumToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
DetectYttriumToggle.TextSize = 14
DetectYttriumToggle.TextXAlignment = Enum.TextXAlignment.Left

local DetectYttriumCorner = Instance.new("UICorner")
DetectYttriumCorner.CornerRadius = UDim.new(0, 6)
DetectYttriumCorner.Parent = DetectYttriumToggle

local Indicator4 = Instance.new("Frame")
Indicator4.Parent = DetectYttriumToggle
Indicator4.AnchorPoint = Vector2.new(1, 0.5)
Indicator4.Position = UDim2.new(0.95, 0, 0.5, 0)
Indicator4.Size = UDim2.new(0, 20, 0, 20)
Indicator4.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

local IndicatorCorner4 = Instance.new("UICorner")
IndicatorCorner4.CornerRadius = UDim.new(0, 4)
IndicatorCorner4.Parent = Indicator4

DetectYttriumToggle.MouseButton1Click:Connect(function()
    detectYttrium = not detectYttrium
    Indicator4.BackgroundColor3 = detectYttrium and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    if detectYttrium then
        startDetectYttrium()
    else
        stopDetectYttrium()
    end
end)

-- 新增：2. 作者在线警示条【完全修复版】
-- 核心：双标签无缝循环+独立持久化UI+全程无断层+退出服务器也保留
local function createAuthorWarnUI()
    -- 持久化UI容器，退出服务器也不会被销毁
    authorWarnUI = Instance.new("ScreenGui")
    authorWarnUI.Name = "AuthorWarnUI"
    authorWarnUI.Parent = game:GetService("CoreGui") -- 强制挂在CoreGui，更稳定
    authorWarnUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    authorWarnUI.ResetOnSpawn = false -- 重生/退出不重置，关键修复！

    -- 警示条底框（屏幕上方，25px高度，不遮挡视野）
    local WarnFrame = Instance.new("Frame")
    WarnFrame.Name = "WarnFrame"
    WarnFrame.Parent = authorWarnUI
    WarnFrame.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
    WarnFrame.Size = UDim2.new(1, 0, 0, 25)
    WarnFrame.Position = UDim2.new(0, 0, 0, 0)
    WarnFrame.BackgroundTransparency = 0.1
    WarnFrame.ClipsDescendants = true -- 裁剪超出部分，避免文字溢出

    local WarnCorner = Instance.new("UICorner")
    WarnCorner.CornerRadius = UDim.new(0, 4)
    WarnCorner.Parent = WarnFrame

    -- 文字容器（用于承载双标签，实现无缝滚动）
    local TextContainer = Instance.new("Frame")
    TextContainer.Parent = WarnFrame
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = UDim2.new(1, 0, 1, 0)
    TextContainer.Position = UDim2.new(0, 0, 0, 0)

    -- 双标签：标签1和标签2内容完全一致，拼接实现无缝
    local warnText = "⚠️ 作者lyyanddmc在此服务器 ⚠️"
    -- 标签1（初始在右侧，开始滚动）
    warnLabel1 = Instance.new("TextLabel")
    warnLabel1.Parent = TextContainer
    warnLabel1.BackgroundTransparency = 1
    warnLabel1.Size = UDim2.new(0, warnText:len()*12, 1, 0) -- 根据文字长度自适应
    warnLabel1.Position = UDim2.new(1, 0, 0, 0)
    warnLabel1.Font = Enum.Font.GothamBold
    warnLabel1.Text = warnText
    warnLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
    warnLabel1.TextSize = 16
    warnLabel1.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    warnLabel1.TextStrokeTransparency = 0
    warnLabel1.TextXAlignment = Enum.TextXAlignment.Left

    -- 标签2（紧跟标签1右侧，实现无缝衔接）
    warnLabel2 = Instance.new("TextLabel")
    warnLabel2.Parent = TextContainer
    warnLabel2.BackgroundTransparency = 1
    warnLabel2.Size = UDim2.new(0, warnText:len()*12, 1, 0)
    warnLabel2.Position = UDim2.new(1, warnText:len()*12, 0, 0)
    warnLabel2.Font = Enum.Font.GothamBold
    warnLabel2.Text = warnText
    warnLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
    warnLabel2.TextSize = 16
    warnLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    warnLabel2.TextStrokeTransparency = 0
    warnLabel2.TextXAlignment = Enum.TextXAlignment.Left

    -- 核心：无限循环滚动动画（从右到左，无缝衔接，无断层）
    local function startScroll()
        local tweenInfo = TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0)
        local tweenGoal = {Position = UDim2.new(0, -warnText:len()*24, 0, 0)} -- 滚动距离为双标签总长度
        local scrollTween = TweenService:Create(TextContainer, tweenInfo, tweenGoal)
        scrollTween:Play()
        -- 动画结束后立即重置位置，循环执行
        scrollTween.Completed:Connect(function()
            TextContainer.Position = UDim2.new(0, 0, 0, 0)
            startScroll() -- 递归调用，实现无限循环
        end)
    end
    startScroll()

    return WarnFrame
end

-- 检测作者是否在服务器（实时检测，0.5秒/次）
local function checkAuthorInServer()
    local found = false
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name == AUTHOR_NAME then
            found = true
            break
        end
    end
    if found ~= isAuthorInServer then
        isAuthorInServer = found
        if isAuthorInServer then
            -- 作者在服：显示警示条（无则创建）
            if not authorWarnUI then createAuthorWarnUI() end
            authorWarnUI.Enabled = true
        else
            -- 作者离服：隐藏警示条（不销毁，保留UI）
            if authorWarnUI then authorWarnUI.Enabled = false end
        end
    end
end

-- 默认开启：创建UI+启动实时检测（独立线程，不影响主脚本）
task.spawn(function()
    createAuthorWarnUI() -- 先创建UI，默认隐藏
    authorWarnUI.Enabled = false
    -- 无限检测，退出服务器也会持续运行（CoreGui持久化）
    while true do
        checkAuthorInServer()
        task.wait(0.5)
    end
end)

-- 飞镖光环核心函数
local function hackthrow(plr, itemname, itemguid, velocity, epos)
    if plr ~= LocalPlayer or not load then return end
    task.spawn(function()
        local throwGuid = GUID()
        local success, stickyId = InvokeServer("throwSticky", throwGuid, itemname, itemguid, velocity, epos)
        if not success then return end
        local dummyPart = Instance.new("Part")
        dummyPart.Size = Vector3.new(2, 2, 2)
        dummyPart.Position = epos
        dummyPart.Anchored = true
        dummyPart.Transparency = 1
        dummyPart.CanCollide = true
        dummyPart.Parent = workspace
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = { plr.Character, workspace.Game.Local, workspace.Game.Drones }
        local dist = (epos - plr.Character.Head.Position).Magnitude
        local rayResult = workspace:Raycast(plr.Character.Head.Position, (epos - plr.Character.Head.Position).Unit * (dist + 5), rayParams)
        if rayResult and rayResult.Instance then
            local hitPart = rayResult.Instance
            local relativeHitCFrame = hitPart.CFrame:ToObjectSpace(CFrame.new(rayResult.Position, rayResult.Position + rayResult.Normal))
            local stickyCFrame = CFrame.new(rayResult.Position)
            if dummyPart.Parent then dummyPart:Destroy() end
            getgenv().throwargs = { "hitSticky", stickyId or throwGuid, hitPart, relativeHitCFrame, stickyCFrame }
            InvokeServer("hitSticky", stickyId or throwGuid, hitPart, relativeHitCFrame, stickyCFrame)
        else
            if dummyPart.Parent then dummyPart:Destroy() end
        end
    end)
end

local function getinventory()
    return inventory and inventory.items or {}
end

local function finditem(string)
    for guid, data in next, getinventory() do
        if data.name == string or data.type == string or data.subtype == string then
            return data
        end
    end
end

local function executebladekill(plr, head)
    if not load or not plr or not head then return end
    local item = finditem("Ninja Star")
    if item then
        FireServer("equip", item.guid)
        if not getgenv().throwargs then
            local spos = LocalPlayer.Character and LocalPlayer.Character.RightHand.Position
            local epos = head.Position
            if not spos then return end
            local velocity = (epos - spos).Unit * ((spos - epos).Magnitude * 15)
            task.spawn(InvokeServer, "attemptPurchaseAmmo", "Ninja Star")
            hackthrow(LocalPlayer, "Ninja Star", item.guid, velocity, epos)
        end
        if getgenv().throwargs then
            getgenv().throwargs[3] = head
            task.spawn(InvokeServer, unpack(getgenv().throwargs))
        end
    else
        task.spawn(InvokeServer, "attemptPurchase", "Ninja Star")
    end
end

-- 飞镖光环心跳检测
RunService.Heartbeat:Connect(function()
    local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if bladeaura and HumanoidRootPart and load then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local head = char and char:FindFirstChild("Head")
            local dist = head and (HumanoidRootPart.Position - head.Position).Magnitude or math.huge
            if hum and hum.Health > 0 and head and dist < 190 then
                executebladekill(plr, head)
                break
            end
        end
    end
end)

-- 玩家加入时反管理检测
Players.PlayerAdded:Connect(function()
    if antiAdmin then
        checkAdminPlayers()
    end
end)

-- UI隐藏/显示按钮
local ToggleUIButton = Instance.new("TextButton")
ToggleUIButton.Name = "ToggleUI"
ToggleUIButton.Parent = ScreenGui
ToggleUIButton.BackgroundColor3 = Color3.fromRGB(28, 33, 55)
ToggleUIButton.Position = UDim2.new(0, 20, 0.3, 0)
ToggleUIButton.Size = UDim2.new(0, 60, 0, 30)
ToggleUIButton.Font = Enum.Font.SourceSans
ToggleUIButton.Text = "Yttrium俄亥俄州"
ToggleUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIButton.TextSize = 14
ToggleUIButton.Draggable = true

ToggleUIButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
