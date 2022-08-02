VehicleSpawn = function(plate)
	local vehicle = vehicles.plate.get(plate)
	if vehicle then
		vehicle.stored = 0
		vehicle.garage_name = nil
		vehicles.plate.set(vehicle)
		if not Config.SetVehicleStoredOnServerStart then
			UpdateVehicleInDatabase(vehicles.plate[vehiclePlate])
		end
	end
end
exports("VehicleSpawn", VehicleSpawn)

VehicleDespawn = function(plate, vehicleProps, garage)
	local vehicle = vehicles.plate.get(plate)
	if vehicle and vehicleProps then
		vehicle.vehicle = vehicleProps
		vehicle.stored = 1
		vehicle.garage_name = garage or nil
		vehicles.plate.set(vehicle)
		UpdateVehicleInDatabase(vehicle)
	end
end
exports("VehicleDespawn", VehicleDespawn)

SetVehicle = function(vehicle)
	if vehicles.plate.is(vehicle.plate) then
		vehicles.plate.set(vehicle)
		UpdateVehicleInDatabase(vehicle)
	end
end
exports("SetVehicle", SetVehicle)

_CreateVehicle = function(vehicle)
	if not vehicles.plate.is(vehicle.plate) then
		vehicles.plate.add(vehicle)
		local xPlayer = ESX.GetPlayerFromIdentifier(vehicle.owner)
		if xPlayer then
			vehicles.source.add(xPlayer.source, vehicle.plate)
		end
		if #ESX.GetExtendedPlayers("job", vehicle.job) > 0 then
			vehicles.job.add(vehicle.job, vehicle.plate)
		end
		SaveNewVehicleToDatabase(vehicle)
	end
end
exports("CreateVehicle", _CreateVehicle)

DeleteVehiclePlate = function(source, plate)
	if not source and not plate then return false end
	if vehicles.plate.is(plate) then
		local vehicle = vehicles.plate.get(plate)
		vehicles.source.remove(source, vehicle.plate)
		if vehicle.job then
			vehicles.job.remove(vehicle.job, vehicle.plate)
		end

		vehicles.plate.remove(vehicle.plate)
		RemoveVehicleFromDatabase(vehicle.plate)
		return true
	else
		return false
	end
end
exports("DeleteVehiclePlate", DeleteVehiclePlate)

SetVehiclePropsOwned = function(source, vehicleProps, plate, vehName)
	if not source and not vehicleProps and not plate and not vehName then return false end
	local xPlayer = ESX.GetPlayerFromId(source)

	local vehicle = {
		owner = xPlayer.identifier,
		plate = plate,
		vehicle = vehicleProps,
		vehiclename = vehName,
		stored = 0
	}

	vehicles.source.add(source, plate)
	vehicles.plate.add(vehicle)

	SaveNewVehicleToDatabase(vehicle)
	return vehicles.plate.get(plate)
end
exports("SetVehiclePropsOwned", SetVehiclePropsOwned)

SwitchVehicleJob = function(source, plate)
	if not source and not plate then return false end
	local xPlayer = ESX.GetPlayerFromId(source)
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
			return true
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
			return true
		end
	end
end
exports("SwitchVehicleJob", SwitchVehicleJob)

GeneratePlate = function(template)
	if not template then template = Config.PlateTemplate or "NNN LLL" end
	template = ESX.Math.Trim(template)
	if string.len(template) > 8 then
		error("Plate" .. template .. " can't be longer than 8 chars. Replacing with 'NNN LLL'")
		template = "NNN LLL"
	end

	local plate = ""
	for i = 1, string.len(template) do
		local char = string.byte(template, i)
		if char == 78 or char == 110 then -- N or n
			plate = plate .. math.random(0,9)
		elseif char == 76 or char == 108 then -- L or l
			plate = plate .. string.char(math.random(65,90))
		else
			plate = plate .. string.char(32)
		end
	end

	if CheckVehicleInDatabase(plate) then
		return GeneratePlate(template)
	else
		return plate
	end
end
exports("GeneratePlate", GeneratePlate)
