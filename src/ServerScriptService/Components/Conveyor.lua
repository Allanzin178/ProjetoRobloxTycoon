local Conveyor = {}
Conveyor.__index = Conveyor

function Conveyor.new(tycoon, instance: Instance)
	local self = setmetatable({}, Conveyor)
	self.Tycoon = tycoon
	self.Instance = instance
	self.Speed = instance:GetAttribute("Speed") or 5
	
	return self
end

function Conveyor:Init()
	local belt: Part = self.Instance.Belt
	
	belt.AssemblyLinearVelocity = belt.CFrame.LookVector * self.Speed
end



return Conveyor
