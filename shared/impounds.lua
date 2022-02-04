Impounds = {
	{
		pos = vector3(402.03024291992,-1633.1915283203,29.291927337646), -- position for marker and blip
		spawn = vector3(407.16467285156,-1645.1149902344,29.291955947876), -- position for vehicle spawnpoint
		heading = 225.00, -- heading for vehicle spawnpoint, must have point zero zero (.00) at the end
	},
	{
		pos = vector3(1662.2703857422,3820.53515625,35.469779968262), -- position for marker and blip
		spawn = vector3(1668.1334228516,3828.6984863281,34.905460357666), -- position for vehicle spawnpoint
		heading = 311.00, -- heading for vehicle spawnpoint, must have point zero zero (.00) at the end
	},
	{
		pos = vector3(-478.79782104492,6008.2709960938,31.299709320068), -- position for marker and blip
		spawn = vector3(-475.72998046875,5988.599609375,31.336709976196), -- position for vehicle spawnpoint
		heading = 314.00, -- heading for vehicle spawnpoint, must have point zero zero (.00) at the end
	},
	{
		pos = vector3(261.95443725586,-764.43389892578,34.644542694092), -- position for marker and blip
		spawn = vector3(251.48957824707,-753.13787841797,34.638568878174), -- position for vehicle spawnpoint
		heading = 68.00, -- heading for vehicle spawnpoint, must have point zero zero (.00) at the end
	}
}

for i, v in ipairs(Impounds) do
	if not v.name then
		Impounds[i].name = "Impound" .. i
	end
end