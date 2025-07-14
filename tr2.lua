local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Get official inventory UI
local inventory = PlayerGui:WaitForChild("Inventory"):FindFirstChild("Frame") or PlayerGui:WaitForChild("InventoryUI")

-- Dino Egg Wiki image (purely visual)
local DINO_EGG_IMAGE = "https://static.wikia.nocookie.net/growagarden/images/7/74/Dinosauregg.png"

-- ScreenGui
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "DinoAutoClaimUI"
screenGui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 240, 0, 100)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 25)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "DNA Machine"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle Button
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 120, 0, 35)
toggle.Position = UDim2.new(0.5, -60, 0, 40)
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggle.Text = "AutoClaim: OFF"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.AutoButtonColor = false
toggle.BorderSizePixel = 0

-- Toggle animation
local function setToggleState(state)
	if state then
		toggle.BackgroundColor3 = Color3.fromRGB(90, 170, 90)
		toggle.Text = "AutoClaim: ON"
	else
		toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		toggle.Text = "AutoClaim: OFF"
	end
end

-- Close Button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 20, 0, 20)
close.Position = UDim2.new(1, -25, 0, 5)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.BackgroundTransparency = 1

close.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Inventory Handling
local function findNextEmptySlot(container)
	for _, slot in pairs(container:GetChildren()) do
		if slot:IsA("ImageButton") and slot.Image == "" then
			return slot
		end
	end
	return nil
end

local function addDinoEggVisual()
	local slot = findNextEmptySlot(inventory)
	if not slot then return end

	slot.Image = DINO_EGG_IMAGE
	slot.ImageTransparency = 0
	slot.ImageColor3 = Color3.new(1, 1, 1)
	slot.BackgroundTransparency = 0.25

	local flash = Instance.new("ImageLabel")
	flash.Image = DINO_EGG_IMAGE
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.BackgroundTransparency = 1
	flash.ImageTransparency = 0.4
	flash.Parent = slot

	TweenService:Create(flash, TweenInfo.new(1), {ImageTransparency = 1}):Play()
	Debris:AddItem(flash, 1.2)
end

-- Message stacking (visual)
local msgFrame = Instance.new("Frame", screenGui)
msgFrame.Size = UDim2.new(0, 250, 1, -100)
msgFrame.Position = UDim2.new(0.5, -125, 0, 120)
msgFrame.BackgroundTransparency = 1

local function showMessage(text)
	local msg = Instance.new("TextLabel", msgFrame)
	msg.Size = UDim2.new(1, 0, 0, 25)
	msg.Position = UDim2.new(0, 0, 0, #msgFrame:GetChildren() * 28)
	msg.Text = text
	msg.Font = Enum.Font.Gotham
	msg.TextColor3 = Color3.fromRGB(255, 255, 255)
	msg.TextSize = 14
	msg.BackgroundTransparency = 0.3
	msg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	msg.TextXAlignment = Enum.TextXAlignment.Center

	local fade = TweenService:Create(msg, TweenInfo.new(0.3), {TextTransparency = 0})
	fade:Play()

	task.delay(6, function()
		local fadeOut = TweenService:Create(msg, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
		fadeOut:Play()
		Debris:AddItem(msg, 0.6)
	end)
end

-- Toggle Logic
local isRunning = false
toggle.MouseButton1Click:Connect(function()
	isRunning = not isRunning
	setToggleState(isRunning)

	if isRunning then
		task.spawn(function()
			while isRunning do
				addDinoEggVisual()
				showMessage("No DNA Machine created Dinosaur Egg")
				task.wait(0.125)
			end
		end)
	end
end)

-- Initial toggle state
setToggleState(false)
