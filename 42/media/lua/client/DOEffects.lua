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
                dummy:setRenderYOffset(100)
                square:AddSpecialObject(dummy)
                if effect.frameRnd then
                    effect.frame = 1 + ZombRand(effect.frameCnt)
                else
                    effect.frame = 1
                end

                effect.object = dummy

            end
            
            if effect.frame > effect.frameCnt and effect.rep >= effect.repCnt then
                square:RemoveTileObject(effect.object)
                DOEffects.tab[i] = nil
            else
                if effect.frame > effect.frameCnt then
                    effect.rep = effect.rep + 1
                    effect.frame = 1
                end

                -- local frameStr = string.format("%03d", effect.frame)
                -- local alpha = (effect.repCnt - effect.rep + 1) / effect.repCnt
                local sprite = effect.object:getSprite()
                
                if sprite then
                    local spriteName = effect.name .. "_" .. (effect.frame - 1)
                    
                    -- method 1
                    effect.object:setSprite(spriteName)

                    -- method 2
                    -- effect.object:setOverlaySprite(spriteName)
                    -- effect.object:setAttachedAnimSprite(ArrayList.new())

                    -- method 3
                    -- effect.object:getAttachedAnimSprite():add(getSprite(spriteName):newInstance())

                    -- method 4
                    -- effect.object:AttachAnim("Smoke", "03", 4, IsoFireManager.SmokeAnimDelay, 0, 12, true, 0, false, 0.7F, IsoFireManager.SmokeTintMod)

                    -- method b41
                    -- effect.object:setSprite(IsoSprite.new())
                    -- effect.object:getSprite():LoadFramesNoDirPageSimple("media/textures/FX/" .. effect.name .. "/" .. frameStr .. ".png")
                    effect.object:setAlpha(0.2)
                    if effect.colors then
                        effect.object:setCustomColor(effect.colors.r, effect.colors.g, effect.colors.b, effect.colors.a)
                    end
                    effect.frame = effect.frame + 1
                    
                    if effect.poison then
                        --effect.object:setCustomColor(0.1,0.7,0.2, alpha)
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
                            local player = getPlayer()
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