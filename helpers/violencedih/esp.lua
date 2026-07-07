if not getgenv().vdhelpers then
	getgenv().vdhelpers = {}
end

local poiplayers = game:GetService("Players")
local poirunservice = game:GetService("RunService")
local poicamera = workspace.CurrentCamera

local poiespmodule = {}
poiespmodule.poiboxenabled = false
poiespmodule.poinameenabled = false

local poiregistry = {}

local function poigettorso(poicharacter)
	return poicharacter:FindFirstChild("Torso") or poicharacter:FindFirstChild("UpperTorso") or poicharacter:FindFirstChild("HumanoidRootPart")
end

local function poiaddplayer(poiplayer)
	if poiplayer == poiplayers.LocalPlayer then return end
	poiregistry[poiplayer] = {
		box = Drawing.new("Square"),
		text = Drawing.new("Text")
	}
	poiregistry[poiplayer].box.Thickness = 1.5
	poiregistry[poiplayer].box.Filled = false
	poiregistry[poiplayer].text.Size = 14
	poiregistry[poiplayer].text.Center = true
	poiregistry[poiplayer].text.Outline = true
	poiregistry[poiplayer].text.Font = 3
end

local function poiremoveplayer(poiplayer)
	if poiregistry[poiplayer] then
		poiregistry[poiplayer].box:Remove()
		poiregistry[poiplayer].text:Remove()
		poiregistry[poiplayer] = nil
	end
end

poirunservice.RenderStepped:Connect(function()
	for poiplayer, poidraws in pairs(poiregistry) do
		local poichar = poiplayer.Character
		local poitorso = poichar and poigettorso(poichar)
		if poitorso and (poiespmodule.poiboxenabled or poiespmodule.poinameenabled) then
			local poipos, poionboard = poicamera:WorldToViewportPoint(poitorso.Position)
			if poionboard then
				local poiheight = (poicamera.ViewportSize.Y / poipos.Z) * 3.5
				local poiwidth = poiheight * 0.75
				local poicolor = Color3.fromRGB(255, 255, 255)
				if poiplayer.Team and poiplayer.Team.Name == "Killer" then
					poicolor = Color3.fromRGB(255, 0, 0)
				end
				if poiespmodule.poiboxenabled then
					poidraws.box.Visible = true
					poidraws.box.Size = Vector2.new(poiwidth, poiheight)
					poidraws.box.Position = Vector2.new(poipos.X - poiwidth / 2, poipos.Y - poiheight / 2)
					poidraws.box.Color = poicolor
				else
					poidraws.box.Visible = false
				end
				if poiespmodule.poinameenabled then
					local poinamepos, poinameonboard = poicamera:WorldToViewportPoint(poitorso.Position + Vector3.new(0, 2, 0))
					if poinameonboard then
						poidraws.text.Visible = true
						poidraws.text.Position = Vector2.new(poinamepos.X, poinamepos.Y)
						poidraws.text.Text = poiplayer.Name
						poidraws.text.Color = poicolor
					else
						poidraws.text.Visible = false
					end
				else
					poidraws.text.Visible = false
				end
			else
				poidraws.box.Visible = false
				poidraws.text.Visible = false
			end
		else
			poidraws.box.Visible = false
			poidraws.text.Visible = false
		end
	end
end)

poiplayers.PlayerAdded:Connect(poiaddplayer)
poiplayers.PlayerRemoving:Connect(poiremoveplayer)

for poii, poiuser in ipairs(poiplayers:GetPlayers()) do
	poiaddplayer(poiuser)
end

getgenv().vdhelpers.poiespmodule = poiespmodule
