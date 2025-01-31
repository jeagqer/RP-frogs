-- Load JSON Config || DO NOT EDIT THIS FILE
local config = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config.json'))[1]

-- URL Encode
function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end

AddEventHandler("playerConnecting", function(name, setReason, deferrals)

	-- Check Steam Identifier
	if string.find(GetPlayerIdentifiers(source)[1], "steam:") then

		-- Starting Deferring Player
		deferrals.defer()

		-- Set Defer Message
		deferrals.update("Checking Player Information. Please Wait.")

		-- Get User License
		local license = GetPlayerIdentifiers(source)[2]

		-- Add User to Database
		PerformHttpRequest(config.url .. '/api/adduser?community=' .. config.communityid .. '&license=' .. license .. '&name=' .. urlencode(GetPlayerName(source)), function(statusCode, response, headers) end)
		Citizen.Wait(1500)


		-- Log Player Connection
		if config.server_logs then
			PerformHttpRequest(config.url .. '/api/log?community=' .. config.communityid .. '&logaction=playerjoined&sender=' .. license .. '&message=' .. urlencode('Joining.'), function(statusCode, text, headers) end, 'GET')
		end

		-- Get User Data
		PerformHttpRequest(config.url .. '/api/userdata?community=' .. config.communityid .. '&license=' .. license, function(statusCode, response, headers)
			if response ~= nil and response ~= "null" then
				--print('[Staff Panel] Data Received.')
				local userinfo = json.decode(response)
				if userinfo == nil then
					-- Incorrect User Information
					print('[Staff Panel] Incorrect Response. (Expected JSON, Recieved ' .. response .. ') Please Wait.')
					deferrals.update('[Staff Panel] Incorrect Response. (Expected JSON, Recieved ' .. response .. ') Please Wait.')
					Citizen.Wait(3000)
				else 
					if userinfo['banned'] == "true" then
						print('[Staff Panel] Banned User Attempting to Connect (' .. license .. ')')
						local ban_reason = config.ban_message
						ban_reason = ban_reason:gsub("{ban_staff}", userinfo['staff'])
						ban_reason = ban_reason:gsub("{ban_reason}", userinfo['reason'])
						ban_reason = ban_reason:gsub("{ban_issued}", userinfo['ban_issued'])
						ban_reason = ban_reason:gsub("{ban_expires}", userinfo['banned_until'])
						ban_reason = ban_reason:gsub("{username}", userinfo['name'])
						ban_reason = ban_reason:gsub("{license}", userinfo['license'])
						ban_reason = ban_reason:gsub("{steam}", userinfo['steam'])
						ban_reason = ban_reason:gsub("{playtime}", userinfo['playtime'])
						ban_reason = ban_reason:gsub("{firstjoined}", userinfo['firstjoined'])
						ban_reason = ban_reason:gsub("{lastplayed}", userinfo['lastplayed'])
						ban_reason = ban_reason:gsub("{trustscore}", userinfo['trustscore'])
						deferrals.done(ban_reason)
					else 
						-- print('[Staff Panel] User Connecting (' .. license .. ')')
						deferrals.done()
					end
				end
			else
				-- No Data Fail-Safe
				--print('[Staff Panel] No Data Received. Attempting Again in 5 Seconds.')
				deferrals.done('🛑 SOMETHING WENT WRONG. PLEASE RECONNECT 🛑')
			end
		end)
	
	else
		-- Steam Not Set
		setReason("Error! Steam is required to play on this FiveM server.")
		CancelEvent()
	end
end)

-- Proccess Chat Messages
AddEventHandler('chatMessage', function(source, name, msg)
	-- Analyze Chat Message
	if config.chat_proccessing then
		PerformHttpRequest(config.url .. '/api/message?community=' .. config.communityid .. '&id=' .. GetPlayerIdentifiers(source)[2] .. '&message=' .. urlencode(msg), function(statusCode, text, headers) end, 'GET')
	end
	
	-- Log to Database
	if config.server_logs then
		PerformHttpRequest(config.url .. '/api/log?community=' .. config.communityid .. '&logaction=message&sender=' .. GetPlayerIdentifiers(source)[2] .. '&message=' .. urlencode(msg), function(statusCode, text, headers) end, 'GET')
	end
end)

-- Log Player Disconnect
AddEventHandler('playerDropped', function(reason)
	if config.server_logs then
		PerformHttpRequest(config.url .. '/api/log?community=' .. config.communityid .. '&logaction=playerleft&sender=' .. GetPlayerIdentifiers(source)[2] .. '&message=' .. urlencode(reason), function(statusCode, text, headers) end, 'GET')
	end
end)

-- RCON Kick Command
RegisterCommand("staff_kick", function(source, args, rawCommand)
	if source == 0 or source == "console" then
		DropPlayer(table.remove(args, 1), table.concat(args, ' '))
		CancelEvent()
	end
end)

-- RCON Tell All Command
RegisterCommand("staff_sayall", function(source, args, rawCommand)
	if source == 0 or source == "console" then
		local message = rawCommand:gsub('staff_sayall ', '')
		TriggerClientEvent("chatMessage", -1, '', {255, 255, 255}, config.prefix .. '^0 ' .. message)
	end
end)

RegisterCommand("staff_sayall2", function(source, args, rawCommand)
	if source == 0 or source == "console" then
		local message = rawCommand:gsub('staff_sayall2 ', '')
		TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(217, 9, 9, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
        args = { "Console", message}
    })
	end
end)

-- RCON Tell Player Command
RegisterCommand("staff_tell", function(source, args, rawCommand)
	if source == 0 or source == "console" then
		local message = rawCommand:gsub('staff_tell ' .. args[1], '')
		TriggerClientEvent("chatMessage", args[1], '', {255, 255, 255}, config.prefix .. '^0 ' .. message)
	end
end)