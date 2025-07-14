
--// Dino Egg AutoClaim GUI with Inventory Simulation (Grow a Garden Style)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DinoEggAutoClaimGUI"
gui.ResetOnSpawn = false

-- Main GUI Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 160)
main.Position = UDim2.new(0.5, -160, 0.5, -80)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🦕 Dino AutoClaim"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansSemibold
title.TextScaled = true

-- Close Button
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextScaled = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Minimize Button
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -70, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
minBtn.TextColor3 = Color3.new(0, 0, 0)
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextScaled = true
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- AutoClaim Toggle
local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
toggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleBtn.Text = "AutoClaim: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansSemibold
toggleBtn.TextScaled = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- Status Line
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 1, -30)
status.BackgroundTransparency = 1
status.Text = "Status: Disabled"
status.TextColor3 = Color3.fromRGB(200, 50, 50)
status.Font = Enum.Font.SourceSansSemibold
status.TextScaled = true

-- Message Fader (bottom stacked)
local function showMessage(text)
    local msg = Instance.new("TextLabel", gui)
    msg.AnchorPoint = Vector2.new(0.5, 0)
    msg.Position = UDim2.new(0.5, 0, 0.85, 0)
    msg.Size = UDim2.new(0, 400, 0, 30)
    msg.BackgroundTransparency = 1
    msg.Text = text
    msg.TextScaled = true
    msg.TextColor3 = Color3.new(1, 1, 1)
    msg.Font = Enum.Font.SourceSansSemibold
    msg.TextStrokeTransparency = 0.5
    msg.TextStrokeColor3 = Color3.new(0, 0, 0)
    msg.ZIndex = 1000
    msg.TextTransparency = 1
    msg.TextStrokeTransparency = 1

    local offset = 0
    for _, other in ipairs(gui:GetChildren()) do
        if other:IsA("TextLabel") and other ~= msg and other.Position.Y.Scale >= 0.8 then
            offset = offset + 35
        end
    end
    msg.Position = UDim2.new(0.5, 0, 0.85, -offset)

    TweenService:Create(msg, TweenInfo.new(0.25), {
        TextTransparency = 0,
        TextStrokeTransparency = 0.5
    }):Play()

    task.delay(2.5, function()
        TweenService:Create(msg, TweenInfo.new(0.5), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play()
        task.wait(0.5)
        msg:Destroy()
    end)
end

-- Fake Inventory Frame
local inventory = Instance.new("Frame", gui)
inventory.Size = UDim2.new(0, 220, 0, 90)
inventory.Position = UDim2.new(0.5, -110, 1, -100)
inventory.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inventory.BorderSizePixel = 0
inventory.Visible = true
local uicorner = Instance.new("UICorner", inventory)
uicorner.CornerRadius = UDim.new(0, 8)

local uiLayout = Instance.new("UIGridLayout", inventory)
uiLayout.CellSize = UDim2.new(0, 50, 0, 50)
uiLayout.CellPadding = UDim2.new(0, 5, 0, 5)

-- Dino Egg Icon Button
local function addInventoryEgg()
    showMessage("🧬 DNA Machine created Dinosaur Egg...")

    local eggBtn = Instance.new("ImageButton", inventory)
    eggBtn.Name = "DinoEgg"
    eggBtn.Image = "rbxassetid://17340164294" -- Replace with correct Dino Egg image ID
    eggBtn.BackgroundTransparency = 1
    eggBtn.MouseButton1Click:Connect(function()
        -- Egg Preview Frame
        local popup = Instance.new("Frame", gui)
        popup.Size = UDim2.new(0, 200, 0, 200)
        popup.Position = UDim2.new(0.5, -100, 0.5, -100)
        popup.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        popup.ZIndex = 1001
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 12)

        local previewText = Instance.new("TextLabel", popup)
        previewText.Size = UDim2.new(1, 0, 0.2, 0)
        previewText.Position = UDim2.new(0, 0, 0, 0)
        previewText.BackgroundTransparency = 1
        previewText.Text = "Dino Egg"
        previewText.Font = Enum.Font.SourceSansSemibold
        previewText.TextColor3 = Color3.new(1, 1, 1)
        previewText.TextScaled = true

        local eggImage = Instance.new("ImageLabel", popup)
        eggImage.Size = UDim2.new(0.8, 0, 0.6, 0)
        eggImage.Position = UDim2.new(0.1, 0, 0.3, 0)
        eggImage.BackgroundTransparency = 1
        eggImage.Image = "rbxassetid://17340164294"

        task.delay(3, function()
            popup:Destroy()
        end)
    end)
end

-- Toggle AutoClaim
local isRunning = false
toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    toggleBtn.Text = isRunning and "AutoClaim: ON" or "AutoClaim: OFF"
    toggleBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    status.Text = isRunning and "Status: Enabled" or "Status: Disabled"
    status.TextColor3 = isRunning and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(200, 50, 50)

    if isRunning then
        task.spawn(function()
            while isRunning do
                addInventoryEgg()
                task.wait(0.125)
            end
        end)
    end
end)

-- Minimize/Close
minBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(main:GetChildren()) do
        if child:IsA("GuiObject") and child ~= title and child ~= minBtn and child ~= closeBtn then
            child.Visible = not child.Visible
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    isRunning = false
    gui:Destroy()
end)
