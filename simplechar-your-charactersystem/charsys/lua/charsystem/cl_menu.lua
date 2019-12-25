-- space for locals

local BgFrame
local CharName1
local CharName2
local CharName3

local CharJob1
local CharJob2
local CharJob3

local CharMoney1
local CharMoney2
local CharMoney3

local CloneID1
local CloneID2
local CloneID3
local CloneIDOn

local CharsLoaded

local CharPlaying

local MaxChars

net.Receive("CharSystemSendProfiles", function()

local CharTable = net.ReadTable()

local CharSlot1 = CharTable[1] and tonumber(CharTable[1].slot) == 1 and CharTable[1] or CharTable[2] and tonumber(CharTable[2].slot) == 1 and CharTable[2] or CharTable[3] and tonumber(CharTable[3].slot) == 1 and CharTable[3] -- Gets the slot table
local CharSlot2 = CharTable[1] and tonumber(CharTable[1].slot) == 2 and CharTable[1] or CharTable[2] and tonumber(CharTable[2].slot) == 2 and CharTable[2] or CharTable[3] and tonumber(CharTable[3].slot) == 2 and CharTable[3]
local CharSlot3 = CharTable[1] and tonumber(CharTable[1].slot) == 3 and CharTable[1] or CharTable[2] and tonumber(CharTable[2].slot) == 3 and CharTable[2] or CharTable[3] and tonumber(CharTable[3].slot) == 3 and CharTable[3]

CharName1 = CharSlot1 and CharSlot1.name
CharName2 = CharSlot2 and CharSlot2.name
CharName3 = CharSlot3 and CharSlot3.name

CharMoney1 = CharSlot1 and CharSlot1.money
CharMoney2 = CharSlot2 and CharSlot2.money
CharMoney3 = CharSlot3 and CharSlot3.money

CharJob1 = CharSlot1 and CharSlot1.job
CharJob2 = CharSlot2 and CharSlot2.job
CharJob3 = CharSlot3 and CharSlot3.job

CloneID1 = CharSlot1 and CharSlot1.cloneid
CloneID2 = CharSlot2 and CharSlot2.cloneid
CloneID3 = CharSlot3 and CharSlot3.cloneid
CloneIDOn = CharSystem.Config.CloneID

if(CharTable["playing"]) then
  CharPlaying = CharTable["playing"]
  if(IsValid(BgFrame)) then
    BgFrame:Close()
  end
end

CharsLoaded = true


end)


net.Receive("CharacterSystemOpenMenu", function()
local MaxChars = net.ReadUInt(8)
CharSystem.OpenCharMenu(MaxChars)


end)
-- MENU STUFF

local blur = Material("pp/blurscreen") -- blur Material
local function DrawBlur( panel , amount ) -- blur function
  local x , y = panel:LocalToScreen( 0 , 0 )
  local scrW , scrH = ScrW() , ScrH()
  surface.SetDrawColor( 255 , 255 , 255 )
  surface.SetMaterial(blur)
  for i = 1 , 3 do
    blur:SetFloat("$blur" , ( i / 3) * (amount or 6))
    blur:Recompute()
    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect( x * -1 , y * -1 , scrW , scrH )
  end
end

--DrawBlur( self , 3 )
--draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 240 ) )
--end
function CharSystem.CreateCharacter(slot, name)
  net.Start("CharSystemCreateProfile")
  net.WriteUInt(slot, 8)
  net.WriteString(name)
  net.SendToServer()
end

function CharSystem.PlayCharacter(slot)
  net.Start("CharSystemPlayProfile")
  net.WriteUInt(slot, 8)
  net.SendToServer()
end

function CharSystem.CharacterDelete(slot)
  net.Start("CharSystemDeleteProfile")
  net.WriteUInt(slot, 8)
  net.SendToServer()
end



function CharSystem.DeleteCharMenuOpen(slot)
  if(IsValid(BgFrame)) then
    local DeleteConfirmation = vgui.Create("DFrame", BgFrame)
    DeleteConfirmation:SetPos(ScrW() * 0.390,ScrH() * 0.412)
    DeleteConfirmation:SetSize(ScrW() * 0.260,ScrH() * 0.092)
    DeleteConfirmation:SetTitle("")
    DeleteConfirmation:SetDraggable(true)
    DeleteConfirmation:ShowCloseButton(false)
    function DeleteConfirmation.Paint(self,w,h)
      DrawBlur( self , 3 )
      draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175) )
      draw.RoundedBox( 0 , 0 , 0 , ScrW()*0.260 , ScrH() * 0.037 , Color( 0 , 0 , 0 , 190 ) )
      draw.SimpleText(CharSystem.Config.DeleteConfirmation, "EnterNamePanel", 40, 10, Color(135,135,135,155))
      draw.RoundedBox( 0 , 0 , ScrH() * 0.037, ScrW() * 0.130, ScrH() * 0.092 , Color( 255 , 0 , 0 , 100 ) )
      draw.RoundedBox( 0 , ScrW() * 0.130 , ScrH() * 0.037, ScrW() * 0.130 , ScrH() * 0.092 , Color( 0 , 255 , 0 , 100 ) )

    end
    local DeleteConfirmationYes = vgui.Create("DButton", DeleteConfirmation)
    DeleteConfirmationYes:SetPos(0,ScrH() * 0.037)
    DeleteConfirmationYes:SetSize(ScrW() * 0.1302, ScrH() * 0.055)
    DeleteConfirmationYes:SetText(CharSystem.Config.DeleteConfirmationYes)
    DeleteConfirmationYes:SetFont("CustomButton")
    function DeleteConfirmationYes.Paint(self, w, h)
    end
    function DeleteConfirmationYes.DoClick()
      surface.PlaySound("buttons/button16.wav")
      CharSystem.CharacterDelete(slot)

      DeleteConfirmation:Close()
    end

    local DeleteConfirmationNo = vgui.Create("DButton", DeleteConfirmation)
    DeleteConfirmationNo:SetPos(ScrW() * 0.1302,ScrH() * 0.037)
    DeleteConfirmationNo:SetSize(ScrW() * 0.1302 , ScrH() * 0.0555)
    DeleteConfirmationNo:SetText(CharSystem.Config.DeleteConfirmationNo)
    DeleteConfirmationNo:SetFont("CustomButton")
    function DeleteConfirmationNo.Paint(self, w, h)
    end

    function DeleteConfirmationNo.DoClick()
      surface.PlaySound("buttons/button16.wav")
      DeleteConfirmation:Close()
    end


  end
end
function CharSystem.NameInputMenuOpen(slot)
  if(IsValid(BgFrame)) then
    local NameError = ""
    local NameInput = vgui.Create( "DFrame", BgFrame)
    NameInput:SetPos(ScrW() * 0.390, ScrH() * 0.4120)
    NameInput:SetSize(ScrW() * 0.260, ScrH() * 0.185)
    NameInput:SetTitle("")
    NameInput:SetDraggable(true)
    NameInput:ShowCloseButton(false)
    function NameInput.Paint(self, w, h)
      DrawBlur( self , 3 )
      draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175) )
      draw.RoundedBox( 0 , 0 , 0 , ScrW() * 0.260 , ScrH() * 0.037 , Color( 0 , 0 , 0 , 190 ) )
      draw.SimpleText(CharSystem.Config.NameEnter, "EnterNamePanel", ScrW() * 0.020, ScrH() * 0.009, Color(135,135,135,155))
      draw.SimpleText(NameError, "NamePanelError", w/2, h-(ScrH() * 0.055), Color(255,0,0,155), TEXT_ALIGN_CENTER)


    end


    local CloseButtonName = vgui.Create("DButton", NameInput)
    CloseButtonName:SetPos(NameInput:GetWide() - ScrW() * 0.0312 ,0)
    CloseButtonName:SetSize(ScrW() * 0.0312 , ScrH() * 0.037)
    CloseButtonName:SetFont("CustomButton")
    CloseButtonName:SetText(CharSystem.Config.Close)
    function CloseButtonName.Paint(self,w,h)
    end
    function CloseButtonName.DoClick()
      NameInput:Close()
    end
    local NameEntry = vgui.Create( "DTextEntry", NameInput )

    NameEntry:SetPos(ScrW() * 0.078, NameInput:GetTall()/2)
    NameEntry:SetSize(ScrW() * 0.104 ,ScrH() * 0.027)
    local NameOkay
    function NameEntry.OnChange()

      local NameText = NameEntry:GetValue()
      if(NameText and string.Trim(NameText) != "") then
        if(string.len(NameText) > 2 and string.len(NameText) < 31) then
          NameError = ""
          NameOkay = true
          if(!string.match(NameText, "^[a-zA-ZÐ€-ÑŸ0-9 ]+$")) then
            NameError = CharSystem.Config.ForbiddenSigns
            NameOkay = false
          else
            NameOkay = true
          end

        else
          NameError = CharSystem.Config.NameTooShortLong
          NameOkay = false
        end
      else
        NameError = CharSystem.Config.NameEmpty
        NameOkay = false
      end
    end
    function NameEntry.Paint(self,w,h)

      draw.RoundedBox(0, 0, 0, w, h, Color(230, 230, 230))
      draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(255, 255, 255))
      self:DrawTextEntryText(Color(0, 0, 0), Color(142, 240, 193), Color(0, 0, 0))


    end

    local AcceptNameButton = vgui.Create("DButton", NameInput)
    AcceptNameButton:SetText("Enter")
    AcceptNameButton:SetSize(ScrW() * 0.104,ScrH() * 0.037)
    AcceptNameButton:SetPos(NameInput:GetWide()-ScrW() * 0.104, NameInput:GetTall()-ScrH() * 0.037)
    AcceptNameButton:SetFont("CustomButton")
    function AcceptNameButton.Paint(self,w,h)
    end

    function AcceptNameButton.DoClick()
      if(NameOkay) then
        CharSystem.CreateCharacter(slot, NameEntry:GetValue())
        surface.PlaySound("buttons/button16.wav")
        NameInput:Close()
      else
        surface.PlaySound( "buttons/combine_button1.wav" )
      end

    end

  end
end


function CharSystem.OpenCharMenu(MaxChars) -- open_menu is called if menu should be opened

  -- [Basic Layout]


  BgFrame = vgui.Create( "DFrame" ) -- frame for background of menu
  BgFrame:SetSize( ScrW() , ScrH() )
  BgFrame:SetPos( 0 , 0 )
  BgFrame:SetDraggable( false )
  BgFrame:MakePopup()

  local BgPic = vgui.Create( "DImage" , BgFrame ) -- actual background picture
  BgPic:SetSize( ScrW() , ScrH() )
  BgPic:SetPos( 0 , 0 )
  BgPic:SetImage( CharSystem.Config.Background )


  local LeftPanel = vgui.Create( "DPanel" , BgFrame ) -- left sided panel
  LeftPanel:SetPos( ScrW() * 0.020 , 0 )
  LeftPanel:SetSize( ScrW() - ScrW() * 0.041 , ScrH() * 0.064)
  LeftPanel.Paint = function( self , w , h )
  DrawBlur( self , 3 )
  draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 100 ) )
  draw.RoundedBox( 0 ,  0 , 0 , ScrW() * 0.157 , ScrH() * 0.064 , Color( 0 , 0 , 0 , 200 ) )




end

local CloseButton = vgui.Create( "DButton", LeftPanel )
CloseButton:SetPos(ScrW() * 0.803, 0)
CloseButton:SetSize( ScrW() * 0.156 , ScrH() * 0.064 )
if(CharPlaying) then
  CloseButton:SetText( "CLOSE" )
else
  CloseButton:SetText( "LEAVE" )
end
CloseButton:SetFont( "Trebuchet24" )
function CloseButton.DoClick()
  if(CharPlaying) then
    BgFrame:Close()
  else

    RunConsoleCommand("disconnect")
  end
end
CloseButton.Paint = function( self , w , h )
DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175 ) )
end

-- [Custom Button's + Server Info]

local WelcomeText = vgui.Create("DLabel", LeftPanel)
WelcomeText:SetSize(ScrW() * 0.156, ScrH() * 0.064)
WelcomeText:SetContentAlignment(5)
WelcomeText:SetText( CharSystem.Config.WelcomeMessage )
WelcomeText:SetFont( "CustomButton" )


local ButCustom1 = vgui.Create( "DButton" , LeftPanel ) -- 1st Custom Button
ButCustom1:SetPos(ScrW() * 0.161, 0)
ButCustom1:SetSize( ScrW() * 0.156 , ScrH() * 0.064 )
ButCustom1:SetText( CharSystem.Config.CustomButton1 )

ButCustom1:SetFont( "CustomButton" )
function ButCustom1.Paint( self , w , h )
DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175 ) )


end
function ButCustom1.DoClick()
gui.OpenURL( CharSystem.Config.CustomButton1URL )

end

local ButCustom2 = vgui.Create( "DButton" , LeftPanel ) -- 2nd Custom Button
ButCustom2:SetPos( ScrW() * 0.322, 0)
ButCustom2:SetSize( ScrW() * 0.156, ScrH() * 0.0648 )
ButCustom2:SetText( CharSystem.Config.CustomButton2 )
ButCustom2:SetFont( "CustomButton" )
function ButCustom2.Paint( self , w , h )
DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175 ) )
end
function ButCustom2.DoClick()
gui.OpenURL( CharSystem.Config.CustomButton2URL )

end

local ButCustom3 = vgui.Create( "DButton" , LeftPanel ) -- 3rd Custom Button
ButCustom3:SetPos( ScrW() * 0.482,0)
ButCustom3:SetSize( ScrW() * 0.156, ScrH() * 0.0648 )
ButCustom3:SetText( CharSystem.Config.CustomButton3 )
ButCustom3:SetFont( "CustomButton" )
ButCustom3.Paint = function( self , w , h )
DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175 ) )
end
function ButCustom3.DoClick()
gui.OpenURL( CharSystem.Config.CustomButton3URL )

end

local ButCustom4 = vgui.Create( "DButton" , LeftPanel ) -- 3rd Custom Button
ButCustom4:SetPos( ScrW() * 0.643,0)
ButCustom4:SetSize( ScrW() * 0.156, ScrH() * 0.0648 )
ButCustom4:SetText( CharSystem.Config.CustomButton4 )
ButCustom4:SetFont( "CustomButton" )
ButCustom4.Paint = function( self , w , h )
DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175 ) )
end
function ButCustom4.DoClick()
gui.OpenURL( CharSystem.Config.CustomButton4URL )

end


local Char1Panel = vgui.Create( "DPanel" , BgFrame ) -- char 1 panel
Char1Panel:SetPos( ScrW() * 0.052 , ScrH()* 0.277)
Char1Panel:SetSize( ScrW() * 0.260 , ScrH() * 0.555 )
Char1Panel.Paint = function( self , w , h )
DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175 ) )
draw.RoundedBox(0,0,0,ScrW() * 0.260,ScrH() * 0.101,Color(0,0,0,190))
end


local Char1ModelPan = vgui.Create( "DModelPanel" , Char1Panel ) -- char 1 model preview
Char1ModelPan:SetPos( ScrW() * 0.005 , ScrH() * 0.083 )
Char1ModelPan:SetSize( ScrW() * 0.260 , ScrH() * 0.370 )
function Char1ModelPan.Think()

local JobID = tonumber(CharJob1)
local JobModel = ""

local JobTable = RPExtraTeams[JobID]
if (CharPlaying == 1) then

JobModel = LocalPlayer():GetModel()
elseif(JobTable and JobTable.model) then

local ModelTable = JobTable.model
if(istable(ModelTable))then
ModelTable = ModelTable[1]
end
JobModel = ModelTable
end

if(Char1ModelPan:GetModel() != JobModel) then

Char1ModelPan:SetModel(JobModel)
end
end


local CharName1Label = vgui.Create( "DLabel" , Char1Panel ) -- 1st Character Name
CharName1Label:SetPos( ScrW() * 0.005 , ScrH() * 0.013 )
CharName1Label:SetContentAlignment(5)
CharName1Label:SetFont( "CharInfosName" )

CharName1Label:SetSize( Char1Panel:GetWide() , ScrH() * 0.046 )
function CharName1Label.Think()
if(CharName1) then
if(CloneIDOn) then
if(CharSystem.Config.JobsWithOutID[tonumber(CharJob1)]) then
CharName1Label:SetText( tostring(CharName1) )
else
CharName1Label:SetText( tostring(CloneID1).." "..tostring(CharName1) )

end


else
CharName1Label:SetText( tostring(CharName1) )
end
else
CharName1Label:SetText( CharSystem.Config.SlotEmpty )



end
end

local Char1JobLabel = vgui.Create( "DLabel" , Char1Panel ) -- 1st Character Name
Char1JobLabel:SetPos( ScrW() * 0.005 , ScrH() * 0.060 )
Char1JobLabel:SetContentAlignment(5)
Char1JobLabel:SetFont( "CharInfosJob" )
Char1JobLabel:SetSize( Char1Panel:GetWide() , ScrH() * 0.037 )
function Char1JobLabel.Think()

if(CharJob1) then
Char1JobLabel:SetText(team.GetName(tonumber(CharJob1)))
else
Char1JobLabel:SetText( CharSystem.Config.SlotEmpty )


end
end

if(CharPlaying != 1 and CharName1) then
local Char1DeleteButton = vgui.Create( "DImageButton" , Char1Panel )
Char1DeleteButton:SetPos( Char1Panel:GetWide() -16 , 0) -- 16 nicht ändern
Char1DeleteButton:SetSize( 16 , 16 ) -- 16 is fest nicht ändern
Char1DeleteButton:SetImage("icon16/bin_closed.png")
function Char1DeleteButton.DoClick()
CharSystem.DeleteCharMenuOpen(1)

end



end

local Char1Play = vgui.Create( "DButton" , Char1Panel )
Char1Play:SetPos( 0 , Char1Panel:GetTall() - ScrH() * 0.074)
Char1Play:SetSize( ScrW() * 0.260 , ScrH() * 0.074 )
Char1Play:SetText( "Play Character" )
Char1Play:SetFont( "Trebuchet24" )
Char1Play.Paint = function( self , w , h )
--DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 120 ) )
end

function Char1Play.Think(self,w,h)
if(CharPlaying == 1) then
Char1Play:SetText( CharSystem.Config.CurrentlyPlaying )
elseif(!CharName1) then
Char1Play:SetText( CharSystem.Config.CreateCharacterBut )
elseif(CharName1) then
Char1Play:SetText( CharSystem.Config.PlayCharacterBut )
end


end
function Char1Play.DoClick()
if(!CharName1) then
CharSystem.NameInputMenuOpen(1)
elseif(CharName1 and CharPlaying != 1) then
CharSystem.PlayCharacter(1)

end
end



--end

-- [Character Slot 2]

local Char2Panel = vgui.Create( "DPanel" , BgFrame ) -- char 1 panel
Char2Panel:SetPos( ScrW() * 0.364 , ScrH() * 0.277)
Char2Panel:SetSize( ScrW() * 0.260 , ScrH() * 0.555 )
Char2Panel.Paint = function( self , w , h )
DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175 ) )
draw.RoundedBox(0,0,0,w,ScrH() * 0.101,Color(0,0,0,190))
end


if(MaxChars < 2)then
local LockedImage2 = vgui.Create("DImage",Char2Panel )
LockedImage2:SetPos(ScrW() * 0.005 , ScrH() * 0.083 )
LockedImage2:SetSize( ScrW() * 0.260 , ScrH() * 0.370)
LockedImage2:SetImage("materials/lock.png")
else
local Char2ModelPan = vgui.Create( "DModelPanel" , Char2Panel )
Char2ModelPan:SetPos( ScrW() * 0.005 , ScrH() * 0.083 )
Char2ModelPan:SetSize( ScrW() * 0.260 , ScrH() * 0.370)
function Char2ModelPan.Think()

local JobID = tonumber(CharJob2)
local JobModel = ""

local JobTable = RPExtraTeams[JobID]
if (CharPlaying == 2) then

JobModel = LocalPlayer():GetModel()
elseif(JobTable and JobTable.model) then

local ModelTable = JobTable.model
if(istable(ModelTable))then
ModelTable = ModelTable[1]
end
JobModel = ModelTable
end

if(Char2ModelPan:GetModel() != JobModel) then

Char2ModelPan:SetModel(JobModel)
end
end
end
local CharName2Label = vgui.Create( "DLabel" , Char2Panel ) -- 1st Character Name
CharName2Label:SetPos( ScrW() * 0.005 , ScrH() * 0.013 )
CharName2Label:SetContentAlignment(5)
CharName2Label:SetText( "" )
CharName2Label:SetFont( "CharInfosName" )
CharName2Label:SetSize( Char2Panel:GetWide() , ScrH() * 0.046 )
function CharName2Label.Think()
if(CharName2) then
if(CloneIDOn) then
if(CharSystem.Config.JobsWithOutID[tonumber(CharJob2)]) then
CharName2Label:SetText( tostring(CharName2) )
else
CharName2Label:SetText( tostring(CloneID2).." "..tostring(CharName2) )

end


else
CharName2Label:SetText( tostring(CharName2) )
end
elseif(2 > MaxChars) then
CharName2Label:SetText( CharSystem.Config.LockedCharacter)

else
CharName2Label:SetText( CharSystem.Config.SlotEmpty )

end
end






local Char2JobLabel = vgui.Create( "DLabel" , Char2Panel ) -- 1st Character Name
Char2JobLabel:SetPos( ScrW() * 0.005 , ScrH() * 0.060 )
Char2JobLabel:SetText( "" )
Char2JobLabel:SetContentAlignment(5)
Char2JobLabel:SetFont( "CharInfosJob" )
Char2JobLabel:SetSize( Char2Panel:GetWide() , ScrH() * 0.037 )
function Char2JobLabel.Think()

if(CharJob2) then
Char2JobLabel:SetText( team.GetName(tonumber(CharJob2)))


elseif(2 > MaxChars) then
Char2JobLabel:SetText( CharSystem.Config.LockedCharacter )

else
Char2JobLabel:SetText( CharSystem.Config.SlotEmpty )

end

end


if(CharPlaying != 2 and CharName2) then
local Char2DeleteButton = vgui.Create( "DImageButton" , Char2Panel )
Char2DeleteButton:SetPos( Char2Panel:GetWide() -16 , 0) -- 16 nicht ändern
Char2DeleteButton:SetSize( 16 , 16 ) -- 16 is fest nicht ändern
Char2DeleteButton:SetImage("icon16/bin_closed.png")
function Char2DeleteButton.DoClick()
CharSystem.DeleteCharMenuOpen(2)

end



end

local Char2Play = vgui.Create( "DButton" , Char2Panel )
Char2Play:SetPos( 0 , Char2Panel:GetTall() - ScrH() * 0.074)
Char2Play:SetSize( ScrW() * 0.260 , ScrH() * 0.074 )
Char2Play:SetText( "Play Character" )
Char2Play:SetFont( "Trebuchet24" )
function Char2Play.Paint(self,w,h)
--DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 120 ) )
end

function Char2Play.Think(self,w,h)
if(CharPlaying == 2) then
Char2Play:SetText( CharSystem.Config.CurrentlyPlaying )

elseif(CharName2 and 2 <= MaxChars) then
Char2Play:SetText( CharSystem.Config.PlayCharacterBut )
elseif(2>MaxChars) then
Char2Play:SetText( CharSystem.Config.LockedCharacter )
elseif(!CharName2) then
Char2Play:SetText( CharSystem.Config.CreateCharacterBut )

end

end
function Char2Play.DoClick()
if(!CharName2 and 2<=MaxChars) then
CharSystem.NameInputMenuOpen(2)
elseif(CharName2 and CharPlaying != 2 and 2<=MaxChars) then
CharSystem.PlayCharacter(2)
else
end
end

-- [Character Slot 3]

local Char3Panel = vgui.Create( "DPanel" , BgFrame ) -- char 1 panel
Char3Panel:SetPos( ScrW() * 0.677 , ScrH() * 0.277)
Char3Panel:SetSize( ScrW() * 0.260 , ScrH() * 0.555 )
Char3Panel.Paint = function( self , w , h )
DrawBlur( self , 3 )
draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 175 ) )
draw.RoundedBox(0,0,0,w,ScrH() * 0.101,Color(0,0,0,190))
end



if(MaxChars < 3) then
local LockedImage3 = vgui.Create("DImage",Char3Panel )
LockedImage3:SetPos(ScrW() * 0.005 , ScrH() * 0.083 )
LockedImage3:SetSize( ScrW() * 0.260 , ScrH() * 0.370)
LockedImage3:SetImage("materials/lock.png")





else
local Char3ModelPan = vgui.Create( "DModelPanel" , Char3Panel )
Char3ModelPan:SetPos( ScrW() * 0.005 , ScrH() * 0.083 )
Char3ModelPan:SetSize( ScrW() * 0.260 , ScrH() * 0.370)
function Char3ModelPan.Think()

local JobID = tonumber(CharJob3)
local JobModel = ""

local JobTable = RPExtraTeams[JobID]
if (CharPlaying == 3) then

JobModel = LocalPlayer():GetModel()
elseif(JobTable and JobTable.model) then

local ModelTable = JobTable.model
if(istable(ModelTable))then
ModelTable = ModelTable[1]
end
JobModel = ModelTable
end

if(Char3ModelPan:GetModel() != JobModel) then

Char3ModelPan:SetModel(JobModel)
end
end
end

local CharName3Label = vgui.Create( "DLabel" , Char3Panel ) -- 1st Character Name
CharName3Label:SetPos( ScrW() * 0.005 , ScrH() * 0.013 )
CharName3Label:SetContentAlignment(5)
CharName3Label:SetText( "" )
CharName3Label:SetFont( "CharInfosName" )
CharName3Label:SetSize( Char3Panel:GetWide() , ScrH() * 0.046 )
function CharName3Label.Think()
if(CharName3) then
if(CloneIDOn) then
if(CharSystem.Config.JobsWithOutID[tonumber(CharJob3)]) then
CharName3Label:SetText( tostring(CharName3) )
else
CharName3Label:SetText( tostring(CloneID3).." "..tostring(CharName3) )

end


else
CharName3Label:SetText( tostring(CharName3) )
end

elseif(3 > MaxChars) then
CharName3Label:SetText( CharSystem.Config.LockedCharacter )

else
CharName3Label:SetText( CharSystem.Config.SlotEmpty )

end
end


local Char3JobLabel = vgui.Create( "DLabel" , Char3Panel ) -- 1st Character Name
Char3JobLabel:SetPos( ScrW() * 0.005 , ScrH() * 0.060 )
Char3JobLabel:SetText( "" )
Char3JobLabel:SetContentAlignment(5)
Char3JobLabel:SetFont( "CharInfosJob" )
Char3JobLabel:SetSize( Char3Panel:GetWide() , ScrH() * 0.037 )
function Char3JobLabel.Think()

if(CharJob3) then
Char3JobLabel:SetText( team.GetName(tonumber(CharJob3)))

elseif(3 > MaxChars) then
Char3JobLabel:SetText( CharSystem.Config.LockedCharacter  )

else
Char3JobLabel:SetText( CharSystem.Config.SlotEmpty )

end

end


if(CharPlaying != 3 and CharName3) then
local Char3DeleteButton = vgui.Create( "DImageButton" , Char3Panel )
Char3DeleteButton:SetPos( Char3Panel:GetWide() -16 , 0) -- 16 nicht ändern
Char3DeleteButton:SetSize( 16 , 16 ) -- 16 is fest nicht ändern
Char3DeleteButton:SetImage("icon16/bin_closed.png")
function Char3DeleteButton.DoClick()
CharSystem.DeleteCharMenuOpen(3)

end



end

local Char3Play = vgui.Create( "DButton" , Char3Panel )
Char3Play:SetPos( 0 , Char3Panel:GetTall() - ScrH() * 0.074)
Char3Play:SetSize( ScrW() * 0.260 , ScrH() * 0.074 )
Char3Play:SetText(  CharSystem.Config.PlayCharacterBut )
Char3Play:SetFont( "Trebuchet24" )
function Char3Play.Paint(self,w,h)
--DrawBlur( self , 3 )

draw.RoundedBox( 0 , 0 , 0 , w , h , Color( 0 , 0 , 0 , 120 ) )
end

function Char3Play.Think(self,w,h)
if(CharPlaying == 3) then
Char3Play:SetText( CharSystem.Config.CurrentlyPlaying )
elseif(CharName3 and MaxChars >= 3) then
Char3Play:SetText( CharSystem.Config.PlayCharacterBut )
elseif(3> MaxChars) then
Char3Play:SetText( CharSystem.Config.LockedCharacter )
elseif(!CharName3) then
Char3Play:SetText( CharSystem.Config.CreateCharacterBut )

end
end
function Char3Play.DoClick()
if(!CharName3 and 3 == MaxChars) then
CharSystem.NameInputMenuOpen(3)
elseif(CharName3 and CharPlaying != 3 and 3== MaxChars) then
CharSystem.PlayCharacter(3)
else
end
end


--if (CharPlaying) then




--end
end

net.Receive("ColorMessage",function(len,ply)

local ColorMessageTable = net.ReadTable()

if (!istable(ColorMessageTable)) then
return
end

chat.AddText(unpack(ColorMessageTable))
end)



