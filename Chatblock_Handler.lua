-- // SERVICES //
local TweenService = game:GetService("TweenService")

-- // CHATBLOCK //
local ChatBlock = {}
ChatBlock.__index = ChatBlock

-- // CONSTRUCTOR // --
function ChatBlock.new(chatModel: boolean, parentInstance: ScrollingFrame, startMessage: string, PlaySound: Sound)
	local newChatBlock = {}
	setmetatable(newChatBlock, ChatBlock)
	
	newChatBlock.NewClone = nil
	newChatBlock.StartMessage = startMessage or "thinking..."
	newChatBlock.ParentInstance = parentInstance
	newChatBlock.ChatModel = chatModel
	newChatBlock.UserMessage = game:GetService("ReplicatedStorage")
		                                              :WaitForChild("CHAT_BLOCKS_TEMPLATE")
													  :WaitForChild("UserMessage")
	newChatBlock.BotMessage = game:GetService("ReplicatedStorage")
													  :WaitForChild("CHAT_BLOCKS_TEMPLATE")
													  :WaitForChild("BotMessage")
	
	newChatBlock.Template = function()
		
		if not newChatBlock.ChatModel then
			return newChatBlock.BotMessage
		end
		return newChatBlock.UserMessage
	end
	
	newChatBlock.Sound = PlaySound or game:GetService("SoundService")
										  :WaitForChild("Notification")
										
	-- newChatBlock.MessagePath = newChatBlock.Template()    
	
	return newChatBlock
end

-- // FUNCTION TO TWEEN TRANSPARENCY OF THE WHOLE BLOCK TO ANIMATE //
function ChatBlock:Animate(tweenInfo)
	local info = tweenInfo or TweenInfo.new(0.2, Enum.EasingStyle.Quad)
	local transparencyStart = 1

	for _, UIElement in pairs(self.NewClone:GetDescendants()) do
		if UIElement:IsA("TextLabel") then
			UIElement.TextTransparency = transparencyStart

			local goal = {TextTransparency = 0}
			TweenService:Create(UIElement, info, goal):Play()

		elseif UIElement:IsA("Frame") then
			UIElement.BackgroundTransparency = transparencyStart

			local goal = {BackgroundTransparency = 0}
			TweenService:Create(UIElement, info, goal):Play()
		end
	end
end

-- // FUNCTION TO PLAY NOTIFICATION SOUND //
function ChatBlock:PlaySound()
	self.Sound:Play()
end

-- // FUNCTION TO GET THE TEXT LABEL FROM THE CHAT MODEL //
function ChatBlock:GetTextLabel()
	for _, descendant in pairs(self.NewClone:GetDescendants()) do
		if not descendant:IsA("TextLabel") then continue end
		return descendant
	end
end

-- // FUNCTION TO CREATE A CHAT BLOCK //
function ChatBlock:Create()
	local templateClone = self.Template():Clone()

	self.NewClone = templateClone

	self.TextLabel = self:GetTextLabel()
	self.TextLabel.Text = self.StartMessage
	self.NewClone.Parent = self.ParentInstance
	
	return self
end

return ChatBlock
