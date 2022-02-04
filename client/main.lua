local MainRun = false -- Make sure to run the main function once
ESX = nil
xPlayer = {}

-- ESX events
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
	TriggerEvent('glz_veh:init')
end

--Citizen.CreateThread(function()
--	if not MainRun then
--		TriggerServerEvent("glz_veh:restart")
--		Main()
--	end
--end)

function pNotify(text,type,time)
	local options = {
	  text = text,
	  timeout = time or 2000,
	  type = type
	}

	exports.pNotify:SendNotification(options)
end