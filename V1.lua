-- ============================================
-- AdminLib - UI Library Completa para Roblox
-- Versão: 1.0.0
-- Suporte a Icons (ImageId ou Emoji)
-- ============================================

local AdminLib = {}
AdminLib.__index = AdminLib
AdminLib._VERSION = "1.0.0"

-- Serviços
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ============================================
-- UTILIDADES
-- ============================================

local Utility = {}

function Utility:Tween(obj, props, duration, callback)
    duration = duration or 0.3
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, props)
    if callback then
        tween.Completed:Connect(callback)
    end
    tween:Play()
    return tween
end

function Utility:MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Utility:CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

function Utility:CreateIcon(parent, icon, size, position)
    size = size or {30, 30}
    position = position or {0, 10, 0, 10}
    
    if not icon then
        return nil
    end
    
    -- Verificar se é número (ImageId)
    if tonumber(icon) then
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Size = UDim2.new(0, size[1], 0, size[2])
        imageLabel.Position = UDim2.new(position[1], position[2], position[3], position[4])
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = "rbxassetid://" .. tostring(icon)
        imageLabel.ScaleType = Enum.ScaleType.Fit
        imageLabel.Parent = parent
        return imageLabel
    else
        -- É emoji ou texto
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(0, size[1], 0, size[2])
        textLabel.Position = UDim2.new(position[1], position[2], position[3], position[4])
        textLabel.BackgroundTransparency = 1
        textLabel.Text = icon
        textLabel.TextSize = size[1] * 0.7
        textLabel.Font = Enum.Font.GothamBold
        textLabel.Parent = parent
        return textLabel
    end
end

-- ============================================
-- THEMES
-- ============================================

local Themes = {
    Dark = {
        Primary = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Tertiary = Color3.fromRGB(40, 40, 45),
        Accent = Color3.fromRGB(88, 166, 255),
        AccentHover = Color3.fromRGB(108, 186, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 170),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(237, 66, 69),
        Border = Color3.fromRGB(50, 50, 55),
        Toggle = Color3.fromRGB(65, 190, 255)
    }
}

-- ============================================
-- WINDOW
-- ============================================

local Window = {}
Window.__index = Window

function AdminLib:Window(config)
    config = config or {}
    
    local self = setmetatable({}, Window)
    self.Title = config.Title or "AdminLib"
    self.SubTitle = config.SubTitle or ""
    self.Size = config.Size or {470, 340}
    self.Theme = Themes.Dark
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:CreateUI()
    
    return self
end

function Window:CreateUI()
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AdminLib"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = CoreGui
    
    -- Main Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Size = UDim2.new(0, self.Size[1], 0, self.Size[2])
    self.Container.Position = UDim2.new(0.5, -self.Size[1]/2, 0.5, -self.Size[2]/2)
    self.Container.BackgroundColor3 = self.Theme.Primary
    self.Container.BorderSizePixel = 0
    self.Container.ClipsDescendants = true
    self.Container.Parent = self.ScreenGui
    
    Utility:CreateCorner(self.Container, 12)
    
    -- Header
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 60)
    self.Header.BackgroundColor3 = self.Theme.Secondary
    self.Header.BorderSizePixel = 0
    self.Header.Parent = self.Container
    
    Utility:CreateCorner(self.Header, 12)
    
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 12)
    headerFix.Position = UDim2.new(0, 0, 1, -12)
    headerFix.BackgroundColor3 = self.Theme.Secondary
    headerFix.BorderSizePixel = 0
    headerFix.Parent = self.Header
    
    -- Icon (Padrão: emoji 🔥)
    Utility:CreateIcon(self.Header, "🔥", {40, 40}, {0, 15, 0, 10})
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -150, 0, 24)
    title.Position = UDim2.new(0, 60, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = self.Title
    title.TextColor3 = self.Theme.Text
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Header
    
    -- SubTitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -150, 0, 18)
    subtitle.Position = UDim2.new(0, 60, 0, 32)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = self.SubTitle
    subtitle.TextColor3 = self.Theme.SubText
    subtitle.TextSize = 13
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = self.Header
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0, 12)
    closeBtn.BackgroundColor3 = self.Theme.Error
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 22
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = self.Header
    
    Utility:CreateCorner(closeBtn, 8)
    
    closeBtn.MouseEnter:Connect(function()
        Utility:Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 90, 90)}, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        Utility:Tween(closeBtn, {BackgroundColor3 = self.Theme.Error}, 0.2)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Tab Navigation
    self.Navigation = Instance.new("ScrollingFrame")
    self.Navigation.Name = "Navigation"
    self.Navigation.Size = UDim2.new(0, 140, 1, -80)
    self.Navigation.Position = UDim2.new(0, 10, 0, 70)
    self.Navigation.BackgroundTransparency = 1
    self.Navigation.BorderSizePixel = 0
    self.Navigation.ScrollBarThickness = 4
    self.Navigation.ScrollBarImageColor3 = self.Theme.Accent
    self.Navigation.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Navigation.Parent = self.Container
    
    local navList = Instance.new("UIListLayout")
    navList.SortOrder = Enum.SortOrder.LayoutOrder
    navList.Padding = UDim.new(0, 8)
    navList.Parent = self.Navigation
    
    navList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Navigation.CanvasSize = UDim2.new(0, 0, 0, navList.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, -165, 1, -80)
    self.ContentArea.Position = UDim2.new(0, 155, 0, 70)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.ClipsDescendants = true
    self.ContentArea.Parent = self.Container
    
    -- Draggable
    Utility:MakeDraggable(self.Container, self.Header)
end

function Window:Destroy()
    Utility:Tween(self.Container, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, function()
        self.ScreenGui:Destroy()
    end)
end

-- ============================================
-- NOTIFY
-- ============================================

function Window:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local desc = config.Desc or ""
    local icon = config.Icon or "ℹ️"
    local time = config.Time or 3
    local options = config.Options or {}
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 0)
    notif.Position = UDim2.new(1, -320, 1, -20)
    notif.BackgroundColor3 = self.Theme.Secondary
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = self.ScreenGui
    
    Utility:CreateCorner(notif, 10)
    
    -- Icon
    Utility:CreateIcon(notif, icon, {40, 40}, {0, 10, 0, 10})
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -65, 0, 20)
    titleLabel.Position = UDim2.new(0, 55, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = notif
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -65, 0, 18)
    descLabel.Position = UDim2.new(0, 55, 0, 32)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = self.Theme.SubText
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = notif
    
    local contentHeight = 60
    
    if #options > 0 then
        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, -20, 0, 35)
        btnContainer.Position = UDim2.new(0, 10, 0, 60)
        btnContainer.BackgroundTransparency = 1
        btnContainer.Parent = notif
        
        local btnList = Instance.new("UIListLayout")
        btnList.FillDirection = Enum.FillDirection.Horizontal
        btnList.HorizontalAlignment = Enum.HorizontalAlignment.Right
        btnList.Padding = UDim.new(0, 8)
        btnList.Parent = btnContainer
        
        for _, option in ipairs(options) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 80, 0, 30)
            btn.BackgroundColor3 = self.Theme.Accent
            btn.Text = ""
            btn.TextColor3 = self.Theme.Text
            btn.TextSize = 12
            btn.Font = Enum.Font.GothamMedium
            btn.Parent = btnContainer
            
            Utility:CreateCorner(btn, 6)
            
            if option.Icon then
                Utility:CreateIcon(btn, option.Icon, {20, 20}, {0, 5, 0, 5})
                
                local btnText = Instance.new("TextLabel")
                btnText.Size = UDim2.new(1, -30, 1, 0)
                btnText.Position = UDim2.new(0, 28, 0, 0)
                btnText.BackgroundTransparency = 1
                btnText.Text = option.Title
                btnText.TextColor3 = self.Theme.Text
                btnText.TextSize = 12
                btnText.Font = Enum.Font.GothamMedium
                btnText.TextXAlignment = Enum.TextXAlignment.Left
                btnText.Parent = btn
            else
                btn.Text = option.Title
            end
            
            btn.MouseButton1Click:Connect(function()
                if option.Callback then
                    option.Callback()
                end
                notif:Destroy()
            end)
        end
        
        contentHeight = 105
    end
    
    notif.Size = UDim2.new(0, 300, 0, contentHeight)
    Utility:Tween(notif, {Position = UDim2.new(1, -320, 1, -contentHeight - 20)}, 0.5)
    
    task.wait(time)
    Utility:Tween(notif, {Position = UDim2.new(1, -320, 1, -20)}, 0.5, function()
        notif:Destroy()
    end)
end

-- ============================================
-- DIALOG
-- ============================================

function Window:Dialog(config)
    config = config or {}
    local title = config.Title or "Dialog"
    local desc = config.Desc or ""
    local icon = config.Icon or "❓"
    local options = config.Options or {}
    
    local dialog = {}
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Visible = false
    overlay.Parent = self.ScreenGui
    
    local dialogFrame = Instance.new("Frame")
    dialogFrame.Size = UDim2.new(0, 350, 0, 0)
    dialogFrame.Position = UDim2.new(0.5, -175, 0.5, 0)
    dialogFrame.BackgroundColor3 = self.Theme.Secondary
    dialogFrame.BorderSizePixel = 0
    dialogFrame.ClipsDescendants = true
    dialogFrame.Parent = overlay
    
    Utility:CreateCorner(dialogFrame, 12)
    
    -- Icon
    Utility:CreateIcon(dialogFrame, icon, {60, 60}, {0.5, -30, 0, 20})
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 25)
    titleLabel.Position = UDim2.new(0, 20, 0, 90)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = dialogFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -40, 0, 40)
    descLabel.Position = UDim2.new(0, 20, 0, 120)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = self.Theme.SubText
    descLabel.TextSize = 13
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextWrapped = true
    descLabel.Parent = dialogFrame
    
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, -40, 0, 40)
    btnContainer.Position = UDim2.new(0, 20, 0, 170)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = dialogFrame
    
    local btnList = Instance.new("UIListLayout")
    btnList.FillDirection = Enum.FillDirection.Horizontal
    btnList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnList.Padding = UDim.new(0, 10)
    btnList.Parent = btnContainer
    
    for _, option in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 120, 0, 38)
        btn.BackgroundColor3 = self.Theme.Accent
        btn.Text = ""
        btn.TextColor3 = self.Theme.Text
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = btnContainer
        
        Utility:CreateCorner(btn, 8)
        
        if option.Icon then
            Utility:CreateIcon(btn, option.Icon, {24, 24}, {0, 10, 0, 7})
            
            local btnText = Instance.new("TextLabel")
            btnText.Size = UDim2.new(1, -44, 1, 0)
            btnText.Position = UDim2.new(0, 38, 0, 0)
            btnText.BackgroundTransparency = 1
            btnText.Text = option.Title
            btnText.TextColor3 = self.Theme.Text
            btnText.TextSize = 13
            btnText.Font = Enum.Font.GothamMedium
            btnText.TextXAlignment = Enum.TextXAlignment.Left
            btnText.Parent = btn
        else
            btn.Text = option.Title
        end
        
        btn.MouseButton1Click:Connect(function()
            if option.Callback then
                option.Callback()
            end
            dialog:Hide()
        end)
    end
    
    function dialog:Show()
        overlay.Visible = true
        Utility:Tween(overlay, {BackgroundTransparency = 0.5}, 0.3)
        Utility:Tween(dialogFrame, {Size = UDim2.new(0, 350, 0, 220), Position = UDim2.new(0.5, -175, 0.5, -110)}, 0.3)
    end
    
    function dialog:Hide()
        Utility:Tween(overlay, {BackgroundTransparency = 1}, 0.3)
        Utility:Tween(dialogFrame, {Size = UDim2.new(0, 350, 0, 0), Position = UDim2.new(0.5, -175, 0.5, 0)}, 0.3, function()
            overlay.Visible = false
        end)
    end
    
    return dialog
end

-- ============================================
-- TAB
-- ============================================

function Window:Tab(config)
    config = config or {}
    local name = config.Name or "Tab"
    local icon = config.Icon or "📁"
    
    local tab = {}
    tab.Name = name
    tab.Sections = {}
    tab.Selected = false
    
    -- Tab Button
    tab.Button = Instance.new("TextButton")
    tab.Button.Size = UDim2.new(1, 0, 0, 45)
    tab.Button.BackgroundColor3 = self.Theme.Tertiary
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = ""
    tab.Button.Parent = self.Navigation
    
    Utility:CreateCorner(tab.Button, 10)
    
    -- Icon
    Utility:CreateIcon(tab.Button, icon, {30, 30}, {0, 8, 0, 7.5})
    
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -48, 1, 0)
    tabLabel.Position = UDim2.new(0, 43, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = name
    tabLabel.TextColor3 = self.Theme.Text
    tabLabel.TextSize = 14
    tabLabel.Font = Enum.Font.GothamMedium
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.TextTruncate = Enum.TextTruncate.AtEnd
    tabLabel.Parent = tab.Button
    
    -- Tab Content
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 4
    tab.Content.ScrollBarImageColor3 = self.Theme.Accent
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentArea
    
    local contentList = Instance.new("UIListLayout")
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, 10)
    contentList.Parent = tab.Content
    
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
    end)
    
    -- Select Tab
    function tab:Select()
        for _, t in pairs(self.Window.Tabs) do
            t.Button.BackgroundColor3 = self.Window.Theme.Tertiary
            t.Content.Visible = false
            t.Selected = false
        end
        tab.Button.BackgroundColor3 = self.Window.Theme.Accent
        tab.Content.Visible = true
        tab.Selected = true
        self.Window.CurrentTab = tab
    end
    
    tab.Button.MouseButton1Click:Connect(function()
        tab:Select()
    end)
    
    tab.Window = self
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        tab:Select()
    end
    
    -- ============================================
    -- SECTION
    -- ============================================
    
    function tab:Section(config)
        config = config or {}
        local name = config.Name or "Section"
        local desc = config.Desc or ""
        local icon = config.Icon
        local opened = config.Opened ~= false
        
        local section = {}
        section.Elements = {}
        
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Size = UDim2.new(1, 0, 0, 0)
        sectionFrame.BackgroundColor3 = self.Window.Theme.Secondary
        sectionFrame.BorderSizePixel = 0
        sectionFrame.Parent = tab.Content
        
        Utility:CreateCorner(sectionFrame, 10)
        
        -- Header
        local header = Instance.new("TextButton")
        header.Size = UDim2.new(1, 0, 0, 45)
        header.BackgroundTransparency = 1
        header.Text = ""
        header.Parent = sectionFrame
        
        -- Icon (opcional)
        if icon then
            Utility:CreateIcon(header, icon, {30, 30}, {0, 10, 0, 7.5})
        end
        
        local headerTitle = Instance.new("TextLabel")
        headerTitle.Size = UDim2.new(1, -90, 0, 20)
        headerTitle.Position = UDim2.new(0, icon and 45 or 15, 0, 8)
        headerTitle.BackgroundTransparency = 1
        headerTitle.Text = name
        headerTitle.TextColor3 = self.Window.Theme.Text
        headerTitle.TextSize = 15
        headerTitle.Font = Enum.Font.GothamBold
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        headerTitle.Parent = header
        
        local headerDesc = Instance.new("TextLabel")
        headerDesc.Size = UDim2.new(1, -90, 0, 15)
        headerDesc.Position = UDim2.new(0, icon and 45 or 15, 0, 26)
        headerDesc.BackgroundTransparency = 1
        headerDesc.Text = desc
        headerDesc.TextColor3 = self.Window.Theme.SubText
        headerDesc.TextSize = 11
        headerDesc.Font = Enum.Font.Gotham
        headerDesc.TextXAlignment = Enum.TextXAlignment.Left
        headerDesc.TextTruncate = Enum.TextTruncate.AtEnd
        headerDesc.Parent = header
        
        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 20, 0, 20)
        arrow.Position = UDim2.new(1, -30, 0, 12.5)
        arrow.BackgroundTransparency = 1
        arrow.Text = opened and "▼" or "▶"
        arrow.TextColor3 = self.Window.Theme.SubText
        arrow.TextSize = 12
        arrow.Font = Enum.Font.GothamBold
        arrow.Parent = header
        
        -- Content
        local content = Instance.new("Frame")
        content.Size = UDim2.new(1, -20, 0, 0)
        content.Position = UDim2.new(0, 10, 0, 50)
        content.BackgroundTransparency = 1
        content.Visible = opened
        content.Parent = sectionFrame
        
        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 8)
        contentList.Parent = content
        
        local function updateSize()
            local totalHeight = 50
            if opened then
                totalHeight = totalHeight + contentList.AbsoluteContentSize.Y + 15
            end
            sectionFrame.Size = UDim2.new(1, 0, 0, totalHeight)
        end
        
        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)
        
        header.MouseButton1Click:Connect(function()
            opened = not opened
            arrow.Text = opened and "▼" or "▶"
            content.Visible = opened
            updateSize()
        end)
        
        updateSize()
        section.Frame = sectionFrame
        section.Content = content
        section.Window = self.Window
        
        -- ============================================
        -- PARAGRAPH
        -- ============================================
        
        function section:Paragraph(config)
            config = config or {}
            local name = config.Name or "Paragraph"
            local desc = config.Desc or ""
            local icon = config.Icon
            local options = config.Options or {}
            
            local paraHeight = 70
            if #options > 0 then
                paraHeight = 110
            end
            
            local paraFrame = Instance.new("Frame")
            paraFrame.Size = UDim2.new(1, 0, 0, paraHeight)
            paraFrame.BackgroundColor3 = self.Window.Theme.Tertiary
            paraFrame.BorderSizePixel = 0
            paraFrame.Parent = content
            
            Utility:CreateCorner(paraFrame, 8)
            
            -- Icon (opcional)
            if icon then
                Utility:CreateIcon(paraFrame, icon, {30, 30}, {0, 10, 0, 8})
            end
            
            local paraTitle = Instance.new("TextLabel")
            paraTitle.Size = UDim2.new(1, -50, 0, 20)
            paraTitle.Position = UDim2.new(0, icon and 45 or 15, 0, 10)
            paraTitle.BackgroundTransparency = 1
            paraTitle.Text = name
            paraTitle.TextColor3 = self.Window.Theme.Text
            paraTitle.TextSize = 14
            paraTitle.Font = Enum.Font.GothamBold
            paraTitle.TextXAlignment = Enum.TextXAlignment.Left
            paraTitle.Parent = paraFrame
            
            local paraDesc = Instance.new("TextLabel")
            paraDesc.Size = UDim2.new(1, -20, 0, 30)
            paraDesc.Position = UDim2.new(0, 10, 0, 32)
            paraDesc.BackgroundTransparency = 1
            paraDesc.Text = desc
            paraDesc.TextColor3 = self.Window.Theme.SubText
            paraDesc.TextSize = 12
            paraDesc.Font = Enum.Font.Gotham
            paraDesc.TextWrapped = true
            paraDesc.TextXAlignment = Enum.TextXAlignment.Left
            paraDesc.Parent = paraFrame
            
            if #options > 0 then
                local optContainer = Instance.new("Frame")
                optContainer.Size = UDim2.new(1, -20, 0, 30)
                optContainer.Position = UDim2.new(0, 10, 0, 70)
                optContainer.BackgroundTransparency = 1
                optContainer.Parent = paraFrame
                
                local optList = Instance.new("UIListLayout")
                optList.FillDirection = Enum.FillDirection.Horizontal
                optList.Padding = UDim.new(0, 8)
                optList.Parent = optContainer
                
                for _, opt in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(0, 70, 0, 28)
                    optBtn.BackgroundColor3 = self.Window.Theme.Accent
                    optBtn.Text = ""
                    optBtn.TextColor3 = self.Window.Theme.Text
                    optBtn.TextSize = 11
                    optBtn.Font = Enum.Font.GothamMedium
                    optBtn.Parent = optContainer
                    
                    Utility:CreateCorner(optBtn, 6)
                    
                    if opt.Icon then
                        Utility:CreateIcon(optBtn, opt.Icon, {18, 18}, {0, 5, 0, 5})
                        
                        local optText = Instance.new("TextLabel")
                        optText.Size = UDim2.new(1, -28, 1, 0)
                        optText.Position = UDim2.new(0, 26, 0, 0)
                        optText.BackgroundTransparency = 1
                        optText.Text = opt.Title
                        optText.TextColor3 = self.Window.Theme.Text
                        optText.TextSize = 11
                        optText.Font = Enum.Font.GothamMedium
                        optText.TextXAlignment = Enum.TextXAlignment.Left
                        optText.Parent = optBtn
                    else
                        optBtn.Text = opt.Title
                    end
                    
                    optBtn.MouseButton1Click:Connect(function()
                        if opt.Callback then
                            opt.Callback()
                        end
                    end)
                end
            end
        end
        
        -- ============================================
        -- BUTTON
        -- ============================================
        
        function section:Button(config)
            config = config or {}
            local name = config.Name or "Button"
            local desc = config.Desc or ""
            local callback = config.Callback or function() end
            
            local btnFrame = Instance.new("TextButton")
            btnFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 60 or 45)
            btnFrame.BackgroundColor3 = self.Window.Theme.Accent
            btnFrame.BorderSizePixel = 0
            btnFrame.Text = ""
            btnFrame.Parent = content
            
            Utility:CreateCorner(btnFrame, 8)
            
            local btnTitle = Instance.new("TextLabel")
            btnTitle.Size = UDim2.new(1, -20, 0, 20)
            btnTitle.Position = UDim2.new(0, 10, 0, desc ~= "" and 8 or 12.5)
            btnTitle.BackgroundTransparency = 1
            btnTitle.Text = name
            btnTitle.TextColor3 = self.Window.Theme.Text
            btnTitle.TextSize = 14
            btnTitle.Font = Enum.Font.GothamBold
            btnTitle.TextXAlignment = Enum.TextXAlignment.Left
            btnTitle.Parent = btnFrame
            
            if desc ~= "" then
                local btnDesc = Instance.new("TextLabel")
                btnDesc.Size = UDim2.new(1, -20, 0, 20)
                btnDesc.Position = UDim2.new(0, 10, 0, 32)
                btnDesc.BackgroundTransparency = 1
                btnDesc.Text = desc
                btnDesc.TextColor3 = Color3.fromRGB(230, 230, 240)
                btnDesc.TextSize = 11
                btnDesc.Font = Enum.Font.Gotham
                btnDesc.TextXAlignment = Enum.TextXAlignment.Left
                btnDesc.Parent = btnFrame
            end
            
            btnFrame.MouseEnter:Connect(function()
                Utility:Tween(btnFrame, {BackgroundColor3 = self.Window.Theme.AccentHover}, 0.2)
            end)
            
            btnFrame.MouseLeave:Connect(function()
                Utility:Tween(btnFrame, {BackgroundColor3 = self.Window.Theme.Accent}, 0.2)
            end)
            
            btnFrame.MouseButton1Click:Connect(callback)
        end
        
        -- ============================================
        -- TOGGLE
        -- ============================================
        
        function section:Toggle(config)
            config = config or {}
            local name = config.Name or "Toggle"
            local desc = config.Desc or ""
            local icon = config.Icon
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local state = default
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 65 or 50)
            toggleFrame.BackgroundColor3 = self.Window.Theme.Tertiary
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = content
            
            Utility:CreateCorner(toggleFrame, 8)
            
            local toggleTitle = Instance.new("TextLabel")
            toggleTitle.Size = UDim2.new(1, -70, 0, 20)
            toggleTitle.Position = UDim2.new(0, 10, 0, desc ~= "" and 8 or 15)
            toggleTitle.BackgroundTransparency = 1
            toggleTitle.Text = name
            toggleTitle.TextColor3 = self.Window.Theme.Text
            toggleTitle.TextSize = 14
            toggleTitle.Font = Enum.Font.GothamMedium
            toggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            toggleTitle.Parent = toggleFrame
            
            if desc ~= "" then
                local toggleDesc = Instance.new("TextLabel")
                toggleDesc.Size = UDim2.new(1, -70, 0, 18)
                toggleDesc.Position = UDim2.new(0, 10, 0, 32)
                toggleDesc.BackgroundTransparency = 1
                toggleDesc.Text = desc
                toggleDesc.TextColor3 = self.Window.Theme.SubText
                toggleDesc.TextSize = 11
                toggleDesc.Font = Enum.Font.Gotham
                toggleDesc.TextXAlignment = Enum.TextXAlignment.Left
                toggleDesc.Parent = toggleFrame
            end
            
            -- Toggle Switch
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 50, 0, 28)
            toggleBg.Position = UDim2.new(1, -60, 0.5, -14)
            toggleBg.BackgroundColor3 = state and self.Window.Theme.Toggle or Color3.fromRGB(60, 60, 65)
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = toggleFrame
            
            Utility:CreateCorner(toggleBg, 14)
            
            -- Toggle Circle (com icon opcional)
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 22, 0, 22)
            toggleCircle.Position = state and UDim2.new(0, 25, 0, 3) or UDim2.new(0, 3, 0, 3)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Parent = toggleBg
            
            Utility:CreateCorner(toggleCircle, 11)
            
            if icon then
                Utility:CreateIcon(toggleCircle, icon, {18, 18}, {0.5, -9, 0.5, -9})
            end
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.Parent = toggleBg
            
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                Utility:Tween(toggleBg, {BackgroundColor3 = state and self.Window.Theme.Toggle or Color3.fromRGB(60, 60, 65)}, 0.2)
                Utility:Tween(toggleCircle, {Position = state and UDim2.new(0, 25, 0, 3) or UDim2.new(0, 3, 0, 3)}, 0.2)
                callback(state)
            end)
            
            return {
                Set = function(self, value)
                    state = value
                    toggleBg.BackgroundColor3 = state and section.Window.Theme.Toggle or Color3.fromRGB(60, 60, 65)
                    toggleCircle.Position = state and UDim2.new(0, 25, 0, 3) or UDim2.new(0, 3, 0, 3)
                end
            }
        end
        
        -- ============================================
        -- DROPDOWN
        -- ============================================
        
        function section:Dropdown(config)
            config = config or {}
            local name = config.Name or "Dropdown"
            local desc = config.Desc or ""
            local icon = config.Icon
            local options = config.Options or {}
            local default = config.Default
            local multi = config.Multi or false
            local callback = config.Callback or function() end
            
            local selected = multi and {} or default
            local opened = false
            
            local dropFrame = Instance.new("Frame")
            dropFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 85 or 70)
            dropFrame.BackgroundColor3 = self.Window.Theme.Tertiary
            dropFrame.BorderSizePixel = 0
            dropFrame.ClipsDescendants = true
            dropFrame.Parent = content
            
            Utility:CreateCorner(dropFrame, 8)
            
            local dropTitle = Instance.new("TextLabel")
            dropTitle.Size = UDim2.new(1, -20, 0, 20)
            dropTitle.Position = UDim2.new(0, 10, 0, 8)
            dropTitle.BackgroundTransparency = 1
            dropTitle.Text = name
            dropTitle.TextColor3 = self.Window.Theme.Text
            dropTitle.TextSize = 14
            dropTitle.Font = Enum.Font.GothamMedium
            dropTitle.TextXAlignment = Enum.TextXAlignment.Left
            dropTitle.Parent = dropFrame
            
            if desc ~= "" then
                local dropDesc = Instance.new("TextLabel")
                dropDesc.Size = UDim2.new(1, -20, 0, 18)
                dropDesc.Position = UDim2.new(0, 10, 0, 30)
                dropDesc.BackgroundTransparency = 1
                dropDesc.Text = desc
                dropDesc.TextColor3 = self.Window.Theme.SubText
                dropDesc.TextSize = 11
                dropDesc.Font = Enum.Font.Gotham
                dropDesc.TextXAlignment = Enum.TextXAlignment.Left
                dropDesc.Parent = dropFrame
            end
            
            -- Selected Display
            local selectedBtn = Instance.new("TextButton")
            selectedBtn.Size = UDim2.new(1, -20, 0, 35)
            selectedBtn.Position = UDim2.new(0, 10, 0, desc ~= "" and 50 or 35)
            selectedBtn.BackgroundColor3 = self.Window.Theme.Secondary
            selectedBtn.BorderSizePixel = 0
            selectedBtn.Text = ""
            selectedBtn.Parent = dropFrame
            
            Utility:CreateCorner(selectedBtn, 6)
            
            if icon then
                Utility:CreateIcon(selectedBtn, icon, {20, 20}, {0, 8, 0, 7.5})
            end
            
            local selectedText = Instance.new("TextLabel")
            selectedText.Size = UDim2.new(1, -45, 0, 35)
            selectedText.Position = UDim2.new(0, icon and 33 or 10, 0, 0)
            selectedText.BackgroundTransparency = 1
            selectedText.Text = multi and "Nenhum selecionado" or (selected or "Selecione...")
            selectedText.TextColor3 = self.Window.Theme.SubText
            selectedText.TextSize = 12
            selectedText.Font = Enum.Font.Gotham
            selectedText.TextXAlignment = Enum.TextXAlignment.Left
            selectedText.TextTruncate = Enum.TextTruncate.AtEnd
            selectedText.Parent = selectedBtn
            
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 0, 20)
            arrow.Position = UDim2.new(1, -25, 0, 7.5)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = self.Window.Theme.SubText
            arrow.TextSize = 10
            arrow.Font = Enum.Font.GothamBold
            arrow.Parent = selectedBtn
            
            -- Options Container
            local optionsContainer = Instance.new("Frame")
            optionsContainer.Size = UDim2.new(1, -20, 0, 0)
            optionsContainer.Position = UDim2.new(0, 10, 0, desc ~= "" and 90 or 75)
            optionsContainer.BackgroundTransparency = 1
            optionsContainer.Parent = dropFrame
            
            local optionsList = Instance.new("UIListLayout")
            optionsList.SortOrder = Enum.SortOrder.LayoutOrder
            optionsList.Padding = UDim.new(0, 4)
            optionsList.Parent = optionsContainer
            
            for _, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.BackgroundColor3 = self.Window.Theme.Secondary
                optBtn.Text = option
                optBtn.TextColor3 = self.Window.Theme.Text
                optBtn.TextSize = 12
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.Parent = optionsContainer
                
                Utility:CreateCorner(optBtn, 6)
                
                local padding = Instance.new("UIPadding", optBtn)
                padding.PaddingLeft = UDim.new(0, 10)
                
                optBtn.MouseButton1Click:Connect(function()
                    if multi then
                        if table.find(selected, option) then
                            table.remove(selected, table.find(selected, option))
                            optBtn.BackgroundColor3 = self.Window.Theme.Secondary
                        else
                            table.insert(selected, option)
                            optBtn.BackgroundColor3 = self.Window.Theme.Accent
                        end
                        selectedText.Text = #selected > 0 and table.concat(selected, ", ") or "Nenhum selecionado"
                    else
                        selected = option
                        selectedText.Text = option
                        opened = false
                        arrow.Text = "▼"
                        Utility:Tween(dropFrame, {Size = UDim2.new(1, 0, 0, desc ~= "" and 85 or 70)}, 0.3)
                    end
                    callback(selected)
                end)
            end
            
            selectedBtn.MouseButton1Click:Connect(function()
                opened = not opened
                arrow.Text = opened and "▲" or "▼"
                local newHeight = (desc ~= "" and 85 or 70) + (opened and (#options * 34 + 5) or 0)
                Utility:Tween(dropFrame, {Size = UDim2.new(1, 0, 0, newHeight)}, 0.3)
            end)
            
            return {
                Set = function(self, value)
                    selected = value
                    selectedText.Text = multi and (type(value) == "table" and table.concat(value, ", ") or "Nenhum") or value
                end
            }
        end
        
        -- ============================================
        -- SLIDER
        -- ============================================
        
        function section:Slider(config)
            config = config or {}
            local name = config.Name or "Slider"
            local desc = config.Desc or ""
            local icon = config.Icon
            local minV = config.MinV or 0
            local maxV = config.MaxV or 100
            local defaultV = config.DefaultV or minV
            local callback = config.Callback or function() end
            
            local value = defaultV
            local dragging = false
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 80 or 65)
            sliderFrame.BackgroundColor3 = self.Window.Theme.Tertiary
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = content
            
            Utility:CreateCorner(sliderFrame, 8)
            
            local sliderTitle = Instance.new("TextLabel")
            sliderTitle.Size = UDim2.new(1, -60, 0, 20)
            sliderTitle.Position = UDim2.new(0, 10, 0, 8)
            sliderTitle.BackgroundTransparency = 1
            sliderTitle.Text = name
            sliderTitle.TextColor3 = self.Window.Theme.Text
            sliderTitle.TextSize = 14
            sliderTitle.Font = Enum.Font.GothamMedium
            sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            sliderTitle.Parent = sliderFrame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -55, 0, 8)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(value)
            valueLabel.TextColor3 = self.Window.Theme.Accent
            valueLabel.TextSize = 14
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = sliderFrame
            
            if desc ~= "" then
                local sliderDesc = Instance.new("TextLabel")
                sliderDesc.Size = UDim2.new(1, -20, 0, 18)
                sliderDesc.Position = UDim2.new(0, 10, 0, 30)
                sliderDesc.BackgroundTransparency = 1
                sliderDesc.Text = desc
                sliderDesc.TextColor3 = self.Window.Theme.SubText
                sliderDesc.TextSize = 11
                sliderDesc.Font = Enum.Font.Gotham
                sliderDesc.TextXAlignment = Enum.TextXAlignment.Left
                sliderDesc.Parent = sliderFrame
            end
            
            -- Slider Track
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Size = UDim2.new(1, -20, 0, 8)
            sliderTrack.Position = UDim2.new(0, 10, 0, desc ~= "" and 55 or 40)
            sliderTrack.BackgroundColor3 = self.Window.Theme.Secondary
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Parent = sliderFrame
            
            Utility:CreateCorner(sliderTrack, 4)
            
            -- Slider Fill
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((value - minV) / (maxV - minV), 0, 1, 0)
            sliderFill.BackgroundColor3 = self.Window.Theme.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderTrack
            
            Utility:CreateCorner(sliderFill, 4)
            
            -- Slider Handle (com icon opcional)
            local sliderHandle = Instance.new("Frame")
            sliderHandle.Size = UDim2.new(0, 22, 0, 22)
            sliderHandle.Position = UDim2.new((value - minV) / (maxV - minV), -11, 0.5, -11)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderHandle.BorderSizePixel = 0
            sliderHandle.Parent = sliderTrack
            
            Utility:CreateCorner(sliderHandle, 11)
            
            if icon then
                Utility:CreateIcon(sliderHandle, icon, {18, 18}, {0.5, -9, 0.5, -9})
            end
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                value = math.floor(minV + (maxV - minV) * pos)
                valueLabel.Text = tostring(value)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                sliderHandle.Position = UDim2.new(pos, -11, 0.5, -11)
                callback(value)
            end
            
            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return {
                Set = function(self, val)
                    value = math.clamp(val, minV, maxV)
                    valueLabel.Text = tostring(value)
                    local pos = (value - minV) / (maxV - minV)
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    sliderHandle.Position = UDim2.new(pos, -11, 0.5, -11)
                end
            }
        end
        
        -- ============================================
        -- INPUT
        -- ============================================
        
        function section:Input(config)
            config = config or {}
            local name = config.Name or "Input"
            local desc = config.Desc or ""
            local icon = config.Icon
            local default = config.Default or ""
            local callback = config.Callback or function() end
            
            local inputFrame = Instance.new("Frame")
            inputFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 90 or 75)
            inputFrame.BackgroundColor3 = self.Window.Theme.Tertiary
            inputFrame.BorderSizePixel = 0
            inputFrame.Parent = content
            
            Utility:CreateCorner(inputFrame, 8)
            
            local inputTitle = Instance.new("TextLabel")
            inputTitle.Size = UDim2.new(1, -20, 0, 20)
            inputTitle.Position = UDim2.new(0, 10, 0, 8)
            inputTitle.BackgroundTransparency = 1
            inputTitle.Text = name
            inputTitle.TextColor3 = self.Window.Theme.Text
            inputTitle.TextSize = 14
            inputTitle.Font = Enum.Font.GothamMedium
            inputTitle.TextXAlignment = Enum.TextXAlignment.Left
            inputTitle.Parent = inputFrame
            
            if desc ~= "" then
                local inputDesc = Instance.new("TextLabel")
                inputDesc.Size = UDim2.new(1, -20, 0, 18)
                inputDesc.Position = UDim2.new(0, 10, 0, 30)
                inputDesc.BackgroundTransparency = 1
                inputDesc.Text = desc
                inputDesc.TextColor3 = self.Window.Theme.SubText
                inputDesc.TextSize = 11
                inputDesc.Font = Enum.Font.Gotham
                inputDesc.TextXAlignment = Enum.TextXAlignment.Left
                inputDesc.Parent = inputFrame
            end
            
            -- Input Container
            local inputContainer = Instance.new("Frame")
            inputContainer.Size = UDim2.new(1, -20, 0, 35)
            inputContainer.Position = UDim2.new(0, 10, 0, desc ~= "" and 50 or 35)
            inputContainer.BackgroundColor3 = self.Window.Theme.Secondary
            inputContainer.BorderSizePixel = 0
            inputContainer.Parent = inputFrame
            
            Utility:CreateCorner(inputContainer, 6)
            
            if icon then
                Utility:CreateIcon(inputContainer, icon, {24, 24}, {0, 8, 0, 5.5})
            end
            
            local inputBox = Instance.new("TextBox")
            inputBox.Size = UDim2.new(1, icon and -45 or -20, 1, 0)
            inputBox.Position = UDim2.new(0, icon and 38 or 10, 0, 0)
            inputBox.BackgroundTransparency = 1
            inputBox.Text = default
            inputBox.PlaceholderText = "Digite aqui..."
            inputBox.PlaceholderColor3 = self.Window.Theme.SubText
            inputBox.TextColor3 = self.Window.Theme.Text
            inputBox.TextSize = 12
            inputBox.Font = Enum.Font.Gotham
            inputBox.TextXAlignment = Enum.TextXAlignment.Left
            inputBox.ClearTextOnFocus = false
            inputBox.Parent = inputContainer
            
            inputBox.FocusLost:Connect(function()
                callback(inputBox.Text)
            end)
            
            return {
                Set = function(self, text)
                    inputBox.Text = text
                end
            }
        end
        
        -- ============================================
        -- KEYBIND
        -- ============================================
        
        function section:Keybind(config)
            config = config or {}
            local name = config.Name or "Keybind"
            local desc = config.Desc or ""
            local defaultK = config.DefaultK or "None"
            local callback = config.Callback or function() end
            
            local currentKey = defaultK
            local listening = false
            
            local keybindFrame = Instance.new("Frame")
            keybindFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 65 or 50)
            keybindFrame.BackgroundColor3 = self.Window.Theme.Tertiary
            keybindFrame.BorderSizePixel = 0
            keybindFrame.Parent = content
            
            Utility:CreateCorner(keybindFrame, 8)
            
            local keybindTitle = Instance.new("TextLabel")
            keybindTitle.Size = UDim2.new(1, -80, 0, 20)
            keybindTitle.Position = UDim2.new(0, 10, 0, desc ~= "" and 8 or 15)
            keybindTitle.BackgroundTransparency = 1
            keybindTitle.Text = name
            keybindTitle.TextColor3 = self.Window.Theme.Text
            keybindTitle.TextSize = 14
            keybindTitle.Font = Enum.Font.GothamMedium
            keybindTitle.TextXAlignment = Enum.TextXAlignment.Left
            keybindTitle.Parent = keybindFrame
            
            if desc ~= "" then
                local keybindDesc = Instance.new("TextLabel")
                keybindDesc.Size = UDim2.new(1, -80, 0, 18)
                keybindDesc.Position = UDim2.new(0, 10, 0, 32)
                keybindDesc.BackgroundTransparency = 1
                keybindDesc.Text = desc
                keybindDesc.TextColor3 = self.Window.Theme.SubText
                keybindDesc.TextSize = 11
                keybindDesc.Font = Enum.Font.Gotham
                keybindDesc.TextXAlignment = Enum.TextXAlignment.Left
                keybindDesc.Parent = keybindFrame
            end
            
            local keybindBtn = Instance.new("TextButton")
            keybindBtn.Size = UDim2.new(0, 65, 0, 30)
            keybindBtn.Position = UDim2.new(1, -75, 0.5, -15)
            keybindBtn.BackgroundColor3 = self.Window.Theme.Accent
            keybindBtn.Text = currentKey
            keybindBtn.TextColor3 = self.Window.Theme.Text
            keybindBtn.TextSize = 12
            keybindBtn.Font = Enum.Font.GothamBold
            keybindBtn.Parent = keybindFrame
            
            Utility:CreateCorner(keybindBtn, 6)
            
            keybindBtn.MouseButton1Click:Connect(function()
                listening = true
                keybindBtn.Text = "..."
                keybindBtn.BackgroundColor3 = self.Window.Theme.Warning
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode.Name
                        keybindBtn.Text = currentKey
                        keybindBtn.BackgroundColor3 = self.Window.Theme.Accent
                        listening = false
                        callback(currentKey)
                    end
                elseif input.KeyCode.Name == currentKey and not gameProcessed then
                    callback(currentKey)
                end
            end)
            
            return {
                Set = function(self, key)
                    currentKey = key
                    keybindBtn.Text = key
                end
            }
        end
        
        -- ============================================
        -- COLORPICKER
        -- ============================================
        
        function section:ColorPicker(config)
            config = config or {}
            local name = config.Name or "ColorPicker"
            local desc = config.Desc or ""
            local default = config.Default or Color3.fromRGB(255, 255, 255)
            local callback = config.Callback or function() end
            
            local currentColor = default
            local pickerOpen = false
            
            local colorFrame = Instance.new("Frame")
            colorFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 65 or 50)
            colorFrame.BackgroundColor3 = self.Window.Theme.Tertiary
            colorFrame.BorderSizePixel = 0
            colorFrame.ClipsDescendants = true
            colorFrame.Parent = content
            
            Utility:CreateCorner(colorFrame, 8)
            
            local colorTitle = Instance.new("TextLabel")
            colorTitle.Size = UDim2.new(1, -70, 0, 20)
            colorTitle.Position = UDim2.new(0, 10, 0, desc ~= "" and 8 or 15)
            colorTitle.BackgroundTransparency = 1
            colorTitle.Text = name
            colorTitle.TextColor3 = self.Window.Theme.Text
            colorTitle.TextSize = 14
            colorTitle.Font = Enum.Font.GothamMedium
            colorTitle.TextXAlignment = Enum.TextXAlignment.Left
            colorTitle.Parent = colorFrame
            
            if desc ~= "" then
                local colorDesc = Instance.new("TextLabel")
                colorDesc.Size = UDim2.new(1, -70, 0, 18)
                colorDesc.Position = UDim2.new(0, 10, 0, 32)
                colorDesc.BackgroundTransparency = 1
                colorDesc.Text = desc
                colorDesc.TextColor3 = self.Window.Theme.SubText
                colorDesc.TextSize = 11
                colorDesc.Font = Enum.Font.Gotham
                colorDesc.TextXAlignment = Enum.TextXAlignment.Left
                colorDesc.Parent = colorFrame
            end
            
            -- Color Display Button
            local colorBtn = Instance.new("TextButton")
            colorBtn.Size = UDim2.new(0, 50, 0, 30)
            colorBtn.Position = UDim2.new(1, -60, 0.5, -15)
            colorBtn.BackgroundColor3 = currentColor
            colorBtn.BorderSizePixel = 2
            colorBtn.BorderColor3 = self.Window.Theme.Border
            colorBtn.Text = ""
            colorBtn.Parent = colorFrame
            
            Utility:CreateCorner(colorBtn, 6)
            
            -- Color Picker Panel
            local pickerPanel = Instance.new("Frame")
            pickerPanel.Size = UDim2.new(1, -20, 0, 180)
            pickerPanel.Position = UDim2.new(0, 10, 0, desc ~= "" and 65 or 50)
            pickerPanel.BackgroundColor3 = self.Window.Theme.Secondary
            pickerPanel.BorderSizePixel = 0
            pickerPanel.Visible = false
            pickerPanel.Parent = colorFrame
            
            Utility:CreateCorner(pickerPanel, 8)
            
            -- RGB Sliders
            local hue, sat, val = 0, 1, 1
            
            local function updateColor()
                currentColor = Color3.fromHSV(hue, sat, val)
                colorBtn.BackgroundColor3 = currentColor
                callback(currentColor)
            end
            
            local sliderNames = {"Hue", "Saturation", "Value"}
            local sliderValues = {hue, sat, val}
            
            for i, sliderName in ipairs(sliderNames) do
                local sliderContainer = Instance.new("Frame")
                sliderContainer.Size = UDim2.new(1, -20, 0, 40)
                sliderContainer.Position = UDim2.new(0, 10, 0, 10 + (i - 1) * 45)
                sliderContainer.BackgroundTransparency = 1
                sliderContainer.Parent = pickerPanel
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Size = UDim2.new(0.5, 0, 0, 20)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = sliderName
                sliderLabel.TextColor3 = self.Window.Theme.Text
                sliderLabel.TextSize = 12
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = sliderContainer
                
                local sliderValue = Instance.new("TextLabel")
                sliderValue.Size = UDim2.new(0.5, 0, 0, 20)
                sliderValue.Position = UDim2.new(0.5, 0, 0, 0)
                sliderValue.BackgroundTransparency = 1
                sliderValue.Text = string.format("%.2f", sliderValues[i])
                sliderValue.TextColor3 = self.Window.Theme.Accent
                sliderValue.TextSize = 12
                sliderValue.Font = Enum.Font.GothamBold
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                sliderValue.Parent = sliderContainer
                
                local sliderTrack = Instance.new("Frame")
                sliderTrack.Size = UDim2.new(1, 0, 0, 6)
                sliderTrack.Position = UDim2.new(0, 0, 0, 25)
                sliderTrack.BackgroundColor3 = self.Window.Theme.Primary
                sliderTrack.BorderSizePixel = 0
                sliderTrack.Parent = sliderContainer
                
                Utility:CreateCorner(sliderTrack, 3)
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new(sliderValues[i], 0, 1, 0)
                sliderFill.BackgroundColor3 = self.Window.Theme.Accent
                sliderFill.BorderSizePixel = 0
                sliderFill.Parent = sliderTrack
                
                Utility:CreateCorner(sliderFill, 3)
                
                local sliderHandle = Instance.new("Frame")
                sliderHandle.Size = UDim2.new(0, 16, 0, 16)
                sliderHandle.Position = UDim2.new(sliderValues[i], -8, 0.5, -8)
                sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderHandle.BorderSizePixel = 0
                sliderHandle.Parent = sliderTrack
                
                Utility:CreateCorner(sliderHandle, 8)
                
                local dragging = false
                
                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                    
                    if i == 1 then
                        hue = pos
                    elseif i == 2 then
                        sat = pos
                    else
                        val = pos
                    end
                    
                    sliderValue.Text = string.format("%.2f", pos)
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    sliderHandle.Position = UDim2.new(pos, -8, 0.5, -8)
                    updateColor()
                end
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
            end
            
            colorBtn.MouseButton1Click:Connect(function()
                pickerOpen = not pickerOpen
                pickerPanel.Visible = pickerOpen
                local newHeight = (desc ~= "" and 65 or 50) + (pickerOpen and 180 or 0)
                Utility:Tween(colorFrame, {Size = UDim2.new(1, 0, 0, newHeight)}, 0.3)
            end)
            
            return {
                Set = function(self, color)
                    currentColor = color
                    colorBtn.BackgroundColor3 = color
                    local h, s, v = Color3.toHSV(color)
                    hue, sat, val = h, s, v
                end
            }
        end
        
        table.insert(tab.Sections, section)
        return section
    end
    
    return tab
end

return AdminLib
