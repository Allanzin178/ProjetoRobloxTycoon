local CAS = game:GetService("ContextActionService")
local player = game.Players.LocalPlayer

local chr = player.Character
local humanoid

local NORMAL_SPEED = 26
local RUN_SPEED_DEFAULT = 36
local MAX_MOMENTUM = 100
local MIN_MOMENTUM = 0

local isRunning = false

local function running(momentum)
	if isRunning == true then
		if momentum >= MAX_MOMENTUM then
			momentum = MAX_MOMENTUM
		end
		humanoid.WalkSpeed = RUN_SPEED_DEFAULT + (momentum / 10)
		task.wait(0.1)
		running(momentum + 3)
	end
end

local function onRunAction(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		isRunning = true
		running(MIN_MOMENTUM)
	elseif inputState == Enum.UserInputState.End then
		isRunning = false
		humanoid.WalkSpeed = NORMAL_SPEED
	end
end

local function configPlayer(character)
	if not character then return end
	chr = character
	humanoid = character:WaitForChild("Humanoid")
	
	humanoid.WalkSpeed = NORMAL_SPEED
	
	CAS:BindAction("Run", onRunAction, true, Enum.KeyCode.LeftShift)
end

player.CharacterAdded:Connect(configPlayer)

configPlayer(chr)



