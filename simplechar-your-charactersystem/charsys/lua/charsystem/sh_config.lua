CharSystem = CharSystem or {}
CharSystem.Config = CharSystem.Config or {}
CharSystemDB = CharSystemDB or {}




-- UI
CharSystem.Config.Background = "materials/military2.jpg" -- Background preinstalled background: materials/battlefront.jpg , materials/christams.jpg , materials/cwrp1.jpg , materials/cwrp2.jpg , materials/firstorder.jpg , materials/landchaft.jpg , materials/landchaft2.jpg , materials/military1.jpg , materials/military2.jpg, materials/military3.jpg , materials/swrp.jpg , materials/vader.jpg , materials/swrpships.jpg
CharSystem.Config.DeleteConfirmation = "Do you want to delete the Character?"  -- Delete confirmation

CharSystem.Config.DeleteConfirmationYes = "Yes" -- Yes button
CharSystem.Config.DeleteConfirmationNo = "No" -- No button

CharSystem.Config.NameEnter = "Please enter your name" -- enter your name field

CharSystem.Config.Close = "Close" -- Close Button
CharSystem.Config.ForbiddenSigns = "Your nme includes forbidden signs!" -- Forbidden signs in your name
CharSystem.Config.NameTooShortLong = "Name is too short or long!" -- Yor name is too long or short error
CharSystem.Config.NameEmpty = "Your need to enter a name!" -- Nameentry field is empty

CharSystem.Config.WelcomeMessage = "Welcome to the Server" -- Welcome TextLabel

CharSystem.Config.CustomButton1 = "FORUMS" -- CustomButton1 text
CharSystem.Config.CustomButton1URL = "" -- CustomButton1 url

CharSystem.Config.CustomButton2 = "TEAMSPEAK"  -- CustomButton2 text
CharSystem.Config.CustomButton2URL = ""   -- CustomButton2 url

CharSystem.Config.CustomButton3 = "WORKSHOP" -- CustomButton3 text
CharSystem.Config.CustomButton3URL = ""   -- CustomButton3 url

CharSystem.Config.CustomButton4 = "DISCORD" -- CustomButton4 text
CharSystem.Config.CustomButton4URL = ""   -- CustomButton4 text

CharSystem.Config.SlotEmpty = "This slot is empty" -- Slot is empty
CharSystem.Config.CurrentlyPlaying = "You are currently playing on this profile" -- Currently playing on this profile
CharSystem.Config.CreateCharacterBut = "Create a character!" -- Create a character
CharSystem.Config.PlayCharacterBut = "Play this Character!" -- Play on this character
CharSystem.Config.LockedCharacter = "This slot is locked!" -- player is not allowed to create a char on this slot

timer.Simple(0, function()

-- This is the config file

-- What error should be displayed when the time between char changes is to short?
CharSystem.Config.ErrorTime = "You need to wait one second to switch your character again!"

-- Player tries to create 2 characters at the same time(normaly he is not able to, just to cover the possibilty)
CharSystem.Config.AlreadyCreating = "You can't create two charactes at the same time!"

-- default number of chars
CharSystem.Config.DefaultChars = 2

-- max number of chars for specific usergroups(maximum is 3)
CharSystem.Config.MaxChars = {
  ["superadmin"] = 2,
  ["donator"] = 3,


}

-- Default Job
CharSystem.Config.DefaultTeam = TEAM_CITIZEN

-- default money
CharSystem.Config.DefaultMoney = 1500

-- What error should be displayed when a user tries to create a char, which slot is higher than the maximum slot/char(normaly he is not able to, just to cover the possibilty)
CharSystem.Config.TooHighSlot = "You can't create another char! You already got the maximum!"

--What error should be displayed when a user tries to create a char, which name is already used
CharSystem.Config.NameAlreadyExists = "This name is already used by another user!"

-- What notification(Darkrp.notify) should be displayed when a character is successful created
CharSystem.Config.CharCreated = "You successfully created a character!"

-- What error should be displayed when a user tries to delete a char, which he is currently playing
CharSystem.Config.DeletePlayingChar = "You can't delete the character you are currently playing!"

--What notification should be displayed when a char is deleted?
CharSystem.Config.CharDeleted = "You successfully deleted the character!"

-- Whhat error should be displayed when a player executes a command without permission?
CharSystem.Config.NoPermissions = "You do not have permissions, to execute this command!"

-- What error should be displayed when no player with the given name(e.g !chars gzd8whudjdi) is found
CharSystem.Config.NoPlayerFound = "No player with the name %name% is found!"

-- What notification should be displayed when a name is changed?
CharSystem.Config.NameChanged = "You successfully changed the name of %target%"

-- What notification should be displayed when a player changes the job of somebody else(e.g !setjob myname Citizen)
CharSystem.Config.JobChanged = "You successfully changed the job of the %target%!"

-- What notification should be displayed when a player gets invited to a job?
CharSystem.Config.GotInvite = "You got invited to the job %newjob%! Type !accept to accept the invitation!"

-- what error should be displayed when a user executes !accept, but is not invited to a team
CharSystem.Config.NoInvitation = "You did not get an invitation!"

--message when a player accepts an invitation
CharSystem.Config.AcceptInvitation = "You successfully joined the job %team%"

-- message to the player, if an invitation expired
CharSystem.Config.InvitationExpired = "Your invitation expired!"

-- successful invite
CharSystem.Config.InviteSuccessful = "You invited %name%!"

CharSystem.Config.NoTeamFound = "The team you enterd does nor exist!"

-- What error should be displayed when somebody tries to delete a char(via adminmenu), which is currently played by a person
CharSystem.Config.AdminMenuDeleteCharError = "You can't delete a character, which is currently played!"

-- What should be displayed when somebody kicks a user out of a job?
CharSystem.Config.JobKick = "You kicked %name% out of the job!"

-- What message should the player, who got kicked out of the job, receive?
CharSystem.Config.JobKickMessage = "Sorry! You got kicked out of your job by %name%"

-- No chars found(!chars name)
CharSystem.Config.NoChars = "No characters found!"

-- Should the CloneID be enabled?
CharSystem.Config.CloneID = false

-- Jobs that should not have an ID(eg. Jedi), ignore if you disabled CloneID
CharSystem.Config.JobsWithOutID = {

  [TEAM_CITIZEN] = true,
}

-- which usergorups or steamid should be able to kick somebody out of their job?
CharSystem.Config.PermissionsKick = {
  ["superadmin"] = true
}
-- which usergroup or steamid should be able to change the job of a user?
CharSystem.Config.AllowedJobChange = {

  ["superadmin"] = true,


}

-- Which usergroup or steamid should be able to change a name of a user?
CharSystem.Config.AllowedNameChange = {

  ["superadmin"] = true,


}
-- Which usergroups or steamid should be able to !invite
CharSystem.Config.AllowedInvite = {

  ["superadmin"] = true,


}



-- Which usergroup or steamid should be able to open the admin menu?
CharSystem.Config.AllowedAdminMenu = {

  ["superadmin"] = true,


}


-- Should the Faction System(!train) be enabled !!
CharSystem.Config.FactionEnabled = true

-- Factionsettings(required for !train)

-- Faction 1 default job

CharSystem.Config.Faction1DefaultJob = TEAM_CITIZEN or 0 -- The 0 is a failsafe, if the job does not exist

-- Faction 1 jobs(which teams are members of faction 1)
CharSystem.Config.Faction1Teams =
{
  --[[
  [TEAM_CITIZEN] = true,
  Just copy an paste it with your team
  ]]
  [TEAM_MINE] = true,

}

-- Which usergroups should be able to execute !train(faction 1)
CharSystem.Config.Faction1Ranks = {

  ["user"] = true,
  ["superadmin"] = true,


}

--Faction 2 default job
CharSystem.Config.Faction2DefaultJob = TEAM_CITIZEN or 0 -- The 0 is a failsafe, if the job does not exist

--Faction 2 jobs(which teams are members of faction 2)
CharSystem.Config.Faction2Teams = {

  --[[
  [TEAM_CITIZEN] = true,
  Just copy an paste it with your team
  ]]
  [TEAM_CLONE] = true,

}

-- Which usergroups should be able to execute !train(faction 2)
CharSystem.Config.Faction2Ranks = {

  ["user"] = true,
  ["superadmin"] = true,


}

-- Faction 3 default job
CharSystem.Config.Faction3DefaultJob = TEAM_CITIZEN or 0 -- The 0 is a failsafe, if the job does not exist

-- Force 3 jobs(which teams are members of faction3 )
CharSystem.Config.Faction3Teams = {

  --[[
  [TEAM_CITIZEN] = true,
  Just copy an paste it with your team
  ]]



}

-- Which usergroups should be able to execute !train(faction 3)
CharSystem.Config.Faction3Ranks = {

  ["user"] = true,
  ["superadmin"] = true,


}

CharSystem.Config.NoFaction = "Sorry! You do not belong to a faction!"

-- Message the trained player receives
CharSystem.Config.TrainMessage = "You got trained by %name%"

-- Message the executer of !train receives
CharSystem.Config.TrainMessagePly = "You trained %name%"






end)
