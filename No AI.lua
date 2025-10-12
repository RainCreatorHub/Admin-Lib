local Library = {}
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("Test") then
    CoreGui.Test:Destroy()
end

function Library:Window(Info)
 local Info = Info or {}
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
  TA.Parent = Win

if Info.PInfo == true then
 local PI = Instance.new("Frame")
  PI.Name = "Player Info"
  PI.Size = UDim2.new(0, 100, 0, 40)
  PI.Position = UDim2.new(0, 1, 0, 280)
  PI.Parent = Win

 local PIC = Instance.new("UICorner")
  PIC.Parent = PI
elseif Info.PInfo == false or Not Info.PInfo then
  print("Okay")
end

local Tab1 = Instance.new("TextButton")
Tab1.Name = "Tab1"
Tab1.Size = UDim2.new(1, -4, 0, 30)
Tab1.Position = UDim2.new(0, 2, 0, 2)
Tab1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Tab1.TextColor3 = Color3.new(1,1,1)
Tab1.Text = "Tab1"
Tab1.Font = Enum.Font.SourceSans
Tab1.TextSize = 16
Tab1.Parent = TA
local Tab1C = Instance.new("UICorner")
Tab1C.Parent = Tab1

local Tab1Content = Instance.new("Frame")
Tab1Content.Name = "Tab1Content"
Tab1Content.Size = UDim2.new(1, -100, 1, 0)
Tab1Content.Position = UDim2.new(0, 100, 0, 0)
Tab1Content.BackgroundColor3 = Color3.fromRGB(35,35,35)
Tab1Content.Visible = true
Tab1Content.Parent = Win

local Tab2 = Instance.new("TextButton")
Tab2.Name = "Tab2"
Tab2.Size = UDim2.new(1, -4, 0, 30)
Tab2.Position = UDim2.new(0, 2, 0, 34)
Tab2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Tab2.TextColor3 = Color3.new(1,1,1)
Tab2.Text = "Tab2"
Tab2.Font = Enum.Font.SourceSans
Tab2.TextSize = 16
Tab2.Parent = TA
local Tab2C = Instance.new("UICorner")
Tab2C.Parent = Tab2

local Tab2Content = Instance.new("Frame")
Tab2Content.Name = "Tab2Content"
Tab2Content.Size = UDim2.new(1, -100, 1, 0)
Tab2Content.Position = UDim2.new(0, 100, 0, 0)
Tab2Content.BackgroundColor3 = Color3.fromRGB(35,35,35)
Tab2Content.Visible = false
Tab2Content.Parent = Win

local Mb = Instance.new("TextButton")
Mb.Name = "MinButton"
Mb.Size = UDim2.new(0, 24, 0, 24)
Mb.Position = UDim2.new(1, -52, 0, 0)
Mb.Text = "–"
Mb.TextColor3 = Color3.new(1, 1, 1)
Mb.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Mb.Parent  = Tbar
Mb.MouseButton1Click:Connect(function()
    if Win.Size.Y.Offset > 24 then
        Win.Size = UDim2.new(0, 450, 0, 24)
        if TA then TA.Visible = false end
        if Tab1Content then Tab1Content.Visible = false end
        if Tab2Content then Tab2Content.Visible = false end
        Mb.Text = "+"
    else
        Win.Size = UDim2.new(0, 450, 0, 320)
        if TA then TA.Visible = true end
        if Tab1Content then Tab1Content.Visible = true end
        Mb.Text = "–"
    end
end)

local MbC = Instance.new("UICorner")
MbC.Parent = Mb

Mb2.MouseButton1Click:Connect(function()
    Win.Visible = not Win.Visible
end)

Tab1.MouseButton1Click:Connect(function()
    Tab1Content.Visible = true
    Tab2Content.Visible = false
end)

Tab2.MouseButton1Click:Connect(function()
    Tab1Content.Visible = false
    Tab2Content.Visible = true
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
end

return Library
