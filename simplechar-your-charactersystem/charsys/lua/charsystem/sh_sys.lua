timer.Simple(0, function()
	DarkRP.removeChatCommand("forcerpname")
	DarkRP.removeChatCommand("freerpname")
	concommand.Remove("rp_resetallmoney")
        for k,v in pairs(RPExtraTeams) do
        concommand.Remove(v.command)
        end
     
end)
