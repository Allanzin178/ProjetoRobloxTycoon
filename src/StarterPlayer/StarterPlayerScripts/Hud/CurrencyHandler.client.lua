local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GuiAnimations = require(ReplicatedStorage.Utils.GuiAnimations)

local Events = ReplicatedStorage.Events
local CurrencyTexts = ReplicatedStorage.Gui

local MoneyTemplate = CurrencyTexts.Money
local CosmicCoinsTemplate = CurrencyTexts.CosmicCoins

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local currenciesGui = playerGui:WaitForChild("Currencies")

local moneyFrame = currenciesGui:WaitForChild("Money")
local cosmicCoinsFrame = currenciesGui:WaitForChild("CosmicCoins")

local function UpdateCashGui(value: number)
	local moneyText = moneyFrame:FindFirstChild("Money")
	if not moneyText then
		moneyText = MoneyTemplate:Clone()
		moneyText.Parent = moneyFrame
	end
	
	GuiAnimations.Expand(moneyText, 0.5)
	GuiAnimations.ValueAnimation(moneyText, value)
end

local function UpdateCosmicGui(value: number)
	local cosmicCoinsText = cosmicCoinsFrame:FindFirstChild("CosmicCoins")
	if not cosmicCoinsText then
		cosmicCoinsText = CosmicCoinsTemplate:Clone()
		cosmicCoinsText.Parent = cosmicCoinsFrame
	end
	
	GuiAnimations.Expand(cosmicCoinsText, 0.5)
	GuiAnimations.ValueAnimation(cosmicCoinsText, value)
end

Events["Server-Client"].CashChange.OnClientEvent:Connect(UpdateCashGui)
Events["Server-Client"].CosmicCoinsChange.OnClientEvent:Connect(UpdateCosmicGui)