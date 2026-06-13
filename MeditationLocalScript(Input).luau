local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local playerGui = plr.PlayerGui
local humanoid = character:FindFirstChild("Humanoid")
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
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
local expChange = require(replicatedStorage.modules:FindFirstChild("EXPmodule"))
local maxEXPRequirements = require(replicatedStorage.modules:FindFirstChild("Max_EXP_Requirements"))
local enlightenmentPackage = replicatedStorage.CinematicAnimations.Example2
local enlightenmentScene = require(enlightenmentPackage.AnimPlayer2)
local expBar = playerGui:FindFirstChild("ScreenGui").ExpBar.BarFrame.EXP
local MeditationFrame = playerGui:FindFirstChild("ScreenGui").Skills.Meditation
local cooldownText = playerGui.ScreenGui.Cool.Cooldown
local levelText = playerGui:FindFirstChild("ScreenGui").LevelUp:FindFirstChild("Level")
local frameForEnlight = playerGui:FindFirstChild("ScreenGui").Enlight.Frame
local enlightText = frameForEnlight.TextLabel
local doesntMeetRequirement = playerGui:FindFirstChild("ScreenGui").LevelUp.Does_Not_Meet_Level_Requirement
local barSize = expBar.Size
local EXP = character:GetAttribute("EXP")
local MaxEXP = character:GetAttribute("MaxEXP")
local text = expBar.Parent.Parent.TextLabel
local levelChanged = replicatedStorage:FindFirstChild("bindableEvents").LevelChanged
local ratesAndNumber = replicatedStorage.bindableEvents.RatesAndNumber
local breathVFX = replicatedStorage.ClonedItems.VFX.BreathVFX:Clone()
local BreathRemote = replicatedStorage.remoteEvents.BreathVFX
local enlightenmentRemote = replicatedStorage.remoteEvents.EnlightenmentEvent
local meditationRemote = replicatedStorage.remoteEvents.MeditationRemote
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


-- tables
local anims = {
	startMeditation = humanoid.Animator:LoadAnimation(script.startmeditationpose), 
	focusMeditation = humanoid.Animator:LoadAnimation(script.meditationposeidle),
	enlightenmentAnim = humanoid.Animator:LoadAnimation(script.Enlightenment)
}


--[[local meditationLevels = {
	apathyLevel = character:GetAttribute("apathyLevel"),
	griefLevel = character:GetAttribute("griefLevel"),
	fearLevel = character:GetAttribute("fearLevel"),
	angerLevel = character:GetAttribute("angerLevel"),
	
	advancedMeditation = {
		courageLevel = character:GetAttribute("CourageLevel")	
	}
	
}--]]

local levelRequirements = {5, 10, 15, 25, 50, 60, 75, 100}


local leaderstats = plr.leaderstats
local FocusStats = plr:WaitForChild("MeditationFolder").FocusStats
local ApathyStats = plr.MeditationFolder:WaitForChild("ApathyStats")
local GriefStats = plr.MeditationFolder:WaitForChild("GriefStats")
local FearStats = plr.MeditationFolder:WaitForChild("FearStats")
local AngerStats = plr.MeditationFolder:WaitForChild("AngerStats")
local CourageStats = plr.MeditationFolder:WaitForChild("CourageStats")
local DesireStats = plr.MeditationFolder:WaitForChild("DesireStats")
local PurposeStats = plr.MeditationFolder:WaitForChild("PurposeStats")
local LoveStats = plr.MeditationFolder:WaitForChild("LoveStats")

-- gets rates from server
local rates = {
			focusRate = {rate = FocusStats:WaitForChild("FocusRate").Value, number = FocusStats:WaitForChild("FocusAddend").Value},
			apathyRate = {rate = ApathyStats:WaitForChild("ApathyRate").Value, number = ApathyStats:WaitForChild("ApathyAddend").Value},
			griefRate = {rate = GriefStats:WaitForChild("GriefRate").Value, number = GriefStats:WaitForChild("GriefAddend").Value},
			fearRate = {rate = FearStats:WaitForChild("FearRate").Value, number = FearStats:WaitForChild("FearAddend").Value},
			angerRate = {rate = AngerStats:WaitForChild("AngerRate").Value, number = AngerStats:WaitForChild("AngerAddend").Value},
			courageRate = {rate = CourageStats:WaitForChild("CourageRate").Value, number = CourageStats:WaitForChild("CourageAddend").Value},
			desireRate = {rate = DesireStats:WaitForChild("DesireRate").Value, number = DesireStats:WaitForChild("DesireAddend").Value},
			purposeRate = {rate = PurposeStats:WaitForChild("PurposeRate").Value, number = PurposeStats:WaitForChild("PurposeAddend").Value},
			loveRate = {rate = LoveStats:WaitForChild("LoveRate").Value, number = LoveStats:WaitForChild("LoveAddend").Value},
		}
		

print(rates.focusRate)

print(FocusStats.FocusRate.Value)





--local rates = {
--	focusRate = {rate = 1, number = 1},
--	apathyRate = {rate = 1, number = 1},
--	griefRate = {rate = 1, number = 1},
--	fearRate = {rate = 1, number = 1},
--	angerRate = {rate = 0.6, number = 20},
--	courageRate = {rate = 1, number = 1},
--	desireRate = {rate = 1, number = 1},
--	purposeRate = {rate = 1, number = 1},
--	loveRate = {rate = 1, number = 1},
--}

-- updates the rates and addends for the exp calculation
local function changeRatesAndAddends(newRate, newAddend, levelName)
	if levelName == "Level" then
		rates.focusRate.rate = newRate
		rates.focusRate.number = newAddend
		print(rates.focusRate)
	elseif levelName == "ApathyLevel" then
		rates.apathyRate.rate = newRate
		rates.apathyRate.number = newAddend
	elseif levelName == "GriefLevel" then
		rates.griefRate.rate = newRate
		rates.griefRate.number = newAddend
	elseif levelName == "FearLevel" then
		rates.fearRate.rate = newRate
		rates.fearRate.number = newAddend
	elseif levelName == "AngerLevel" then
		rates.angerRate.rate = newRate
		rates.angerRate.number = newAddend
	elseif levelName == "CourageLevel" then
		rates.angerRate.rate = newRate
		rates.angerRate.number = newAddend
	elseif levelName == "DesireLevel" then
		rates.angerRate.rate = newRate
		rates.angerRate.number = newAddend
	elseif levelName == "PurposeLevel" then
		rates.angerRate.rate = newRate
		rates.angerRate.number = newAddend
	end
end

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

-- anims connection events for whenever the player reaches enlightenment
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

-- attribute changedsignal to update variables that contain attributes
character:GetAttributeChangedSignal("hotBarEquip"):Connect(function()
	hotBarEquip = character:GetAttribute("hotBarEquip")
	-- to indicate that player is using the meditation slot
	hotBarModule.HotBarSelect(character, MeditationFrame, hotBarEquip)
end)

character:GetAttributeChangedSignal("equipped"):Connect(function()
	equipped = character:GetAttribute("equipped")
	print(equipped)
end)

local function debounceFunction(message)
	db = false
end


-- cooldown for when the player is done meditating
local function reset(seconds)
	if count == 2 then
		debounceTime = seconds

		task.delay(1.5, function()
			count = 0
			print(count)
			keyBeingUsed = nil
		--[[print(keyBeingUsed['key'])
		print(debounceTime)--]]
			return count
		end)
	end
end
-- cooldown for when the player unequips the the meditation slot
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

-- tweens text whenever the player doesn't meet the level requirements
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
	-- loads players exp bar text and the level text
	
	text.Text = "EXP: "..character:GetAttribute("EXP").."/"..character:GetAttribute("MaxEXP")
	levelText.Text = "Level:"..level
	
	-- loads exp bar when the player joins the game
	expBarModule:BarChange(character:GetAttribute("MaxEXP"), expBar, expBar.Size, character, "EXP", Color3.fromRGB(34, 152, 255))
	-- gets rate server values

	rates = {
		focusRate = {rate = FocusStats:WaitForChild("FocusRate").Value, number = FocusStats:WaitForChild("FocusAddend").Value},
		apathyRate = {rate = ApathyStats:WaitForChild("ApathyRate").Value, number = ApathyStats:WaitForChild("ApathyAddend").Value},
		griefRate = {rate = GriefStats:WaitForChild("GriefRate").Value, number = GriefStats:WaitForChild("GriefAddend").Value},
		fearRate = {rate = FearStats:WaitForChild("FearRate").Value, number = FearStats:WaitForChild("FearAddend").Value},
		angerRate = {rate = AngerStats:WaitForChild("AngerRate").Value, number = AngerStats:WaitForChild("AngerAddend").Value},
		courageRate = {rate = CourageStats:WaitForChild("CourageRate").Value, number = CourageStats:WaitForChild("CourageAddend").Value},
		desireRate = {rate = DesireStats:WaitForChild("DesireRate").Value, number = DesireStats:WaitForChild("DesireAddend").Value},
		purposeRate = {rate = PurposeStats:WaitForChild("PurposeRate").Value, number = PurposeStats:WaitForChild("PurposeAddend").Value},
		loveRate = {rate = LoveStats:WaitForChild("LoveRate").Value, number = LoveStats:WaitForChild("LoveAddend").Value},
	}

	print(rates.focusRate)

	print(plr.MeditationFolder.FocusStats.FocusRate.Value)
end)

 -- add a bindable event around here to change exp to new exp
userInputService.InputBegan:Connect(function(input, isTyping)
	if isTyping then return end
	inputModule.Input(character, hotBarEquip, input)
	local meditationEXPAttributes = {
		EXP = character:GetAttribute("EXP"),
		
		beginnerEXPAttributes = {
			apathyEXP = character:GetAttribute("apathyEXP"),
			griefEXP = character:GetAttribute("griefEXP"),
			fearEXP = character:GetAttribute("fearEXP"),
			angerEXP = character:GetAttribute("angerEXP"),
		},
		
		
		advancedEXPAttributes = {
			courageEXP = character:GetAttribute("courageEXP"),
			desireEXP = character:GetAttribute("desireEXP"),
			purposeEXP = character:GetAttribute("purposeEXP"),
			loveEXP = character:GetAttribute("loveEXP"),
		}
	}
	
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
	
	
	for i, v in pairs(meditationEXPAttributes.beginnerEXPAttributes) do
		beginnerEXPS = v
	end
	
	for i, x in pairs(meditationEXPAttributes.advancedEXPAttributes) do
		if x ~= meditationEXPAttributes.advancedEXPAttributes.loveEXP then
			advancedEXPS = x
		end
	end
	
	for i, allAdvancedEXPS in pairs(meditationEXPAttributes.advancedEXPAttributes) do
		allAdvancedRequisites = allAdvancedEXPS
	end
	
	local state = {hotBarEquip = character:GetAttribute("hotBarEquip")}
	
	
	
	local key = input.KeyCode
	
	--used so that players don't spam different meditations at the same time.
	if keyBeingUsed and key ~= Enum.KeyCode[keyBeingUsed] then
		return
	end
	
	if meditationEXPAttributes.EXP == maxEXPRequirements.FocusRequisites[100] and not character:GetAttribute("Enlightened") and beginnerEXPS == maxEXPRequirements.Requisites[10] and allAdvancedRequisites == maxEXPRequirements.Requisites[10] then
		enlightText.Visible = true
	
	end
	-- this is for whenever the player reaches enlightenment
	if input.KeyCode == Enum.KeyCode.E and not character:GetAttribute("Enlightened") and meditationEXPAttributes.EXP == maxEXPRequirements.FocusRequisites[100] and beginnerEXPS == maxEXPRequirements.Requisites[10] and allAdvancedRequisites == maxEXPRequirements.Requisites[10] then
		--playerGui.ScreenGui.Enabled = false
		
		
		character:SetAttribute("Enlightened", true)
		enlightenmentScene.AnimPlayer(character, anims.enlightenmentAnim)
		anims.enlightenmentAnim.Ended:Connect(function()
			print("stopped")
			enlightText.Visible = false
			playerGui.ScreenGui.Enabled = true
		end)
	end
	
	--[[levelChanged.Event:Connect(function(meditationLevels)
		meditationLevels = meditationLevels
	end)--]]
	
	-- normal meditation
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
		
		--cooldown on the bottom right for whenever the player isn't meditating anymore
		cooldownModule.Cooldown(debounceTime, cooldownText, "Focus Meditation: ", hotBarEquip)
		print(plr, character, levelText)
		--updates level gui and text for that specific meditation
		levelModuleGUI.LevelGUI(plr,character, "Level", levelText, "Level: ", Color3.fromRGB(244, 255, 41), rates.focusRate.rate, rates.focusRate.number)
		-- increments the exp for that specific meditation
		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation, rates.focusRate.rate, "EXP", "MaxEXP",meditationEXPAttributes.EXP, meditationMaxEXPAttributes.MaxEXP, rates.focusRate.number, state.hotBarEquip, count)
		
		-- updates the exp bar ui for the specific meditation
		expChange.ExpChange("EXP", "MaxEXP", maxEXPRequirements.FocusRequisites, character, "Level", text,expBar, barSize, Color3.fromRGB(34, 152, 255))
		
		task.delay(debounceTime, debounceFunction)
		
	elseif key == Enum.KeyCode.Z and not db and equipped then
		-- this is for if the player doesn't meet the level requirement 
		if level < levelRequirements[1] then
			tweenTextTransparencyHandler("Apathy Meditation")
			return
	end
		
		print(not keyBeingUsed)
		if not keyBeingUsed then
			keyBeingUsed = "Z"
		end
		
		
		db = true
		debounceTime = 0.7
		count = count + 1
		
		task.spawn(exitMeditatingHotBar)
		
		reset(5)


		levelModuleGUI.LevelGUI(plr,character, "ApathyLevel", levelText, "Apathy Level: ", Color3.fromRGB(75, 75, 75), rates.apathyRate.rate, rates.apathyRate.number)

		cooldownModule.Cooldown(debounceTime, cooldownText, "Apathy Meditation: ", equipped)

		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation, rates.apathyRate.rate, "apathyEXP", "apathyMaxEXP",meditationEXPAttributes.beginnerEXPAttributes.apathyEXP, meditationMaxEXPAttributes.apathyMaxEXP, rates.apathyRate.number, equipped, count)
		
		expChange.ExpChange("apathyEXP", "apathyMaxEXP", maxEXPRequirements.Requisites, character, "ApathyLevel", text,expBar, barSize, Color3.fromRGB(53, 50, 57))
		
		task.delay(debounceTime, debounceFunction)
	
	
	elseif key == Enum.KeyCode.G and not db and equipped then
		if level < levelRequirements[2] then
			tweenTextTransparencyHandler("Grief Meditation")
			return
		end
		if not keyBeingUsed then
			keyBeingUsed = "G"
		end
	

		db = true
		debounceTime = 0.7
		count = count + 1

		task.spawn(exitMeditatingHotBar)

		reset(5)


		levelModuleGUI.LevelGUI(plr,character, "GriefLevel", levelText, "Grief Level: ", Color3.fromRGB(32, 36, 255), rates.griefRate.rate, rates.griefRate.number)
		
		expChange.ExpChange("griefEXP", "griefMaxEXP", maxEXPRequirements.Requisites, character, "GriefLevel", text,expBar, barSize, Color3.fromRGB(55, 61, 94))

		cooldownModule.Cooldown(debounceTime, cooldownText, "Grief Meditation: ", equipped)

		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation, rates.griefRate.rate, "griefEXP", "griefMaxEXP",meditationEXPAttributes.beginnerEXPAttributes.griefEXP, meditationMaxEXPAttributes.griefMaxEXP,  rates.griefRate.number, equipped, count)

		task.delay(debounceTime, debounceFunction)
	elseif key == Enum.KeyCode.F and not db and equipped then
		if level < levelRequirements[3] then
			tweenTextTransparencyHandler("Fear Meditation")
			return
		end
		if not keyBeingUsed then
			keyBeingUsed = "F"
		end

		db = true
		debounceTime = 0.7
		count = count + 1

		task.spawn(exitMeditatingHotBar)

		reset(5)

		
		levelModuleGUI.LevelGUI(plr,character, "FearLevel", levelText, "Fear Level: ", Color3.fromRGB(167, 16, 255), rates.fearRate.rate, rates.fearRate.number)
		
		expChange.ExpChange("fearEXP", "fearMaxEXP", maxEXPRequirements.Requisites, character, "FearLevel", text,expBar, barSize, Color3.fromRGB(170, 0, 255))

		cooldownModule.Cooldown(debounceTime, cooldownText, "Fear Meditation: ", equipped)

		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation,  rates.fearRate.rate, "fearEXP", "fearMaxEXP",meditationEXPAttributes.beginnerEXPAttributes.fearEXP, meditationMaxEXPAttributes.fearMaxEXP,  rates.fearRate.number, equipped, count)

		task.delay(debounceTime, debounceFunction)
	elseif key == Enum.KeyCode.B and not db and equipped then
		if level < levelRequirements[4] then
			tweenTextTransparencyHandler("Anger Meditation")
			return
		end
		if not keyBeingUsed then
			keyBeingUsed = "B"
		end

		db = true
		debounceTime = 0.7
		count = count + 1

		task.spawn(exitMeditatingHotBar)

		reset(5)

		levelModuleGUI.LevelGUI(plr,character, "AngerLevel", levelText, "Anger Level: ", Color3.fromRGB(170, 0, 0), rates.angerRate.rate, rates.angerRate.number)
		
		expChange.ExpChange("angerEXP", "angerMaxEXP", maxEXPRequirements.Requisites, character, "AngerLevel", text,expBar, barSize, Color3.fromRGB(255, 0, 4))
		
		cooldownModule.Cooldown(debounceTime, cooldownText, "Anger Meditation: ", equipped)

		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation, rates.angerRate.rate, "angerEXP", "angerMaxEXP",meditationEXPAttributes.beginnerEXPAttributes.angerEXP, meditationMaxEXPAttributes.angerMaxEXP, rates.angerRate.number, equipped, count)

		task.delay(debounceTime, debounceFunction)
	
	elseif key == Enum.KeyCode.C and not db and equipped then
		
		if level < levelRequirements[5] and beginnerEXPS ~= maxEXPRequirements.Requisites[10] then
			tweenTextTransparencyHandler("Courage Meditation, you need to max out beginner meditations")
			return
		end
		
		if not keyBeingUsed then
			keyBeingUsed = "C"
		end

		db = true
		debounceTime = 0.7
		count = count + 1

		task.spawn(exitMeditatingHotBar)

		reset(5)

		levelModuleGUI.LevelGUI(plr,character, "CourageLevel", levelText, "Courage Level: ", Color3.fromRGB(255, 214, 48), rates.courageRate.rate, rates.courageRate.number)
		
		expChange.ExpChange("courageEXP", "courageMaxEXP", maxEXPRequirements.Requisites, character, "CourageLevel", text,expBar, barSize, Color3.fromRGB(255, 255, 0))
		
		cooldownModule.Cooldown(debounceTime, cooldownText, "Courage Meditation: ", equipped)

		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation, rates.courageRate.rate, "courageEXP", "courageMaxEXP",meditationEXPAttributes.advancedEXPAttributes.courageEXP, meditationMaxEXPAttributes.advancedMaxEXPAttributes.courageMaxEXP, rates.courageRate.number, equipped, count)
		
		task.delay(debounceTime, debounceFunction)
	elseif key == Enum.KeyCode.T and not db and equipped then
		if level < levelRequirements[6] and beginnerEXPS ~= maxEXPRequirements.Requisites[10] then
			tweenTextTransparencyHandler("Desire Meditation, you need to max out beginner meditations")
			return
		end

		if not keyBeingUsed then
			keyBeingUsed = "T"
		end

		db = true
		debounceTime = 0.7
		count = count + 1

		task.spawn(exitMeditatingHotBar)

		reset(5)

		levelModuleGUI.LevelGUI(plr,character, "DesireLevel", levelText, "Desire Level: ", Color3.fromRGB(138, 255, 103), rates.desireRate.rate, rates.desireRate.number)
		
		expChange.ExpChange("desireEXP", "desireMaxEXP", maxEXPRequirements.Requisites, character, "DesireLevel", text,expBar, barSize, Color3.fromRGB(55, 193, 55))

		cooldownModule.Cooldown(debounceTime, cooldownText, "Desire Meditation: ", equipped)

		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation, rates.desireRate.rate, "desireEXP", "desireMaxEXP",meditationEXPAttributes.advancedEXPAttributes.desireEXP, meditationMaxEXPAttributes.advancedMaxEXPAttributes.desireMaxEXP, rates.desireRate.number, equipped, count)

		task.delay(debounceTime, debounceFunction)
	elseif key == Enum.KeyCode.P and not db and equipped then
		if level < levelRequirements[7] and beginnerEXPS ~= maxEXPRequirements.Requisites[10] then
			tweenTextTransparencyHandler("Purpose Meditation, you need to max out beginner meditations")
			return
		end
		
		if not keyBeingUsed then
			keyBeingUsed = "P"
		end

		db = true
		debounceTime = 0.7
		count = count + 1

		task.spawn(exitMeditatingHotBar)

		reset(5)

		levelModuleGUI.LevelGUI(plr,character, "PurposeLevel", levelText, "Purpose Level: ", Color3.fromRGB(255, 160, 76), rates.purposeRate.rate, rates.purposeRate.number)
		
		expChange.ExpChange("purposeEXP", "purposeMaxEXP", maxEXPRequirements.Requisites, character, "PurposeLevel", text,expBar, barSize, Color3.fromRGB(255, 171, 53))

		cooldownModule.Cooldown(debounceTime, cooldownText, "Purpose Meditation: ", equipped)

		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation, rates.purposeRate.rate, "purposeEXP", "purposeMaxEXP",meditationEXPAttributes.advancedEXPAttributes.purposeEXP, meditationMaxEXPAttributes.advancedMaxEXPAttributes.purposeMaxEXP, rates.purposeRate.number, equipped, count)

		task.delay(debounceTime, debounceFunction)
	elseif key == Enum.KeyCode.L and not db and equipped then
		if level < levelRequirements[8] and beginnerEXPS ~= maxEXPRequirements.Requisites[10] and advancedEXPS ~= maxEXPRequirements.Requisites[10] then
			tweenTextTransparencyHandler("Love Meditation, you need to max out beginner meditations and the first three advanced meditations")
			return
		end

		if not keyBeingUsed then
			keyBeingUsed = "L"
		end

		db = true
		debounceTime = 0.7
		count = count + 1

		task.spawn(exitMeditatingHotBar)

		reset(5)

		levelModuleGUI.LevelGUI(plr,character, "LoveLevel", levelText, "Love Level: ", Color3.fromRGB(255, 25, 251), rates.loveRate.rate, rates.loveRate.number)

		expChange.ExpChange("loveEXP", "loveMaxEXP", maxEXPRequirements.Requisites, character, "LoveLevel", text,expBar, barSize, Color3.fromRGB(255, 170, 255))

		cooldownModule.Cooldown(debounceTime, cooldownText, "Love Meditation: ", equipped)

		meditationModule.MeditationGain(plr,character, anims.startMeditation, anims.focusMeditation, rates.loveRate.rate, "loveEXP", "loveMaxEXP",meditationEXPAttributes.advancedEXPAttributes.loveEXP, meditationMaxEXPAttributes.advancedMaxEXPAttributes.loveMaxEXP, rates.loveRate.number, equipped, count)

		task.delay(debounceTime, debounceFunction)
	end

end)

