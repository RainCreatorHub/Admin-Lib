local Lib = {}
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("AdL") then
  CoreGui:FindFirstChild("AdL"):Destroy()
end

task.wait(1)
function Lib:Window(Info)
    local Info = Info or {}
    
    local S = Instance.new("ScreenGui")
    S.Name = "AdL"
    S.ResetOnSpawn = false
    S.Parent = CoreGui

    local Win = Instance.new("Frame")
    Win.Size = UDim2.new(0, Info.Size[1] or 450, 0, Info.Size[2] or 320)
    Win.Position = UDim2.new(0, 200, 0, 15)
    Win.Parent = S

    local BWin = Instance.new("UICorner")
    BWin.Parent = Win

    local Tbar = Instance.new("Frame")
    Tbar.Size = UDim2.new(0, 450, 0, 30)
    Tbar.Parent = Win

    local TbarD = Instance.new("Frame")
    TbarD.Size = UDim2.new(0, 450, 0, 0.01)
    TbarD.Position = UDim2.new(0, 0, 0, 30)
    TbarD.Parent = Win

    local TC = Instance.new("UICorner")
    TC.Parent = Tbar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 15, 0, 15)
    Title.Position = UDim2.new(0, 3, 0, 4)
    Title.Text = Info.Title or "Window Title"
    Title.Parent = Tbar
end

function Lib:Demo()
  local Window = Lib:Window({
    Title = "Hello",
    Size = {
     450,
     320
    }
  })
end

Lib:Demo()
return Lib
