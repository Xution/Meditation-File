local module = {}
--local module.Courtounies = {meditationGain}
local state = {
	activeCoroutines = {},
	
	 playerState = {}
}


module.MeditationGain = function(plr,character,startupAnim, meditationAnim, rate, expString, maxEXPString,EXP, MaxEXP, addend, equipped, count)
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local bindableEvents = replicatedStorage:FindFirstChild("bindableEvents")
	local remoteEvents = replicatedStorage:FindFirstChild("remoteEvents")
	
	local levelChanged = bindableEvents.LevelChanged
	local ratesAndNumberUpdate = bindableEvents.RatesAndNumber
	local changedRatesAndNumber = bindableEvents.Changed_Rates_And_Number
	local attributeLevelRemote = remoteEvents.LevelAttributeRemote
	local attributeEXPRemote = remoteEvents.EXPAttributeRemote
	local ExpEvent = bindableEvents.EXPEvent
	local number
	local rates
	local newLevel
	local levelString
	local userID = plr.UserId
	local humanoid = character:FindFirstChild("Humanoid")
	
	--[[Updates exp and maxexp across to this module to update as the while loop below is constantly updating the exp/maxexp
	Additionally, it is doing the same with the level, rate, and addend as firing those values to the server--]]
	ExpEvent.Event:Connect(function(newEXP, newMaxEXP)
			EXP = character:GetAttribute(newEXP)
			MaxEXP = character:GetAttribute(newMaxEXP)
			print(EXP, MaxEXP)
			
		end)

		levelChanged.Event:Connect(function(level, levelAttribute, newRate, newAddend)
			newLevel = character:GetAttribute(levelAttribute)
			levelString = levelAttribute
			rate = newRate
			addend = newAddend
			print(levelString, newLevel)
			print(rate, addend)
			attributeLevelRemote:FireServer(levelString, newLevel, rate, addend)
			ratesAndNumberUpdate:Fire(rate, addend, levelString)
		end)

		--changedRatesAndNumber.Event:Connect(function(newRate, newAddend)
			
			
		--	--attributeLevelRemote:FireServer(levelString, newLevel, rate, addend)
			
		--end)
		
	
	
	
	
	-- causes player to be stunned when meditating

	character:SetAttribute("Stunned", true)
	print(count)
	local function gainRate(characterId)
		task.spawn(function()
			-- attaches the couroutine to the characterId so that meditation exp rate is not global and character only
			while state.activeCoroutines[characterId] and task.wait(rate) do
				equipped = character:GetAttribute("hotBarEquip")
				
				if meditationAnim.IsPlaying then			
					EXP = EXP + addend
					
					character:SetAttribute(expString, math.floor(EXP, MaxEXP))
					attributeEXPRemote:FireServer(expString, EXP, maxEXPString, MaxEXP)
					
					--[[stops the meditation if player presses the meditation key again or if the meditation tool is not equipped.
					As a result, the coroutine will break and the player will be able to move again.--]]
					if count == 2 or not equipped then
						meditationAnim:Stop()
						character:SetAttribute("Stunned", false)
																					
						state.activeCoroutines[characterId] = nil
						break
					end

				end
			end
		end)
		
	end
	
	local characterId = character:GetAttribute("UserId") or character.Name

	-- Stop previous one if running
	if state.activeCoroutines[characterId] then
		state.activeCoroutines[characterId] = nil
	end

	state.activeCoroutines[characterId] = true
	coroutine.wrap(function()
		gainRate(characterId)
	end)()


	
	-- If player presses meditation key the meditation plays.
	if count == 1 and startupAnim then
		startupAnim:Play()
	end
	
	
	print(count)

	
end


return module
