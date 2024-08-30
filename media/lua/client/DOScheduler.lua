DOScheduler = DOScheduler or {}
 
DOScheduler.Schedule = {}

-- checks if the player is new on the server, if yes then requests
-- creation of a schedule on the server
function DOScheduler.CheckPlayer()
    local player = getPlayer()
    local pid = player:getDisplayName()
    local gmd = GetDOModData()
    if not gmd.KnownPlayers[pid] then
        DOScheduler.CreateSchedule(player)
    end
end

-- creates schedules for the player
function DOScheduler.CreateSchedule(player)
    sendClientCommand(player, 'Schedule', 'Create', {x=1})
end

-- clears schedules on the server for all players
function DOScheduler.ClearSchedule(player)
    sendClientCommand(player, 'Schedule', 'Clear', {x=1})
    DOScheduler.Schedule = {}
end

-- loads schedule from the server
function DOScheduler.LoadSchedule(player)
    DOScheduler.Schedule = {}
    local gmd = GetDOModData()
    local pid = player:getDisplayName()
    for i, event in pairs(gmd.Schedule) do
        if event.pid == pid then
            table.insert(DOScheduler.Schedule, event)
        end
    end
end

-- processes schedule phases
function DOScheduler.CheckSchedule()
    if ZombRand(10) == 1 then
        -- print ("EVENTS:" .. #DOScheduler.Schedule)
    end

    local player = getPlayer()
    local gmd = GetDOModData()
    
    if #DOScheduler.Schedule == 0 then
        DOScheduler.LoadSchedule(player)
    end

    
    local pid = player:getDisplayName()
    local ct = DOUtils.GetTime()
    for i, event in pairs(DOScheduler.Schedule) do
        if event.start < ct and event.pid == pid then
            if DOPhases[event.phase] then
                print ("------------------------------------------------")
                print ("DayOne Scheduler: Running Phase: " .. event.phase)
                print ("------------------------------------------------")
                DOPhases[event.phase](player)
            end
            table.remove(DOScheduler.Schedule, i)
            local args = {i=i}
            sendClientCommand(player, 'Schedule', 'RemovePhase', args)
            break
        end
    end
end

Events.OnTick.Add(DOScheduler.CheckSchedule)
Events.EveryOneMinute.Add(DOScheduler.CheckPlayer)