ESX.RegisterServerCallback("glz_veh:getPlayerVehicles", function(source, cb)
	local Vehicles = {}
	if vehicles.source[source] then
		for i, v in ipairs(vehicles.source[source]) do
			table.insert(Vehicles, vehicles.plate[v])
		end
	end
	cb(Vehicles)
end)

ESX.RegisterServerCallback("glz_veh:getPlayerJobVehicles", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Vehicles = {}
	if vehicles.job[xPlayer.job.name] then
		for i, v in ipairs(vehicles.job[xPlayer.job.name]) do
			table.insert(Vehicles, vehicles.plate[v])
		end
	end
	cb(Vehicles)
end)

ESX.RegisterServerCallback("glz_veh:getJobVehicles", function(source, cb, job)
	local Vehicles = {}
	if vehicles.job[job] then
		for i, v in ipairs(vehicles.job[job]) do
			table.insert(Vehicles, vehicles.plate[v])
		end
	end
	cb(Vehicles)
end)

ESX.RegisterServerCallback("glz_veh:getVehicleByPlate", function(source, cb, plate)
	cb(vehicles.plate[plate])
end)

ESX.RegisterServerCallback("glz_veh:payForImpound", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.Impounds.Cost then
		xPlayer.removeMoney(Config.Impounds.Cost)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("glz_veh:hasPlayerVehicleByPlate", function(source, cb, plate)
	if vehicles.source[source] then
		for i, v in ipairs(vehicles.source[source]) do
			if v == plate then
				cb(true)
				return
			end
		end
	end
	cb(false)
end)

RegisterNetEvent('glz_veh:setVehicleStatus', function(vehiclePlate, status)
	if vehicles.plate[vehiclePlate] then
		vehicles.plate[vehiclePlate].stored = tonumber(status)
		if not Config.SetVehicleStoredOnServerStart then
			UpdateVehicleInDatabase(vehicles.plate[vehiclePlate])
		end
	end
end)

RegisterNetEvent('glz_veh:setVehicleSpawn', function(vehiclePlate)
	if vehicles.plate[vehiclePlate] then
		local Vehicle = vehicles.plate[vehiclePlate]
		Vehicle.stored = 0
		Vehicle.garage_name = nil
		vehicles.plate[vehiclePlate] = Vehicle
		if not Config.SetVehicleStoredOnServerStart then
			UpdateVehicleInDatabase(vehicles.plate[vehiclePlate])
		end
	end
end)

RegisterNetEvent('glz_veh:vehicleDespawn', function(vehiclePlate, vehicleProps, garage)
	if vehicles.plate[vehiclePlate] then
		local Vehicle = vehicles.plate[vehiclePlate]
		Vehicle.vehicle = vehicleProps
		Vehicle.stored = 1
		Vehicle.garage_name = garage or nil
		vehicles.plate[vehiclePlate] = Vehicle
		UpdateVehicleInDatabase(Vehicle)
	end
end)

RegisterNetEvent('glz_veh:setVehicle', function(vehicle)
	if vehicles.plate[vehicle.plate] then
		vehicles.plate[vehicle.plate] = vehicle
		UpdateVehicleInDatabase(vehicle)
	end
end)

RegisterNetEvent('glz_veh:setVehiclePropsOwned', function(vehicleProps, plate, vehName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local vehicle = {
		owner = xPlayer.identifier,
		plate = plate,
		vehicle = vehicleProps,
		vehiclename = vehName,
		stored = 0
	}

	InsertVehicle("source", vehicle, xPlayer)

    SaveNewVehicleToDatabase(vehicle)
end)