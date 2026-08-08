local workspace = game.Workspace
local player = game.Players.LocalPlayer
local found = {}
local scanning = false

-- Кнопка
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.5, -75, 0.85, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "СКАНЕР ВЫКЛ"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16
btn.Parent = gui

local function scan()
    found = {}
    for _, obj in workspace:GetDescendants() do
        if obj:IsA("BasePart") then
            local name = obj.Name
            if not found[name] then
                found[name] = 1
            else
                found[name] = found[name] + 1
            end
        end
    end

    local sorted = {}
    for name, count in found do
        table.insert(sorted, {name = name, count = count})
    end
    table.sort(sorted, function(a, b) return a.count < b.count end)

    print("=== ВСЕ ОБЪЕКТЫ НА КАРТЕ ===")
    for _, data in ipairs(sorted) do
        if data.count >= 1 and data.count <= 50 then
            print(data.name .. " | Количество: " .. data.count)
        end
    end
    print("=== КОНЕЦ ===")
end

btn.MouseButton1Click:Connect(function()
    scanning = not scanning
    if scanning then
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        btn.Text = "СКАНЕР ВКЛ"
        scan()
    else
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        btn.Text = "СКАНЕР ВЫКЛ"
    end
end)

-- Автообновление каждые 3 секунды если включен
task.spawn(function()
    while true do
        if scanning then
            scan()
        end
        task.wait(3)
    end
end)
