-- Modified by Lou (Version Pressure Optimisée)

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

local webhook = function() return true end
local dsc = "https://discord.gg/RPpF74xXk" 

local character
local vals = {
    ESPActive = false,
    NFU = {}
}

-- [Système ESP Joueurs]
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
    -- PAGE ACCUEIL
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

    -- PAGE SURVIVAL (Nouveautés Pressure)
    local survivalPage = window:AddPage({Title = "Survival", Order = 1})
    
    survivalPage:AddButton({Caption = "Anti-Eyefestation", Callback = function()
        game:GetService("RunService").Stepped:Connect(function()
            pcall(function()
                local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                if PlayerGui:FindFirstChild("MainGui") and PlayerGui.MainGui:FindFirstChild("Panics") then
                    PlayerGui.MainGui.Panics.Visible = false
                end
            end)
        end)
    end})

    survivalPage:AddButton({Caption = "Infinite Oxygen", Callback = function()
        game:GetService("RunService").RenderStepped:Connect(function()
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Oxygen") then
                    char.Oxygen.Value = 100
                end
            end)
        end)
    end})

    -- PAGE WORLD
    local worldPage = window:AddPage({Title = "World", Order = 2})

    worldPage:AddButton({Caption = "Instant Interact", Callback = function()
        game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
            prompt.HoldDuration = 0
        end)
    end})

    worldPage:AddButton({Caption = "Fullbright (No Dark)", Callback = function()
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").GlobalShadows = false
    end})

    -- CRÉDITS FINAUX
    page:AddSeparator()
    page:AddLabel({Caption = "Propriétaire exclusif : Lou"})
    page:AddButton({Caption = "Copier mon Discord", Callback = function()
        setclipboard(dsc)
    end})
end

-- [Initialisation]
local windowFunc = function(window)
    local tbl = getGlobalTable()
    if not tbl["GameName"] then tbl["GameName"] = "Lou Hub" end
    task.spawn(mainWindow, window)
end

getGlobalTable().NFWF = windowFunc
return windowFunc
