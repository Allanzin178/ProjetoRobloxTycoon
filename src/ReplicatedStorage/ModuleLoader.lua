-- / Types
type Cache = {
    [string]: {any} | ModuleScript
}

export type SettingsType = {
    REQUIRE_ON_LOAD: boolean?,
    VERBOSE_LOADING: boolean?
}

-- / Tables
local ModuleLoader = {}
local CachedModules = {} :: Cache

-- / Variables
local LoaderScript: ModuleScript = script
local SearchLocal: Instance = nil

-- / Settings
local Settings = {
    REQUIRE_ON_LOAD = LoaderScript:GetAttribute("RequireOnLoad"), -- Se o Loader deve requerir o modulescript ao dar Load
    VERBOSE_LOADING = LoaderScript:GetAttribute("VerboseLoading"), -- Se quando estiver carregando os modulos irá printar no console o progresso
}

-- / Private Functions
function LoadModules(modules: {Instance})
    for _, module in modules do
        if not module:IsA("ModuleScript") then
            continue
        end

        -- if Settings.VERBOSE_LOADING then
        --     print(string.format("%s Loaded", module.Name))
        -- end

        CachedModules[module.Name] = if Settings.REQUIRE_ON_LOAD then TryRequireModule(module) else module

    end
end

function GetCachedModulesLength(): number
    local length = 0
    for _, v in CachedModules do
        length = length + 1
    end

    return length
end

function TryRequireModule(module: ModuleScript)
    local success, result = xpcall(function()
        -- Caso dê certo retorna o modulo requirido
        local script = require(module)
        if script["Init"] and module:GetAttribute("InitOnRequire") ~= false then
            script:Init()
        end
        return script
    end, function(err)
        -- Erro formatado caso dê errado
        return string.format("[ModuleLoader] Erro ao carregar %s: %s\n%s",
            module.Name,
            tostring(err),
            debug.traceback()
        )
    end)

    if success then
        if Settings.VERBOSE_LOADING then
            print(string.format("%s Required", module.Name))
        end
        return result
    else
        warn(result)
        return module
    end
end

-- / Public Functions
function ModuleLoader.Start(instance: Instance)
    SearchLocal = instance
    LoadModules(SearchLocal:GetChildren())
end

function ModuleLoader:GetService(name: string): {any}
    local module = CachedModules[name]
    if GetCachedModulesLength() == 0 then
        LoadModules(SearchLocal:GetChildren())
    end

    if not module then
        warn(string.format("Serviço %s não existe ou não foi carregado", name))
        return {}
    end

    module = if Settings.REQUIRE_ON_LOAD then module else TryRequireModule(module)

    return module
end

return ModuleLoader
