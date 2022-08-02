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
	if Config.Impounds.Cost == false or Config.Impounds.Cost <= 0 then return cb(true) end
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

RegisterNetEvent('glz_veh:vehicleSpawn', function(plate)
	VehicleSpawn(plate)
end)

RegisterNetEvent('glz_veh:vehicleDespawn', function(plate, vehicleProps, garage)
	VehicleDespawn(plate, vehicleProps, garage)
end)

RegisterNetEvent('glz_veh:deleteVehicle', function(plate)
	local _source = source
	if vehicles.plate.is(plate) then
		local xPlayer = ESX.GetPlayerFromId(_source)
		local vehicle = vehicles.plate.get(plate)
		if vehicle.owner == xPlayer.identifier then
			DeleteVehiclePlate(plate)
		end
	end
end)

RegisterNetEvent('glz_veh:setVehiclePropsOwned', function(vehicleProps, plate, vehName)
	SetVehiclePropsOwned(source, vehicleProps, plate, vehName)
end)

RegisterNetEvent('glz_veh:switchVehicleJob', function(plate)
	SwitchVehicleJob(source, plate)
end)