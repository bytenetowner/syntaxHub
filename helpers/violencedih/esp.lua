local nmqplayers = game:GetService("Players")
local nmqespmodule = {}
nmqespmodule.nmqboxenabled = false
nmqespmodule.nmqnameenabled = false

local function nmqgettorso(nmqcharacter)
	return nmqcharacter:FindFirstChild("Torso") or nmqcharacter:FindFirstChild("UpperTorso") or nmqcharacter:FindFirstChild("HumanoidRootPart")
end

nmqespmodule.nmqcreateboxesp = function(nmqplayer)
	local nmqcharacter = nmqplayer.Character
	if not nmqcharacter then return end
	local nmqtorso = nmqgettorso(nmqcharacter)
	if not nmqtorso then return end

	if nmqtorso:FindFirstChild("VerySpecificBoxEspBillboardGui") then
		nmqtorso.VerySpecificBoxEspBillboardGui:Destroy()
	end

	local nmqcolor = Color3.fromRGB(255, 255, 255)
	if nmqplayer.Team and nmqplayer.Team.Name == "Killer" then
		nmqcolor = Color3.fromRGB(255, 0, 0)
	end

	local nmqbillboardgui = Instance.new("BillboardGui")
	nmqbillboardgui.Name = "VerySpecificBoxEspBillboardGui"
	nmqbillboardgui.AlwaysOnTop = true
	nmqbillboardgui.Size = UDim2.new(4, 0, 5, 0)
	nmqbillboardgui.Adornee = nmqtorso
	nmqbillboardgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	nmqbillboardgui.Parent = nmqtorso

	local nmqoutlineframe = Instance.new("Frame")
	nmqoutlineframe.Name = "VerySpecificBoxEspOutlineFrame"
	nmqoutlineframe.Size = UDim2.new(1, 0, 1, 0)
	nmqoutlineframe.BackgroundTransparency = 1
	nmqoutlineframe.ZIndex = 1
	nmqoutlineframe.Parent = nmqbillboardgui

	local nmqoutlineuistroke = Instance.new("UIStroke")
	nmqoutlineuistroke.Name = "VerySpecificBoxEspOutlineUiStroke"
	nmqoutlineuistroke.Thickness = 2
	nmqoutlineuistroke.Color = Color3.fromRGB(0, 0, 0)
	nmqoutlineuistroke.Parent = nmqoutlineframe

	local nmqframe = Instance.new("Frame")
	nmqframe.Name = "VerySpecificBoxEspFrame"
	nmqframe.Size = UDim2.new(1, 0, 1, 0)
	nmqframe.BackgroundTransparency = 1
	nmqframe.ZIndex = 2
	nmqframe.Parent = nmqbillboardgui

	local nmquistroke = Instance.new("UIStroke")
	nmquistroke.Name = "VerySpecificBoxEspUiStroke"
	nmquistroke.Thickness = 1.5
	nmquistroke.Color = nmqcolor
	nmquistroke.Parent = nmqframe
end

nmqespmodule.nmqremoveboxesp = function(nmqplayer)
	local nmqcharacter = nmqplayer.Character
	if not nmqcharacter then return end
	local nmqtorso = nmqgettorso(nmqcharacter)
	if not nmqtorso then return end
	local nmqgui = nmqtorso:FindFirstChild("VerySpecificBoxEspBillboardGui")
	if nmqgui then
		nmqgui:Destroy()
	end
end

nmqespmodule.nmqcreatenameesp = function(nmqplayer)
	local nmqcharacter = nmqplayer.Character
	if not nmqcharacter then return end
	local nmqtorso = nmqgettorso(nmqcharacter)
	if not nmqtorso then return end

	if nmqtorso:FindFirstChild("VerySpecificNameEspBillboardGui") then
		nmqtorso.VerySpecificNameEspBillboardGui:Destroy()
	end

	local nmqcolor = Color3.fromRGB(255, 255, 255)
	if nmqplayer.Team and nmqplayer.Team.Name == "Killer" then
		nmqcolor = Color3.fromRGB(255, 0, 0)
	end

	local nmqbillboardgui = Instance.new("BillboardGui")
	nmqbillboardgui.Name = "VerySpecificNameEspBillboardGui"
	nmqbillboardgui.AlwaysOnTop = true
	nmqbillboardgui.Size = UDim2.new(4, 0, 5, 0)
	nmqbillboardgui.Adornee = nmqtorso
	nmqbillboardgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	nmqbillboardgui.Parent = nmqtorso

	local nmqtextlabel = Instance.new("TextLabel")
	nmqtextlabel.Name = "VerySpecificNameEspTextLabel"
	nmqtextlabel.Size = UDim2.new(1, 0, 1, 0)
	nmqtextlabel.Position = UDim2.new(0, 0, 0, 0)
	nmqtextlabel.BackgroundTransparency = 1
	nmqtextlabel.Text = nmqplayer.Name
	nmqtextlabel.TextColor3 = nmqcolor
	nmqtextlabel.TextSize = 14
	nmqtextlabel.Font = Enum.Font.SourceSansBold
	nmqtextlabel.TextXAlignment = Enum.TextXAlignment.Center
	nmqtextlabel.TextYAlignment = Enum.TextYAlignment.Center
	nmqtextlabel.Parent = nmqbillboardgui

	local nmqtextstroke = Instance.new("UIStroke")
	nmqtextstroke.Name = "VerySpecificTextLabelUiStroke"
	nmqtextstroke.Thickness = 0.5
	nmqtextstroke.Color = Color3.fromRGB(0, 0, 0)
	nmqtextstroke.Parent = nmqtextlabel
end

nmqespmodule.nmqremovenameesp = function(nmqplayer)
	local nmqcharacter = nmqplayer.Character
	if not nmqcharacter then return end
	local nmqtorso = nmqgettorso(nmqcharacter)
	if not nmqtorso then return end
	local nmqgui = nmqtorso:FindFirstChild("VerySpecificNameEspBillboardGui")
	if nmqgui then
		nmqgui:Destroy()
	end
end

local function nmqsetupesp(nmqplayer)
	nmqplayer.CharacterAdded:Connect(function(nmqcharacter)
		task.wait(0.5)
		if nmqespmodule.nmqboxenabled then
			nmqespmodule.nmqcreateboxesp(nmqplayer)
		end
		if nmqespmodule.nmqnameenabled then
			nmqespmodule.nmqcreatenameesp(nmqplayer)
		end
	end)

	nmqplayer:GetPropertyChangedSignal("Team"):Connect(function()
		if nmqespmodule.nmqboxenabled then
			nmqespmodule.nmqcreateboxesp(nmqplayer)
		end
		if nmqespmodule.nmqnameenabled then
			nmqespmodule.nmqcreatenameesp(nmqplayer)
		end
	end)
end

nmqplayers.PlayerAdded:Connect(nmqsetupesp)

for nmqi, nmqv in ipairs(nmqplayers:GetPlayers()) do
	if nmqv ~= nmqplayers.LocalPlayer then
		nmqsetupesp(nmqv)
	end
end

return nmqespmodule
