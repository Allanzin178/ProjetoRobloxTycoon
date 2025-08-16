-- / Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- / Local Player
local player = Players.LocalPlayer

-- / Functions inicialization
local Functions = ReplicatedStorage.Functions

-- / Gui inicialization 
local PlayerGui = player:WaitForChild("PlayerGui")
local UpgradeGui = PlayerGui:WaitForChild("Upgrades")
local TreeGui = UpgradeGui:WaitForChild("Background"):WaitForChild("SkillTree"):WaitForChild("TreeTemplate")

local RowTemplate = ReplicatedStorage.Gui.RowSkill0
local SkillTemplate = ReplicatedStorage.Gui.Skill

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

print(upgrades)