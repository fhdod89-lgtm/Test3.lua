local workspace = game.Workspace
local scanning = false

local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 180, 0, 60)
btn.Position = UDim2.new(0.5, -90, 0.6, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "СКАНЕР ВЫКЛ"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Parent = gui

btn.MouseButton1Click:Connect(function()
    scanning = not scanning
    if scanning then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        btn.Text = "СКАНЕР ВКЛ"
        
        local found = {}
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
        
        print("=== ОБЪЕКТЫ ===")
        for _, data in ipairs(sorted) do
            if data.count >= 5 and data.count <= 50 then
                print(data.name .. " x" .. data.count)
            end
        end
        print("=== КОНЕЦ ===")
    else
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        btn.Text = "СКАНЕР ВЫКЛ"
    end
end)
