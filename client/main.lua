local PlayerData = {}

Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
    
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function DrawText3D(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
			
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
		
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 68)
end

local display = false

if Config.BlipOn then
    Citizen.CreateThread(function()
        Citizen.Wait(0)
        for _, info in pairs(Config.blips) do
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite (info.blip, info.id)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale  (info.blip, 0.7)
            SetBlipColour (info.blip, info.colour)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.title)
            EndTextCommandSetBlipName(info.blip)
        end
    end)
end

Citizen.CreateThread(function()

    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
		local playerPed = PlayerPedId()
		
		for k, v in pairs (Config.Containers) do
			local depository_name = v.depository_name
            local depository_loc = v.location
			local depository_dist = GetDistanceBetweenCoords(playerCoords, depository_loc.x, depository_loc.y, depository_loc.z, 1)
			if depository_dist <= 1.0 then
                sleep = 0
				DrawText3D(depository_loc.x, depository_loc.y, depository_loc.z, v.openText)
				if IsControlJustReleased(0, 38) then
					ESX.TriggerServerCallback('uniscript_deposit:checkContainer', function(checkContainer)
						ContainerMenu(k, checkContainer)
					end, k)
				end
			end
			
		end
        Citizen.Wait(sleep)
	end
	
end)

function KeyboardInput(Titolo, TestoEsempio, LunghezzaMax)
	AddTextEntry('FMMC_KEY_TIP1', Titolo) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", TestoEsempio, "", "", "", LunghezzaMax)
	blockinput = true 
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

ContainerMenu = function(k, hasContainer)
    local elements = {}
    local deposit = nil
    local data = nil
	if hasContainer then
        TriggerServerEvent('uniscript_deposit:loadStashes',k) 
        ESX.TriggerServerCallback('uniscript_deposit:checkNameContainer', function(checkContainer)
            deposit = checkContainer
            table.insert(elements, {icon = '', title = Lang.sell, description = Lang.sell_description})
            table.insert(elements, {icon = '', title = Lang.open, description = Lang.open_description})
            table.insert(elements, {icon = '', title = Lang.change_lock, description = Lang.change_lock_description})
            table.insert(elements, {icon = '', title = Lang.duplicate_key, description = Lang.duplicate_key_description})
            table.insert(elements, {icon = '', title = Lang.close, description = Lang.close_descripion})
            exports["esx_context"]:Open("right", elements, function(menu, element)
                if element.title == Lang.sell then
                    exports["esx_context"]:Close()
                    TriggerServerEvent('uniscript_deposit:stopRentingContainer', k, deposit)
                elseif element.title == Lang.open then
                    exports["esx_context"]:Close()
                    exports.ox_inventory:openInventory('stash', k.. '-'..Lang.inventory)
                    Notify(" Deposit is open")
                elseif element.title == Lang.change_lock then
                    exports["esx_context"]:Close()
                    local name = KeyboardInput(Lang.new_name, '', 10)
                    TriggerServerEvent('uniscript_deposit:cambiaNome', k, name)
                elseif element.title == Lang.duplicate_key then
                    exports["esx_context"]:Close()
                    TriggerServerEvent('uniscript_deposit:duplica_chiave',deposit)
                elseif element.title == Lang.close then
                    exports["esx_context"]:Close()
                end
            end)
        end,k)
	end
    if not hasContainer then
        TriggerServerEvent('uniscript_deposit:loadStashes',k)
        ESX.TriggerServerCallback('uniscript_deposit:proprietà', function(venduto)
            data = venduto
            if data == false then
                table.insert(elements, {icon = '', title = Lang.rent, description = Lang.rent_description})
                table.insert(elements, {icon = '', title = Lang.close, description = Lang.close_description})

                exports["esx_context"]:Open("right", elements, function(menu, element)
                    if element.title == Lang.rent then
                        exports["esx_context"]:Close()
                        local name = KeyboardInput(Lang.insert_deposit, '', 10)
                        TriggerServerEvent('uniscript_deposit:startRentingContainer', k, name)
                    elseif element.title == Lang.close then
                        exports["esx_context"]:Close()
                    end
                end)
            elseif data == 0 then
                ESX.TriggerServerCallback('uniscript_deposit:checkNameContainer', function(checkContainer)
                    deposit = checkContainer
                    print(deposit)
                    local piede_porco = exports.ox_inventory:Search(2, 'WEAPON_CROWBAR')
                    local chiave = exports.ox_inventory:Search(2, 'keyscont', {description = Lang.keys..'-'..deposit})
                    print(chiave)
                    
                    if piede_porco > 0 then
                        table.insert(elements,{icon = '', title = Lang.force_lock, description = Lang.force_lock_description})
                    end
                    if chiave > 0 then
                        table.insert(elements,{icon = '', title = Lang.open, description = Lang.open_description})
                    end
                    if PlayerData.job and PlayerData.job.name == Config.ImpoundedJob  and PlayerData.job.grade == Config.ImpoundedJobGrade then
                        table.insert(elements,{icon = '', title = Lang.impound_Deposit, description = Lang.impound_Deposit_description})
                    end                  
                    table.insert(elements,{icon = '', title = Lang.close, description = Lang.not_own_deposit})
                    exports["esx_context"]:Open("right", elements, function(menu, element)
                        if element.title == Lang.force_lock then
                            exports["esx_context"]:Close()
                            TriggerServerEvent('uniscript_deposit:deleteitem','WEAPON_CROWBAR')
                            exports.ox_inventory:openInventory('stash', k.. '-'..Lang.inventory)
                            Notify(" Deposit is open")
                        elseif element.title == Lang.open then
                            exports["esx_context"]:Close()
                            exports.ox_inventory:openInventory('stash', k.. '-'..Lang.inventory)
                            Notify("Container  is open")
                        elseif element.title == Lang.impound_Deposit then
                            exports["esx_context"]:Close()
                            TriggerServerEvent('uniscript_deposit:sequestro', k)
                        elseif element.title == Lang.close then
                            exports["esx_context"]:Close()
                        end
                    end)
                end,k)
            elseif data == 2 then
                ESX.TriggerServerCallback('uniscript_deposit:checkNameContainer', function(checkContainer)
                    print(checkContainer)
                    deposit = checkContainer.name
                    if PlayerData.job and PlayerData.job.name == Config.ImpoundedJob and PlayerData.job.grade == Config.ImpoundedJobGrade then
                        table.insert(elements,{icon = '', title = Lang.released, description = Lang.released_description})
                        table.insert(elements,{icon = '', title = Lang.put_sale, description = Lang.put_sale_description})
                        table.insert(elements,{icon = '', title = Lang.open, description = Lang.open_description})
                    end                  
                    table.insert(elements,{icon = '', title = Lang.close, description = Lang.not_own_deposit})
                    exports["esx_context"]:Open("right", elements, function(menu, element)
                        if element.title == Lang.open then
                            exports["esx_context"]:Close()
                            exports.ox_inventory:openInventory('stash', k.. '-'..Lang.inventory)
                            Notify(" Deposit is open")
                        elseif element.title == Lang.released then
                            exports["esx_context"]:Close()
                            TriggerServerEvent('uniscript_deposit:reintegra', k)
                        elseif element.title == Lang.put_sale then
                            exports["esx_context"]:Close()
                            TriggerServerEvent('uniscript_deposit:rivendi', k)
                        elseif element.title == Lang.close then
                            exports["esx_context"]:Close()
                        end
                    end)
                end,k)
            end
        end,k)
	end
end

RegisterNetEvent("uniscript_deposit:notify")
AddEventHandler("uniscript_deposit:notify",function(msg)
    Notify(msg)
end)