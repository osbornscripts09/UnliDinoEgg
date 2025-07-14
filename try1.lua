--// Dino Egg AutoClaim GUI for Grow a Garden
--// Features: Drag GUI, AutoClaim Toggle, 8 eggs/sec, fade-in messages, stacking, close/minimize

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DinoEggAutoClaimGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 160)
main.Position = UDim2.new(0.5, -160, 0.5, -80)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🦕 Dino AutoClaim"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansSemibold
title.TextScaled = true

-- Close Button
local topClose = Instance.new("TextButton", main)
topClose.Size = UDim2.new(0, 30, 0, 30)
topClose.Position = UDim2.new(1, -35, 0, 5)
topClose.Text = "X"
topClose.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
topClose.TextColor3 = Color3.new(1, 1, 1)
topClose.Font = Enum.Font.SourceSansBold
topClose.TextScaled = true
Instance.new("UICorner", topClose).CornerRadius = UDim.new(0, 6)

-- Minimize Button
local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -70, 0, 5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
minimize.TextColor3 = Color3.new(0, 0, 0)
minimize.Font = Enum.Font.SourceSansBold
minimize.TextScaled = true
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)

-- AutoClaim Button
local autoButton = Instance.new("TextButton", main)
autoButton.Size = UDim2.new(0.9, 0, 0, 50)
autoButton.Position = UDim2.new(0.05, 0, 0.4, 0)
autoButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
autoButton.Text = "AutoClaim: OFF"
autoButton.TextColor3 = Color3.new(1, 1, 1)
autoButton.Font = Enum.Font.SourceSansSemibold
autoButton.TextScaled = true
Instance.new("UICorner", autoButton).CornerRadius = UDim.new(0, 8)

-- Status Label
local statusLine = Instance.new("TextLabel", main)
statusLine.Size = UDim2.new(1, 0, 0, 30)
statusLine.Position = UDim2.new(0, 0, 1, -30)
statusLine.BackgroundTransparency = 1
statusLine.Text = "Status: Disabled"
statusLine.TextColor3 = Color3.fromRGB(200, 50, 50)
statusLine.Font = Enum.Font.SourceSansSemibold
statusLine.TextScaled = true

-- Show Message Function
local function showMessage(text)
	local msg = Instance.new("TextLabel")
	msg.AnchorPoint = Vector2.new(0.5, 0)
	msg.Position = UDim2.new(0.5, 0, 0.8, 0)
	msg.Size = UDim2.new(0, 400, 0, 35)
	msg.BackgroundTransparency = 1
	msg.Text = text
	msg.TextScaled = true
	msg.TextColor3 = Color3.new(1, 1, 1)
	msg.Font = Enum.Font.SourceSansSemibold
	msg.TextStrokeTransparency = 0.5
	msg.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	msg.Parent = gui
	msg.ZIndex = 1000
	msg.Visible = true
	msg.TextTransparency = 1
	msg.TextStrokeTransparency = 1

	local offset = 0
	for _, other in ipairs(gui:GetChildren()) do
		if other:IsA("TextLabel") and other ~= msg and other.Position.Y.Scale >= 0.8 then
			offset = offset + 40
		end
	end
	msg.Position = UDim2.new(0.5, 0, 0.8, -offset)

	local tweenService = game:GetService("TweenService")
	local fadeIn = tweenService:Create(msg, TweenInfo.new(0.25), {
		TextTransparency = 0,
		TextStrokeTransparency = 0.5
	})
	fadeIn:Play()

	task.delay(2.5, function()
		local fadeOut = tweenService:Create(msg, TweenInfo.new(0.5), {
			TextTransparency = 1,
			TextStrokeTransparency = 1
		})
		fadeOut:Play()
		fadeOut.Completed:Wait()
		msg:Destroy()
	end)
end

-- Dino Egg Model (basic visual egg)
local function createDinoEgg()
	local model = Instance.new("Model")
	model.Name = "DinoEgg"
	local egg = Instance.new("Part")
	egg.Name = "Main"
	egg.Size = Vector3.new(2, 2.5, 2)
	egg.Shape = Enum.PartType.Ball
	egg.Material = Enum.Material.SmoothPlastic
	egg.Color = Color3.fromRGB(200, 100, 60)
	egg.TopSurface = Enum.SurfaceType.Smooth
	egg.BottomSurface = Enum.SurfaceType.Smooth
	egg.Anchored = true
	egg.CanCollide = false
	egg.Parent = model
	model.PrimaryPart = egg
	return model
end

-- Spawn Dino Egg + Message
local function spawnEgg()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local egg = createDinoEgg()
	egg.Parent = workspace
	egg:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, -5))
	showMessage("🧬 DNA Machine created Dinosaur Egg...")
end

-- AutoClaim Toggle Logic
local isAutoClaim = false
local autoClaimThread

autoButton.MouseButton1Click:Connect(function()
	isAutoClaim = not isAutoClaim
	autoButton.Text = isAutoClaim and "AutoClaim: ON" or "AutoClaim: OFF"
	autoButton.BackgroundColor3 = isAutoClaim and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
	statusLine.Text = isAutoClaim and "Status: Enabled" or "Status: Disabled"
	statusLine.TextColor3 = isAutoClaim and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(200, 50, 50)

	if isAutoClaim then
		autoClaimThread = task.spawn(function()
			while isAutoClaim do
				spawnEgg()
				task.wait(0.125)
			end
		end)
	end
end)

-- Close + Minimize
local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(main:GetChildren()) do
		if child:IsA("GuiObject") and child ~= title and child ~= minimize and child ~= topClose then
			child.Visible = not minimized
		end
	end
end)

topClose.MouseButton1Click:Connect(function()
	isAutoClaim = false
	gui:Destroy()
end)
