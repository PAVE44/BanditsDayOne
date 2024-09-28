DOTV = DOTV or {}

DOTV.State = true

DOTV.TVBroadCast = function()
    local player = getPlayer()
    local cell = getCell()
    local world = getWorld()
    local cx = player:getX()
    local cy = player:getY()
    local tvs = {}
    for z = 0, 7 do
        for y = cy-12, cy+12 do
            for x = cx-12, cx+12 do
                local square = cell:getGridSquare(x, y, z)
                if square then
                    local objects = square:getObjects()
                    for i=0, objects:size()-1 do
                        local object = objects:get(i)
                        if object then
                            if instanceof(object, "IsoTelevision") then
                                local dd = object:getDeviceData()
                                local emitter = dd:getEmitter()
                                if emitter then
                                    if dd:getIsTurnedOn() then
                                        dd:StopPlayMedia()

                                        --local emitter = world:getFreeEmitter(object:getX(), object:getY(), object:getZ())
                                        emitter:setVolumeAll(dd:getDeviceVolume())
                                        if not emitter:isPlaying("DOTV") then
                                            emitter:stopAll()
                                            emitter:playSound("DOTV")
                                        end
                                    else
                                        emitter:stopSoundByName("DOTV")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

Events.EveryOneMinute.Add(DOTV.TVBroadCast)