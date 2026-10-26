--[[
    ╔══════════════════════════════════════════════╗
    ║           Darkness Soft - Blox Strike        ║
    ║                  for Delta                   ║
    ║                                              ║
    ║  Key: darknes                                ║
    ║  Features:                                   ║
    ║  • Silent Aim                                ║
    ║  • Aimbot                                    ║
    ║  • ESP (Boxes, Names, Health)                ║
    ║  • Fullbright                                ║
    ║  • Skin Changer Loader                       ║
    ╚══════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==================== KEY SYSTEM ====================
local CORRECT_KEY = "darknes"

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "DarknessKey"
KeyGui.ResetOnSpawn = false
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.Parent = game:GetService("CoreGui")

local KeyMain = Instance.new("Frame")
KeyMain.Size = UDim2.new(0, 340, 0, 210)
KeyMain.Position = UDim2.new(0.5, -170, 0.5, -105)
KeyMain.BackgroundColor3 = Color3.fromRGB(16, 10, 14)
KeyMain.BorderSizePixel = 0
KeyMain.Parent = KeyGui
Instance.new("UICorner", KeyMain).CornerRadius = UDim.new(0, 12)

local KeyStroke = Instance.new("UIStroke", KeyMain)
KeyStroke.Color = Color3.fromRGB(255, 55, 90)
KeyStroke.Thickness = 1.4

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Position = UDim2.new(0, 0, 0, 15)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Darkness Soft"
KeyTitle.TextColor3 = Color3.fromRGB(255, 90, 120)
KeyTitle.TextSize = 20
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyMain

local KeySub = Instance.new("TextLabel")
KeySub.Size = UDim2.new(1, 0, 0, 20)
KeySub.Position = UDim2.new(0, 0, 0, 50)
KeySub.BackgroundTransparency = 1
KeySub.Text = "Enter Key to continue"
KeySub.TextColor3 = Color3.fromRGB(180, 130, 150)
KeySub.TextSize = 13
KeySub.Font = Enum.Font.Gotham
KeySub.Parent = KeyMain

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 260, 0, 36)
KeyBox.Position = UDim2.new(0.5, -130, 0, 85)
KeyBox.BackgroundColor3 = Color3.fromRGB(30, 16, 24)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Key..."
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(140, 100, 120)
KeyBox.TextSize = 15
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyMain
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local KeyBoxStroke = Instance.new("UIStroke", KeyBox)
KeyBoxStroke.Color = Color3.fromRGB(70, 30, 50)
KeyBoxStroke.Thickness = 1

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0, 260, 0, 36)
SubmitBtn.Position = UDim2.new(0.5, -130, 0, 135)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 90)
SubmitBtn.Text = "Submit"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 15
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyMain
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0, 0, 0, 178)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
ErrorLabel.TextSize = 12
ErrorLabel.Font = Enum.Font.Gotham
ErrorLabel.Parent = KeyMain

local function LoadMainScript()
    KeyGui:Destroy()

    -- ==================== SETTINGS ====================
    local Settings = {
        Aimbot = {
            Enabled = false,
            Key = Enum.KeyCode.E,
            Smoothness = 0.17,
            FOV = 115,
            TeamCheck = true,
            AimPart = "Head"
        },
        SilentAim = {
            Enabled = false,
            FOV = 85,
            HitChance = 92,
            TeamCheck = true,
            AimPart = "Head",
            Sticky = true
        },
        ESP = {
            Enabled = false,
            Boxes = true,
            Names = true,
            Health = true,
            TeamCheck = true,
            Color = Color3.fromRGB(255, 55, 90)
        }
    }

    -- ==================== UTILITY ====================
    local function IsAlive(p)
        return p and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0
    end

    local function IsEnemy(p)
        if not Settings.Aimbot.TeamCheck then return true end
        return p.Team ~= LocalPlayer.Team
    end

    local function GetClosest(fov, silent)
        local closest, shortest = nil, fov
        local mousePos = Vector2.new(Mouse.X, Mouse.Y)
        local partName = silent and Settings.SilentAim.AimPart or Settings.Aimbot.AimPart

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsAlive(player) and IsEnemy(player) then
                local part = player.Character:FindFirstChild(partName) or player.Character:FindFirstChild("Head")
                if part then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if dist < shortest then
                            closest = player
                            shortest = dist
                        end
                    end
                end
            end
        end
        return closest
    end

    -- FOV Circles
    local AimFOV = Drawing.new("Circle")
    AimFOV.Thickness = 1.5
    AimFOV.NumSides = 64
    AimFOV.Filled = false
    AimFOV.Color = Color3.fromRGB(255, 55, 90)
    AimFOV.Transparency = 0.7
    AimFOV.Visible = false

    local SilentFOV = Drawing.new("Circle")
    SilentFOV.Thickness = 1.5
    SilentFOV.NumSides = 64
    SilentFOV.Filled = false
    SilentFOV.Color = Color3.fromRGB(0, 255, 140)
    SilentFOV.Transparency = 0.65
    SilentFOV.Visible = false

    -- ==================== AIMBOT ====================
    local aiming = false
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Settings.Aimbot.Key then aiming = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Settings.Aimbot.Key then aiming = false end
    end)

    RunService.RenderStepped:Connect(function()
        AimFOV.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        AimFOV.Radius = Settings.Aimbot.FOV
        AimFOV.Visible = Settings.Aimbot.Enabled

        SilentFOV.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        SilentFOV.Radius = Settings.SilentAim.FOV
        SilentFOV.Visible = Settings.SilentAim.Enabled

        if Settings.Aimbot.Enabled and aiming then
            local target = GetClosest(Settings.Aimbot.FOV, false)
            if target and target.Character then
                local part = target.Character:FindFirstChild(Settings.Aimbot.AimPart) or target.Character.Head
                if part then
                    local pos = Camera:WorldToViewportPoint(part.Position)
                    local delta = Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)
                    mousemoverel(delta.X * Settings.Aimbot.Smoothness, delta.Y * Settings.Aimbot.Smoothness)
                end
            end
        end
    end)

    -- ==================== SILENT AIM ====================
    local currentTarget = nil
    local function getSilentTarget()
        if not Settings.SilentAim.Enabled then 
            currentTarget = nil 
            return nil 
        end
        if math.random(1, 100) > Settings.SilentAim.HitChance then return nil end

        local target = GetClosest(Settings.SilentAim.FOV, true)

        if Settings.SilentAim.Sticky and currentTarget and IsAlive(currentTarget) then
            local part = currentTarget.Character:FindFirstChild(Settings.SilentAim.AimPart) or currentTarget.Character.Head
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist <= Settings.SilentAim.FOV * 1.3 then
                        return currentTarget
                    end
                end
            end
        end
        currentTarget = target
        return target
    end

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if Settings.SilentAim.Enabled and not checkcaller() then
            if method == "Raycast" or method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" then
                local target = getSilentTarget()
                if target and target.Character then
                    local part = target.Character:FindFirstChild(Settings.SilentAim.AimPart) or target.Character.Head
                    if part then
                        if typeof(args[1]) == "Vector3" then
                            args[2] = (part.Position - args[1]).Unit * 1000
                            return oldNamecall(self, unpack(args))
                        elseif typeof(args[1]) == "Ray" then
                            args[1] = Ray.new(args[1].Origin, (part.Position - args[1].Origin).Unit * 1000)
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
            end
        end
        return oldNamecall(self, ...)
    end))

    -- ==================== ESP ====================
    local ESPObjects = {}
    local function CreateESP(player)
        if ESPObjects[player] then return end
        local box = Drawing.new("Square")
        box.Thickness = 1.2
        box.Filled = false
        box.Color = Settings.ESP.Color
        box.Visible = false

        local name = Drawing.new("Text")
        name.Size = 14
        name.Center = true
        name.Outline = true
        name.Color = Color3.fromRGB(255, 255, 255)
        name.Visible = false

        local health = Drawing.new("Text")
        health.Size = 13
        health.Center = true
        health.Outline = true
        health.Color = Color3.fromRGB(0, 255, 120)
        health.Visible = false

        ESPObjects[player] = {Box = box, Name = name, Health = health}
    end

    Players.PlayerAdded:Connect(CreateESP)
    Players.PlayerRemoving:Connect(function(p)
        if ESPObjects[p] then
            for _, v in pairs(ESPObjects[p]) do v:Remove() end
            ESPObjects[p] = nil
        end
    end)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then CreateESP(p) end
    end

    RunService.RenderStepped:Connect(function()
        for player, d in pairs(ESPObjects) do
            if Settings.ESP.Enabled and IsAlive(player) and (not Settings.ESP.TeamCheck or IsEnemy(player)) then
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local head = char and char:FindFirstChild("Head")
                local hum = char and char:FindFirstChild("Humanoid")
                if root and head and hum then
                    local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                    if onScreen then
                        local h = math.abs(headPos.Y - legPos.Y)
                        local w = h / 1.85
                        d.Box.Size = Vector2.new(w, h)
                        d.Box.Position = Vector2.new(rootPos.X - w/2, headPos.Y)
                        d.Box.Visible = Settings.ESP.Boxes
                        d.Box.Color = Settings.ESP.Color

                        d.Name.Text = player.Name
                        d.Name.Position = Vector2.new(rootPos.X, headPos.Y - 16)
                        d.Name.Visible = Settings.ESP.Names

                        d.Health.Text = math.floor(hum.Health) .. " HP"
                        d.Health.Position = Vector2.new(rootPos.X, legPos.Y + 3)
                        d.Health.Visible = Settings.ESP.Health
                    else
                        d.Box.Visible = false
                        d.Name.Visible = false
                        d.Health.Visible = false
                    end
                end
            else
                d.Box.Visible = false
                d.Name.Visible = false
                d.Health.Visible = false
            end
        end
    end)

    -- ==================== CUSTOM UI ====================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DarknessSoft"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 560, 0, 440)
    Main.Position = UDim2.new(0.5, -280, 0.5, -220)
    Main.BackgroundColor3 = Color3.fromRGB(16, 10, 14)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", Main)
    stroke.Color = Color3.fromRGB(60, 25, 40)
    stroke.Thickness = 1.2

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 42)
    TopBar.BackgroundColor3 = Color3.fromRGB(22, 12, 18)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local TopFix = Instance.new("Frame")
    TopFix.Size = UDim2.new(1, 0, 0, 15)
    TopFix.Position = UDim2.new(0, 0, 1, -15)
    TopFix.BackgroundColor3 = Color3.fromRGB(22, 12, 18)
    TopFix.BorderSizePixel = 0
    TopFix.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 280, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Darkness Soft  -  Blox Strike"
    Title.TextColor3 = Color3.fromRGB(255, 90, 120)
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local Discord = Instance.new("TextLabel")
    Discord.Size = UDim2.new(0, 140, 1, 0)
    Discord.Position = UDim2.new(0, 300, 0, 0)
    Discord.BackgroundTransparency = 1
    Discord.Text = "discord.gg/darkness"
    Discord.TextColor3 = Color3.fromRGB(180, 100, 130)
    Discord.TextSize = 12
    Discord.Font = Enum.Font.Gotham
    Discord.TextXAlignment = Enum.TextXAlignment.Left
    Discord.Parent = TopBar

    local ReleaseBtn = Instance.new("TextButton")
    ReleaseBtn.Size = UDim2.new(0, 80, 0, 24)
    ReleaseBtn.Position = UDim2.new(1, -130, 0.5, -12)
    ReleaseBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 90)
    ReleaseBtn.Text = "Release"
    ReleaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ReleaseBtn.TextSize = 12
    ReleaseBtn.Font = Enum.Font.GothamBold
    ReleaseBtn.Parent = TopBar
    Instance.new("UICorner", ReleaseBtn).CornerRadius = UDim.new(0, 6)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 130)
    CloseBtn.TextSize = 22
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        AimFOV:Remove()
        SilentFOV:Remove()
        for _, d in pairs(ESPObjects) do
            for _, v in pairs(d) do v:Remove() end
        end
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -42)
    Sidebar.Position = UDim2.new(0, 0, 0, 42)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 11, 16)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

    local SideFix = Instance.new("Frame")
    SideFix.Size = UDim2.new(0, 20, 1, 0)
    SideFix.Position = UDim2.new(1, -20, 0, 0)
    SideFix.BackgroundColor3 = Color3.fromRGB(20, 11, 16)
    SideFix.BorderSizePixel = 0
    SideFix.Parent = Sidebar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -150, 1, -52)
    Content.Position = UDim2.new(0, 145, 0, 48)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    -- Tab System
    local TabButtons = {}
    local TabFrames = {}

    local function CreateTabButton(name, yPos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -16, 0, 34)
        btn.Position = UDim2.new(0, 8, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(30, 16, 24)
        btn.BackgroundTransparency = 1
        btn.Text = "  " .. name
        btn.TextColor3 = Color3.fromRGB(200, 140, 160)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamMedium
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = Sidebar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        TabButtons[name] = btn

        btn.MouseButton1Click:Connect(function()
            for n, f in pairs(TabFrames) do
                f.Visible = (n == name)
            end
            for n, b in pairs(TabButtons) do
                if n == name then
                    b.BackgroundTransparency = 0
                    b.TextColor3 = Color3.fromRGB(255, 80, 110)
                else
                    b.BackgroundTransparency = 1
                    b.TextColor3 = Color3.fromRGB(200, 140, 160)
                end
            end
        end)
    end

    CreateTabButton("ESP", 12)
    CreateTabButton("Aimbot", 50)
    CreateTabButton("Silent Aim", 88)
    CreateTabButton("Misc", 126)
    CreateTabButton("Skins", 164)
    CreateTabButton("Settings", 202)

    TabButtons["ESP"].BackgroundTransparency = 0
    TabButtons["ESP"].TextColor3 = Color3.fromRGB(255, 80, 110)

    -- Toggle Creator
    local function CreateToggle(parent, text, default, callback, yPos)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(1, -20, 0, 36)
        holder.Position = UDim2.new(0, 10, 0, yPos)
        holder.BackgroundTransparency = 1
        holder.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(230, 200, 210)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = holder

        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, 44, 0, 22)
        toggleBg.Position = UDim2.new(1, -50, 0.5, -11)
        toggleBg.BackgroundColor3 = default and Color3.fromRGB(255, 55, 90) or Color3.fromRGB(50, 30, 40)
        toggleBg.BorderSizePixel = 0
        toggleBg.Parent = holder
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 16, 0, 16)
        circle.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.BorderSizePixel = 0
        circle.Parent = toggleBg
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local state = default
        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.Parent = holder

        clickBtn.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(circle, TweenInfo.new(0.18), {
                Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            }):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.18), {
                BackgroundColor3 = state and Color3.fromRGB(255, 55, 90) or Color3.fromRGB(50, 30, 40)
            }):Play()
            if callback then callback(state) end
        end)
    end

    -- ESP Tab
    local ESPFrame = Instance.new("ScrollingFrame")
    ESPFrame.Size = UDim2.new(1, 0, 1, 0)
    ESPFrame.BackgroundTransparency = 1
    ESPFrame.ScrollBarThickness = 3
    ESPFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 55, 90)
    ESPFrame.Visible = true
    ESPFrame.Parent = Content
    TabFrames["ESP"] = ESPFrame

    local ESPTitle = Instance.new("TextLabel")
    ESPTitle.Size = UDim2.new(1, -20, 0, 28)
    ESPTitle.Position = UDim2.new(0, 10, 0, 5)
    ESPTitle.BackgroundTransparency = 1
    ESPTitle.Text = "Player ESP"
    ESPTitle.TextColor3 = Color3.fromRGB(255, 90, 120)
    ESPTitle.TextSize = 16
    ESPTitle.Font = Enum.Font.GothamBold
    ESPTitle.TextXAlignment = Enum.TextXAlignment.Left
    ESPTitle.Parent = ESPFrame

    CreateToggle(ESPFrame, "Player ESP", false, function(v) Settings.ESP.Enabled = v end, 40)
    CreateToggle(ESPFrame, "Boxes", true, function(v) Settings.ESP.Boxes = v end, 80)
    CreateToggle(ESPFrame, "Nametag ESP", true, function(v) Settings.ESP.Names = v end, 120)
    CreateToggle(ESPFrame, "Health ESP", true, function(v) Settings.ESP.Health = v end, 160)

    -- Aimbot Tab
    local AimbotFrame = Instance.new("ScrollingFrame")
    AimbotFrame.Size = UDim2.new(1, 0, 1, 0)
    AimbotFrame.BackgroundTransparency = 1
    AimbotFrame.ScrollBarThickness = 3
    AimbotFrame.Visible = false
    AimbotFrame.Parent = Content
    TabFrames["Aimbot"] = AimbotFrame

    local AimbotTitle = Instance.new("TextLabel")
    AimbotTitle.Size = UDim2.new(1, -20, 0, 28)
    AimbotTitle.Position = UDim2.new(0, 10, 0, 5)
    AimbotTitle.BackgroundTransparency = 1
    AimbotTitle.Text = "Aimbot"
    AimbotTitle.TextColor3 = Color3.fromRGB(255, 90, 120)
    AimbotTitle.TextSize = 16
    AimbotTitle.Font = Enum.Font.GothamBold
    AimbotTitle.TextXAlignment = Enum.TextXAlignment.Left
    AimbotTitle.Parent = AimbotFrame

    CreateToggle(AimbotFrame, "Aimbot", false, function(v) Settings.Aimbot.Enabled = v end, 40)
    CreateToggle(AimbotFrame, "Team Check", true, function(v)
        Settings.Aimbot.TeamCheck = v
        Settings.SilentAim.TeamCheck = v
        Settings.ESP.TeamCheck = v
    end, 80)

    -- Silent Aim Tab
    local SilentFrame = Instance.new("ScrollingFrame")
    SilentFrame.Size = UDim2.new(1, 0, 1, 0)
    SilentFrame.BackgroundTransparency = 1
    SilentFrame.ScrollBarThickness = 3
    SilentFrame.Visible = false
    SilentFrame.Parent = Content
    TabFrames["Silent Aim"] = SilentFrame

    local SilentTitle = Instance.new("TextLabel")
    SilentTitle.Size = UDim2.new(1, -20, 0, 28)
    SilentTitle.Position = UDim2.new(0, 10, 0, 5)
    SilentTitle.BackgroundTransparency = 1
    SilentTitle.Text = "Silent Aim"
    SilentTitle.TextColor3 = Color3.fromRGB(255, 90, 120)
    SilentTitle.TextSize = 16
    SilentTitle.Font = Enum.Font.GothamBold
    SilentTitle.TextXAlignment = Enum.TextXAlignment.Left
    SilentTitle.Parent = SilentFrame

    CreateToggle(SilentFrame, "Silent Aim", false, function(v) Settings.SilentAim.Enabled = v end, 40)
    CreateToggle(SilentFrame, "Sticky Target", true, function(v) Settings.SilentAim.Sticky = v end, 80)

    -- Misc Tab
    local MiscFrame = Instance.new("ScrollingFrame")
    MiscFrame.Size = UDim2.new(1, 0, 1, 0)
    MiscFrame.BackgroundTransparency = 1
    MiscFrame.Visible = false
    MiscFrame.Parent = Content
    TabFrames["Misc"] = MiscFrame

    CreateToggle(MiscFrame, "Fullbright", false, function(v)
        local L = game:GetService("Lighting")
        if v then
            L.Brightness = 2
            L.ClockTime = 14
            L.FogEnd = 100000
            L.GlobalShadows = false
        else
            L.Brightness = 1
            L.GlobalShadows = true
        end
    end, 20)

    -- Skins Tab
    local SkinsFrame = Instance.new("ScrollingFrame")
    SkinsFrame.Size = UDim2.new(1, 0, 1, 0)
    SkinsFrame.BackgroundTransparency = 1
    SkinsFrame.Visible = false
    SkinsFrame.Parent = Content
    TabFrames["Skins"] = SkinsFrame

    local SkinBtn = Instance.new("TextButton")
    SkinBtn.Size = UDim2.new(1, -30, 0, 38)
    SkinBtn.Position = UDim2.new(0, 15, 0, 20)
    SkinBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 90)
    SkinBtn.Text = "Load Full Skin Changer"
    SkinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SkinBtn.TextSize = 14
    SkinBtn.Font = Enum.Font.GothamBold
    SkinBtn.Parent = SkinsFrame
    Instance.new("UICorner", SkinBtn).CornerRadius = UDim.new(0, 8)

    SkinBtn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://expectional.dev/loadstring/Blox-Strike-Skinchanger.lua"))()
    end)

    -- Settings Tab
    local SettingsFrame = Instance.new("ScrollingFrame")
    SettingsFrame.Size = UDim2.new(1, 0, 1, 0)
    SettingsFrame.BackgroundTransparency = 1
    SettingsFrame.Visible = false
    SettingsFrame.Parent = Content
    TabFrames["Settings"] = SettingsFrame

    local DestroyBtn = Instance.new("TextButton")
    DestroyBtn.Size = UDim2.new(1, -30, 0, 38)
    DestroyBtn.Position = UDim2.new(0, 15, 0, 20)
    DestroyBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
    DestroyBtn.Text = "Destroy UI"
    DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DestroyBtn.TextSize = 14
    DestroyBtn.Font = Enum.Font.GothamBold
    DestroyBtn.Parent = SettingsFrame
    Instance.new("UICorner", DestroyBtn).CornerRadius = UDim.new(0, 8)

    DestroyBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        AimFOV:Remove()
        SilentFOV:Remove()
        for _, d in pairs(ESPObjects) do
            for _, v in pairs(d) do v:Remove() end
        end
    end)

    print("[Darkness Soft] Loaded successfully | Key accepted")
end

-- ==================== KEY CHECK ====================
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CORRECT_KEY then
        ErrorLabel.Text = "Success!"
        ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
        task.wait(0.35)
        LoadMainScript()
    else
        ErrorLabel.Text = "Wrong key!"
        ErrorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        KeyBox.Text = ""
    end
end)

KeyBox.FocusLost:Connect(function(enter)
    if enter then
        if KeyBox.Text == CORRECT_KEY then
            ErrorLabel.Text = "Success!"
            ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
            task.wait(0.35)
            LoadMainScript()
        else
            ErrorLabel.Text = "Wrong key!"
            ErrorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            KeyBox.Text = ""
        end
    end
end)
