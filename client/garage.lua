local Blips = {}
local Positions = {}
local currentData
local currentPosition
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

		for i = 1, #Positions do
			local v = Positions[i]
			local pedCoords = GetEntityCoords(ESX.PlayerData.ped)
			local distance = #(pedCoords - v.pos)

			if distance < Config.DrawDistance then
				sleep = 0
				DrawMarker(
					v.marker.Type,
					v.pos.x, v.pos.y, v.pos.z,
					0, 0, 0, 0, 0, 0,
					v.marker.Scale, v.marker.Scale, v.marker.Scale,
					v.marker.Color.red, v.marker.Color.green, v.marker.Color.blue,
					150,true,false,2,true,nil,nil,false
				)
				if distance < v.marker.Scale then
					currentPosition = i
					currentData = v
					PlayerInMarker(v.data)
				else
					if currentData and currentPosition == i then
						opened = false
						currentPosition = nil
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
		for i = 1, #Config.Garages.Garages do
			local v = Config.Garages.Garages[i]
			CreateBlip(v.name, _("garage_blip_name"), v.pos, Config.Garages.Blip)

			local pos = {
				marker = Config.Garages.Marker,
				name = v.name,
				data = "garage",
				spawn = v.spawn,
				heading = v.heading,
				pos = v.pos
			}
			Positions[#Positions+1] = pos

			local pos2 = {
				marker = Config.Garages.DespawnMarker,
				name = v.name,
				data = "despawn",
				pos = v.despawn
			}
			Positions[#Positions+1] = pos2
		end
	end

	if Config.Impounds.Enabled then
		for i = 1, #Config.Impounds.Impounds do
			local v = Config.Impounds.Impounds[i]
			CreateBlip(v.name, _U("impound_blip_name"), v.pos, Config.Impounds.Blip)

			local pos = {
				marker = Config.Impounds.Marker,
				name = v.name,
				data = "impound",
				spawn = v.spawn,
				heading = v.heading,
				pos = v.pos
			}
			Positions[#Positions+1] = pos
		end
	end
end)

PlayerInMarker = function(data)
	if data == "garage" and not IsPedInAnyVehicle(ESX.PlayerData.ped, true) and not opened then
		ESX.ShowHelpNotification(_U("press_menu"))
		if IsControlJustReleased(0,38) then
			opened = true
			OpenGarageMenu(currentData.name, currentData.spawn, currentData.heading)
		end
	end

	if data == "impound" and not IsPedInAnyVehicle(ESX.PlayerData.ped, true) and not opened then
		ESX.ShowHelpNotification(_U("press_menu"))
		if IsControlJustReleased(0,38) then
			opened = true
			OpenImpoundMenu()
		end
	end

	if data == "despawn" and IsPedInAnyVehicle(ESX.PlayerData.ped, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(ESX.PlayerData.ped), -1) == ESX.PlayerData.ped and not opened then
		ESX.ShowHelpNotification(_U("press_despawn"))
		if IsControlJustReleased(0,38) then
			opened = true
			StoreVehicle(GetVehiclePedIsIn(ESX.PlayerData.ped,false), currentData.name)
		end
	end
end

-- Menus --
function OpenImpoundMenu()
	local impData = currentData
	ESX.TriggerServerCallback("glz_veh:getPlayerVehicles", function(vehicles)
		local elements = {}
		for i = 1, #vehicles do
			local v = vehicles[i]
			if v.stored == 0 or v.garage_name == nil then
				elements[#elements+1] = {label = '<span style="color:Green">'..v.vehiclename..'</span> - <span style="color:GoldenRod">'..v.plate..'</span> - <span style="color:Green">$'..Config.Impounds.Cost..'</span>', value=v}
			end
		end

		OpenMenu("Impound", elements, function(data, menu)
			if data.current.value then
				if ESX.Game.IsSpawnPointClear(impData.spawn, 3.0) then
					ESX.TriggerServerCallback("glz_veh:payForImpound", function(paid)
						if paid then
							ESX.Game.SpawnVehicle(data.current.value.vehicle.model, impData.spawn, impData.heading, function(callback_vehicle)
								TriggerServerEvent("glz_veh:vehicleSpawn", data.current.value.plate)
								SetVehicleProperties(callback_vehicle, data.current.value.vehicle)
								SetPedIntoVehicle(ESX.PlayerData.ped, callback_vehicle, -1)
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
