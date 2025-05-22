-- made by kamalsarasq

-- // SERVICES //
local HttpService = game:GetService("HttpService")

-- // FUNCTION TO MANIPULATE STRING //
local RequestHandler = {}
RequestHandler.__index = RequestHandler

-- // CREATOR FUNCTION //
function RequestHandler.new(URL, API_KEY, HEADERS, BODY)
	local newRequestHandler = {}
	setmetatable(newRequestHandler, RequestHandler)

	-- properties
	newRequestHandler.Url = URL
	newRequestHandler.APIkey = API_KEY
	newRequestHandler.Headers = HEADERS or {
		["Authorization"] = "Bearer " .. newRequestHandler.APIkey,
		["Content-Type"] = "application/json"
	}

	newRequestHandler.Body = BODY
	warn(newRequestHandler.Body)

	return newRequestHandler
end

-- // REQUEST HANDLER //
function RequestHandler:Request()
	-- encoding body
	self.Body = HttpService:JSONEncode(self.Body)

	-- sending request to ClosedAI
	local response = HttpService:RequestAsync({
		Url = self.Url,
		Method = "POST",
		Headers = self.Headers,
		Body = self.Body
	})

	-- handling error
	if not response.Success then
		error("Request failed: " .. response.StatusCode .. " - " .. response.StatusMessage)
	end

	warn("success")
	-- decoding response
	local decodedResponse = HttpService:JSONDecode(response.Body)
	-- getting the message
	local chatGPTMessage = decodedResponse["choices"][1]["message"]["content"]
	return chatGPTMessage -- retunring AI message
end

return RequestHandler
