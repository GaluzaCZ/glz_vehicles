ESX.RegisterServerCallback("glz_veh:getPlayerVehicles", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(vehicles.identifier[xPlayer.identifier])
end)

RegisterNetEvent('glz_veh:setVehiclePropsOwned', function(vehicleProps, plate, vehName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local vehicle = {
		owner = xPlayer.identifier,
		plate = plate,
		vehicle = vehicleProps,
		vehiclename = vehName
	}

	InsertVehicle("identifier", vehicle, xPlayer)

    SaveVehicleToDatabase(vehicle)
end)