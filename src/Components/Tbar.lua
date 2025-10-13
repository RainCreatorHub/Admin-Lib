-- Tbar.lua - Barra de título com controles
local Tbar = {}

local Services = require(script.Parent.Services)
local Dialog = require(script.Parent.Dialog)

function Tbar:Create(window, info, windowSize)
	local Tbar = Instance.new("Frame")
	Tbar.Name = "Tbar"
	Tbar.Size = UDim2.new(1, 0, 0, 40)
	Tbar.BackgroundColor3 = Services.Colors.Secondary
	Tbar.BorderSizePixel = 0
	Tbar.Parent = window

	Services:CreateCorner():Parent = Tbar

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, -60, 0, 20)
	Title.Position = UDim2.new(0, 10, 0, 3)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.SourceSansBold
	Title.TextColor3 = Services.Colors.Text
	Title.Text = info.Title or "Window Title"
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Tbar

	local SubTitle = Instance.new("TextLabel")
	SubTitle.Name = "SubTitle"
	SubTitle.Size = UDim2.new(1, -60, 0, 15)
	SubTitle.Position = UDim2.new(0, 10, 0, 20)
	SubTitle.BackgroundTransparency = 1
	Title.TextSize = 14
	SubTitle.Font = Enum.Font.SourceSans
	SubTitle.TextColor3 = Services.Colors.TextSecondary
	SubTitle.Text = info.SubTitle or ""
	SubTitle.TextSize = 12
	SubTitle.TextXAlignment = Enum.TextXAlignment.Left
	SubTitle.Parent = Tbar

	local function CreateTbarButton(name, text, position, callback)
		local Btn = Instance.new("TextButton")
		Btn.Name = name
		Btn.Size = UDim2.new(0, 20, 0, 20)
		Btn.Position = UDim2.new(1, position, 0.5, 0)
		Btn.AnchorPoint = Vector2.new(1, 0.5)
		Btn.BackgroundColor3 = Tbar.BackgroundColor3
		Btn.Font = Enum.Font.SourceSansBold
		Btn.TextColor3 = Services.Colors.Text
		Btn.Text = text
		Btn.TextSize = 18
		Btn.Parent = Tbar
		Btn.MouseButton1Click:Connect(callback)
		return Btn
	end

	local isMinimized = false
	local MinButton
	
	local function ToggleMinimize()
		isMinimized = not isMinimized
		local originalSize = UDim2.new(0, windowSize[1], 0, windowSize[2])
		local minimizedSize = UDim2.new(0, windowSize[1], 0, Tbar.AbsoluteSize.Y)

		if isMinimized then
			MinButton.Text = "+"
			local tween = Services:CreateTween(window, { Size = minimizedSize })
			tween:Play()
		else
			MinButton.Text = "–"
			local tween = Services:CreateTween(window, { Size = originalSize })
			tween:Play()
		end
	end

	local CloButton = CreateTbarButton("CloButton", "x", -10, function()
		if isMinimized then
			ToggleMinimize()
			task.wait(0.2)
		end
		if not window:FindFirstChild("DialogueContainer") then
			Dialog:Create(window, {
				Title = "Confirmar",
				Desc = "Você tem certeza que quer fechar a janela?",
				Options = { "Confirmar", "Cancelar" }
			}, windowSize)
		end
	end)

	MinButton = CreateTbarButton("MinButton", "–", -35, ToggleMinimize)
	MinButton.TextSize = 22

	-- Sistema de arrastar
	Tbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if window:FindFirstChild("DialogueContainer") then return end
			local dragStart = input.Position
			local startPos = window.Position
			local connection
			connection = Services.UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					local delta = input.Position - dragStart
					window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
				end
			end)
			Services.UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					connection:Disconnect()
				end
			end)
		end
	end)
	
	return Tbar
end

return Tbar
