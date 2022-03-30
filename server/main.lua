-- Global vars
ESX = exports.es_extended:getSharedObject()

-- ESX events
AddEventHandler('esx:setJob', function(source, job, lastJob)
	if not vehicles.job.is(job.name) then
		local xPlayer = ESX.GetPlayerFromId(source)
		local result = LoadVehiclesFromDatabase(xPlayer, false, true)
		for i, vehicle in ipairs(result) do
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

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	InitPlayer(source)
end)

AddEventHandler('esx:playerLogout', function(source)
	vehicles.source.remove(source)
	vehicles.plate.removeUnused()
end)

InitPlayer = function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(source)
		Wait(1000)
	end
	local job = false
	local result

	-- checks if job is already loaded
	if vehicles.job.is(xPlayer.job.name) then
		job = true
		result = LoadVehiclesFromDatabase(xPlayer, true, false)
	else
		result = LoadVehiclesFromDatabase(xPlayer, true, true)
	end

	for i, vehicle in ipairs(result) do
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

-- Insert function table.insert()
InsertVehicle = function(where, vehicle, xPlayer, override)
	if where == "source" then
		vehicles.source.add(xPlayer.source, vehicle.plate)
	elseif where == "job" then
		vehicles.job.add(xPlayer.job.name, vehicle.plate)
	end

	if not vehicles.plate.is(vehicle.plate) or override then
		vehicles.plate.add(vehicle)
	end
end

LoadVehiclesFromDatabase = function(xPlayer, loadPlayer, loadJob)
	local result
	if loadPlayer and loadJob then
		result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = ? OR job = ?', {xPlayer.identifier, xPlayer.job.name})
	elseif loadPlayer and not loadJob then
		result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = ?', {xPlayer.identifier})
	elseif not loadPlayer and loadJob then
		result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE job = ?', {xPlayer.job.name})
	end

	for i, v in ipairs(result) do
		result[i].vehicle = json.decode(v.vehicle)
	end

	return result
end

SaveNewVehicleToDatabase = function(vehicle)
	MySQL.Async.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, vehiclename) VALUES (?, ?, ?, ?) ', {vehicle.owner, vehicle.plate, json.encode(vehicle.vehicle), vehicle.vehiclename})
end

UpdateVehicleInDatabase = function(vehicle)
	MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = ?, job = ?, stored = ?, garage_name = ?, vehiclename = ? WHERE plate = ? ', {json.encode(vehicle.vehicle), vehicle.job, vehicle.stored, vehicle.garage_name, vehicle.vehiclename, vehicle.plate})
end

RemoveVehicleFromDatabase = function(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = ?', {plate})
end

RegisterNetEvent('glz_veh:restart', function()
	InitPlayer(source)
end)