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
local TreeGui = UpgradeGui:WaitForChild("Wrapper"):WaitForChild("Background"):WaitForChild("SkillTree"):WaitForChild("TreeTemplate")

local RowTemplate = ReplicatedStorage.Gui.RowSkill0
local SkillTemplate = ReplicatedStorage.Gui.Skill

-- / Variables gui menu
local UpgradeKey = Enum.KeyCode.M
local isOpen = false

-- / Upgrades table
local upgrades = Functions.GetAllUpgrades:InvokeServer()

-- / Functions
local function createRow()
    local row = RowTemplate:Clone()
    row.Parent = TreeGui
    return row
end

local function createSkill(row)
    local skill = SkillTemplate:Clone()
    skill.Parent = row
    return skill
end

local function toggleGui()
    
end

print(upgrades)