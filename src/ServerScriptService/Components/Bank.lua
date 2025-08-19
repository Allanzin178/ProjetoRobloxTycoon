local PlayerManager = require(script.Parent.Parent.PlayerManager)
local GuiAnimations = require(game:GetService("ReplicatedStorage").Utils.GuiAnimations)
local SoundHandler = require(game:GetService("ReplicatedStorage").Modules.SoundHandler)

local Bank = {}
Bank.__index = Bank

function Bank.new(tycoon, instance)
	local self = setmetatable({}, Bank)
	self.Tycoon = tycoon
	self.Instance = instance
	self.Display = self.Instance.Display
	self.Button = self.Instance.Button
	self.Balance = 0
	
	return self
end

function Bank:Init()
	
	self.Balance = PlayerManager.GetBankCash(self.Tycoon.Owner)
	self:UpdateDisplay()
	
	self.prompt = self:CreatePrompt()
	self.Tycoon:SubscribeTopic("WorthChange", function(worth)
		self:OnWorthChange(worth)	
	end)
	
	--self.Tycoon:SubscribeTopic("BankCashout", function(player)
		
	--end)
end

function Bank:CreatePrompt()
	local prompt = Instance.new("ProximityPrompt")
	prompt.HoldDuration = 0.5
	
	prompt.ActionText = "Cashout"
	prompt.Parent = self.Button
	
	prompt.Triggered:Connect(function(player)
		self:Cashout(player)
	end)
	return prompt
end

function Bank:Cashout(player)
	if self.Balance > 0 and player == self.Tycoon.Owner then
		SoundHandler.SendSoundToClient(self.Tycoon.Owner, "Money", {RandomPitch = {enabled = true}})
		self:CashTransfer(player)
	end
end

function Bank:OnWorthChange(worth)
	self.Balance += math.floor(worth + 0.5)
	self.prompt.ObjectText = "$" .. self.Balance
	
	PlayerManager.SetBankCash(self.Tycoon.Owner, self.Balance)
	
	self:UpdateDisplay()
end

function Bank:UpdateDisplay()
	
	--self.Display.Money.Text = "$" .. self.Balance
	GuiAnimations.ValueAnimation(self.Display.Money, self.Balance)

end

function Bank:CashTransfer(player)
	if player and player == self.Tycoon.Owner then
		print(self.Tycoon.Owner.Name .. " deu Cashout!")
		local playerMoney = PlayerManager.GetCash(player) + self.Balance
		PlayerManager.SetCash(player, playerMoney)
		print(PlayerManager.GetCash(player))
		self.Balance = 0
		self:UpdateDisplay()
	end
end

return Bank