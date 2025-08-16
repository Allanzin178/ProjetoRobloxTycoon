local Debris = game:GetService("Debris")

export type Hitbox_Data = {
	Frame: CFrame,
	Size: Vector3,
	Params: OverlapParams,
}

local hitboxUtil = {}

function hitboxUtil.Spawn(data: Hitbox_Data, callback: (enemy: Model) -> nil)
	local list = workspace:GetPartBoundsInBox(data.Frame, data.Size, data.Params)
	local enemies = hitboxUtil.FilterCharacters(list)
	local success = #enemies > 0
	
	hitboxUtil.VisualizeBox(data.Frame, data.Size, 1, success)
	
	if success then
		for _, enemy in ipairs(enemies) do
			callback(enemy)
		end
	end
	
	print(success)
	
	return success, enemies
end

function hitboxUtil.FilterCharacters(list: {BasePart}): {Model}
	if #list == 0 then
		return {}
	end
	
	local found: {Model} = {}
	
	for _, Part in list do
		local model = Part:FindFirstAncestorOfClass("Model")
		
		if not model then
			continue
		end
		
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		
		if not humanoid then
			continue
		end
		if humanoid.Health <= 0 then
			continue
		end
		
		if table.find(found, model) then
			continue
		end
		
		table.insert(found, model)
	end
	
	return found
end

function hitboxUtil.VisualizeBox(cframe: CFrame, size: Vector3, duration: number, hit: boolean)
	local adornment = Instance.new("BoxHandleAdornment")
	
	adornment.Color3 = hit and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	adornment.Parent = workspace.Terrain
	adornment.Adornee = workspace.Terrain
	adornment.CFrame = cframe
	adornment.Size = size
	adornment.Transparency = 0.65
	
	Debris:AddItem(adornment, duration)
end

function hitboxUtil.GetDefaultParams(character: Model)
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {character}
	
	return params
end

return hitboxUtil
