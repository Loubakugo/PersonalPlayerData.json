-- Modified by Lou (Vrai Source Fire Hub - Pressure)

local function getGlobalTable()
    return typeof(getfenv().getgenv) == "function" and typeof(getfenv().getgenv()) == "table" and getfenv().getgenv() or _G
end

local lib = getGlobalTable()._FIRELIB
local plr = game:GetService("Players").LocalPlayer

local function mainWindow(window)
    -- --- CRÉATION DES ONGLETS À L'IDENTIQUE ---
    local Tabs = {
        Main = window:AddPage({Title = "Main", Order = 1}),
        Readme = window:AddPage({Title = "! READ ME NOW !", Order = 2}),
        Bypasses = window:AddPage({Title = "Bypasses", Order = 3}),
        Interact = window:AddPage({Title = "Interact", Order = 4}),
        Visual = window:AddPage({Title = "Visual", Order = 5}),
        Trolling = window:AddPage({Title = "Trolling", Order = 6})
    }

    -- --- SECTION BYPASSES (IMG_6378) ---
    Tabs.Bypasses:AddToggle({Caption = "No damage", Callback = function(state)
        if state then
            getgenv().NoDmg = hookmetamethod(game, "__namecall", function(self, ...)
                if not checkcaller() and (tostring(self) == "DamageEvent" or tostring(self) == "DrownEvent") and getnamecallmethod() == "FireServer" then
                    return nil
                end
                return getgenv().NoDmg(self, ...)
            end)
        end
    end})

    Tabs.Bypasses:AddToggle({Caption = "Auto hide", Callback = function(state)
        getgenv().AutoHide = state
        task.spawn(function()
            while getgenv().AutoHide do
                for _, v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("MonsterRoot") or v.Name == "Angler" then
                        local dist = (v.PrimaryPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 200 then
                            local locker = workspace:FindFirstChild("Locker", true)
                            if locker and locker:FindFirstChild("ProximityPrompt") then
                                fireproximityprompt(locker.ProximityPrompt)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end})

    Tabs.Bypasses:AddToggle({Caption = "Anti Searchlights", Callback = function(state)
        getgenv().AntiSearch = state
        local old; old = hookmetamethod(game, "__namecall", function(self, ...)
            if getgenv().AntiSearch and tostring(self) == "SearchlightEvent" and getnamecallmethod() == "FireServer" then return nil end
            return old(self, ...)
        end)
    end})

    Tabs.Bypasses:AddToggle({Caption = "Anti Eyefestation", Callback = function(state)
        getgenv().AntiEye = state
        game:GetService("RunService").Heartbeat:Connect(function()
            if getgenv().AntiEye then
                pcall(function()
                    plr.PlayerGui.MainGui.Panics.Eyefestation.Visible = false
                    plr.PlayerGui.MainGui.Panics.Modifier = 0
                end)
            end
        end)
    end})

    -- --- SECTION INTERACT (IMG_6379) ---
    Tabs.Interact:AddToggle({Caption = "Auto loot currency", Callback = function(state)
        getgenv().AutoLoot = state
        task.spawn(function()
            while getgenv().AutoLoot do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and (v.Parent.Name == "GoldPile" or v.Parent.Name == "Battery") then
                        fireproximityprompt(v)
                    end
                end
                task.wait(0.1)
            end
        end)
    end})

    Tabs.Interact:AddToggle({Caption = "Instant proximity prompt interact", Callback = function(state)
        game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p)
            if state then p.HoldDuration = 0 end
        end)
    end})

    Tabs.Interact:AddToggle({Caption = "Notify monsters", Callback = function(state)
        getgenv().Notify = state
        workspace.ChildAdded:Connect(function(c)
            if getgenv().Notify and (c:FindFirstChild("MonsterRoot") or c.Name == "Angler") then
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Fire Hub", Text = "Entity: "..c.Name})
            end
        end)
    end})

    Tabs.Interact:AddButton({Caption = "Bruteforce closest door codelock", Callback = function()
        local lock = workspace:FindFirstChild("Codelock", true)
        if lock then
            for i = 0, 9999 do
                game:GetService("ReplicatedStorage").Events.UnlockDoor:FireServer(lock, string.format("%04d", i))
                if i % 20 == 0 then task.wait() end
                if not lock:Parent then break end
            end
        end
    end})

    -- --- SECTION VISUAL (IMG_6380) ---
    Tabs.Visual:AddToggle({Caption = "Rainbow ESP", Callback = function(state)
        getgenv().Rainbow = state
        task.spawn(function()
            while getgenv().Rainbow do
                local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Highlight") then v.FillColor = c end
                end
                task.wait()
            end
        end)
    end})

    Tabs.Visual:AddToggle({Caption = "Monster ESP", Callback = function(state)
        getgenv().MonstESP = state
        task.spawn(function()
            while getgenv().MonstESP do
                for _, v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("MonsterRoot") or v.Name == "Angler" then
                        if not v:FindFirstChild("Highlight") then Instance.new("Highlight", v) end
                    end
                end
                task.wait(1)
            end
        end)
    end})

    Tabs.Visual:AddButton({Caption = "Fullbright", Callback = function()
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
    end})
end

-- [ INITIALISATION ]
local windowFunc = function(window)
    task.spawn(mainWindow, window)
end

getGlobalTable().NFWF = windowFunc
return windowFunc
