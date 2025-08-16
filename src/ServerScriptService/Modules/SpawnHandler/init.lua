local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Spawn = require(script.Spawn)

local Events = ReplicatedStorage.Events

local SpawnHandler = {}
local SpawnList = {}

local playersSpawns = {}

function SpawnHandler.StartSpawns()
	for _, instance in ipairs(CollectionService:GetTagged("Spawn")) do
		if instance:IsA("Model") and instance:FindFirstChild("Spawn") then
			
			local newSpawn = Spawn.new(instance, SpawnHandler)
			newSpawn:Init()
			table.insert(SpawnList, newSpawn)
	
		end
	end	
	
	-- Talvez exista maneiras mais eficientes, mas essa foi a que eu pensei
	SpawnHandler.ListenUnoccupy()
end

function SpawnHandler.GetSpawns()
	return SpawnList
end

function SpawnHandler.AddPlayerSpawn(player: Player, spawn)
	if not playersSpawns[player.UserId] then
		playersSpawns[player.UserId] = {}
	end
	
	playersSpawns[player.UserId].Spawn = spawn
end

function SpawnHandler.RemovePlayerSpawn(player: Player)
	playersSpawns[player.UserId].Spawn = nil
end

function SpawnHandler.GetPlayerSpawn(player: Player)
	if playersSpawns[player.UserId] then
		if playersSpawns[player.UserId].Spawn then
			return playersSpawns[player.UserId].Spawn
		end
	end
end

function SpawnHandler.IsPlayerOccupying(player: Player): boolean
	if not playersSpawns[player.UserId] then
		playersSpawns[player.UserId] = {}
	end 
	-- Se isso for verdadeiro            vai retornar isso       se nao vai retornar isso                 
	return playersSpawns[player.UserId].Spawn and true or false
end


-- Talvez exista maneiras mais eficientes, mas essa foi a que eu pensei
function SpawnHandler.ListenUnoccupy()
	Events["Server-Server"].UnoccupySpawn.Event:Connect(function(player)
		local spawn = SpawnHandler.GetPlayerSpawn(player)
		if spawn then
			spawn:Unoccupy(player)
		end
	end)
end

return SpawnHandler
