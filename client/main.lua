local ESX = nil
local vehicles = {}
local xPlayer
local MainRun = false -- Make sure to run the main function once

RegisterNetEvent('esx:playerLoaded', function(playerData)
	xPlayer = playerData
	if not MainRun then
		Main()
	end
end)

RegisterNetEvent('esx:setJob', function(Job)
	xPlayer.job = Job
end)

RegisterNetEvent('esx:setPlayerData', function(k, v)
	xPlayer[k] = v
end)

RegisterNetEvent('esx:onPlayerLogout', function()

end)

Main = function()
	MainRun = true

	-- load ESX to client
	while ESX == nil do
		ESX = exports.es_extended:getSharedObject()
	end
	if not xPlayer then
		xPlayer = ESX.GetPlayerData()
	end

	-- Main thread
	Citizen.CreateThread(function()
		-- Get client vehicles from server
		ESX.TriggerServerCallback('glz:veh_initPlayer', function(result)
			if result then
				for _, v in pairs(result) do
					print(v.identifier, v.firstname, v.lastname)
					print(xPlayer.identifier, xPlayer.firstname, xPlayer.lastname)
				end
			end
		end)
	end)
end

if not MainRun then
	Main()
end