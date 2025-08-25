local RS = game:GetService("ReplicatedStorage")
local TimerService = require(RS.Modules.TimerService)
local ModuleLoader = require(RS.ModuleLoader)

ModuleLoader.Start(RS.Modules)
local info
info = {
    OnUpdate = function(tempo)
        print(string.format("%.1f", tempo))
    end,
    OnFinish = function(tempo)
        print(tempo .. "TERMINOU!")
        local timer = TimerService.new(info)
        timer:Start()
    end,
    Order = "Crescent",
    UpdateTime = 0.1,
    Seconds = 10
}

local timer = TimerService.new(info)

print("Tentou começar")

-- timer:Start()

-- SoundHandler Initialization
ModuleLoader:GetService("SoundHandler")
