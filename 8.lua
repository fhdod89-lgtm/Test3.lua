local player = game.Players.LocalPlayer
local workspace = game.Workspace
local farming = false

-- Кнопка
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 180, 0, 60)
btn.Position = UDim2.new(0.5, -90, 0.75, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "ВЫКЛ"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 20
btn.Parent = gui

btn.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        btn.Text = "ВКЛ"
    else
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        btn.Text = "ВЫКЛ"
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- NoClip + фарм
task.spawn(function()
    while true do
        if farming and player.Character then
            -- Проход сквозь стены
            for _, part in player.Character:GetDescendants() do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                -- Ищем ВСЕ монеты
                local coins = {}
                for _, obj in workspace:GetDescendants() do
                    if obj:IsA("BasePart") and obj.Anchored then
                        if obj.Name:find("Coin") or obj.Name == "CoinContainer" then
                            table.insert(coins, obj)
                        end
                    end
                end
                
                if #coins > 0 then
                    -- Берём монету с самым большим расстоянием (обходим всех)
                    local best = coins[1]
                    local maxDist = (root.Position - best.Position).Magnitude
                    
                    for _, coin in coins do
                        local dist = (root.Position - coin.Position).Magnitude
                        if dist > maxDist then
                            maxDist = dist
                            best = coin
                        end
                    end
                    
                    -- Если близко к монете — телепорт прямо на неё
                    if maxDist < 10 then
                        root.CFrame = CFrame.new(best.Position)
                    end
                    
                    -- Летим к самой дальней (чтобы пройти через все)
                    root.Velocity = (best.Position - root.Position).unit * 100
                end
            end
        end
        task.wait(0.05)
    end
end)
