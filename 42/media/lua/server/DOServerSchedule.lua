
DOServer = DOServer or {}

DOServer.Schedule = DOServer.Schedule or {}

function DOServer.Schedule.Kaboom(player, args)
    local px = player:getX()
    local py = player:getY()
    local cell = player:getCell()
    local r = args.r
    for z=0, 4 do
        for y=-r, r do
            for x=-r, r do
                local bx = px + x
                local by = py + y
                local dist = math.sqrt(math.pow(bx - px, 2) + math.pow(by - py, 2))
                if dist < r then
                    local square = cell:getGridSquare(bx, by, z)
                    if square then
                        square:BurnWalls(false)
                        if ZombRand(4) == 1 and square:isFree(false) then
                            local obj = IsoObject.new(square, "floors_burnt_01_1", "")
                            square:AddSpecialObject(obj)
                            obj:transmitCompleteItemToClients()
                        end
                        if ZombRand(6) == 1 and square:isFree(false) then
                            local rn = ZombRand(53)
                            local sprite = "trash_01_" .. tostring(rn)
                            local obj = IsoObject.new(square, sprite, "")
                            square:AddSpecialObject(obj)
                            obj:transmitCompleteItemToClients()
                        end
                    end
                end
            end
        end
    end
end

function DOServer.Schedule.AddEffect(player, args)
    sendServerCommand('DOEffects2', 'Add', args)
end

local onClientCommand = function(module, command, player, args)
    if DOServer[module] and DOServer[module][command] then
        local argStr = ""
        for k, v in pairs(args) do
            argStr = argStr .. " " .. k .. "=" .. tostring(v)
        end
        DOServer[module][command](player, args)
        TransmitDOModData()
    end
end

Events.OnClientCommand.Add(onClientCommand)
