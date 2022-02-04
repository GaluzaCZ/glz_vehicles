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

ESX.RegisterServerCallback("glz_veh:hasPlayerVehicleByJob", function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if vehicles.job[xPlayer.getJob().name] then
		for i, v in ipairs(vehicles.job[xPlayer.getJob().name]) do
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
	if vehicles.plate[vehiclePlate] and vehiclePlate and vehicleProps then
		vehicles.plate[vehiclePlate].vehicle = vehicleProps
		vehicles.plate[vehiclePlate].stored = 1
		vehicles.plate[vehiclePlate].garage_name = garage or nil
		UpdateVehicleInDatabase(vehicles.plate[vehiclePlate])
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

RegisterNetEvent('glz_veh:switchVehicleJob', function(plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if vehicles.plate[plate] and vehicles.plate[plate].owner == xPlayer.identifier then
		if vehicles.plate[plate].job == nil then
			vehicles.plate[plate].job = xPlayer.getJob().name
			InsertVehicle("job", vehicles.plate[plate], xPlayer)
			UpdateVehicleInDatabase(vehicles.plate[plate])
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = _U("set_vehicle_job", xPlayer.getJob().label),
				timeout = 3500,
				type = "success"
			})
		elseif vehicles.plate[plate].job ~= nil then
			for i, v in ipairs(vehicles.job[vehicles.plate[plate].job]) do
				if v == plate then
					table.remove(vehicles.job[vehicles.plate[plate].job], i)
				end
			end
			vehicles.plate[plate].job = nil
			UpdateVehicleInDatabase(vehicles.plate[plate])
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = _U("remove_vehicle_job"),
				timeout = 3500,
				type = "info"
			})
		end
	end
end)