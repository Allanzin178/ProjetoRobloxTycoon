local Weapons = {}

local weaponsInfos = {}

type Info = {
	Name: string,
	Damage: number,
	HitboxInfo: {
		CFrameOffset: CFrame,
		Size: Vector3
	}?,
	RagdollDuration: number?,
	KnockbackDistance: number?
}

function Weapons.GetAllWeaponsInfo()
	
	for _, module in ipairs(script:GetChildren()) do
		local info = require(module)
		if weaponsInfos[info.Name] then
			warn("Weapon name already exists: " .. info.Name)
			continue
		end
		weaponsInfos[info.Name] = info
	end
	
	return weaponsInfos
end

function Weapons.GetWeaponInfoByName(
	name: string
): Info?
	if not name then return end
	
	if not weaponsInfos[name] then
		Weapons.GetAllWeaponsInfo()
	end
	
	return weaponsInfos[name] or {}
end

return Weapons
