ESX.RegisterServerCallback("glz_veh:getPlayerVehicles", function(source, cb)
	cb(vehicles.source.get(source))
end)

ESX.RegisterServerCallback("glz_veh:getPlayerJobVehicles", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(vehicles.job.get(xPlayer.job.name))
end)

ESX.RegisterServerCallback("glz_veh:getJobVehicles", function(source, cb, job)
	cb(vehicles.job.get(job))
end)

ESX.RegisterServerCallback("glz_veh:getVehicleByPlate", function(source, cb, plate)
	cb(vehicles.plate.get(plate))
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
	cb(vehicles.source.has(source, plate))
end)

ESX.RegisterServerCallback("glz_veh:hasPlayerVehicleByJob", function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(vehicles.job.has(xPlayer.job.name, plate))
end)

RegisterNetEvent('glz_veh:setVehicleStatus', function(plate, status)
	local vehicle = vehicles.plate.get(plate)
	if vehicle then
		vehicle.stored = tonumber(status)
		vehicles.plate.set(vehicle)
		if not Config.SetVehicleStoredOnServerStart then
			UpdateVehicleInDatabase(vehicles.plate[plate])
		end
	end
end)

RegisterNetEvent('glz_veh:setVehicleSpawn', function(plate)
	local vehicle = vehicles.plate.get(plate)
	if vehicle then
		vehicle.stored = 0
		vehicle.garage_name = nil
		vehicles.plate.set(vehicle)
		if not Config.SetVehicleStoredOnServerStart then
			UpdateVehicleInDatabase(vehicles.plate[vehiclePlate])
		end
	end
end)

RegisterNetEvent('glz_veh:vehicleDespawn', function(plate, vehicleProps, garage)
	local vehicle = vehicles.plate.get(plate)
	if vehicle and vehicleProps then
		vehicle.vehicle = vehicleProps
		vehicle.stored = 1
		vehicle.garage_name = garage or nil
		vehicles.plate.set(vehicle)
		UpdateVehicleInDatabase(vehicle)
	end
end)

RegisterNetEvent('glz_veh:setVehicle', function(vehicle)
	if vehicles.plate.is(vehicle.plate) then
		vehicles.plate.set(vehicle)
		UpdateVehicleInDatabase(vehicle)
	end
end)

RegisterNetEvent('glz_veh:deleteVehicle', function(plate, cb)
	local _source = source
	if vehicles.plate.is(plate) then
		local xPlayer = ESX.GetPlayerFromId(_source)
		local vehicle = vehicles.plate.get(plate)
		if vehicle.owner == xPlayer.identifier then
			vehicles.source.remove(_source, vehicle.plate)
			if vehicle.job then
				vehicles.job.remove(xPlayer.job.name, vehicle.plate)
			end

			vehicles.plate.remove(vehicle.plate)
			RemoveVehicleFromDatabase(vehicle.plate)
			if cb then cb(true) end
		else
			if cb then cb(false) end
		end
	else
		if cb then cb(false) end
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

	vehicles.source.add(_source, plate)
	vehicles.plate.add(vehicle)

	SaveNewVehicleToDatabase(vehicle)
end)

RegisterNetEvent('glz_veh:switchVehicleJob', function(plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicle = vehicles.plate.get(plate)

	if vehicle and vehicle.owner == xPlayer.identifier then
		if vehicle.job == nil then
			vehicle.job = xPlayer.job.name
			vehicles.job.add(vehicle.job, plate)
			vehicles.plate.set(vehicle)
			UpdateVehicleInDatabase(vehicle)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = _U("set_vehicle_job", xPlayer.getJob().label),
				timeout = 3500,
				type = "success"
			})
		elseif vehicle.job ~= nil then
			vehicle.job = nil
			vehicles.job.remove(vehicle.job, plate)
			vehicles.plate.set(vehicle)
			UpdateVehicleInDatabase(vehicle)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = _U("remove_vehicle_job"),
				timeout = 3500,
				type = "info"
			})
		end
	end
end)