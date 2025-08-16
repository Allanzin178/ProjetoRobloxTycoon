local PlayerManager = require(script.Parent.Parent.PlayerManager)
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local sfx = SoundService.SoundEffects

local Button = {}
Button.__index = Button

function Button.new(tycoon, instance)
	local self = setmetatable({}, Button)
	self.Tycoon = tycoon
	self.Instance = instance
	self.Display = self.Instance:GetAttribute("Display") 
	self.Cost = self.Instance:GetAttribute("Cost")

	self:DespawnSubscription()

	return self
end

function Button:Init()
	self:AttachSound()
	self.Prompt = self:CreatePrompt()
	self.Prompt.Triggered:Connect(function(...)
		self:Press(...)	
	end)	
	
end

function Button:CreatePrompt()
	local prompt = Instance.new("ProximityPrompt")
	prompt.HoldDuration = 0.5
	prompt.ActionText = self.Display
	prompt.ObjectText = "$" .. self.Cost
	
	prompt.Parent = self.Instance
	return prompt
end

function Button:Press(player)
	local id = self.Instance:GetAttribute("Id")
	local money = PlayerManager.GetCash(player)
	
	if player == self.Tycoon.Owner and money >= self.Cost then
		PlayerManager.SetCash(player, money - self.Cost)
		
		-- Toca o efeito sonoro
		if not self.Sfx.IsLoaded then
			self.Sfx.Loaded:Wait()
		end
		
		self:PlaySfx()
		
		self.Tycoon:PublishTopic("Button", id)
	end
end

function Button:DespawnSubscription()
	self.Subscription = self.Tycoon:SubscribeTopic("Button", function(id, responseId)
		if id == self.Instance:GetAttribute("Id") then
			self.Instance:Destroy()
			self.Subscription:Disconnect()
			
			-- Quando destruir, publica a resposta para o proximo loop
			self.Tycoon:PublishTopic("ResponseButton", responseId)
		end
	end)
end

function Button:AttachSound()
	local Money = sfx.Money:Clone()
	Money.Volume = 0.5
	Money.Parent = self.Instance:Clone()
	Money.Parent.Transparency = 1
	Money.Parent.CanCollide = false
	Money.Parent.Parent = self.Tycoon.Model
	self.Sfx = Money
end

function Button:PlaySfx()
	self.Sfx:Stop()
	self.Sfx:Play()
	Debris:AddItem(self.Sfx.Parent, 1)
end

return Button
