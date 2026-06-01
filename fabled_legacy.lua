local mainScript = [[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local UseSpell = ReplicatedStorage:WaitForChild("useSpell", 5)
local Swing = ReplicatedStorage:WaitForChild("Swing", 5)
local DisplayPortals = ReplicatedStorage:WaitForChild("DisplayPortals", 5)
local getInventory = ReplicatedStorage:WaitForChild("getInventory", 5)

local configFileName = "FabledLegacy_Config.json"

-- ====================================================================
-- HỆ THỐNG LƯU VÀ TẢI CONFIG
-- ====================================================================
local function saveCurrentSettings()
    local configTable = {
        ToggleAutoDungeon = _G.ToggleAutoDungeon,
        ToggleAuraKill = _G.ToggleAuraKill,
        ToggleAutoR = _G.ToggleAutoR,
        ToggleAutoChestPortal = _G.ToggleAutoChestPortal,
        ToggleAntiAFK = _G.ToggleAntiAFK,
        ToggleAutoLobby = _G.ToggleAutoLobby,
        HeightOffset = _G.HeightOffset,
        AuraRadius = _G.AuraRadius
    }
    pcall(function()
        if writefile then
            writefile(configFileName, HttpService:JSONEncode(configTable))
        end
    end)
end

local function loadStoredSettings()
    _G.ToggleAutoDungeon = false
    _G.ToggleAuraKill = false
    _G.ToggleAutoR = false
    _G.ToggleAutoChestPortal = false
    _G.ToggleAntiAFK = false
    _G.ToggleAutoLobby = false
    _G.HeightOffset = 8
    _G.AuraRadius = 35

    pcall(function()
        if isfile and readfile and isfile(configFileName) then
            local decodedData = HttpService:JSONDecode(readfile(configFileName))
            if decodedData then
                if decodedData.ToggleAutoDungeon ~= nil then _G.ToggleAutoDungeon = decodedData.ToggleAutoDungeon end
                if decodedData.ToggleAuraKill ~= nil then _G.ToggleAuraKill = decodedData.ToggleAuraKill end
                if decodedData.ToggleAutoR ~= nil then _G.ToggleAutoR = decodedData.ToggleAutoR end
                if decodedData.ToggleAutoChestPortal ~= nil then _G.ToggleAutoChestPortal = decodedData.ToggleAutoChestPortal end
                if decodedData.ToggleAntiAFK ~= nil then _G.ToggleAntiAFK = decodedData.ToggleAntiAFK end
                if decodedData.ToggleAutoLobby ~= nil then _G.ToggleAutoLobby = decodedData.ToggleAutoLobby end
                if decodedData.HeightOffset ~= nil then _G.HeightOffset = decodedData.HeightOffset end
                if decodedData.AuraRadius ~= nil then _G.AuraRadius = decodedData.AuraRadius end
            end
        end
    end)
end

loadStoredSettings()

-- ====================================================================
-- HỆ THỐNG GIAO DIỆN UX/UI CHUYÊN NGHIỆP CÓ THU NHỎ
-- ====================================================================
local uiName = "FabledLegacyUltimateUI"
local pui = pcall(function() return CoreGui.Name end) and CoreGui or Player:WaitForChild("PlayerGui")
if pui:FindFirstChild(uiName) then pui[uiName]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", pui) 
ScreenGui.Name = uiName
ScreenGui.ResetOnSpawn = false

-- Icon Thu Nhỏ (Minimized State)
local MinimizedBtn = Instance.new("TextButton", ScreenGui)
MinimizedBtn.Size = UDim2.new(0, 50, 0, 50)
MinimizedBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
MinimizedBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MinimizedBtn.Text = "FL"
MinimizedBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
MinimizedBtn.Font = Enum.Font.GothamBold
MinimizedBtn.TextSize = 18
MinimizedBtn.Visible = false
MinimizedBtn.Active = true
MinimizedBtn.Draggable = true
Instance.new("UICorner", MinimizedBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", MinimizedBtn).Color = Color3.fromRGB(255, 215, 0)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 360)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(40, 40, 50)

-- Header Bar
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FABLED LEGACY ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút Thu Nhỏ (Minimize "-")
local MinimizeAction = Instance.new("TextButton", Header)
MinimizeAction.Size = UDim2.new(0, 35, 0, 35)
MinimizeAction.Position = UDim2.new(0.85, 0, 0, 0)
MinimizeAction.BackgroundTransparency = 1
MinimizeAction.Text = "—"
MinimizeAction.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeAction.Font = Enum.Font.GothamBold
MinimizeAction.TextSize = 14

MinimizeAction.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedBtn.Visible = true
end)

MinimizedBtn.MouseButton1Click:Connect(function()
    MinimizedBtn.Visible = false
    MainFrame.Visible = true
end)

-- Thanh cuộn chứa các chức năng (ScrollingFrame)
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, 0, 1, -65)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 340)

local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Hàm tạo UI Toggle
local function createToggleBtn(textOn, textOff, globalVar)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local function updateStyle()
        if _G[globalVar] then
            Btn.BackgroundColor3 = Color3.fromRGB(45, 160, 45)
            Btn.Text = textOn
        else
            Btn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
            Btn.Text = textOff
        end
    end
    updateStyle()
    
    Btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        updateStyle()
        saveCurrentSettings()
    end)
    Btn.Parent = ScrollFrame
end

-- Hàm tạo UI Input
local function createBoxInput(labelText, globalVar)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.9, 0, 0, 30)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.35, 0, 1, 0)
    Box.Position = UDim2.new(0.65, 0, 0, 0)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Box.Text = tostring(_G[globalVar])
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.Font = Enum.Font.GothamBold
    Box.TextSize = 12
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

    Box.FocusLost:Connect(function()
        local val = tonumber(Box.Text)
        if val then 
            _G[globalVar] = val 
            saveCurrentSettings()
        else 
            Box.Text = tostring(_G[globalVar]) 
        end
    end)
    Frame.Parent = ScrollFrame
end

-- Khởi tạo các nút trên UI
createToggleBtn("Auto Dungeon: ON", "Auto Dungeon: OFF", "ToggleAutoDungeon")
createToggleBtn("Aura Kill (Q, E): ON", "Aura Kill: OFF", "ToggleAuraKill")
createToggleBtn("Auto Skill R: ON", "Auto Skill R: OFF", "ToggleAutoR")
createToggleBtn("Auto Chest & Portal: ON", "Auto Chest & Portal: OFF", "ToggleAutoChestPortal")
createToggleBtn("Anti-AFK: ON", "Anti-AFK: OFF", "ToggleAntiAFK")
createToggleBtn("Auto Lobby: ON", "Auto Lobby: OFF", "ToggleAutoLobby")

createBoxInput("Độ cao (Height):", "HeightOffset")
createBoxInput("Bán kính Aura:", "AuraRadius")

local Footnote = Instance.new("TextLabel", MainFrame)
Footnote.Size = UDim2.new(1, 0, 0, 20)
Footnote.Position = UDim2.new(0, 0, 1, -20)
Footnote.BackgroundTransparency = 1
Footnote.Text = "Cấu hình tự động lưu"
Footnote.TextColor3 = Color3.fromRGB(120, 120, 130)
Footnote.Font = Enum.Font.Gotham
Footnote.TextSize = 10

-- ====================================================================
-- HỆ THỐNG XỬ LÝ (TỐI ƯU HÓA)
-- ====================================================================

-- Hàm phụ trợ quét mục tiêu
local function getEnemiesFolder() return Workspace:FindFirstChild("Enemies") end
local function getRootPart(model)
    if not model then return nil end
    return model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
end

local function triggerInteractPrompt(prompt)
    if not prompt or not prompt.Enabled then return end
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        task.spawn(function()
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration + 0.1)
            prompt:InputHoldEnd()
        end)
    end
end

-- 1. Anti AFK
Player.Idled:Connect(function()
    if _G.ToggleAntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- 2. Vòng lặp Auto Dungeon & Lobby
task.spawn(function()
    while task.wait(2) do
        -- Auto Dungeon (Retry/Reset)
        if _G.ToggleAutoDungeon then
            pcall(function()
                local args = { { true } }
                if ReplicatedStorage:FindFirstChild("StartLoopy") then ReplicatedStorage.StartLoopy:FireServer(unpack(args)) end
                if ReplicatedStorage:FindFirstChild("StartDungeon") then ReplicatedStorage.StartDungeon:FireServer(unpack(args)) end
                
                local WCUI = Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("WCUI")
                if WCUI then
                    for _, folder in ipairs({WCUI:FindFirstChild("RaidUI"), WCUI:FindFirstChild("Event"), WCUI:FindFirstChild("StarterPlayerScripts")}) do
                        if folder then
                            for _, child in ipairs(folder:GetChildren()) do
                                if child.Name:match("Result") or child.Name:match("Reset") then
                                    local btn = child:FindFirstChild("Next") or child:FindFirstChild("Retry") or child:FindFirstChild("ResetRaidBtn")
                                    if btn and btn.ClassName == "TextButton" and btn.Visible then
                                        VirtualUser:CaptureController()
                                        VirtualUser:ClickButton1(Vector2.new(btn.AbsolutePosition.X + (btn.AbsoluteSize.X / 2), btn.AbsolutePosition.Y + (btn.AbsoluteSize.Y / 2)))
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        
        -- Auto Lobby
        if _G.ToggleAutoLobby then
            pcall(function()
                local CreateLobby = ReplicatedStorage:FindFirstChild("CreateLobby")
                local StartLobby = ReplicatedStorage:FindFirstChild("StartLobby")
                if CreateLobby and StartLobby then
                    CreateLobby:InvokeServer({["Map"] = "Cursed Marshes", ["Calamity"] = false, ["Hardcore"] = false, ["NoHit"] = false, ["Difficulty"] = "Expert", ["LevelRequirement"] = 45, ["Tier"] = 0, ["Private"] = false, ["Easter"] = false})
                    task.wait(1.5)
                    StartLobby:FireServer()
                end
            end)
        end
    end
end)

-- 3. Vòng lặp Chiến đấu: Aura Kill (Q, E, Swing) + Auto R + Auto Portals/Chest
task.spawn(function()
    local lastCast = 0
    local lastPortalCheck = 0
    
    while task.wait(0.1) do
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local Mobs = getEnemiesFolder()
        
        if not hrp then continue end

        -- QUẢN LÝ QUÁI VẬT & CHIẾN ĐẤU
        if Mobs then
            local closestDist, targetEnemy, targetPart = math.huge, nil, nil
            local aliveCount = 0
            
            for _, obj in ipairs(Mobs:GetDescendants()) do
                if obj:IsA("Model") then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    local part = getRootPart(obj)
                    if hum and hum.Health > 0 and part then
                        aliveCount = aliveCount + 1
                        local dist = (hrp.Position - part.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            targetEnemy = obj
                            targetPart = part
                        end
                    end
                end
            end

            -- Nếu có quái và bật Auto R
            if aliveCount > 0 and _G.ToggleAutoR and UseSpell then
                pcall(function() UseSpell:FireServer("R") end)
            end

            -- Aura Kill Logic
            if _G.ToggleAuraKill and targetEnemy and targetPart then
                pcall(function()
                    local centerPos = targetPart.Position
                    hrp.CFrame = CFrame.lookAt(centerPos + Vector3.new(0, _G.HeightOffset, 0), centerPos)
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    local now = tick()
                    local canCastSpell = (now - lastCast) >= 0.3
                    local hitCount = 0
                    
                    for _, mob in ipairs(Mobs:GetDescendants()) do
                        if mob:IsA("Model") and hitCount < 5 then
                            local mPart = getRootPart(mob)
                            local mHum = mob:FindFirstChildOfClass("Humanoid")
                            if mPart and mHum and mHum.Health > 0 and (hrp.Position - mPart.Position).Magnitude <= _G.AuraRadius then
                                hitCount = hitCount + 1
                                if Swing then Swing:FireServer(); Swing:FireServer(mob) end
                                if UseSpell and canCastSpell then
                                    UseSpell:FireServer("Q", mPart.Position); UseSpell:FireServer("q", mPart)
                                    UseSpell:FireServer("E", mPart.Position); UseSpell:FireServer("e", mPart)
                                    lastCast = now
                                end
                            end
                        end
                    end
                end)
            end

            -- Auto Chest & Portal Logic (Khi sạch bóng quái)
            if _G.ToggleAutoChestPortal and aliveCount == 0 and (tick() - lastPortalCheck > 2) then
                pcall(function()
                    -- 1. Tìm và mở rương Rewards trước
                    for _, desc in ipairs(Workspace:GetDescendants()) do
                        if desc:IsA("ProximityPrompt") and desc.Enabled then
                            local objText, actText, nameText = desc.ObjectText or "", desc.ActionText or "", desc.Name or ""
                            local isSellSafe = objText:match("Sell") or actText:match("Sell") or nameText:match("Sell") or objText:match("Shop") or actText:match("Shop") or nameText:match("Shop")
                            
                            if not isSellSafe and objText == "Claim Rewards" and actText == "Interact" then
                                local promptParent = desc:FindFirstAncestorOfClass("Part") or desc:FindFirstAncestorOfClass("MeshPart") or desc.Parent
                                if promptParent and promptParent:IsA("BasePart") then
                                    if (hrp.Position - promptParent.Position).Magnitude > 15 then
                                        hrp.CFrame = promptParent.CFrame * CFrame.new(0, 2, 4)
                                        task.wait(0.5)
                                    end
                                    triggerInteractPrompt(desc)
                                    task.wait(0.5)
                                    if getInventory then getInventory:InvokeServer(3411886796 or Player.UserId) end
                                    task.wait(1)
                                end
                            end
                        end
                    end
                    
                    -- 2. Chọn Portal số 2 sau khi nhận thưởng
                    if DisplayPortals then
                        DisplayPortals:FireServer(2)
                    end
                end)
                lastPortalCheck = tick()
            end
        end
    end
end)
]]

loadstring(mainScript)()

local queue = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if queue then
    queue(mainScript)
end
