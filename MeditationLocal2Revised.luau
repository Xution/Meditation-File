local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local playerGui = plr.PlayerGui
local humanoid = character:FindFirstChild("Humanoid")
local replicatedStorage = game:GetService("ReplicatedStorage")
local replicatedFirst = game:GetService("ReplicatedFirst")
local starterPlayer = game:GetService("StarterPlayer")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

local modules = replicatedStorage:FindFirstChild("modules")
local clientModules = replicatedFirst:FindFirstChild("modules")
local remoteEvents = replicatedStorage:FindFirstChild("RemoteEvents")
local enlightenmentPackage = replicatedStorage:FindFirstChild("CinematicAnimations"):FindFirstChild("Example2")

local itemSelectModule = require(modules:FindFirstChild("SelectedItem"))
local hotBarModule = require(modules:FindFirstChild("HotBarSelect"))
local expBarModule = require(modules:FindFirstChild("barModule"))
local inputModule = require(modules:FindFirstChild("InputModule"))
local meditationModule = require(modules:FindFirstChild("Meditationmodule"))
local transparentModule: ModuleScript = require(modules:FindFirstChild("TransparentBars"))
local cooldownModule = require(modules:FindFirstChild("Cooldownmodule"))
local levelModuleGUI = require(modules:FindFirstChild("LevelModuleGUI"))
local maxEXPRequirements = require(modules:FindFirstChild("Max_EXP_Requirements"))
local textTweenModule = require(modules:FindFirstChild("Tween_Text_Transparency_Module"))
local expChange = require(modules:FindFirstChild("AttributeChange")) -- change this later
local maxEXPRequirements = require(modules:FindFirstChild("Max_EXP_Requirements"))
local enlightenmentScene = require(enlightenmentPackage.AnimPlayer2)
local meditationPaths = require(clientModules:FindFirstChild("MeditationPaths"))

local MeditationGUI = playerGui:FindFirstChild("MeditationGui")
local hotBarGUI = playerGui:FindFirstChild("HotBarGUI")
local skillsFolder = hotBarGUI:FindFirstChild("Skills")
local expBar = MeditationGUI.ExpBar.BarFrame.EXP
local MeditationFrame = MeditationGUI.Skills.Meditation
local cooldownText = MeditationGUI.Cool.Cooldown
local levelText = MeditationGUI.LevelUp:FindFirstChild("Level")
local frameForEnlight = MeditationGUI.Enlight.Frame
local enlightText = frameForEnlight.TextLabel
local doesntMeetRequirement = MeditationGUI.LevelUp.Does_Not_Meet_Level_Requirement
local barSize = expBar.Size
local EXP = character:GetAttribute("EXP")
local MaxEXP = character:GetAttribute("MaxEXP")
local text = expBar.Parent.Parent.TextLabel
local levelChanged = replicatedStorage:FindFirstChild("bindableEvents").LevelChanged
local ratesAndNumber = replicatedStorage.bindableEvents.RatesAndNumber
local attributeEXPRemote = remoteEvents.EXPAttributeRemote
local breathVFX = replicatedStorage.ClonedItems.VFX.BreathVFX:Clone()
local BreathRemote = remoteEvents.BreathVFX
local enlightenmentRemote = remoteEvents.EnlightenmentEvent
local meditationRemote = remoteEvents.MeditationRemote
local level = character:GetAttribute("Level")
local hotBarEquip = character:GetAttribute("hotBarEquip")
local equipped = character:GetAttribute("equipped")
local isMeditating = character:GetAttribute("isMeditating")
local count = 0
local db = false
local levelTextColor
local rate = 1
local number = 1
local walkSpeed = humanoid.WalkSpeed
local jumpHeight = humanoid.JumpHeight
local count2 = 0
local meditationGain
local keyBeingUsed = nil
local debounceTime = 0.7
local textDebounce = false
local beginnerEXPS 
local advancedEXPS
local allAdvancedRequisites


local expFrame = MeditationGUI:FindFirstChild("EXPFRAME")
local expButton = expFrame:FindFirstChild("ExpButton")
local expBarFolder = MeditationGUI.ExpBar
local observationBar = expBarFolder.BarFrame:FindFirstChild("ObservationEXP")
local text = expBarFolder.TextLabel
local randomThought = expFrame.RandomThought
local meditationRemote = replicatedStorage:FindFirstChild("RemoteEvents")["IncrementEXP/Minutes"]
local ObservationEXP = character:GetAttribute("observationEXP")
local ObservationMaxEXP = character:GetAttribute("observationMaxEXP")
local ObservationMinutes = character:GetAttribute("ObservationMinutes")
local inFrame = false
local db2 = false
local observationDB = false
local randomPosition = false
local clickDB = false
local randomXScale
local randomYScale 
local inCircleLoop

local mouse = plr:GetMouse()


-- tables
local anims = {
	startMeditation = humanoid.Animator:LoadAnimation(script.startmeditationpose), 
	focusMeditation = humanoid.Animator:LoadAnimation(script.meditationposeidle),
	enlightenmentAnim = humanoid.Animator:LoadAnimation(script.Enlightenment)
}


local levelRequirements = {5, 10, 15, 25, 50, 60, 75, 100}


local leaderstats = plr:FindFirstChild("leaderstats")
local FocusStats = plr:WaitForChild("MeditationFolder").FocusStats
local ObservationStats = plr:WaitForChild("MeditationFolder").ObservationStats
-- rates and addends table from datastore
local rates = {
	focusRate = {rate = FocusStats:WaitForChild("FocusRate").Value, number = FocusStats:WaitForChild("FocusAddend").Value},
	observationRate = {rate = ObservationStats:WaitForChild("ObservationRate").Value, number = ObservationStats:WaitForChild("ObservationAddend").Value}

}


print(rates.observationRate)

print(ObservationStats.ObservationRate.Value)


--updates rates and addends for different meditations
local function changeRatesAndAddends(newRate, newAddend, levelName)
	if levelName == "Level" then
		rates.focusRate.rate = newRate
		rates.focusRate.number = newAddend
		print(rates.focusRate)
	elseif levelName == "ObservationLevel" then
		print('YEAHHHHHHHHHHHHHHHHH')
		rates.observationRate.rate = newRate
		rates.observationRate.number = newAddend
		print(rates.observationRate.rate)
	end
end
-- bindable event to change rates and addends
ratesAndNumber.Event:Connect(function(rate, number, levelName)
	print(rate, number)
	changeRatesAndAddends(rate, number, levelName)
end)
-- get attributechanged signal for level
character:GetAttributeChangedSignal("Level"):Connect(function()
	level = character:GetAttribute("Level")
end)

-- all of this is for when the player reaches enlightenment
anims.startMeditation:GetMarkerReachedSignal("StartMeditationIdle"):Connect(function()
	anims.focusMeditation:Play()
end)

anims.focusMeditation:GetMarkerReachedSignal("BreathEvent"):Connect(function()
	BreathRemote:FireServer()
end)

anims.enlightenmentAnim:GetMarkerReachedSignal("airVFX"):Connect(function()
	print("passed air")
	enlightenmentRemote:FireServer('air')
end)

anims.enlightenmentAnim:GetMarkerReachedSignal("groundVFX"):Connect(function()
	print("passed ground")
	enlightenmentRemote:FireServer('ground')
end)

anims.enlightenmentAnim:GetMarkerReachedSignal("ShineVFX"):Connect(function()
	print("passed shine")
	enlightenmentRemote:FireServer('light')
end)

character:GetAttributeChangedSignal("hotBarEquip"):Connect(function()
	hotBarEquip = character:GetAttribute("hotBarEquip")
	hotBarModule.HotBarSelect(character, MeditationFrame, hotBarEquip)
end)
-- change equipped to hotBarEquip only
character:GetAttributeChangedSignal("equipped"):Connect(function()
	equipped = character:GetAttribute("equipped")
	if userInputService:IsKeyDown(Enum.KeyCode.One) then
		hotBarModule.HotBarSelect(character, skillsFolder.HotBar.Meditation , equipped)
	elseif userInputService:IsKeyDown(Enum.KeyCode.Two) then
		hotBarModule.HotBarSelect(character, skillsFolder.HotBar.Observation , equipped)
	end

	print(equipped)
end)

local function debounceFunction(message)
	db = false
end


-- debounce when the player is not in meditation
local function reset(seconds)
	if count == 2 then
		debounceTime = seconds

		task.delay(1.5, function()
			count = 0
			print(count)
			keyBeingUsed = nil

			return count
		end)
	end
end
-- resets the debounce time and count and keybeingused when the player is not in meditation
local function exitMeditatingHotBar()
	while task.wait(.1) do
		if not equipped then
			debounceTime = 5
			count = 0
			keyBeingUsed = nil
			break
		end
	end
end
-- gets the expbar as well as the rates when the player loads in the game
task.delay(1.3, function()

	text.Text = "EXP: "..character:GetAttribute("EXP").."/"..character:GetAttribute("MaxEXP")
	levelText.Text = "Level:"..level
	expBarModule:BarChange(character:GetAttribute("MaxEXP"), expBar, expBar.Size, character, "EXP", Color3.fromRGB(34, 152, 255))

	rates = {
		focusRate = {rate = FocusStats:WaitForChild("FocusRate").Value, number = FocusStats:WaitForChild("FocusAddend").Value},
		observationRate = {rate = ObservationStats:WaitForChild("ObservationRate").Value, number = ObservationStats:WaitForChild("ObservationAddend").Value},

	}

	--print(rates.focusRate)

	--print(plr.MeditationFolder.FocusStats.FocusRate.Value)
end)
local countRef = {value = 0}
-- tables of attributes

--exp attributes
local meditationEXPAttributes = {
	EXP = character:GetAttribute("EXP"),
	ObservationEXP = character:GetAttribute("observationEXP"),

}
-- gets the hotbar equip attribute
local state = {hotBarEquip = character:GetAttribute("hotBarEquip")}
-- maxexp attributes
local meditationMaxEXPAttributes = {

	MaxEXP = character:GetAttribute("MaxEXP"),
	apathyMaxEXP = character:GetAttribute("apathyMaxEXP"),
	griefMaxEXP = character:GetAttribute("griefMaxEXP"),
	fearMaxEXP = character:GetAttribute("fearMaxEXP"),
	angerMaxEXP = character:GetAttribute("angerMaxEXP"),

	advancedMaxEXPAttributes = {
		courageMaxEXP = character:GetAttribute("courageMaxEXP"),
		desireMaxEXP = character:GetAttribute("desireMaxEXP"),
		purposeMaxEXP = character:GetAttribute("purposeMaxEXP"),
		loveMaxEXP = character:GetAttribute("loveMaxEXP"),
	}
}
-- build context table for the meditation module
local function buildContext()
	return {
		plr = plr,
		character = character,
		rates = rates,
		debounceTime = debounceTime,
		db = db,
		--db2 = db2,
		--randomPosition = randomPosition,
		count = count, 
		anims = anims,
		text = text,
		randomThought = randomThought,
		cooldownText = cooldownText,
		levelText = levelText,
		expBar = expBar,
		hotBarEquip = hotBarEquip,
		state = state,
		barSize = barSize,
		reset = reset,
		keyBeingUsed = keyBeingUsed,
		exitMeditatingHotBar = exitMeditatingHotBar,
		debounceFunction = debounceFunction,
		meditationEXPAttributes = meditationEXPAttributes,
		meditationMaxEXPAttributes = meditationMaxEXPAttributes,
		expFrame = expFrame,
		mouse = mouse,

	}
end

-- what the randomThoughts look like.

local RandomThoughtTable = {
	"I wonder what I'm going to do today",
	"I should cook chicken today",
	"I don't think I can do this",
	"I can do this",
	"Deftones is the best band",
	"Cats are better than dogs",
	"I don't believe in myself",
	"I should believe in myself",
	"I had a bad day today",
	"I had a good day today",
	"I am the best at basketball",
	"I'm the best singer in my school",
	"Should I get Burger King or McDonalds",
	"Humans invented Mondays.<br /> Nature never said the <br /> week had to restart",
	"Did I lock the door when I left?",
	"Why did that person say that to me",
	"I should drink more water.",
	"Why are my parents so mean to me",

}

-- add a bindable event around here to change exp to new exp
userInputService.InputBegan:Connect(function(input, isTyping)
	if isTyping then return end
	inputModule.Input(character, hotBarEquip, input)

	local key = input.KeyCode
	-- enlightenment text indicator
	if meditationEXPAttributes.EXP == maxEXPRequirements.MeditationRequsites[100] and  meditationEXPAttributes.ObservationEXP == maxEXPRequirements.MeditationRequisites[100]  and not character:GetAttribute("Enlightened") --[[and beginnerEXPS == maxEXPRequirements.Requisites[10] and allAdvancedRequisites == maxEXPRequirements.Requisites[10]--]] then
		enlightText.Visible = true
	end
	-- to activate enligthenment when the character meets exp requirements
	if input.KeyCode == Enum.KeyCode.E and not character:GetAttribute("Enlightened") and meditationEXPAttributes.EXP == maxEXPRequirements.MeditationRequsites[100] and meditationEXPAttributes.ObservationEXP == maxEXPRequirements.MeditationRequsites[100]  --[[and allAdvancedRequisites == maxEXPRequirements.Requisites[10]--]] then
		MeditationGUI.Enabled = false


		character:SetAttribute("Enlightened", true)
		enlightenmentScene.AnimPlayer(character, anims.enlightenmentAnim)
		anims.enlightenmentAnim.Ended:Connect(function()
			print("stopped")
			enlightText.Visible = false
			MeditationGUI.Enabled = true
		end)
		return
	end
	
	if keyBeingUsed and key ~= Enum.KeyCode[keyBeingUsed] then
		return
	end
	local paths = meditationPaths.Paths[key]
	-- Activates different meditation actions
	if paths and paths.canMeditate(db, equipped) then
		print("Meditating path keycode")
		
		keyBeingUsed = key.Name
		count += 1
		
		character:SetAttribute("meditationCount", count)
		meditationPaths:Init()
		paths.activateMeditation(paths,buildContext())


	end

end)

