AddCSLuaFile("charsystem/sh_config.lua")
include("charsystem/sh_config.lua")
AddCSLuaFile("charsystem/sh_sys.lua")
include("charsystem/sh_sys.lua")

if SERVER then
    include("charsystem/sv_commands.lua")
    include("charsystem/sv_main.lua")
    include("charsystem/sv_adminmenu.lua")
    AddCSLuaFile("charsystem/cl_menu.lua")
    AddCSLuaFile("charsystem/cl_adminmenu.lua")
    AddCSLuaFile("charsystem/cl_fonts.lua")
end

if CLIENT then
    include("charsystem/cl_menu.lua")
    include("charsystem/cl_fonts.lua")
    include("charsystem/cl_adminmenu.lua")
end

MsgC(Color(255, 123, 0), "[CharSystem] ", Color(255, 255, 255), "Loaded!\n")
