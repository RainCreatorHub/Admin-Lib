--[[
  Feito com a IA Claude
  Web: Claude.ai
]]

local Lib = {}
local CoreGui = game:GetService("CoreGui")

-- Limpar instância anterior
if CoreGui:FindFirstChild("AdL") then
	CoreGui:FindFirstChild("AdL"):Destroy()
end

-- URL base do repositório
local BASE_URL = "https://raw.githubusercontent.com/RainCreatorHub/Admin-Lib/refs/heads/main/"

-- Função para carregar módulos com fallback
local function LoadModule(path, url)
	local success, result = pcall(function()
		if script:FindFirstChild("src") then
			return require(script.src[path])
		end
		error("Module not found locally")
	end)
	
	if success then
		return result
	else
		warn("Failed to load locally, trying URL:", path)
		local urlSuccess, urlResult = pcall(function()
			return loadstring(game:HttpGet(BASE_URL .. url))()
		end)
		
		if urlSuccess then
			return urlResult
		else
			error("Failed to load module from URL: " .. path .. "\n" .. tostring(urlResult))
		end
	end
end

-- Carregar componentes
Lib.Services = LoadModule("Components.Services", "src/Components/Services.lua")
Lib.Dialog = LoadModule("Components.Dialog", "src/Components/Dialog.lua")
Lib.Notify = LoadModule("Components.Notify", "src/Components/Notify.lua")
Lib.Tbar = LoadModule("Components.Tbar", "src/Components/Tbar.lua")

-- Carregar elementos
Lib.Button = LoadModule("Elements.Button", "src/Elements/Button.lua")
Lib.Toggle = LoadModule("Elements.Toggle", "src/Elements/Toggle.lua")
Lib.Slider = LoadModule("Elements.Slider", "src/Elements/Slider.lua")
Lib.Dropdown = LoadModule("Elements.Dropdown", "src/Elements/Dropdown.lua")
Lib.Section = LoadModule("Elements.Section", "src/Elements/Section.lua")

-- Carregar Window (precisa de todos os outros módulos)
Lib.Window = LoadModule("Components.Window", "src/Components/Window.lua")

-- Função de demonstração
function Lib:Demo()
	local MyWindow = Lib.Window:Create({
		Title = "AdL Library",
		SubTitle = "v1.7 - Modular",
		Size = { 440, 320 }
	})
	
	local MainTab = MyWindow:Tab({ Title = "Main" })
	local SettingsTab = MyWindow:Tab({ Title = "Settings" })
	
	Lib.Button:Create({
		Title = "Test Button",
		Parent = MainTab,
		Callback = function()
			Lib.Notify:Create({
				Title = "Success",
				Description = "Button clicked!",
				Duration = 3
			})
		end
	})
	
	Lib.Toggle:Create({
		Title = "Test Toggle",
		Parent = MainTab,
		Default = false,
		Callback = function(value)
			print("Toggle:", value)
		end
	})
	
	Lib.Slider:Create({
		Title = "Test Slider",
		Parent = SettingsTab,
		Min = 0,
		Max = 100,
		Default = 50,
		Callback = function(value)
			print("Slider:", value)
		end
	})
	
	Lib.Dropdown:Create({
		Title = "Test Dropdown",
		Parent = SettingsTab,
		Options = { "Option 1", "Option 2", "Option 3" },
		Default = "Option 1",
		Callback = function(value)
			print("Selected:", value)
		end
	})
end

return Lib
