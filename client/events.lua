RegisterNetEvent("glz_veh:engine", function()
	if IsPedInAnyVehicle(PlayerPedId(), true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
		SetVehicleEngineOn(vehicle, GetIsVehicleEngineRunning(vehicle) ~= 1, false, true)
	end
end)

RegisterNetEvent("glz_veh:door", function(doorId)
	if IsPedInAnyVehicle(PlayerPedId(), true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
		if GetVehicleDoorAngleRatio(vehicle, tonumber(doorId)) > 0.1 then
			SetVehicleDoorShut(vehicle, tonumber(doorId), false)
		else
			SetVehicleDoorOpen(vehicle, tonumber(doorId), false, false)
		end
	end
end)

local neons = {
	vehicle = nil,
	toggle = false,
	has = false
}
RegisterNetEvent("glz_veh:neons", function()
	if IsPedInAnyVehicle(PlayerPedId(), true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
		if vehicle ~= neons.vehicle or not neons.has then
			neons = {
				vehicle = vehicle,
				toggle = false,
				has = false
			}
			for i = 0, 3, 1 do
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
end)