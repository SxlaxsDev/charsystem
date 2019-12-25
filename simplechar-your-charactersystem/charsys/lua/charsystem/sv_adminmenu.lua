util.AddNetworkString("AdminMenuSetJobOfChar")
util.AddNetworkString("AdminMenuChangeNameOfChar")
util.AddNetworkString("AdminMenuDeleteChar")
util.AddNetworkString("AdminMenuChangeMoneyOfChar")

net.Receive("AdminMenuChangeNameOfChar", function(len,ply)
local NewName = net.ReadString()
local SteamIDTarget = net.ReadString()
local SlotID = net.ReadUInt(8)
if(!CharSystem.Config.AllowedAdminMenu[ply:GetUserGroup()] and !CharSystem.Config.AllowedAdminMenu[ply:SteamID()]) then
  ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)
  return
end
local PlayerNameTarget = player.GetBySteamID(SteamIDTarget)
sql.Query("UPDATE charsys SET name = '"..NewName.."' WHERE steamid = '"..SteamIDTarget.."' AND slot = "..SlotID )  -- Update the Name in the Database
if(PlayerNameTarget) then
  PlayerNameTarget:setDarkRPVar("rpname", NewName)  -- Change Name ingame
  CharSystemDB.SendProfiles(PlayerNameTarget)
end


end)

net.Receive("AdminMenuChangeMoneyOfChar", function(len,ply)
local NewMoney = net.ReadString()
NewMoney = tonumber(NewMoney)
local SteamIDTarget = net.ReadString()
local SlotID = net.ReadUInt(8)
if(!CharSystem.Config.AllowedAdminMenu[ply:GetUserGroup()] and !CharSystem.Config.AllowedAdminMenu[ply:SteamID()]) then
  ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)
  return
end
local PlayerNameTarget = player.GetBySteamID(SteamIDTarget)
sql.Query("UPDATE charsys SET money = '"..NewMoney.."' WHERE steamid = '"..SteamIDTarget.."' AND slot = "..SlotID )  -- Update the Name in the Database
if(PlayerNameTarget) then

  if(PlayerNameTarget.WhichSlotPlaying == SlotID) then
    PlayerNameTarget:setDarkRPVar("money", NewMoney)  -- Change Name ingame
  end
  CharSystemDB.SendProfiles(PlayerNameTarget)
end


end)

net.Receive("AdminMenuSetJobOfChar", function(len, ply)
if(!CharSystem.Config.AllowedAdminMenu[ply:GetUserGroup()] and !CharSystem.Config.AllowedAdminMenu[ply:SteamID()]) then

  ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)
  return
end

local SlotID = net.ReadUInt(8)
SlotID = math.Clamp(SlotID,1,3)
local TargetSteamID = net.ReadString()
local NewJob = net.ReadString()
local JobID
for k,v in pairs(RPExtraTeams) do
  if(NewJob == v.name) then
    JobID = k
  end


end


local IsInDatabase = sql.Query("SELECT * FROM charsys WHERE steamid = '"..TargetSteamID.."' AND slot = "..SlotID)  -- check if steamid is in table

if(IsInDatabase) then

  sql.Query("UPDATE charsys SET job = "..JobID.." WHERE steamid = '"..TargetSteamID.."' AND slot = "..SlotID)  -- Change Job

  PlayerOnServer = player.GetBySteamID(TargetSteamID)  -- Find the player

  if(PlayerOnServer) then
    if(PlayerOnServer.WhichSlotPlaying == SlotID) then
      PlayerOnServer:changeTeam(JobID, true,true)
    end
    CharSystemDB.SendProfiles(PlayerOnServer)  -- Update data on client
    ply:ChatAddText(color_white, string.Replace(CharSystem.Config.JobChanged, "%target%", PlayerOnServer:Nick()))

  end
end

end)

net.Receive("AdminMenuDeleteChar", function(len,ply)
if(!CharSystem.Config.AllowedAdminMenu[ply:GetUserGroup()] and !CharSystem.Config.AllowedAdminMenu[ply:SteamID()]) then

  ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)
  return
end

local SlotID = net.ReadUInt(8)  -- The Slot we need to delete
local SteamIDDelte = net.ReadString()  -- SteamID of the person which char we need to delete
SlotID = math.Clamp(SlotID,1,3)

local IsInDatabase = sql.Query("SELECT * FROM charsys WHERE steamid = '"..SteamIDDelte.."' AND slot = "..SlotID)  -- check if steamid which should be deleted and the slot is valid
local DeletedPlayer = player.GetBySteamID(SteamIDDelte)

if(DeletedPlayer.WhichSlotPlaying == SlotID) then

  ply:ChatAddText(Color(198,0,0),CharSystem.Config.AdminMenuDeleteCharError)
  return
end

if(IsInDatabase) then

  sql.Query("DELETE FROM charsys WHERE steamid = '"..SteamIDDelte.."' AND slot = "..SlotID)  -- Delete Char

  CharSystemDB.SendProfiles(DeletedPlayer)
  ply:ChatAddText(color_white, CharSystem.Config.DeletedChar)

end

end)

