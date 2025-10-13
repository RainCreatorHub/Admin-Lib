-- Services.lua - Módulo de serviços compartilhados
local Services = {
	CoreGui = game:GetService("CoreGui"),
	UserInputService = game:GetService("UserInputService"),
	TweenService = game:GetService("TweenService"),
	RunService = game:GetService("RunService")
}

-- Configurações de cores
Services.Colors = {
	Background = Color3.fromRGB(35, 35, 45),
	Secondary = Color3.fromRGB(25, 25, 35),
	Element = Color3.fromRGB(45, 45, 55),
	ElementHover = Color3.fromRGB(55, 55, 65),
	Accent = Color3.fromRGB(110, 110, 255),
	Text = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(200, 200, 200),
	TextDark = Color3.fromRGB(220, 220, 220),
	SideBar = Color3.fromRGB(30, 30, 40),
	Overlay = Color3.fromRGB(20, 20, 25)
}

-- Configurações de UI
Services.Config = {
	CornerRadius = UDim.new(0, 6),
	SmallCornerRadius = UDim.new(0, 4),
	RoundCorner = UDim.new(1, 0),
	DefaultTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	FastTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Função auxiliar para criar corner
function Services:CreateCorner(radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or self.Config.CornerRadius
	return corner
end

-- Função auxiliar para criar padding
function Services:CreatePadding(left, right, top, bottom)
	local padding = Instance.new("UIPadding")
	if left then padding.PaddingLeft = UDim.new(0, left) end
	if right then padding.PaddingRight = UDim.new(0, right) end
	if top then padding.PaddingTop = UDim.new(0, top) end
	if bottom then padding.PaddingBottom = UDim.new(0, bottom) end
	return padding
end

-- Função auxiliar para criar tween
function Services:CreateTween(instance, properties, tweenInfo)
	return self.TweenService:Create(
		instance,
		tweenInfo or self.Config.DefaultTweenInfo,
		properties
	)
end

return Services
