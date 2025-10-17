local Lib = {}

function Lib:Window(Info)
    local Info = Info or {}
    local Title = Info.Title or "Window"
    local Size = Info.Size or UDim2.new(0, 440, 0, 330)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WindowGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.Size = Size
    Window.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.BorderSizePixel = 0
    Window.Parent = ScreenGui
    
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 8)
    WindowCorner.Parent = Window
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Window
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 8)
    TitleBarCorner.Parent = TitleBar
    
    local TitleBarExtension = Instance.new("Frame")
    TitleBarExtension.Size = UDim2.new(1, 0, 0, 8)
    TitleBarExtension.Position = UDim2.new(0, 0, 1, -8)
    TitleBarExtension.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBarExtension.BorderSizePixel = 0
    TitleBarExtension.Parent = TitleBar
    
    local Logo
    if Info.Logo then
        Logo = Instance.new("ImageLabel")
        Logo.Name = "Logo"
        Logo.Size = UDim2.new(0, 20, 0, 20)
        Logo.Position = UDim2.new(0, 8, 0.5, -10)
        Logo.BackgroundTransparency = 1
        Logo.Image = "rbxassetid://" .. tostring(Info.Logo)
        Logo.Parent = TitleBar
    end
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, Info.Logo and 35 or 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(1, -55, 0.5, -12.5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "–"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TitleBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 4)
    MinimizeCorner.Parent = MinimizeButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -25, 0.5, -12.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    local minimized = false
    local originalSize = Size
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Window:TweenSize(
                UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 35),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.3,
                true
            )
            MinimizeButton.Text = "+"
        else
            Window:TweenSize(
                originalSize,
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.3,
                true
            )
            MinimizeButton.Text = "–"
        end
    end)
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    if Info.Key and Info.KeyS then
        local KeySystem = Instance.new("Frame")
        KeySystem.Name = "KeySystem"
        KeySystem.Size = UDim2.new(0, 350, 0, 250)
        KeySystem.Position = UDim2.new(0.5, -175, 0.5, -125)
        KeySystem.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        KeySystem.BorderSizePixel = 0
        KeySystem.Parent = ScreenGui
        
        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 8)
        KeyCorner.Parent = KeySystem
        
        local KeyLogo
        if Info.KeyS.Logo then
            KeyLogo = Instance.new("ImageLabel")
            KeyLogo.Size = UDim2.new(0, 60, 0, 60)
            KeyLogo.Position = UDim2.new(0.5, -30, 0, 20)
            KeyLogo.BackgroundTransparency = 1
            KeyLogo.Image = "rbxassetid://" .. tostring(Info.KeyS.Logo)
            KeyLogo.Parent = KeySystem
        end
        
        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Size = UDim2.new(1, -40, 0, 25)
        KeyTitle.Position = UDim2.new(0, 20, 0, KeyLogo and 90 or 20)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = Info.KeyS.Title or "Key System"
        KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyTitle.TextSize = 18
        KeyTitle.Font = Enum.Font.GothamBold
        KeyTitle.Parent = KeySystem
        
        local KeySubTitle = Instance.new("TextLabel")
        KeySubTitle.Size = UDim2.new(1, -40, 0, 20)
        KeySubTitle.Position = UDim2.new(0, 20, 0, KeyTitle.Position.Y.Offset + 25)
        KeySubTitle.BackgroundTransparency = 1
        KeySubTitle.Text = Info.KeyS.SubTitle or ""
        KeySubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        KeySubTitle.TextSize = 14
        KeySubTitle.Font = Enum.Font.Gotham
        KeySubTitle.Parent = KeySystem
        
        local KeyDesc = Instance.new("TextLabel")
        KeyDesc.Size = UDim2.new(1, -40, 0, 20)
        KeyDesc.Position = UDim2.new(0, 20, 0, KeySubTitle.Position.Y.Offset + 20)
        KeyDesc.BackgroundTransparency = 1
        KeyDesc.Text = Info.KeyS.Desc or ""
        KeyDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
        KeyDesc.TextSize = 12
        KeyDesc.Font = Enum.Font.Gotham
        KeyDesc.Parent = KeySystem
        
        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(1, -40, 0, 35)
        KeyInput.Position = UDim2.new(0, 20, 0, KeyDesc.Position.Y.Offset + 30)
        KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        KeyInput.BorderSizePixel = 0
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Enter Key..."
        KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        KeyInput.TextSize = 14
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.Parent = KeySystem
        
        local KeyInputCorner = Instance.new("UICorner")
        KeyInputCorner.CornerRadius = UDim.new(0, 6)
        KeyInputCorner.Parent = KeyInput
        
        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Size = UDim2.new(0, 140, 0, 35)
        SubmitButton.Position = UDim2.new(0, 20, 1, -45)
        SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
        SubmitButton.BorderSizePixel = 0
        SubmitButton.Text = "Submit"
        SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitButton.TextSize = 14
        SubmitButton.Font = Enum.Font.GothamBold
        SubmitButton.Parent = KeySystem
        
        local SubmitCorner = Instance.new("UICorner")
        SubmitCorner.CornerRadius = UDim.new(0, 6)
        SubmitCorner.Parent = SubmitButton
        
        local GetKeyButton = Instance.new("TextButton")
        GetKeyButton.Size = UDim2.new(0, 140, 0, 35)
        GetKeyButton.Position = UDim2.new(1, -160, 1, -45)
        GetKeyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        GetKeyButton.BorderSizePixel = 0
        GetKeyButton.Text = "Get Key"
        GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        GetKeyButton.TextSize = 14
        GetKeyButton.Font = Enum.Font.GothamBold
        GetKeyButton.Parent = KeySystem
        
        local GetKeyCorner = Instance.new("UICorner")
        GetKeyCorner.CornerRadius = UDim.new(0, 6)
        GetKeyCorner.Parent = GetKeyButton
        
        Window.Visible = false
        
        SubmitButton.MouseButton1Click:Connect(function()
            local enteredKey = KeyInput.Text
            for _, validKey in pairs(Info.KeyS.Key) do
                if enteredKey == validKey then
                    KeySystem:Destroy()
                    Window.Visible = true
                    return
                end
            end
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Invalid Key!"
            wait(1)
            KeyInput.PlaceholderText = "Enter Key..."
        end)
        
        GetKeyButton.MouseButton1Click:Connect(function()
            if Info.KeyS.Url then
                setclipboard(Info.KeyS.Url)
                GetKeyButton.Text = "Copied!"
                wait(1)
                GetKeyButton.Text = "Get Key"
            end
        end)
    end
    
    local WindowFunctions = {}
    
    function WindowFunctions:Notify(NotifyInfo)
        local NotifyInfo = NotifyInfo or {}
        local NotifyTitle = NotifyInfo.Title or "Notification"
        local NotifyDesc = NotifyInfo.Desc or ""
        local NotifyLogo = NotifyInfo.Logo
        local Options = NotifyInfo.Options or {}
        
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Name = "Notify"
        NotifyFrame.Size = UDim2.new(0, 320, 0, 200 + (#Options * 40))
        NotifyFrame.Position = UDim2.new(0.5, -160, 0.5, -(100 + (#Options * 20)))
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Visible = true
        NotifyFrame.ZIndex = 10
        NotifyFrame.Parent = ScreenGui
        
        local NotifyCorner = Instance.new("UICorner")
        NotifyCorner.CornerRadius = UDim.new(0, 8)
        NotifyCorner.Parent = NotifyFrame
        
        local NotifyLogoImage
        if NotifyLogo then
            NotifyLogoImage = Instance.new("ImageLabel")
            NotifyLogoImage.Size = UDim2.new(0, 50, 0, 50)
            NotifyLogoImage.Position = UDim2.new(0.5, -25, 0, 20)
            NotifyLogoImage.BackgroundTransparency = 1
            NotifyLogoImage.Image = "rbxassetid://" .. tostring(NotifyLogo)
            NotifyLogoImage.ZIndex = 11
            NotifyLogoImage.Parent = NotifyFrame
        end
        
        local NotifyTitleLabel = Instance.new("TextLabel")
        NotifyTitleLabel.Size = UDim2.new(1, -40, 0, 25)
        NotifyTitleLabel.Position = UDim2.new(0, 20, 0, NotifyLogoImage and 80 or 20)
        NotifyTitleLabel.BackgroundTransparency = 1
        NotifyTitleLabel.Text = NotifyTitle
        NotifyTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifyTitleLabel.TextSize = 18
        NotifyTitleLabel.Font = Enum.Font.GothamBold
        NotifyTitleLabel.ZIndex = 11
        NotifyTitleLabel.Parent = NotifyFrame
        
        local NotifyDescLabel = Instance.new("TextLabel")
        NotifyDescLabel.Size = UDim2.new(1, -40, 0, 40)
        NotifyDescLabel.Position = UDim2.new(0, 20, 0, NotifyTitleLabel.Position.Y.Offset + 30)
        NotifyDescLabel.BackgroundTransparency = 1
        NotifyDescLabel.Text = NotifyDesc
        NotifyDescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        NotifyDescLabel.TextSize = 14
        NotifyDescLabel.Font = Enum.Font.Gotham
        NotifyDescLabel.TextWrapped = true
        NotifyDescLabel.ZIndex = 11
        NotifyDescLabel.Parent = NotifyFrame
        
        local yOffset = NotifyDescLabel.Position.Y.Offset + 50
        
        for i, option in ipairs(Options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, -40, 0, 35)
            OptionButton.Position = UDim2.new(0, 20, 0, yOffset)
            OptionButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = option.Title or "Option " .. i
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.TextSize = 14
            OptionButton.Font = Enum.Font.GothamBold
            OptionButton.ZIndex = 11
            OptionButton.Parent = NotifyFrame
            
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 6)
            OptionCorner.Parent = OptionButton
            
            OptionButton.MouseButton1Click:Connect(function()
                if option.Callback then
                    option.Callback()
                end
                NotifyFrame:Destroy()
            end)
            
            yOffset = yOffset + 45
        end
    end
        local DialogInfo = DialogInfo or {}
        local DialogTitle = DialogInfo.Title or "Dialog"
        local DialogDesc = DialogInfo.Desc or ""
        local DialogLogo = DialogInfo.Logo
        local Options = DialogInfo.Options or {}
        
        local DialogFrame = Instance.new("Frame")
        DialogFrame.Name = "Dialog"
        DialogFrame.Size = UDim2.new(0, 320, 0, 200 + (#Options * 40))
        DialogFrame.Position = UDim2.new(0.5, -160, 0.5, -(100 + (#Options * 20)))
        DialogFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        DialogFrame.BorderSizePixel = 0
        DialogFrame.Visible = false
        DialogFrame.ZIndex = 10
        DialogFrame.Parent = ScreenGui
        
        local DialogCorner = Instance.new("UICorner")
        DialogCorner.CornerRadius = UDim.new(0, 8)
        DialogCorner.Parent = DialogFrame
        
        local DialogLogoImage
        if DialogLogo then
            DialogLogoImage = Instance.new("ImageLabel")
            DialogLogoImage.Size = UDim2.new(0, 50, 0, 50)
            DialogLogoImage.Position = UDim2.new(0.5, -25, 0, 20)
            DialogLogoImage.BackgroundTransparency = 1
            DialogLogoImage.Image = "rbxassetid://" .. tostring(DialogLogo)
            DialogLogoImage.ZIndex = 11
            DialogLogoImage.Parent = DialogFrame
        end
        
        local DialogTitleLabel = Instance.new("TextLabel")
        DialogTitleLabel.Size = UDim2.new(1, -40, 0, 25)
        DialogTitleLabel.Position = UDim2.new(0, 20, 0, DialogLogoImage and 80 or 20)
        DialogTitleLabel.BackgroundTransparency = 1
        DialogTitleLabel.Text = DialogTitle
        DialogTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        DialogTitleLabel.TextSize = 18
        DialogTitleLabel.Font = Enum.Font.GothamBold
        DialogTitleLabel.ZIndex = 11
        DialogTitleLabel.Parent = DialogFrame
        
        local DialogDescLabel = Instance.new("TextLabel")
        DialogDescLabel.Size = UDim2.new(1, -40, 0, 40)
        DialogDescLabel.Position = UDim2.new(0, 20, 0, DialogTitleLabel.Position.Y.Offset + 30)
        DialogDescLabel.BackgroundTransparency = 1
        DialogDescLabel.Text = DialogDesc
        DialogDescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        DialogDescLabel.TextSize = 14
        DialogDescLabel.Font = Enum.Font.Gotham
        DialogDescLabel.TextWrapped = true
        DialogDescLabel.ZIndex = 11
        DialogDescLabel.Parent = DialogFrame
        
        local yOffset = DialogDescLabel.Position.Y.Offset + 50
        
        for i, option in ipairs(Options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, -40, 0, 35)
            OptionButton.Position = UDim2.new(0, 20, 0, yOffset)
            OptionButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = option.Title or "Option " .. i
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.TextSize = 14
            OptionButton.Font = Enum.Font.GothamBold
            OptionButton.ZIndex = 11
            OptionButton.Parent = DialogFrame
            
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 6)
            OptionCorner.Parent = OptionButton
            
            OptionButton.MouseButton1Click:Connect(function()
                if option.Callback then
                    option.Callback()
                end
                DialogFrame.Visible = false
            end)
            
            yOffset = yOffset + 45
        end
        
        local DialogFunctions = {}
        
        function DialogFunctions:Show()
            DialogFrame.Visible = true
        end
        
        function DialogFunctions:Hide()
            DialogFrame.Visible = false
        end
        
        function DialogFunctions:Destroy()
            DialogFrame:Destroy()
        end
        
        return DialogFunctions
    end
    
    return WindowFunctions
end

function Lib:Demo()
    local Window = Lib:Window({
        Title = "Hello bro!",
        Logo = 84950591783336,
        Key = true,
        KeyS = {
            Key = {"1234", "5678"},
            Url = "https://google.com",
            Logo = 84950591783336,
            Title = "Key",
            SubTitle = "System",
            Desc = "Keys: '1234' '5678'"
        }
    })

    local Dialog = Window:Dialog({
        Title = "Dialog",
        Desc = "Hello men",
        Logo = 84950591783336,
        Options = {
            {
                Title = "Hello 1",
                Callback = function()
                    print("Ola 1!")
                end
            },
            {
                Title = "Hello 2",
                Callback = function()
                    print("Ola 2!")
                end
            }
        }
    })
    Dialog:Show()

    Window:Notify({
      Title = "Hello",
      Desc = "Bro!",
      Logo = 84950591783336,
      Options = {
        {
         Title = "Hello 1",
         Callback = function()
          print("Ola 1!")
         end
        },
        {
         Title = "Hello 2",
         Callback = function()
           print("Ola 2!")
         end
        }
      }
   })
end

return Lib
