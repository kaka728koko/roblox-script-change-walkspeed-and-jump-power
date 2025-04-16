-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Local Player
local localPlayer = Players.LocalPlayer
if not localPlayer or not localPlayer.Character or not localPlayer.Character:FindFirstChild("Humanoid") then
    warn("Local player or humanoid not found.")
    return
end
local humanoid = localPlayer.Character:WaitForChild("Humanoid")

-- UI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedJumpControlUI"
screenGui.ResetOnSpawn = false -- Prevent UI from disappearing on respawn
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "ControlFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 210) -- Increased height for jump controls
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Draggable Functionality (for both PC and Mobile)
local dragging = false
local dragInput = nil
local dragStart = nil
local startPosition = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if dragging and input == dragInput then
        dragging = false
        dragInput = nil
    end
end)

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
titleLabel.TextColor3 = Color3.White
titleLabel.Text = "Speed & Jump Control"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextScaled = true
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = mainFrame

-- Walk Speed Section
local walkSpeedLabelTitle = Instance.new("TextLabel")
walkSpeedLabelTitle.Name = "WalkSpeedLabelTitle"
walkSpeedLabelTitle.Size = UDim2.new(0.9, 0, 0.15, 0)
walkSpeedLabelTitle.Position = UDim2.new(0.05, 0, 0.2, 0)
walkSpeedLabelTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
walkSpeedLabelTitle.TextColor3 = Color3.White
walkSpeedLabelTitle.Text = "Walk Speed"
walkSpeedLabelTitle.Font = Enum.Font.SourceSansBold
walkSpeedLabelTitle.TextScaled = true
walkSpeedLabelTitle.TextXAlignment = Enum.TextXAlignment.Left
walkSpeedLabelTitle.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(0.55, 0, 0.15, 0)
speedLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
speedLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedLabel.TextColor3 = Color3.White
speedLabel.Text = "Speed: " .. humanoid.WalkSpeed
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextScaled = true
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(0.35, 0, 0.15, 0)
speedInput.Position = UDim2.new(0.6, 0, 0.35, 0)
speedInput.PlaceholderText = "Enter"
speedInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedInput.TextColor3 = Color3.White
speedInput.Font = Enum.Font.SourceSans
speedInput.TextScaled = true
speedInput.Parent = mainFrame

local function updateWalkSpeed()
    local newSpeed = tonumber(speedInput.Text)
    if newSpeed then
        humanoid.WalkSpeed = newSpeed
        speedLabel.Text = "Speed: " .. math.floor(humanoid.WalkSpeed)
    else
        speedLabel.Text = "Speed: Invalid"
    end
end

speedInput.FocusLost:Connect(updateWalkSpeed)
speedInput.TextBoxFocusReleased:Connect(updateWalkSpeed)

local infiniteSpeedButton = Instance.new("TextButton")
infiniteSpeedButton.Name = "InfiniteSpeedButton"
infiniteSpeedButton.Size = UDim2.new(0.45, 0, 0.15, 0)
infiniteSpeedButton.Position = UDim2.new(0.025, 0, 0.5, 0)
infiniteSpeedButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
infiniteSpeedButton.TextColor3 = Color3.White
infiniteSpeedButton.Text = "Infinite"
infiniteSpeedButton.Font = Enum.Font.SourceSansBold
infiniteSpeedButton.TextScaled = true
infiniteSpeedButton.Parent = mainFrame

infiniteSpeedButton.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = math.huge
    speedInput.Text = "∞"
    speedLabel.Text = "Speed: ∞"
end)

local resetSpeedButton = Instance.new("TextButton")
resetSpeedButton.Name = "ResetSpeedButton"
resetSpeedButton.Size = UDim2.new(0.45, 0, 0.15, 0)
resetSpeedButton.Position = UDim2.new(0.525, 0, 0.5, 0)
resetSpeedButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
resetSpeedButton.TextColor3 = Color3.White
resetSpeedButton.Text = "Reset"
resetSpeedButton.Font = Enum.Font.SourceSansBold
resetSpeedButton.TextScaled = true
resetSpeedButton.Parent = mainFrame

resetSpeedButton.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = 16 -- Default walk speed
    speedInput.Text = "16"
    speedLabel.Text = "Speed: 16"
end)

-- Jump Power Section
local jumpPowerLabelTitle = Instance.new("TextLabel")
jumpPowerLabelTitle.Name = "JumpPowerLabelTitle"
jumpPowerLabelTitle.Size = UDim2.new(0.9, 0, 0.15, 0)
jumpPowerLabelTitle.Position = UDim2.new(0.05, 0, 0.7, 0)
jumpPowerLabelTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpPowerLabelTitle.TextColor3 = Color3.White
jumpPowerLabelTitle.Text = "Jump Power"
jumpPowerLabelTitle.Font = Enum.Font.SourceSansBold
jumpPowerLabelTitle.TextScaled = true
jumpPowerLabelTitle.TextXAlignment = Enum.TextXAlignment.Left
jumpPowerLabelTitle.Parent = mainFrame

local jumpPowerLabel = Instance.new("TextLabel")
jumpPowerLabel.Name = "JumpPowerLabel"
jumpPowerLabel.Size = UDim2.new(0.55, 0, 0.15, 0)
jumpPowerLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
jumpPowerLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
jumpPowerLabel.TextColor3 = Color3.White
jumpPowerLabel.Text = "Power: " .. humanoid.JumpPower
jumpPowerLabel.Font = Enum.Font.SourceSans
jumpPowerLabel.TextScaled = true
jumpPowerLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpPowerLabel.Parent = mainFrame

local jumpPowerInput = Instance.new("TextBox")
jumpPowerInput.Name = "JumpPowerInput"
jumpPowerInput.Size = UDim2.new(0.35, 0, 0.15, 0)
jumpPowerInput.Position = UDim2.new(0.6, 0, 0.85, 0)
jumpPowerInput.PlaceholderText = "Enter"
jumpPowerInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
jumpPowerInput.TextColor3 = Color3.White
jumpPowerInput.Font = Enum.Font.SourceSans
jumpPowerInput.TextScaled = true
jumpPowerInput.Parent = mainFrame

local function updateJumpPower()
    local newPower = tonumber(jumpPowerInput.Text)
    if newPower then
        humanoid.JumpPower = newPower
        jumpPowerLabel.Text = "Power: " .. math.floor(humanoid.JumpPower)
    else
        jumpPowerLabel.Text = "Power: Invalid"
    end
end

jumpPowerInput.FocusLost:Connect(updateJumpPower)
jumpPowerInput.TextBoxFocusReleased:Connect(updateJumpPower)

local infiniteJumpButton = Instance.new("TextButton")
infiniteJumpButton.Name = "InfiniteJumpButton"
infiniteJumpButton.Size = UDim2.new(0.45, 0, 0.15, 0)
infiniteJumpButton.Position = UDim2.new(0.025, 0, 1, 0)
infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
infiniteJumpButton.TextColor3 = Color3.White
infiniteJumpButton.Text = "Infinite"
infiniteJumpButton.Font = Enum.Font.SourceSansBold
infiniteJumpButton.TextScaled = true
infiniteJumpButton.Parent = mainFrame

infiniteJumpButton.MouseButton1Click:Connect(function()
    humanoid.JumpPower = math.huge
    jumpPowerInput.Text = "∞"
    jumpPowerLabel.Text = "Power: ∞"
end)

local resetJumpButton = Instance.new("TextButton")
resetJumpButton.Name = "ResetJumpButton"
resetJumpButton.Size = UDim2.new(0.45, 0, 0.15, 0)
resetJumpButton.Position = UDim2.new(0.525, 0, 1, 0)
resetJumpButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
resetJumpButton.TextColor3 = Color3.White
resetJumpButton.Text = "Reset"
resetJumpButton.Font = Enum.Font.SourceSansBold
resetJumpButton.TextScaled = true
resetJumpButton.Parent = mainFrame

resetJumpButton.MouseButton1Click:Connect(function()
    humanoid.JumpPower = 50 -- Default jump power
    jumpPowerInput.Text = "50"
    jumpPowerLabel.Text = "Power: 50"
end)
