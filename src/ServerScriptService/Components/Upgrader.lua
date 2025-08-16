local Upgrader = {}
Upgrader.__index = Upgrader

function Upgrader.new(tycoon, instance)
	local self = setmetatable({}, Upgrader)
	self.Instance = instance
	self.Detector = instance.Detector
	
	return self
end

function Upgrader:Init()
	self.Detector.Touched:Connect(function(hitPart)
		self:OnTouch(hitPart)
	end)
end

function Upgrader:OnTouch(hitPart)
	local worth = hitPart:GetAttribute("Worth")
	
	if worth then
		local multiplier = self.Instance:GetAttribute("Multiplier")
		local finalWorth = worth * multiplier
		
		hitPart:SetAttribute("Worth", finalWorth)
		
		local worthNumber = hitPart.WorthNumber
			
		if worthNumber then
			worthNumber.TextLabel.Text = "$" .. math.round(finalWorth)
		end
	end
end


return Upgrader