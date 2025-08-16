local ValueAnimation = {}

function ValueAnimation.Animate(moneyText: TextLabel, targetCash: number)

	local moneyStr = string.sub(moneyText.Text, 2)
	local currentValue = tonumber(moneyStr)

	local initialCash = currentValue

	local moneyDifference = targetCash - currentValue

	local tempCash = initialCash

	local cashIncrement = 1 
	local exponentialIncrease = math.max((moneyDifference / 2000), 0.5)

	task.spawn(function()
		repeat

			tempCash = math.floor(tempCash + cashIncrement)
			cashIncrement = cashIncrement + exponentialIncrease

			if tempCash >= targetCash then
				tempCash = targetCash
			end

			moneyText.Text = tostring("$" .. tempCash)
			task.wait()

		until tempCash >= targetCash
	end)
end

return ValueAnimation
