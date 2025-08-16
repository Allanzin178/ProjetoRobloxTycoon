--[[
	The spin code animation was inspired by
	Daily Spin Gui by HowToRoblox
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpinnerEvent = ReplicatedStorage.Events["Server-Client"].Spinner
local RunService = game:GetService("RunService")

local TweenService = game:GetService("TweenService")

local function spinFunction(x: number)

	local y = math.sqrt(1 - math.pow(x - 1, 2))

	return y
end

local function onSpin(roleta: Model, totalRotation: number, spinDuration: number, numRotation: number, anglePerPrize: number)
	if not roleta.PrimaryPart then
		warn("PrimaryPart não definido para o modelo:", roleta.Name)
		return
	end
	
	local primaryPart = roleta.PrimaryPart
	local baseCFrame = primaryPart.CFrame
	local loopStart = time()
	
	local lastAnglePlayedSound
	
	while true do
		local now = time()
		local timeSinceStarted = now - loopStart
		
		local x = timeSinceStarted / spinDuration
		local y = spinFunction(x)
		
		local newAngle = y * totalRotation
		
		primaryPart.CFrame = baseCFrame * CFrame.Angles(math.rad(-newAngle), 0, 0)

		if script:FindFirstChild("SpinSound") then

			if math.floor(newAngle / anglePerPrize) ~= lastAnglePlayedSound then

				local margin = 5
				local playSound = newAngle % (anglePerPrize) > anglePerPrize/2 - margin and newAngle % (anglePerPrize) < anglePerPrize/2 + margin

				if playSound then
					lastAnglePlayedSound = math.floor(newAngle / anglePerPrize)

					local newSpinSound = script.SpinSound:Clone()
					newSpinSound.Parent = primaryPart
					newSpinSound:Play()
					
					local connection

					connection = newSpinSound.Ended:Connect(function()
						newSpinSound:Destroy()
						connection:Disconnect()
					end)
				end
			end
		end
		
		if timeSinceStarted >= spinDuration then
			local rewardSound = script.RewardSound:Clone()
			rewardSound.Parent = primaryPart
			rewardSound:Play()

			local connection

			connection = rewardSound.Ended:Connect(function()
				rewardSound:Destroy()
				connection:Disconnect()
			end)
			break
		end
		
		RunService.Heartbeat:Wait()
	end

end




SpinnerEvent.OnClientEvent:Connect(onSpin)