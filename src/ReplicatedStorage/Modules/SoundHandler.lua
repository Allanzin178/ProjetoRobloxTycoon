local SoundService = game:GetService("SoundService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local SoundEvent = RS.Events["Server-Client"].Sound

local SoundHandler = {}
local Sounds = {}

local MAX_RETRY_SOUND = 3

export type PitchVariations = "Low" | "Medium" | "High"

export type SoundConfigs = {
	Volume: number?,
	MaxDistance: number?,
	MinDistance: number?,
	RollOffMode: Enum.RollOffMode?,
	SoundId: number?,
	Looped: boolean?,
	PlaybackSpeed: number?,
	TimePosition: number?,
	Parent: Instance?,
	RandomPitch: {
		enabled: boolean?,
		variation: PitchVariations?
	}?
}

function SoundHandler:Init()
	SoundHandler.GatherSounds(SoundService, Sounds)
end

function SoundHandler.Play(name: string, configs: SoundConfigs, location: Instance?)
	
	if location then
		SoundHandler.GatherSounds(location, Sounds)
	end
	
	local ogSound = SoundHandler.FindSound(name, Sounds)
	
	if not ogSound then
		warn(name, "Was not found!")
		warn(Sounds)
		return
	end
	
	local newSound = SoundHandler.CloneSound(ogSound, configs)
	
	newSound:Play()
end

function SoundHandler.GatherSounds(location: Instance, sounds: {})
	for _, sound: Instance in ipairs(location:GetChildren()) do
		if sounds[sound.Name] then
			return
		end

		if sound:IsA("SoundGroup") then
			sounds[sound.Name] = sounds[sound.Name] or {}
			SoundHandler.GatherSounds(sound, sounds[sound.Name])
		else
			sounds[sound.Name] = sound
		end
	end
end

function SoundHandler.FindSound(name: string, sounds: {}): Sound?
	if not name then return end
	
	local retrys = 1
	
	repeat
		for soundName, sound in pairs(sounds) do
			if typeof(sound) == "table" then
				local found = SoundHandler.FindSound(name, sound)
				if found then
					return found
				end
			else
				if soundName == name then
					return sound
				end
			end		
		end
		warn("Tentativa ", retrys)
		retrys += 1
		
		SoundHandler.GatherSounds(SoundService, Sounds)
	until retrys >= MAX_RETRY_SOUND
	
	
	
end

function SoundHandler.RandomPitch(sound: Sound, variation: PitchVariations)
	local variationsConfig: {[PitchVariations]: NumberRange} = {
		["Low"] = NumberRange.new(1, 5),
		["Medium"] = NumberRange.new(2, 10),
		["High"] = NumberRange.new(5, 20)
	}

	local variationSelected: NumberRange = variationsConfig[variation] or variationsConfig["Low"]

	local ADD = 1
	local SUBTRACT = 2

	local addOrSubtract = math.random(ADD, SUBTRACT)
	local pitchQuantity = math.random(variationSelected.Min, variationSelected.Max) / 100

	if addOrSubtract == 1 then
		sound.PlaybackSpeed = 1 + pitchQuantity -- Se pitchQuantity fosse 20 por exemplo: 1 + 0,2 = 1,2
	elseif addOrSubtract == 2 then
		sound.PlaybackSpeed = 1 - (pitchQuantity / 2) -- Se pitchQuantity fosse 20 por exemplo: 1 - 0,2 = 0,8
	end

	return sound
end

function SoundHandler.CloneSound(ogSound: Sound, configs: SoundConfigs?)
	if not ogSound then return end
	if not configs then
		configs = {}
	end
	local newSound = ogSound:Clone()

	newSound.Volume = configs.Volume or ogSound.Volume
	newSound.RollOffMaxDistance = configs.MaxDistance or ogSound.RollOffMaxDistance
	newSound.RollOffMinDistance = configs.MinDistance or ogSound.RollOffMinDistance
	newSound.RollOffMode = configs.RollOffMode or ogSound.RollOffMode
	newSound.Looped = configs.Looped or ogSound.Looped
	newSound.PlaybackSpeed = configs.PlaybackSpeed or ogSound.PlaybackSpeed
	newSound.TimePosition = configs.TimePosition or ogSound.TimePosition

	if configs.RandomPitch and configs.RandomPitch.enabled then
		-- Randomiza o playbackspeed baseado na config passada e ja muda no newSound
		SoundHandler.RandomPitch(newSound, configs.RandomPitch.variation or nil)
	end

	newSound.Parent = configs.Parent or ogSound.Parent

	newSound:Stop()
	
	local connection
	connection = newSound.Ended:Connect(function()
		newSound:Destroy()
		connection:Disconnect()
	end)
	
	return newSound
end

function SoundHandler.SendSoundToClient(player: Player, soundName: string, configs: SoundConfigs?)
	
	if not RunService:IsServer() then
		warn("Não foi possivel enviar pro cliente: Ja esta executando no cliente")
		return
	end
	
	if not player then return end
	
	if not soundName then
		warn("Informe o nome do áudio para enviar!")
		return
	end
	
	SoundEvent:FireClient(player, {
		name = soundName,
		configs = configs
	})
	
end

function SoundHandler.SetupOnClient()
	if not RunService:IsClient() then
		warn("Não foi possivel: Está no servidor!")
		return
	end
	
	if SoundHandler["ClientConnection"] then
		warn("Já existe uma conexão ativa")
		return
	end
	
	SoundHandler["ClientConnection"] = SoundEvent.OnClientEvent:Connect(function(data: {name: string, configs: SoundConfigs?})
		local soundName = data.name
		local configs = data.configs
		
		if not soundName then
			warn("Dados de som recebidos pelo cliente sao invalidos")
			return
		end
		
		SoundHandler.Play(soundName, configs)
	end)
	
	print("Som no cliente conectado!")
end

return SoundHandler
