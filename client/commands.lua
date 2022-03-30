RegisterCommand(Config.SwitchVehicleJobCommand, function()
	if IsPedInAnyVehicle(PPed, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PPed), -1) == PPed then
		local vehicle = GetVehiclePedIsIn(PPed, false)
		local plate = GetVehicleNumberPlateText(vehicle)
		ESX.TriggerServerCallback("glz_veh:hasPlayerVehicleByPlate", function(has)
			if has then
				TriggerServerEvent("glz_veh:switchVehicleJob",plate)
			else
				pNotify(_U("not_owned"), "error")
			end
		end, plate)
	end
end, false)

if Config.CarLock.Enabled then
	RegisterCommand(Config.CarLock.Command, function()
		ToggleLock()
	end, false)

	RegisterKeyMapping(Config.CarLock.Command, "Lock/Unlock your vehicle", "keyboard", Config.CarLock.Key)
end