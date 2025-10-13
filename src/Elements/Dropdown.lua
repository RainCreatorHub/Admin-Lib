-- Dropdown.lua - Elemento de dropdown/seleção
local Dropdown = {}

local Services = require(script.Parent.Parent.Components.Services)

function Dropdown:Create(dropdownInfo)
	dropdownInfo = dropdownInfo or {}
	local parent = dropdownInfo.Parent
	local options = dropdownInfo.Options or {}
	local value = dropdownInfo.Default or options[1]

	local DropdownFrame = Instance.new("Frame")
	DropdownFrame.Name = dropdownInfo.Title or "Dropdown"
	DropdownFrame.Size = UDim2.new(1, 0, 0, 60)
	DropdownFrame.BackgroundTransparency = 1
	DropdownFrame.Parent = parent

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, 0, 0, 20)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.SourceSans
	Title.TextColor3 = Services.Colors.Text
	Title.Text = dropdownInfo.Title or "Dropdown"
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = DropdownFrame

	local MainButton = Instance.new("TextButton")
	MainButton.Name = "MainButton"
	MainButton.Size = UDim2.new(1, 0, 0, 35)
	MainButton.Position = UDim2.new(0, 0, 0, 25)
	MainButton.BackgroundColor3 = Services.Colors.Element
	MainButton.Font = Enum.Font.SourceSansBold
	MainButton.TextColor3 = Services.Colors.Text
	MainButton.Text = "  " .. tostring(value)
	MainButton.TextSize = 14
	MainButton.TextXAlignment = Enum.TextXAlignment.Left
	MainButton.Parent = DropdownFrame
	
	Services:CreateCorner(Services.Config.SmallCornerRadius):Parent = MainButton

	local Arrow = Instance.new("TextLabel")
	Arrow.Size = UDim2.new(0, 20, 1, 0)
	Arrow.Position = UDim2.new(1, -25, 0, 0)
	Arrow.BackgroundTransparency = 1
	Arrow.Font = Enum.Font.SourceSansBold
	Arrow.TextColor3 = Services.Colors.Text
	Arrow.Text = "▼"
	Arrow.TextSize = 12
	Arrow.Parent = MainButton

	local OptionsList = Instance.new("ScrollingFrame")
	OptionsList.Name = "OptionsList"
	OptionsList.Size = UDim2.new(1, 0, 0, 0)
	OptionsList.Position = UDim2.new(0, 0, 1, 5)
	OptionsList.BackgroundColor3 = Services.Colors.Element
	OptionsList.BorderSizePixel = 0
	OptionsList.ScrollBarThickness = 4
	OptionsList.ScrollBarImageColor3 = Services.Colors.ElementHover
	OptionsList.Visible = false
	OptionsList.ClipsDescendants = true
	OptionsList.ZIndex = 2
	OptionsList.Parent = MainButton
	
	Services:CreateCorner(Services.Config.SmallCornerRadius):Parent = OptionsList
	
	local OptionsLayout = Instance.new("UIListLayout")
	OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	OptionsLayout.Parent = OptionsList

	local isOpen = false
	for i, option in ipairs(options) do
		local OptionButton = Instance.new("TextButton")
		OptionButton.Name = tostring(option)
		OptionButton.Size = UDim2.new(1, 0, 0, 35)
		OptionButton.BackgroundColor3 = Services.Colors.Element
		OptionButton.Font = Enum.Font.SourceSans
		OptionButton.TextColor3 = Services.Colors.TextDark
		OptionButton.Text = "  " .. tostring(option)
		OptionButton.TextSize = 14
		OptionButton.TextXAlignment = Enum.TextXAlignment.Left
		OptionButton.Parent = OptionsList
		
		OptionButton.MouseEnter:Connect(function() 
			OptionButton.BackgroundColor3 = Services.Colors.ElementHover 
		end)
		OptionButton.MouseLeave:Connect(function() 
			OptionButton.BackgroundColor3 = Services.Colors.Element 
		end)
		
		OptionButton.MouseButton1Click:Connect(function()
			value = option
			MainButton.Text = "  " .. tostring(value)
			if dropdownInfo.Callback then
				dropdownInfo.Callback(value)
			end
			-- Fechar dropdown
			isOpen = false
			OptionsList.Visible = false
			Services:CreateTween(OptionsList, { 
				Size = UDim2.new(1, 0, 0, 0) 
			}):Play()
			Services:CreateTween(Arrow, { Rotation = 0 }):Play()
		end)
	end

	-- Auto ajustar canvas size
	OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		OptionsList.CanvasSize = UDim2.new(0, 0, 0, OptionsLayout.AbsoluteContentSize.Y)
	end)

	MainButton.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		OptionsList.Visible = isOpen
		local listSize = #options * 35
		local targetSize = isOpen and UDim2.new(1, 0, 0, math.min(listSize, 140)) or UDim2.new(1, 0, 0, 0)
		local targetRotation = isOpen and 180 or 0
		
		Services:CreateTween(OptionsList, { Size = targetSize }):Play()
		Services:CreateTween(Arrow, { Rotation = targetRotation }):Play()
	end)

	return DropdownFrame
end

return Dropdown
