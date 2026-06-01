local mainScript = [[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService") -- Thư viện mã hóa JSON để lưu file

local Player = Players.LocalPlayer
local UseSpell = ReplicatedStorage:WaitForChild("useSpell", 5)
local Swing = ReplicatedStorage:WaitForChild("Swing", 5)

-- Tên file cấu hình sẽ lưu trong thư mục phần mềm hack của bạn
local configFileName = "FabledLegacy_Config.json"

-- ====================================================================
-- HỆ THỐNG LƯU VÀ TẢI CONFIG CỦA SCRIPT
-- ====================================================================
local function saveCurrentSettings()
    local configTable = {
        ToggleAutoDungeon = _G.ToggleAutoDungeon,
        ToggleAuraKill = _G.ToggleAuraKill,
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
    -- Thiết lập giá trị mặc định ban đầu là luôn OFF
    _G.ToggleAutoDungeon = false
    _G.ToggleAuraKill = false
    _G.ToggleAntiAFK = false
    _G.ToggleAutoLobby = false
    _G.HeightOffset = 8
    _G.AuraRadius = 35

    -- Tiến hành đọc file nếu có dữ liệu đã lưu từ trước
    pcall(function()
        if isfile and readfile and isfile(configFileName) then
            local decodedData = HttpService:JSONDecode(readfile(configFileName))
            if decodedData then
                if decodedData.ToggleAutoDungeon ~= nil then _G.ToggleAutoDungeon = decodedData.ToggleAutoDungeon end
                if decodedData.ToggleAuraKill ~= nil then _G.ToggleAuraKill = decodedData.ToggleAuraKill end
                if decodedData.ToggleAntiAFK ~= nil then _G.ToggleAntiAFK = decodedData.ToggleAntiAFK end
                if decodedData.ToggleAutoLobby ~= nil then _G.ToggleAutoLobby = decodedData.ToggleAutoLobby end
                if decodedData.HeightOffset ~= nil then _G.HeightOffset = decodedData.HeightOffset end
                if decodedData.AuraRadius ~= nil then _G.AuraRadius = decodedData.AuraRadius end
            end
        end
    end)
end

-- Chạy hàm tải dữ liệu cấu hình ngay khi chạy Script
loadStoredSettings()

-- ====================================================================
-- HỆ THỐNG GIAO DIỆN UX/UI CHUYÊN NGHIỆP
-- ====================================================================
local uiName = "FabledLegacyUltimateUI"
local pui = pcall(function() return game:GetService("CoreGui").Name end) and game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
if pui:FindFirstChild(uiName) then pui[uiName]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", pui) ScreenGui.Name = uiName

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 330)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "FABLED LEGACY ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13

-- Hàm tạo nút bật tắt nhanh (Có tích hợp Tự động Lưu)
local function createToggleBtn(yPos, textOn, textOff, globalVar)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.Position = UDim2.new(0.05, 0, 0, yPos)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local function updateStyle()
        if _G[globalVar] then
            Btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
            Btn.Text = textOn
        else
            Btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            Btn.Text = textOff
        end
    end
    
    updateStyle()
    
    Btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        updateStyle()
        saveCurrentSettings() -- TỰ ĐỘNG LƯU KHI BẤM NÚT
    end)
    return Btn
end

createToggleBtn(45, "Auto Dungeon: ON", "Auto Dungeon: OFF", "ToggleAutoDungeon")
createToggleBtn(85, "Aura Kill: ON", "Aura Kill: OFF", "ToggleAuraKill")
createToggleBtn(125, "Anti-AFK: ON", "Anti-AFK: OFF", "ToggleAntiAFK")
createToggleBtn(165, "Auto Lobby: ON", "Auto Lobby: OFF", "ToggleAutoLobby")

-- Hàm tạo ô nhập chỉ số TextBox (Có tích hợp Tự động Lưu)
local function createBoxInput(yPos, labelText, globalVar)
    local Label = Instance.new("TextLabel", MainFrame)
    Label.Size = UDim2.new(0.5, 0, 0, 30)
    Label.Position = UDim2.new(0.05, 0, 0, yPos)
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Box = Instance.new("TextBox", MainFrame)
    Box.Size = UDim2.new(0.35, 0, 0, 30)
    Box.Position = UDim2.new(0.55, 0, 0, yPos)
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
            saveCurrentSettings() -- TỰ ĐỘNG LƯU KHI THAY ĐỔI SỐ
        else 
            Box.Text = tostring(_G[globalVar]) 
        end
    end)
end

createBoxInput(210, "Độ cao so với quái:", "HeightOffset")
createBoxInput(250, "Bán kính Aura (Rad):", "AuraRadius")

local Footnote = Instance.new("TextLabel", MainFrame)
Footnote.Size = UDim2.new(1, 0, 0, 25)
Footnote.Position = UDim2.new(0, 0, 1, -25)
Footnote.BackgroundTransparency = 1
Footnote.Text = "Tự động nhớ cấu hình khi qua màn"
Footnote.TextColor3 = Color3.fromRGB(120, 120, 130)
Footnote.Font = Enum.Font.Gotham
Footnote.TextSize = 10

-- ====================================================================
-- VÒNG LẶP CHỨC NĂNG (DUNGEON / AURA / ANTI-AFK / AUTO LOBBY)
-- ====================================================================

-- 1. Anti AFK Chống văng game
Player.Idled:Connect(function()
    if _G.ToggleAntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- 2. Vòng lặp Auto Dungeon (Tự động click chuyển màn)
task.spawn(function()
    while task.wait(2) do
        if _G.ToggleAutoDungeon then
            pcall(function()
                local args = { { true } }
                local StartLoopy = ReplicatedStorage:FindFirstChild("StartLoopy")
                if StartLoopy then StartLoopy:FireServer(unpack(args)) end
                
                local StartDungeon = ReplicatedStorage:FindFirstChild("StartDungeon")
                if StartDungeon then StartDungeon:FireServer(unpack(args)) end
                
                local PlayerGui = Player:FindFirstChild("PlayerGui")
                local WCUI = PlayerGui and PlayerGui:FindFirstChild("WCUI")
                if WCUI then
                    local folders = {WCUI:FindFirstChild("RaidUI"), WCUI:FindFirstChild("Event"), WCUI:FindFirstChild("StarterPlayerScripts")}
                    for _, folder in ipairs(folders) do
                        if folder then
                            for _, child in ipairs(folder:GetChildren()) do
                                if child.Name:match("Result") or child.Name:match("Reset") then
                                    local btn = child:FindFirstChild("Next") or child:FindFirstChild("Retry") or child:FindFirstChild("ResetRaidBtn")
                                    if btn and btn.ClassName == "TextButton" and btn.Visible then
                                        local posX = btn.AbsolutePosition.X + (btn.AbsoluteSize.X / 2)
                                        local posY = btn.AbsolutePosition.Y + (btn.AbsoluteSize.Y / 2)
                                        VirtualUser:CaptureController()
                                        VirtualUser:ClickButton1(Vector2.new(posX, posY))
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. Vòng lặp Auto Tự động Tạo và Bắt đầu Phòng
task.spawn(function()
    while task.wait(4) do
        if _G.ToggleAutoLobby then
            pcall(function()
                local CreateLobby = ReplicatedStorage:FindFirstChild("CreateLobby")
                local StartLobby = ReplicatedStorage:FindFirstChild("StartLobby")
                
                if CreateLobby and StartLobby then
                    local args = {
                        [1] = {
                            ["Map"] = "Cursed Marshes",
                            ["Calamity"] = false,
                            ["Hardcore"] = false,
                            ["NoHit"] = false,
                            ["Difficulty"] = "Expert",
                            ["LevelRequirement"] = 45,
                            ["Tier"] = 0,
                            ["Private"] = false,
                            ["Easter"] = false
                        }
                    }
                    CreateLobby:InvokeServer(unpack(args))
                    task.wait(1.5)
                    StartLobby:FireServer()
                end
            end)
        end
    end
end)

-- Lấy thư mục chứa quái một cách chủ động
local function getEnemiesFolder()
    return Workspace:FindFirstChild("Enemies")
end

-- Tìm bộ phận gốc linh hoạt
local function getRootPart(model)
    if not model then return nil end
    return model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
end

-- 4. Hàm quét tìm mục tiêu gần nhất
local function getClosestTarget()
    local Mobs = getEnemiesFolder()
    if not Mobs then return nil, nil end
    
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    
    local closestDist, target, targetPart = math.huge, nil, nil
    
    for _, obj in pairs(Mobs:GetDescendants()) do
        if obj:IsA("Model") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local part = getRootPart(obj)
            
            if hum and hum.Health > 0 and part then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    target = obj
                    targetPart = part
                end
            end
        end
    end
    return target, targetPart
end

-- 5. Vòng lặp Aura Kill & Ghim vị trí (Chống lag gói tin)
task.spawn(function()
    local lastCast = 0
    while task.wait(0.1) do
        local Mobs = getEnemiesFolder()
        if _G.ToggleAuraKill and Player.Character and Mobs then
            pcall(function()
                local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
                local centerEnemy, centerPart = getClosestTarget()
                
                if hrp and centerEnemy and centerPart then
                    local centerPos = centerPart.Position

                    -- Ghim nhân vật ổn định trên không trung
                    hrp.CFrame = CFrame.lookAt(centerPos + Vector3.new(0, _G.HeightOffset, 0), centerPos)
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    local now = tick()
                    local canCastSpell = (now - lastCast) >= 0.3
                    local hitCount = 0
                    
                    for _, mob in pairs(Mobs:GetDescendants()) do
                        if mob:IsA("Model") and hitCount < 5 then
                            local mobPart = getRootPart(mob)
                            local mobHum = mob:FindFirstChildOfClass("Humanoid")
                            
                            if mobPart and mobHum and mobHum.Health > 0 then
                                if (hrp.Position - mobPart.Position).Magnitude <= _G.AuraRadius then
                                    hitCount = hitCount + 1
                                    
                                    -- Đòn chém thường (Swing)
                                    if Swing then
                                        Swing:FireServer() 
                                        Swing:FireServer(mob)
                                    end
                                    
                                    -- Kích hoạt kỹ năng Q và E (Spells)
                                    if UseSpell and canCastSpell then
                                        local mPos = mobPart.Position
                                        UseSpell:FireServer("Q", mPos) UseSpell:FireServer("q", mobPart)
                                        UseSpell:FireServer("E", mPos) UseSpell:FireServer("e", mobPart)
                                        lastCast = now
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
]]

-- Thực thi script ngay lập tức
loadstring(mainScript)()

-- Tự động thực thi lại khi game Chuyển map/Retry
local queue = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if queue then
    queue(mainScript)
end