DOSpecialSpawn = DOSpecialSpawn or {}

DOSpecialSpawn.State = false
DOSpecialSpawn.Locations = {}

local configHigh = {}
configHigh.hasRifleChance = 85
configHigh.hasPistolChance = 100
configHigh.rifleMagCount = 7
configHigh.pistolMagCount = 4

local configLow = {}
configLow.hasRifleChance = 85
configLow.hasPistolChance = 100
configLow.rifleMagCount = 7
configLow.pistolMagCount = 4

local configNone = {}
configNone.hasRifleChance = 0
configNone.hasPistolChance = 0
configNone.rifleMagCount = 0
configNone.pistolMagCount = 0

local checkpoint = {}
checkpoint.x1 = 12450
checkpoint.x2 = 12580
checkpoint.y1 = 4220
checkpoint.y2 = 4330
checkpoint.clanId = 16
checkpoint.config = configHigh
checkpoint.cnt = 5
table.insert(DOSpecialSpawn.Locations, checkpoint)

local cortmanMedicalMuldraugh = {}
cortmanMedicalMuldraugh.x1 = 10860
cortmanMedicalMuldraugh.x2 = 10890
cortmanMedicalMuldraugh.y1 = 10015
cortmanMedicalMuldraugh.y2 = 10050
cortmanMedicalMuldraugh.clanId = 1
cortmanMedicalMuldraugh.config = configNone
cortmanMedicalMuldraugh.melee = "Base.Scalpel"
cortmanMedicalMuldraugh.outfit = "Doctor"
cortmanMedicalMuldraugh.cnt = 1

DOSpecialSpawn.ControlSpecialSpawn = function()
    if not DOSpecialSpawn.State then return end
    local player = getPlayer()
    local px, py = player:getX(), player:getY()

    for i, location in pairs(DOSpecialSpawn.Locations) do
        if not location.state then
            if px > location.x1 and px < location.x2 and py > location.y1 and py < location.y2 then
                location.state = true
                DOSpecialSpawn.Spawn(location)
            end
        end
    end

end

DOSpecialSpawn.Spawn = function(location)
    config = location.config
    config.clanId = location.clanId

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = "Looter"
    event.program.stage = "Prepare"

    event.x = location.x1 + ZombRand(location.x2 - location.x1)
    event.y = location.y1 + ZombRand(location.y2 - location.y1)

    for i=1, location.cnt do
        local bandit = BanditCreator.MakeFromWave(config)

        if location.outfit then
            bandit.outfit = location.outfit
        end
    
        if location.melee then
            bandit.weapons.melee = location.melee
        end

        event.bandits = {}
        for i=1, 4 do
            table.insert(event.bandits, bandit)
        end
        sendClientCommand(player, 'Commands', 'SpawnGroup', event)
    end
end

Events.EveryOneMinute.Add(DOSpecialSpawn.ControlSpecialSpawn)
