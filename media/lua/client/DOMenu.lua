DOMenu = DOMenu or {}

function DOMenu.CreateSchedule (player)
    DOScheduler.CreateSchedule(player)
end

function DOMenu.ClearSchedule (player)
    DOScheduler.ClearSchedule(player)
end

function DOMenu.WorldContextMenuPre(playerID, context, worldobjects, test)
    local square = clickedSquare
    
    local player = getSpecificPlayer(playerID)
    if isDebugEnabled() or isAdmin() then
        context:addOption("[DGB] Create Schedule", player, DOMenu.CreateSchedule)
        context:addOption("[DGB] Clear Schedule", player, DOMenu.ClearSchedule)
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(DOMenu.WorldContextMenuPre)