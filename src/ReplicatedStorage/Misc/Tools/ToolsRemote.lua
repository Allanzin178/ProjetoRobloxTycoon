local RS = game:GetService("ReplicatedStorage")
local Events = RS.Events


local Funcs = {
	["TungBat"] = {
		M1 = function(...)
			Events["Client-Server"].Combat:FireServer(...)
		end,
	},
}

return Funcs
