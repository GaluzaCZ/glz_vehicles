-- Global vars
ESX = exports.es_extended:getSharedObject()
connectedJobs = {}
vehicles = {
	source = {},
	plate = {},
	job = {}
}

-- ESX events
RegisterNetEvent('esx:setJob', function(source, job, lastJob)
	for i, user in ipairs(connectedJobs[lastJob.name]) do
		if user == source then
			table.remove(connectedJobs[lastJob.name], i)
			break
		end
	end

	if not connectedJobs[job.name] then
		connectedJobs[job.name] = {}
	end

	table.insert(connectedJobs[job.name], source)

	local xPlayer = ESX.GetPlayerFromId(source)
	if not vehicles.job[job.name] then
		result = LoadVehiclesFromDatabase(xPlayer, false, true)
		for i, vehicle in ipairs(result) do
			if Config.SetVehicleStoredOnServerStart then
				vehicle.stored = 1
			end

			InsertVehicle("job", vehicle, xPlayer)
		end
	end
	CheckJobVehicles(lastJob.name)
end)

RegisterNetEvent('esx:playerLoaded', function(source, xPlayer)
	if not connectedJobs[xPlayer.job.name] then
		connectedJobs[xPlayer.job.name] = {}
	end
	table.insert(connectedJobs[xPlayer.job.name], source)

	InitPlayer(source)
end)

RegisterNetEvent('esx:playerDropped', function(source)
	local lastJob = nil
	for job, users in pairs(connectedJobs) do
		for i, user in ipairs(users) do
			if user == source then
				lastJob = job
				table.remove(connectedJobs[job], i)
				break -- break loops
			end
		end
	end

	PlayerDropped(source)
	CheckJobVehicles(lastJob)
end)

InitPlayer = function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result
	local job

	-- checks if some vehicles are loaded
	if vehicles.job[xPlayer.job.name] then
		job = true
		result = LoadVehiclesFromDatabase(xPlayer, true, false)
	else
		result = LoadVehiclesFromDatabase(xPlayer, true, true)
	end

	for i, vehicle in ipairs(result) do
		if Config.SetVehicleStoredOnServerStart then
			vehicle.stored = 1
		end

		if vehicle.owner == xPlayer.identifier then -- If is owner of this car add the vehicle to vehicles.identifier

			InsertVehicle("source", vehicle, xPlayer)
		end

		if not job and vehicle.job and vehicle.job == xPlayer.job.name then

			InsertVehicle("job", vehicle, xPlayer)
		end
	end
end

-- Insert function table.insert()
InsertVehicle = function(where, vehicle, xPlayer, override)
	if where == "source" then
		if not vehicles.source[xPlayer.source] then
			vehicles.source[xPlayer.source] = {}
		end

		table.insert(vehicles.source[xPlayer.source], vehicle.plate)
	elseif where == "job" then
		if not vehicles.job[xPlayer.job.name] then
			vehicles.job[xPlayer.job.name] = {}
		end

		table.insert(vehicles.job[xPlayer.job.name], vehicle.plate)
	end

	if not vehicles.plate[vehicle.plate] or override then
		vehicles.plate[vehicle.plate] = vehicle
	end
end

LoadVehiclesFromDatabase = function(xPlayer, loadPlayer, loadJob)
	local result
	if loadPlayer and loadJob then
		result = MySQL.query.await('SELECT * FROM owned_vehicles WHERE owner = ? OR job = ?', {xPlayer.identifier, xPlayer.job.name})
	elseif loadPlayer and not loadJob then
		result = MySQL.query.await('SELECT * FROM owned_vehicles WHERE owner = ?', {xPlayer.identifier})
	elseif not loadPlayer and loadJob then
		result = MySQL.query.await('SELECT * FROM owned_vehicles WHERE job = ?', {xPlayer.job.name})
	end

	for i, v in ipairs(result) do
		result[i].vehicle = json.decode(v.vehicle)
	end

	return result
end

SaveNewVehicleToDatabase = function(vehicle)
	MySQL.insert.await('INSERT INTO owned_vehicles (owner, plate, vehicle, vehiclename) VALUES (?, ?, ?, ?) ', {vehicle.owner, vehicle.plate, json.encode(vehicle.vehicle), vehicle.vehiclename})
end

UpdateVehicleInDatabase = function(vehicle)
	MySQL.update.await('UPDATE owned_vehicles SET vehicle = ?, job = ?, stored = ?, garage_name = ?, vehiclename = ? WHERE plate = ? ', {json.encode(vehicle.vehicle), vehicle.job, vehicle.stored, vehicle.garage_name, vehicle.vehiclename, vehicle.plate})
end

CheckJobVehicles = function (job)
	if #connectedJobs[job] < 1 and vehicles.job[job] then
		-- to-do: add removing vehicles from vehicles.plate for save energy
		table.remove(vehicles.job[job])
	end
end

PlayerDropped = function(source)
	if vehicles.source[source] then
		-- to-do: add removing vehicles from vehicles.plate for save energy
		table.remove(vehicles.source[source])
	end
end