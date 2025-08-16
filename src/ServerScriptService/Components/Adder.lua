local Adder = {}
Adder.__index = Adder

function Adder.new(tycoon, instance)
	local self = setmetatable({}, Adder)
	self.Instance = instance
	self.Detector = instance.Detector

	return self
end

function Adder:Init()
	self.Detector.Touched:Connect(function(hitPart)
		self:OnTouch(hitPart)
	end)
end

function Adder:OnTouch(hitPart)
	local worth = hitPart:GetAttribute("Worth")

	if worth then
		local addition = self.Instance:GetAttribute("Addition")
		hitPart:SetAttribute("Worth", worth + addition)
		local finalWorth = worth + addition

		hitPart:SetAttribute("Worth", finalWorth)

		local worthNumber = hitPart.WorthNumber

		if worthNumber then
			worthNumber.TextLabel.Text = "$" .. math.round(finalWorth)
		end
	end
end


return Adder