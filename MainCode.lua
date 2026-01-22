-- Modified by Lou (Version V2 - Pressure Full)

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

local dsc = "https://discord.gg/RPpF74xXk" 

local vals = {
    ESPActive = false,
    MonsterESP = false,
    AutoCollect = false
}

-- [Interface Principale]
local function mainWindow(window)
    -- --- PAGE ACCUEIL ---
    local page = window:AddPage({Title = "Menu Lou", Order = 0})
    page:AddLabel({Caption = "Auteur : Lou"})
    
    page:AddToggle({Caption = "Player ESP", Default = false, Callback = function(b)
        espLib.ESPValues.PlayerESP = b
    end})

    page:AddSeparator()
    page:AddButton({Caption = "Infinite Yield", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end})
    page:AddButton({Caption = "New Dex (Explorer)", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end})

    -- --- PAGE SURVIVAL ---
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

    survivalPage:AddButton({Caption = "Searchlight Bypass", Callback = function()
        -- Empêche le boss final de détecter le joueur
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Searchlight" and v:IsA("RemoteEvent") then
                hookfunction(v.FireServer, function() return end)
            end
        end
    end})

    survivalPage:AddButton({Caption = "Infinite Oxygen", Callback = function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Oxygen") then
                plr.Character.Oxygen.Value = 100
            end
        end)
    end})

    -- --- PAGE VISUALS (ESP MONSTRES) ---
    local visualPage = window:AddPage({Title = "Visuals", Order = 2})

    visualPage:AddButton({Caption = "ESP Monstres (Highlight)", Callback = function()
        task.spawn(function()
            while task.wait(2) do -- Scan toutes les 2 secondes
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and (v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Base")) then
                        if v.Name == "Angler" or v.Name == "Pinkie" or v.Name == "Pandemonium" or v.Name == "Froger" then
                            if not v:FindFirstChild("Highlight") then
                                local h = Instance.new("Highlight", v)
                                h.FillColor = Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                end
            end
        end)
    end})

    visualPage:AddButton({Caption = "Fullbright", Callback = function()
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").GlobalShadows = false
    end})

    -- --- PAGE WORLD ---
    local worldPage = window:AddPage({Title = "World", Order = 3})

    worldPage:AddButton({Caption = "Auto-Collect Items", Callback = function()
        vals.AutoCollect = true
        task.spawn(function()
            while vals.AutoCollect do
                task.wait(0.3)
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and (v.Parent.Name == "Gold" or v.Parent.Name == "Battery") then
                        fireproximityprompt(v)
                    end
                end
            end
        end)
    end})

    worldPage:AddButton({Caption = "Instant Interact", Callback = function()
        game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
            prompt.HoldDuration = 0
        end)
    end})

    -- CRÉDITS
    page:AddSeparator()
    page:AddLabel({Caption = "Propriétaire : Lou"})
end

-- [Initialisation]
local windowFunc = function(window)
    local tbl = getGlobalTable()
    if not tbl["GameName"] then tbl["GameName"] = "Pressure-Lobby" end
    task.spawn(mainWindow, window)
end

getGlobalTable().NFWF = windowFunc
return windowFunc
