local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerManager = require(game.ServerScriptService.PlayerManager)

local PlayerTimePlayed = DataStoreService:GetOrderedDataStore("PlayerTimePlayed")

local item = script:WaitForChild("Template")
local container = script:WaitForChild("Container")
local containerParent = script.Parent.LeaderboardPart.SurfaceGui.ScrollingFrame

PlayerManager.PlayerAdded:Connect(function(plr)
	
	
	while true do 
		task.wait(10)
		local playerTimePlayedData = PlayerManager.GetTimePlayed(plr)
		
		local success, errorMsg = pcall(function()
			PlayerTimePlayed:SetAsync(plr.UserId, playerTimePlayedData)
		end)
		if not success then
			warn(errorMsg)
		end
	end
end)

while true do
	
	local currentContainer = containerParent:FindFirstChild("Container")
	if currentContainer then
		currentContainer:Destroy()
	end
	
	local success, pages = pcall(function()
		return PlayerTimePlayed:GetSortedAsync(false, 10)
	end)
	
	if success then
		local entries = pages:GetCurrentPage()
		local containerClone = container:Clone()
		
		containerClone.Parent = containerParent
		
		for rank, entry in pairs(entries) do
			local clonedItem = item:Clone()
			
			local success, username = pcall(function()
				return game.Players:GetNameFromUserIdAsync(entry.key)
			end)
			
			if username and success then
				clonedItem.Name = username
				clonedItem.NameLabel.Text = username
			else
				continue
			end
			
			clonedItem.NumberLabel.Text = entry.value
			clonedItem.RankLabel.Text = "#" .. rank
			
			clonedItem.Parent = containerClone
		end
	end
	task.wait(11)
end