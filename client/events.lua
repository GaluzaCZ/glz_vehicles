RegisterNetEvent("glz_veh:engine", function()
	if IsPedInAnyVehicle(PPed, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PPed), -1) == PPed then
		local vehicle = GetVehiclePedIsIn(PPed,false)
		SetVehicleEngineOn(vehicle, GetIsVehicleEngineRunning(vehicle) ~= 1, false, true)
	end
end)

RegisterNetEvent("glz_veh:door", function(doorId)
	if IsPedInAnyVehicle(PPed, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PPed), -1) == PPed then
		local vehicle = GetVehiclePedIsIn(PPed,false)
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
	if IsPedInAnyVehicle(PPed, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PPed), -1) == PPed then
		local vehicle = GetVehiclePedIsIn(PPed,false)
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