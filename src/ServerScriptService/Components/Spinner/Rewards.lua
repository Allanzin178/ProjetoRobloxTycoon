local PlayerManager = require(script.Parent.Parent.Parent.PlayerManager)

local Rewards = {}

local MAX_CHANCE = 1000


Rewards.data = {
	{
		name = "500 coins",
		chance = 499/1000,
		callback = function(Tycoon)
			Tycoon:PublishTopic("WorthChange", 500)
		end,
	},
	{
		name = "750 coins",
		chance = 450/1000,
		callback = function(Tycoon)
			Tycoon:PublishTopic("WorthChange", 500)
		end,
	},
	{
		name = "5 cosmic coins",
		chance = 45/1000,
		callback = function(Tycoon)
			PlayerManager.SetCosmicCoins(Tycoon.Owner, PlayerManager.GetCosmicCoins(Tycoon.Owner) + 5)
		end,
	},
	{
		name = "25 cosmic coins",
		chance = 5/1000,
		callback = function(Tycoon)
			PlayerManager.SetCosmicCoins(Tycoon.Owner, PlayerManager.GetCosmicCoins(Tycoon.Owner) + 25)
		end,
	},
	{
		name = "Exclusive item",
		chance = 1/1000
	}
}

function Rewards.Roll()
	
	local pesoTotal = 0
	for _, reward in ipairs(Rewards.data) do
		pesoTotal += (reward.chance * MAX_CHANCE)
	end
	
	local randomNumber = math.random(1, pesoTotal) -- 500 por exemplo
	local cumulative = 0
	
	for _, reward in ipairs(Rewards.data) do
		cumulative += (reward.chance * MAX_CHANCE) -- 0 + 499 = 499 [Segundo loop] 499 + 450 = 949
		if cumulative >= randomNumber then -- 499 >= 500 [Não] 949 >= 500 [Sim]
			return reward
		end
	end
	
end

return Rewards
