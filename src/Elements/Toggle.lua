-- Toggle.lua - Elemento de toggle/switch
local Toggle = {}

local Services = require(script.Parent.Parent.Components.Services)

function Toggle:Create(toggleInfo)
	toggleInfo = toggleInfo or {}
	local parent = toggleInfo.Parent
	local value = toggleInfo.Default or false

	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Name = toggleInfo.Title or "Toggle"
	ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Parent = parent

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0.8, 0, 1, 0)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.SourceSans
	Title.TextColor3 = Services.Colors.Text
	Title.Text = toggleInfo.Title or "Toggle"
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = ToggleFrame

	local Switch = Instance.new("TextButton")
	Switch.Size = UDim2.new(0.2, 0, 1, 0)
	Switch.Position = UDim2.new(0.8, 0, 0, 0)
	Switch.BackgroundColor3 = Services.Colors.Element
	Switch.Text = ""
	Switch.Parent = ToggleFrame

	Services:CreateCorner():Parent = Switch

	local Knob = Instance.new("Frame")
	Knob.Size = UDim2.new(0, 18, 0, 18)
	Knob.AnchorPoint = Vector2.new(0.5, 0.5)
	Knob.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
	Knob.BorderSizePixel = 0
	Knob.Parent = Switch
	
	Services:CreateCorner(Services.Config.RoundCorner):Parent = Knob

	local function UpdateToggle(isDefault)
		local targetColor = value and Services.Colors.Accent or Services.Colors.Element
		local targetPos = value and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
		
		if isDefault then
			Switch.BackgroundColor3 = targetColor
			Knob.Position = targetPos
		else
			Services:CreateTween(Switch, { BackgroundColor3 = targetColor }):Play()
			Services:CreateTween(Knob, { Position = targetPos }):Play()
		end
		
		if not isDefault and toggleInfo.Callback then
			toggleInfo.Callback(value)
		end
	end
	
	Switch.MouseButton1Click:Connect(function()
		value = not value
		UpdateToggle(false)
	end)
	
	UpdateToggle(true)
	return ToggleFrame
end

return Toggle
