DOEffects2 = DOEffects2 or {}

DOEffects2.tab = {}
DOEffects2.tick = 0

DOEffects2.Add = function(effect)
    table.insert(DOEffects2.tab, effect)
end

DOEffects2.Process = function()
    if not isIngameState() then return end
    if isServer() then return end

    local player = getSpecificPlayer(0)
    if player == nil then return end
    local playerNum = player:getPlayerNum()
    local zoom = getCore():getZoom(playerNum)

    local cell = getCell()
    for i, effect in pairs(DOEffects2.tab) do

        local square = cell:getGridSquare(effect.x, effect.y, effect.z)
        if square then

            if not effect.repCnt then effect.repCnt = 1 end
            if not effect.rep then effect.rep = 1 end

            local size = effect.size / zoom
            local offset = size / 2
            local tx = isoToScreenX(playerNum, effect.x, effect.y, effect.z) - offset
            local ty = isoToScreenY(playerNum, effect.x, effect.y, effect.z) - offset

            if not effect.frame then 
                if effect.frameRnd then
                    effect.frame = 1 + ZombRand(effect.frameCnt)
                else
                    effect.frame = 1
                end
            end

            if effect.frame > effect.frameCnt and effect.rep >= effect.repCnt then
                DOEffects2.tab[i] = nil
            else
                if effect.frame > effect.frameCnt then
                    effect.rep = effect.rep + 1
                    effect.frame = 1
                end

                local frameStr = string.format("%03d", effect.frame)
                local tex = getTexture("media/textures/FX/" .. effect.name .. "/" .. frameStr .. ".png")
                UIManager.DrawTexture(tex, tx, ty, size, size, 0.7)

                if effect.colors then
                    -- .object:setCustomColor(effect.colors.r, effect.colors.g, effect.colors.b, effect.colors.a)
                end
                effect.frame = effect.frame + 1

                if effect.poison then
                    -- effect.object:setCustomColor(0.1,0.7,0.2, alpha)
                    if effect.frame % 10 == 1 then
                        local actors = BanditZombie.GetAll()
                        for _, actor in pairs(actors) do
                            local dist = math.sqrt(math.pow(actor.x - effect.x, 2) + math.pow(actor.y - effect.y, 2))
                            if dist < 3 then
                                local character = BanditZombie.GetInstanceById(actor.id)
                                local outfit = character:getOutfitName()
                                if outfit ~= "ZSArmySpecialOps" then
                                    character:setHealth(character:getHealth() - 0.12)
                                end
                            end
                        end
                        local immune = false
                        local mask = player:getWornItem("MaskEyes")
                        if mask then
                            if mask:getFullType() == "Base.Hat_GasMask" then 
                                immune = true 
                            end
                        end
                        if not immune then
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
            DOEffects2.tab[i] = nil
        end
    end
end

local onServerCommand = function(mod, command, args)
    if mod == "DOEffects2" then
        DOEffects2[command](args)
    end
end

Events.OnServerCommand.Add(onServerCommand)
Events.OnPreUIDraw.Add(DOEffects2.Process)