local CAS = game:GetService("ContextActionService")
local RS = game:GetService("ReplicatedStorage")

local ActionHandler = require(RS.Modules.ActionHandler)

local ToolHandler = {}
ToolHandler.__index = ToolHandler

function ToolHandler.new(player: Player, tool: Tool)
	local self = setmetatable({}, ToolHandler)
	if not tool then
		warn("Erro com a ferramenta")
		return {}
	end
	
	self.Player = player
	self.Tool = tool
	
	self:Init()
	
	return self
	
end

function ToolHandler:Init()
	self.Tool.Equipped:Connect(function()
		self:OnEquip()
	end)
	self.Tool.Unequipped:Connect(function()
		self:OnUnequip()
	end)
end

function ToolHandler:OnInput(inputName: string, inputState: Enum.UserInputState, inputObject: InputObject)
	local chr = self.Player.Character or self.Player.CharacterAdded:Wait()
	if not chr then return end
	
	local tool = self.Tool
	if not tool then return end
	
	if inputName == "M1" then
		ActionHandler.M1(tool.Name, chr, inputName, inputState)
	end
end

function ToolHandler:BindEvents()
	CAS:BindAction(
		"M1", 
		function(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject)
			self:OnInput(actionName, inputState, inputObject)
		end,
		false, 
		Enum.UserInputType.MouseButton1
	)
end

function ToolHandler:UnbindEvents()
	CAS:UnbindAction("M1")
end

function ToolHandler:OnEquip()
	self:BindEvents()
end

function ToolHandler:OnUnequip()
	self:UnbindEvents()
end

return ToolHandler



