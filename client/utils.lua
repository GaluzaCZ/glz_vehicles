OpenMenu = function(name, vehicles, cb, cb2)
	local elements = {}
	if not vehicles[1] then
		elements[1] = {label = '<span style="color:Red">'.._U("no_cars")..'</span>', value=nil}
	else
		elements = vehicles
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehiclesMenu', {
		title =  name,
		elements = elements,
		align = 'top'
	},
	cb,
	cb2 or function(data, menu)
		menu.close()
	end)
end
exports("OpenMenu", OpenMenu)

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
						TriggerServerEvent("glz_veh:setVehicleSpawn", data.current.value.plate)
						SetVehicleProperties(callback_vehicle, data.current.value.vehicle)
						SetPedIntoVehicle(PPed, callback_vehicle, -1)
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
						TriggerServerEvent("glz_veh:setVehicleSpawn", data.current.value.plate)
						SetVehicleProperties(callback_vehicle, data.current.value.vehicle)
						SetPedIntoVehicle(PPed, callback_vehicle, -1)
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

SetVehicleProperties = function(vehicle, vehicleProps)
	ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
	if vehicleProps.tyres then
		for id = 0, 7 do
			if vehicleProps.tyres[id + 1] then
				SetTyreHealth(vehicle, id, ESX.Math.Round(tonumber(vehicleProps.tyres[id + 1]), 1))
			end
		end
	end
	if vehicleProps.windows then
		for id = 0, 7 do
			if vehicleProps.windows[id + 1] == true then
				SmashVehicleWindow(vehicle, id)
			end
		end
	end
	if vehicleProps.doors then
		for id = 0, 5 do
			if vehicleProps.doors[id + 1] == true then
				SetVehicleDoorBroken(vehicle, id, true)
			end
		end
	end
	if vehicleProps.vehicleHeadLight then SetVehicleHeadlightsColour(vehicle, vehicleProps.vehicleHeadLight) end
end
exports("SetVehicleProperties", SetVehicleProperties)

GetVehicleProperties = function(vehicle)
	if DoesEntityExist(vehicle) then
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		vehicleProps.tyres = {}
		vehicleProps.windows = {}
		vehicleProps.doors = {}
		for id = 0, 7 do
			vehicleProps.tyres[id + 1] = GetTyreHealth(vehicle, id)
		end

		for id = 0, 7 do
			vehicleProps.windows[id + 1] = not IsVehicleWindowIntact(vehicle, id)
		end

		for id = 0, 5 do
			vehicleProps.doors[id + 1] = IsVehicleDoorDamaged(vehicle, id) == 1
		end
		vehicleProps.vehicleHeadLight = GetVehicleHeadlightsColour(vehicle)
		return vehicleProps
	else
		return nil
	end
end
exports("GetVehicleProperties", GetVehicleProperties)