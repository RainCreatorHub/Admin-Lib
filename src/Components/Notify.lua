-- Notify.lua - Sistema de notificações
local Notify = {}

local Services = require(script.Parent.Services)

function Notify:Create(info)
	info = info or {}
	
	local ScreenGui = Services.CoreGui:FindFirstChild("AdLNotifications")
	if not ScreenGui then
		ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "AdLNotifications"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Parent = Services.CoreGui
		
		local Container = Instance.new("Frame")
		Container.Name = "Container"
		Container.Size = UDim2.new(0, 300, 1, -20)
		Container.Position = UDim2.new(1, -310, 0, 10)
		Container.BackgroundTransparency = 1
		Container.Parent = ScreenGui
		
		local ListLayout = Instance.new("UIListLayout")
		ListLayout.Padding = UDim.new(0, 10)
		ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		ListLayout.Parent = Container
	end
	
	local Container = ScreenGui:FindFirstChild("Container")
	
	local Notification = Instance.new("Frame")
	Notification.Size = UDim2.new(1, 0, 0, 80)
	Notification.BackgroundColor3 = Services.Colors.Element
	Notification.BorderSizePixel = 0
	Notification.Parent = Container
	
	Services:CreateCorner():Parent = Notification
	
	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -20, 0, 25)
	Title.Position = UDim2.new(0, 10, 0, 10)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.SourceSansBold
	Title.TextColor3 = Services.Colors.Text
	Title.Text = info.Title or "Notification"
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextYAlignment = Enum.TextYAlignment.Top
	Title.Parent = Notification
	
	local Description = Instance.new("TextLabel")
	Description.Size = UDim2.new(1, -20, 0, 35)
	Description.Position = UDim2.new(0, 10, 0, 35)
	Description.BackgroundTransparency = 1
	Description.Font = Enum.Font.SourceSans
	Description.TextColor3 = Services.Colors.TextDark
	Description.Text = info.Description or ""
	Description.TextSize = 13
	Description.TextWrapped = true
	Description.TextXAlignment = Enum.TextXAlignment.Left
	Description.TextYAlignment = Enum.TextYAlignment.Top
	Description.Parent = Notification
	
	-- Animação de entrada
	Notification.Position = UDim2.new(1, 0, 0, 0)
	local slideTween = Services:CreateTween(Notification, {
		Position = UDim2.new(0, 0, 0, 0)
	})
	slideTween:Play()
	
	-- Auto destruir
	local duration = info.Duration or 5
	task.delay(duration, function()
		if Notification and Notification.Parent then
			local fadeOut = Services:CreateTween(Notification, {
				Position = UDim2.new(1, 0, 0, 0)
			})
			fadeOut:Play()
			fadeOut.Completed:Connect(function()
				Notification:Destroy()
			end)
		end
	end)
	
	return Notification
end

return Notify
