RegisterServerEvent('uniscript_deposit:loadStashes')
AddEventHandler('uniscript_deposit:loadStashes', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local stash = id
    if stash ~= nil then
		MySQL.Async.fetchAll('SELECT * FROM depository WHERE depositoryName = @depositoryId', { 
			['@depositoryId'] = id 
			}, function(result) 
			for k,v in pairs(result) do
				local peso = v.weight
				local slot = v.slots
				local label = v.name
				exports.ox_inventory:RegisterStash(stash.. '-'..Lang.inventory, Lang.inventory..'-'..stash, slot, peso, false)
			end
		end)
    end
end)

ESX.RegisterServerCallback('uniscript_deposit:checkContainer', function(source, cb, depositoryId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll('SELECT * FROM depository WHERE depositoryName = @depositoryId AND identifier = @identifier', { 
		['@depositoryId'] = depositoryId, 
		['@identifier'] = xPlayer.identifier 
		}, function(result) 
		if result[1] ~= nil then
			cb(true)
		else
			cb(false)
		end	
	end)
end)

ESX.RegisterServerCallback('uniscript_deposit:checkNameContainer', function(source, cb, depositoryId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll('SELECT * FROM depository WHERE depositoryName = @depositoryId', { 
		['@depositoryId'] = depositoryId
		}, function(result) 
			--if result[1] then
			--	print(result)
			
			for k,v in pairs(result) do
				local name = v.name
				print(name)
				cb(name)
			end
			--end
	end)
end)

ESX.RegisterServerCallback('uniscript_deposit:proprietà', function(source, cb, depositoryId)
	MySQL.Async.fetchAll('SELECT * FROM depository WHERE depositoryName = @depositoryId', { 
		['@depositoryId'] = depositoryId
		},function(result)
		if result[1] ~= nil then
			cb(result[1].sell)
		else
			cb(false)
		end	
	end)
end)

RegisterServerEvent('uniscript_deposit:startRentingContainer')
AddEventHandler('uniscript_deposit:startRentingContainer', function(depositoryId, depositoryName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll('SELECT * FROM depository WHERE depositoryName = @depositoryId AND identifier = @identifier', { 
		['@depositoryId'] = depositoryId, 
		['@identifier'] = xPlayer.identifier 
		}, function(result)
		if result[1] == nil then
			print(depositoryName)
			if xPlayer.getMoney() >= Config.InitialRentPrice then
				MySQL.Async.execute('INSERT INTO depository (identifier, depositoryName, name, sell) VALUES (@identifier, @depositoryId, @name, @sell)', {
					['@identifier'] = xPlayer.identifier,
					['@depositoryId'] = depositoryId,
					['@name'] = depositoryName,
					['@sell'] = 0
				})
				xPlayer.removeMoney(Config.InitialRentPrice)
				xPlayer.addInventoryItem('keyscont', 1, {depository = depositoryName, description = Lang.keys..'-'..depositoryName})
				TriggerClientEvent("uniscript_deposit:notify",Lang.deposit_rent)
			else
				TriggerClientEvent("uniscript_deposit:notify", src, Lang.no_money)
			end
		end
	end)
end)

RegisterServerEvent('uniscript_deposit:stopRentingContainer')
AddEventHandler('uniscript_deposit:stopRentingContainer', function(depositoryId, depositoryName) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll('SELECT * FROM depository WHERE depositoryName = @depositoryId AND identifier = @identifier', { ['@depositoryId'] = depositoryId, ['@identifier'] = xPlayer.identifier }, function(result)
		if result[1] ~= nil then
			MySQL.Async.execute('DELETE from depository WHERE depositoryName = @depositoryId AND identifier = @identifier', {
				['@depositoryId'] = depositoryId,
				['@identifier'] = xPlayer.identifier
			})
			TriggerClientEvent("uniscript_deposit:notify", src, Lang.sell_deposit)
		end
	end)
end)

function PayContainerRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM depository', {}, function(result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)
			if xPlayer then
				if xPlayer.getAccount('bank').money >= Config.DailyRentPrice then
					xPlayer.removeAccountMoney('bank', Config.DailyRentPrice)
					TriggerClientEvent("uniscript_deposit:notify",Lang.pay_rent)
				else
					TriggerClientEvent("uniscript_deposit:notify",Lang.no_bank_money)
					TriggerClientEvent("uniscript_deposit:notify",Lang.no_money_impound)
					MySQL.Sync.execute('UPDATE depository SET name = @name WHERE identifier = @identifier', { 
						['@name'] = "Sequestro "..result[i].identifier, 
						['@identifier'] = result[i].identifier 
					})
				end
			else
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', { ['@bank'] = Config.DailyRentPrice, ['@identifier'] = result[i].identifier })
			end
		end
	end)
end

TriggerEvent('cron:runAt', 5, 10, PayContainerRent)

RegisterServerEvent('uniscript_deposit:sequestro')
AddEventHandler('uniscript_deposit:sequestro', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll('SELECT * FROM depository WHERE depositoryName = @depositoryId', { 	
		['@depositoryId'] = id, 
	},function(result)
		for k,v in pairs(result) do
			local vecchioId = v.identifier
			local vecchioNome = v.name
			MySQL.Sync.execute('UPDATE depository SET oldidentifier = @oldidentifier WHERE depositoryName = @depositoryId', { 
				['@oldidentifier'] =  vecchioId,
				['@depositoryId'] = id 
			})
			MySQL.Sync.execute('UPDATE depository SET oldname = @oldname WHERE depositoryName = @depositoryId', { 
				['@oldname'] =  vecchioNome,
				['@depositoryId'] = id 
			})	
			MySQL.Sync.execute('UPDATE depository SET sell = @sell WHERE depositoryName = @depositoryId', { 
				['@sell'] =  2,
				['@depositoryId'] = id 
			})
		end
	end)

	MySQL.Sync.execute('UPDATE depository SET identifier = @identifier WHERE depositoryName = @depositoryId', { 
		['@identifier'] =  "char1:0101010101010101010101010101010101010101",
		['@depositoryId'] = id 
	})

	MySQL.Sync.execute('UPDATE depository SET name = @name WHERE depositoryName = @depositoryId', { 
		['@name'] = Lang.impound.." "..id,
		['@depositoryId'] = id 
	})
	xPlayer.addInventoryItem('keyscont', 1, {depository = Lang.impound..'-'..id, description = Lang.keys..'-'..id})
	TriggerClientEvent("uniscript_deposit:notify", src, Lang.deposit_seize)
end)

RegisterServerEvent('uniscript_deposit:reintegra')
AddEventHandler('uniscript_deposit:reintegra', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll('SELECT * FROM depository WHERE depositoryName = @depositoryId', { 	
		['@depositoryId'] = id, 
	},function(result)
		for k,v in pairs(result) do
			local ritornaId = v.oldidentifier
			local ritornaNome = v.oldname
			MySQL.Sync.execute('UPDATE depository SET identifier = @identifier WHERE depositoryName = @depositoryId', { 
				['@identifier'] =  ritornaId,
				['@depositoryId'] = id 
			})
			MySQL.Sync.execute('UPDATE depository SET name = @name WHERE depositoryName = @depositoryId', { 
				['@name'] =  ritornaNome,
				['@depositoryId'] = id 
			})	
			MySQL.Sync.execute('UPDATE depository SET sell = @sell WHERE depositoryName = @depositoryId', { 
				['@sell'] =  0,
				['@depositoryId'] = id 
			})
			TriggerClientEvent("uniscript_deposit:notify", src, Lang.unsealed_deposit)	
		end
	end)
end)

RegisterServerEvent('uniscript_deposit:rivendi')
AddEventHandler('uniscript_deposit:rivendi', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.execute('DELETE from depository WHERE depositoryName = @depositoryId', {
		['@depositoryId'] = id
	})
	TriggerClientEvent("uniscript_deposit:notify", src, Lang.deposit_relisted)
end)

RegisterServerEvent('uniscript_deposit:cambiaNome')
AddEventHandler('uniscript_deposit:cambiaNome', function(id, name)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Sync.execute('UPDATE depository SET name = @name WHERE depositoryName = @depositoryId', { 
		['@name'] = name, 
		['@depositoryId'] = id 
	})
	xPlayer.addInventoryItem('keyscont', 1, {depository = id, description = Lang.keys..'-'..name})
	TriggerClientEvent("uniscript_deposit:notify", src, Lang.lock_changed)
end)


RegisterServerEvent('uniscript_deposit:duplica_chiave')
AddEventHandler('uniscript_deposit:duplica_chiave', function(name)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.getAccount('bank').money >= Config.DupliKey then
		xPlayer.removeAccountMoney('bank', Config.DupliKey)
		xPlayer.addInventoryItem('keyscont', 1, {depository = name, description = Lang.keys..'-'..name})
		TriggerClientEvent("uniscript_deposit:notify",Lang.key_duplicate)
	else
		TriggerClientEvent("uniscript_deposit:notify", src, Lang.no_money)
	end
end)

RegisterServerEvent('uniscript_deposit:deleteitem')
AddEventHandler('uniscript_deposit:deleteitem', function(item)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem(item, 1)
end)


