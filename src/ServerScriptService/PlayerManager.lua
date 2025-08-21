local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local PlayerData = DataStoreService:GetDataStore("PlayerData")

local Events = ReplicatedStorage.Events

local function Reconcile(source, template)
	for k, v in pairs(template) do
		if not source[k] then
			source[k] = v
			if typeof(v) == "table" then
				Reconcile(source[k], v)
			end
		end
	end
end

local function LeaderboardSetup(valueCash, valueTimePlayed)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = valueCash
	cash.Parent = leaderstats
	
	local timePlayed = Instance.new("IntValue")
	timePlayed.Name = "Time Played"
	timePlayed.Value = valueTimePlayed
	timePlayed.Parent = leaderstats
	return leaderstats
end

local function LoadData(player)
	local success, result = pcall(function()
		return PlayerData:GetAsync(player.UserId)
	end)
	if not success then
		warn(result)
	end
	return success, result
end

local function SaveData(player, data)
	local success, result = pcall(function()
		PlayerData:SetAsync(player.UserId, data)
	end)
	if not success then
		warn(result)
	end
	return success
end

local function CopyTable(original)
	local copy = {}
	-- index e valor
	for k, v in pairs(original) do
		if typeof(v) == "table" then
			copy[k] = CopyTable(v)
		else
			copy[k] = v
		end
	end
	
	return copy
end

local sessionData = {}
local defaultPlayerData = {
	Cash = 100,
	CosmicCoins = 0,
	TimePlayed = 0,
	UnlockIds = {},
	UpgradeIds = {},
	TycoonConfig = {
		BankCash = 0
	},
}

local playerAdded = Instance.new("BindableEvent")
local playerRemoving = Instance.new("BindableEvent")

local PlayerManager = {}

PlayerManager.PlayerAdded = playerAdded.Event
PlayerManager.PlayerRemoving = playerRemoving.Event

function PlayerManager.Start()
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerManager.OnPlayerAdded)(player)
	end
	Players.PlayerAdded:Connect(PlayerManager.OnPlayerAdded)
	Players.PlayerRemoving:Connect(PlayerManager.OnPlayerRemoving)
	
	TextChatService.ClearData.Triggered:Connect(function(textsource: TextSource)
		local player = Players:GetPlayerByUserId(textsource.UserId)
		PlayerManager.ClearData(player)
	end)

	TextChatService.ResetUpgrades.Triggered:Connect(function(textsource: TextSource)
		local player = Players:GetPlayerByUserId(textsource.UserId)
		PlayerManager.ResetUpgrades(player)
	end)
	
	PlayerManager.BindToClose(PlayerManager.OnClose)
end

function PlayerManager.OnPlayerAdded(player)
	local success, data = LoadData(player)
	
	local dataTable = if success and data then data else {}
	
	Reconcile(dataTable, CopyTable(defaultPlayerData))
	
	sessionData[player.UserId] = dataTable
	
	Events["Server-Client"].CashChange:FireClient(player, sessionData[player.UserId].Cash)
	Events["Server-Client"].CosmicCoinsChange:FireClient(player, sessionData[player.UserId].CosmicCoins)
	
	local leaderstats = LeaderboardSetup(PlayerManager.GetCash(player), PlayerManager.GetTimePlayed(player))
	leaderstats.Parent = player
	
	playerAdded:Fire(player)
end

function PlayerManager.OnPlayerRemoving(player)
		
	playerRemoving:Fire(player)
	task.wait(0.05)
	SaveData(player, sessionData[player.UserId])
end

function PlayerManager.BindToClose(callback)
	game:BindToClose(callback)
end

-- / Get e set cash
function PlayerManager.GetCash(player: Player)
	return sessionData[player.UserId].Cash
end

function PlayerManager.SetCash(player: Player, value: number)
	if value then
		sessionData[player.UserId].Cash = value
		
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats  then
			local cash = leaderstats:FindFirstChild("Cash")
			if cash then	
				cash.Value = value
			end
		end
		
		Events["Server-Client"].CashChange:FireClient(player, sessionData[player.UserId].Cash)
	end
end

-- / Get e set cosmic coins
function PlayerManager.GetCosmicCoins(player: Player)
	return sessionData[player.UserId].CosmicCoins
end

function PlayerManager.SetCosmicCoins(player: Player, value: number)
	if value then
		sessionData[player.UserId].CosmicCoins = value
		
		Events["Server-Client"].CosmicCoinsChange:FireClient(player, sessionData[player.UserId].CosmicCoins)
	end
end

-- / Currency functions
PlayerManager.CurrencyFunctions = {
	Coins = {
		GetCurrency = PlayerManager.GetCash,
		SetCurrency = PlayerManager.SetCash
	},
	CosmicCoins = {
		GetCurrency = PlayerManager.GetCosmicCoins,
		SetCurrency = PlayerManager.SetCosmicCoins
	}
}

-- / Get e set time played
function PlayerManager.GetTimePlayed(player: Player): number
	return sessionData[player.UserId].TimePlayed
end

function PlayerManager.SetTimePlayed(player: Player, value: number)
	if value then
		sessionData[player.UserId].TimePlayed = value
		
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats  then
			local timePlayed = leaderstats:FindFirstChild("Time Played")
			if timePlayed then	
				timePlayed.Value = value
			end
		end
	end
end

-- / Get e set unlock ids
function PlayerManager.GetUnlockIds(player: Player)
	return sessionData[player.UserId].UnlockIds
end

function PlayerManager.AddUnlockId(player: Player, id: string)
	local data = sessionData[player.UserId]
	
	if not table.find(data.UnlockIds, id) then
		table.insert(data.UnlockIds, id)
	end
end



-- / Get e set bankcash
function PlayerManager.GetBankCash(player: Player)
	return sessionData[player.UserId].TycoonConfig.BankCash
end

function PlayerManager.SetBankCash(player: Player, value: number)
	if value then
		sessionData[player.UserId].TycoonConfig.BankCash = value
	end
end

-- / Get e set upgradeIds
function PlayerManager.GetUpgradeIds(player: Player)
	return sessionData[player.UserId].UpgradeIds
end

function PlayerManager.AddUpgradeId(player: Player, id: string)
	local data = sessionData[player.UserId]

	if not table.find(data.UpgradeIds, id) then
		table.insert(data.UpgradeIds, id)
	end
end

function PlayerManager.ResetUpgrades(player: Player)
	local data = sessionData[player.UserId]
	table.clear(data.UpgradeIds)
end
-- / Fim getters e setters

function PlayerManager.ClearData(player: Player)
	table.clear(sessionData[player.UserId].UnlockIds)
	sessionData[player.UserId] = CopyTable(defaultPlayerData)
	
	print(sessionData[player.UserId])
	
	Events["Server-Client"].CashChange:FireClient(player, sessionData[player.UserId].Cash)
	Events["Server-Client"].CosmicCoinsChange:FireClient(player, sessionData[player.UserId].CosmicCoins)
	
	-- Talvez exista maneiras mais eficientes, mas essa foi a que eu pensei
	Events["Server-Server"].UnoccupySpawn:Fire(player)
	
	SaveData(player, sessionData[player.UserId])
	
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats  then
		local cash = leaderstats:FindFirstChild("Cash")
		if cash then	
			cash.Value = sessionData[player.UserId].Cash
		end
	end
end


function PlayerManager.OnClose()
	if RunService:IsStudio() then
		print("Ta no studio")
		-- Avoid writing studio data to production and stalling test session closing
		return
	end
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerManager.OnPlayerRemoving)(player)
	end
end

ReplicatedStorage.Functions.GetPlayerTimePlayed.OnServerInvoke = function(player: Player): number
	return PlayerManager.GetTimePlayed(player)
end

return PlayerManager
