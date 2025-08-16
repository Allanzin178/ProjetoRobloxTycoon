local TweenService = game:GetService("TweenService")

local module = {}

function module.Animate(guiObject: GuiBase, duration: number, expandRatio: number)
	if not expandRatio then
		expandRatio = 1.1
	end

	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
	local tweenInfo2 = TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

	local OgSize = guiObject.Size

	local tween = TweenService:Create(guiObject, tweenInfo, {
		Size = UDim2.new(
			OgSize.X.Scale * expandRatio, 
			0, 
			OgSize.Y.Scale * expandRatio, 
			0
		)
	})

	local tween2 = TweenService:Create(guiObject, tweenInfo2, {
		Size = OgSize
	})

	tween:Play()
	local connection = tween.Completed:Connect(function()
		tween2:Play()
	end)

	guiObject.Destroying:Once(function()
		connection:Disconnect()
	end)
end

return module


