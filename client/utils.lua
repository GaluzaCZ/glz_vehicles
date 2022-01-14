function SetVehicleProperties(vehicle, vehicleProps)
	ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
	if vehicleProps["windows"] then
		for windowId = 1, 9, 1 do
			if vehicleProps["windows"][windowId] == false then
				SmashVehicleWindow(vehicle, windowId)
			end
		end
	end
	if vehicleProps["tyres"] then
		for tyreId = 1, 7, 1 do
			if vehicleProps["tyres"][tyreId] ~= false then
				SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
			end
		end
	end
	if vehicleProps["doors"] then
		for doorId = 0, 5, 1 do
			if vehicleProps["doors"][doorId] ~= false then
				SetVehicleDoorBroken(vehicle, doorId - 1, true)
			end
		end
	end
	if vehicleProps.vehicleHeadLight then SetVehicleHeadlightsColour(vehicle, vehicleProps.vehicleHeadLight) end
end

function GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        vehicleProps["tyres"] = {}
        vehicleProps["windows"] = {}
        vehicleProps["doors"] = {}
        for id = 1, 7,1 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)

            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId

                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
        end
        for id = 1, 9,1 do
            local windowId = IsVehicleWindowIntact(vehicle, id)

            if windowId ~= nil then
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = windowId
            else
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = true
            end
        end
        for id = 0, 5,1 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)

            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end
		vehicleProps["vehicleHeadLight"]  = GetVehicleHeadlightsColour(vehicle)
        return vehicleProps
	else
		return nil
    end
end