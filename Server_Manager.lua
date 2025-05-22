-- made by kamalsarasq

-- // VARIABLES //
local remoteFunction = game.ReplicatedStorage.Events.requestServer
local Request = require(script.Parent.Request)

-- // HTTP INFORMATION //
local API_KEY = "api key goes here"
local url = "https://api.openai.com/v1/chat/completions"

-- // SERVICES //
local chat = game:GetService("Chat")

-- // FUNCTIONS TABLE //
local functions = {}

-- // COOLDOWN TRACKING //
local cooldowns = {}

-- // FUNCTION TO VERIFY REQUESTS //
functions.VerifyRequest = function(player: Player)
	local userId = player.UserId

	if not cooldowns[userId] then
		cooldowns[userId] = true

		-- remove from cooldown after 1 second
		task.delay(1, function()
			cooldowns[userId] = nil
		end)

		return true
	end

	return false
end

-- // FUNCTION TO CONTRUCT THE BODY //
local function ConstructBody(player: Player, prompt: string)
	return {
		model = "gpt-3.5-turbo",
		messages = {
			{ role = "user", content = player.DisplayName .. ": " .. prompt }
		}
	}
end

-- // HANDLING REQUESTS ON SERVER //
remoteFunction.OnServerInvoke = function(player: Player, PROMT: string)
	-- verifying the request
	local isAllowed = functions.VerifyRequest(player)
	if not isAllowed then return end
	
	-- making a request to ClosedAI
	local Request = Request.new(url, API_KEY, nil, ConstructBody(player, PROMT))
	local result = Request:Request()
		
	if result then
		-- if there was a result then returning the result
		return result
	end
			-- if not result then returning false
	return false
end
