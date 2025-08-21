local EnumCurrencies = require(game:GetService("ServerScriptService").Configs.CurrenciesEnum)

export type Upgrade = {
	ID: number,
	Name: string,
	Description: string,
	Value: {
		Currency: EnumCurrencies.Type,
		Quantity: number,
	},
	Requirements: {
		Tycoon: {
			UnlockID: string?,
		},
		UpgradeIDs: {string}?,
	},
}

local UpgradesData: { Upgrade } = {
	{
		ID = "upg1_clickerdropper",
		Name = "Clicker Dropper",
		Description = "+50% drop value",
		Value = {
			Currency = EnumCurrencies.CosmicCoins,
			Quantity = 5
		},
		Requirements = {
			Tycoon = {
				UnlockID = "Spinner1"
			}
		}
	},
	{
		ID = "upg1_spinner1",
		Name = "Spinner 1",
		Description = "-1s cooldown",
		Value = {
			Currency = EnumCurrencies.CosmicCoins,
			Quantity = 10
		},
		Requirements = {
			Tycoon = {
				UnlockID = "Spinner1"
			}
		}
	},
	{
		ID = "upg2_clickerdropper",
		Name = "Clicker Dropper",
		Description = "+50% drop rate",
		Value = {
			Currency = EnumCurrencies.CosmicCoins,
			Quantity = 10
		},
		Requirements = {
			Tycoon = {
				UnlockID = "Spinner1"
			},
			UpgradeIDs = {
				"upg1_clickerdropper"
			}
		}
	},
}


return UpgradesData
