local UpgradeData = require(script.UpgradesData)

local Upgrade = {}

export type Upgrade = UpgradeData.Upgrade

function Upgrade.GetAll(): { UpgradeData.Upgrade }
	return UpgradeData
end

function Upgrade.GetById(id: string): UpgradeData.Upgrade?
	if not id then return end
	
	for _, upg in UpgradeData do
		if upg.ID == id then
			return upg
		end
	end
	
	warn("Upgrade com id", id, "não encontrado")
	return nil
end

function Upgrade.GetAllByName(name: string): { UpgradeData.Upgrade? }
	if not name then return end
	
	local result = {}
	
	for _, upg in UpgradeData do
		if upg.Name == name then
			table.insert(result, upg)
		end
	end
	
	return result
end

return Upgrade
