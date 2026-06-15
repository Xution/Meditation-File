local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local playerGui = plr.PlayerGui
local humanoid = character:FindFirstChild("Humanoid")
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

local itemSelectModule = require(replicatedStorage.modules:FindFirstChild("SelectedItem"))
local hotBarModule = require(replicatedStorage.modules:FindFirstChild("HotBarSelect"))
local expBarModule = require(replicatedStorage.modules:FindFirstChild("barModule"))
local inputModule = require(replicatedStorage.modules:FindFirstChild("InputModule"))
local meditationModule = require(replicatedStorage.modules:FindFirstChild("Meditationmodule"))
local transparentModule: ModuleScript = require(replicatedStorage.modules:FindFirstChild("TransparentBars"))
local cooldownModule = require(replicatedStorage.modules:FindFirstChild("Cooldownmodule"))
local levelModuleGUI = require(replicatedStorage.modules:FindFirstChild("LevelModuleGUI"))
local maxEXPRequirements = require(replicatedStorage.modules:FindFirstChild("Max_EXP_Requirements"))
local textTweenModule = require(replicatedStorage.modules:FindFirstChild("Tween_Text_Transparency_Module"))
local expChange = require(replicatedStorage.modules:FindFirstChild("AttributeChange")) -- change this later
local maxEXPRequirements = require(replicatedStorage.modules:FindFirstChild("Max_EXP_Requirements"))
local enlightenmentPackage = replicatedStorage:FindFirstChild("CinematicAnimations"):FindFirstChild("Example2")
local enlightenmentScene = require(enlightenmentPackage.AnimPlayer2)

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
local attributeEXPRemote = replicatedStorage:FindFirstChild("RemoteEvents").EXPAttributeRemote
local breathVFX = replicatedStorage.ClonedItems.VFX.BreathVFX:Clone()
local BreathRemote = replicatedStorage.RemoteEvents.BreathVFX
local enlightenmentRemote = replicatedStorage.RemoteEvents.EnlightenmentEvent
local meditationRemote = replicatedStorage.RemoteEvents.MeditationRemote
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

local rates = {
			focusRate = {rate = FocusStats:WaitForChild("FocusRate").Value, number = FocusStats:WaitForChild("FocusAddend").Value},
			observationRate = {rate = ObservationStats:WaitForChild("ObservationRate").Value, number = ObservationStats:WaitForChild("ObservationAddend").Value}
			
		}

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
-- find out whats wrong with observationRate
ratesAndNumber.Event:Connect(function(rate, number, levelName)
	print(rate, number)
	changeRatesAndAddends(rate, number, levelName)
end)

character:GetAttributeChangedSignal("Level"):Connect(function()
	level = character:GetAttribute("Level")
end)


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

local function isMouseWithinCircle(mousePosition)
	local circleRadius = expFrame.AbsoluteSize.X / 2
	local center = expFrame.AbsolutePosition + (expFrame.AbsoluteSize/2)
	--print((expFrame.AbsoluteSize/2), expFrame.AbsolutePosition)
	local distance = (mousePosition - center).Magnitude
	--print(expFrame.AbsoluteSize.X, distance)
	return distance <= circleRadius -- cant compare it to the diameter because the diameter will technically become the radius 
	-- making the distance from the circle too far and not within the circle.
end


local function tweenTextTransparencyHandler(message)
	if textDebounce then return end
	textDebounce = true
	textTweenModule.Tween(1.3, doesntMeetRequirement, message, UDim2.new(0.393, 0,0.172, 0), UDim2.new(0.393, 0,-0.172, 0))
	task.delay(3, function()
		textDebounce = false
	end)
	return
end
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
	local meditationEXPAttributes = {
		EXP = character:GetAttribute("EXP"),
		ObservationEXP = character:GetAttribute("observationEXP"),
		
	}

	
	local state = {hotBarEquip = character:GetAttribute("hotBarEquip")}
	
	
	
	local key = input.KeyCode
	
	if keyBeingUsed and key ~= Enum.KeyCode[keyBeingUsed] then
		return
	end
	
	if meditationEXPAttributes.EXP == maxEXPRequirements.MeditationRequsites[100] and  meditationEXPAttributes.ObservationEXP == maxEXPRequirements.MeditationRequisites[100]  and not character:GetAttribute("Enlightened") --[[and beginnerEXPS == maxEXPRequirements.Requisites[10] and allAdvancedRequisites == maxEXPRequirements.Requisites[10]--]] then
		enlightText.Visible = true
	end
	
	if input.KeyCode == Enum.KeyCode.E and not character:GetAttribute("Enlightened") and meditationEXPAttributes.EXP == maxEXPRequirements.MeditationRequsites[100] and meditationEXPAttributes.ObservationEXP == maxEXPRequirements.MeditationRequsites[100]  --[[and allAdvancedRequisites == maxEXPRequirements.Requisites[10]--]] then
		MeditationGUI.Enabled = false
		
		
		character:SetAttribute("Enlightened", true)
		enlightenmentScene.AnimPlayer(character, anims.enlightenmentAnim)
		anims.enlightenmentAnim.Ended:Connect(function()
			print("stopped")
			enlightText.Visible = false
			MeditationGUI.Enabled = true
		end)
	end
	

	if key == Enum.KeyCode.E and not db and equipped then
		print(not keyBeingUsed)
		if not keyBeingUsed then
			keyBeingUsed = "E"
		end
		
		
		db = true

		debounceTime = 0.7
		count = count + 1
		
		task.spawn(exitMeditatingHotBar)

		reset(5)
		
		cooldownModule.Cooldown(debounceTime, cooldownText, "Focus Meditation: ", hotBarEquip)
		print(plr, character, levelText)

		levelModuleGUI.LevelGUI(plr,character, "Level", levelText, "Level: ", Color3.fromRGB(244, 255, 41), rates.focusRate.rate, rates.focusRate.number)

		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation, rates.focusRate.rate, "EXP", "MaxEXP",meditationEXPAttributes.EXP, meditationMaxEXPAttributes.MaxEXP, rates.focusRate.number, state.hotBarEquip, count)

		expChange.ExpChange("EXP", "MaxEXP", maxEXPRequirements.MeditationRequsites, character, "Level", text,expBar, barSize, Color3.fromRGB(34, 152, 255), "MeditationRequisite")
		
		--meditationRemote:FireServer("FocusEXP", rates.focusRate.rate)
		print(maxEXPRequirements.MeditationRequsites)
		task.delay(debounceTime, debounceFunction)
		
	
	elseif key == Enum.KeyCode.Two and not db then
		
		db = true
		expFrame.Position = UDim2.new(0.451, 0, 0.376, 0)
		expFrame.Visible = true

		randomPosition = true
		randomThought.Text = RandomThoughtTable[math.random(1, #RandomThoughtTable)]
		
		debounceTime = 0.7
		count += 1
		
		reset(5)
		
		cooldownModule.Cooldown(debounceTime, cooldownText, "Observation Meditation: ", hotBarEquip)
		
		levelModuleGUI.LevelGUI(plr,character, "ObservationLevel", levelText, "Level: ", Color3.fromRGB(137, 255, 180), rates.observationRate.rate, rates.observationRate.number, "Observation")

		expChange.ExpChange("observationEXP", "observationMaxEXP", maxEXPRequirements.MeditationRequsites, character, "ObservationLevel", text,expBar, barSize, Color3.fromRGB(85, 170, 0), "MeditationRequisite")
		
		print(maxEXPRequirements.MeditationRequsites)
		local newtask = task.spawn(function()
			while expFrame.Visible do
				task.wait(10)
				randomXScale = (math.random(1, 90)/100)
				randomYScale = (math.random(1, 90)/100)
				expFrame.Position = UDim2.new(randomXScale, 0, randomYScale,0)
				randomThought.Text = RandomThoughtTable[math.random(1, #RandomThoughtTable)]
				--print(randomXScale, randomYScale)
				if count == 2 then
					break
				end

			end
		end)
		
		
		character:SetAttribute("Stunned", true)
		if count == 1 then
			anims.startMeditation:Play()
		end
		
		
		anims.startMeditation.Ended:Connect(function()
			anims.focusMeditation:Play()
		end)
		

		
	
		inCircleLoop = runService.RenderStepped:Connect(function()

			
			local mousePosition = Vector2.new(mouse.X, mouse.Y)
			ObservationEXP = character:GetAttribute("observationEXP")
			ObservationMaxEXP = character:GetAttribute("observationMaxEXP")
			
			if count == 2 or not equipped then
				anims.startMeditation:Stop()
				character:SetAttribute("Stunned", false)
				inCircleLoop:Disconnect()
				task.cancel(newtask)
			end
			if isMouseWithinCircle(mousePosition) and randomPosition and anims.focusMeditation.IsPlaying then --  change to and expFrane.Visible
				inFrame = true
				task.spawn(function()
					
					while inFrame and not db2 do
						db2 = true
						task.wait(0.1)

						print(rates.observationRate.rate)
						print("ENNTEERIngn")
									
					
						ObservationEXP += rates.observationRate.number
						character:SetAttribute("observationEXP", math.floor(ObservationEXP, ObservationMaxEXP))
						meditationRemote:FireServer("ObservationEXP", rates.observationRate.rate)
						attributeEXPRemote:FireServer("observationEXP", ObservationEXP, "observationMaxEXP", ObservationMaxEXP)
						
						task.wait(rates.observationRate.rate)
						db2 = false

					end
				end)


			else
				inFrame = false
			end



		end) 

		
		expButton.MouseButton1Click:Connect(function()
			if not clickDB then
				clickDB = true
				print("CLICK")
				
				task.delay(0.5, function()
					clickDB = false
				end)
			end
		end)

		
		task.delay(debounceTime, function()
			db = false
		end)
		
		if count == 2 then
			character:SetAttribute("Stunned", false)
			anims.focusMeditation:Stop()
			expFrame.Visible = false
			randomPosition = false
			--print(randomPosition)
			task.cancel(newtask)
			inCircleLoop:Disconnect()
			task.delay(1, function()
				count = 0
			end)
			
		end

		
	
	end

end)

