RegisterCommand(Config.SwitchVehicleJobCommand, function()
	if IsPedInAnyVehicle(ESX.PlayerData.ped, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(ESX.PlayerData.ped), -1) == ESX.PlayerData.ped then
		local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped, false)
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
