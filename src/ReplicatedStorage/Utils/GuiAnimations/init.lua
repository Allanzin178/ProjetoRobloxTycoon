local GuiAnimations = {}
local AnimationsList = {}

function GuiAnimations.Start()
	for _, module in ipairs(script:GetChildren()) do
		if module:IsA("ModuleScript") then
			local moduleScript = require(module)
			AnimationsList[module.Name] = moduleScript
		end
	end
end

GuiAnimations.Start()

function GuiAnimations.Expand(guiObject: GuiBase, duration: number, expandRatio: number)
	AnimationsList["ExpandAnimation"].Animate(guiObject, duration, expandRatio)	
end

function GuiAnimations.ButtonAnimation(button: GuiButton)
	AnimationsList["ButtonAnimation"].Animate(button)
end

function GuiAnimations.ValueAnimation(textLabel: TextLabel, targetValue: number)
	AnimationsList["ValueAnimation"].Animate(textLabel, targetValue)
end

return GuiAnimations


