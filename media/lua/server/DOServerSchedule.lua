
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
    ct = ct + 4000

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

    event = {}
    event.pid = pid
    event.start = ct 
    event.phase = "ChopperAlert"
    table.insert(events, event)
    ct = ct + 5000

    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "SpawnPolicePatrol"
    table.insert(events, event)
    ct = ct + 5000

    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "UpdateVehicles"
    table.insert(schedule, event)
    ct = ct + 174000

    -- TIME: 360,000
    event = {}
    event.pid = pid
    event.start = ct + 100
    event.phase = "SpawnPeopleInHouses"
    table.insert(events, event)

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
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "EraserOn"
    table.insert(schedule, event)

    event = {}
    event.pid = pid
    event.start = ct + 100
    event.phase = "SpawnPeopleInHouses"
    table.insert(events, event)

    -- TIME: 426,000
    -- A10s
    for b=1, 30 do
        local events = DOGroupPhases.A10(pid, ct+b*10000)
        for k, v in pairs(events) do table.insert(schedule, v) end
    end

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
    event.phase = "SpawnPeopleInHouses"
    table.insert(events, event)

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
    event.phase = "SpawnPeopleInHouses"
    table.insert(events, event)

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
    event.start = ct + 100
    event.phase = "SpawnPeopleInHouses"
    table.insert(events, event)

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
    for b=1, 30 do
        local events = DOGroupPhases.A10(pid, ct+b*9000)
        for k, v in pairs(events) do table.insert(schedule, v) end
    end

    for b=1, 14 do
        local events = DOGroupPhases.Bombing(pid, ct)
        for k, v in pairs(events) do table.insert(schedule, v) end
        ct = ct + 8000
    end

    -- TIME: 750,000
    event = {}
    event.pid = pid
    event.start = ct 
    event.phase = "ChopperAlert"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "SpawnPolicePatrol"
    table.insert(events, event)
    ct = ct + 8000

    -- TIME: 862,000
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "SpawnPeopleInHouses"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "SpawnFriendlyArmy"
    table.insert(schedule, event)
    ct = ct + 26000

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
    event.start = ct + 100
    event.phase = "SpawnPeopleInHouses"
    table.insert(events, event)
    
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
    event.phase = "CiviliansOff"
    table.insert(schedule, event)

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
    ct = ct + 126500

    -- TIME 1,900,00
    for i=1, 2 do
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "SpawnGang"
        table.insert(schedule, event)
        ct = ct + 15000
    end

    -- TIME 1,930,500
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = "SpawnScientists"
    table.insert(schedule, event)
    ct = ct + 30000
    
    -- TIME 1,960,000
    for i=1, 5 do
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "SpawnGang"
        table.insert(schedule, event)
        ct = ct + 8000
    end

    -- TIME 2,000,000
    ct = ct + 70000

    -- END 2,330,000
    local events = DOGroupPhases.Kaboom(pid, ct)
    for k, v in pairs(events) do table.insert(schedule, v) end

     event = {}
     event.pid = pid
     event.start = ct
     event.phase = "EraserOff"
     table.insert(schedule, event)

     event = {}
     event.pid = pid
     event.start = ct
     event.phase = "TvOff"
     table.insert(schedule, event)
 
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

function DOServer.Schedule.Kaboom(player, args)
    local px = player:getX()
    local py = player:getY()
    local cell = player:getCell()
    local r = args.r
    for z=0, 4 do
        for y=-r, r do
            for x=-r, r do
                local bx = px + x
                local by = py + y
                local dist = math.sqrt(math.pow(bx - px, 2) + math.pow(by - py, 2))
                if dist < r then
                    local square = cell:getGridSquare(bx, by, z)
                    if square then
                        square:BurnWalls(false)
                        if ZombRand(4) == 1 and square:isFree(false) then
                            local obj = IsoObject.new(square, "floors_burnt_01_1", "")
                            square:AddSpecialObject(obj)
                            obj:transmitCompleteItemToClients()
                        end
                        if ZombRand(6) == 1 and square:isFree(false) then
                            local rn = ZombRand(53)
                            local sprite = "trash_01_" .. tostring(rn)
                            local obj = IsoObject.new(square, sprite, "")
                            square:AddSpecialObject(obj)
                            obj:transmitCompleteItemToClients()
                        end
                    end
                end
            end
        end
    end
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
