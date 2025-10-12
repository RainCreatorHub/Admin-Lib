local Lib = {}

function Lib:Window(Info)
  local Info = Info or {}
  local WinOb = {}
  local CoreGui = game:GetService("CoreGui")

  if CoreGui:WaitForChild("Chat") then
    CoreGui.Chat:Destroy()
  else
    print("Okay")
  end
  
  local S = Instance.new("ScreenGui")
  S.Name = "Chat"
  S.ResetOnSpawn = false
  S.Parent = CoreGui

  local Win = Instance.new("Frame")
  Win.Size = UDim2.new(0, Info.Size[1] or 470, 0, Info.Size[2] or 340)
  Win.Position = UDim2.new(0.5, -235, 0.5, -170)
  Win.Parent = S

  local Tbar = Instance.new("Frame")
  Tbar.Size = UDim2.new(0, 199, 0, 2)
  Tbar.Parent = Win

  function WinOb:Label(Info)

  end

  return WinOb
end

return Lib
