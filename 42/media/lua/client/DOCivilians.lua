DOCivilians = DOCivilians or {}

DOCivilians.State = false

DOCivilians.ControlPopulation = function()
    if not DOCivilians.State then return end
    local player = getPlayer()
    local px, py = player:getX(), player:getY()
    local zCnt = 0
    local cCnt = 0
    local zCntClose = 0
    local cCntClose = 0
    
    local actors = BanditZombie.GetAll()
    for _, actor in pairs(actors) do
        local dist = math.sqrt(math.pow(actor.x - px, 2) + math.pow(actor.y - py, 2))
        if actor.isBandit then
            cCnt = cCnt + 1
            if dist < 50 then
                cCntClose = cCntClose + 1
            end
        else
            zCnt = zCnt + 1
            if dist < 50 then
                zCntClose = zCntClose + 1
            end
        end

        local fz = getCell():getFakeZombieForHit()
        local genItem = instanceItem("Base.RollingPin")
        if dist > 80 then
            if actor.id % 4 == 0 then
                local actor = BanditZombie.GetInstanceById(actor.id)
                if actor then
                    actor:addBlood(0.6)
                    -- SwipeStatePlayer.splash(actor, item, fz)

                    actor:Hit(item, fz, 1.01, false, 1, false)
                    if actor:getHealth() <= 0 then
                        actor:setHealth(0)
                        actor:clearAttachedItems()
                        -- bandit:changeState(ZombieOnGroundState.instance())
                        actor:setAttackedBy(getCell():getFakeZombieForHit())
                        -- bandit:becomeCorpse()
                    end
                end
            end
        end
    end

    local intensity = (SandboxVars.BanditsDayOne.General_CivilianIntensity - 1) * 10
    -- print ("-----------------------------------------------------------------")
    -- print ("-- POOL: " .. (cCnt * 100 / intensity) .. "% CC:" .. (cCntClose + 10) .. " ZC:" .. zCntClose)
    -- print ("-----------------------------------------------------------------")
    if cCnt < intensity then
        if cCntClose + 10 < zCntClose then
            DOPhases.SpawnPeopleStreetFar(player)
        end
    end
end

Events.EveryOneMinute.Add(DOCivilians.ControlPopulation)
