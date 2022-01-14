ESX.RegisterServerCallback("glz_veh:getPlayerVehicles", function(source, cb)
	local Vehicles = {}
	for i, v in ipairs(vehicles.source[source]) do
		table.insert(Vehicles, vehicles.plate[v])
	end
	cb(Vehicles)
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

RegisterNetEvent('glz_veh:setVehicleOut', function(vehiclePlate)
	vehicles.plate[vehiclePlate].stored = 0
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