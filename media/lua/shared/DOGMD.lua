DOModData = {}

function InitDOModData(isNewGame)

    local modData = ModData.getOrCreate("BanditDayOne")

    if isClient() then
        ModData.request("BanditDayOne")
    end

    -- uncheck below lines to reset the mod on server restart
    -- modData.KnownPlayers = {}
    -- modData.Schedule = {}

    if not modData.KnownPlayers then modData.KnownPlayers = {} end
    if not modData.Schedule then modData.Schedule = {} end

    DOModData = modData
end

function LoadDOModData(key, modData)
    if isClient() then
        if key and key == "BanditDayOne" and modData then
            DOModData = modData
        end
    end
end

function GetDOModData()
    return DOModData
end

function TransmitDOModData()
    ModData.transmit("BanditDayOne")
end


Events.OnInitGlobalModData.Add(InitDOModData)
Events.OnReceiveGlobalModData.Add(LoadDOModData)
