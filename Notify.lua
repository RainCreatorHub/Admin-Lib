local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NotificationSystem"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Configurações
local NOTIFICATION_DURATION = 5
local ANIMATION_SPEED = 0.3

-- Estilos de cor
local COLOR = {
    DEEP_BLACK = Color3.new(0, 0, 0),
    LMAO_GREEN = Color3.new(0.5, 1, 0.5)
}

local function createNotification(title, message)
    -- Container principal
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 300, 0, 120)
    container.Position = UDim2.new(1, -320, 1, -130)
    container.AnchorPoint = Vector2.new(0, 1)
    container.BackgroundTransparency = 1
    container.Parent = gui

    -- Camada de contorno externo (Preto)
    local outerBorder = Instance.new("Frame")
    outerBorder.Size = UDim2.new(1, 6, 1, 6)
    outerBorder.Position = UDim2.new(0, -3, 0, -3)
    outerBorder.BorderSizePixel = 0
    outerBorder.BackgroundColor3 = COLOR.DEEP_BLACK
    outerBorder.Parent = container

    -- Camada de contorno médio (Verde)
    local middleBorder = Instance.new("Frame")
    middleBorder.Size = UDim2.new(1, 4, 1, 4)
    middleBorder.Position = UDim2.new(0, -2, 0, -2)
    middleBorder.BorderSizePixel = 0
    middleBorder.BackgroundColor3 = COLOR.LMAO_GREEN
    middleBorder.Parent = container

    -- Camada de contorno interno (Preto)
    local innerBorder = Instance.new("Frame")
    innerBorder.Size = UDim2.new(1, 2, 1, 2)
    innerBorder.Position = UDim2.new(0, -1, 0, -1)
    innerBorder.BorderSizePixel = 0
    innerBorder.BackgroundColor3 = COLOR.DEEP_BLACK
    innerBorder.Parent = container

    -- Corpo principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.BackgroundColor3 = COLOR.DEEP_BLACK
    mainFrame.Parent = container

    -- Elementos de UI
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = COLOR.LMAO_GREEN
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = mainFrame

    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -20, 0, 2)
    separator.Position = UDim2.new(0, 10, 0, 45)
    separator.BorderSizePixel = 0
    separator.BackgroundColor3 = COLOR.LMAO_GREEN
    separator.Parent = mainFrame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 1, -60)
    messageLabel.Position = UDim2.new(0, 10, 0, 52)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.new(1, 1, 1)
    messageLabel.TextSize = 14
    messageLabel.TextWrapped = true
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.Parent = mainFrame

    -- Animação de entrada
    container.Position = UDim2.new(1, 400, 1, -130)
    local tweenIn = TweenService:Create(
        container,
        TweenInfo.new(ANIMATION_SPEED, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -320, 1, -130)}
    )
    tweenIn:Play()

    -- Animação de saída
    local tweenOut = TweenService:Create(
        container,
        TweenInfo.new(ANIMATION_SPEED, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(1, 400, 1, -130)}
    )

    delay(NOTIFICATION_DURATION, function()
        tweenOut:Play()
        tweenOut.Completed:Wait()
        container:Destroy()
    end)
end

-- Sistema de fila
local notificationQueue = {}
local isShowingNotification = false

local function showNextNotification()
    if #notificationQueue == 0 or isShowingNotification then return end
    
    isShowingNotification = true
    local notifData = table.remove(notificationQueue, 1)
    
    createNotification(notifData.title, notifData.message)
    
    wait(NOTIFICATION_DURATION + ANIMATION_SPEED)
    isShowingNotification = false
    showNextNotification()
end

-- API pública
local Notification = {}

function Notification:Notify(title, message)
    table.insert(notificationQueue, {
        title = title,
        message = message
    })
    showNextNotification()
end

return Notification
