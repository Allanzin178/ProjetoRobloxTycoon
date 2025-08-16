local Dropper = require(script.Parent.Dropper)
local sfx = game:GetService("SoundService").SoundEffects
local SoundHandler = require(game:GetService("ReplicatedStorage").Modules.SoundHandler)

local ClickerDropper = {}
ClickerDropper.__index = ClickerDropper

function ClickerDropper.new(tycoon, instance: Instance)
	local self = setmetatable({}, ClickerDropper)
	
	self.Dropper = Dropper.new(tycoon, instance)
	self.Clicker = instance.Clicker.ClickDetector
	
	self.Dropper.ShinyMultiplier = 3
	self.Dropper.IsAbleToPlaySfx = false
	self.ClickerCooldown = 0.2
	self.Debounce = false
	
	return self
end

function ClickerDropper:Init()
	
	self.Dropper:Init()
	
	self.Clicker.MouseClick:Connect(function(player)
		if player == self.Dropper.Tycoon.Owner then
			self:OnClick()
		end
	end)
	
end

function ClickerDropper:OnClick()
	
	SoundHandler.SendSoundToClient(self.Dropper.Tycoon.Owner, "Click")
	
	if self.Debounce == false then
		
		self.Debounce = true
		self.Dropper:Drop()
		
		local defaultColor = self.Clicker.Parent.Color
		self.Clicker.Parent.Color = Color3.new(1, 0, 0)
		
		task.wait(self.ClickerCooldown)
		
		self.Debounce = false
		self.Clicker.Parent.Color = defaultColor
	end

end


return ClickerDropper
