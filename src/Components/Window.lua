-- Window.lua - Janela principal com sistema de tabs
local Window = {}

local Services = require(script.Parent.Services)
local Tbar = require(script.Parent.Tbar)

function Window:Create(Info)
	Info = Info or {}
	Info.Size = Info.Size or { 440, 320 }

	local S = Instance.new("ScreenGui")
	S.Name = "AdL"
	S.ResetOnSpawn = false
	S.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	S.Parent = Services.CoreGui

	local Win = Instance.new("Frame")
	Win.Name = "Window"
	Win.Size = UDim2.new(0, Info.Size[1], 0, Info.Size[2])
	Win.Position = UDim2.new(0.5, -Info.Size[1] / 2, 0.5, -Info.Size[2] / 2)
	Win.BackgroundColor3 = Services.Colors.Background
	Win.BorderSizePixel = 0
	Win.ClipsDescendants = true
	Win.Parent = S

	Services:CreateCorner():Parent = Win

	-- Criar barra de título
	local TbarFrame = Tbar:Create(Win, Info, Info.Size)
	
	local WindowObject = {}
	WindowObject.Window = Win
	WindowObject.ScreenGui = S
	
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(0, 100, 1, -TbarFrame.AbsoluteSize.Y)
	TabContainer.Position = UDim2.new(0, 0, 0, TbarFrame.AbsoluteSize.Y)
	TabContainer.BackgroundColor3 = Services.Colors.SideBar
	TabContainer.BorderSizePixel = 0
	TabContainer.Parent = Win
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.Padding = UDim.new(0, 5)
	TabListLayout.Parent = TabContainer
	
	Services:CreatePadding(nil, nil, 10):Parent = TabContainer
	
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, -100, 1, -TbarFrame.AbsoluteSize.Y)
	ContentContainer.Position = UDim2.new(0, 100, 0, TbarFrame.AbsoluteSize.Y)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = Win
	
	local PageLayout = Instance.new("UIPageLayout")
	PageLayout.Parent = ContentContainer
	
	function WindowObject:Tab(tabInfo)
		tabInfo = tabInfo or {}
		
		local ContentFrame = Instance.new("Frame")
		ContentFrame.Name = tabInfo.Title or "Tab"
		ContentFrame.Size = UDim2.new(1, 0, 1, 0)
		ContentFrame.BackgroundTransparency = 1
		ContentFrame.LayoutOrder = #TabContainer:GetChildren()
		ContentFrame.Parent = ContentContainer
		
		local ScrollingFrame = Instance.new("ScrollingFrame")
		ScrollingFrame.Name = "ScrollingFrame"
		ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.ScrollBarThickness = 4
		ScrollingFrame.ScrollBarImageColor3 = Services.Colors.ElementHover
		ScrollingFrame.Parent = ContentFrame
		
		local ListLayout = Instance.new("UIListLayout")
		ListLayout.Padding = UDim.new(0, 10)
		ListLayout.Parent = ScrollingFrame
		
		Services:CreatePadding(10, 10, 10):Parent = ScrollingFrame
		
		-- Auto ajustar tamanho do canvas
		ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
		end)
		
		local TabButton = Instance.new("TextButton")
		TabButton.Name = tabInfo.Title or "Tab"
		TabButton.Size = UDim2.new(1, -10, 0, 25)
		TabButton.Position = UDim2.new(0.5, 0, 0, 0)
		TabButton.AnchorPoint = Vector2.new(0.5, 0)
		TabButton.BackgroundColor3 = TabContainer.BackgroundColor3
		TabButton.TextColor3 = Services.Colors.TextSecondary
		TabButton.Font = Enum.Font.SourceSans
		TabButton.Text = tabInfo.Title or "Tab"
		TabButton.TextSize = 14
		TabButton.Parent = TabContainer
		
		TabButton.MouseButton1Click:Connect(function()
			PageLayout:JumpTo(ContentFrame)
			for _, button in ipairs(TabContainer:GetChildren()) do
				if button:IsA("TextButton") then
					button.Font = Enum.Font.SourceSans
					button.TextColor3 = Services.Colors.TextSecondary
				end
			end
			TabButton.Font = Enum.Font.SourceSansBold
			TabButton.TextColor3 = Services.Colors.Text
		end)
		
		if #TabContainer:GetChildrenOfType("TextButton") == 1 then
			TabButton.MouseButton1Click:Fire()
		end
		
		return ScrollingFrame
	end

	return WindowObject
end

return Window
