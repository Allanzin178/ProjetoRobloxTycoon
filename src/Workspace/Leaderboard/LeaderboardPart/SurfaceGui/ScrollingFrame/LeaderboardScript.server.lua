--local DataStoreService = game:GetService("DataStoreService")
--local TimeplayedDataStore = DataStoreService:GetDataStore("TimeplayedDataStore")

--local LeaderboardPart = script.Parent.Parent.Parent.Parent.LeaderboardPart
--local RefreshRate=60
--local function RefreshLeaderboard()
--	 for i, Player in pairs(game.Players:GetPlayers()) do
--			LeaderBoardDataStore:SetAsync(Player.UserId , Player.Leaderstats.TimePlayed.Value)
--	 end
	 
--	 local Sucess, Error = pcall(function()
--			local Data = LeaderboardDataStore:GetSortedAsync(false, 60)
--			local RollsPage = Data:GetCurrentPage(
				
--			for Rank, SavedData in ipairs(RollsPage)	do
				
--				local UserId = tonumber(SavedData.key)
--				local Timeplayed = SavedData.value	
				
--				if coins 0 then 
--					local Username = game.Players:GetNameFromUserIdAsync(
					
--					local NewSample = script:WaitForChild("Template") : 
					
--					NewSample.parent = LeaderboardPar.SurfaceGui:WaitForChild("ScrollingFrame").Container
--					NewSample.name = Username
					
--					NewSample.RankLabel.text = "#"..Rank
--					NewSample.NameLabel.text = Username			
--					NewSample.NumberLabel.text = Hours
					
--					if Rank ==1 then
--						NewSample.BackgroundColor3 = Color3.fromRGB(255, 213, 0)
--					elseif Rank== 2 then
--						NewSampl.BackgroundColor3 + Color3.fromRGB(192, 192, 192)
						
--					elseif Rank == 3 then 
--						NewSample.BackgroundColor3 = Color3.fromRGB(205 ,127, 50)
						
--					else
--						NewSample.BackgroundColor3 = Color3.fromRGB(216, 216, 216)
--				end
--					)
--			end
--		end
--	end
--end)
--while true do 
--	for i, Frame in pairs(LeaderboardPart.SurfaceGui:WaitForChild("ScrollingFrame").Container:
		
--		if Frame.Name = "Template" and Frame:IsA("Frame") then 
--			Frame:Destroy()
--		end
--	end
--	RefreshLeaderboard()
	
--	task.wait(RefreshRate)
--end