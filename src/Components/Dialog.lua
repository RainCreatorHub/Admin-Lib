-- Dialog.lua - Sistema de diálogos de confirmação
local Dialog = {}

local Services = require(script.Parent.Services)

function Dialog:Create(window, info, windowSize)
	local viewportSize = workspace.CurrentCamera.ViewportSize
	local targetPosition = UDim2.new(0, (viewportSize.X - windowSize[1]) / 2, 0, (viewportSize.Y - windowSize[2]) / 2)
	
	local moveTween = Services:CreateTween(window, { Position = targetPosition })
	moveTween:Play()

	local DialogueContainer = Instance.new("Frame")
	DialogueContainer.Name = "DialogueContainer"
	DialogueContainer.Size = UDim2.new(1, 0, 1, -30)
	DialogueContainer.Position = UDim2.new(0, 0, 0, 30)
	DialogueContainer.BackgroundColor3 = Services.Colors.Overlay
	DialogueContainer.BackgroundTransparency = 0.3
	DialogueContainer.Parent = window

	local DialogueFrame = Instance.new("Frame")
	DialogueFrame.Name = "Dialogue"
	DialogueFrame.Size = UDim2.new(0, 280, 0, 150)
	DialogueFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	DialogueFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	DialogueFrame.BackgroundColor3 = Services.Colors.Element
	DialogueFrame.BorderSizePixel = 0
	DialogueFrame.Parent = DialogueContainer

	Services:CreateCorner():Parent = DialogueFrame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -20, 0, 30)
	Title.Position = UDim2.new(0, 10, 0, 10)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.SourceSansBold
	Title.TextColor3 = Services.Colors.Text
	Title.Text = info.Title or "Info"
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextYAlignment = Enum.TextYAlignment.Top
	Title.Parent = DialogueFrame

	local Desc = Instance.new("TextLabel")
	Desc.Size = UDim2.new(1, -20, 0, 50)
	Desc.Position = UDim2.new(0, 10, 0, 40)
	Desc.BackgroundTransparency = 1
	Desc.Font = Enum.Font.SourceSans
	Desc.TextColor3 = Services.Colors.TextDark
	Desc.Text = info.Desc or "Description"
	Desc.TextSize = 14
	Desc.TextWrapped = true
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.TextYAlignment = Enum.TextYAlignment.Top
	Desc.Parent = DialogueFrame

	local ButtonContainer = Instance.new("Frame")
	ButtonContainer.Size = UDim2.new(1, 0, 0, 30)
	ButtonContainer.Position = UDim2.new(0, 0, 1, -40)
	ButtonContainer.BackgroundTransparency = 1
	ButtonContainer.Parent = DialogueFrame

	local ListLayout = Instance.new("UIListLayout")
	ListLayout.FillDirection = Enum.FillDirection.Horizontal
	ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Padding = UDim.new(0, 10)
	ListLayout.Parent = ButtonContainer

	Services:CreatePadding(nil, 10):Parent = ButtonContainer

	local function CreateButton(text, layoutOrder, isConfirm)
		local Btn = Instance.new("TextButton")
		Btn.Name = text
		Btn.Size = UDim2.new(0, 100, 1, 0)
		Btn.BackgroundColor3 = isConfirm and Services.Colors.ElementHover or Services.Colors.Element
		Btn.TextColor3 = Services.Colors.Text
		Btn.Font = Enum.Font.SourceSansBold
		Btn.Text = text
		Btn.TextSize = 14
		Btn.LayoutOrder = layoutOrder
		Btn.Parent = ButtonContainer

		Services:CreateCorner(Services.Config.SmallCornerRadius):Parent = Btn

		Btn.MouseButton1Click:Connect(function()
			if isConfirm then
				window.Parent:Destroy()
			else
				DialogueContainer:Destroy()
			end
		end)
	end

	CreateButton(info.Options[2] or "Cancel", 2, false)
	CreateButton(info.Options[1] or "Confirm", 1, true)
	
	return DialogueContainer
end

return Dialog
