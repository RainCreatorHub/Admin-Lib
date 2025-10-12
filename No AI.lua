local Library = {}
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("Test") then
    CoreGui.Test:Destroy()
end

function Library:Window(Info)
    local Info = Info or {}
    local WindowObject = {}
    
    local S = Instance.new("ScreenGui")
    S.Name = "Test"
    S.ResetOnSpawn = false
    S.Parent = CoreGui

    local Mb2 = Instance.new("TextButton")
    Mb2.Name = "MinButton2"
    Mb2.Size = UDim2.new(0, 30, 0, 30)
    Mb2.Position = UDim2.new(0, 150, 0, 15)
    Mb2.Text = " "
    Mb2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Mb2.Parent = S

    local Mb2C = Instance.new("UICorner")
    Mb2C.Parent = Mb2

    local Win = Instance.new("Frame")
    Win.Name = "Window"
    Win.Size = UDim2.new(0, 450, 0, 320)
    Win.Position = UDim2.new(0, 200, 0, 15)
    Win.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Win.Parent = S

    local WC = Instance.new("UICorner")
    WC.Parent = Win

    local Tbar = Instance.new("Frame")
    Tbar.Name = "Tbar"
    Tbar.Size = UDim2.new(1, 0, 0, 24)
    Tbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Tbar.Parent = Win

    local TbarC = Instance.new("UICorner")
    TbarC.Parent = Tbar

    local TL = Instance.new("TextLabel")
    TL.Name = "TL"
    TL.Size = UDim2.new(1, -60, 1, 0)
    TL.Position = UDim2.new(0, 10, 0, 0)
    TL.Text = Info.Title or "Window!"
    TL.BackgroundTransparency = 1
    TL.TextColor3 = Color3.new(1, 1, 1)
    TL.Font = Enum.Font.SourceSans
    TL.TextSize = 18
    TL.TextXAlignment = Enum.TextXAlignment.Left
    TL.Parent = Tbar

    local Cb = Instance.new("TextButton")
    Cb.Name = "CloseButton"
    Cb.Size = UDim2.new(0, 24, 0, 24)
    Cb.Position = UDim2.new(1, -26, 0, 0)
    Cb.Text = "X"
    Cb.TextColor3 = Color3.new(1, 0.3, 0.3)
    Cb.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Cb.Parent = Tbar
    Cb.MouseButton1Click:Connect(function()
        S:Destroy()
    end)

    local CbC = Instance.new("UICorner")
    CbC.Parent = Cb

    local TA = Instance.new("Frame")
    TA.Name = "TabArea"
    TA.Size = UDim2.new(0, 100, 0, 250)
    TA.Position = UDim2.new(0, 1, 0, 26)
    TA.BackgroundTransparency = 1
    TA.Parent = Win

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 2)
    TabList.Parent = TA

    if Info.PInfo and Info.PInfo.Enabled == true then
        local PI = Instance.new("TextButton")
        PI.Name = "PlayerInfo"
        PI.Size = UDim2.new(0, 100, 0, 40)
        PI.Position = UDim2.new(0, 1, 0, 280)
        PI.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        PI.Parent = Win

        local PIC = Instance.new("UICorner")
        PIC.Parent = PI

        local PILabel = Instance.new("TextLabel")
        PILabel.Size = UDim2.new(1, -10, 1, 0)
        PILabel.Position = UDim2.new(0, 5, 0, 0)
        PILabel.BackgroundTransparency = 1
        PILabel.TextColor3 = Color3.new(1, 1, 1)
        PILabel.Font = Enum.Font.SourceSans
        PILabel.TextSize = 14
        PILabel.TextWrapped = true
        PILabel.TextYAlignment = Enum.TextYAlignment.Center
        PILabel.Parent = PI

        if Info.PInfo.Anonymous == true then
            PILabel.Text = "Anonymous"
        else
            local player = game:GetService("Players").LocalPlayer
            PILabel.Text = player.Name
        end

        if Info.PInfo.Callback then
            PI.MouseButton1Click:Connect(function()
                Info.PInfo.Callback()
            end)
        end
    end

    local Mb = Instance.new("TextButton")
    Mb.Name = "MinButton"
    Mb.Size = UDim2.new(0, 24, 0, 24)
    Mb.Position = UDim2.new(1, -52, 0, 0)
    Mb.Text = "–"
    Mb.TextColor3 = Color3.new(1, 1, 1)
    Mb.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Mb.Parent = Tbar
    Mb.MouseButton1Click:Connect(function()
        if Win.Size.Y.Offset > 24 then
            Win.Size = UDim2.new(0, 450, 0, 24)
            TA.Visible = false
            for _, content in pairs(Win:GetChildren()) do
                if content.Name:match("Content$") then
                    content.Visible = false
                end
            end
            Mb.Text = "+"
        else
            Win.Size = UDim2.new(0, 450, 0, 320)
            TA.Visible = true
            for _, content in pairs(Win:GetChildren()) do
                if content.Name:match("Content$") and content:GetAttribute("Selected") then
                    content.Visible = true
                end
            end
            Mb.Text = "–"
        end
    end)

    local MbC = Instance.new("UICorner")
    MbC.Parent = Mb

    Mb2.MouseButton1Click:Connect(function()
        Win.Visible = not Win.Visible
    end)

    local function MakeDraggable(frame, dragArea)
        local dragging, dragInput, startPos, startMousePos
        local function Update(input)
            local delta = input.Position - startMousePos
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
        dragArea.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startMousePos = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        dragArea.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                Update(input)
            end
        end)
    end

    MakeDraggable(Win, Tbar)
    MakeDraggable(Mb2, Mb2)

    local tabCount = 0

    function WindowObject:Tab(TabInfo)
        local TabInfo = TabInfo or {}
        tabCount = tabCount + 1
        local TabObject = {}

        local Tab = Instance.new("TextButton")
        Tab.Name = "Tab" .. tabCount
        Tab.Size = UDim2.new(1, -4, 0, 30)
        Tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Tab.TextColor3 = Color3.new(1, 1, 1)
        Tab.Text = TabInfo.Name or "Tab"
        Tab.Font = Enum.Font.SourceSans
        Tab.TextSize = 16
        Tab.LayoutOrder = tabCount
        Tab.Parent = TA

        if TabInfo.Locked == true then
            Tab.TextColor3 = Color3.fromRGB(150, 150, 150)
            Tab.Text = "🔒 " .. (TabInfo.Name or "Tab")
        end

        if TabInfo.Icon then
            Tab.Text = TabInfo.Icon .. " " .. (TabInfo.Name or "Tab")
        end

        local TabC = Instance.new("UICorner")
        TabC.Parent = Tab

        local TabContent = Instance.new("Frame")
        TabContent.Name = "Tab" .. tabCount .. "Content"
        TabContent.Size = UDim2.new(1, -100, 1, 0)
        TabContent.Position = UDim2.new(0, 100, 0, 0)
        TabContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabContent.Visible = (tabCount == 1)
        TabContent.Parent = Win

        if tabCount == 1 then
            TabContent:SetAttribute("Selected", true)
        end

        Tab.MouseButton1Click:Connect(function()
            if TabInfo.Locked == true then
                return
            end

            for _, content in pairs(Win:GetChildren()) do
                if content.Name:match("Content$") then
                    content.Visible = false
                    content:SetAttribute("Selected", false)
                end
            end

            TabContent.Visible = true
            TabContent:SetAttribute("Selected", true)
        end)

        return TabObject
    end

    return WindowObject
end

return Library
