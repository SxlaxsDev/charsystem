local cmdPrefix = "!"

local commands = {
  ["charname"] = function(ply, args)
    if(!CharSystem.Config.AllowedNameChange[ply:GetUserGroup()]) then
      ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)
      return
    end

    local Target = CharSystemDB.FindPlayer(args[2])

    if(!Target) then
      ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))
      return
    end

    local NewName = ""

    for i, v in ipairs(args) do
      if(i > 2) then
        NewName = NewName.." "..v  -- Make a the new name complete
      end
    end

    NewName = string.sub(NewName, 2)

    if NewName and NewName != "" then
      sql.Query("UPDATE charsys SET name = '"..NewName.."' WHERE steamid = '"..Target:SteamID().."' AND slot = "..Target.WhichSlotPlaying)  -- Update the Name in the Database

      Target:setDarkRPVar("rpname", NewName)  -- Change Name ingame
      CharSystemDB.SendProfiles(Target)  -- Update the client data
      ply:ChatAddText(color_white, string.Replace(CharSystem.Config.NameChanged, "%target%",args[2]))
    end
  end,

  ["setjob"] = function(ply, args)
    if(!CharSystem.Config.AllowedJobChange[ply:GetUserGroup()] and !CharSystem.Config.AllowedJobChange[ply:SteamID()]) then
      ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)
      return
    end

    local Target = CharSystemDB.FindPlayer(args[2])

    if(!Target) then
      ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))
      return
    end

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
  end,

  ["chars"] = function(ply, args)
    if(!CharSystem.Config.AllowedAdminMenu[ply:GetUserGroup()] and !CharSystem.Config.AllowedAdminMenu[ply:SteamID()]) then
      ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoPermissions)
      return
    end

    local CharInfoTable
    local PlayerName = ""

    PlayerName = args[2]
    local Target = CharSystemDB.FindPlayer(PlayerName)

    if(!Target) then
      ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))
      return
    end

    CharInfoTable = CharSystemDB.getCharInfoSteamID(Target:SteamID())
    if(CharInfoTable) then

      net.Start("CharSystemAdminMenuOpen")  -- send it to the client
      net.WriteTable(CharInfoTable)
      net.WriteString(Target:SteamID())

      net.Send(ply)
    else
      ply:ChatAddText(Color(198, 0, 0), CharSystem.Config.NoChars)
    end
  end,

  ["invite"] = function(ply, args)
    if(CharSystem.Config.AllowedInvite[ply:GetUserGroup()] or CharSystem.Config.AllowedInvite[ply:SteamID()]) then
      local InvitedPlayerName = ""

      for s,l in ipairs(args) do
        if(s > 1) then
          InvitedPlayerName = InvitedPlayerName.." "..l  -- get the full name
        end
      end

      if(!InvitedPlayerName or InvitedPlayerName == " " or InvitedPlayerName == "") then
        ply:ChatAddText(Color(198, 0, 0), string.Replace(CharSystem.Config.NoPlayerFound, "%name%", args[2]))
        return
      end

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
  end,

  ["accept"] = function(ply, args)
    if(ply.InviteTeam) then
      ply:changeTeam(ply.InviteTeam, true, true)
      ply.InviteTeam = nil
      timer.Remove("Invitation"..ply:SteamID())
      ply:ChatAddText(string.Replace(CharSystem.Config.AcceptInvitation, "%team%", team.GetName(ply:Team())))
    else
      ply:ChatAddText(CharSystem.Config.NoInvitation)
    end
  end,

  ["jkick"] = function(ply, args)
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
  end,

  ["train"] = function(ply, args)
    if(!CharSystem.Config.Faction1Ranks[ply:GetUserGroup()] and !ChasrSystem.Config.Faction2Ranks[ply:GetUserGroup()] and !ChasrSystem.Config.Faction3Ranks[ply:GetUserGroup()]) then
      ply:ChatAddText(CharSystem.Config.NoPermissions)
      return
    end
    
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
        return
      end

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
  end,
}

hook.Add("PlayerSay", "CharacterSystemCommands", function(ply, text, teamchat)
  local args = string.Split(text, " ")
  args[1] = string.lower(args[1])

  if !string.StartWith(args[1], cmdPrefix) then return end

  local cmdFunc = commands[string.Right(args[1], args[1]:len() - 1)]
  if !cmdFunc then return end

  cmdFunc(ply, args)
  return ""
end)