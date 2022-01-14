Config = {} --Don't touch

Config.Locale = "cs" -- set your locale in "locales" folder

Config.DrawDistance = 50 -- Distance which marker will show

Config.SetVehicleStoredOnServerStart = true -- if server restart all vehicles will be stored in garage

Config.Garages = {
	Enabled = true,

	Blip = {
		Type = 357, -- https://docs.fivem.net/docs/game-references/blips/
		Color = 3, -- https://docs.fivem.net/docs/game-references/blips/ - at the end of the page
		Scale = 0.5
	},

	Marker = {
		Type = 2, -- U can find it at https://docs.fivem.net/docs/game-references/markers/
		Color = { red = 39, green = 255, blue = 0 }, -- (RGB) https://htmlcolorcodes.com/color-picker/
		Scale = 0.5
	},

	DespawnMarker = {
		Type = 30, -- U can find it at https://docs.fivem.net/docs/game-references/markers/
		Color = { red = 38, green = 190, blue = 255 }, -- (RGB) https://htmlcolorcodes.com/color-picker/
		Scale = 2.0
	},

	Garages = Garages
}

Config.Impounds = {
	Enabled = true,

	Cost = 2000,

	Blip = {
		Type = 67, -- https://docs.fivem.net/docs/game-references/blips/
		Color = 1, -- https://docs.fivem.net/docs/game-references/blips/ - at the end of the page
		Scale = 1.0
	},

	Marker = {
		Type = 24, -- U can find it at https://docs.fivem.net/docs/game-references/markers/
		Color = { red = 255, green = 80, blue = 0 }, -- (RGB) https://htmlcolorcodes.com/color-picker/
		Scale = 2.0
	},

	Impounds = Impounds
}