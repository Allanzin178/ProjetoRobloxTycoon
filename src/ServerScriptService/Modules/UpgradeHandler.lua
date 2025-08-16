local SCS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")

local Functions = RS.Functions

local PlayerManager = require(SCS.PlayerManager)
local UpgradeService = require(SCS.Configs.UpgradeService)

--[[
	Logica:
		O servidor vai ter uma lista de upgrades
		(Configs.Upgrades)
		Cada upgrade vai ter um ID, um nome, um custo, um tipo e um valor
		O cliente vai mandar o ID do upgrade que ele quer comprar
		O servidor vai verificar se o jogador tem dinheiro suficiente
		Se tiver, ele vai subtrair o dinheiro do jogador e adicionar o upgrade na lista dele
		O servidor vai mandar pro cliente o nome do upgrade que ele comprou para atualizar a UI
		
		Esse modulo fica responsavel por gerenciar esse fluxo e atualizar a lista de upgrades do player no player manager
]]

local UpgradeHandler = {}

function UpgradeHandler:Init()
	UpgradeHandler.ListenInvoke()
	
	
end

function UpgradeHandler.ListenInvoke()
	Functions.TryBuyUpgrade.OnServerInvoke = UpgradeHandler.UnlockUpgrade
	
	Functions.GetAllUpgrades.OnServerInvoke = UpgradeHandler.GetAllUpgrades
end

function UpgradeHandler.UnlockUpgrade(player:Player, upgradeId: string): boolean
	
end

function UpgradeHandler.GetAllUpgrades(): boolean
	return UpgradeService.GetAll()
end

return UpgradeHandler
