DOScheduler = DOScheduler or {}
 
DOScheduler.Schedule = {}

function DOScheduler.GenerateEvents()

    local player = getPlayer()
    local gametime = getGameTime()

    local startHour = gametime:getStartTimeOfDay()
    local startDay = gametime:getStartDay()
    local startMonth = gametime:getStartMonth()
    local startYear = gametime:getStartYear()

    local day = gametime:getDay()
    local hour = gametime:getHour()
    local month = gametime:getMonth()
    local year = gametime:getYear()

    local minute = gametime:getMinutes()

    -- print ("schedule cnt: " .. #DOScheduler.Schedule)

    -- in multiplayer getStartDay and getDay returns bullshit value, so this needs to be corrected
    local gamemode = getWorld():getGameMode()
    if gamemode == "Multiplayer" then 
        startDay = startDay - 13
        startYear = startYear - 19
        month = month + 1
        day = day + 1
    end
    
    if month ~= 6 then return end

    local worldAge = (day * 24 + hour) - (startDay * 24 + startHour)

    DOCivilians.State = false
    if worldAge < 21 then
        DOCivilians.State = true
    end

    DOAmbience.State = false
    if worldAge > 1 and worldAge < 20 then
        DOAmbience.State = true
    end

    DOTV.State = false
    if worldAge < 17 then
        DOTV.State = true
    end

    DOEraser.State = false
    if worldAge > 8 and worldAge < 28 then
        DOEraser.State = true
    end

    DOSpecialSpawn.State = false
    if false and worldAge < 30 then
        DOSpecialSpawn.State = true
    end

    if startMonth - month ~= 0 or startYear - year ~= 0 then return end 
    if worldAge < 0 or worldAge > 24 then return end

    -- 09.00
    if worldAge < 1 then
        if minute == 1 then
            DOPhases.SpawnFamilly(player)
            DOPhases.SpawnPeopleInHouses(player)
            DOPhases.Siren(player)
        elseif minute == 2 then
            DOPhases.SpawnPeopleStreet(player, 2)
            DOPhases.SpawnPolicePatrol(player, 1, "Police")
        elseif minute == 3 then
            DOPhases.UpdateVehicles(player)
        elseif minute == 22 then
            DOPhases.SpawnPolicePatrol(player, 1, "Police")
        elseif minute == 23 then
            DOPhases.UpdateVehicles(player)
        elseif minute == 25 then
            DOPhases.ChopperAlert(player)
        elseif minute == 44 then
            DOPhases.SpawnPolicePatrol(player, 1, "Police")
        elseif minute == 45 then
            DOPhases.UpdateVehicles(player)
        end
    
    -- 10.00
    elseif worldAge < 2 then
        if minute == 11 then
            DOPhases.SpawnPolicePatrol(player, 1, "Police")
        elseif minute == 12 then
            DOPhases.UpdateVehicles(player)
        elseif minute == 44 then
            DOPhases.ChopperAlert(player)
            DOPhases.UpdateVehicles(player)
        elseif minute == 45 then
            DOPhases.SpawnPolicePatrol(player, 2, "PoliceState")
        end

    -- 11.00
    elseif worldAge < 3 then
        if minute == 15 then
            DOPhases.SpawnFireman(player, 2)
        elseif minute == 16 then
            DOPhases.UpdateVehicles(player)
        elseif minute == 20 then
            DOPhases.SpawnPeopleInHouses(player)
        elseif minute == 34 then
            DOPhases.SpawnFireman(player, 2)
        elseif minute == 45 then
            DOPhases.SpawnPolicePatrol(player, 2, "ZSPoliceSpecialOps")
        elseif minute == 47 then
            DOPhases.SpawnPolicePatrol(player, 3, "ZSPoliceSpecialOps")
        end

    -- 12.00
    elseif worldAge < 4 then
        if minute == 11 then
            DOPhases.ChopperAlert(player)
        elseif minute == 13 then
            DOPhases.SpawnPolicePatrol(player, 4, "PoliceRiot")
        elseif minute == 16 then
            DOPhases.SpawnPolicePatrol(player, 4, "PoliceRiot")
        elseif minute == 41 then
            DOPhases.SpawnPeopleInHouses(player)
        elseif minute == 59 then
            DOPhases.Siren(player)
        end

    -- 13.00
    elseif worldAge < 5 then
        if minute % 20 == 0 then
            DOGroupPhases.A10()
        end

        if minute == 4 then
            DOPhases.SpawnPolicePatrol(player, 3, "ZSPoliceSpecialOps")
        elseif minute == 16 then
            DOPhases.SpawnPeopleInHouses(player)
        elseif minute == 59 then
            DOPhases.Siren(player)
        end
    -- 14.00
    elseif worldAge < 6 then
        if minute % 5 == 0 then
            DOGroupPhases.Gas()
        end

        if minute == 3 then
            DOPhases.SpawnArmy(player, 2, "ZSArmySpecialOps")
        elseif minute == 44 then
            DOPhases.SpawnArmy(player, 2, "ZSArmySpecialOps")
        elseif minute == 59 then
            DOPhases.Siren(player)
        end

    -- 15.00
    elseif worldAge < 7 then
        if minute % 20 == 0 then
            DOGroupPhases.Bombing()
        end

        if minute == 6 then
            DOPhases.SpawnPeopleInHouses(player)
        elseif minute == 12 then 
            DOPhases.SpawnInmates(player, 5)
        elseif minute == 21 then
            DOPhases.SpawnArmy(player, 4)
        end

    -- 16.00
    elseif worldAge < 8 then
        if minute % 20 == 0 then
            DOGroupPhases.A10()
        end
        if minute % 10 == 0 then
            DOGroupPhases.Bombing()
        end

        if minute == 4 then
            DOPhases.SpawnArmy(player, 3)
        elseif minute == 33 then
            DOPhases.SpawnBandits(player, 1)
        end

    -- 17.00
    elseif worldAge < 9 then
        if minute == 10 then
            DOPhases.GetHelicopter()
        elseif minute == 59 then
            DOPhases.Siren(player)
        end

        if minute == 24 then
            DOPhases.SpawnArmy(player, 2)
        end

    -- 18.00
    elseif worldAge < 10 then
        if minute == 7 or minute == 17 or minute == 27 or minute == 37 or minute == 47 or minute == 57 then
            DOGroupPhases.A10()
        end
        if minute == 12 or minute == 22 or minute == 32 or minute == 42 or minute == 52 then
            DOGroupPhases.Bombing()
        end

        if minute == 33 then
            DOPhases.SpawnBandits(player, 1)
        elseif minute == 55 then
            DOPhases.SpawnArmy(player, 2)
        end
    -- 19.00
    elseif worldAge < 11 then
        if minute == 7 or minute == 17 or minute == 27 or minute == 37 or minute == 47 or minute == 57 then
            DOGroupPhases.A10()
        end
        if minute == 12 or minute == 22 or minute == 32 or minute == 42 or minute == 52 then
            DOGroupPhases.Bombing()
        end

        if minute == 33 then
            DOPhases.SpawnArmy(player, 1)
        elseif minute == 44 then
            DOPhases.SpawnBandits(player, 2)
        end

    -- 20.00
    elseif worldAge < 12 then
        if minute == 33 then
            DOPhases.SpawnBandits(player, 3)
        elseif minute == 59 then
            DOPhases.Siren(player)
        end

    -- 21.00
    elseif worldAge < 13 then
        if minute % 7 == 0 then
            DOGroupPhases.Bombing()
        end

        if minute == 20 then
            DOPhases.SpawnScientists(player, 2)
        elseif minute == 32 then
            DOPhases.SpawnScientists(player, 2)
        end


    -- 22.00
    elseif worldAge < 14 then
        if minute % 6 == 0 then
            DOGroupPhases.Bombing()
        end

    -- 23.00
    elseif worldAge < 15 then
        if minute % 5 == 0 then
            DOGroupPhases.Bombing()
        end
        if minute % 5 == 2 then
            DOGroupPhases.Gas()
        end

        if minute == 1 then
            DOPhases.SpawnBandits(player, 3)
        elseif minute == 28 then
            DOPhases.SpawnVeterans(player, 1)
        end
        
    -- 00.00
    elseif worldAge < 16 then
        if minute % 4 == 0 then
            DOGroupPhases.Bombing()
        end
        if minute % 2 == 0 then
            DOGroupPhases.Gas()
        end
        if minute % 21 == 0 then
            DOGroupPhases.A10()
        end

    -- 01.00
    elseif worldAge < 17 then
        if minute == 5 then
            DOGroupPhases.Gas()
        elseif minute == 44 then
            DOPhases.SpawnBandits(player, 3)
        end

    -- 02.00
    elseif worldAge < 18 then
        if minute == 4 then
            DOPhases.WeatherStorm(player)
        elseif minute == 7 then
            DOPhases.SpawnPsychopaths(player, 7)
        end

    -- 03.00
    elseif worldAge < 19 then

    -- 04.00
    elseif worldAge < 20 then
        if minute == 20 then
            DOPhases.SpawnScientists(player, 3)
        elseif minute == 32 then
            DOPhases.SpawnScientists(player, 2)
        end

    -- 05.00
    elseif worldAge < 21 then


    -- 06.00
    elseif worldAge < 22 then

        if minute == 11 then
            DOPhases.SpawnScientists(player, 3)
        elseif minute == 14 then
            DOPhases.SpawnScientists(player, 2)
        end

    -- 07.00
    elseif worldAge < 23 then
        if minute == 7 then
            DOPhases.SpawnGang(player, 1)
        elseif minute == 18 then
            DOPhases.SpawnGang(player, 2)
        elseif minute == 32 then
            DOPhases.SpawnGang(player, 4)
        elseif minute == 37 then
            DOPhases.SpawnGang(player, 1)
        end

    -- 08.00
    elseif worldAge < 24 then
        if minute == 53 then
            DOPhases.Siren(player)
        elseif minute == 57 then 
            DOGroupPhases.Kaboom()
        end

    -- 09.00
    end

end

-- processes schedule phases
function DOScheduler.CheckSchedule()
    local player = getPlayer()
    local ct = DOUtils.GetTime()
    for i, event in pairs(DOScheduler.Schedule) do
        if event.start < ct then
            if DOPhases[event.phase] then
                DOPhases[event.phase](player)
            end
            table.remove(DOScheduler.Schedule, i)
            break
        end
    end
end

Events.OnTick.Add(DOScheduler.CheckSchedule)
Events.EveryOneMinute.Add(DOScheduler.GenerateEvents)