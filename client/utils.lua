function SetVehicleProperties(vehicle, vehicleProps)
	ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
	if vehicleProps.windows then
		for windowId = 0, 7, 1 do
			if vehicleProps.windows[windowId + 1] == true then
				SmashVehicleWindow(vehicle, windowId)
			end
		end
	end
	if vehicleProps.tyres then
        for k, v in pairs(vehicleProps.tyres) do
            SetTyreHealth(vehicle, tonumber(k), ESX.Math.Round(tonumber(v), 1))
        end
	end
	if vehicleProps.doors then
		for doorId = 0, 5, 1 do
			if vehicleProps.doors[doorId + 1] == true then
				SetVehicleDoorBroken(vehicle, doorId, true)
			end
		end
	end
	if vehicleProps.vehicleHeadLight then SetVehicleHeadlightsColour(vehicle, vehicleProps.vehicleHeadLight) end
end

function GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        vehicleProps.tyres = {}
        vehicleProps.windows = {}
        vehicleProps.doors = {}
        for id = 0, 7,1 do
            vehicleProps.tyres[id] = GetTyreHealth(vehicle, id)
        end

        for id = 0, 7,1 do
            vehicleProps.windows[id + 1] = not IsVehicleWindowIntact(vehicle, id)
        end

        for id = 0, 5,1 do
            vehicleProps.doors[id + 1] = IsVehicleDoorDamaged(vehicle, id) == 1
        end
		vehicleProps.vehicleHeadLight = GetVehicleHeadlightsColour(vehicle)
        return vehicleProps
	else
		return nil
    end
end