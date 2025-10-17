local UI = {}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function UI:Window(Info)
    local Info = Info or {}
    warn(Info.Title or "UI Loaded...")

    local Wf = {}
    local Tabs = {}
    local CurrentTab = nil
    
    -- Configurações
    local Theme = Info.Theme or "Dark"
    local Size = Info.Size or {470, 340}
    
    -- Cores dos temas
    local Themes = {
        Dark = {
            Background = Color3.fromRGB(30, 30, 40),
            Foreground = Color3.fromRGB(45, 45, 55),
            Text = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(0, 170, 255),
            Secondary = Color3.fromRGB(60, 60, 70),
            Success = Color3.fromRGB(0, 200, 100),
            Warning = Color3.fromRGB(255, 170, 0),
            Error = Color3.fromRGB(255, 60, 60)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 240),
            Foreground = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(0, 0, 0),
            Accent = Color3.fromRGB(0, 120, 215),
            Secondary = Color3.fromRGB(230, 230, 230),
            Success = Color3.fromRGB(0, 150, 50),
            Warning = Color3.fromRGB(200, 130, 0),
            Error = Color3.fromRGB(200, 50, 50)
        }
    }
    
    local CurrentTheme = Themes[Theme] or Themes.Dark
    
    -- Criar a interface principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary_" .. tostring(math.random(1000, 9999))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, Size[1], 0, Size[2])
    MainFrame.Position = UDim2.new(0.5, -Size[1]/2, 0.5, -Size[2]/2)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Barra de título
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = CurrentTheme.Foreground
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Info.Title or "UI Library"
    TitleLabel.TextColor3 = CurrentTheme.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = CurrentTheme.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = CurrentTheme.Text
    CloseButton.TextSize = 12
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- Container de abas
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    -- Barra de abas
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, 0, 0, 40)
    TabBar.BackgroundColor3 = CurrentTheme.Secondary
    TabBar.BorderSizePixel = 0
    TabBar.Parent = TabContainer

    local TabBarCorner = Instance.new("UICorner")
    TabBarCorner.CornerRadius = UDim.new(0, 8)
    TabBarCorner.Parent = TabBar
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, -20, 0, 30)
    TabList.Position = UDim2.new(0, 10, 0, 5)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = TabBar
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabList
    
    -- Conteúdo das abas
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, 0, 1, -40)
    TabContent.Position = UDim2.new(0, 0, 0, 40)
    TabContent.BackgroundTransparency = 1
    TabContent.Parent = TabContainer
    
    -- Função para arrastar a janela
    local function SetupDrag()
        local dragging = false
        local dragInput, dragStart, startPos
        
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    SetupDrag()
    
    -- Função para alternar visibilidade
    function Wf:Toggle()
        MainFrame.Visible = not MainFrame.Visible
    end
    
    -- Função para destruir a UI
    function Wf:Destroy()
        ScreenGui:Destroy()
    end

    -- Função para mudar tema
    function Wf:SetTheme(newTheme)
        if Themes[newTheme] then
            CurrentTheme = Themes[newTheme]
            -- Atualizar cores de todos os elementos
            MainFrame.BackgroundColor3 = CurrentTheme.Background
            TitleBar.BackgroundColor3 = CurrentTheme.Foreground
            TitleLabel.TextColor3 = CurrentTheme.Text
            TabBar.BackgroundColor3 = CurrentTheme.Secondary
            CloseButton.BackgroundColor3 = CurrentTheme.Error
            
            -- Atualizar abas e elementos
            for _, tab in pairs(Tabs) do
                if tab.Button then
                    tab.Button.BackgroundColor3 = CurrentTheme.Secondary
                    tab.Button.TextColor3 = CurrentTheme.Text
                end
                if tab.Content then
                    tab.Content.ScrollBarImageColor3 = CurrentTheme.Accent
                end
            end
        end
    end
    
    -- Função para criar aba
    function Wf:Tab(TInfo)
        local TInfo = TInfo or {}
        local Tab = {
            Name = TInfo.Name or "Nova Aba",
            Locked = TInfo.Locked or false,
            Elements = {}
        }
        
        table.insert(Tabs, Tab)
        
        -- Criar botão da aba
        local TabButton = Instance.new("TextButton")
        TabButton.Name = Tab.Name .. "Button"
        TabButton.Size = UDim2.new(0, 80, 0, 30)
        TabButton.BackgroundColor3 = CurrentTheme.Secondary
        TabButton.BorderSizePixel = 0
        TabButton.Text = Tab.Name
        TabButton.TextColor3 = CurrentTheme.Text
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabList
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = TabButton
        
        -- Atualizar tamanho do canvas
        local function updateCanvas()
            local totalSize = 0
            for _, child in pairs(TabList:GetChildren()) do
                if child:IsA("TextButton") then
                    totalSize = totalSize + child.AbsoluteSize.X + 5
                end
            end
            TabList.CanvasSize = UDim2.new(0, totalSize, 0, 0)
        end
        
        updateCanvas()
        TabButton:GetPropertyChangedSignal("Size"):Connect(updateCanvas)
        
        -- Criar conteúdo da aba
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = Tab.Name .. "Content"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Position = UDim2.new(0, 0, 0, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = CurrentTheme.Accent
        TabFrame.Visible = false
        TabFrame.Parent = TabContent
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.Parent = TabFrame
        
        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        Tab.Content = TabFrame
        Tab.Button = TabButton
        
        -- Selecionar aba
        local function SelectTab()
            if Tab.Locked then return end
            
            -- Esconder todos os conteúdos
            for _, otherTab in pairs(Tabs) do
                if otherTab.Content then
                    otherTab.Content.Visible = false
                end
                if otherTab.Button then
                    otherTab.Button.BackgroundColor3 = CurrentTheme.Secondary
                end
            end
            
            -- Mostrar conteúdo da aba selecionada
            Tab.Content.Visible = true
            Tab.Button.BackgroundColor3 = CurrentTheme.Accent
            CurrentTab = Tab
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        -- Selecionar primeira aba
        if #Tabs == 1 then
            SelectTab()
        end
        
        -- TAB METHODS (TM)
        local TM = {}
        
        function TM:Button(BInfo)
            local BInfo = BInfo or {}
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Size = UDim2.new(1, -20, 0, 35)
            ButtonFrame.BackgroundColor3 = CurrentTheme.Foreground
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = Tab.Content

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = BInfo.Name or "Button"
            Button.TextColor3 = CurrentTheme.Text
            Button.TextSize = 12
            Button.Font = Enum.Font.Gotham
            Button.Parent = ButtonFrame
            
            Button.MouseButton1Click:Connect(function()
                if BInfo.Callback then
                    BInfo.Callback()
                end
            end)
            
            -- Efeito hover
            Button.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Accent}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Foreground}):Play()
            end)

            return Button
        end
        
        function TM:Label(LInfo)
            local LInfo = LInfo or {}
            
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "LabelFrame"
            LabelFrame.Size = UDim2.new(1, -20, 0, 25)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Parent = Tab.Content
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = LInfo.Name or "Label"
            Label.TextColor3 = CurrentTheme.Text
            Label.TextSize = 14
            Label.Font = Enum.Font.GothamSemibold
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = LabelFrame

            return Label
        end
        
        function TM:Toggle(TogInfo)
            local TogInfo = TogInfo or {}
            local Toggled = TogInfo.Default or false
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
            ToggleFrame.BackgroundColor3 = CurrentTheme.Foreground
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Tab.Content
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = TogInfo.Name or "Toggle"
            ToggleLabel.TextColor3 = CurrentTheme.Text
            ToggleLabel.TextSize = 12
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleSwitch = Instance.new("Frame")
            ToggleSwitch.Name = "ToggleSwitch"
            ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
            ToggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleSwitch.BackgroundColor3 = CurrentTheme.Secondary
            ToggleSwitch.BorderSizePixel = 0
            ToggleSwitch.Parent = ToggleFrame
            
            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = ToggleSwitch
            
            local ToggleDot = Instance.new("Frame")
            ToggleDot.Name = "ToggleDot"
            ToggleDot.Size = UDim2.new(0, 16, 0, 16)
            ToggleDot.Position = UDim2.new(0, 2, 0, 2)
            ToggleDot.BackgroundColor3 = CurrentTheme.Text
            ToggleDot.BorderSizePixel = 0
            ToggleDot.Parent = ToggleSwitch
            
            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = ToggleDot
            
            local function UpdateToggle()
                if Toggled then
                    TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Accent}):Play()
                    TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0, 2)}):Play()
                else
                    TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Secondary}):Play()
                    TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
                end
                
                if TogInfo.Callback then
                    TogInfo.Callback(Toggled)
                end
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateToggle()
            end)
            
            UpdateToggle()

            local ToggleObject = {}
            function ToggleObject:Set(value)
                Toggled = value
                UpdateToggle()
            end
            function ToggleObject:Get()
                return Toggled
            end

            return ToggleObject
        end

        function TM:Slider(SInfo)
            local SInfo = SInfo or {}
            local Value = SInfo.Default or SInfo.Min or 0
            local Min = SInfo.Min or 0
            local Max = SInfo.Max or 100
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Size = UDim2.new(1, -20, 0, 50)
            SliderFrame.BackgroundColor3 = CurrentTheme.Foreground
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = Tab.Content
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "SliderLabel"
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = SInfo.Name or "Slider: " .. Value
            SliderLabel.TextColor3 = CurrentTheme.Text
            SliderLabel.TextSize = 12
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "ValueLabel"
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Position = UDim2.new(1, -50, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(Value)
            ValueLabel.TextColor3 = CurrentTheme.Text
            ValueLabel.TextSize = 12
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame
            
            local Track = Instance.new("Frame")
            Track.Name = "Track"
            Track.Size = UDim2.new(1, -20, 0, 5)
            Track.Position = UDim2.new(0, 10, 0, 30)
            Track.BackgroundColor3 = CurrentTheme.Secondary
            Track.BorderSizePixel = 0
            Track.Parent = SliderFrame
            
            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track
            
            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = CurrentTheme.Accent
            Fill.BorderSizePixel = 0
            Fill.Parent = Track
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = Track
            
            local function UpdateSlider(input)
                local relativeX = (input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X
                local newValue = math.floor(Min + (Max - Min) * math.clamp(relativeX, 0, 1))
                
                if newValue ~= Value then
                    Value = newValue
                    Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
                    ValueLabel.Text = tostring(Value)
                    SliderLabel.Text = (SInfo.Name or "Slider") .. ": " .. Value
                    
                    if SInfo.Callback then
                        SInfo.Callback(Value)
                    end
                end
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                UpdateSlider(UserInputService:GetMouseLocation())
                
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        connection:Disconnect()
                    end
                end)
            end)

            local SliderObject = {}
            function SliderObject:Set(newValue)
                Value = math.clamp(newValue, Min, Max)
                Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
                ValueLabel.Text = tostring(Value)
                SliderLabel.Text = (SInfo.Name or "Slider") .. ": " .. Value
                
                if SInfo.Callback then
                    SInfo.Callback(Value)
                end
            end
            function SliderObject:Get()
                return Value
            end

            return SliderObject
        end

        function TM:Section(SInfo)
            local SInfo = SInfo or {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "SectionFrame"
            SectionFrame.Size = UDim2.new(1, -20, 0, 30)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = Tab.Content
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Name = "SectionLabel"
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = " " .. (SInfo.Name or "Section")
            SectionLabel.TextColor3 = CurrentTheme.Accent
            SectionLabel.TextSize = 12
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionFrame
            
            local Line = Instance.new("Frame")
            Line.Name = "Line"
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 1, -1)
            Line.BackgroundColor3 = CurrentTheme.Accent
            Line.BorderSizePixel = 0
            Line.Parent = SectionFrame

            return SectionFrame
        end
        
        return TM
    end
    
    -- Fechar janela
    CloseButton.MouseButton1Click:Connect(function()
        Wf:Toggle()
    end)
    
    return Wf
end

return UI
