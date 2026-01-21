-- Modified by Lou

local function getGlobalTable()
    return typeof(getfenv().getgenv) == "function" and typeof(getfenv().getgenv()) == "table" and getfenv().getgenv() or _G
end

if getGlobalTable().NFWF then
    return getGlobalTable().NFWF
end

local lib = getGlobalTable()._FIRELIB
local plr = game:GetService("Players").LocalPlayer
local signals
local notif = {Title = "[ Lou Hub ]", Time = 10, Text = ""}

-- Dépendances externes
local espLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Core/Libraries/ESP/Main.lua", true))()

pcall(function()
    signals = loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Core/Libraries/Signals/Main.lua"))()
end)

-- Webhook désactivé pour la confidentialité de Lou
local webhook = function() return true end

local dsc = "https://discord.gg/RPpF74xXk" -- Ton lien discord
local function getDevice()
    return game:GetService("UserInputService").MouseEnabled and game:GetService("UserInputService").KeyboardEnabled and not game:GetService("UserInputService").TouchEnabled and "Computer" or
        game:GetService("UserInputService").GamepadEnabled and "Console" or "Phone"
end

local character
local vals = {
    ESPActive = false,
    NFU = {}
}

-- [Système ESP et détection joueurs]
task.spawn(function()
    local plrs = game:GetService("Players")
    local lplr = plrs.LocalPlayer
    local playerBases = {}

    function character(plr)
        local char = plr.Character
        if not char then return end
        local playerBase = playerBases[plr.Name] or { HighlightEnabled = true, Color = Color3.new(1, 1, 1), Text = "NAME", ESPName = "PlayerESP" }
        playerBases[plr.Name] = playerBase
        pcall(espLib.DeapplyESP, char)
        playerBase.Color = plr.Team and plr.Team.TeamColor.Color or Color3.new(1, 1, 1)
        playerBase.Text = (vals.NFU[plr.Name] and "<font color=\"rgb(255,0,175)\"><b>[ Hub User ]</b></font>" or "") .. "\n" .. plr.DisplayName
        pcall(espLib.ApplyESP, char, playerBase)
    end

    local function player(plr)
        if plr and plr ~= lplr then
            if plr.Character then character(plr) end
            plr.Changed:Connect(function() character(plr) end)
        end
    end

    for i,v in plrs:GetPlayers() do player(v) task.wait() end
    plrs.PlayerAdded:Connect(player)
end)

-- [Interface Principale]
local function mainWindow(window)
    local page = window:AddPage({Title = "Menu Lou", Order = 0})
    
    page:AddLabel({Caption = "Auteur : Lou"})
    
    page:AddToggle({Caption = "Player ESP", Default = vals.ESPActive, Callback = function(b)
        vals.ESPActive = b
        espLib.ESPValues.PlayerESP = b
    end})

    page:AddSeparator()

    page:AddButton({Caption = "Infinite Yield", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end})

    page:AddButton({Caption = "New Dex (Explorer)", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end})

    page:AddSeparator()

    page:AddTextBox({Caption = "Exécuteur rapide", Placeholder = "Code Lua ici...", Enter = true, Callback = function(text)
        local s,e = loadstring(text)
        if s then pcall(s) else warn(e) end
    end})

    page:AddSeparator()
    page:AddLabel({Caption = "Propriétaire exclusif : Lou"})
    
    -- Bouton Discord
    page:AddButton({Caption = "Copier mon Discord", Callback = function()
        setclipboard(dsc)
        print("Lien copié !")
    end})
end

-- [Initialisation]
local windowFunc = function(window)
    local tbl = getGlobalTable()
    -- Bypass de la sécurité pour Lou
    if not tbl["GameName"] then tbl["GameName"] = "Lou Hub" end
    
    task.spawn(mainWindow, window)
end

getGlobalTable().NFWF = windowFunc
return windowFunc
