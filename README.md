# 🧩 Admin `Lib`

[My Free AI](https://cognito-ai-4daf724c.base44.app)
---
## `Load`
---
```lua
local AdminLib = loadstring(game:HttpGet("https://pastefy.app/U1Jfir0T/raw"))()
```

## `Window`
---
```lua
local Win = AdminLib:Window({
    Title = "Admin",
    SubTitle = "Lib!",
    Size = {470, 340}
})
```

## `Dialog`
---
```lua
local D = Win:Dialog({
    Title = "Confirmar Ação",
    Desc = "Deseja realmente executar?",
    Icon = "❓",
    Options = {
        {
            Title = "Sim",
            Icon = "✅",
            Callback = function()
                print("Confirmado!")
            end
        },
        {
            Title = "Não",
            Icon = "❌",
            Callback = function()
                print("Cancelado!")
            end
        }
    }
})
```
## `Dialog` | Show
```lua
D:Show()
```
---
## `Notify`
---
```lua
Win:Notify({
    Title = "Bem-vindo!",
    Desc = "Script carregado com sucesso",
    Icon = "🔥",
    Time = 3,
    Options = {
        {
            Title = "OK",
            Icon = 12345678,
            Callback = function()
                print("Notificação fechada")
            end
        }
    }
})
```
## `Tab`
---
```lua
local Tab = Win:Tab({
    Name = "Principal",
    Icon = "🏠"
})
```
## `Section`
```lua
local Section = Tab:Section({
    Name = "Configurações",
    Desc = "Configure o auto join",
    Icon = "⚙️",
    Opened = true
})
```
## `Paragraph`
---
```lua
Section:Paragraph({
    Name = "Informação",
    Desc = "Selecione as opções abaixo",
    Icon = 12345678,
    Options = {
        {Title = "Ajuda", Icon = "❓", Callback = function() end}
    }
})
```
## `Button`
---
```lua
Section:Button({
    Name = "Executar",
    Desc = "Clique para iniciar",
    Callback = function()
        print("Botão clicado!")
    end
})
```
## `Toggle`
---
```lua
Section:Toggle({
    Name = "Auto Join",
    Desc = "Ativa entrada automática",
    Icon = "🔄",
    Default = true,
    Callback = function(v)
        print("Toggle:", v)
    end
})
```

## `Dropdown`
---
```lua
Section:Dropdown({
    Name = "Servidor",
    Desc = "Escolha o servidor",
    Icon = 12345678,
    Options = {"1M-5M", "5M-10M", "10M+"},
    Default = "1M-5M",
    Multi = false,
    Callback = function(v)
        print("Selecionado:", v)
    end
})
```

## `Slider`
---
```lua
Section:Slider({
    Name = "Velocidade",
    Desc = "Ajuste a velocidade",
    Icon = "⚡",
    MinV = 0,
    MaxV = 100,
    DefaultV = 50,
    Callback = function(v)
        print("Valor:", v)
    end
})
```
## `Input`
---
```lua
Section:Input({
    Name = "Player Name",
    Desc = "Digite seu nome",
    Icon = nil,
    Default = "",
    Callback = function(v)
        print("Input:", v)
    end
})
```
## `Keybind`
---
```lua
Section:Keybind({
    Name = "Toggle UI",
    Desc = "Tecla para mostrar/ocultar",
    DefaultK = "Q",
    Callback = function(key)
        print("Tecla:", key)
    end
})
```

## `Color Picker`
---
```lua
Section:ColorPicker({
    Name = "Cor do Tema",
    Desc = "Escolha uma cor",
    Default = Color3.fromRGB(88, 166, 255),
    Callback = function(color)
        print("Cor:", color)
    end
})
