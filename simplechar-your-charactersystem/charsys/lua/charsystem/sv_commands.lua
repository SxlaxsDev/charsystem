hook.Add("PlayerSay", "CharacterSystemPlayerSay", function(ply, text, teamchat)

local args = string.Split(text, " ")

args[1] = string.lower(args[1])

if(args[1] == "!charname") then
  if(!CharSystem.Config.AllowedNameChange[ply:GetUserGroup()]) then
    ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)

  else

    local Target = CharSystemDB.FindPlayer(args[2])

    if(!Target) then
      ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))

    else

      local NewName = ""

      for i, v in ipairs(args) do

        if(i > 2) then

          NewName = NewName.." "..v  -- Make a the new name complete
        end
      end

      NewName = string.sub(NewName, 2)

      if(!NewName or NewName == "") then -- is there even a name?

      else
        sql.Query("UPDATE charsys SET name = '"..NewName.."' WHERE steamid = '"..Target:SteamID().."' AND slot = "..Target.WhichSlotPlaying)  -- Update the Name in the Database

        Target:setDarkRPVar("rpname", NewName)  -- Change Name ingame
        CharSystemDB.SendProfiles(Target)  -- Update the client data
        ply:ChatAddText(color_white, string.Replace(CharSystem.Config.NameChanged, "%target%",args[2]))
      end
    end
  end


elseif(args[1] == "!setjob") then

  if(!CharSystem.Config.AllowedJobChange[ply:GetUserGroup()] and !CharSystem.Config.AllowedJobChange[ply:SteamID()]) then
    ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)

  else

    local Target = CharSystemDB.FindPlayer(args[2])

    if(!Target) then

      ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))

    else

      local jobnameCH = ""

      for s,l in ipairs(args) do
        if(s > 2) then
          jobnameCH = jobnameCH.." "..l  -- get the jobname
        end
      end

      local NewJob
      jobnameCH = string.sub(jobnameCH, 2)  -- get jobname

      for k, v in pairs(RPExtraTeams) do
        if(string.lower(jobnameCH) == string.lower(v.name)) then   -- if the job name we need to find is equal to v.name k is the jobid
          NewJob = k
        end
      end
      if(!NewJob) then
        ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoTeamFound)
        return
      end

      Target:changeTeam(NewJob, true, true)
      ply:ChatAddText(color_white, string.Replace(CharSystem.Config.JobChanged, "%target%", args[2]))
    end
  end

elseif(args[1] == "!chars")then
  if(!CharSystem.Config.AllowedAdminMenu[ply:GetUserGroup()] and !CharSystem.Config.AllowedAdminMenu[ply:SteamID()]) then
    ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)

  else

    local CharInfoTable
    local PlayerName = ""

    PlayerName = args[2]
    local Target = CharSystemDB.FindPlayer(PlayerName)

    if(!Target) then

      ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))

    else

      CharInfoTable = CharSystemDB.getCharInfoSteamID(Target:SteamID())
      if(CharInfoTable) then

        net.Start("CharSystemAdminMenuOpen")  -- send it to the client
        net.WriteTable(CharInfoTable)
        net.WriteString(Target:SteamID())

        net.Send(ply)
      else
        ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoChars)
      end
    end
  end
elseif(args[1] == "!invite") then


  if(CharSystem.Config.AllowedInvite[ply:GetUserGroup()] or CharSystem.Config.AllowedInvite[ply:SteamID()]) then
    local InvitedPlayerName = ""

    for s,l in ipairs(args) do
      if(s > 1) then
        InvitedPlayerName = InvitedPlayerName.." "..l  -- get the full name
      end
    end



    if(!InvitedPlayerName or InvitedPlayerName == " " or InvitedPlayerName == "") then

      ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))


    else
      InvitedPlayerName = string.sub(InvitedPlayerName, 2)
      local Target = CharSystemDB.FindPlayer(InvitedPlayerName)
      if(!Target) then

        ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))

      else


        Target.InviteTeam = ply:Team()

        ply:ChatAddText(string.Replace(CharSystem.Config.InviteSuccessful, "%name%", Target:Nick()))
        Target:ChatAddText(string.Replace(CharSystem.Config.GotInvite, "%newjob%", team.GetName(ply:Team())))

        timer.Remove("Invitation"..Target:SteamID())

        timer.Create("Invitation"..Target:SteamID(), 60, 1, function()

        Target.InviteTeam = nil
        Target:ChatAddText(Color(198, 0, 0), CharSystem.Config.InvitationExpired)

        end)
      end
    end
  end
elseif(args[1] == "!accept") then

  if(ply.InviteTeam) then
    ply:changeTeam(ply.InviteTeam)
    ply.InviteTeam = nil
    timer.Remove("Invitation"..ply:SteamID())
    ply:ChatAddText(string.Replace(CharSystem.Config.AcceptInvitation, "%team%", team.GetName(ply:Team())))
  else
    ply:ChatAddText(CharSystem.Config.NoInvitation)

  end

elseif(args[1] == "!jkick") then

  if(!CharSystem.Config.PermissionsKick[ply:GetUserGroup()] and !CharSystem.Config.PermissionsKick[ply:SteamID()]) then

    ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)


  else
    local KickedPlayerName = ""

    for s,l in ipairs(args) do
      if(s > 1) then
        KickedPlayerName = KickedPlayerName.." "..l  -- get the full name
      end
    end
    KickedPlayerName = string.sub(KickedPlayerName,2)



    local Target = CharSystemDB.FindPlayer(KickedPlayerName)
    if(!Target) then

      ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))

    else

      Target:changeTeam(CharSystem.Config.DefaultTeam)
      ply:ChatAddText(string.Replace(CharSystem.Config.JobKick, "%name%", Target:Nick()))
      Target:ChatAddText(string.Replace(CharSystem.Config.JobKickMessage, "%name%", ply:Nick()))

    end
  end

elseif(args[1] == "!train") then
  if(!CharSystem.Config.Faction1Ranks[ply:GetUserGroup()] and !ChasrSystem.Config.Faction2Ranks[ply:GetUserGroup()] and !ChasrSystem.Config.Faction3Ranks[ply:GetUserGroup()]) then
    ply:ChatAddText(CharSystem.Config.NoPermissions)

  else

    local Faction -- which faction
    if(CharSystem.Config.Faction1Teams[ply:Team()]) then
      Faction = 1

    elseif(CharSystem.Config.Faction2Teams[ply:Team()]) then

      Faction = 2
    elseif(CharSystem.Config.Faction3Teams[ply:Team()]) then
      Faction = 3
    else
      ply:ChatAddText(CharSystem.Config.NoFaction)
    end
    if(Faction) then
      local TargetName = ""



      for s,l in ipairs(args) do
        if(s > 1) then
          TargetName = TargetName.." "..l  -- get the full name
        end
      end
      TargetName = string.sub(TargetName,2)


      local Target = CharSystemDB.FindPlayer(TargetName)
      if(!Target) then
        ply:ChatAddText(string.Replace(CharSystem.Config.NoPlayerFound, "%name%", TargetName))


      else
        if(Faction == 1) then
          Target:changeTeam(CharSystem.Config.Faction1DefaultJob, true, true)
        elseif(Faction == 2) then
          Target:changeTeam(CharSystem.Config.Faction2DefaultJob, true, true)
        elseif(Faction == 3) then
          Target:changeTeam(CharSystem.Config.Faction3DefaultJob, true, true)

        end
        Target:ChatAddText(string.Replace(CharSystem.Config.TrainMessage, "%name%", ply:Nick()))
        ply:ChatAddText(string.Replace(CharSystem.Config.TrainMessagePly, "%name%", Target:Nick()))

      end
    end
  end
end
end)


