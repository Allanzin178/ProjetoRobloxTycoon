local RS = game:GetService("ReplicatedStorage")
local RagdollEvent = RS.Events["Server-Client"].Ragdoll
local Player = game.Players.LocalPlayer

local function onRagdoll(enabled: boolean)
	local character = Player.Character or Player.CharacterAdded:Wait()
	local hum = character:FindFirstChildOfClass("Humanoid")
	
	if not enabled then
		hum.AutoRotate = true
		hum.PlatformStand = false
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	else
		hum.AutoRotate = false
		hum.PlatformStand = true
	end
end

RagdollEvent.OnClientEvent:Connect(onRagdoll)