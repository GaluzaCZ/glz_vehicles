OpenMenu = function(name, vehicles, cb)
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
	}, cb,
	function(data, menu)
		menu.close()
	end)
end
exports("OpenMenu", OpenMenu)

SetVehicleProperties = function(vehicle, vehicleProps)
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
exports("SetVehicleProperties", SetVehicleProperties)

GetVehicleProperties = function(vehicle)
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
exports("GetVehicleProperties", GetVehicleProperties)