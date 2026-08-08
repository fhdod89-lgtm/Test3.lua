local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local cam = workspace.CurrentCamera
local autoAccept = false
local freeze = false

-- GUI панель
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

-- Кнопка ЗАМОРОЗКА
local freezeBtn = Instance.new("TextButton")
freezeBtn.Size = UDim2.new(0, 160, 0, 55)
freezeBtn.Position = UDim2.new(0.5, -80, 0.65, 0)
freezeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
freezeBtn.Text = "ЗАМОРОЗКА: ВЫКЛ"
freezeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
freezeBtn.Font = Enum.Font.SourceSansBold
freezeBtn.TextSize = 14
freezeBtn.Parent = gui

-- Кнопка АВТО-АЦЕПТ
local acceptBtn = Instance.new("TextButton")
acceptBtn.Size = UDim2.new(0, 160, 0, 55)
acceptBtn.Position = UDim2.new(0.5, -80, 0.75, 0)
acceptBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
acceptBtn.Text = "АВТО-АЦЕПТ: ВЫКЛ"
acceptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
acceptBtn.Font = Enum.Font.SourceSansBold
acceptBtn.TextSize = 14
acceptBtn.Parent = gui

-- Функция тапа
local function tap(x, y)
    vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(0.01)
    vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

-- Поиск трейда
local function findTrade()
    for _, obj in player.PlayerGui:GetDescendants() do
        if obj:IsA("Frame") and obj.Name:lower():find("trade") then return obj end
    end
    for _, obj in game.CoreGui:GetDescendants() do
        if obj:IsA("Frame") and obj.Name:lower():find("trade") then return obj end
    end
    return nil
end

-- Проверка предметов у врага
local function enemyHasItems(trade)
    local right = trade.AbsolutePosition.X + trade.AbsoluteSize.X * 0.5
    for _, obj in trade:GetDescendants() do
        if obj:IsA("ImageLabel") and obj.Visible and obj.AbsolutePosition.X > right and obj.ImageTransparency < 0.9 then
            return true
        end
    end
    return false
end

-- Заморозка: не даёт жертве отменить трейд
local function freezeTrade()
    if not freeze then return end
    local trade = findTrade()
    if trade then
        -- Постоянно жмём Accept чтобы трейд не закрылся
        local sw, sh = cam.ViewportSize.X, cam.ViewportSize.Y
        tap(sw * 0.5, sh * 0.72)
    end
end

-- Кнопка ЗАМОРОЗКА
freezeBtn.MouseButton1Click:Connect(function()
    freeze = not freeze
    if freeze then
        freezeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        freezeBtn.Text = "ЗАМОРОЗКА: ВКЛ"
    else
        freezeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        freezeBtn.Text = "ЗАМОРОЗКА: ВЫКЛ"
    end
end)

-- Кнопка АВТО-АЦЕПТ
acceptBtn.MouseButton1Click:Connect(function()
    autoAccept = not autoAccept
    if autoAccept then
        acceptBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        acceptBtn.Text = "АВТО-АЦЕПТ: ВКЛ"
    else
        acceptBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        acceptBtn.Text = "АВТО-АЦЕПТ: ВЫКЛ"
    end
end)

-- Главный цикл
local accepted = false

task.spawn(function()
    while true do
        local trade = findTrade()
        
        if trade then
            -- Заморозка
            if freeze then
                local sw, sh = cam.ViewportSize.X, cam.ViewportSize.Y
                tap(sw * 0.5, sh * 0.72)
            end
            
            -- Авто-ацепт
            if autoAccept and enemyHasItems(trade) and not accepted then
                task.wait(0.3)
                local sw, sh = cam.ViewportSize.X, cam.ViewportSize.Y
                tap(sw * 0.5, sh * 0.72)
                task.wait(0.08)
                tap(sw * 0.65, sh * 0.72)
                accepted = true
                
                task.wait(0.6)
                tap(sw * 0.5, sh * 0.72)
                task.wait(0.08)
                tap(sw * 0.65, sh * 0.72)
            end
        else
            accepted = false
        end
        
        task.wait(0.1)
    end
end)
