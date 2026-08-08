local player = game.Players.LocalPlayer
local workspace = game.Workspace
local RunService = game:GetService("RunService")
local farming = false
local connection = nil

-- Кнопка
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 180, 0, 60)
btn.Position = UDim2.new(0.5, -90, 0.7, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "ФАРМ ВЫКЛ"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Parent = gui

local function stopFarm()
    farming = false
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = "ФАРМ ВЫКЛ"
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
    end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(0, 0, 0)
    end
end

local function startFarm()
    farming = true
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = "ФАРМ ВКЛ"
    
    while farming do
        if not player.Character then
            task.wait(0.5)
            continue
        end
        
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = player.Character:FindFirstChild("Humanoid")
        
        if not root or not humanoid then
            task.wait(0.5)
            continue
        end
        
        humanoid.WalkSpeed = 100
        
        local nearest = nil
        local minDist = 50
        
        for _, obj in workspace:GetDescendants() do
            if obj:IsA("BasePart") and obj.Size.X < 4 and obj.Size.Y < 4 and obj.Anchored and obj.CanCollide == false then
                local dist = (root.Position - obj.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = obj
                end
            end
        end
        
        if nearest then
            root.CFrame = nearest.CFrame + Vector3.new(0, 0.5, 0)
        end
        
        task.wait(0.1)
    end
end

btn.MouseButton1Click:Connect(function()
    if farming then
        stopFarm()
    else
        task.spawn(startFarm)
    end
end)
