function pNotify(text,type,time)
	local options = {
	  text = text,
	  timeout = time or 2000,
	  type = type
	}

	exports.pNotify:SendNotification(options)
end

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
	if Config.LegacyFuel and vehicleProps.fuelLevel then exports.LegacyFuel:SetFuel(vehicle, vehicleProps.fuelLevel) end
end
exports("SetVehicleProperties", SetVehicleProperties)

GetVehicleProperties = function(vehicle)
	if not DoesEntityExist(vehicle) then return nil end

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

	if Config.LegacyFuel then vehicleProps.fuelLevel = exports.LegacyFuel:GetFuel(vehicle) end
	return vehicleProps
end
exports("GetVehicleProperties", GetVehicleProperties)

ToggleEngine = function()
	if IsPedInAnyVehicle(ESX.PlayerData.ped, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(ESX.PlayerData.ped), -1) == ESX.PlayerData.ped then
		local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped,false)
		SetVehicleEngineOn(vehicle, GetIsVehicleEngineRunning(vehicle) ~= 1, false, true)
	end
end
exports("ToggleEngine", ToggleEngine)

ToggleDoor = function(doorId)
	if IsPedInAnyVehicle(ESX.PlayerData.ped, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(ESX.PlayerData.ped), -1) == ESX.PlayerData.ped then
		local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped,false)
		if GetVehicleDoorAngleRatio(vehicle, tonumber(doorId)) > 0.1 then
			SetVehicleDoorShut(vehicle, tonumber(doorId), false)
		else
			SetVehicleDoorOpen(vehicle, tonumber(doorId), false, false)
		end
	end
end
exports("ToggleDoor", ToggleDoor)

local neons = {
	vehicle = nil,
	toggle = false,
	has = false
}
ToggleNeons = function()
	if IsPedInAnyVehicle(ESX.PlayerData.ped, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(ESX.PlayerData.ped), -1) == ESX.PlayerData.ped then
		local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped,false)
		if vehicle ~= neons.vehicle or not neons.has then
			neons = {
				vehicle = vehicle,
				toggle = false,
				has = false
			}
			for i = 0, 3 do
				if IsVehicleNeonLightEnabled(vehicle, i) == 1 then
					neons.has = true
					neons.toggle = true
					break
				end
			end
		end
		if neons.has then
			DisableVehicleNeonLights(vehicle, neons.toggle)
			neons.toggle = not neons.toggle
		end
	end
end
exports("ToggleNeons", ToggleNeons)
