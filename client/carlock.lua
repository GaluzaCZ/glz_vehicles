if Config.CarLock.Enabled then
	AddEventHandler('glz_veh:init', function()
		local dict = "anim@mp_player_intmenu@key_fob@"
		ESX.Streaming.RequestAnimDict(dict)

		BlinkVehicle = function(v)
			SetVehicleLights(v, 2)
			Citizen.Wait(150)
			SetVehicleLights(v, 0)
			Citizen.Wait(150)
			SetVehicleLights(v, 2)
			Citizen.Wait(150)
			SetVehicleLights(v, 0)
		end

		ToggleLock = function()
			local coords = GetEntityCoords(GetPlayerPed(-1))
			local cars = ESX.Game.GetVehiclesInArea(coords, Config.CarLock.Distance)
			if #cars == 0 then
				pNotify(_U("no_cars_in_radius"),"info")
			else
				local carsdistancesort = {}
				local carsdistance = {}
				local vehiclesbydistance = {}
				for i, v in ipairs(cars) do
					local vehicleCoords = GetEntityCoords(v)
					local distance = GetDistanceBetweenCoords(coords, vehicleCoords, true)
					table.insert(carsdistancesort, distance)
					table.insert(carsdistance, distance)
				end
				table.sort(carsdistancesort)

				for i, v in ipairs(cars) do
					for j = 1, #carsdistancesort, 1 do
						if carsdistancesort[j] == carsdistance[i] then
							table.insert(vehiclesbydistance, v)
						end
					end
				end

				for i, v in ipairs(vehiclesbydistance) do
					local plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
					local owned = nil
					ESX.TriggerServerCallback('glz_veh:hasPlayerVehicleByPlate', function(owner)
						if owner then
							owned = true
							local lock = GetVehicleDoorLockStatus(v)
							if lock == 1 or lock == 0 then
								for j = 0, 5, 1 do
									SetVehicleDoorShut(v, j, false)
								end
								SetVehicleDoorsLocked(v, 2)
								PlayVehicleDoorCloseSound(v, 1)

								if not IsPedInAnyVehicle(PlayerPedId(), true) then
									TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
								end

								pNotify(_U("vehicle_locked"),"success")
								BlinkVehicle(v)
							elseif lock == 2 then
								SetVehicleDoorsLocked(v, 1)
								PlayVehicleDoorOpenSound(v, 0)

								if not IsPedInAnyVehicle(PlayerPedId(), true) then
									TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
								end

								pNotify(_U("vehicle_unlocked"),"warning")
								BlinkVehicle(v)
							end
						else
							owned = false
						end
					end, plate)
					while owned == nil do Wait(0) end
					if owned then
						break
					end
					if i == #vehiclesbydistance then
						pNotify(_U("no_owned_cars_in_radius"),"info")
					end
				end
			end
		end
	end)
end
