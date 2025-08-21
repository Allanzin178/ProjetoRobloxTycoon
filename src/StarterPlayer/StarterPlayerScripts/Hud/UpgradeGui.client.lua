-- / Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CAS = game:GetService("ContextActionService")

-- / Local Player
local player = Players.LocalPlayer

-- / Remote Functions
local Functions = ReplicatedStorage.Functions

-- / Gui inicialization 
local PlayerGui = player:WaitForChild("PlayerGui")
local UpgradeGui = PlayerGui:WaitForChild("Upgrades")
local Wrapper: CanvasGroup = UpgradeGui:WaitForChild("Wrapper")
local SkillTreeGui = Wrapper:WaitForChild("Background"):WaitForChild("SkillTree")

local RowTemplate = ReplicatedStorage.Gui.RowSkill0
local ColumnTemplate = ReplicatedStorage.Gui.ColumnTemplate
local SkillTemplate = ReplicatedStorage.Gui.Skill

-- / Variables gui menu
local UpgradeKey = Enum.KeyCode.M
local isOpen = false
local isInitialized = false

-- / Skill tree Types
type Skill = {
    Name: string
}

type Row = {
    Skills: { Skill }
}

type Column = {
    Rows: { Row }
}

type SkillTree = {
    Columns: { Column }
}

-- / Upgrades table
local upgrades = Functions.GetAllUpgrades:InvokeServer()
print(upgrades)

-- / Functions


function InitializeSkillTree()
    if isInitialized then
        return
    end

    local skillTree = {} :: SkillTree

    --[[
        Logica: Crie column se nao tiver Requirements.UpgradeIDs
        criar row na column com o UpgradeID necessario, se ja tiver apenas adicionar skill

        Ideia: pre-mapear a skill tree, depois ir fazendo as correções e por ultimo montar a gui
    ]]

    for _, upg in upgrades do
        local requirements = upg.Requirements
        if not requirements.UpgradeIDs then -- Se não tiver Upg como requerido

            -- TODO: Arrumar o codigo, para ter pre-mapeamento e melhor organização
            local column = createColumn()
            if not skillTree.Columns then
                skillTree.Columns = {}
            end
            table.insert(skillTree.Columns, {})

            local row = createRow(column)
            if not skillTree.Columns[#skillTree.Columns].Rows then
                skillTree.Columns[#skillTree.Columns].Rows = {}
            end
            table.insert(skillTree.Columns[#skillTree.Columns].Rows, {})

            local skill = createSkill(row, upg)
            if not skillTree.Columns[#skillTree.Columns].Rows[#skillTree.Columns[#skillTree.Columns].Rows].Skills then
                skillTree.Columns[#skillTree.Columns].Rows[#skillTree.Columns[#skillTree.Columns].Rows].Skills = {}
            end
            table.insert(skillTree.Columns[#skillTree.Columns].Rows[#skillTree.Columns[#skillTree.Columns].Rows].Skills, {})

            print(skillTree)

        else -- Se tiver Upg como requerido
            
        end
    end

    isInitialized = true
end

function createColumn()
    local column = ColumnTemplate:Clone()
    column.Parent = SkillTreeGui
    return column
end

function createRow(column)
    local row = RowTemplate:Clone()
    row.Parent = column
    return row
end

function createSkill(row, upg)
    local skill: GuiButton = SkillTemplate:Clone()

    skill.SkillName.Text = string.format("%s(%d)", upg.Name, upg.Value.Quantity)

    skill.MouseButton1Down:Connect(function()
        local success, resposta = Functions.TryBuyUpgrade:InvokeServer(upg.ID)
        if success then
            print(string.format("Comprou %s!", upg.Name))
        else
            warn(resposta)
        end
        
    end)

    skill.Parent = row
    return skill
end

function toggleGui(actionName, inputState, inputObject)
    if inputState ~= Enum.UserInputState.Begin then
        return
    end
    print(isOpen)
    
    if isOpen then -- fechar
        Wrapper.GroupTransparency = 1
        isOpen = false
    else  -- abrir
        Wrapper.GroupTransparency = 0

        InitializeSkillTree()

        isOpen = true
    end
end

CAS:BindAction("ToggleGui", toggleGui, false, UpgradeKey)