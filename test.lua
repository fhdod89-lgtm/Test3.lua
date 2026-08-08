local player = game.Players.LocalPlayer
local workspace = game.Workspace
local vim = game:GetService("VirtualInputManager")
local cam = workspace.CurrentCamera

local function tap(x, y)
    vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(0.01)
    vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

local function collectCoin(coin)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    root.CFrame = coin.CFrame
    task.wait(0.05)
end

local function findCoins()
    local coins = {}
    for _, obj in workspace:GetDescendants() do
        if obj:IsA("BasePart") and obj.Name == "CoinContainer" then
            table.insert(coins, obj)
        end
    end
    return coins
end

while true do
    local coins = findCoins()
    if #coins > 0 then
        for _, coin in coins do
            if coin and coin.Parent then
                collectCoin(coin)
            end
        end
    end
    task.wait(0.1)
end
