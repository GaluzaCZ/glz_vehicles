local self = {
	--[[
		source = {
			plate...
		}
	]]
	source = {},

	--[[
		job = {
			plate...
		}
	]]
	job = {},

	-- Main table
	--[[
	plate = {
		owner,
		plate,
		vehicle, -- vehicleProps
		type,
		job,
		stored,
		garage_name, -- Mby will be renamed to "garage"
		vehiclename,
		(all in database)
	}
	]]
	plate = {}
}

vehicles = {
	source = {},
	job = {},
	plate = {}
}

-- Plate
vehicles.plate.add = function(vehicle)
	if vehicles.plate.is(vehicle.plate) then return false end
	self.plate[vehicle.plate] = vehicle
	return true
end

vehicles.plate.remove = function(vehicleOrPlate)
	if type(vehicleOrPlate) == "table" then
		self.plate[vehicleOrPlate.plate] = nil
		return true
	elseif type(vehicleOrPlate) == "string" then
		self.plate[vehicleOrPlate] = nil
		return true
	end

	return false
end

vehicles.plate.set = function(vehicle)
	if vehicles.plate.is(vehicle.plate) then
		self.plate[vehicle.plate] = vehicle
		return true
	end

	return false
end

vehicles.plate.get = function(plate)
	return self.plate[plate]
end

vehicles.plate.is = function(plate)
	if self.plate[plate] then
		return true
	else
		return false
	end
end

vehicles.plate.changePlate = function(vehicle, newPlate)
	if vehicles.plate.is(newPlate) then return false end
	if vehicle.plate == newPlate then return false end
	vehciels.plate.remove(vehicle)
	vehicle.plate = newPlate
	vehicles.plate.add(vehicle)
	return true
end

vehicles.plate.removeUnused = function()
	for plate, vehicle in pairs(self.plate) do
		local continue = false
		for source in pairs(self.source) do
			if vehicles.source.has(source, plate) then
				continue = true
				break
			end
		end
		if vehicle.job and vehicles.job.is(vehicle.job) then
			continue = true
		end
		if not continue then
			vehicles.plate.remove(plate)
		end
	end
end

-- Source
vehicles.source.get = function(source)
	local vehs = {}
	if not vehicles.source.is(source) then return vehs end
	for i, v in ipairs(self.source[source]) do
		table.insert(vehs, vehicles.plate.get(v))
	end
	return vehs
end

vehicles.source.is = function(source)
	if self.source[source] then
		return true
	else
		return false
	end
end

vehicles.source.has = function(source, plate)
	if not vehicles.source.is(source) then return false end
	for i, v in ipairs(self.source[source]) do
		if v == plate then
			return true
		end
	end
	return false
end

vehicles.source.add = function(source, plate)
	if vehicles.source.has(source, plate) then return true end
	if not vehicles.source.is(source) then
		self.source[source] = {}
	end

	table.insert(self.source[source], plate)
end

vehicles.source.remove = function(source, plate)
	if not plate then
		self.source[source] = nil
		return true
	end
	if not vehicles.source.is(source) then return false end
	for i, v in ipairs(self.source[source]) do
		if v == plate then
			table.remove(self.source[source], i)
			return true
		end
	end
	return true
end

vehicles.source.removeUnused = function() -- Don't use this function, idk if it's working
	for source in pairs(self.source) do
		local players = ESX.GetPlayers()
		local continue = false
		for i, src in ipairs(players) do
			if src == source then
				continue = true
				break
			end
		end
		if not continue then
			vehicles.source.remove(source)
		end
	end
end

-- Job
vehicles.job.get = function(job)
	local vehs = {}
	if not vehicles.job.is(job) then return vehs end
	for i, v in ipairs(self.job[job]) do
		table.insert(vehs, vehicles.plate.get(v))
	end
	return vehs
end

vehicles.job.is = function(job)
	if self.job[job] then
		return true
	else
		return false
	end
end

vehicles.job.has = function(job, plate)
	if not vehicles.job.is(job) then return false end
	for i, v in ipairs(self.job[job]) do
		if v == plate then
			return true
		end
	end
	return false
end

vehicles.job.add = function(job, plate)
	if vehicles.job.has(job, plate) then return true end
	if not vehicles.job.is(job) then
		self.job[job] = {}
	end

	table.insert(self.job[job], plate)
end

vehicles.job.remove = function(job, plate)
	if not plate then
		self.job[job] = nil
		return true
	end
	if not vehicles.job.is(job) then return false end
	for i, v in ipairs(self.job[job]) do
		if v == plate then
			table.remove(self.job[job], i)
			return true
		end
	end
	return true
end

vehicles.job.removeUnused = function()
	for job in pairs(self.job) do
	   local players = ESX.GetExtendedPlayers("job", job)
	   if #players == 0 then
		   vehicles.job.remove(job)
	   end
	end
end