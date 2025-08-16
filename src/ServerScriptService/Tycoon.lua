local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local template = ServerStorage.Template
local tycoonStorage = ServerStorage.TycoonStorage

local componentFolder = script.Parent.Components
local PlayerManager = require(script.Parent.PlayerManager)

local function NewModel(model, cframe)
	local newModel = model:Clone()
	newModel:SetPrimaryPartCFrame(cframe)
	newModel.Parent = workspace
	
	return newModel
end

local Tycoon = {}
Tycoon.__index = Tycoon

function Tycoon.new(player, spawn)
	local self = setmetatable({}, Tycoon)
	self.Owner = player
	self.SpawnLocation = spawn.SpawnLocation
	
	self._topicEvent = Instance.new("BindableEvent")
	self._spawn = spawn
	return self
end

function Tycoon:Init()
	self.Model = NewModel(template, self.SpawnLocation.CFrame)
	self.Owner.RespawnLocation = self.Model.Spawn
	
	self:LockAll()
	self:LoadUnlocks()
	self:WaitForExit()
end

function Tycoon:LoadUnlocks()
	local ids = PlayerManager.GetUnlockIds(self.Owner)
	
	-- Começa com 1
	local function processNext(index)
		-- So continua se index for menor que o tamanho do array de ids
		if index <= #ids then
			-- Elabora um id que o button tem que responder antes dele executar o proximo loop
			local responseId = ids[index] .. "_response_"
			
			-- Publica o topico e o response id, para que o button saiba quando pode ser destruido
			self:PublishTopic("Button", ids[index], responseId)
			
			-- Cria o subscription
			local subscription 
			subscription = self:SubscribeTopic("ResponseButton", function(id)
				-- Se o id recebido for o esperado, desconecta o subscription e executa o proximo loop
				if id == responseId then
					subscription:Disconnect()
					processNext(index + 1)
				end
			end)
		end
	end
	
	-- Executa o primeiro loop
	processNext(1)
	
end

function Tycoon:LockAll()
	for _, instance in ipairs(self.Model:GetDescendants()) do
		if CollectionService:HasTag(instance, "Unlockable") then
			self:Lock(instance)
		else
			self:AddComponents(instance)
		end
	end
end

function Tycoon:Lock(instance)
	instance.Parent = tycoonStorage
	self:CreateComponent(instance, componentFolder.Unlockable)
end

function Tycoon:Unlock(instance, id)
	PlayerManager.AddUnlockId(self.Owner, id)
	
	CollectionService:RemoveTag(instance, "Unlockable")
	instance.Parent = self.Model
	self:AddComponents(instance)
end

-- Roda todos os scripts de um instance baseado em suas tags 
function Tycoon:AddComponents(instance)
	-- Percorre todas as tags do objeto
	for _, tag in ipairs(CollectionService:GetTags(instance)) do
		-- Procura o script correspondente
		local componentScript = componentFolder:FindFirstChild(tag)
		
		-- Se achar, cria o componente
		if componentScript then
			self:CreateComponent(instance, componentScript)
		end
	end
end

function Tycoon:CreateComponent(instance, componentScript)
	
	-- Aqui ele vai executar o script correspondente da tag
	local compModule = require(componentScript)
	-- Criar o objeto
	local newComp = compModule.new(self, instance)
	-- E inicializar
	newComp:Init()
end

function Tycoon:PublishTopic(topicName, ...)
	self._topicEvent:Fire(topicName, ...)
end

function Tycoon:SubscribeTopic(topicName, callback)
	local connection = self._topicEvent.Event:Connect(function(name, ...)
		if name == topicName then
			callback(...)
		end
	end)
	
	return connection
end

function Tycoon:WaitForExit()
	PlayerManager.PlayerRemoving:Connect(function(player)
		if player == self.Owner then
			--self:PublishTopic("BankCashout", player)
			self:Destroy(player)
			self._spawn:Unoccupy(player)
		end
	end)
end

function Tycoon:Destroy(player)
	self.Model:Destroy()
	self._topicEvent:Destroy()
end

return Tycoon
