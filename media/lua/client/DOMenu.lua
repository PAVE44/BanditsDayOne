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

function DOMenu.AddLight(player, square)
    local colors = {r=1.0, g=0.5, b=0.5}
    local lightSource = IsoLightSource.new(square:getX(), square:getY(), square:getZ(), colors.r, colors.g, colors.b, 60, 5)
    getCell():addLamppost(lightSource)
    
    local lightLevel = square:getLightLevel(0)
    print ("LIGHTLEVEL:" .. lightLevel)
    if lightLevel < 0.7 and player:isOutside() then
        local px = player:getX()
        local py = player:getY()
        local sx = square:getX()
        local sy = square:getY()

        local dx = math.abs(px - sx)
        local dy = math.abs(py - sy)

        local tex
        local dist = math.sqrt(math.pow(sx - px, 2) + math.pow(sy - py, 2))
        if dist > 30 then dist = 30 end

        if dx > dy then
            if sx > px then
                tex = "e"
            else
                tex = "w"
            end
        else
            if sy > py then
                tex = "s"
            else
                tex = "n"
            end
        end

        DOTex.tex = getTexture("media/textures/blast_" .. tex .. ".png")
        DOTex.alpha = 1 - (dist / 30)
    end
    

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
        -- context:addOption("[DGB] Add Light", player, DOMenu.AddLight, square)
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(DOMenu.WorldContextMenuPre)
