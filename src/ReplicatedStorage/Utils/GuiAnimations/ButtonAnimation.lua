local TweenService = game:GetService("TweenService")

local BtnAnimation = {}

function BtnAnimation.Animate(button: GuiButton)
	local OgSize = button.Size
	
	local InfoClick = TweenInfo.new(0.05)
	local InfoHover = TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	
	local SizeClick = UDim2.fromScale(OgSize.X.Scale * 0.9, OgSize.Y.Scale * 0.9)
	local SizeHover = UDim2.fromScale(OgSize.X.Scale * 1.06, OgSize.Y.Scale * 1.06)
	
	local connection = button.MouseButton1Down:Connect(function(x, y)
		BtnAnimation.ClickCircle(button, x, y)
		BtnAnimation.CreateTween(button, InfoClick, {Size = SizeClick})
	end)
	
	local connection1 = button.MouseButton1Up:Connect(function(x, y)
		
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

function BtnAnimation.CreateTween(instance: Instance, info: TweenInfo, properties: {})
	local tween = TweenService:Create(instance, info, properties)
	tween:Play()
	return tween
end

-- / Animação circulo
function BtnAnimation.ClickCircle(button: GuiButton, x: number, y: number)
	local initSize = 20 -- Pixels
	local initTransparency = 0.35 -- Entre 0 e 1

	local finalSize = 50 -- Pixels
	local finalTransparency = 1 -- Entre 0 e 1

	local circle = _createCircle(initSize, initTransparency) -- Cria o efeito do clique
	local clickScreenGui = _getClickScreenGui(button) -- Pega a screengui que armazenará os cliques

	circle.Parent = clickScreenGui -- Aloca o efeito para dentro do screengui
	circle.Position = UDim2.fromOffset(x, y) -- Muda a posição do efeito para a posição do clique

	local InfoSize = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local InfoTransparency = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

	local tweenSize = BtnAnimation.CreateTween(circle, InfoSize, {Size = UDim2.fromOffset(finalSize, finalSize)})
	local tweenTransparency = BtnAnimation.CreateTween(circle, InfoTransparency, {Transparency = finalTransparency})

	local connection 
	connection = tweenTransparency.Completed:Connect(function()
		circle:Destroy()
		connection:Disconnect()
	end)
end

function _createCircle(initSize: number, initTransparency: number)
	local circleColor = Color3.new(1, 1, 1) -- Cor do circulo

	local circle = Instance.new("Frame")
	circle.Size = UDim2.fromOffset(initSize, initSize)
	circle.BackgroundTransparency = initTransparency
	circle.AnchorPoint = Vector2.new(0.5, 0.5) 
	circle.BackgroundColor3 = circleColor
	circle.ZIndex = 10
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = circle

	local aspectRatio = Instance.new("UIAspectRatioConstraint")
	aspectRatio.AspectRatio = 1
	aspectRatio.Parent = circle
	
	return circle
end

function _getClickScreenGui(instance: Instance)
	local playerGui = instance:FindFirstAncestorOfClass("PlayerGui")
	local screenGui = playerGui:FindFirstChild("ClickEffect") or Instance.new("ScreenGui")

	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui
	screenGui.DisplayOrder = 100
	screenGui.Name = "ClickEffect"

	return screenGui
end

return BtnAnimation
