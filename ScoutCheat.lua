-- ScoutCheat.lua
-- Ten plik ładuje wszystkie moduły cheata (Aimbot, ESP, GUI itp.)
-- Jest odpalany z poziomu Eclipse Hub.

local repoURL = "https://raw.githubusercontent.com/piotrwrt150/zniu81zd41c3jljumqn8p3o609mjr75arzan2r0yxqa/main/"

if _G.ScoutCheatLoaded then
    print("[ScoutCheat] Skrypt jest już załadowany!")
    return
end

_G.ScoutCheatLoaded = true

print("[ScoutCheat] Ładowanie modułów...")

local Config = loadstring(game:HttpGet(repoURL .. "Config.lua?t=" .. tick()))()
getgenv().ScoutCheat = { Config = Config, _connections = {}, _drawings = {} }
_G.ScoutCheat = getgenv().ScoutCheat

loadstring(game:HttpGet(repoURL .. "ESP.lua?t=" .. tick()))()
loadstring(game:HttpGet(repoURL .. "Aimbot.lua?t=" .. tick()))()
loadstring(game:HttpGet(repoURL .. "Visuals.lua?t=" .. tick()))()
loadstring(game:HttpGet(repoURL .. "Watermark.lua?t=" .. tick()))()
loadstring(game:HttpGet(repoURL .. "GUI.lua?t=" .. tick()))()
loadstring(game:HttpGet(repoURL .. "Unload.lua?t=" .. tick()))()

print("[ScoutCheat] ✔ Załadowano pomyślnie!")
