local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

local function childAdded(object)
	if object:IsA("Tool") then
		local handle = object:FindFirstChild("Handle")
		if handle then
			local rightArm = character:FindFirstChild("Right Arm")
			
			if rightArm then
				local rightGrip = rightArm:FindFirstChild("RightGrip")
				if rightGrip then
					rightGrip.Enabled = false
					local motor = Instance.new("Motor6D")
					motor.Name = "ToolGrip"
					motor.Part0 = rightArm
					motor.Part1 = handle
					motor.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(-math.pi/2,0,0)
					motor.C1 = object.Grip
					motor.Parent = rightArm
					repeat 
						rightGrip.AncestryChanged:Wait()
					until rightGrip ~= rightArm
					motor:Destroy()
				end
			end
		end
	end
end

character.ChildAdded:Connect(childAdded)