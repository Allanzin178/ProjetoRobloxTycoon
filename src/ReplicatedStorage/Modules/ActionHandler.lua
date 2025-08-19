local RS = game:GetService("ReplicatedStorage")

local AnimationHandler = require(RS.Modules.AnimationHandler)
local SoundHandler = require(RS.Modules.SoundHandler)
local ToolsRemote = require(RS.Misc.Tools.ToolsRemote)
local ToolsAnims = require(RS.Misc.Tools.ToolsAnims)

local ActionHandler = {}

local isAttacking = false

function ActionHandler.M1(toolName: string, chr: Model, inputName: string, inputState: Enum.UserInputState)
	if isAttacking == false then
		if inputState ~= Enum.UserInputState.Begin then return end
		
		-- Temporario
		local animationId = ToolsAnims[toolName].M1[1]

		local markerReached: AnimationHandler.MarkerReached = {
			name = "Hit",
			callback = function(markerName: string)
				if inputState == Enum.UserInputState.Begin then

					-- Dinamico com ToolsRemote
					ToolsRemote[toolName].M1(toolName, inputName, inputState)
				end
			end,
		}
		
		local function whenEndedFunc()
			isAttacking = false
		end
		
		local function whenPlayedFunc()
			SoundHandler.Play("BatSwing1", {RandomPitch = {enabled = true}})
		end

		local track = AnimationHandler.LoadAnim(chr, "BatAttack", animationId, markerReached, whenEndedFunc, whenPlayedFunc)

		isAttacking = true
	
	end
	
end

return ActionHandler
