local player = PlayerPedId()

Citizen.CreateThread(function ()
    while true do
        local sleep = 1000
        local player = PlayerPedId()
        local playerLoc = GetEntityCoords(player)

        for _,location in ipairs(Config.positionsTp) do
            loc1 = {
                x=location[1][1],
                y=location[1][2],
                z=location[1][3],
                heading=location[1][4]
            }
            loc2 = {
                x=location[3][1],
                y=location[3][2],
                z=location[3][3],
                heading=location[3][4]
            }
            Red = location[5][1]
            Green = location[5][2]
            Blue = location[5][3]

            if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 2) then 
                sleep = 0
                DrawText3D(location[1][1], location[1][2], location[1][3], location[2])
                
                if IsControlJustReleased(1, Config.key_to_teleport) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                    else
                        SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(player, loc2.heading)
                    end
                end

            elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 2) then
                sleep = 0
                DrawText3D(location[3][1], location[3][2], location[3][3], location[4])

                if IsControlJustReleased(1, Config.key_to_teleport) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                    else
                        SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(player, loc1.heading)
                    end
                end
            end            
        end
        Citizen.Wait(sleep)
    end
end)

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end