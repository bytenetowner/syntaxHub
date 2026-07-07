if not getgenv().vdhelpers then
	getgenv().vdhelpers = {}
end

local ytrplayers = game:GetService("Players")
local ytrrunservice = game:GetService("RunService")
local ytrcamera = workspace.CurrentCamera

local ytrespmodule = {}
ytrespmodule.poiboxenabled = false
ytrespmodule.poinameenabled = false

local ytrregistry = {}

local function ytrgettorso(ytrcharacter)
	return ytrcharacter:FindFirstChild("Torso") or ytrcharacter:FindFirstChild("UpperTorso") or ytrcharacter:FindFirstChild("HumanoidRootPart")
end

local function ytraddplayer(ytrplayer)
	if ytrplayer == ytrplayers.LocalPlayer then return end
	ytrregistry[ytrplayer] = {
		ytrbox = Drawing.new("Square"),
		ytrboxoutline = Drawing.new("Square"),
		ytrtext = Drawing.new("Text")
	}
	ytrregistry[ytrplayer].ytrboxoutline.Thickness = 1
	ytrregistry[ytrplayer].ytrboxoutline.Filled = false
	ytrregistry[ytrplayer].ytrboxoutline.Color = Color3.fromRGB(0, 0, 0)
	ytrregistry[ytrplayer].ytrboxoutline.ZIndex = 1
	
	ytrregistry[ytrplayer].ytrbox.Thickness = 1
	ytrregistry[ytrplayer].ytrbox.Filled = false
	ytrregistry[ytrplayer].ytrbox.ZIndex = 2
	
	ytrregistry[ytrplayer].ytrtext.Size = 11
	ytrregistry[ytrplayer].ytrtext.Center = true
	ytrregistry[ytrplayer].ytrtext.Outline = true
	ytrregistry[ytrplayer].ytrtext.Font = 3
	ytrregistry[ytrplayer].ytrtext.ZIndex = 3
end

local function ytrremoveplayer(ytrplayer)
	if ytrregistry[ytrplayer] then
		ytrregistry[ytrplayer].ytrbox:Remove()
		ytrregistry[ytrplayer].ytrboxoutline:Remove()
		ytrregistry[ytrplayer].ytrtext:Remove()
		ytrregistry[ytrplayer] = nil
	end
end

ytrrunservice.RenderStepped:Connect(function()
	for ytrplayer, ytrdraws in pairs(ytrregistry) do
		local ytrchar = ytrplayer.Character
		local ytrtorso = ytrchar and ytrgettorso(ytrchar)
		if ytrtorso and (ytrespmodule.poiboxenabled or ytrespmodule.poinameenabled) then
			local ytrpos, ytronboard = ytrcamera:WorldToViewportPoint(ytrtorso.Position)
			if ytronboard then
				local ytrheight = (ytrcamera.ViewportSize.Y / ytrpos.Z) * 3.5
				local ytrwidth = ytrheight * 0.75
				local ytrcolor = Color3.fromRGB(255, 255, 255)
				if ytrplayer.Team and ytrplayer.Team.Name == "Killer" then
					ytrcolor = Color3.fromRGB(255, 0, 0)
				end
				if ytrespmodule.poiboxenabled then
					ytrdraws.ytrboxoutline.Visible = true
					ytrdraws.ytrboxoutline.Size = Vector2.new(ytrwidth + 2, ytrheight + 2)
					ytrdraws.ytrboxoutline.Position = Vector2.new(ytrpos.X - ytrwidth / 2 - 1, ytrpos.Y - ytrheight / 2 - 1)
					
					ytrdraws.ytrbox.Visible = true
					ytrdraws.ytrbox.Size = Vector2.new(ytrwidth, ytrheight)
					ytrdraws.ytrbox.Position = Vector2.new(ytrpos.X - ytrwidth / 2, ytrpos.Y - ytrheight / 2)
					ytrdraws.ytrbox.Color = ytrcolor
				else
					ytrdraws.ytrboxoutline.Visible = false
					ytrdraws.ytrbox.Visible = false
				end
				if ytrespmodule.poinameenabled then
					local ytrboxtop = ytrpos.Y - ytrheight / 2
					local ytrpixelperstud = (ytrcamera.ViewportSize.Y / (2 * math.tan(math.rad(ytrcamera.FieldOfView) / 2))) / ytrpos.Z
					ytrdraws.ytrtext.Visible = true
					ytrdraws.ytrtext.Position = Vector2.new(ytrpos.X, ytrboxtop - ytrpixelperstud - 11)
					ytrdraws.ytrtext.Text = ytrplayer.Name
					ytrdraws.ytrtext.Color = ytrcolor
				else
					ytrdraws.ytrtext.Visible = false
				end
			else
				ytrdraws.ytrboxoutline.Visible = false
				ytrdraws.ytrbox.Visible = false
				ytrdraws.ytrtext.Visible = false
			end
		else
			ytrdraws.ytrboxoutline.Visible = false
			ytrdraws.ytrbox.Visible = false
			ytrdraws.ytrtext.Visible = false
		end
	end
end)

ytrplayers.PlayerAdded:Connect(ytraddplayer)
ytrplayers.PlayerRemoving:Connect(ytrremoveplayer)

for ytri, ytruser in ipairs(ytrplayers:GetPlayers()) do
	ytraddplayer(ytruser)
end

getgenv().vdhelpers.poiespmodule = ytrespmodule
