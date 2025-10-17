local Lib = {}

function Lib:Window(Info)
    Info = Info or {}
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
    
    Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 8)
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Window
    
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)
    
    local Ext = Instance.new("Frame")
    Ext.Size = UDim2.new(1, 0, 0, 8)
    Ext.Position = UDim2.new(0, 0, 1, -8)
    Ext.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Ext.BorderSizePixel = 0
    Ext.Parent = TitleBar
    
    if Info.Logo then
        local Logo = Instance.new("ImageLabel")
        Logo.Size = UDim2.new(0, 20, 0, 20)
        Logo.Position = UDim2.new(0, 8, 0.5, -10)
        Logo.BackgroundTransparency = 1
        Logo.Image = "rbxassetid://" .. tostring(Info.Logo)
        Logo.Parent = TitleBar
    end
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, Info.Logo and 35 or 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 25, 0, 25)
    MinBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
    MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "–"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 16
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TitleBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Position = UDim2.new(1, -25, 0.5, -12.5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
    
    local minimized = false
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Window:TweenSize(
            minimized and UDim2.new(Size.X.Scale, Size.X.Offset, 0, 35) or Size,
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        MinBtn.Text = minimized and "+" or "–"
    end)
    
    local dragging, dragInput, dragStart, startPos
    
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
        local KeyS = Instance.new("Frame")
        KeyS.Size = UDim2.new(0, 350, 0, 250)
        KeyS.Position = UDim2.new(0.5, -175, 0.5, -125)
        KeyS.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        KeyS.BorderSizePixel = 0
        KeyS.ZIndex = 10
        KeyS.Parent = ScreenGui
        Instance.new("UICorner", KeyS).CornerRadius = UDim.new(0, 8)
        
        if Info.KeyS.Logo then
            local KLogo = Instance.new("ImageLabel")
            KLogo.Size = UDim2.new(0, 60, 0, 60)
            KLogo.Position = UDim2.new(0.5, -30, 0, 20)
            KLogo.BackgroundTransparency = 1
            KLogo.Image = "rbxassetid://" .. tostring(Info.KeyS.Logo)
            KLogo.ZIndex = 11
            KLogo.Parent = KeyS
        end
        
        local yPos = Info.KeyS.Logo and 90 or 20
        
        local KTitle = Instance.new("TextLabel")
        KTitle.Size = UDim2.new(1, -40, 0, 25)
        KTitle.Position = UDim2.new(0, 20, 0, yPos)
        KTitle.BackgroundTransparency = 1
        KTitle.Text = Info.KeyS.Title or "Key System"
        KTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        KTitle.TextSize = 18
        KTitle.Font = Enum.Font.GothamBold
        KTitle.ZIndex = 11
        KTitle.Parent = KeyS
        
        local KSub = Instance.new("TextLabel")
        KSub.Size = UDim2.new(1, -40, 0, 20)
        KSub.Position = UDim2.new(0, 20, 0, yPos + 25)
        KSub.BackgroundTransparency = 1
        KSub.Text = Info.KeyS.SubTitle or ""
        KSub.TextColor3 = Color3.fromRGB(200, 200, 200)
        KSub.TextSize = 14
        KSub.Font = Enum.Font.Gotham
        KSub.ZIndex = 11
        KSub.Parent = KeyS
        
        local KDesc = Instance.new("TextLabel")
        KDesc.Size = UDim2.new(1, -40, 0, 20)
        KDesc.Position = UDim2.new(0, 20, 0, yPos + 45)
        KDesc.BackgroundTransparency = 1
        KDesc.Text = Info.KeyS.Desc or ""
        KDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
        KDesc.TextSize = 12
        KDesc.Font = Enum.Font.Gotham
        KDesc.ZIndex = 11
        KDesc.Parent = KeyS
        
        local KInput = Instance.new("TextBox")
        KInput.Size = UDim2.new(1, -40, 0, 35)
        KInput.Position = UDim2.new(0, 20, 0, yPos + 75)
        KInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        KInput.BorderSizePixel = 0
        KInput.Text = ""
        KInput.PlaceholderText = "Enter Key..."
        KInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        KInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        KInput.TextSize = 14
        KInput.Font = Enum.Font.Gotham
        KInput.ZIndex = 11
        KInput.Parent = KeyS
        Instance.new("UICorner", KInput).CornerRadius = UDim.new(0, 6)
        
        local SubBtn = Instance.new("TextButton")
        SubBtn.Size = UDim2.new(0, 140, 0, 35)
        SubBtn.Position = UDim2.new(0, 20, 1, -45)
        SubBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
        SubBtn.BorderSizePixel = 0
        SubBtn.Text = "Submit"
        SubBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubBtn.TextSize = 14
        SubBtn.Font = Enum.Font.GothamBold
        SubBtn.ZIndex = 11
        SubBtn.Parent = KeyS
        Instance.new("UICorner", SubBtn).CornerRadius = UDim.new(0, 6)
        
        local GetBtn = Instance.new("TextButton")
        GetBtn.Size = UDim2.new(0, 140, 0, 35)
        GetBtn.Position = UDim2.new(1, -160, 1, -45)
        GetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        GetBtn.BorderSizePixel = 0
        GetBtn.Text = "Get Key"
        GetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        GetBtn.TextSize = 14
        GetBtn.Font = Enum.Font.GothamBold
        GetBtn.ZIndex = 11
        GetBtn.Parent = KeyS
        Instance.new("UICorner", GetBtn).CornerRadius = UDim.new(0, 6)
        
        Window.Visible = false
        
        SubBtn.MouseButton1Click:Connect(function()
            for _, k in pairs(Info.KeyS.Key) do
                if KInput.Text == k then
                    KeyS:Destroy()
                    Window.Visible = true
                    return
                end
            end
            KInput.Text = ""
            KInput.PlaceholderText = "Invalid Key!"
            wait(1)
            KInput.PlaceholderText = "Enter Key..."
        end)
        
        GetBtn.MouseButton1Click:Connect(function()
            if Info.KeyS.Url then
                pcall(function() setclipboard(Info.KeyS.Url) end)
                GetBtn.Text = "Copied!"
                wait(1)
                GetBtn.Text = "Get Key"
            end
        end)
    end
    
    local WF = {}
    
    function WF:Dialog(DInfo)
        DInfo = DInfo or {}
        local opts = DInfo.Options or {}
        
        local D = Instance.new("Frame")
        D.Size = UDim2.new(0, 320, 0, 200 + (#opts * 40))
        D.Position = UDim2.new(0.5, -160, 0.5, -(100 + (#opts * 20)))
        D.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        D.BorderSizePixel = 0
        D.Visible = false
        D.ZIndex = 10
        D.Parent = ScreenGui
        Instance.new("UICorner", D).CornerRadius = UDim.new(0, 8)
        
        local yPos = 20
        
        if DInfo.Logo then
            local DLogo = Instance.new("ImageLabel")
            DLogo.Size = UDim2.new(0, 50, 0, 50)
            DLogo.Position = UDim2.new(0.5, -25, 0, 20)
            DLogo.BackgroundTransparency = 1
            DLogo.Image = "rbxassetid://" .. tostring(DInfo.Logo)
            DLogo.ZIndex = 11
            DLogo.Parent = D
            yPos = 80
        end
        
        local DTitle = Instance.new("TextLabel")
        DTitle.Size = UDim2.new(1, -40, 0, 25)
        DTitle.Position = UDim2.new(0, 20, 0, yPos)
        DTitle.BackgroundTransparency = 1
        DTitle.Text = DInfo.Title or "Dialog"
        DTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        DTitle.TextSize = 18
        DTitle.Font = Enum.Font.GothamBold
        DTitle.ZIndex = 11
        DTitle.Parent = D
        
        local DDesc = Instance.new("TextLabel")
        DDesc.Size = UDim2.new(1, -40, 0, 40)
        DDesc.Position = UDim2.new(0, 20, 0, yPos + 30)
        DDesc.BackgroundTransparency = 1
        DDesc.Text = DInfo.Desc or ""
        DDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
        DDesc.TextSize = 14
        DDesc.Font = Enum.Font.Gotham
        DDesc.TextWrapped = true
        DDesc.ZIndex = 11
        DDesc.Parent = D
        
        yPos = yPos + 80
        
        for i, opt in ipairs(opts) do
            local OBtn = Instance.new("TextButton")
            OBtn.Size = UDim2.new(1, -40, 0, 35)
            OBtn.Position = UDim2.new(0, 20, 0, yPos)
            OBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
            OBtn.BorderSizePixel = 0
            OBtn.Text = opt.Title or "Option " .. i
            OBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            OBtn.TextSize = 14
            OBtn.Font = Enum.Font.GothamBold
            OBtn.ZIndex = 11
            OBtn.Parent = D
            Instance.new("UICorner", OBtn).CornerRadius = UDim.new(0, 6)
            
            OBtn.MouseButton1Click:Connect(function()
                if opt.Callback then
                    pcall(opt.Callback)
                end
                D.Visible = false
            end)
            
            yPos = yPos + 45
        end
        
        return {
            Show = function() D.Visible = true end,
            Hide = function() D.Visible = false end,
            Destroy = function() D:Destroy() end
        }
    end
    
    function WF:Notify(NInfo)
        NInfo = NInfo or {}
        local opts = NInfo.Options or {}
        
        local N = Instance.new("Frame")
        N.Size = UDim2.new(0, 320, 0, 200 + (#opts * 40))
        N.Position = UDim2.new(0.5, -160, 0.5, -(100 + (#opts * 20)))
        N.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        N.BorderSizePixel = 0
        N.ZIndex = 10
        N.Parent = ScreenGui
        Instance.new("UICorner", N).CornerRadius = UDim.new(0, 8)
        
        local yPos = 20
        
        if NInfo.Logo then
            local NLogo = Instance.new("ImageLabel")
            NLogo.Size = UDim2.new(0, 50, 0, 50)
            NLogo.Position = UDim2.new(0.5, -25, 0, 20)
            NLogo.BackgroundTransparency = 1
            NLogo.Image = "rbxassetid://" .. tostring(NInfo.Logo)
            NLogo.ZIndex = 11
            NLogo.Parent = N
            yPos = 80
        end
        
        local NTitle = Instance.new("TextLabel")
        NTitle.Size = UDim2.new(1, -40, 0, 25)
        NTitle.Position = UDim2.new(0, 20, 0, yPos)
        NTitle.BackgroundTransparency = 1
        NTitle.Text = NInfo.Title or "Notification"
        NTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NTitle.TextSize = 18
        NTitle.Font = Enum.Font.GothamBold
        NTitle.ZIndex = 11
        NTitle.Parent = N
        
        local NDesc = Instance.new("TextLabel")
        NDesc.Size = UDim2.new(1, -40, 0, 40)
        NDesc.Position = UDim2.new(0, 20, 0, yPos + 30)
        NDesc.BackgroundTransparency = 1
        NDesc.Text = NInfo.Desc or ""
        NDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
        NDesc.TextSize = 14
        NDesc.Font = Enum.Font.Gotham
        NDesc.TextWrapped = true
        NDesc.ZIndex = 11
        NDesc.Parent = N
        
        yPos = yPos + 80
        
        for i, opt in ipairs(opts) do
            local OBtn = Instance.new("TextButton")
            OBtn.Size = UDim2.new(1, -40, 0, 35)
            OBtn.Position = UDim2.new(0, 20, 0, yPos)
            OBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
            OBtn.BorderSizePixel = 0
            OBtn.Text = opt.Title or "Option " .. i
            OBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            OBtn.TextSize = 14
            OBtn.Font = Enum.Font.GothamBold
            OBtn.ZIndex = 11
            OBtn.Parent = N
            Instance.new("UICorner", OBtn).CornerRadius = UDim.new(0, 6)
            
            OBtn.MouseButton1Click:Connect(function()
                if opt.Callback then
                    pcall(opt.Callback)
                end
                N:Destroy()
            end)
            
            yPos = yPos + 45
        end
    end
    
    return WF
end

function Lib:Demo()
    local Win = Lib:Window({
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

    local Dlg = Win:Dialog({
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
    Dlg:Show()
    
    Win:Notify({
        Title = "Hello",
        Desc = game.Players.LocalPlayer.Name .. "!",
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
