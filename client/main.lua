local ESX = nil
local xPlayer
local MainRun = false -- Make sure to run the main function once
local vehicles = {
	identifier = {},
	job = {}
}

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
	-- To do
end

RegisterNetEvent('glz_veh:syncClient', function(data)
	if data.identifier then
		vehicles.identifier = data.identifier
	elseif data.job then
		vehicles.job = data.job
	end
end)