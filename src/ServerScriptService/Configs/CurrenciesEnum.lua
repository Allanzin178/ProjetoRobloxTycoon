local PlayerManager = require(game:GetService("ServerScriptService").PlayerManager)

export type Type = "Coins" | "CosmicCoins"

local Currencies = {
	Coins = "Coins",
	CosmicCoins = "CosmicCoins"	
}

return Currencies

