-- Section.lua - Elemento de seção/container
local Section = {}

local Services = require(script.Parent.Parent.Components.Services)

function Section:Create(sectionInfo)
	sectionInfo = sectionInfo or {}
	local parent = sectionInfo.Parent

	local SectionFrame = Instance.new("Frame")
	SectionFrame.Name = sectionInfo.Title or "Section"
	SectionFrame.Size = UDim2.new(1, 0, 0, 100)
	SectionFrame.BackgroundColor3 = Services.Colors.Element
	SectionFrame.BorderSizePixel = 0
	SectionFrame.Parent = parent
	
	Services:CreateCorner():Parent = SectionFrame

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, -20, 0, 25)
	Title.Position = UDim2.new(0, 10, 0, 5)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.SourceSansBold
	Title.TextColor3 = Services.Colors.Text
	Title.Text = sectionInfo.Title or "Section"
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = SectionFrame

	local Divider = Instance.new("Frame")
	Divider.Name = "Divider"
	Divider.Size = UDim2.new(1, -20, 0, 1)
	Divider.Position = UDim2.new(0, 10, 0, 30)
	Divider.BackgroundColor3 = Services.Colors.ElementHover
	Divider.BorderSizePixel = 0
	Divider.Parent = SectionFrame

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Name = "Content"
	ContentFrame.Size = UDim2.new(1, -20, 1, -40)
	ContentFrame.Position = UDim2.new(0, 10, 0, 35)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Parent = SectionFrame

	local ListLayout = Instance.new("UIListLayout")
	ListLayout.Padding = UDim.new(0, 8)
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Parent = ContentFrame

	-- Auto ajustar altura da seção baseado no conteúdo
	ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		SectionFrame.Size = UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y + 45)
	end)

	return ContentFrame
end

return Section
