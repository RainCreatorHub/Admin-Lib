-- Button.lua - Elemento de botão
local Button = {}

local Services = require(script.Parent.Parent.Components.Services)

function Button:Create(buttonInfo)
	buttonInfo = buttonInfo or {}
	local parent = buttonInfo.Parent
	
	local Btn = Instance.new("TextButton")
	Btn.Name = buttonInfo.Title or "Button"
	Btn.Size = UDim2.new(1, 0, 0, 35)
	Btn.BackgroundColor3 = Services.Colors.Element
	Btn.TextColor3 = Services.Colors.Text
	Btn.Font = Enum.Font.SourceSansBold
	Btn.Text = buttonInfo.Title or "Button"
	Btn.TextSize = 14
	Btn.Parent = parent
	
	Services:CreateCorner(Services.Config.SmallCornerRadius):Parent = Btn
	
	-- Efeito hover
	Btn.MouseEnter:Connect(function()
		Services:CreateTween(Btn, { 
			BackgroundColor3 = Services.Colors.ElementHover 
		}, Services.Config.FastTweenInfo):Play()
	end)
	
	Btn.MouseLeave:Connect(function()
		Services:CreateTween(Btn, { 
			BackgroundColor3 = Services.Colors.Element 
		}, Services.Config.FastTweenInfo):Play()
	end)
	
	if buttonInfo.Callback then
		Btn.MouseButton1Click:Connect(buttonInfo.Callback)
	end
	
	return Btn
end

return Button
