DOPhases = DOPhases or {}

local function getGroundType(square)
    local groundType = "generic"
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if object then
            local sprite = object:getSprite()
            if sprite then
                local spriteName = sprite:getName()
                if spriteName then
                    if spriteName:embodies("street") then
                        groundType = "street"
                    end
                end
            end
        end
    end
    return groundType
end

DOPhases.SpawnFamilly = function(player)

    -- YOUR FAMILLY
    config = {}
    config.clanId = 1
    config.hasRifleChance = 0
    config.hasPistolChance = 0
    config.rifleMagCount = 0
    config.pistolMagCount = 0

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Companion"
    event.program.stage = "Prepare"

    event.x = player:getX() - 1 + ZombRand(2)
    event.y = player:getY() - 1 + ZombRand(2)
    event.bandits = {}
    
    local bandit = BanditCreator.MakeFromWave(config)
    table.insert(event.bandits, bandit)
    table.insert(event.bandits, bandit)
    addSound(player, player:getX(), player:getY(), player:getZ(), 40, 100)

    sendClientCommand(player, 'Commands', 'SpawnGroup', event)
end

DOPhases.SpawnPeopleInHouses = function(player)

    -- PEOPLE IN HOUSES
    local buildings = {}
    for y = -80, 80 do
        for x = -80, 80 do
            local square = getCell():getGridSquare(player:getX() + x, player:getY() + y, 0)
            if square then
                local building = square:getBuilding()
                if building then
                    local id = building:getID()
                    buildings[id] = building
                end
            end
        end
    end

    config = {}
    config.hasRifleChance = 5
    config.hasPistolChance = 50
    config.rifleMagCount = 1
    config.pistolMagCount = 3
    config.clanId = 1

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Defend"
    event.program.stage = "Prepare"

    for _, building in pairs(buildings) do
        local room = building:getRandomRoom()
        if room then
            local roomDef = room:getRoomDef()
            if roomDef then
                local spawnSquare = roomDef:getFreeSquare()
                if spawnSquare then
                    if ZombRand(3) > 0 then
                        event.x = spawnSquare:getX()
                        event.y = spawnSquare:getY()
                        event.bandits = {}
                        
                        local bandit = BanditCreator.MakeFromWave(config)
                        table.insert(event.bandits, bandit)
                        table.insert(event.bandits, bandit)
                        
                        sendClientCommand(player, 'Commands', 'SpawnGroup', event)
                    end
                end
            end
        end
    end
end

DOPhases.SpawnPeopleStreet = function(player)

    -- PEOPLE IN THE STREET
    config = {}
    config.clanId = 1
    config.hasRifleChance = 0
    config.hasPistolChance = 30
    config.rifleMagCount = 0
    config.pistolMagCount = 2

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    for i=1, 16 do
        local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(15,40))
        if spawnPoint then
            event.x = spawnPoint.x
            event.y = spawnPoint.y
            event.bandits = {}
            
            local bandit = BanditCreator.MakeFromWave(config)
            table.insert(event.bandits, bandit)
            table.insert(event.bandits, bandit)
            
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)
        end
    end
end

DOPhases.SpawnPeopleStreetFar = function(player)

    -- PEOPLE IN THE STREET
    config = {}
    config.clanId = 1
    config.hasRifleChance = 0
    config.hasPistolChance = 30
    config.rifleMagCount = 0
    config.pistolMagCount = 2

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    for i=1, 24 do
        local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(35,60))
        if spawnPoint then
            event.x = spawnPoint.x
            event.y = spawnPoint.y
            event.bandits = {}
            
            local bandit = BanditCreator.MakeFromWave(config)
            table.insert(event.bandits, bandit)
            table.insert(event.bandits, bandit)
            
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)

            local allfree = true
            for x=spawnPoint.x-2, spawnPoint.x+2 do
                for y=spawnPoint.y-2, spawnPoint.y+2 do
                    local testSquare = getCell():getGridSquare(x, y, 0)
                    if not testSquare or not testSquare:isFree(false) then
                        allfree = false
                    end
                end
            end

            if ZombRand(5) == 1 and allfree then
                local args = {type="Base.CarNormal", x=spawnPoint.x, y=spawnPoint.y, alarm=true}
                sendClientCommand(player, 'Commands', 'VehicleSpawn', args)
            end
        end
    end
end

DOPhases.SpawnPolicePatrol = function(player)
    -- POLICE PATROL
    config = {}
    config.clanId = 6
    config.hasRifleChance = 100
    config.hasPistolChance = 100
    config.rifleMagCount = 6
    config.pistolMagCount = 6

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(30,40))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        
        sendClientCommand(player, 'Commands', 'SpawnGroup', event)
    end
end

DOPhases.SpawnArmy = function(player)
    
    -- POLICE PATROL
    config = {}
    config.clanId = 16
    config.hasRifleChance = 100
    config.hasPistolChance = 100
    config.rifleMagCount = 9
    config.pistolMagCount = 5

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(40,45))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)

        sendClientCommand(player, 'Commands', 'SpawnGroup', event)

        local args = {type="Base.PickUpVanLightsPolice", x=spawnPoint.x, y=spawnPoint.y, engine=true, lights=true, lightbar=true}
        sendClientCommand(player, 'Commands', 'VehicleSpawn', args)
    end
end

DOPhases.SpawnFriendlyArmy = function(player)
    
    -- POLICE PATROL
    config = {}
    config.clanId = 16
    config.hasRifleChance = 100
    config.hasPistolChance = 100
    config.rifleMagCount = 9
    config.pistolMagCount = 5

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Companion"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(22,30))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)

        sendClientCommand(player, 'Commands', 'SpawnGroup', event)
    end
end

DOPhases.SpawnVeterans = function(player)

    -- VETERANS
    config = {}
    config.clanId = 8
    config.hasRifleChance = 100
    config.hasPistolChance = 100
    config.rifleMagCount = 8
    config.pistolMagCount = 4

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Companion"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(40,50))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        
        sendClientCommand(player, 'Commands', 'SpawnGroup', event)
    end
end

DOPhases.SpawnGang = function(player)
    
    config = {}
    config.clanId = 9
    config.hasRifleChance = 5
    config.hasPistolChance = 25
    config.rifleMagCount = 2
    config.pistolMagCount = 3

    local event = {}
    event.hostile = true
    event.occured = false
    event.program = {}
    event.program.name = "Bandit"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(40,45))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)

        sendClientCommand(player, 'Commands', 'SpawnGroup', event)
    end
end

DOPhases.SpawnScientists = function(player)
    
    config = {}
    config.clanId = 9
    config.hasRifleChance = 0
    config.hasPistolChance = 0
    config.rifleMagCount = 0
    config.pistolMagCount = 2

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(40,45))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)
        table.insert(event.bandits, bandit)

        sendClientCommand(player, 'Commands', 'SpawnGroup', event)
    end
end

DOPhases.SpawnVehicleFireTruck  = function(player)
    for x=player:getX()-40, player:getX()+40 do
        for y=player:getY()-40, player:getY()+40 do
            if (x<-20 or x>20) and (y<-20 or y>20) then
                local square = getCell():getGridSquare(x, y, 0)
                if square and square:isFree(false) then
                    local gt = getGroundType(square)
                    if gt == "street" then
                        local args = {type="Base.PickUpTruckLightsFire", x=x, y=y, engine=true, lights=true, lightbar=true}
                        sendClientCommand(player, 'Commands', 'VehicleSpawn', args)
                        return true
                    end
                end
            end
        end
    end
end

DOPhases.UpdateVehicles = function(player)
    local vehicleList = getCell():getVehicles()
    
    for i=0, vehicleList:size()-1 do
        local vehicle = vehicleList:get(i)
        if vehicle then
            vehicle:setHeadlightsOn(true)
            addSound(player, vehicle:getX(), vehicle:getY(), vehicle:getZ(), 150, 100)
            BanditPlayer.WakeEveryone()
            if vehicle:hasLightbar() then
                local mode = vehicle:getLightbarLightsMode()
                if mode == 0 then
                    vehicle:setLightbarLightsMode(3)
                    vehicle:setLightbarSirenMode(2)
                end
            else
                vehicle:setAlarmed(true)
                vehicle:triggerAlarm()
            end
        end
    end
end

DOPhases.GetHelicopter = function(player)
    testHelicopter()
end

DOPhases.Siren = function(player)
    local emitter = getWorld():getFreeEmitter(player:getX()+10, player:getY()-20, 0)
    emitter:playAmbientSound("DOSiren2")
    emitter:setVolumeAll(0.9)
    addSound(player, player:getX(), player:getY(), player:getZ(), 150, 100)
end

DOPhases.ChopperAlert = function(player)
    --getCell():getGridSquare(player:getX()-10, player:getY()-10, 0):playSound("DOChopper")
    BanditPlayer.WakeEveryone()
    local emitter = getWorld():getFreeEmitter(player:getX(), player:getY(), 0)
    emitter:playAmbientSound("DOChopper")
    emitter:setVolumeAll(0.9)
    addSound(player, player:getX(), player:getY(), player:getZ(), 150, 100)
end

DOPhases.JetLeft = function(player)
    BanditPlayer.WakeEveryone()
    local emitter = getWorld():getFreeEmitter(player:getX()-8, player:getY()+8, 0)
    emitter:playAmbientSound("DOJet")
    emitter:setVolumeAll(1)
end

DOPhases.JetRight = function(player)
    BanditPlayer.WakeEveryone()
    local emitter = getWorld():getFreeEmitter(player:getX()+8, player:getY()-8, 0)
    emitter:playAmbientSound("DOJet")
    emitter:setVolumeAll(1)
end

DOPhases.BombDrop = function(player)
    local affectedZones = {}
    affectedZones.Forest = false
    affectedZones.DeepForest = false
    affectedZones.Nav = true
    affectedZones.Vegitation = false
    affectedZones.TownZone = true
    affectedZones.Ranch = false
    affectedZones.Farm = true
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

    local sounds = {"BurnedObjectExploded", "FlameTrapExplode", "SmokeBombExplode", "PipeBombExplode", "DOExploClose1", "DOExploClose2", "DOExploClose3", "DOExploClose4", "DOExploClose5", "DOExploClose6", "DOExploClose7", "DOExploClose8"}
    
    local function getSound()
        return sounds[1 + ZombRand(#sounds)]
    end

    -- players outside are safe, house campers not so much
    local offset = 2
    if player:isOutside() then
        offset = 6  
    end

    local ox = offset + ZombRand(34)
    local oy = offset + ZombRand(34)

    if ZombRand(2) == 1 then ox = -ox end
    if ZombRand(2) == 1 then oy = -oy end

    local x = player:getX() + ox
    local y = player:getY() + oy

    local zone = getWorld():getMetaGrid():getZoneAt(x, y, 0)
    if zone then
        local zoneType = zone:getType()
        if isAffectedZone(zoneType) then

            -- bomb sound
            local sound = getSound()
            local emitter = getWorld():getFreeEmitter(x, y, 0)
            emitter:playSound(sound)
            emitter:setVolumeAll(0.9)
            addSound(player, x, y, 0, 120, 100)

            -- wake up players
            BanditPlayer.WakeEveryone()

            -- explosion and fire
            local squares = {}
            table.insert(squares, {x=x, y=y})
            table.insert(squares, {x=x+2, y=y-2})
            table.insert(squares, {x=x+2, y=y+2})
            table.insert(squares, {x=x+4, y=y})

            for _, sq in pairs(squares) do
                if isClient() then
                    local args = {x=sq.x, y=sq.y, z=0}
                    sendClientCommand('object', 'addExplosionOnSquare', args)
                else
                    local square = getCell():getGridSquare(sq.x, sq.y, 0)
                    IsoFireManager.explode(getCell(), square, 100)
                end
            end

            -- junk placement
            BanditBaseGroupPlacements.Junk (x-4, y-4, 0, 6, 8, 3)

            -- damage to zombies, players are safe
            local fakeItem = InventoryItemFactory.CreateItem("Base.RollingPin")
            local cell = getCell()
            for dx=x-3, x+5 do
                for dy=y-3, y+4 do
                    local square = cell:getGridSquare(dx, dy, 0)
                    if square then
                        if ZombRand(4) == 1 then
                            BanditBasePlacements.IsoObject("floors_burnt_01_1", dx, dy, 0)
                        end
                        local zombie = square:getZombie()
                        if zombie then
                            zombie:Hit(fakeItem, cell:getFakeZombieForHit(), 50, false, 1, false)
                        end
                    end
                end
            end
        end
    end
end

DOPhases.WeatherStorm = function(player)
    if isClient() then
        getClimateManager():transmitTriggerStorm(12)
    else
        -- getClimateManager():triggerCustomWeatherStage(WeatherPeriod.STAGE_STORM, 12)
    end
end