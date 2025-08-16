local RS = game:GetService("ReplicatedStorage")
local SCS = game:GetService("ServerScriptService")

local Events = RS.Events
local Modules = RS.Modules

local HitboxHandler = require(Modules.HitboxHandler)
local SoundHandler = require(RS.Modules.SoundHandler)
local WeaponsConfig = require(SCS.Configs.Weapons)
local KnockbackUtil = require(SCS.Utils.KnockbackUtil)
local RagdollUtil = require(SCS.Utils.RagdollUtil)

Events["Client-Server"].Combat.OnServerEvent:Connect(function(plr, toolName, actionName, inputState)
	if not plr then return end
	if not toolName then return end
	if not actionName then return end

	local chr = plr.Character or plr.CharacterAdded:Wait()
	if not chr then return end

	local hrp = chr:FindFirstChild("HumanoidRootPart")
	if not hrp then return end


	local weaponInfo = WeaponsConfig.GetWeaponInfoByName(toolName)

	local hitboxInfo = {
		Frame = hrp.CFrame * weaponInfo.HitboxInfo.CFrameOffset,
		Size = weaponInfo.HitboxInfo.Size,
		Params = HitboxHandler.GetDefaultParams(chr)
	}

	local hitboxCallback = function(enemy: Model)
		RagdollUtil.RagdollCharacter(enemy, weaponInfo.RagdollDuration)
		KnockbackUtil(chr, enemy, weaponInfo.KnockbackDistance)
		SoundHandler.Play("BatHit3")
		-- Damage logic or more here
	end

	HitboxHandler.Spawn(hitboxInfo, hitboxCallback)

end)

return true