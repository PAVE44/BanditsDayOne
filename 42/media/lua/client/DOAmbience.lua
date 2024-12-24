DOAmbience = DOAmbience or {}

DOAmbience.State = false

DOAmbience.CheckAmbience = function()
    if not DOAmbience.State then return end

    local player = getPlayer()
    local px = player:getX()
    local py = player:getY()

    local bcnt = 0
    local bandits = BanditZombie.GetAllB()
    for id, bandit in pairs(bandits) do
        local dist = math.sqrt(math.pow(px - bandit.x, 2) + math.pow(py - bandit.y, 2))
        if dist > 50 and dist < 110 then
            bcnt = bcnt + 1
        end
    end

    local zcnt = 0
    local zombies = BanditZombie.GetAllZ()
    for id, zombie in pairs(zombies) do
        local dist = math.sqrt(math.pow(px - zombie.x, 2) + math.pow(py - zombie.y, 2))
        if dist > 50 and dist < 110 then
            zcnt = zcnt + 1
        end
    end

    local emitter = player:getEmitter()
    if bcnt > 9 and zcnt > 15 then
        if not emitter:isPlaying("DOAmbientGuns") then
            player:playSound("DOAmbientGuns")
        end
    else
        if emitter:isPlaying("DOAmbientGuns") then
            emitter:stopSoundByName("DOAmbientGuns")
        end
    end
end

Events.EveryOneMinute.Add(DOAmbience.CheckAmbience)