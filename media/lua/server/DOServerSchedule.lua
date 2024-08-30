
DOServer = DOServer or {}
DOServer.Schedule = DOServer.Schedule or {}

function DOServer.Schedule.Create(player, args)
    local schedule = {}
    local pid = player:getDisplayName()
    local ct = DOUtils.GetTime()
    local event

    local gmd = GetDOModData()
    for k, p in pairs(gmd.Schedule) do
        if p.pid == pid then
            table.remove(gmd.Schedule, k)
        end
    end

    -- TIME: 0 
    local events = DOGroupPhases.Start(pid, ct)
    for k, v in pairs(events) do table.insert(schedule, v) end
    ct = ct + 5000

    -- TIME: 4000 
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "UpdateVehicles"
    table.insert(schedule, event)
    ct = ct + 115000

    -- TIME: 120,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "GetHelicopter"
    table.insert(schedule, event)
    ct = ct + 60000

    -- TIME: 180,000
    local events = DOGroupPhases.MoreActors(pid, ct)
    for k, v in pairs(events) do table.insert(schedule, v) end
    ct = ct + 4000
    
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "UpdateVehicles"
    table.insert(schedule, event)
    ct = ct + 174000

    -- TIME: 360,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "Siren"
    table.insert(schedule, event)
    ct = ct + 6000

    -- TIME: 366,000
    for b=1, 3 do
        local events = DOGroupPhases.Bombing(pid, ct)
        for k, v in pairs(events) do table.insert(schedule, v) end
        ct = ct + 20000
    end

    -- TIME: 426,000
    local events = DOGroupPhases.Army(pid, ct)
    for k, v in pairs(events) do table.insert(schedule, v) end
    ct = ct + 60000

    -- TIME: 486,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "Siren"
    table.insert(schedule, event)
    ct = ct + 6000

    -- TIME: 492,000
    for b=1, 6 do
        local events = DOGroupPhases.Bombing(pid, ct)
        for k, v in pairs(events) do table.insert(schedule, v) end
        ct = ct + 10000
    end

    -- TIME: 552,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "GetHelicopter"
    table.insert(schedule, event)
    ct = ct + 10000

    -- TIME: 562,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "SpawnArmy"
    table.insert(schedule, event)
    ct = ct + 38000

    -- TIME: 592,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "Siren"
    table.insert(schedule, event)
    ct = ct + 8000
    
    -- TIME: 600,000
    for b=1, 8 do
        local events = DOGroupPhases.Bombing(pid, ct)
        for k, v in pairs(events) do table.insert(schedule, v) end
        ct = ct + 9000
    end

    -- TIME: 672,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "WeatherStorm"
    -- table.insert(schedule, event)

    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "GetHelicopter"
    table.insert(schedule, event)
    ct = ct + 10000

    -- TIME: 682,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "SpawnVeterans"
    table.insert(schedule, event)
    ct = ct + 30000

    -- TIME: 712,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "SpawnArmy"
    table.insert(schedule, event)
    ct = ct + 30000

    -- TIME: 742,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "Siren"
    table.insert(schedule, event)
    ct = ct + 8000
    
    -- TIME: 750,000
    for b=1, 14 do
        local events = DOGroupPhases.Bombing(pid, ct)
        for k, v in pairs(events) do table.insert(schedule, v) end
        ct = ct + 8000
    end

    -- TIME: 862,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "SpawnFriendlyArmy"
    table.insert(schedule, event)
    ct = ct + 30000

    -- TIME: 892,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "GetHelicopter"
    table.insert(schedule, event)
    ct = ct + 8000

    -- TIME: 900,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "Siren"
    table.insert(schedule, event)
    ct = ct + 5000
    
    -- TIME: 905,000
    for b=1, 35 do
        local events = DOGroupPhases.Bombing(pid, ct)
        for k, v in pairs(events) do table.insert(schedule, v) end
        ct = ct + 7500
    end

    -- TIME: 1,167,500
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "Siren"
    table.insert(schedule, event)
    ct = ct + 6000

    -- TIME: 1,173,500
    for b=1, 100 do
        local events = DOGroupPhases.Bombing(pid, ct)
        for k, v in pairs(events) do table.insert(schedule, v) end
        ct = ct + 5000 + ZombRand(2000)
    end

    -- END 1,773,500

    for _, p in pairs(schedule) do
        table.insert(gmd.Schedule, p)
    end
    gmd.KnownPlayers[pid] = true
end

function DOServer.Schedule.Clear(player, args)
    local gmd = GetDOModData()
    gmd.Schedule = {}
    gmd.KnownPlayers = {}
end

function DOServer.Schedule.RemovePhase(player, args)
    local gmd = GetDOModData()
    table.remove(gmd.Schedule, args.i)
end

local onClientCommand = function(module, command, player, args)
    if DOServer[module] and DOServer[module][command] then
        local argStr = ""
        for k, v in pairs(args) do
            argStr = argStr .. " " .. k .. "=" .. tostring(v)
        end
        print ("received " .. module .. "." .. command .. " "  .. argStr)
        DOServer[module][command](player, args)
        TransmitDOModData()
    end
end

Events.OnClientCommand.Add(onClientCommand)
