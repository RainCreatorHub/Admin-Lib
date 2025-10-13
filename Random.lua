local Lib = {}
local CoreGui = game:GetService("CoreGui")

function Lib:Window(Info)
    local Info = Info or {}
    
    local S = Instance.new("ScreenGui")
    S.ResetOnSpawn = false
    S.Parent = CoreGui

    local Win = Instance.new("Frame")
    Win.Size = UDim2.new(0, Info.Size[1] or 470, 0, Info.Size[2] or 340)
    Win.Position = UDim2.new(0, -100, 0, 15)
    Win.Parent = S

    local Tbar = Instance.new("Frame")
    Tbar.Parent = Win
end

function Lib:Demo()
  local Window = Lib:Window({
        Size = {
            470,
            340
        }
  })
end

return Lib
