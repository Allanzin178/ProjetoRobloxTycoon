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
	if not(guiObject or duration) then
		warn("Informações essenciais para a animação estao faltando")
		return
	end
	AnimationsList["ExpandAnimation"].Animate(guiObject, duration, expandRatio)	
end

function GuiAnimations.ButtonAnimation(button: GuiButton)
	if not(button) then
		warn("Informações essenciais para a animação estao faltando")
		return
	end
	AnimationsList["ButtonAnimation"].Animate(button)
end

function GuiAnimations.ValueAnimation(textLabel: TextLabel, targetValue: number)
	if not(textLabel or targetValue) then
		warn("Informações essenciais para a animação estao faltando")
		return
	end
	AnimationsList["ValueAnimation"].Animate(textLabel, targetValue)
end

return GuiAnimations


