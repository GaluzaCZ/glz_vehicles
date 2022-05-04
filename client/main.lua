local MainRun = false -- Make sure to run the main function once

-- ESX events
RegisterNetEvent('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
	if not MainRun then
		Main()
	end
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Main = function()
	MainRun = true

	Wait(500)
	-- initialize
	TriggerServerEvent('glz_veh:init')
	TriggerEvent('glz_veh:init')
end

CreateThread(function()
	if not MainRun and GetResourceState("es_extended") == "started" then
		if ESX.IsPlayerLoaded() then
			Main()
		end
	end
end)
