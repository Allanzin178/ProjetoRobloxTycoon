local EnumCurrencies = require(game:GetService("ServerScriptService").Configs.CurrenciesEnum)

export type Upgrade = {
	ID: string,
} & UpgradeWithoutId

type UpgradeWithoutId = {
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

local idCache = {}

function createUpgrade(data: UpgradeWithoutId): Upgrade
	local formattedName = string.lower(string.gsub(data.Name, "%s+", ""))

	idCache[formattedName] = idCache[formattedName] or 1 -- 1
	local id = string.format("upg%d_%s", idCache[formattedName], formattedName)
	idCache[formattedName] = idCache[formattedName] + 1 -- 2 (para o proximo)

	local result: Upgrade = table.clone(data)
	result.ID = id
	return result
end

local upg1 = createUpgrade({
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
})

local upg2 = createUpgrade({
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
})

local upg3 = createUpgrade({
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
			upg1.ID
		}
	}
})

local UpgradesData: { Upgrade } = {
	upg1,
	upg2,
	upg3
}



return UpgradesData
