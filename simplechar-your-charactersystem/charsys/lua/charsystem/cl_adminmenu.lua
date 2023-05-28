local CharName1Admin
local CharName2Admin
local CharName3Admin
local CharMoney1Admin
local CharMoney2Admin
local CharMoney3Admin
local SteamIDTarget
local blur = Material("pp/blurscreen") -- blur Material

-- blur function
local function DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

function OpenAdminSystem()
	local AdminFrame = vgui.Create("DFrame")
	AdminFrame:MakePopup()
	AdminFrame:SetTitle("")
	AdminFrame:SetDraggable(false)
	AdminFrame:SetSize(900, 500)
	AdminFrame:Center()

	AdminFrame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(34, 40, 49, 255))
	end

	local BgPic1 = vgui.Create("DImage", AdminFrame)
	BgPic1:SetPos(300, 100)
	BgPic1:SetSize(300, 300)
	BgPic1:SetImage("materials/adminmenu.png")
	local AdminTopPanel = vgui.Create("DPanel", AdminFrame)
	AdminTopPanel:SetPos(0, 0)
	AdminTopPanel:SetSize(AdminFrame:GetWide(), 50)

	AdminTopPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(181, 84, 0, 255))
	end

	local TitleLabel = vgui.Create("DLabel", AdminFrame)
	TitleLabel:SetPos(10, 5)
	TitleLabel:SetSize(300, 40)
	TitleLabel:SetText("User: " .. SteamIDTarget)
	TitleLabel:SetFont("Trebuchet24")
	local TitleLabel = vgui.Create("DLabel", AdminFrame)
	TitleLabel:SetPos(10, 5)
	TitleLabel:SetSize(300, 40)
	TitleLabel:SetText("User: " .. SteamIDTarget)
	TitleLabel:SetFont("Trebuchet24")
	local AdminTopClose = vgui.Create("DButton", AdminTopPanel)
	AdminTopClose:SetPos(AdminFrame:GetWide() - 50, 0)
	AdminTopClose:SetSize(50, 50)
	AdminTopClose:SetText("X")
	AdminTopClose:SetFont("Trebuchet24")

	function AdminTopClose.DoClick()
		AdminFrame:Close()
	end

	function AdminTopClose.Paint(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(181, 84, 0, 255))
	end

	local Char1Panel = vgui.Create("DPanel", AdminFrame)
	Char1Panel:SetPos(-900, 100) -- end 50 , 100
	Char1Panel:SetSize(800, 370)

	function Char1Panel.Paint(self, w, h)
		DrawBlur(self, 3)
		draw.RoundedBox(0, 0, 0, w, h, Color(57, 62, 70, 200))
	end

	local Char2Panel = vgui.Create("DPanel", AdminFrame)
	Char2Panel:SetPos(-900, 100)
	Char2Panel:SetSize(800, 370)

	function Char2Panel.Paint(self, w, h)
		DrawBlur(self, 3)
		draw.RoundedBox(0, 0, 0, w, h, Color(57, 62, 70, 200))
	end

	local Char3Panel = vgui.Create("DPanel", AdminFrame)
	Char3Panel:SetPos(-900, 100)
	Char3Panel:SetSize(800, 370)

	function Char3Panel.Paint(self, w, h)
		DrawBlur(self, 3)
		draw.RoundedBox(0, 0, 0, w, h, Color(57, 62, 70, 200))
	end

	local Char1Button = vgui.Create("DButton", AdminFrame)
	Char1Button:SetSize(100, 30)
	Char1Button:SetPos(150 - 50, 60)
	Char1Button:SetText("Slot 1")
	Char1Button:SetFont("Trebuchet24")

	function Char1Button.Paint(self, w, h)
		draw.RoundedBox(7, 0, 0, w, h, Color(181, 84, 0, 255))
	end

	function Char1Button.DoClick()
		Char1Panel:MoveTo(50, 100, 0, 0, -1) -- Char1Panel
		Char2Panel:MoveTo(-900, 100, 0, 0, -1)
		Char3Panel:MoveTo(-900, 100, 0, 0, -1)
	end

	local Char2Button = vgui.Create("DButton", AdminFrame)
	Char2Button:SetSize(100, 30)
	Char2Button:SetPos(450 - 50, 60)
	Char2Button:SetText("Slot 2")
	Char2Button:SetFont("Trebuchet24")

	function Char2Button.Paint(self, w, h)
		draw.RoundedBox(7, 0, 0, w, h, Color(181, 84, 0, 255))
	end

	function Char2Button.DoClick()
		Char1Panel:MoveTo(-900, 100, 0, 0, -1)
		Char2Panel:MoveTo(50, 100, 0, 0, -1)
		Char3Panel:MoveTo(-900, 100, 0, 0, -1)
	end

	local Char3Button = vgui.Create("DButton", AdminFrame)
	Char3Button:SetSize(100, 30)
	Char3Button:SetPos(750 - 50, 60)
	Char3Button:SetText("Slot 3")
	Char3Button:SetFont("Trebuchet24")

	function Char3Button.Paint(self, w, h)
		draw.RoundedBox(7, 0, 0, w, h, Color(181, 84, 0, 255))
	end

	function Char3Button.DoClick()
		Char1Panel:MoveTo(-900, 100, 0, 0, -1)
		Char2Panel:MoveTo(-900, 100, 0, 0, -1)
		Char3Panel:MoveTo(50, 100, 0, 0, -1)
	end

	local Char1Name = vgui.Create("DTextEntry", Char1Panel)
	Char1Name:SetPos(10, 10)
	Char1Name:SetSize(200, 40)
	Char1Name:SetText(CharName1Admin or "None")

	function Char1Name.Paint(self, w, h)
		surface.SetDrawColor(0, 0, 0)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end

	local Char1Money = vgui.Create("DTextEntry", Char1Panel)
	Char1Money:SetPos(10, 60)
	Char1Money:SetSize(200, 40)
	Char1Money:SetText(CharMoney1Admin or "0")

	function Char1Money.Paint(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end

	local Char1Job = vgui.Create("DComboBox", Char1Panel)
	Char1Job:SetPos(10, 110)
	Char1Job:SetSize(200, 30)
	Char1Job:SetFont("Trebuchet24")
	Char1Job:SetValue("Select / Change Job")

	function Char1Job.Paint(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(181, 84, 0, 190))
	end

	for k, v in pairs(RPExtraTeams) do
		Char1Job:AddChoice(team.GetName(k))
	end

	local Delete1 = false
	local Char1Delete = vgui.Create("DButton", Char1Panel)
	Char1Delete:SetPos(10, 280)
	Char1Delete:SetSize(200, 30)
	Char1Delete:SetText("Delete Character")
	Char1Delete:SetFont("Trebuchet24")

	function Char1Delete.Paint(self, w, h)
		draw.RoundedBox(7, 0, 0, w, h, Color(255, 0, 0, 90))
	end

	function Char1Delete.DoClick()
		Delete1 = true
	end

	local Char1Save = vgui.Create("DButton", Char1Panel)
	Char1Save:SetPos(10, 320)
	Char1Save:SetSize(200, 30)
	Char1Save:SetText("Save Changes")
	Char1Save:SetFont("Trebuchet24")

	function Char1Save.Paint(self, w, h)
		draw.RoundedBox(7, 0, 0, w, h, Color(0, 255, 0, 90))
	end

	function Char1Save.DoClick()
		if Char1Name:GetValue() and string.find(CharName1Admin or "None", Char1Name:GetValue()) == nil then
			net.Start("AdminMenuChangeNameOfChar")
			net.WriteString(Char1Name:GetValue())
			net.WriteString(SteamIDTarget)
			net.WriteUInt(1, 8)
			net.SendToServer()
		end

		if Delete1 then
			net.Start("CharSystemDeleteProfile")
			net.WriteUInt(1, 8)
			net.WriteString(SteamIDTarget)
			net.SendToServer()
		end

		if Char1Job:GetValue() ~= "Select / Change Job" then
			local JobID

			for k, v in pairs(RPExtraTeams) do
				if Char1Job:GetValue() == v.name then
					JobID = k
				end
			end

			if JobID then
				net.Start("AdminMenuSetJobOfChar")
				net.WriteUInt(1, 8)
				net.WriteString(SteamIDTarget)
				net.WriteString(Char1Job:GetValue())
				net.SendToServer()
			end
		end

		if Char1Money:GetValue() ~= "0" and Char1Money:GetValue() ~= tostring(CharMoney1Admin) then
			net.Start("AdminMenuChangeMoneyOfChar")
			net.WriteString(Char1Money:GetValue())
			net.WriteString(SteamIDTarget)
			net.WriteUInt(1, 8)
			net.SendToServer()
		end
	end

	local Char2Name = vgui.Create("DTextEntry", Char2Panel)
	Char2Name:SetPos(10, 10)
	Char2Name:SetSize(200, 40)
	Char2Name:SetText(CharName2Admin or "0")

	function Char2Name.Paint(self, w, h)
		surface.SetDrawColor(0, 0, 0)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end

	local Char2Money = vgui.Create("DTextEntry", Char2Panel)
	Char2Money:SetPos(10, 60)
	Char2Money:SetSize(200, 40)
	Char2Money:SetText(CharMoney2Admin or "0")

	function Char2Money.Paint(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end

	local Char2Job = vgui.Create("DComboBox", Char2Panel)
	Char2Job:SetPos(10, 110)
	Char2Job:SetSize(200, 30)
	Char2Job:SetFont("Trebuchet24")
	Char2Job:SetValue("Select / Change Job")

	Char2Job.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(181, 84, 0, 190))
	end

	for k, v in pairs(RPExtraTeams) do
		Char2Job:AddChoice(team.GetName(k))
	end

	local Delete2 = false
	local Char2Delete = vgui.Create("DButton", Char2Panel)
	Char2Delete:SetPos(10, 280)
	Char2Delete:SetSize(200, 30)
	Char2Delete:SetText("Delete Character")
	Char2Delete:SetFont("Trebuchet24")

	function Char2Delete.Paint(self, w, h)
		draw.RoundedBox(7, 0, 0, w, h, Color(255, 0, 0, 90))
	end

	function Char2Delete.DoClick()
		Delete2 = true
	end

	local Char2Save = vgui.Create("DButton", Char2Panel)
	Char2Save:SetPos(10, 320)
	Char2Save:SetSize(200, 30)
	Char2Save:SetText("Save Changes")
	Char2Save:SetFont("Trebuchet24")

	function Char2Save.Paint(self, w, h)
		draw.RoundedBox(7, 0, 0, w, h, Color(0, 255, 0, 90))
	end

	function Char2Save.DoClick()
		if Char2Name:GetValue() and string.find(CharName2Admin or "none", Char2Name:GetValue()) == nil then
			net.Start("AdminMenuChangeNameOfChar")
			net.WriteString(Char2Name:GetValue())
			net.WriteString(SteamIDTarget)
			net.WriteUInt(2, 8)
			net.SendToServer()
		end

		if Delete2 then
			net.Start("CharSystemDeleteProfile")
			net.WriteUInt(2, 8)
			net.WriteString(SteamIDTarget)
			net.SendToServer()
		end

		if Char2Job:GetValue() ~= "Select / Change Job" then
			local JobID2

			for k, v in pairs(RPExtraTeams) do
				if Char2Job:GetValue() == v.name then
					JobID2 = k
				end
			end

			if JobID2 then
				net.Start("AdminMenuSetJobOfChar")
				net.WriteUInt(2, 8)
				net.WriteString(SteamIDTarget)
				net.WriteString(Char2Job:GetValue())
				net.SendToServer()
			end
		end

		if Char2Money:GetValue() ~= "0" and Char2Money:GetValue() ~= tostring(CharMoney2Admin) then
			net.Start("AdminMenuChangeMoneyOfChar")
			net.WriteString(Char2Money:GetValue())
			net.WriteString(SteamIDTarget)
			net.WriteUInt(2, 8)
			net.SendToServer()
		end
	end

	local Char3Name = vgui.Create("DTextEntry", Char3Panel)
	Char3Name:SetPos(10, 10)
	Char3Name:SetSize(200, 40)
	Char3Name:SetText(CharName3Admin or "None")

	function Char3Name.Paint(self, w, h)
		surface.SetDrawColor(0, 0, 0)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end

	local Char3Money = vgui.Create("DTextEntry", Char3Panel)
	Char3Money:SetPos(10, 60)
	Char3Money:SetSize(200, 40)
	Char3Money:SetText(CharMoney3Admin or "0")

	function Char3Money.Paint(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end

	local Char3Job = vgui.Create("DComboBox", Char3Panel)
	Char3Job:SetPos(10, 110)
	Char3Job:SetSize(200, 30)
	Char3Job:SetFont("Trebuchet24")
	Char3Job:SetValue("Select / Change Job")

	Char3Job.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(181, 84, 0, 190))
	end

	for k, v in pairs(RPExtraTeams) do
		Char3Job:AddChoice(team.GetName(k))
	end

	local Delete3 = false
	local Char3Delete = vgui.Create("DButton", Char3Panel)
	Char3Delete:SetPos(10, 280)
	Char3Delete:SetSize(200, 30)
	Char3Delete:SetText("Delete Character")
	Char3Delete:SetFont("Trebuchet24")

	function Char3Delete.Paint(self, w, h)
		draw.RoundedBox(7, 0, 0, w, h, Color(255, 0, 0, 90))
	end

	function Char3Delete.DoClick()
		Delete3 = true
	end

	local Char3Save = vgui.Create("DButton", Char3Panel)
	Char3Save:SetPos(10, 320)
	Char3Save:SetSize(200, 30)
	Char3Save:SetText("Save Changes")
	Char3Save:SetFont("Trebuchet24")

	function Char3Save.Paint(self, w, h)
		draw.RoundedBox(7, 0, 0, w, h, Color(0, 255, 0, 90))
	end

	function Char3Save.DoClick()
		if Char3Name:GetValue() and string.find(CharName3Admin or "None", Char3Name:GetValue()) == nil then
			net.Start("AdminMenuChangeNameOfChar")
			net.WriteString(Char3Name:GetValue())
			net.WriteString(SteamIDTarget)
			net.WriteUInt(3, 8)
			net.SendToServer()
		end

		if Delete3 then
			net.Start("CharSystemDeleteProfile")
			net.WriteUInt(3, 8)
			net.WriteString(SteamIDTarget)
			net.SendToServer()
		end

		if Char3Job:GetValue() ~= "Select / Change Job" then
			local JobID

			for k, v in pairs(RPExtraTeams) do
				if Char3Job:GetValue() == v.name then
					JobID = k
				end
			end

			if JobID then
				net.Start("AdminMenuSetJobOfChar")
				net.WriteUInt(3, 8)
				net.WriteString(SteamIDTarget)
				net.WriteString(Char3Job:GetValue())
				net.SendToServer()
			end
		end

		if Char3Money:GetValue() ~= "0" and Char3Money:GetValue() ~= tostring(CharMoney3Admin) then
			net.Start("AdminMenuChangeMoneyOfChar")
			net.WriteString(Char3Money:GetValue())
			net.WriteString(SteamIDTarget)
			net.WriteUInt(3, 8)
			net.SendToServer()
		end
	end
end

net.Receive("CharSystemAdminMenuOpen", function()
	local CharTable = net.ReadTable()
	SteamIDTarget = net.ReadString()
	local CharSlot1 = CharTable[1] and tonumber(CharTable[1].slot) == 1 and CharTable[1] or CharTable[2] and tonumber(CharTable[2].slot) == 1 and CharTable[2] or CharTable[3] and tonumber(CharTable[3].slot) == 1 and CharTable[3] -- Gets the slot table
	local CharSlot2 = CharTable[1] and tonumber(CharTable[1].slot) == 2 and CharTable[1] or CharTable[2] and tonumber(CharTable[2].slot) == 2 and CharTable[2] or CharTable[3] and tonumber(CharTable[3].slot) == 2 and CharTable[3]
	local CharSlot3 = CharTable[1] and tonumber(CharTable[1].slot) == 3 and CharTable[1] or CharTable[2] and tonumber(CharTable[2].slot) == 3 and CharTable[2] or CharTable[3] and tonumber(CharTable[3].slot) == 3 and CharTable[3]
	CharName1Admin = CharSlot1 and CharSlot1.name
	CharName2Admin = CharSlot2 and CharSlot2.name
	CharName3Admin = CharSlot3 and CharSlot3.name
	CharMoney1Admin = CharSlot1 and CharSlot1.money
	CharMoney2Admin = CharSlot2 and CharSlot2.money
	CharMoney3Admin = CharSlot3 and CharSlot3.money
	OpenAdminSystem()
end)
