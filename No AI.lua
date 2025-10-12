-- Desisto 👍🏻

local Lib = {}

local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local Players = game:GetService("Players")

pcall(function()
	local chat = CoreGui:WaitForChild("Chat", 2)
	if chat then chat:Destroy() end
end)

function Lib:Window(props)
	props = props or {}
	local newWindow = {}
	setmetatable(newWindow, { __index = self })

	local sizeX = (props.Size and props.Size[1]) or 500
	local sizeY = (props.Size and props.Size[2]) or 380

	local gui = Instance.new("ScreenGui")
	gui.Name = props.Name or "Window"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local frame = Instance.new("Frame")
	frame.Name = "WindowFrame"
	frame.Size = UDim2.fromOffset(sizeX, sizeY)
	frame.Position = UDim2.new(0.5, -sizeX / 2, 0.5, -sizeY / 2)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local topBar = Instance.new("Frame")
	topBar.Name = "TitleBar"
	topBar.Size = UDim2.new(1, 0, 0, 50)
	topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	topBar.BorderSizePixel = 0
	topBar.Parent = frame

	local title = Instance.new("TextLabel")
	title.Name = "TitleLabel"
	title.Size = UDim2.new(1, -10, 0, 28)
	title.Position = UDim2.fromOffset(5, 4)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.SourceSansBold
	title.Text = props.Title or "Window"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = topBar

	local subTitle = Instance.new("TextLabel")
	subTitle.Name = "SubTitleLabel"
	subTitle.Size = UDim2.new(1, -10, 0, 15)
	subTitle.Position = UDim2.fromOffset(5, 28)
	subTitle.BackgroundTransparency = 1
	subTitle.Font = Enum.Font.SourceSans
	subTitle.Text = props.SubTitle or ""
	subTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
	subTitle.TextSize = 12
	subTitle.TextXAlignment = Enum.TextXAlignment.Left
	subTitle.Parent = topBar

	if props.PInfo and props.PInfo.Enabled then
		local pinfo = props.PInfo
		local player = Players.LocalPlayer
		local text = "Player: " .. (pinfo.Anonymous and "Anonymous" or player.Name)
		
		local pinfoLabel = Instance.new("TextLabel")
		pinfoLabel.Name = "PlayerInfoLabel"
		pinfoLabel.Size = UDim2.new(1, -10, 0, 30)
		pinfoLabel.Position = UDim2.new(0, 5, 1, -30)
		pinfoLabel.AnchorPoint = Vector2.new(0, 1)
		pinfoLabel.BackgroundTransparency = 1
		pinfoLabel.Font = Enum.Font.SourceSans
		pinfoLabel.Text = text
		pinfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		pinfoLabel.TextSize = 12
		pinfoLabel.TextXAlignment = Enum.TextXAlignment.Right
		pinfoLabel.Parent = topBar
		
		if pinfo.Callback and typeof(pinfo.Callback) == "function" then
			pinfo.Callback(player)
		end
	end

	self.Elements = { Frame = frame }

	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local startPos = frame.Position
			local dragStart = input.Position
			local moveConn
			moveConn = UserInput.InputChanged:Connect(function(moveInput)
				if moveInput.UserInputType == input.UserInputType then
					frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (moveInput.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (moveInput.Position.Y - dragStart.Y))
				end
			end)
			UserInput.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == input.UserInputType then
					moveConn:Disconnect()
				end
			end)
		end
	end)

	gui.Parent = CoreGui
	return newWindow
end

function Lib:Label(Info)
	Info = Info or {}
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromOffset((Info.Size and Info.Size[1]) or 120, (Info.Size and Info.Size[2]) or 20)
	label.Position = UDim2.fromOffset((Info.Pos and Info.Pos[1]) or 10, (Info.Pos and Info.Pos[2]) or 60)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.Text = Info.Name or "Default Label"
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = self.Elements.Frame
	return label
end

return Lib
