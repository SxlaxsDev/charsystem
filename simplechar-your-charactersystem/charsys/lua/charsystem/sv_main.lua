util.AddNetworkString("CharSystemCreateProfile")
util.AddNetworkString("CharSystemPlayProfile")
util.AddNetworkString("CharSystemSendProfiles")
util.AddNetworkString("CharSystemDeleteProfile")
util.AddNetworkString("CharSystemAdminMenuOpen")
util.AddNetworkString("ColorMessage")
util.AddNetworkString("CharacterSystemOpenMenu")
util.AddNetworkString("ChangeNameOfChar")
CharSystemDB = CharSystemDB or {}


hook.Add("DarkRPDBInitialized", "DBErstellen", function()


sql.Query("CREATE TABLE IF NOT EXISTS charsys (id INTEGER PRIMARY KEY AUTOINCREMENT, slot INTEGER NOT NULL, steamid varchar(255) NOT NULL, name varchar(255) NOT NULL, money INTEGER NOT NULL, job INTEGER NOT NULL, cloneid INTEGER)")
sql.Query("CREATE INDEX IF NOT EXISTS IDX_NAME_PLAY ON charsys (name)")
sql.Query("CREATE INDEX IF NOT EXISTS IDX_CSYS_ID ON charsys (id)")
sql.Query("CREATE INDEX IF NOT EXISTS IDX_CSYS_STEAMID ON charsys (steamid)")

end)



hook.Add("PlayerInitialSpawn", "CharSystemPlayerJoinServer", function(ply)

timer.Simple(3, function()

if(ply:IsValid()) then  -- is the player valid

  ply:Lock()  -- no inputs while he did not choose a char
  ply.IsChoosingChar = true  -- he is choosing a char, will be set to nil when Server receives "CharSystemPlayProfile"
  CharSystemDB.SendProfiles(ply)
  
    net.Start("CharacterSystemOpenMenu")
    net.WriteUInt(CharSystem.Config.MaxChars[ply:GetUserGroup()] or CharSystem.Config.DefaultChars,8)
    net.Send(ply)
    
   end
  end)
 end)

hook.Add("ShowSpare2", "OpenCharSystemWithF4", function(ply)
net.Start("CharacterSystemOpenMenu")
net.WriteUInt(CharSystem.Config.MaxChars[ply:GetUserGroup()] or CharSystem.Config.DefaultChars,8)

    net.Send(ply)
    end)


hook.Add("OnPlayerChangedTeam", "JobUpdatenCharSystem", function(ply, oldjob, newjob)

if(!ply.IsChoosingChar) then  -- Did the player just join the server an still receives money?

  sql.Query("UPDATE charsys SET job = "..newjob.." WHERE steamid = '"..ply:SteamID().."' and slot = "..ply.WhichSlotPlaying)  -- update money in db

  CharSystemDB.SendProfiles(ply)  -- Update the money on the client
end
end)


function CharSystemDB.SendProfiles(ply, slotnumber)
  if(ply:IsValid()) then

    local CharTable = sql.Query("SELECT * FROM charsys WHERE steamid = '"..ply:SteamID().."'")  -- gets all chars of the player


    CharTable = CharTable or {} -- if he does not have any chars make an empty table

      if slotnumber then --

        CharTable["playing"] = slotnumber -- the client should not on which char he is playing
      end

      net.Start("CharSystemSendProfiles")
      net.WriteTable(CharTable)
      net.Send(ply)

    
  end
end

net.Receive("CharSystemPlayProfile", function(len,ply)
if(!ply:IsValid()) then 
  return
end
local Slot = net.ReadUInt(8)  -- Which slot did the player choose to play?
Slot = math.Clamp(Slot,1,3)
local ProfileTable = sql.Query("SELECT * FROM charsys WHERE steamid = '"..ply:SteamID().."' and slot = "..Slot.."")   -- this gets a table of the char with the given slot and steamid

if(!ProfileTable) then  --  does not own any chars with the given slot
  return
end

ProfileTable = ProfileTable[1]

if(ply.IsChoosingChar) then  -- did the user join on the server and did not choose a profile?
 
  ply:UnLock()
  ply.IsChoosingChar = nil  -- he chose a profile
end
    
ply.WhichSlotPlaying = Slot  -- The variable which defines which profile the player currently uses should be set to the int we receive from the client
ply:changeTeam(tonumber(ProfileTable.job), true, true)
    print("test")
    print(ProfileTable.job)
if(CharSystem.Config.CloneID) then
  if(CharSystem.Config.JobsWithOutID[tonumber(ProfileTable.job)]) then
    ply:setDarkRPVar("rpname", tostring(ProfileTable.name))
     else
       ply:setDarkRPVar("rpname", tostring(ProfileTable.cloneid).. " " ..tostring(ProfileTable.name))
     end
  
else
ply:setDarkRPVar("rpname", tostring(ProfileTable.name))
end
ply:setDarkRPVar("money", tonumber(ProfileTable.money))




CharSystemDB.SendProfiles(ply, Slot) -- update data

end)

net.Receive("CharSystemCreateProfile", function(len,ply)
if(!ply:IsValid()) then
  return
end

if(ply.IsCreatingProfile) then  -- is the player already creating a char?
  DarkRP.notify(ply,1,4,CharSystem.Config.AlreadyCreating)
  return
end

ply.IsCreatingProfile = true  -- set variable that he is creating a char on true

local SlotNumber = net.ReadUInt(8)  -- On which slot should a char be created
local name = net.ReadString()  -- Which name?
local MaxSlots = CharSystem.Config.MaxChars[ply:GetUserGroup()] or CharSystem.Config.DefaultChars -- Which limit does the usergroup has, if it does not have one, set it to default

 -- No ints bigger than 3 or less than 1

if(MaxSlots < SlotNumber) then
  DarkRP.notify(ply,1,4,CharSystem.Config.TooHighSlot)
  return

end

SlotNumber = math.Clamp(SlotNumber,1,3)

local SlotTable = sql.Query("SELECT slot FROM charsys WHERE steamid = '"..ply:SteamID().."'")   -- gets all the chars/slots of the player

local Slot1 = SlotTable and SlotTable[1] and SlotTable[1].slot and tonumber(SlotTable[1].slot) == SlotNumber  -- Is the char on the first index the char with the same slot on which we should create a chat?
local Slot2 = SlotTable and SlotTable[2] and SlotTable[2].slot and tonumber(SlotTable[2].slot) == SlotNumber   -- So this does mean if there is already a char with this slot so is the slot already used?
local Slot3 = SlotTable and SlotTable[3] and SlotTable[3].slot and tonumber(SlotTable[3].slot) == SlotNumber

if(!SlotTable or !Slot1 and !Slot2 and !Slot3) then  -- if the slot is not used

  local NameTable = sql.Query("SELECT name FROM charsys WHERE name = '"..name.."'")  -- Does the Name already exist?
  if(NameTable) then
    DarkRP.notify(ply,1,4,CharSystem.Config.NameAlreadyExists)

    return
  end
if(CharSystem.Config.CloneID) then
  local CloneIDNumber = math.random(1,9)*1000 + math.random(1,9)*100 + math.random(1,9)*10 + math.random(1,9)
   sql.Query("INSERT INTO charsys (slot, steamid, name, money, job, cloneid) VALUES ("..SlotNumber..", '"..ply:SteamID().."', '"..name.."', "..CharSystem.Config.DefaultMoney..", '"..CharSystem.Config.DefaultTeam.."',"..CloneIDNumber..")")
  else
  sql.Query("INSERT INTO charsys (slot, steamid, name, money, job, cloneid) VALUES ("..SlotNumber..", '"..ply:SteamID().."', '"..name.."', "..CharSystem.Config.DefaultMoney..", '"..CharSystem.Config.DefaultTeam.."',0 )")
end
  ply.IsCreatingProfile = nil  -- the player does not create a profile anymore
  DarkRP.notify(ply,0,4,CharSystem.Config.CharCreated)
    -- update profile


end

ply.IsCreatingProfile = nil
CharSystemDB.SendProfiles(ply)

end)

net.Receive("CharSystemDeleteProfile", function(len,ply)
if(!ply:IsValid()) then
  return
end

local DeletedSlot = net.ReadUInt(8)  -- get the slot of the char which should be deleted
DeletedSlot = math.Clamp(DeletedSlot,1,3)

if(DeletedSlot == ply.WhichSlotPlaying) then  -- is the player currently playing on the same char?

  DarkRP.notify(ply,1,4,CharSystem.Config.DeletePlayingChar)
  return
end

local DeletedChar = sql.Query("SELECT * FROM charsys WHERE steamid = '"..ply:SteamID().."' AND slot = "..DeletedSlot)   -- is there a char with this slot and steamid?

if(!DeletedChar) then
  return
end

DeletedChar = DeletedChar[1]

if(DeletedChar.slot) then

  sql.Query("DELETE FROM charsys WHERE steamid = '"..ply:SteamID().."' AND slot = "..DeletedSlot)  -- delete the char out of the db

  DarkRP.notify(ply,0,4,CharSystem.Config.CharDeleted)
  CharSystemDB.SendProfiles(ply)  -- Update client data
end

end)



function CharSystemDB.FindPlayer(name)  -- Just a function to get the player with a given name
  if(!name) then return end

  for k,v in pairs(player.GetAll()) do

    if string.find(string.lower(v:Name()), string.lower(name)) == nil then

      continue
    end
    return v
  end
end


function CharSystemDB.getCharInfoSteamID(steamid)
  if(steamid) then  -- is the steamid valid

    local CharTable = sql.Query("SELECT * FROM charsys WHERE steamid = '"..steamid.."'") -- does the steamid/player own chars

    if(CharTable) then

      return CharTable
    end
  end
end


local PLAYER = FindMetaTable("Player")

function PLAYER:ChatAddText(...)  -- Variable number of arguments
  net.Start("ColorMessage")
  net.WriteTable({...})
  net.Send(self)
end

timer.Simple(0, function()

function DarkRP.storeMoney(ply, amount)
  if(ply.IsChoosingChar) then
    return
  end

  sql.Query("UPDATE charsys SET money = "..amount.." WHERE steamid = '"..ply:SteamID().."' AND slot = "..ply.WhichSlotPlaying)
  CharSystemDB.SendProfiles(ply)

end
end)


