local Players=game:GetService("Players")
local HttpService=game:GetService("HttpService")
local TeleportService=game:GetService("TeleportService")
local RunService=game:GetService("RunService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local StarterGui=game:GetService("StarterGui")
local localPlayer=Players.LocalPlayer
local char=localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart=char:WaitForChild("HumanoidRootPart")
local isRunning=true
_G.functionConnections={}

local function firstTeleport()
local char=localPlayer.Character or localPlayer.CharacterAdded:Wait()
local hrp=char:WaitForChild("HumanoidRootPart")
hrp.CFrame=CFrame.new(1653.3216552734375,-16.953155517578125,-529.6856079101562)
end
firstTeleport()

local function showNotification()
StarterGui:SetCore("SendNotification",{
Title="YV",
Text="付费版",
Duration=3
})
end
task.delay(0.1,showNotification)

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="ControlUI"
ScreenGui.Parent=game.CoreGui
local StopButton=Instance.new("TextButton")
StopButton.Size=UDim2.new(0,150,0,40)
StopButton.Position=UDim2.new(0.9,-150,0.1,0)
StopButton.BackgroundColor3=Color3.new(0.8,0.2,0.2)
StopButton.Text="停止🚫"
StopButton.TextColor3=Color3.new(1,1,1)
StopButton.TextSize=14
StopButton.Font=Enum.Font.SourceSansBold
StopButton.Parent=ScreenGui

StopButton.MouseButton1Click:Connect(function()
isRunning=false
StopButton.Text="已停止"
StopButton.BackgroundColor3=Color3.new(0.5,0.5,0.5)
for _,conn in pairs(_G.functionConnections or {}) do
if conn and typeof(conn)=="RBXScriptConnection" then
conn:Disconnect()
end
end
if _G.mainLoopTask then task.cancel(_G.mainLoopTask) end
if _G.maskTask then task.cancel(_G.maskTask) end
if _G.openBoxTask then task.cancel(_G.openBoxTask) end
end)

local function YVAdminKick()
local adminNames={
"FEARLESS4654","jbear314","amogus12342920","kumamikan1",
"RedRubyyy611","whyrally","Davydevv","HagahZet",
"alvis220","na3k7","fakest_reallty","Bogdanpro55555",
"Suponjibobu00","Realsigmadeepseek"
}
for _,v in pairs(Players:GetPlayers()) do
if v~=localPlayer and table.find(adminNames,v.Name) then
localPlayer:Kick("[YV Admin] 反管理踢出 管理员用户名为: "..v.Name)
end
end
local conn=Players.PlayerAdded:Connect(function(v)
if not isRunning then return end
if v~=localPlayer and table.find(adminNames,v.Name) then
localPlayer:Kick("[YV Admin] 反管理踢出 管理员用户名为: "..v.Name)
end
end)
table.insert(_G.functionConnections,conn)
end
task.spawn(YVAdminKick)

local function setupLocker()
local function showLocker()
if not isRunning then return end
local backpackGui=localPlayer.PlayerGui:WaitForChild("Backpack",10)
if not backpackGui then return end
local holder=backpackGui:WaitForChild("Holder",5)
if not holder then return end
local locker=holder:WaitForChild("Locker",5)
if locker then locker.Visible=true end
end
task.spawn(showLocker)
local conn=localPlayer.CharacterAdded:Connect(function()
if not isRunning then return end
wait(1)
showLocker()
end)
table.insert(_G.functionConnections,conn)
localPlayer:SetAttribute("lockerSlots",999)
local devv=require(ReplicatedStorage.devv)
local lockerModule=devv.load("locker")
lockerModule.getNextTier=function() return 5 end
lockerModule.getRobuxPrice=function() return 0 end
local backpackUI=devv.load("GUILoader").Get("Backpack")
for _,slot in pairs(backpackUI.Holder.Locker.Frame:GetChildren()) do
if slot:IsA("GuiObject") then
slot.Locked.Visible=false
slot.Unlocked.Visible=true
end
end
backpackUI.Holder.Locker.Buttons.UnlockAll.Visible=false
backpackUI.Holder.Locker.Buttons.PageSelector.Visible=false
if lockerModule.PromptPurchase then
lockerModule.PromptPurchase=function(itemId,infoType)
if not isRunning then return end
ReplicatedStorage.Signal:InvokeServer("completePurchase",itemId,infoType)
end
end
lockerModule.update()
end
task.spawn(setupLocker)

local CONFIG={
MAX_PLAYERS=38,
TELE_COOLDOWN=0.001,
RETRY_DELAY=1,
FORBIDDEN={center=Vector3.new(352.88,13.03,-1353.05),radius=80}
}
local TARGET_LUCKY={"Green Lucky Block","Orange Lucky Block","Purple Lucky Block"}
local MAT_BOX={"Electronics","Weapon Parts"}
local TARGET_ITEM={
"Green Lucky Block","Orange Lucky Block","Purple Lucky Block","Blue Candy Cane",
"Suitcase Nuke","Easter Basket","Dark Matter Gem","Void Gem","Diamond",
"Diamond Ring","Requirements","Gold Cup","Gold Crown","Pearl Necklace",
"Treasure Map","Spectral Scythe","Bunny Balloon","Ghost Balloon","Clover Balloon",
"Bat Balloon","Gold Clover Balloon","Golden Rose","Black Rose","Heart Balloon",
"Snowflake Balloon","Skull Balloon","Money Printer"
}
local visitedServers={}
local httpRequest=(syn and syn.request) or (http and http.request) or http_request or request

local armorConn=RunService.Heartbeat:Connect(function()
if not isRunning then return end
pcall(function()
local humanoid=char:FindFirstChildOfClass("Humanoid")
if not (humanoid and humanoid.Health>35) then return end
local devv=require(ReplicatedStorage.devv)
local itemModule=devv.load("v3item")
local inv=itemModule.inventory.items
local hasVest=false
for _,v in next,inv do
if v.name=="Light Vest" then
hasVest=true
if (localPlayer:GetAttribute("armor") or 0)<=0 then
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
table.insert(_G.functionConnections,armorConn)

_G.maskTask=task.spawn(function()
while task.wait(0.01) do
if not isRunning then break end
pcall(function()
local devv=require(ReplicatedStorage.devv)
if not char:FindFirstChild("Hockey Mask") then
devv.load("Signal").InvokeServer("attemptPurchase","Hockey Mask")
local itemModule=devv.load("v3item")
local inv=itemModule.inventory.items
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

_G.openBoxTask=task.spawn(function()
while true do
if not isRunning then break end
wait(0.0001)
pcall(function()
local devv=require(ReplicatedStorage.devv)
local itemModule=devv.load("v3item")
local inv=itemModule.inventory.items
local Signal=devv.load("Signal")
for _,v in next,inv do
if table.find(TARGET_LUCKY,v.name) then
Signal.FireServer("equip",v.guid)
wait(0.1)
Signal.FireServer("useConsumable",v.guid)
wait(0.1)
Signal.FireServer("removeItem",v.guid)
end
end
for _,v in next,inv do
if table.find(MAT_BOX,v.name) then
Signal.FireServer("equip",v.guid)
wait(0.1)
Signal.FireServer("useConsumable",v.guid)
wait(0.1)
Signal.FireServer("removeItem",v.guid)
end
end
end)
end
end)

local function scanItems()
if not isRunning then return {} end
local found={}
if not (workspace.Game and workspace.Game.Entities and workspace.Game.Entities.ItemPickup) then return found end
for _,folder in ipairs(workspace.Game.Entities.ItemPickup:GetChildren()) do
for _,item in ipairs(folder:GetChildren()) do
if not (item:IsA("MeshPart") or item:IsA("Part")) then continue end
local dist=(item.Position - CONFIG.FORBIDDEN.center).Magnitude
if dist<=CONFIG.FORBIDDEN.radius then continue end
for _,child in ipairs(item:GetChildren()) do
if child:IsA("ProximityPrompt") and table.find(TARGET_ITEM,child.ObjectText) then
table.insert(found,{item=item,prompt=child})
end
end
end
end
return found
end

local function getValidServers()
if not isRunning then return nil end
local url=string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",game.PlaceId)
local res=httpRequest and httpRequest({Url=url,Method="GET",Timeout=10})
if not res or res.StatusCode~=200 then return nil end
local success,data=pcall(function() return HttpService:JSONDecode(res.Body) end)
if not success or not data or not data.data then return nil end
local valid={}
for _,srv in ipairs(data.data) do
if srv.playing < CONFIG.MAX_PLAYERS and srv.id~=game.JobId and not visitedServers[srv.id] then
table.insert(valid,srv)
end
end
return valid
end

local function teleportSrv()
if not isRunning then return end
local servers=getValidServers()
if not servers or #servers==0 then task.wait(CONFIG.RETRY_DELAY) return end
local srv=servers[math.random(1,#servers)]
visitedServers[srv.id]=true
pcall(function()
TeleportService:TeleportToPlaceInstance(game.PlaceId,srv.id,localPlayer)
end)
end

_G.mainLoopTask=task.spawn(function()
while true do
if not isRunning then break end
local items=scanItems()
if #items>0 then
for _,d in ipairs(items) do
if not isRunning then break end
if char and humanoidRootPart then
humanoidRootPart.CFrame=d.item.CFrame + Vector3.new(0,3,0)
task.wait(0.2)
pcall(function()
if fireproximityprompt then
fireproximityprompt(d.prompt,10)
else
d.prompt:InputHoldBegin()
task.wait(3)
d.prompt:InputHoldEnd()
end
end)
task.wait(0.5)
end
end
end
task.wait(CONFIG.TELE_COOLDOWN)
teleportSrv()
end
end)
