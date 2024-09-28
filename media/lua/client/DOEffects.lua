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

        if not effect.frame then 
            
            local dummy = IsoObject.new(square, "")

            dummy:setOffsetX(effect.offset)
            dummy:setOffsetY(effect.offset)

            -- square:AddTileObject(dummy)
            square:AddSpecialObject(dummy)
            effect.frame = 1
            effect.object = dummy
        end
        
        if effect.frame > effect.frameCnt then
            square:RemoveTileObject(effect.object)
            DOEffects.tab[i] = nil
        else
            effect.object:getSprite():LoadFrameExplicit("media/textures/Explosion/Big/Explosion" .. tostring(effect.frame) .. ".png")
            effect.frame = effect.frame + 1
        end

    end

end

Events.OnTick.Add(DOEffects.Process)