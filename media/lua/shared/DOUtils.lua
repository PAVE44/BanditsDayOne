DOUtils = DOUtils or {}

DOUtils.GetTime = function()
    local world = getWorld()
    local gamemode = world:getGameMode()
    if gamemode == "Multiplayer" then
        --return GameTime:getServerTimeMills()
        return getGameTime():getWorldAgeHours() * 2500000 / 24
    else
        return getGameTime():getWorldAgeHours() * 2500000 / 24
    end
end
