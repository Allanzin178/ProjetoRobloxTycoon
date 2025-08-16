local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiAnimations = require(ReplicatedStorage.Utils.GuiAnimations)

for _, button in script.Parent:GetDescendants() do
	if button:IsA("GuiButton") then
		GuiAnimations.ButtonAnimation(button)
	end
end

local TweenService = game:GetService("TweenService")

local Gui = script.Parent
local shine1 = Gui.Money.Shine
local shine2 = Gui.CosmicCoins.Shine

local info = TweenInfo.new(2, Enum.EasingStyle.Circular, Enum.EasingDirection.Out)

task.spawn(function()
	while true do
		
		shine1.Position = UDim2.fromScale(-0.5, 0.5)
		shine2.Position = UDim2.fromScale(-0.5, 0.5)
		local tween1 = TweenService:Create(shine1, info, {Position = UDim2.fromScale(1.5, 0.5)})
		local tween2 = TweenService:Create(shine2, info, {Position = UDim2.fromScale(1.5, 0.5)})
		
		tween1:Play()
		task.wait(1.5)
		tween2:Play()
		task.wait(8.5)
		
	end

end)