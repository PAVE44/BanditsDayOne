DOMenu = DOMenu or {}

function DOMenu.CreateSchedule (player)
    DOScheduler.CreateSchedule(player)
end

function DOMenu.ClearSchedule (player)
    DOScheduler.ClearSchedule(player)
end

function DOMenu.EraserOn(player, zombie)
    DOEraser.State = true
end

function DOMenu.AddBomb(player, square)
    DOPhases.BombDrop(player)
end

function DOMenu.Kaboom(player, square)
    DOPhases.Kaboom(player)
end

function DOMenu.TVBroadCast(player, square)
    DOPhases.TVBroadCast(player)
end

function DOMenu.AddEvent(player, zombie)
    local gmd = GetDOModData()
    local pid = player:getDisplayName()
    local ct = DOUtils.GetTime() + 100
    local events = DOGroupPhases.A10(pid, ct)
    for k, v in pairs(events) do table.insert(gmd.Schedule, v) end
end

function DOMenu.WorldContextMenuPre(playerID, context, worldobjects, test)
    local square = clickedSquare
    
    local player = getSpecificPlayer(playerID)
    if isDebugEnabled() or isAdmin() then
        -- context:addOption("[DGB] Create Schedule", player, DOMenu.CreateSchedule)
        -- context:addOption("[DGB] Clear Schedule", player, DOMenu.ClearSchedule)
        -- context:addOption("[DGB] Eraser On", player, DOMenu.EraserOn)
        context:addOption("[DGB] Bomb Drop", player, DOMenu.AddBomb, square)
        context:addOption("[DGB] Kaboom", player, DOMenu.Kaboom, square)
        context:addOption("[DGB] TV Broadcast", player, DOMenu.TVBroadCast, square)
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(DOMenu.WorldContextMenuPre)
