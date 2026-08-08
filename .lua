local player = game.Players.LocalPlayer
local workspace = game.Workspace
local farming = false

-- Кнопка
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.5, -75, 0.75, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "ФАРМ ВЫКЛ"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16
btn.Parent = gui

btn.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        btn.Text = "ФАРМ ВКЛ"
    else
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        btn.Text = "ФАРМ ВЫКЛ"
    end
end)

-- Фарм
task.spawn(function()
    while true do
        if farming then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in workspace:GetDescendants() do
                    if obj:IsA("BasePart") and obj.Size.X < 5 and obj.Size.Y < 5 and obj.Anchored then
                        local dist = (root.Position - obj.Position).Magnitude
                        if dist < 100 then
                            root.CFrame = obj.CFrame
                            task.wait(0.02)
                        end
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)
