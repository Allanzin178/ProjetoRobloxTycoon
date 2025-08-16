local SpawnStorage = game:GetService("ServerStorage").SpawnStorage
local Tycoon = require(game:GetService("ServerScriptService").Tycoon)
local sfx = game:GetService("SoundService").SoundEffects

local Spawn = {}
Spawn.__index = Spawn

function Spawn.new(spawnModel: Model, spawnHandler)
	local self = setmetatable({}, Spawn)	
	self.SpawnModel = spawnModel
	self.SpawnLocation = spawnModel.Spawn
	self.Placa = spawnModel.Placa
	self.Pad = spawnModel.Pad
	self.Montanha = spawnModel.Montanha2Fechada.Montanha
	
	self.SpawnHandler = spawnHandler

	return self
end

function Spawn:Init()

	self:Unoccupy()
	
	self.Pad.Touched:Connect(function(hitPart)
		local player = game:GetService("Players"):GetPlayerFromCharacter(hitPart.Parent)
		
		if player and not self.SpawnModel:GetAttribute("Occupied") then
			
			if self.SpawnHandler.IsPlayerOccupying(player) then
				warn("Você já esta ocupando um tycoon!")
				return
			end
			
			self:Occupy(player)
		end
	end)
	
end

function Spawn:Occupy(player: Player)
	self.SpawnModel:SetAttribute("Occupied", true)
	self.Placa.Cima.SurfaceGui.TextLabel.Text = player.Name
	self.SpawnLocation.Transparency = 1
	self.SpawnLocation.CanCollide = false
	self.Pad.CanCollide = false
	self.Pad.CanTouch = false
	self.Pad.Transparency = 1
	self.Montanha.Transparency = 1
	self.Montanha.CanCollide = false
	self.Montanha.Parent = SpawnStorage
	
	self.Tycoon = Tycoon.new(player, self)
	self.Tycoon:Init()
	
	self.SpawnHandler.AddPlayerSpawn(player, self)
	
	sfx.Construction:Play()
end

function Spawn:Unoccupy(player: Player)
	self.SpawnModel:SetAttribute("Occupied", false)
	self.SpawnLocation.Transparency = 0
	self.SpawnLocation.CanCollide = true
	self.Placa.Cima.SurfaceGui.TextLabel.Text = "Empty"
	self.Pad.Transparency = 0
	self.Pad.CanTouch = true
	self.Pad.CanCollide = true
	self.Montanha.Transparency = 0
	self.Montanha.CanCollide = true
	self.Montanha.Parent = self.SpawnModel.Montanha2Fechada
	
	if player then
		self.SpawnHandler.RemovePlayerSpawn(player)
		if self.Tycoon then
			self.Tycoon:Destroy(player)
		end
	end
	
end

return Spawn
