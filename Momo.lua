local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Teleport Gunung",
   LoadingTitle = "Teleport GUI",
   LoadingSubtitle = "Support Delta",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "TeleportGunung",
      FileName = "Config"
   },
   KeySystem = false
})

--------------------------------------------------
-- TAB TELEPORT
--------------------------------------------------
local Tab = Window:CreateTab("Teleport", 4483362458)

-- Lokasi teleport
local Teleports = {
    ["Pos 1"] = Vector3.new(282.89, 13.31, 318.10),
    ["Pos 2"] = Vector3.new(232.8, 53.0, 516.4),
    ["Pos 3"] = Vector3.new(-14.6, 57.0, 308.1),
    ["Pos 4"] = Vector3.new(-333.09, 64.90, 214.66),
    ["Pos 5"] = Vector3.new(-591.19, 99.06, -77.94),
    ["Pos 6"] = Vector3.new(-965.3, 102.9, -4.2),
    ["Pos 7"] = Vector3.new(-1293.8, 197.0, 224.8),
    ["Pos 8"] = Vector3.new(-1650.8, 206.5, 164.7),
    ["Summit"] = Vector3.new(-1980.78, 290.62, 94.75)
}

local OrderedNames = {
    "Pos 1", "Pos 2", "Pos 3", "Pos 4", "Pos 5", "Pos 6", "Pos 7", "Pos 8", "Summit"
}

-- Fungsi teleport
local function teleportTo(location)
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(location)
    end
end

local AutoTeleporting = false
local DelayTime = 0.9

local function autoTeleportOnce()
    local plr = game.Players.LocalPlayer
    for _, name in ipairs(OrderedNames) do
        local pos = Teleports[name]
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
        task.wait(DelayTime)
    end
end

local function autoTeleportLoop()
    while AutoTeleporting do
        autoTeleportOnce()
    end
end

-- Tombol-tombol
Tab:CreateButton({
    Name = "Auto Teleport (Sekali)",
    Callback = function()
        autoTeleportOnce()
    end,
})

Tab:CreateToggle({
    Name = "Auto Teleport (Berulang)",
    CurrentValue = false,
    Callback = function(Value)
        AutoTeleporting = Value
        if Value then
            task.spawn(autoTeleportLoop)
        end
    end,
})

for _, name in ipairs(OrderedNames) do
    local pos = Teleports[name]
    Tab:CreateButton({
        Name = "Teleport ke " .. name,
        Callback = function()
            teleportTo(pos)
        end,
    })
end

--------------------------------------------------
-- TAB OTHER
--------------------------------------------------
local TabOther = Window:CreateTab("Other", 4483362458)

-- Infinite Health
local infHealth = false
TabOther:CreateToggle({
    Name = "Infinite Health",
    CurrentValue = false,
    Callback = function(Value)
        infHealth = Value
        local plr = game.Players.LocalPlayer
        task.spawn(function()
            while infHealth do
                task.wait(0.5)
                if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                    plr.Character:FindFirstChildOfClass("Humanoid").Health = plr.Character:FindFirstChildOfClass("Humanoid").MaxHealth
                end
            end
        end)
    end,
})

-- Infinite Jump
local infJump = false
TabOther:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        infJump = Value
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Remove Network Pause / Gameplay Pause
TabOther:CreateButton({
    Name = "Remove Network Pause",
    Callback = function()
        settings().Physics.AllowSleep = false
        sethiddenproperty(game, "NetworkPauseEnabled", false)
        Rayfield:Notify({
            Title = "Network Pause",
            Content = "Network pause telah di-nonaktifkan!",
            Duration = 5
        })
    end,
})

--------------------------------------------------
-- NOTIFY LOAD
--------------------------------------------------
Rayfield:Notify({
   Title = "Teleport GUI",
   Content = "Script berhasil dimuat!",
   Duration = 5
})
