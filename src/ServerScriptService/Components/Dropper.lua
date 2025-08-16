local dropsFolder = game:GetService("ServerStorage").Drops
local Debris = game:GetService("Debris")
local ps = game:GetService("PhysicsService")
local SoundHandler = require(game:GetService("ReplicatedStorage").Modules.SoundHandler)

local Dropper = {}
Dropper.__index = Dropper

function Dropper.new(tycoon, instance: Instance)
	local self = setmetatable({}, Dropper)
	
	self.Tycoon = tycoon
	self.Instance = instance
	self.Rate = instance:GetAttribute("Rate") or 1
	
	self.DropTemplate = dropsFolder[instance:GetAttribute("Drop")]	
	self.DropSpawn = instance.Spout.Spawn
	self.WorthTemplate = dropsFolder["WorthNumber"]
	
	self.ShinyMultiplier = 1.5
	self.IsAbleToPlaySfx = true
	
	return self
end

function Dropper:Init()
	
	self:RegisterCollisionGroup("OreGroup")
	
	coroutine.wrap(function()
		while self.Instance.Parent == self.Tycoon.Model do
			self:Drop()
			wait(self.Rate)
		end
	end)()
end

function Dropper:Drop()
	
	local drop = self.DropTemplate:Clone()
	local gacha = math.random(1, 100)
	local worth = drop:GetAttribute("Worth")
	
	if gacha <= 1 then
		worth = worth * self.ShinyMultiplier
		drop:SetAttribute("Worth", worth)
		
		drop.Name = drop.Name .. "Shiny"
		
		local highlight = Instance.new("Highlight")
		highlight.FillTransparency = 1
		highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		highlight.Parent = drop
		highlight.OutlineColor = Color3.new(1, 1, 0)
	end
	
	local worthNumber: BillboardGui = self.WorthTemplate:Clone()
	worthNumber.Adornee = drop
	worthNumber.Parent = drop
	worthNumber.TextLabel.Text = "$" .. math.round(worth)
	
	drop.CollisionGroup = "OreGroup"
	drop.Position = self.DropSpawn.WorldPosition
	drop.Parent = self.Instance
	
	drop:SetNetworkOwner(self.Tycoon.Owner)
	
	if self.IsAbleToPlaySfx then
		SoundHandler.Play("Pop", { Parent = self.Instance:WaitForChild("Spout") })
	end
	
	
	Debris:AddItem(drop, 10)
end

function Dropper:RegisterCollisionGroup(name: string)
	ps:RegisterCollisionGroup(name)
	ps:CollisionGroupSetCollidable(name, name, false)
	ps:CollisionGroupSetCollidable(name, "Players", false)
end

return Dropper
