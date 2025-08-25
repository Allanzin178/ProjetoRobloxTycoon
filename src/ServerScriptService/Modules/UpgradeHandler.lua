local SCS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")

local Functions = RS.Functions

local PlayerManager = require(SCS.PlayerManager)
local UpgradeService = require(SCS.Configs.UpgradeService)
local SoundHandler = require(RS.Modules.SoundHandler)

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
	-- Resposta generica para caso o return nao especifique uma
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

	-- TODO: terminar logica de verificar se o player tem o unlockId requirido
	local unlocks = PlayerManager.GetUnlockIds(player)
	
	-- Pega o tipo de moeda necessário para comprar o upgrade
	local currencyType = upgrade.Value.Currency

	-- Puxa as funções get e set dessa moeda
	if not PlayerManager.CurrencyFunctions[currencyType] then
		resposta = "Não existem funções para a moeda " .. currencyType
		return false, resposta
	end
	local currencyFunctions = PlayerManager.CurrencyFunctions[currencyType]

	-- Informações (quantidade de moedas que o player tem e quantidade de moedas que o upgrade pede)
	local playerCurrency = currencyFunctions.GetCurrency(player)
	local upgradeValue = upgrade.Value.Quantity

	-- Verifica se o usuario tem dinheiro para o upgrade
	if playerCurrency < upgradeValue then
		resposta = string.format("Não tens a quantidade de %s necessária para comprar o upgrade! (%d)", currencyType, upgradeValue)
		return false, resposta
	end

	SoundHandler.SendSoundToClient(player, "Money")
	currencyFunctions.SetCurrency(player, playerCurrency - upgradeValue)
	PlayerManager.AddUpgradeId(player, upgradeId)
	return true
end

function UpgradeHandler.GetAllUpgrades(): boolean
	-- TODO: Melhorar para informar os upgrades desbloqueados
	return UpgradeService.GetAll()
end

function _loadUpgrade(upgradeId: string)
	local upgrade = UpgradeService.GetById(upgradeId)
	if not upgrade then
		return nil
	end

	
end
return UpgradeHandler
