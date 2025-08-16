local SoundService = game:GetService("SoundService")

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local mute = playerGui:WaitForChild("Mute")

local musics = {
	"rbxassetid://125598466208798",
	"rbxassetid://118939739460633",
	"rbxassetid://142376088",
	"rbxassetid://121336636707861",
	"rbxassetid://110610021494888"
}

local actualMusic = 1

local backgroundMusic = SoundService:FindFirstChild("Musica")
backgroundMusic.Volume = 0.1
backgroundMusic.Looped = false

local function playRandomMusic()
	backgroundMusic.SoundId = musics[actualMusic]
	backgroundMusic:Play()
	actualMusic += 1
	if actualMusic >= #musics + 1 then
		actualMusic = 1
	end
end

backgroundMusic.Ended:Connect(function()
	playRandomMusic()
end)

local function onClick()
	
	if backgroundMusic.IsPlaying then
		backgroundMusic:Pause()
		mute.Frame.Mutar.TextLabel.Text = "Unmute"
	else
		playRandomMusic()
		mute.Frame.Mutar.TextLabel.Text = "Mute"
	end
end

local muteButton = mute.Frame.Mutar
muteButton.Activated:Connect(onClick)

playRandomMusic()
