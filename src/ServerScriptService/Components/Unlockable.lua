local Unlockable = {}
Unlockable.__index = Unlockable

function Unlockable.new(tycoon, instance: Instance)
	local self = setmetatable({}, Unlockable)
	self.Tycoon = tycoon
	self.Instance = instance
	
	return self
end

function Unlockable:Init()
	self.Subscription = self.Tycoon:SubscribeTopic("Button", function(...)
		self:OnButtonPressed(...)	
	end)
end

function Unlockable:OnButtonPressed(id)
	if id == self.Instance:GetAttribute("UnlockId") then
		self.Tycoon:Unlock(self.Instance, id)
		if not self.Instance:GetAttribute("LockId") then
			self.Subscription:Disconnect()
		end
	end
end

return Unlockable 
