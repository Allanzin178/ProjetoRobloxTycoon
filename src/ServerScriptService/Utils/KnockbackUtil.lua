function knockback(char: Model, vChar: Model, force: number)
	if not (char and vChar) then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local vHrp = vChar:FindFirstChild("HumanoidRootPart")

	if not (hrp and vHrp) then return end
	if vHrp.Anchored then return end

	local dir = (vHrp.Position - hrp.Position).Unit
	local forceDirection = (dir + Vector3.new(0, 0, 0)).Unit

	local attachment = Instance.new("Attachment")
	attachment.Name = "KnockbackAttachment"
	attachment.Parent = vHrp

	local vectorForce = Instance.new("VectorForce")
	vectorForce.Name = "KnockbackForce"
	vectorForce.Attachment0 = attachment
	vectorForce.Force = forceDirection * vHrp.AssemblyMass * force -- ajuste o multiplicador
	vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
	vectorForce.ApplyAtCenterOfMass = true
	vectorForce.Parent = vHrp

	-- Remove depois de 0.1 segundo (pra ser só um empurrão inicial)
	task.delay(0.1, function()
		vectorForce:Destroy()
		attachment:Destroy()
	end)
end

return knockback
