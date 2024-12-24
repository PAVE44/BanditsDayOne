DOGroupPhases = DOGroupPhases or {}

DOGroupPhases.Bombing = function()
    local events = {}
    local event
    local ct = DOUtils.GetTime()

    local intensity = SandboxVars.BanditsDayOne.General_BombingIntensity - 1
    if intensity == 0 then return end

    local j1 = "JetLeft"
    local j2 = "JetRight"
    if ZombRand(2) == 1 then
        j1 = "JetRight"
        j2 = "JetLeft"
    end

    event = {}
    event.start = ct
    event.phase = j1
    table.insert(DOScheduler.Schedule, event)
    ct = ct + 500

    event = {}
    event.start = ct
    event.phase = j2
    table.insert(DOScheduler.Schedule, event)
    ct = ct + 19500

    if intensity > 0 then
        event = {}
        event.start = ct
        event.phase = "BombDrop"
        table.insert(DOScheduler.Schedule, event)
        ct = ct + 300
    end
    
    event = {}
    event.start = ct 
    event.phase = "UpdateVehicles"
    table.insert(DOScheduler.Schedule, event)
    ct = ct + 100

    for i=2, intensity*3 do
        event = {}
        event.start = ct 
        event.phase = "BombDrop"
        table.insert(DOScheduler.Schedule, event)
        ct = ct + 77 + ZombRand(254)
    end
end

DOGroupPhases.Gas = function()
    local events = {}
    local event
    local ct = DOUtils.GetTime()

    local j1 = "JetLeft"
    local j2 = "JetRight"
    if ZombRand(2) == 1 then
        j1 = "JetRight"
        j2 = "JetLeft"
    end

    local intensity = SandboxVars.BanditsDayOne.General_GasIntensity - 1

    event = {}
    event.start = ct
    event.phase = j1
    table.insert(DOScheduler.Schedule, event)
    ct = ct + 500

    event = {}
    event.start = ct
    event.phase = j2
    table.insert(DOScheduler.Schedule, event)
    ct = ct + 19500

    for i=1, 3 do
        if intensity > 0 then
            event = {}
            event.start = ct
            event.phase = "GasDrop"
            table.insert(DOScheduler.Schedule, event)
            ct = ct + 250
        end

        if intensity > 1 then
            event = {}
            event.start = ct
            event.phase = "GasDrop"
            table.insert(DOScheduler.Schedule, event)
            ct = ct + 250
        end

        if intensity > 2 then
            event = {}
            event.start = ct
            event.phase = "GasDrop"
            table.insert(DOScheduler.Schedule, event)
            ct = ct + 250
        end

        if intensity > 3 then
            event = {}
            event.start = ct
            event.phase = "GasDrop"
            table.insert(DOScheduler.Schedule, event)
            ct = ct + 250
        end

        if intensity > 4 then
            event = {}
            event.start = ct
            event.phase = "GasDrop"
            table.insert(DOScheduler.Schedule, event)
            ct = ct + 250
        end

        if intensity > 5 then
            event = {}
            event.start = ct
            event.phase = "GasDrop"
            table.insert(DOScheduler.Schedule, event)
            ct = ct + 250
        end
    end
end

DOGroupPhases.A10 = function()
    local events = {}
    local event
    local ct = DOUtils.GetTime()

    local j1 = "JetLeft"
    local j2 = "JetRight"
    if ZombRand(2) == 1 then
        j1 = "JetRight"
        j2 = "JetLeft"
    end

    local intensity = SandboxVars.BanditsDayOne.General_WarthogIntensity - 1
    
    event = {}
    event.start = ct
    event.phase = j1
    table.insert(DOScheduler.Schedule, event)
    ct = ct + 500

    event = {}
    event.start = ct
    event.phase = j2
    table.insert(DOScheduler.Schedule, event)
    ct = ct + 10000

    if intensity > 0 then
        event = {}
        event.start = ct
        event.phase = "A10"
        table.insert(DOScheduler.Schedule, event)
        ct = ct + 1700
    end

    if intensity > 1 then
        event = {}
        event.start = ct
        event.phase = "A10"
        table.insert(DOScheduler.Schedule, event)
        ct = ct + 1700
    end

    if intensity > 2 then
        event = {}
        event.start = ct
        event.phase = "A10"
        table.insert(DOScheduler.Schedule, event)
        ct = ct + 1700
    end

    if intensity > 3 then
        event = {}
        event.start = ct
        event.phase = "A10"
        table.insert(DOScheduler.Schedule, event)
        ct = ct + 1700
    end

    if intensity > 4 then
        event = {}
        event.start = ct
        event.phase = "A10"
        table.insert(DOScheduler.Schedule, event)
        ct = ct + 1700
    end

    if intensity > 5 then
        event = {}
        event.start = ct
        event.phase = "A10"
        table.insert(DOScheduler.Schedule, event)
    end
end

DOGroupPhases.Kaboom = function()
    local events = {}
    local event
    local ct = DOUtils.GetTime()

    local j1 = "JetLeft"
    local j2 = "JetRight"
    if ZombRand(2) == 1 then
        j1 = "JetRight"
        j2 = "JetLeft"
    end

    local intensity = SandboxVars.BanditsDayOne.General_BombingIntensity - 1

    event = {}
    event.start = ct
    event.phase = j1
    table.insert(DOScheduler.Schedule, event)
    ct = ct + 500

    event = {}
    event.start = ct
    event.phase = j2
    table.insert(DOScheduler.Schedule, event)
    ct = ct + 19500

    if intensity > 1 then
        event = {}
        event.start = ct
        event.phase = "Kaboom"
        table.insert(DOScheduler.Schedule, event)
    end
end