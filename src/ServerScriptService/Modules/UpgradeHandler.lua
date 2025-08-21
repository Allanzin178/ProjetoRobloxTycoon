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

function UpgradeHandler.UnlockUpgrade(player: Player, upgradeId: string): boolean & string
	-- TODO: Verificação se o player ja tem o upgrade, e se ele tem o dinheiro necessario
	local resposta = "Operação deu errado"

	-- Verificação se existe o upgrade com o id passado:
	local upgrade = UpgradeService.GetById(upgradeId)
	if not upgrade then
		resposta = "Upgrade não existe"
		return false, resposta
	end

	-- Pega os Ids do usuario e verifica se ja tem um com o mesmo nome la
	local upgrades = PlayerManager.GetUpgradeIds(player)
	if table.find(upgrades, upgradeId) then
		resposta = "O player já tem o upgrade"
		return false, resposta
	end

	-- Verifica se o usuario tem dinheiro para o upgrade
	local currencyType = upgrade.Value.Currency
	

	PlayerManager.AddUpgradeId(player, upgradeId)
	print("Upgrades:", upgrades)
	return true
end

function UpgradeHandler.GetAllUpgrades(): boolean
	-- TODO: Melhorar para informar os upgrades desbloqueados
	return UpgradeService.GetAll()
end

return UpgradeHandler
