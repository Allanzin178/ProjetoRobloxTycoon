local Players = game:GetService("Players")
local RagdollData = require(script.RagdollData)
local RagdollEvent = game:GetService("ReplicatedStorage").Events["Server-Client"].Ragdoll

local RagdollUtil = {}

_RagdollTimers = {}

function RagdollUtil.Start()
	Players.PlayerAdded:Connect(function(plr)
		plr.CharacterAdded:Connect(function(chr)
			RagdollUtil.SetupHumanoid(chr:WaitForChild("Humanoid"))
			RagdollUtil.BuildCollisionParts(chr)
		end)
	end)

	for _, player in pairs(Players:GetPlayers()) do
		if player.Character then
			RagdollUtil.SetupHumanoid(player.Character:WaitForChild("Humanoid"))
			RagdollUtil.BuildCollisionParts(player.Character)
		end
		
		player.CharacterAdded:Connect(function(chr)
			RagdollUtil.SetupHumanoid(chr:WaitForChild("Humanoid"))
			RagdollUtil.BuildCollisionParts(chr)
		end)
	end
	
	for _, chr in pairs(workspace:GetChildren()) do
		if chr:IsA("Model") then
			if chr:FindFirstChildOfClass("Humanoid") then
				RagdollUtil.SetupHumanoid(chr:WaitForChild("Humanoid"))
				RagdollUtil.BuildCollisionParts(chr)
			end
		end
	end
end

function RagdollUtil.SetupHumanoid(hum: Humanoid)
	hum.BreakJointsOnDeath = false
	hum.RequiresNeck = false
end

function RagdollUtil.BuildCollisionParts(char: Model)
	for _, part in pairs(char:GetChildren()) do
		if part:FindFirstChild("Collide") then
			continue
		end
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			local collide = part:Clone()
			collide.Parent = part
			collide.CanCollide = false
			collide.Massless = true
			collide.Size = Vector3.one
			collide.Name = "Collide"
			collide.Transparency = 1
			collide:ClearAllChildren()
			
			local weld = Instance.new("Weld")
			weld.Parent = collide
			weld.Part0 = part
			weld.Part1 = collide
			
		end
	end
end

function RagdollUtil.RagdollCharacter(char: Model, duration: number?)
	
	local plr = Players:GetPlayerFromCharacter(char)
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	
	if not hrp then
		return
	end
	
	RagdollUtil.BuildJoints(char)
	RagdollUtil.EnableMotor6D(char, false)
	RagdollUtil.EnableCollisionParts(char, true)
	
	if plr then
		RagdollEvent:FireClient(plr, true)
	else
		hrp:SetNetworkOwner(nil)
		hum.AutoRotate = false
		hum.PlatformStand = true
	end
	
	if not duration then
		return
	end

	if _RagdollTimers[char] then
		coroutine.close(_RagdollTimers[char])
	end
	
	_RagdollTimers[char] = coroutine.create(function()
		task.wait(duration)
		RagdollUtil.UnragdollCharacter(char)
	end)
	coroutine.resume(_RagdollTimers[char])

end

function RagdollUtil.UnragdollCharacter(char: Model)

	local plr = Players:GetPlayerFromCharacter(char)
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")

	if plr then
		RagdollEvent:FireClient(plr, false)
	else
		hrp:SetNetworkOwner(nil)
		hum.PlatformStand = false
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
	
	RagdollUtil.DestroyJoints(char)
	RagdollUtil.EnableMotor6D(char, true)
	RagdollUtil.EnableCollisionParts(char, false)

	hum.AutoRotate = true
end

function RagdollUtil.EnableMotor6D(char: Model, enabled: boolean)
	for _, v in pairs(char:GetDescendants()) do
		
		if v.Name == "Handle" or v.Name == "RootJoint" or v.Name == "Neck" or v.Name == "Root" or v.Name == "ToolGrip" then 
			continue 
		end
		
		if v:IsA("Motor6D") then 
			v.Enabled = enabled 
		end
		--if v:IsA("BasePart") then v.CollisionGroup = if enabled then "Character" else "Ragdoll" end
	end
end

function RagdollUtil.EnableCollisionParts(char: Model, enabled: boolean)
	for _, v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.CanCollide = not enabled
			v.Collide.CanCollide = enabled
		end
	end
end

function RagdollUtil.BuildJoints(char: Model)
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	
	for _, v in pairs(char:GetDescendants()) do
		if not v:IsA("BasePart") or v:FindFirstAncestorOfClass("Accessory") or v.Name == "Handle" or v.Name == "Torso" or v.Name == "HumanoidRootPart" then 
			continue 
		end
		
		if not RagdollData[v.Name] then 
			continue 
		end
		
		if v:FindFirstChild("RAGDOLL_CONSTRAINT") then
			continue
		end
		
		local a0: Attachment = Instance.new("Attachment")
		local a1: Attachment = Instance.new("Attachment")
		
		local joint: BallSocketConstraint = Instance.new("BallSocketConstraint")
		
		a0.Name = "RAGDOLL_ATTACHMENT"
		a0.Parent = v
		a0.CFrame = RagdollData[v.Name].CFrame[2]
		
		a1.Name = "RAGDOLL_ATTACHMENT"
		a1.Parent = hrp
		a1.CFrame = RagdollData[v.Name].CFrame[1]
		
		joint.Name = "RAGDOLL_CONSTRAINT"
		joint.Parent = v
		joint.Attachment0 = a0
		joint.Attachment1 = a1
		
		v.Massless = true
	end
	
end

function RagdollUtil.DestroyJoints(char: Model)
	char.HumanoidRootPart.Massless = false
	
	for _, v in pairs(char:GetDescendants()) do
		if v.Name == "RAGDOLL_ATTACHMENT" or v.Name == "RAGDOLL_CONSTRAINT" then
			v:Destroy()
		end
		
		if not v:IsA("BasePart") or v:FindFirstAncestorOfClass("Accessory") or v.Name == "Torso" or v.Name == "Head" then
			continue
		end
	end
end

return RagdollUtil
