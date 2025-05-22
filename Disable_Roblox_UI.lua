local StarterGui = game:GetService("StarterGui")

-- disabling all ui elements
for _, element in pairs(Enum.CoreGuiType:GetEnumItems()) do
	StarterGui:SetCoreGuiEnabled(element, false)
end

-- disabling reset button
repeat
	task.wait(1)
	local success, errormesage = pcall(function()
		StarterGui:SetCore("ResetButtonCallback", false)
	end)
until success
