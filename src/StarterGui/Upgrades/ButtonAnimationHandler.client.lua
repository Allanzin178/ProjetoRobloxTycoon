local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiAnimations = require(ReplicatedStorage.Utils.GuiAnimations)
local SoundHandler = require(ReplicatedStorage.Modules.SoundHandler)

local TargetInstance = script.Parent

for _, button in TargetInstance:GetDescendants() do
	if button:IsA("GuiButton") then
		ConfigureButton(button)
	end
end

TargetInstance.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("GuiButton") then
		ConfigureButton(descendant)
	end
end)

function ConfigureButton(button: GuiButton)
	GuiAnimations.ButtonAnimation(button)
	button.MouseButton1Down:Connect(function(x, y)
		SoundHandler.Play("UIClick2")
	end)
end