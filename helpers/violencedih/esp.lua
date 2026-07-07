if not getgenv().vdhelpers then
	getgenv().vdhelpers = {}
end

local uioplayers = game:GetService("Players")
local uiorunservice = game:GetService("RunService")
local uiocamera = workspace.CurrentCamera

local uioespmodule = {}
uioespmodule.poiboxenabled = false
uioespmodule.poinameenabled = false

local uioregistry = {}

local function uiogettorso(uiocharacter)
	return uiocharacter:FindFirstChild("Torso") or uiocharacter:FindFirstChild("UpperTorso") or uiocharacter:FindFirstChild("HumanoidRootPart")
end

local function uioaddplayer(uioplayer)
	if uioplayer == uioplayers.LocalPlayer then return end
	uioregistry[uioplayer] = {
		box = Drawing.new("Square"),
		outline = Drawing.new("Square"),
		text = Drawing.new("Text")
	}
	uioregistry[uioplayer].outline.Thickness = 3
	uioregistry[uioplayer].outline.Filled = false
	uioregistry[uioplayer].outline.Color = Color3.fromRGB(0, 0, 0)
	
	uioregistry[uioplayer].box.Thickness = 1
	uioregistry[uioplayer].box.Filled = false
	
	uioregistry[uioplayer].text.Size = 11
	uioregistry[uioplayer].text.Center = true
	uioregistry[uioplayer].text.Outline = true
	uioregistry[uioplayer].text.Font = 3
end

local function uioremoveplayer(uioplayer)
	if uioregistry[uioplayer] then
		uioregistry[uioplayer].box:Remove()
		uioregistry[uioplayer].outline:Remove()
		uioregistry[uioplayer].text:Remove()
		uioregistry[uioplayer] = nil
	end
end

uiorunservice.RenderStepped:Connect(function()
	for uioplayer, uiodraws in pairs(uioregistry) do
		local uiochar = uioplayer.Character
		local uiotorso = uiochar and uiogettorso(uiochar)
		if uiotorso and (uioespmodule.poiboxenabled or uioespmodule.poinameenabled) then
			local uiopos, uioonboard = uiocamera:WorldToViewportPoint(uiotorso.Position)
			if uioonboard then
				local uioheight = (uiocamera.ViewportSize.Y / uiopos.Z) * 3.5
				local uiowidth = uioheight * 0.75
				local uiocolor = Color3.fromRGB(255, 255, 255)
				if uioplayer.Team and uioplayer.Team.Name == "Killer" then
					uiocolor = Color3.fromRGB(255, 0, 0)
				end
				if uioespmodule.poiboxenabled then
					uiodraws.outline.Visible = true
					uiodraws.outline.Size = Vector2.new(uiowidth, uioheight)
					uiodraws.outline.Position = Vector2.new(uiopos.X - uiowidth / 2, uiopos.Y - uioheight / 2)
					
					uiodraws.box.Visible = true
					uiodraws.box.Size = Vector2.new(uiowidth, uioheight)
					uiodraws.box.Position = Vector2.new(uiopos.X - uiowidth / 2, uiopos.Y - uioheight / 2)
					uiodraws.box.Color = uiocolor
				else
					uiodraws.outline.Visible = false
					uiodraws.box.Visible = false
				end
				if uioespmodule.poinameenabled then
					local uioboxtop = uiopos.Y - uioheight / 2
					local uiopixelperstud = (uiocamera.ViewportSize.Y / (2 * math.tan(math.rad(uiocamera.FieldOfView) / 2))) / uiopos.Z
					uiodraws.text.Visible = true
					uiodraws.text.Position = Vector2.new(uiopos.X, uioboxtop - uiopixelperstud - 11)
					uiodraws.text.Text = uioplayer.Name
					uiodraws.text.Color = uiocolor
				else
					uiodraws.text.Visible = false
				end
			else
				uiodraws.outline.Visible = false
				uiodraws.box.Visible = false
				uiodraws.text.Visible = false
			end
		else
			uiodraws.outline.Visible = false
			uiodraws.box.Visible = false
			uiodraws.text.Visible = false
		end
	end
end)

uioplayers.PlayerAdded:Connect(uioaddplayer)
uioplayers.PlayerRemoving:Connect(uioremoveplayer)

for uioi, uiouser in ipairs(uioplayers:GetPlayers()) do
	uioaddplayer(uiouser)
end

getgenv().vdhelpers.poiespmodule = uioespmodule
