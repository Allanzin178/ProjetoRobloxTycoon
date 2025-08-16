local Rewards = require(script.Rewards)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpinnerEvent = ReplicatedStorage.Events["Server-Client"].Spinner

local Spinner = {}
Spinner.__index = Spinner

local minSpinDuration = 4
local maxSpinDuration = 6

local minRotations = 3
local maxRotations = 5


function Spinner.new(tycoon, instance: Instance)
	local self = setmetatable({}, Spinner)
	self.Tycoon = tycoon
	self.Instance = instance
	self.Cooldown = 10
	self.Roleta = self.Instance.Roleta
	self.RoletaCentro = self.Instance.Roleta["Parte do centro"]

	return self
end


function Spinner:Init()
	self.SpinnerInfo = self:GetSpinnerInfo()
	self:WeldSlicesWithCenter()
	coroutine.wrap(function()
		while self.Instance.Parent == self.Tycoon.Model do 
			self:Spin()
			task.wait(self.Cooldown)
		end
	end)()
end

function Spinner:Spin()
	local spinDuration = math.random(minSpinDuration, maxSpinDuration)
	local numRotations = math.random(minRotations, maxRotations)
	
	local spinnerInfo = self.SpinnerInfo
	local reward = Rewards.Roll()
	
	local rewardOccorrences = {}
	
	for index, value in ipairs(spinnerInfo) do
		if value.Reward == reward.name then
			if rewardOccorrences[reward.name] then
				rewardOccorrences[reward.name].Times += 1
				
				table.insert(rewardOccorrences[reward.name].Indexes, index)
			else
				rewardOccorrences[reward.name] = {}
				rewardOccorrences[reward.name].Times = 1
				rewardOccorrences[reward.name].Indexes = {}
				table.insert(rewardOccorrences[reward.name].Indexes, index)
			end
		end
	end
	
	local rewardSlice: {Interval: NumberRange, Reward: string}
	
	-- Verifica se existe mais de uma fatia na roleta com a mesma recompensa
	if #rewardOccorrences[reward.name].Indexes > 1 then
		-- Se sim, pega uma fatia aleatoria com a recompensa
		local randomIndex = rewardOccorrences[reward.name].Indexes[math.random(1, #rewardOccorrences[reward.name].Indexes)]
		rewardSlice = spinnerInfo[randomIndex]
	else
		rewardSlice = spinnerInfo[rewardOccorrences[reward.name].Indexes[1]]
	end
	
	local sliceAngle = GetRandomAngleFromSlice(rewardSlice.Interval)
	
	local spinnerRotation = (360 * numRotations) + sliceAngle -- 360 * 3 + 89 = 1169
	
	self.LastSpin = self.LastSpin or 0
	
	local spinOffset = (360 - (self.LastSpin % 360))
	
	local totalRotation = spinnerRotation + spinOffset
	
	local roletaCentro: BasePart = self.RoletaCentro
	local pai: Model = roletaCentro.Parent
	
	
	task.spawn(function()
		SpinnerEvent:FireClient(
			self.Tycoon.Owner, 
			self.Roleta,
			totalRotation,
			spinDuration,
			numRotations,
			spinnerInfo.AnglePerSlice
		)
		
		print(reward.name)
		
		task.wait(spinDuration + 2)
		if reward.callback then
			reward.callback(self.Tycoon)
		end
		
		pai:PivotTo(pai:GetPivot() * CFrame.Angles(math.rad(-(totalRotation)), 0, 0))
	end)
	
	
	self.LastSpin = spinnerRotation
	
end

function GetRandomAngleFromSlice(numberInterval: NumberRange)
	return math.random(numberInterval.Min, numberInterval.Max)
end

function Spinner:GetSpinnerInfo()
	local spinnerInside: Model = self.Roleta:WaitForChild("Dentro")
	
	local info = {}
	
	local numberOfSlices = #spinnerInside:GetChildren()
	local anglePerSlice = 360 / numberOfSlices
	
	for i, instance: Instance in ipairs(spinnerInside:GetChildren()) do
		local textLabel: TextLabel = instance.Part.SurfaceGui:FindFirstChild("TextLabel")
		if textLabel then
			--print(textLabel.Text)
		end
		info[i] = {}
		info[i].Reward = instance:GetAttribute("Reward")
		info[i].Interval = NumberRange.new((anglePerSlice * i) - anglePerSlice, (anglePerSlice * i) - 1)
	end
	
	info.NumOfSlices = numberOfSlices
	info.AnglePerSlice = anglePerSlice
	
	return info
end

function Spinner:WeldSlicesWithCenter()
	local spinnerInside: Model = self.RoletaCentro
	
	for _, v: BasePart in ipairs(self.Roleta:GetDescendants()) do
		if v.Name == spinnerInside.Name then
			continue
		end
		
		if not v:IsA("BasePart") then
			continue
		end
		
		v.Anchored = false
		
		
		local weldConstraint = Instance.new("WeldConstraint")
		weldConstraint.Parent = spinnerInside
		weldConstraint.Part0 = spinnerInside
		weldConstraint.Part1 = v
	end
end

return Spinner
