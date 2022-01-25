local Blips = {}
local Markers = {}
local currentData = nil
local currentMarker
local opened

-- Draw blips on map
function CreateBlip(name, blipName, pos, blip)
	if DoesBlipExist(Blips[name]) then
		RemoveBlip(Blips[name])
	end
	Blips[name] = AddBlipForCoord(pos)
	SetBlipSprite(Blips[name], blip.Type)
	SetBlipDisplay(Blips[name], 2)
	SetBlipColour(Blips[name], blip.Color)
	SetBlipScale(Blips[name], blip.Scale)
	SetBlipAsShortRange(Blips[name], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(blipName)
	EndTextCommandSetBlipName(Blips[name])
end

--Draw markers and their stuff
CreateThread(function()
	while true do
		local sleep = 500 -- save energy

		for i,v in ipairs(Markers) do
			local pedCoords = GetEntityCoords(PlayerPedId())
			local distance = GetDistanceBetweenCoords(pedCoords, v.pos, true)

			if distance < Config.DrawDistance then
				sleep = 0
				DrawMarker(
					v.Type,
					v.pos.x, v.pos.y, v.pos.z,
					0, 0, 0, 0, 0, 0,
					v.Scale, v.Scale, v.Scale,
					v.Color.red, v.Color.green, v.Color.blue,
					150,true,false,2,true,nil,nil,false
				)
				if distance < v.Scale then
					currentMarker = i
					currentData = v
					PlayerInMarker(v.data)
				else
					if currentData and currentMarker == i then
						opened = false
						currentMarker = nil
						currentData = nil
						ESX.UI.Menu.CloseAll()
					end
				end
			end
		end
		Wait(sleep)
	end
end)

GarageInit = function()
	if Config.Garages.Enabled then
		for i, v in ipairs(Config.Garages.Garages) do
			CreateBlip(v.name, _("garage_blip_name"), v.pos, Config.Garages.Blip)

			local Marker = {}
			Marker.Type = Config.Garages.Marker.Type
			Marker.Color = Config.Garages.Marker.Color
			Marker.Scale = Config.Garages.Marker.Scale
			Marker.name = v.name
			Marker.data = "garage"
			Marker.spawn = v.spawn
			Marker.heading = v.heading
			Marker.pos = v.pos
			table.insert(Markers, Marker)

			local Marker2 = {}
			Marker2.Type = Config.Garages.DespawnMarker.Type
			Marker2.Color = Config.Garages.DespawnMarker.Color
			Marker2.Scale = Config.Garages.DespawnMarker.Scale
			Marker2.name = v.name
			Marker2.data = "despawn"
			Marker2.pos = v.despawn
			table.insert(Markers, Marker2)
		end
	end

	if Config.Impounds.Enabled then
		for i, v in ipairs(Config.Impounds.Impounds) do
			CreateBlip(v.name, _U("impound_blip_name"), v.pos, Config.Impounds.Blip)

			local Marker = {}
			Marker.Type = Config.Impounds.Marker.Type
			Marker.Color = Config.Impounds.Marker.Color
			Marker.Scale = Config.Impounds.Marker.Scale
			Marker.name = v.name
			Marker.data = "impound"
			Marker.spawn = v.spawn
			Marker.heading = v.heading
			Marker.pos = v.pos
			table.insert(Markers, Marker)
		end
	end
end

PlayerInMarker = function(data)
	if data == "garage" and not IsPedInAnyVehicle(PlayerPedId(), true) and not opened then
		ESX.ShowHelpNotification(_U("press_menu"))
		if IsControlJustReleased(0,38) then
			opened = true
			OpenGarageMenu()
		end
	end

	if data == "impound" and not IsPedInAnyVehicle(PlayerPedId(), true) and not opened then
		ESX.ShowHelpNotification(_U("press_menu"))
		if IsControlJustReleased(0,38) then
			opened = true
			OpenImpoundMenu()
		end
	end

	if data == "despawn" and IsPedInAnyVehicle(PlayerPedId(), true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() and not opened then
		ESX.ShowHelpNotification(_U("press_despawn"))
		if IsControlJustReleased(0,38) then
			opened = true
			DeSpawnVehicle()
		end
	end
end

-- Menus --
function OpenImpoundMenu()
	local impData = currentData
	ESX.TriggerServerCallback("glz_veh:getPlayerVehicles", function(vehicles)
		local elements = {}
		if vehicles[1] then
			for i, v in ipairs(vehicles) do
				if v.stored == 0 or v.garage == nil then
					table.insert(elements,{label = '<span style="color:Green">'..v.vehiclename..'</span> - <span style="color:GoldenRod">'..v.plate..'</span> - <span style="color:Green">$'..Config.Impounds.Cost..'</span>', value=v})
				end
			end
		end
		if not elements[1] then
			table.insert(elements,{label = '<span style="color:Red">'.._U("no_cars")..'</span>', value=nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'impound', {
			title =  'Impound',
			elements = elements,
			align = 'top'
		},function(data, menu)
			if data.current.value then
				if ESX.Game.IsSpawnPointClear(impData.spawn, 3.0) then
					ESX.TriggerServerCallback("glz_veh:payForImpound", function(paid)
						if paid then
							SpawnVehicle(data.current.value, impData)
							menu.close()
						else
							pNotify(_U("no_money", Config.Impounds.Cost), "error")
						end
					end)
				else
					pNotify(_U("spawnpoint_not_clear"), "warning")
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenGarageMenu()
	local garageData = currentData
	ESX.TriggerServerCallback("glz_veh:getPlayerVehicles", function(vehicles)
		local elements = {}
		if vehicles[1] then
			for i, v in ipairs(vehicles) do
				if v.stored == 1 and v.garage_name == garageData.name then
					table.insert(elements,{label = '<span style="color:Green">'..v.vehiclename..'</span> - <span style="color:GoldenRod">'..v.plate..'</span>', value=v})
				end
			end
		end
		if not elements[1] then
			table.insert(elements,{label = '<span style="color:Red">'.._U("no_cars")..'</span>', value=nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage', {
			title =  'Garage',
			elements = elements,
			align = 'top'
		},function(data, menu)
			if data.current.value then
				if ESX.Game.IsSpawnPointClear(garageData.spawn, 3.0) then
					SpawnVehicle(data.current.value, garageData)
					menu.close()
				else
					pNotify(_U("spawnpoint_not_clear"), "warning")
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

SpawnVehicle = function(vehicle, spawnData)
	ESX.Game.SpawnVehicle(vehicle.vehicle.model, spawnData.spawn, spawnData.heading, function(callback_vehicle)
		TriggerServerEvent("glz_veh:setVehicleSpawn", vehicle.plate)
		SetVehicleProperties(callback_vehicle, vehicle.vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
	end)
end

DeSpawnVehicle = function()
	local data = currentData
	local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
	local vehicleProps = GetVehicleProperties(vehicle)
	ESX.TriggerServerCallback("glz_veh:hasPlayerVehicleByPlate", function(has)
		if has then
			ESX.Game.DeleteVehicle(vehicle)
			TriggerServerEvent("glz_veh:vehicleDespawn", vehicleProps.plate, vehicleProps, data.name)
		else
			pNotify(_U("not_owned"), "error")
		end
	end, vehicleProps.plate)
end