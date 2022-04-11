if Config.CarLock.Enabled then
	AddEventHandler('glz_veh:init', function()
		local dict = "anim@mp_player_intmenu@key_fob@"
		ESX.Streaming.RequestAnimDict(dict)

		local BlinkVehicle = function(v)
			SetVehicleLights(v, 2)
			Citizen.Wait(150)
			SetVehicleLights(v, 0)
			Citizen.Wait(150)
			SetVehicleLights(v, 2)
			Citizen.Wait(150)
			SetVehicleLights(v, 0)
		end

		local lockVehicle = function(v)
			local lock = GetVehicleDoorLockStatus(v)
			if lock == 1 or lock == 0 then
				for i = 0, 5 do
					SetVehicleDoorShut(v, i, false)
				end
				SetVehicleDoorsLocked(v, 2)
				PlayVehicleDoorCloseSound(v, 1)

				if IsPedOnFoot(PPed) then
					TaskPlayAnim(PPed, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				end

				pNotify(_U("vehicle_locked"),"success")
				BlinkVehicle(v)
			elseif lock == 2 then
				SetVehicleDoorsLocked(v, 1)
				PlayVehicleDoorOpenSound(v, 0)

				if IsPedOnFoot(PPed) then
					TaskPlayAnim(PPed, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				end

				pNotify(_U("vehicle_unlocked"),"warning")
				BlinkVehicle(v)
			end
		end

		ToggleLock = function()
			local coords = GetEntityCoords(PPed)
			local cars = ESX.Game.GetVehiclesInArea(coords, Config.CarLock.Distance)
			print(#cars)
			if #cars == 0 then return pNotify(_U("no_cars_in_radius"),"info") end

			table.sort(cars, function(a, b)
				local vehicleCoords1 = GetEntityCoords(a)
				local distance1 = #(coords - vehicleCoords1)
				local vehicleCoords2 = GetEntityCoords(b)
				local distance2 = #(coords - vehicleCoords2)
				return distance1 < distance2
			end)

			for i = 1, #cars do
				local v = cars[i]
				local plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				local loop
				ESX.TriggerServerCallback('glz_veh:hasPlayerVehicleByPlate', function(owner)
					if owner then
						lockVehicle(v)
						loop = "return"
						return
					end
					loop = "continue"
				end, plate)
				while loop == nil do
					Wait(0)
				end
				if loop == "return" then return end
			end
			pNotify(_U("no_owned_cars_in_radius"),"info")
		end
	end)
end
