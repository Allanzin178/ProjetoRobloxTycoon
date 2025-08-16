local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiAnimations = require(ReplicatedStorage.Utils.GuiAnimations)

for _, button in script.Parent:GetDescendants() do
	if button:IsA("GuiButton") then
		GuiAnimations.ButtonAnimation(button)
	end
end