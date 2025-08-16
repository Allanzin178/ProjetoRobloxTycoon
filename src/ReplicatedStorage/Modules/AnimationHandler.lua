export type MarkerReached = {
	name: string,
	callback: (markerName: string) -> nil
}

type Anim = {
	Track: AnimationTrack,
	Connections: { RBXScriptConnection }
}

type AnimById = {
	[number]: Anim
}

type AnimMap = {
	[any]: AnimById
}

local AnimationHandler = {}

AnimationHandler.Anims = {} :: { [Model]: AnimMap }

function getAnimator(char: Model): Animator
	local hmd = char:FindFirstChildOfClass("Humanoid")
	if not hmd then return nil end
	
	local animator = hmd:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Name = "Animator"
		animator.Parent = hmd
	end
	
	return animator
end

function AnimationHandler.LoadAnim(
	char: Model, 
	_type: any, 
	animId: number | string, 
	markerReached: MarkerReached?,
	whenEndedFunc: () -> ()?,
	whenPlayedFunc: () -> ()?
): AnimationTrack
	if not char or not _type or not animId then return end
	
	local animator = getAnimator(char)
	
	local animation = Instance.new("Animation")
	animation.AnimationId = animId
	local track = animator:LoadAnimation(animation)
	
	AnimationHandler.Anims[char] = AnimationHandler.Anims[char] or {}
	AnimationHandler.Anims[char][_type] = AnimationHandler.Anims[char][_type] or {}
	
	local connections = {}
	
	if markerReached then
		table.insert(connections, track:GetMarkerReachedSignal(markerReached.name):Connect(function(markerName)
			markerReached.callback(markerName)
		end))
	end
	
	table.insert(connections, track.Ended:Connect(function()
		if whenEndedFunc then
			whenEndedFunc()
		end
		
		AnimationHandler.RemoveAnim(char, _type, animId)
	end))
	
	AnimationHandler.Anims[char][_type][animId] = {
		Track = track,
		Connections = connections
	}
	
	track:Play()
	if whenPlayedFunc then
		whenPlayedFunc()
	end
	
	return track
end

function AnimationHandler.GetAnims(char: Model, animType: any?): AnimMap | AnimById | nil 
	if not AnimationHandler.Anims[char] then return nil end
	if animType then
		return AnimationHandler.Anims[char][animType] or nil
	end
	return AnimationHandler.Anims[char]
end

function AnimationHandler.IsAnim(char: Model, _type: any, animId: number)
	if AnimationHandler.Anims[char] then
		if AnimationHandler.Anims[char][_type] then
			if AnimationHandler.Anims[char][_type][animId] then
				return true
			end
			return false
		end
		return false
	end
	return false
end

function AnimationHandler.RemoveAnim(char: Model, _type: any, animId: number)
	local animData = AnimationHandler.Anims[char] and AnimationHandler.Anims[char][_type] and AnimationHandler.Anims[char][_type][animId]
	if animData then
		if animData.Track then
			animData.Track:Stop()
			animData.Track:Destroy()
		end
		
		if animData.Connections then
			for _, conn in ipairs(animData.Connections) do
				if conn.Connected then
					conn:Disconnect()
				end
			end
		end
		
		AnimationHandler.Anims[char][_type][animId] = nil
		
		if next(AnimationHandler.Anims[char][_type]) == nil then
			AnimationHandler.Anims[char][_type] = nil
		end
		
		if next(AnimationHandler.Anims[char]) == nil then
			AnimationHandler.Anims[char] = nil
		end
	end
end


return AnimationHandler
