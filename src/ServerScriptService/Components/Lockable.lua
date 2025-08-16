local Lockable = {}
Lockable.__index = Lockable

function Lockable.new(tycoon, instance: Instance)
	local self = setmetatable({}, Lockable)
	self.Tycoon = tycoon
	self.Instance = instance

	return self
end

function Lockable:Init()
	self.Subscription = self.Tycoon:SubscribeTopic("Button", function(...)
		self:OnButtonPressed(...)	
	end)
end

function Lockable:OnButtonPressed(id)
	if id == self.Instance:GetAttribute("LockId") then
		self.Instance:SetAttribute("LockId", nil)
		self.Instance:Destroy()
		self.Subscription:Disconnect()
	end
end

return Lockable
