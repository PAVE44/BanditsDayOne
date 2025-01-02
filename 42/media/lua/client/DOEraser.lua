DOEraser = DODOEraser or {}

DOEraser.State = false

function DOEraser.CheckErase()

    local player = getPlayer()
    local pst = player:getHoursSurvived()

    if not DOEraser.State then 
        return
    end

    local intensity = SandboxVars.BanditsDayOne.General_BombingIntensity - 1
    if intensity < 2 then
        return
    end

    local affectedZones = {}
    affectedZones.Forest = false
    affectedZones.DeepForest = false
    affectedZones.Nav = false
    affectedZones.Vegitation = false
    affectedZones.TownZone = true
    affectedZones.Ranch = false
    affectedZones.Farm = false
    affectedZones.TrailerPark = true
    affectedZones.ZombiesType = false
    affectedZones.FarmLand = false
    affectedZones.LootZone = true
    affectedZones.ZoneStory = true

    local function isAffectedZone(zoneType)
        for zt, zv in pairs(affectedZones) do
            if zoneType == zt and zv then return true end
        end

        return false
    end

    local function generateCirclePoints(x, y, r, n)
        local points = {}
        local angleStep = 2 * math.pi / n  -- Divide the circle into n equal parts
        
        for i = 0, n - 1 do
            local angle = i * angleStep  -- Current angle for point i
            local px = x + r * math.cos(angle)  -- Calculate x coordinate
            local py = y + r * math.sin(angle)  -- Calculate y coordinate
            table.insert(points, {x=math.floor(px+0.5), y=math.floor(py+0.5)})  -- Add the point to the list
        end
        
        return points
    end

    local function generatePoints(x, y, d)
        local points = {}
        local min = -d-10
        local max = d+10
        for py=min, max do
            for px=min, max do
                if (px<-d or px>d) and (py<-d or py>d) then
                    if (px+py) % 4 == 1 then
                        table.insert(points, {x=x+px, y=y+py})
                    end
                end
            end
        end
        
        return points
    end

    local cell = getCell()
    local player = getPlayer()
    local px = math.floor(player:getX() + 0.5)
    local py = math.floor(player:getY() + 0.5)
    local radius = 50
    local numPoints = 50
    -- local points = generateCirclePoints(px, py, radius, numPoints)
    local points = generatePoints(px, py, 40)

    for _, point in pairs(points) do
        local zone = getWorld():getMetaGrid():getZoneAt(point.x, point.y, 0)
        if zone then
            local zoneType = zone:getType()
            if isAffectedZone(zoneType) then
                local square = cell:getGridSquare(point.x, point.y, 0)
                if square then
                    if isClient() then
                        local args = {x=point.x, y=point.y, z=0}
                        sendClientCommand('object', 'addExplosionOnSquare', args)
                    else
                        local square = getCell():getGridSquare(point.x, point.y, 0)
                        IsoFireManager.explode(getCell(), square, 100)
                    end
                    local objectCnt = square:getObjects():size()
                    if objectCnt < 6 then
                        BanditBaseGroupPlacements.Junk (point.x-3, point.y-3, 0, 6, 6, 5)
                    end
                end
            end
        end
    end
end

-- Events.EveryOneMinute.Add(DOEraser.CheckErase) -- crashes b42