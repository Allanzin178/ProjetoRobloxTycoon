local TweenService = game:GetService("TweenService")

local BtnAnimation = {}

function BtnAnimation.Animate(button: GuiButton)
	local OgSize = button.Size
	
	local InfoClick = TweenInfo.new(0.05)
	local InfoHover = TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	
	local SizeClick = UDim2.fromScale(OgSize.X.Scale * 0.9, OgSize.Y.Scale * 0.9)
	local SizeHover = UDim2.fromScale(OgSize.X.Scale * 1.06, OgSize.Y.Scale * 1.06)
	
	local connection = button.MouseButton1Down:Connect(function()
		print("clicou")
		BtnAnimation.CreateTween(button, InfoClick, {Size = SizeClick})
	end)
	
	local connection1 = button.MouseButton1Up:Connect(function()
		print("soltou")
		BtnAnimation.CreateTween(button, InfoClick, {Size = SizeHover})
	end)
	
	local connection2 = button.MouseEnter:Connect(function()
		print("passou o mouse encima")
		BtnAnimation.CreateTween(button, InfoHover, {Size = SizeHover})
	end)
	
	local connection3 = button.MouseLeave:Connect(function()
		BtnAnimation.CreateTween(button, InfoHover, {Size = OgSize})
	end)
	
	button.Destroying:Once(function()
		connection:Disconnect()
		connection1:Disconnect()
		connection2:Disconnect()
		connection3:Disconnect()
	end)
end

function BtnAnimation.CreateTween(button: GuiButton, info: TweenInfo, properties: {[string]: UDim2})
	local tween = TweenService:Create(button, info, properties)
	tween:Play()
	return tween
end

return BtnAnimation
