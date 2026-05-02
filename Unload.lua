-- Unload.lua
-- Naciśnij DELETE aby całkowicie wyłączyć i wyczyścić ScoutCheat.

local UserInputService = game:GetService("UserInputService")

local unloadConn = nil
local function unloadAll()
    print("[ScoutCheat] Rozładowywanie...")

    if not getgenv().ScoutCheat then
        print("[ScoutCheat] Skrypt nie jest w pełni załadowany lub został już rozładowany.")
        return
    end

    -- 1. Disconnect all connections
    if getgenv().ScoutCheat._connections then
        for _, conn in pairs(getgenv().ScoutCheat._connections) do
            pcall(function() conn:Disconnect() end)
        end
        print("[Unload] Rozłączono eventy.")
    end

    -- 2. Remove all drawings
    if getgenv().ScoutCheat._drawings then
        for _, drawing in pairs(getgenv().ScoutCheat._drawings) do
            pcall(function() drawing:Remove() end)
        end
        print("[Unload] Usunięto obiekty Drawing.")
    end

    -- 3. Remove ESP Gui
    if getgenv().ScoutCheat._espGui then
        pcall(function() getgenv().ScoutCheat._espGui:Destroy() end)
        print("[Unload] ESP ScreenGui usunięte.")
    else
        -- Fallback
        local CoreGui = game:GetService("CoreGui")
        local espHolder = CoreGui:FindFirstChild("ESPHolder")
        if not espHolder then
            local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if pg then espHolder = pg:FindFirstChild("ESPHolder") end
        end
        if espHolder then pcall(function() espHolder:Destroy() end) end
    end

    -- 4. Restore Lighting
    pcall(function()
        local Lighting = game:GetService("Lighting")
        if getgenv()._origLighting then
            local o = getgenv()._origLighting
            Lighting.Brightness       = o.Brightness
            Lighting.Ambient          = o.Ambient
            Lighting.OutdoorAmbient   = o.OutdoorAmbient
            Lighting.FogEnd           = o.FogEnd
            Lighting.FogStart         = o.FogStart
            Lighting.FogColor         = o.FogColor
        end
    end)

    -- 5. Clear globals
    getgenv().ScoutCheat  = nil
    _G.ScoutCheat         = nil

    if unloadConn then unloadConn:Disconnect() end

    print("[ScoutCheat] ✔ Całkowicie rozładowano. Skrypt jest teraz nieaktywny.")
end

unloadConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Delete then
        unloadAll()
    end
end)
if getgenv().ScoutCheat then
    table.insert(getgenv().ScoutCheat._connections, unloadConn)
end

getgenv().ScoutUnload = unloadAll
print("[Unload] Gotowy. Naciśnij DELETE aby wyłączyć ScoutCheat.")
