local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local ToolHandler = require(RS.Modules.ToolHandler)

local tool = script.Parent

ToolHandler.new(player, tool)