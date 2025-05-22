-- made by kamalsarasq

-- // VARIABLES //
local screenGui = script.Parent.Parent
local textBox = screenGui.Frame.Message.TextBox
local sendButton = textBox.ImageButton

-- // CHAT BLOCK HANDLER //
local chatBlock = require(script.Parent.CHAT_BLOCK)

-- // DEFAULT TEXT //
local defaultTextBoxText = "Please type your message here."

-- // REMOTE //
local requestServer = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("requestServer")

-- // SOUNDS //
--[[local sounds = {}
for _, sound in pairs(game:GetService("SoundService"):GetChildren()) do
	sounds[sound.Name] = sound
end]]

-- // PLACEHOLDERS //
local errorPlaceholder = "Action is on cooldown or contains invalid text."

-- // COOLDOWN //
local onCooldown = false

-- // FUNCTION TO SEND REQUEST TO SERVER //
local function sendRequest(PROMPT: string)
	-- creating a chat block for bot and getting the text label
	local botChatBlock = chatBlock.new(false, screenGui.Frame.MessageHolder, "Thinking..."):Create()
	-- requesting the server to get the bot reply
	local result = requestServer:InvokeServer(PROMPT)
	if result then
		-- replacing the defualt text with the result from server
		botChatBlock.TextLabel.Text = result
		botChatBlock:Animate()
		botChatBlock:PlaySound()
		return
	end	
	
	-- if failed then we change the text to
	botChatBlock.TextLabel.Text = "Failed, please try again!"
end

-- // FUNCTION TO SHOW ERROR IN PLACEHOLDER TEXT //
local function showPlaceholderError()
	textBox.Text = "" -- clearing the Text

	task.spawn(function()
		textBox.PlaceholderText = errorPlaceholder
		task.wait(1)
		textBox.PlaceholderText = defaultTextBoxText
	end)
end


local function onButtonActivated()
	local PROMPT = textBox.Text
	if onCooldown or PROMPT == "" then showPlaceholderError() warn("Returned") return end
	
	onCooldown = true -- turning on cooldown
	textBox.Text = "" -- clearing the TextBox
	
	local userChatBlock = chatBlock.new(true, screenGui.Frame.MessageHolder, PROMPT):Create()
	
	-- sending request to server to get AI response
	sendRequest(PROMPT)

	task.wait(1)
	-- turning off cooldown after 1 second wait
	onCooldown = false
end

-- // VALUES //
local TRANSPARENT = 0.77
local OPAQUE = 0

-- // STATE //
local isWhite = false

-- // FUNCTION TO UPDATE BUTTON TRANSPARENCY //
local function updateButtonTransparency()
	local hasText = textBox.Text ~= ""
	
	if hasText ~= isWhite then
		isWhite = hasText
		sendButton.ImageTransparency = hasText and OPAQUE or TRANSPARENT
	end
end

-- // CONNECTING TO BUTTON ACTIVATED //
sendButton.Activated:Connect(onButtonActivated)

-- // CONNECTING TO WHEN TEXTBOX TEXT CHANGES //
textBox:GetPropertyChangedSignal("Text"):Connect(updateButtonTransparency)
