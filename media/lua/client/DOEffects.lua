DOEffects = DOEffects or {}

DOEffects.tab = {}
DOEffects.tick = 0

DOEffects.Add = function(effect)

    table.insert(DOEffects.tab, effect)
end

DOEffects.Process = function()
    if isServer() then return end

    DOEffects.tick = DOEffects.tick + 1
    if DOEffects.tick >= 16 then
        DOEffects.tick = 0
    end

    if DOEffects.tick % 2 == 0 then return end

    local cell = getCell()
    for i, effect in pairs(DOEffects.tab) do

        local square = cell:getGridSquare(effect.x, effect.y, effect.z)
        if square then

            if not effect.repCnt then effect.repCnt = 1 end
            if not effect.rep then effect.rep = 1 end

            if not effect.frame then 

                local dummy = IsoObject.new(square, "")

                dummy:setOffsetX(effect.offset)
                dummy:setOffsetY(effect.offset)

                -- square:AddTileObject(dummy)
                square:AddSpecialObject(dummy)
                if effect.frameRnd then
                    effect.frame = 1 + ZombRand(effect.frameCnt)
                else
                    effect.frame = 1
                end

                effect.object = dummy

                if effect.name == "mist" then
                    effect.object:setCustomColor(0.1, 0.7, 0.2, 1)
                end

            end
            
            if effect.frame > effect.frameCnt and effect.rep >= effect.repCnt then
                square:RemoveTileObject(effect.object)
                DOEffects.tab[i] = nil
            else
                if effect.frame > effect.frameCnt then
                    effect.rep = effect.rep + 1
                    effect.frame = 1
                end

                local frameStr = string.format("%03d", effect.frame)
                local alpha = (effect.repCnt - effect.rep + 1) / effect.repCnt
                local sprite = effect.object:getSprite()
                
                if sprite then
                    effect.object:getSprite():LoadFrameExplicit("media/textures/FX/" .. effect.name .. "/" .. frameStr .. ".png")
                    --effect.object:setAlpha(alpha)
                    effect.frame = effect.frame + 1
                    
                    if effect.name == "mist" then
                        --effect.object:setCustomColor(0.1,0.7,0.2, alpha)
                        if effect.frame % 10 == 1 then
                            local actors = BanditZombie.GetAll()
                            for _, actor in pairs(actors) do
                                local dist = math.sqrt(math.pow(actor.x - effect.x, 2) + math.pow(actor.y - effect.y, 2))
                                if dist < 3 then
                                    local character = BanditZombie.GetInstanceById(actor.id)
                                    character:setHealth(character:getHealth() - 0.1)
                                end
                            end
                            local player = getPlayer()
                            local dist = math.sqrt(math.pow(player:getX() - effect.x, 2) + math.pow(player:getY() - effect.y, 2))
                            if dist < 3 then
                                local bodyDamage = player:getBodyDamage()
                                local sick = bodyDamage:getFoodSicknessLevel()
                                bodyDamage:setFoodSicknessLevel(sick + 2)

                                local stats = player:getStats()
                                local drunk = stats:getDrunkenness()
                                stats:setDrunkenness(drunk + 4)
                            end
                        end
                    end
                end
            end
        else
            DOEffects.tab[i] = nil
        end
    end
end

local onServerCommand = function(mod, command, args)
    if mod == "DOEffects" then
        DOEffects[command](args)
    end
end

Events.OnServerCommand.Add(onServerCommand)
Events.OnTick.Add(DOEffects.Process)