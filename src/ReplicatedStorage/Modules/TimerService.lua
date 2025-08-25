-- / Services
local RunService = game:GetService("RunService")

-- / Types
export type Order = "Crescent" | "Decrescent"

export type TimerData = {
    Hours: number?,
    Minutes: number?,
    Seconds: number?,
    UpdateTime: number?,
    Order: Order?,
    OnUpdate: (currentTime: number) -> nil,
    OnFinish: (currentTime: number) -> nil,
}

-- / Tables
local Timer = {}
Timer.__index = Timer

local defaultData: TimerData = {
    Hours = 0,
    Minutes = 0,
    Seconds = 0,
    UpdateTime = 1,
    Order = "Crescent",
    OnUpdate = function(currentTime: number)
        return
    end,
    OnFinish = function(timerDuration: number)
        print("Timer finalizado! duração:" .. timerDuration)
        return
    end
}

-- / Funções privadas
function GetNumberOfDecimals(num: number): number
    local numStr = tostring(num)
    local result = numStr:split('.')

    if #result == 1 then
        return 0
    end

    local decimals = result[#result]
    local numberOfDecimals = #decimals

    return numberOfDecimals
end

function CallbackWrapper(callback: (currentTime: number) -> nil)
    local function Func(...)
        local success, err = pcall(function(...)
            task.spawn(callback, ...)
        end, ...)

        if not success then
            warn("Erro no callback: ", err)
        end
    end

    return Func
end

-- / Funções
function Timer.new(data: TimerData)
    local self = setmetatable({}, Timer)
    self.Duration = (data.Seconds or defaultData.Seconds) + ((data.Minutes or defaultData.Minutes) * 60) + ((data.Hours or defaultData.Hours) * 60 * 60)
    self.Order = data.Order or defaultData.Order
    self.UpdateTime = data.UpdateTime or defaultData.UpdateTime

    self.Connection = nil
    self.Running = false

    self.OnUpdate = CallbackWrapper(data.OnUpdate or defaultData.OnUpdate)
    self.OnFinish = CallbackWrapper(data.OnFinish or defaultData.OnFinish)

    if RunService:IsServer() then
        game:BindToClose(function()
            self:Stop()
        end)
    end

    return self
end

function Timer:Start()
    if self.Running then
        warn("Timer já está em execução!")
        return
    end

    self.Running = true

    local startTime = os.clock()
    local lastUpdate = startTime

    local multiplier = 10 ^ GetNumberOfDecimals(self.UpdateTime)

    if self.Order == "Decrescent" then
        self.Current = self.Duration
    elseif self.Order == "Crescent" then
        self.Current = 0
    end

    self.OnUpdate(self.Current)

    self.Connection = RunService.Heartbeat:Connect(function(deltaTime)
        local loopNow = os.clock()
        local elapsed = loopNow - startTime

        if loopNow - lastUpdate >= self.UpdateTime then
            lastUpdate = loopNow

            local formattedElapsed = math.round(elapsed * multiplier) / multiplier            

            self:UpdateCurrent(formattedElapsed)
            self.OnUpdate(self.Current)
            
        end

        local isFinished = elapsed >= self.Duration

        if isFinished then
            self:Stop()

            local endTime = os.clock()
            local execTime = endTime - startTime

            self:UpdateCurrent(self.Duration) -- Maximo
            self.OnUpdate(self.Current)
            self.OnFinish(execTime)
            
        end
    end)

end

function Timer:UpdateCurrent(elapsed: number)
    self.Current = if self.Order == "Crescent" then 
        math.min(elapsed, self.Duration) else
        math.max(0, self.Duration - elapsed) -- Decrescent
end

function Timer:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    self.Running = false
end

return Timer