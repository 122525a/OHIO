(function(define)
    repeat
        game:GetService("RunService").Heartbeat:Wait()
    until game:IsLoaded()

    local function check_exploit()
        if not getgenv then
            return false
        end
        return true
    end

    if not check_exploit() then
        game.Players.LocalPlayer:Kick("Exploit not supported")
        return
    end

    local WHITELIST_URL = "https://raw.githubusercontent.com/122525a/OHIO/refs/heads/main/wearedevs%E7%99%BD%E5%90%8D%E5%8D%95.lua"
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer or not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end

    local success, whitelistContent = pcall(function()
        return game:HttpGet(WHITELIST_URL, true)
    end)

    if not success then
        LocalPlayer:Kick("Whitelist server error")
        return
    end

    local pattern = "\n" .. LocalPlayer.Name .. "\n"
    local fullWhitelistText = "\n" .. whitelistContent .. "\n"

    if string.find(fullWhitelistText, pattern, 1, true) then
        print("Welcome, " .. LocalPlayer.Name .. ". You are whitelisted")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/122525a/OHIO/refs/heads/main/Yttrium%20Hub%20ohio.lua", true))()
    else
        LocalPlayer:Kick("Not in whitelist")
    end
end)()

