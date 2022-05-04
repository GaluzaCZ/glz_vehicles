if Config.RadialMenu.Enabled then
	AddEventHandler('glz_veh:init', function()
        while GetResourceState("glz_radialmenu") ~= "started" do
            if GetResourceState("glz_radialmenu") == "missing" then return error("Resource 'glz_radialmenu' is not represent! Please download 'glz_radialmenu' or disable RadialMenu in config") end
            Wait(0)
        end
		local name = "vehicle"
        local radialmenu = exports.glz_radialmenu

        radialmenu:create(name, Config.RadialMenu.Menu)

        RegisterCommand(Config.RadialMenu.Command, function()
            if IsPedInAnyVehicle(ESX.PlayerData.ped, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(ESX.PlayerData.ped), -1) == ESX.PlayerData.ped then
                radialmenu:open(name)
            end
        end, false)

        RegisterKeyMapping(Config.RadialMenu.Command, "Open vehicle radialmenu", "keyboard", Config.RadialMenu.Key)
	end)
end