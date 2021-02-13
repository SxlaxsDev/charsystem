# simpleChar
A free Version of my Character System, wich will be released in March on [GmodStore.com](https://gmodstore.com/), that is to be used in any [DarkRP](https://github.com/FPtje/DarkRP) based Gamemode.

## Prerequisites
[The Materials and Backgrounds](https://steamcommunity.com/sharedfiles/filedetails/?id=1942736311)

## Installation Process
1. Navigate to charsystem-master/simplechar-your-charactersystem/
2. Upload the folder charsys to your server!
3. Navigate to charsys/lua/charsystem/sh_config.lua
4. Configure the addon
5. Add the workshop content to your collection
6. Restart the server

## Description

If you join the server or press F4, the character panel appears on your screen. You are able to create a character with your name. The team/job of this char will be set to the default job, which is set in the config. From now on any user, who has permissions to edit your character, can change your team, name, or money via the admin menu or a command. If the faction system is enabled, you can be trained by a faction member, who has permissions to execute “!train”. Your team then will be changed to the default team of the faction. Also you can enable only one faction, which is useful to train new players on a clonewarsrp server or militaryrp, if you enable more factions. A user, who has the permission to execute !invite, can invite you to their team. This means the server owner can give eg. regimental leaders the permission to invite players into their regiment. If the invited user executes in the next 60 seconds the command “!accept”, his team will be changed to the team of the player, who invited the user. The command “!jkick” kicks a player out of his job.&nbsp;The background seen in the pictures can be changed. Also, a CloneID system can be enabled. If enabled and if the team of the player should get an ID, a random ID is generated and add to the name.

This Addon includes 13 diffrent RP Based Backgrounds for the charSystem

All in all, this system grants yo a lot of possibilities, which leads to an great rp experience!

## Admin Features

!jkick *name* Kicks a player out of the faction

!charname *name* *newname* Changes the name of a player

!setjob *name* *job* Sets the job of a player

## Player Features

!invite *name* Invite a player to your team(What players should be allowed to do that is configurable)

!accept accepts an invitation

!train *name* if the faction system is enabled, the players team is changed to the default team of the faction(What players should be allowed to do that is configurable)

## Factions System

This addon provides a faction system. With this you can enable up to 3 factions, each one has a default job. Users are now able to, if you grant them the permission, to train other users into the default job of the faction. This faction system will be updated and a rank system will be integrated.

## List of all Commands

!chars name - open the admin menu

It is important, that, if you want to change something on a character, press "SAVE". Than everything will be executed,

!setjob *name* *newjob* - changes the job of *name* to *newjob*

!jkick *name* - kicks *name* out of his/her job

!invite *name* - invite *name* to "join" you job

!accept - accept an invitation

!train *name* - train/set the job of *name* to the default job of your faction(can be disabled)
