OpenGarageMenu = function(garageName, pos, heading, type, cb)
	ESX.TriggerServerCallback("glz_veh:getPlayerVehicles", function(vehicles)
		local elements = {}
		type = type or "car"
		if vehicles[1] then
			for i = 1, #vehicles do
				local v = vehicles[i]
				if v.stored == 1 and v.garage_name == garageName and v.type == type then
					elements[#elements+1] = {label = '<span style="color:Green">'..v.vehiclename..'</span> - <span style="color:GoldenRod">'..v.plate..'</span>', value=v}
				end
			end
		end

		OpenMenu("Garage", elements, function(data, menu)
			if data.current.value then
				if ESX.Game.IsSpawnPointClear(pos, 3.0) then
					ESX.Game.SpawnVehicle(data.current.value.vehicle.model, pos, heading, function(callback_vehicle)
						TriggerServerEvent("glz_veh:vehicleSpawn", data.current.value.plate)
						SetVehicleProperties(callback_vehicle, data.current.value.vehicle)
						SetPedIntoVehicle(ESX.PlayerData.ped, callback_vehicle, -1)
						if cb then
							cb()
						end
					end)
					menu.close()
				else
					pNotify(_U("spawnpoint_not_clear"), "warning")
				end
			end
		end)
	end)
end
exports("OpenGarageMenu", OpenGarageMenu)

OpenJobGarageMenu = function(job, garageName, pos, heading, type, cb)
	ESX.TriggerServerCallback("glz_veh:getJobVehicles", function(vehicles)
		local elements = {}
		type = type or "car"
		if vehicles[1] then
			for i = 1, #vehicles do
				local v = vehicles[i]
				if v.stored == 1 and v.garage_name == garageName and v.job == job and v.type == type then
					elements[#elements+1] = {label = '<span style="color:Green">'..v.vehiclename..'</span> - <span style="color:GoldenRod">'..v.plate..'</span>', value=v}
				end
			end
		end

		OpenMenu("Garage", elements, function(data, menu)
			if data.current.value then
				if ESX.Game.IsSpawnPointClear(pos, 3.0) then
					ESX.Game.SpawnVehicle(data.current.value.vehicle.model, pos, heading, function(callback_vehicle)
						TriggerServerEvent("glz_veh:vehicleSpawn", data.current.value.plate)
						SetVehicleProperties(callback_vehicle, data.current.value.vehicle)
						SetPedIntoVehicle(ESX.PlayerData.ped, callback_vehicle, -1)
					end)
					menu.close()
					if cb then
						cb()
					end
				else
					pNotify(_U("spawnpoint_not_clear"), "warning")
				end
			end
		end)
	end, job)
end
exports("OpenJobGarageMenu", OpenJobGarageMenu)

StoreVehicle = function(vehicle, garageName, cb)
	local vehicleProps = GetVehicleProperties(vehicle)
	ESX.TriggerServerCallback("glz_veh:hasPlayerVehicleByPlate", function(has)
		if has then
			ESX.Game.DeleteVehicle(vehicle)
			TriggerServerEvent("glz_veh:vehicleDespawn", vehicleProps.plate, vehicleProps, garageName)
			if cb then
				cb()
			end
		else
			pNotify(_U("not_owned"), "error")
		end
	end, vehicleProps.plate)
end
exports("StoreVehicle", StoreVehicle)

StoreJobVehicle = function(vehicle, job, garageName, cb)
	local vehicleProps = GetVehicleProperties(vehicle)
	ESX.TriggerServerCallback("glz_veh:getVehicleByPlate", function(Vehicle)
		if Vehicle and Vehicle.job == job then
			ESX.Game.DeleteVehicle(vehicle)
			TriggerServerEvent("glz_veh:vehicleDespawn", vehicleProps.plate, vehicleProps, garageName)
			if cb then
				cb()
			end
		else
			pNotify(_U("cannot_store"), "error")
		end
	end, vehicleProps.plate)
end
exports("StoreJobVehicle", StoreJobVehicle)