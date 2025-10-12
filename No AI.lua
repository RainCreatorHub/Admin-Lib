local Lib = {}

function Lib:Window(Info)
  local Info = Info or {}
  local WinOb = {}
  local CoreGui = game:GetService("CoreGui")

  local S = Instance.new("ScreenGui")
    S.ResetOnSpawn = false
    S.Parent = CoreGui

  local Win = Instance.new("Frame")
    Win.Size = UDim2.new(0, Info.Size[1] or 470, 0, Info.Size[2] or 340)
    Win.Position = UDim2.new(0, 200, 0, 15)

  function WinOb:Label(Info)
  
  end
 return WinOb
end

return Lib
