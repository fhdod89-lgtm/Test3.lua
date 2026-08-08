local player = game.Players.LocalPlayer
local workspace = game.Workspace
local farming = false

local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 180, 0, 60)
btn.Position = UDim2.new(0.5, -90, 0.75, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "ФАРМ ВЫКЛ"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Parent = gui

btn.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        btn.Text = "ФАРМ ВКЛ"
    else
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        btn.Text = "ФАРМ ВЫКЛ"
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then root.Velocity = Vector3.new(0, 0, 0) end
    end
end)

task.spawn(function()
    while true do
        if farming then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local nearest = nil
                local minDist = 300
                
                for _, obj in workspace:GetDescendants() do
                    if obj:IsA("BasePart") and obj.Anchored then
                        if obj.Name == "CoinContainer" or obj.Name == "Coin" or obj.Name:find("Coin") then
                            local dist = (root.Position - obj.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                nearest = obj
                            end
                        end
                    end
                end
                
                if nearest then
                    local direction = (nearest.Position - root.Position).unit
                    root.Velocity = direction * 80
                end
            end
        end
        task.wait(0.05)
    end
end)
