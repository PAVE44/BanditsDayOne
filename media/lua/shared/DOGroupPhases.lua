DOGroupPhases = DOGroupPhases or {}

DOGroupPhases.Start = function(pid, ct)
    local events = {}
    local event

    event = {}
    event.pid = pid
    event.start = ct + 0
    event.phase = "SpawnFamilly"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 500
    event.phase = "SpawnPeopleStreet"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 1000
    event.phase = "Siren"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 1500
    event.phase = "SpawnVehicleFireTruck"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 2000
    event.phase = "SpawnPeopleStreet"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 10000
    event.phase = "SpawnPeopleInHouses"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 15000
    event.phase = "SpawnPeopleInHouses"
    table.insert(events, event)
    
    event = {}
    event.pid = pid
    event.start = ct + 50000
    event.phase = "ChopperAlert"
    table.insert(events, event)

    return events
end

DOGroupPhases.MoreActors = function(pid, ct)
    local events = {}
    local event

    event = {}
    event.pid = pid
    event.start = ct 
    event.phase = "SpawnPeopleStreetFar"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 2000
    event.phase = "SpawnPolicePatrol"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 4000
    event.phase = "ChopperAlert"
    table.insert(events, event)

    return events
end

DOGroupPhases.Army = function(pid, ct)
    local events = {}
    local event

    event = {}
    event.pid = pid
    event.start = ct 
    event.phase = "SpawnPeopleStreetFar"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 2000
    event.phase = "SpawnArmy"
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 3000
    event.phase = "ChopperAlert"
    table.insert(events, event)

    local j1 = "JetLeft"
    local j2 = "JetRight"
    if ZombRand(2) == 1 then
        j1 = "JetRight"
        j2 = "JetLeft"
    end

    event = {}
    event.pid = pid
    event.start = ct + 10000
    event.phase = j1
    table.insert(events, event)

    event = {}
    event.pid = pid
    event.start = ct + 10500
    event.phase = j2
    table.insert(events, event)

    return events
end

DOGroupPhases.Bombing = function(pid, ct)
    local events = {}
    local event

    local j1 = "JetLeft"
    local j2 = "JetRight"
    if ZombRand(2) == 1 then
        j1 = "JetRight"
        j2 = "JetLeft"
    end

    local intensity = SandboxVars.BanditsDayOne.General_BombingIntensity - 1

    event = {}
    event.pid = pid
    event.start = ct
    event.phase = j1
    table.insert(events, event)
    ct = ct + 500

    event = {}
    event.pid = pid
    event.start = ct
    event.phase = j2
    table.insert(events, event)
    ct = ct + 19500

    if intensity > 0 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "BombDrop"
        table.insert(events, event)
        ct = ct + 700
    end

    if intensity > 1 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "BombDrop"
        table.insert(events, event)
        ct = ct + 800
    end

    if intensity > 2 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "BombDrop"
        table.insert(events, event)
        ct = ct + 600
    end

    if intensity > 3 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "BombDrop"
        table.insert(events, event)
        ct = ct + 800
    end

    if intensity > 4 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "BombDrop"
        table.insert(events, event)
        ct = ct + 200
    end

    if intensity > 5 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "BombDrop"
        table.insert(events, event)
    end

    return events
end

DOGroupPhases.A10 = function(pid, ct)
    local events = {}
    local event

    local j1 = "JetLeft"
    local j2 = "JetRight"
    if ZombRand(2) == 1 then
        j1 = "JetRight"
        j2 = "JetLeft"
    end

    local intensity = SandboxVars.BanditsDayOne.General_WarthogIntensity - 1
    
    event = {}
    event.pid = pid
    event.start = ct
    event.phase = j1
    table.insert(events, event)
    ct = ct + 500

    event = {}
    event.pid = pid
    event.start = ct
    event.phase = j2
    table.insert(events, event)
    ct = ct + 10000

    if intensity > 0 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "A10"
        table.insert(events, event)
        ct = ct + 1700
    end

    if intensity > 1 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "A10"
        table.insert(events, event)
        ct = ct + 1700
    end

    if intensity > 2 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "A10"
        table.insert(events, event)
        ct = ct + 1700
    end

    if intensity > 3 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "A10"
        table.insert(events, event)
        ct = ct + 1700
    end

    if intensity > 4 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "A10"
        table.insert(events, event)
        ct = ct + 1700
    end

    if intensity > 5 then
        event = {}
        event.pid = pid
        event.start = ct
        event.phase = "A10"
        table.insert(events, event)
        ct = ct + 700
    end

    return events
end