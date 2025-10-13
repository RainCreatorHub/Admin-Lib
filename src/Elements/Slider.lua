-- Slider.lua - Elemento de slider
local Slider = {}

local Services = require(script.Parent.Parent.Components.Services)

function Slider:Create(sliderInfo)
	sliderInfo = sliderInfo or {}
	local parent = sliderInfo.Parent
	local min = sliderInfo.Min or 0
	local max = sliderInfo.Max or 100
	local value = sliderInfo.Default or min

	local SliderFrame = Instance.new("Frame")
	SliderFrame.Name = sliderInfo.Title or "Slider"
	SliderFrame.Size = UDim2.new(1, 0, 0, 40)
	SliderFrame.BackgroundTransparency = 1
	SliderFrame.Parent = parent

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0.7, 0, 0, 20)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.SourceSans
	Title.TextColor3 = Services.Colors.Text
	Title.Text = sliderInfo.Title or "Slider"
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = SliderFrame

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.new(0.3, 0, 0, 20)
	ValueLabel.Position = UDim2.new(0.7, 0, 0, 0)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Font = Enum.Font.SourceSansBold
	ValueLabel.TextColor3 = Services.Colors.Text
	ValueLabel.TextSize = 14
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Parent = SliderFrame

	local Track = Instance.new("Frame")
	Track.Size = UDim2.new(1, 0, 0, 8)
	Track.Position = UDim2.new(0, 0, 0, 25)
	Track.BackgroundColor3 = Services.Colors.Element
	Track.BorderSizePixel = 0
	Track.Parent = SliderFrame
	
	Services:CreateCorner(Services.Config.RoundCorner):Parent = Track

	local Fill = Instance.new("Frame")
	Fill.BackgroundColor3 = Services.Colors.Accent
	Fill.BorderSizePixel = 0
	Fill.Parent = Track
	
	Services:CreateCorner(Services.Config.RoundCorner):Parent = Fill

	local function UpdateSlider(x)
		local trackWidth = Track.AbsoluteSize.X
		if trackWidth == 0 then return end
		local percent = math.clamp((x - Track.AbsolutePosition.X) / trackWidth, 0, 1)
		value = min + (max - min) * percent
		local roundedValue = tonumber(string.format(sliderInfo.Format or "%.0f", value))
		Fill.Size = UDim2.new(percent, 0, 1, 0)
		ValueLabel.Text = tostring(roundedValue)
		if sliderInfo.Callback then
			sliderInfo.Callback(roundedValue)
		end
	end
	
	task.wait()
	UpdateSlider(Track.AbsolutePosition.X + Track.AbsoluteSize.X * ((value - min) / (max - min)))

	Track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			UpdateSlider(input.Position.X)
			local connection
			connection = Services.UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					UpdateSlider(input.Position.X)
				end
			end)
			Services.UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					connection:Disconnect()
				end
			end)
		end
	end)

	return SliderFrame
end

return Slider
