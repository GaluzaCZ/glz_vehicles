local Blips = {}
local Markers = {}
local currentData
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
		PPed = PlayerPedId()
		local sleep = 500 -- save energy

		for i,v in ipairs(Markers) do
			local pedCoords = GetEntityCoords(PPed)
			local distance = #(pedCoords - v.pos)

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

AddEventHandler('glz_veh:init', function()
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
end)

PlayerInMarker = function(data)
	if data == "garage" and not IsPedInAnyVehicle(PPed, true) and not opened then
		ESX.ShowHelpNotification(_U("press_menu"))
		if IsControlJustReleased(0,38) then
			opened = true
			OpenGarageMenu(currentData.name, currentData.spawn, currentData.heading)
		end
	end

	if data == "impound" and not IsPedInAnyVehicle(PPed, true) and not opened then
		ESX.ShowHelpNotification(_U("press_menu"))
		if IsControlJustReleased(0,38) then
			opened = true
			OpenImpoundMenu()
		end
	end

	if data == "despawn" and IsPedInAnyVehicle(PPed, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PPed), -1) == PPed and not opened then
		ESX.ShowHelpNotification(_U("press_despawn"))
		if IsControlJustReleased(0,38) then
			opened = true
			StoreVehicle(GetVehiclePedIsIn(PPed,false), currentData.name)
		end
	end
end

-- Menus --
function OpenImpoundMenu()
	local impData = currentData
	ESX.TriggerServerCallback("glz_veh:getPlayerVehicles", function(vehicles)
		local elements = {}
		for i, v in ipairs(vehicles) do
			if v.stored == 0 or v.garage_name == nil then
				table.insert(elements,{label = '<span style="color:Green">'..v.vehiclename..'</span> - <span style="color:GoldenRod">'..v.plate..'</span> - <span style="color:Green">$'..Config.Impounds.Cost..'</span>', value=v})
			end
		end

		OpenMenu("Impound", elements, function(data, menu)
			if data.current.value then
				if ESX.Game.IsSpawnPointClear(impData.spawn, 3.0) then
					ESX.TriggerServerCallback("glz_veh:payForImpound", function(paid)
						if paid then
							ESX.Game.SpawnVehicle(data.current.value.vehicle.model, impData.spawn, impData.heading, function(callback_vehicle)
								TriggerServerEvent("glz_veh:setVehicleSpawn", data.current.value.plate)
								SetVehicleProperties(callback_vehicle, data.current.value.vehicle)
								SetPedIntoVehicle(PPed, callback_vehicle, -1)
							end)
							menu.close()
						else
							pNotify(_U("no_money", Config.Impounds.Cost), "error")
						end
					end)
				else
					pNotify(_U("spawnpoint_not_clear"), "warning")
				end
			end
		end)
	end)
end
