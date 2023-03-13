Config = {}

Config.BlipOn = true
Config.blips = {
	{title="Depositi", colour=3, scale=0.5, id=368, x = 5.32, y = -707.21, z = 45.97}
}

Config.MarkerSize = {x = 0.5, y = 0.5, z = 0.5}
Config.MarkerColor = {r = 255, g = 0, b = 0}
Config.MarkerType = 20
--Config.MarkerColor = {r = 0, g = 128, b = 255}

Config.InitialRentPrice = 60000
Config.DailyRentPrice = 500
Config.DupliKey = 1000

Config.ImpoundedJob = 'police'
Config.ImpoundedJobGrade = 1
Config.Containers = {

	["unionDep1"] = {
		location = vector3(5.09, -680.42, 16.12),
		openText = "~y~Press~r~[E] ~y~to open deposit 1"
	},
	
	["unionDep2"] = {
		location = vector3(-5.98, -676.70, 16.12),
		openText = "~y~Press~r~[E] ~y~to open deposit 2"
	},
	
	["unionDep3"] = {
		location = vector3(6.51, -674.71, 16.12),
		openText = "~y~Press~r~[E] ~y~to open deposit 3"
	},

	["unionDep4"] = {
		location = vector3(-4.32, -670.80, 16.12),
		openText = "~y~Press~r~[E] ~y~to open deposit 4"
	},
	
	["unionDep5"] = {
		location = vector3(10.14, -663.61, 16.12),
		openText = "~y~Press~r~[E] ~y~to open deposit 5"
	},
	
	["unionDep6"] = {
		location = vector3(0.02, -659.44, 16.12),
		openText = "~y~Press~r~[E] ~y~to open deposit 6"
	},
	
}

Config.key_to_teleport = 38

Config.positionsTp = {
    --[[
    {{Teleport1 X, Teleport1 Y, Teleport1 Z, Teleport1 Heading}, {Teleport2 X, Teleport 2Y, Teleport 2Z, Teleport2 Heading}, {Red, Green, Blue}, "Text for Teleport"}
    ]]
    {{5.32, -707.21, 45.97}, "[E] - Go down", {0.92, -703.15, 16.12}, "[E] - Go up", {255,255,255}},
}

function Notify(msg)
    ESX.ShowNotification(msg, 5000, 'info')
end