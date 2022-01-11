local ESX = exports.es_extended:getSharedObject()
local vehicles = {
	identifier = {},
	plate = {},
	job = {}
}

ESX.RegisterServerCallback('glz:veh_initPlayer', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	local result = MySQL.query.await('SELECT * FROM users WHERE identifier = ?', {xPlayer.identifier})
	if result then
		cb(result)
		for _, v in pairs(result) do
			print(v.identifier, v.firstname, v.lastname)
		end
	end
end)