-- ESX events
AddEventHandler('esx:setJob', function(source, job)
	if not vehicles.job.is(job.name) then
		local xPlayer = ESX.GetPlayerFromId(source)
		local result = LoadVehiclesFromDatabase(xPlayer, false, true)
		for i = 1, #result do
			local vehicle = result[i]
			if Config.SetVehicleStoredOnServerStart then
				vehicle.stored = 1
			end

			vehicles.plate.add(vehicle)
			vehicles.job.add(xPlayer.job.name, vehicle.plate)
		end
	end
	vehicles.job.removeUnused()
	vehicles.plate.removeUnused()
end)

AddEventHandler('esx:playerLogout', function(source)
	vehicles.source.remove(source)
	vehicles.plate.removeUnused()
end)

--[[ Initialize ]]
InitPlayer = function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = false
	local result

	-- checks if job is already loaded
	if vehicles.job.is(xPlayer.job.name) then
		job = true
		result = LoadVehiclesFromDatabase(xPlayer, true, false)
	else
		result = LoadVehiclesFromDatabase(xPlayer, true, true)
	end

	for i = 1, #result do
		local vehicle = result[i]
		if Config.SetVehicleStoredOnServerStart then
			vehicle.stored = 1
		end

		vehicles.plate.add(vehicle)

		if vehicle.owner == xPlayer.identifier then
			vehicles.source.add(xPlayer.source, vehicle.plate)
		end

		if not job and vehicle.job and vehicle.job == xPlayer.job.name then
			vehicles.job.add(xPlayer.job.name, vehicle.plate)
		end
	end
end

RegisterNetEvent('glz_veh:init', function()
	InitPlayer(source)
end)

LoadVehiclesFromDatabase = function(xPlayer, loadPlayer, loadJob)
	local result
	if loadPlayer and loadJob then
		result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = ? OR job = ?', {xPlayer.identifier, xPlayer.job.name})
	elseif loadPlayer and not loadJob then
		result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = ?', {xPlayer.identifier})
	elseif not loadPlayer and loadJob then
		result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE job = ?', {xPlayer.job.name})
	end

	for i = 1, #result do
		result[i].vehicle = json.decode(result[i].vehicle)
	end

	return result
end

SaveNewVehicleToDatabase = function(vehicle)
	MySQL.Async.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, job, stored, garage_name, vehiclename) VALUES (?, ?, ?, ?, ?, ?, ?) ', {vehicle.owner, vehicle.plate, json.encode(vehicle.vehicle), vehicle.job, vehicle.stored, vehicle.garage_name, vehicle.vehiclename})
end

UpdateVehicleInDatabase = function(vehicle)
	MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = ?, job = ?, stored = ?, garage_name = ?, vehiclename = ? WHERE plate = ? ', {json.encode(vehicle.vehicle), vehicle.job, vehicle.stored, vehicle.garage_name, vehicle.vehiclename, vehicle.plate})
end

RemoveVehicleFromDatabase = function(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = ?', {plate})
end

CheckVehicleInDatabase = function(plate)
	return MySQL.Sync.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate = ?', {plate})
end
