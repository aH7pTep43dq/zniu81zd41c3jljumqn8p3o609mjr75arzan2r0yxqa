local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Visuals = _G.ScoutCheat.Config.Visuals
local function reg(c) table.insert(getgenv().ScoutCheat._connections, c) return c end
local function regD(d) table.insert(getgenv().ScoutCheat._drawings, d) return d end

local watermarkText = Drawing.new("Text")
watermarkText.Size = 16
watermarkText.Font = Drawing.Fonts.UI
watermarkText.Color = Color3.fromRGB(255, 255, 255)
watermarkText.Outline = true
watermarkText.OutlineColor = Color3.fromRGB(0, 0, 0)
watermarkText.Visible = false
watermarkText.ZIndex = 100

-- Position the watermark at the top right of the screen
local camera = game:GetService("Workspace").CurrentCamera
local function updatePosition()
    local vp = camera.ViewportSize
    -- Estimate text width based on size. Actually, TextBounds isn't always available in Drawing API.
    -- We'll anchor it to top right minus some padding. 16 chars * approx 8 pixels = 128
    watermarkText.Position = Vector2.new(vp.X - 250, 10)
end

regD(watermarkText)

local lastUpdate = tick()
local frames = 0
local fps = 0

reg(RunService.RenderStepped:Connect(function(dt)
    if not Visuals.Watermark then
        watermarkText.Visible = false
        return
    end

    frames = frames + 1
    if tick() - lastUpdate >= 1 then
        fps = frames
        frames = 0
        lastUpdate = tick()
    end

    local ping = 0
    pcall(function()
        -- Network.ServerStatsItem["Data Ping"] isn't always reliably available across all executors
        -- but Stats.Network.ServerStatsItem["Data Ping"]:GetValueString() works mostly.
        ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    
    local timeStr = os.date("%H:%M:%S")

    watermarkText.Text = string.format("ScoutCheat  |  FPS: %d  |  Ping: %d ms  |  %s", fps, ping, timeStr)
    watermarkText.Visible = true
    updatePosition()
end))
