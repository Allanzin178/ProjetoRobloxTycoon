local CollectionService = game:GetService("CollectionService")

local OwnerDoor = {}
OwnerDoor.__index = OwnerDoor

function OwnerDoor.new(tycoon, instance: Instance)
	local self = setmetatable({}, OwnerDoor)
	self.Tycoon = tycoon
	self.Instance = instance

	return self
end

function OwnerDoor:Init()
	self.Instance.Detector.Touched:Connect(function(hitPart)
		self:OnTouched(hitPart)
	end)
end

function OwnerDoor:OnTouched(hitPart)
	local chr: Model = hitPart.Parent
	if not chr then
		return
	end
	
	local hum = chr and chr:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end
	
	local player = game.Players:GetPlayerFromCharacter(chr)
	if player and player == self.Tycoon.Owner then
		return
	end
	
	hum.Health = 0
	
end


return OwnerDoor
