local ps = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local PlayerManager = require(script.Parent.Parent.PlayerManager)

local PlayerCGHandler = {}
local _connections = {}

function PlayerCGHandler.Start()
	
	for _, player in pairs(Players:GetPlayers()) do
		PlayerCGHandler.Init(player)
	end
	
	PlayerManager.PlayerAdded:Connect(PlayerCGHandler.Init)
	PlayerManager.PlayerRemoving:Connect(PlayerCGHandler.Destroy)
end

function PlayerCGHandler.Init(player: Player)
	
	local character = player.Character
	
	if not _connections[player.UserId] then
		_connections[player.UserId] = {}
	end
	
	if character then
		PlayerCGHandler.SetCharacterCollisionGroup(character)
	end
	
	local connection = player.CharacterAdded:Connect(function(chr)
		PlayerCGHandler.SetCharacterCollisionGroup(chr)
	end)
	
	table.insert(_connections[player.UserId], connection)
	
end

function PlayerCGHandler.SetCharacterCollisionGroup(chr)
	
	ps:RegisterCollisionGroup("Players")
	
	for _, part in pairs(chr:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CollisionGroup = "Players"
		end
	end
	
end

function PlayerCGHandler.Destroy(player: Player)
	for _, connection in ipairs(_connections[player.UserId]) do
		if typeof(connection) == "RBXScriptConnection" and connection.Connected then
			connection:Disconnect()
		end
	end
end

return PlayerCGHandler
