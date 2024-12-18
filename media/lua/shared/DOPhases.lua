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

local function findOptimalPoint (player)
    local x
    local y

    local miss = true
    if ZombRand(5) > 1 then
        -- find targets
        local zombieList = BanditZombie.GetAll()
        for by=-6, 6 do
            for bx=-6, 6 do
                local y1 = player:getY() + by * 6 - 3
                local y2 = player:getY() + by * 6 + 3
                local x1 = player:getX() + bx * 6 - 3
                local x2 = player:getX() + bx * 6 + 3
                
                local cnt = 0
                local killList = {}
                for id, zombie in pairs(zombieList) do
                    if zombie.x > x1 and zombie.x < x2 and zombie.y > y1 and zombie.y < y2 then
                        if not zombie.isBandit then
                            cnt = cnt + 1
                        end
                    end
                end
                if cnt > 4 then
                    miss = false
                    x = x1 - 2 + ZombRand(5)
                    y = y1 - 2 + ZombRand(5)
                    break
                end
            end
        end
    end

    -- if no targets then random miss
    if miss then
        local offset = 2
        local r = 88
        if player:isOutside() then
            offset = 6  
            r = 55
        end

        local ox = offset + ZombRand(r)
        local oy = offset + ZombRand(r)

        if ZombRand(2) == 1 then ox = -ox end
        if ZombRand(2) == 1 then oy = -oy end

        x = player:getX() + ox
        y = player:getY() + oy
    end

    return x, y
end

DOPhases.SpawnFamilly = function(player)

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
    config.hasPistolChance = 45
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
                        local intensity = SandboxVars.BanditsDayOne.General_CivilianIntensity - 1
                        if intensity > 0 then
                            for i=1, intensity do
                                table.insert(event.bandits, bandit)
                            end
                            sendClientCommand(player, 'Commands', 'SpawnGroup', event)
                        end
                    end
                end
            end
        end
    end
end

DOPhases.SpawnPeopleStreet = function(player, cnt)

    -- PEOPLE IN THE STREET
    config = {}
    config.clanId = 1
    config.hasRifleChance = 0
    config.hasPistolChance = 27
    config.rifleMagCount = 0
    config.pistolMagCount = 2

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local intensity = (SandboxVars.BanditsDayOne.General_CivilianIntensity - 1) * cnt
    for i=1, intensity do
        local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(25,45))
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

    local intensity = 2
    for i=1, intensity do
        local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(35,50))
        if spawnPoint then
            event.x = spawnPoint.x
            event.y = spawnPoint.y
            event.bandits = {}
            
            local bandit = BanditCreator.MakeFromWave(config)
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

        end
    end
end

DOPhases.SpawnFireman = function(player, cnt)

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
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(25,35))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        bandit.outfit = "FiremanFullSuit"
        bandit.weapons.melee = "Base.Axe"

        local intensity = (SandboxVars.BanditsDayOne.General_CivilianIntensity - 1) * cnt
        if intensity > 0 then
            for i=1, intensity do
                table.insert(event.bandits, bandit)
            end
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)

            local args = {type="Base.PickUpTruckLightsFire", x=spawnPoint.x, y=spawnPoint.y, engine=true, lights=true, lightbar=true}
            sendClientCommand(player, 'Commands', 'VehicleSpawn', args)
        end
    end
end

DOPhases.SpawnPolicePatrol = function(player, cnt, outfit)
    -- POLICE PATROL
    config = {}
    config.clanId = 6
    config.hasRifleChance = 10
    config.hasPistolChance = 100
    config.rifleMagCount = 2
    config.pistolMagCount = 4

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(25,35))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        if outfit then
            bandit.outfit = outfit
        end
        local intensity = (SandboxVars.BanditsDayOne.General_PoliceIntensity - 1) * cnt
        if intensity > 0 then
            for i=1, intensity do
                table.insert(event.bandits, bandit)
            end
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)

            local args = {type="Base.PickUpVanLightsPolice", x=spawnPoint.x, y=spawnPoint.y, engine=true, lights=true, lightbar=true}
            sendClientCommand(player, 'Commands', 'VehicleSpawn', args)
        end
    end
end

DOPhases.SpawnArmy = function(player, cnt, outfit)

    config = {}
    config.clanId = 16
    config.hasRifleChance = 100
    config.hasPistolChance = 100
    config.rifleMagCount = 8
    config.pistolMagCount = 4

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(30,45))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        if outfit then
            bandit.outfit = outfit
        end
        local intensity = (SandboxVars.BanditsDayOne.General_ArmyIntensity - 1) * cnt
        if intensity > 0 then
            for i=1, intensity do
                table.insert(event.bandits, bandit)
            end

            sendClientCommand(player, 'Commands', 'SpawnGroup', event)

        end
    end
end

DOPhases.SpawnVeterans = function(player, cnt)

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
        local intensity = (SandboxVars.BanditsDayOne.General_ArmyIntensity - 1) * cnt
        if intensity > 0 then
            for i=1, intensity do
                table.insert(event.bandits, bandit)
            end
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)
        end
    end
end

DOPhases.SpawnScientists = function(player, cnt)
    
    config = {}
    config.clanId = 12
    config.hasRifleChance = 50
    config.hasPistolChance = 100
    config.rifleMagCount = 2
    config.pistolMagCount = 4

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(35,55))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        local intensity = (SandboxVars.BanditsDayOne.General_ArmyIntensity - 1) * cnt
        if intensity > 0 then
            for i=1, intensity do
                table.insert(event.bandits, bandit)
            end
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)
        end
    end
end

DOPhases.SpawnGang = function(player, cnt)
    
    config = {}
    config.clanId = 9
    config.hasRifleChance = 0
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
        local intensity = (SandboxVars.BanditsDayOne.General_GangsIntensity - 1) * cnt
        if intensity > 0 then
            for i=1, intensity do
                table.insert(event.bandits, bandit)
            end
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)
        end
    end
end

DOPhases.SpawnBandits = function(player, cnt)
    
    config = {}
    config.clanId = 13
    config.hasRifleChance = 1
    config.hasPistolChance = 37
    config.rifleMagCount = 0
    config.pistolMagCount = 3

    local event = {}
    event.hostile = true
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(30,50))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}
        
        local bandit = BanditCreator.MakeFromWave(config)
        local intensity = (SandboxVars.BanditsDayOne.General_GangsIntensity - 1) * cnt
        if intensity > 0 then
            for i=1, intensity do
                table.insert(event.bandits, bandit)
            end
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)
        end
    end
end

DOPhases.SpawnInmates = function(player, cnt)
    
    config = {}
    config.clanId = 5
    config.hasRifleChance = 3
    config.hasPistolChance = 22
    config.rifleMagCount = 2
    config.pistolMagCount = 3

    local event = {}
    event.hostile = true
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
        local intensity = (SandboxVars.BanditsDayOne.General_GangsIntensity - 1) * cnt
        if intensity > 0 then
            for i=1, intensity do
                table.insert(event.bandits, bandit)
            end
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)
        end
    end
end

DOPhases.SpawnPsychopaths = function(player, cnt)
    
    config = {}
    config.clanId = 2
    config.hasRifleChance = 0
    config.hasPistolChance = 0
    config.rifleMagCount = 0
    config.pistolMagCount = 0

    local event = {}
    event.hostile = true
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    local spawnPoint = BanditScheduler.GenerateSpawnPoint(player, ZombRand(35,41))
    if spawnPoint then
        event.x = spawnPoint.x
        event.y = spawnPoint.y
        event.bandits = {}

        local bandit = BanditCreator.MakeFromWave(config)
        bandit.outfit = "HospitalPatient"

        local intensity = (SandboxVars.BanditsDayOne.General_GangsIntensity - 1) * cnt
        if intensity > 0 then
            for i=1, intensity do
                table.insert(event.bandits, bandit)
            end
            sendClientCommand(player, 'Commands', 'SpawnGroup', event)
        end
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
        if vehicle and not vehicle:isEngineRunning() then
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

DOPhases.Kaboom = function(player)
    local px = player:getX()
    local py = player:getY()
    
    DOTex.speed = 0.018
    DOTex.tex = getTexture("media/textures/mask_white.png")
    DOTex.alpha = 2
    player:playSound("DOKaboom")

    local r = 80
    args = {}
    args.r = r
    sendClientCommand(player, 'Schedule', 'Kaboom', args)

    local fakeItem = InventoryItemFactory.CreateItem("Base.RollingPin")
    local fakeZombie = getCell():getFakeZombieForHit()
    local zombieList = BanditZombie.GetAll()
    for id, z in pairs(zombieList) do
        local dist = math.sqrt(math.pow(z.x - px, 2) + math.pow(z.y - py, 2))
        if dist < r then
            local character = BanditZombie.GetInstanceById(id)
            if character and character:isOutside() then
                character:Hit(fakeItem, fakeZombie, 50, false, 1, false)
                character:setCrawler(true)
                character:setHealth(0)
                character:clearAttachedItems()
                character:changeState(ZombieOnGroundState.instance())
                character:setAttackedBy(fakeZombie)
                character:becomeCorpse()
            end
        end
    end

    if player:isOutside() then
        player:clearVariable("BumpFallType")
        player:setBumpType("stagger")
        player:setBumpFall(true)
        player:setBumpFallType("pushedBehind")
        
        local bodyPart
        bodyPart = player:getBodyDamage():getBodyPart(BodyPartType.Head)
        bodyPart:setBurned()
        bodyPart:setAdditionalPain(100)

        bodyPart = player:getBodyDamage():getBodyPart(BodyPartType.Hand_L)
        bodyPart:setBurned()
        bodyPart:setAdditionalPain(100)

        bodyPart = player:getBodyDamage():getBodyPart(BodyPartType.Hand_R)
        bodyPart:setBurned()
        bodyPart:setAdditionalPain(100)
        
    end
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

    -- where it hits
    local x, y = findOptimalPoint(player)

    -- strike only in urban area
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
            local square = getCell():getGridSquare(x, y, 0)
            if not square then return end

            if isClient() then
                local args = {x=x, y=y, z=0}
                sendClientCommand('object', 'addExplosionOnSquare', args)
            else
                
                IsoFireManager.explode(getCell(), square, 100)
            end

            -- blast tex
            local effect = {}
            effect.x = square:getX()
            effect.y = square:getY()
            effect.z = square:getZ()
            effect.offset = 320
            effect.name = "explobig"
            effect.frameCnt = 17
            if isClient() then
                sendClientCommand(getPlayer(), 'Schedule', 'AddEffect', effect)
            else
                table.insert(DOEffects.tab, effect)
            end

            -- light blast
            local colors = {r=1.0, g=0.5, b=0.5}
            local lightSource = IsoLightSource.new(x, y, 0, colors.r, colors.g, colors.b, 60, 10)
            getCell():addLamppost(lightSource)
            
            local lightLevel = square:getLightLevel(0)
            if lightLevel < 0.95 and player:isOutside() then
                local px = player:getX()
                local py = player:getY()
                local sx = square:getX()
                local sy = square:getY()

                local dx = math.abs(px - sx)
                local dy = math.abs(py - sy)

                local tex
                local dist = math.sqrt(math.pow(sx - px, 2) + math.pow(sy - py, 2))
                if dist > 40 then dist = 40 end

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
                DOTex.speed = 0.05
                local alpha = 1.2 - (dist / 40)
                if alpha > 1 then alpha = 1 end
                DOTex.alpha = alpha
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

DOPhases.GasDrop = function(player)

    local square = player:getSquare()
    local x, y = findOptimalPoint(player)
    local svec = {}
    table.insert(svec, {x=-3, y=-1})
    table.insert(svec, {x=3, y=1})
    table.insert(svec, {x=-1, y=-3})
    table.insert(svec, {x=1, y=3})

    for _, v in pairs(svec) do
        local effect = {}
        effect.x = x + v.x
        effect.y = y + v.y
        effect.z = 0
        effect.offset = 300
        effect.name = "mist"
        effect.frameCnt = 60
        effect.frameRnd = true
        effect.repCnt = 10
        if isClient() then
            sendClientCommand(getPlayer(), 'Schedule', 'AddEffect', effect)
        else
            table.insert(DOEffects.tab, effect)
        end
    end

    local colors = {r=0.2, g=1.0, b=0.3}
    local lightSource = IsoLightSource.new(x, y, 0, colors.r, colors.g, colors.b, 60, 10)
    getCell():addLamppost(lightSource)

    local emitter = getWorld():getFreeEmitter(x, y, 0)
    emitter:playSound("DOGas")
    emitter:setVolumeAll(0.25)
end

DOPhases.A10 = function(player)
    local zombieList = BanditZombie.GetAll()
    for by=-1, 1 do
        for bx=-1, 1 do
            local y1 = player:getY() + by * 20 - 10
            local y2 = player:getY() + by * 20 + 10
            local x1 = player:getX() + bx * 20 - 10
            local x2 = player:getX() + bx * 20 + 10
            
            local cnt = 0
            local killList = {}
            for id, zombie in pairs(zombieList) do
                if zombie.x > x1 and zombie.x < x2 and zombie.y > y1 and zombie.y < y2 then
                    -- the strike is counting zombies only, but if threshold is reached all in the area will be affected
                    if not zombie.isBandit then
                        cnt = cnt + 1
                    end
                    killList[zombie.id] = zombie
                end
            end

            if cnt > 12 then
                local fakeItem = InventoryItemFactory.CreateItem("Base.AssaultRifle")
                local fakeZombie = getCell():getFakeZombieForHit()
                for id, zombie in pairs(killList) do
                    local character = BanditZombie.GetInstanceById(id)
                    if character and character:isOutside() then
                        character:Hit(fakeItem, fakeZombie, 1 + ZombRand(20), false, 1, false)
                        SwipeStatePlayer.splash(character, fakeItem, fakeZombie)
                    end
                end

                if player:isOutside() and player:getX() > x1 and player:getX() < x2 and player:getY() > y1 and player:getY() < y2 then
                    if ZombRand(4) == 0 then
                        player:Hit(fakeItem, fakeZombie, 0.8, false, 1, false)
                        SwipeStatePlayer.splash(player, fakeItem, fakeZombie)
                    end
                end

                local sound = "DOA10"
                local emitter = getWorld():getFreeEmitter(x1+10, y1+10, 0)
                emitter:playSound(sound)
                emitter:setVolumeAll(0.9)
                addSound(player, x1+10, y1+10, 0, 120, 100)
                return
            end
        end
    end
end

DOPhases.WeatherStorm = function(player)
    if isClient() then
        getClimateManager():transmitTriggerStorm(6)
    else
        getClimateManager():triggerCustomWeatherStage(WeatherPeriod.STAGE_STORM, 6)
    end
end

