local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui or game.Players.LocalPlayer.PlayerGui
local TextLabel = Instance.new("TextLabel")
TextLabel.Text = "此版本已失效"
TextLabel.Parent = ScreenGui
TextLabel.Position = UDim2.new(0.5,0,0.5,0)
TextLabel.AnchorPoint = Vector2.new(0.5,0.5)
TextLabel.TextColor3 = Color3.new(1,1,1)
TextLabel.TextStrokeTransparency = 0.25
TextLabel.Size = UDim2.new(0, 200, 0, 19)
TextLabel.TextSize = 35.000
TextLabel.BackgroundTransparency = 1
_G.gui = ScreenGui
wait(99999)
_G.gui:Destroy()
