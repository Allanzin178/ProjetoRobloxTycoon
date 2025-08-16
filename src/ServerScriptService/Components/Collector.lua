local CollectionService = game:GetService("CollectionService")

local Collector = {}
Collector.__index = Collector

function Collector.new(tycoon, instance: Instance)
	local self = setmetatable({}, Collector)
	self.Tycoon = tycoon
	self.Instance = instance

	return self
end

function Collector:Init()
	self.Instance.Collider.Touched:Connect(function(hitPart)
		self:OnTouched(hitPart)
	end)
end

function Collector:OnTouched(hitPart)
	if CollectionService:HasTag(hitPart, "Drop") then
		local worth = hitPart:GetAttribute("Worth")
		if worth then
			self.Tycoon:PublishTopic("WorthChange", worth)
			hitPart:Destroy()
		end
	end
end


return Collector
