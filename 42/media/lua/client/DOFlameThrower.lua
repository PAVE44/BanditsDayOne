DOFlameThrower = DOFlameThrower or {}

DOFlameThrower.tab = {}

DOFlameThrower.tex = {}
for size=20, 120, 10 do
    DOFlameThrower.tex[size] = {}
    for frame=1, 17 do
        local frameStr = string.format("%03d", frame)
        DOFlameThrower.tex[size][frame] = getTexture("media/textures/FX/flamethrower/" .. tostring(size) .. "/" .. frameStr .. ".png")
    end
end

DOFlameThrower.Add = function(effect)
    table.insert(DOFlameThrower.tab, effect)
end

DOFlameThrower.Process = function()
    if isServer() then return end
    
    local player = getPlayer()
    if not player then return end

    local zoom = getCore():getZoom(player:getPlayerNum())
    zoom = PZMath.clampFloat(zoom, 0.0, 1.0)

    for i, effect in pairs(DOFlameThrower.tab) do

        if not effect.frame then effect.frame = 1 end

        local sx, sy = ISCoordConversion.ToScreen(effect.x, effect.y, 0)
        local theta = effect.angle * math.pi / 180
        for l=1, 11 do
            local step = l * 20
            local x = math.floor(sx + (step * math.cos(theta)))
            local y = math.floor(sy + (step * math.sin(theta)))
            local size = (l + 1) * 10
            local frame = effect.frame - l + 1
            if frame >= 1 then
                local tex = DOFlameThrower.tex[size][frame]
                if tex then
                    UIManager.DrawTexture(tex, x*zoom, y*zoom, size, size, 1)
                end
            end
        end

        effect.frame = effect.frame + 1
        if effect.frame >= 25 then
            DOFlameThrower.tab[i] = nil
        end
    end
end

local onServerCommand = function(mod, command, args)
    if mod == "DOFlameThrower" then
        DOEffects[command](args)
    end
end

-- OnServerCommand.Add(onServerCommand)
-- Events.OnPreUIDraw.Add(DOFlameThrower.Process)
