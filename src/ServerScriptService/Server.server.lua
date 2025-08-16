local PlayerManager = require(script.Parent.PlayerManager)
local SpawnHandler = require(script.Parent.Modules.SpawnHandler)
local UpgradeHandler = require(script.Parent.Modules.UpgradeHandler)
local PlayerCGHandler = require(script.Parent.Modules.PlayerCollisionGroupHandler)

local RS = game:GetService("ReplicatedStorage")
local RagdollEvent = RS.Events["Client-Server"].Ragdoll
local KnockbackEvent = RS.Events["Client-Server"].Knockback

local ServerUtils = script.Parent.Utils

local ragdoll = require(ServerUtils.RagdollUtil)
local knockback = require(ServerUtils.KnockbackUtil)


PlayerManager.Start()
SpawnHandler.StartSpawns()
PlayerCGHandler.Start()
UpgradeHandler:Init()

local playerTime = {}



PlayerManager.PlayerAdded:Connect(function(player: Player)
	playerTime[player.UserId] = PlayerManager.GetTimePlayed(player)
	task.spawn(function()
		while true do
			task.wait(1)
			playerTime[player.UserId] = playerTime[player.UserId] + 1

			PlayerManager.SetTimePlayed(player, playerTime[player.UserId])
		end
	end)
end)

ragdoll.Start()

RagdollEvent.OnServerEvent:Connect(function(player: Player, chr: Model)
	ragdoll.RagdollCharacter(chr, 2.5)
end)

KnockbackEvent.OnServerEvent:Connect(function(player: Player, chr: Model, vChr: Model)
	knockback(chr, vChr, 2500)
end)
