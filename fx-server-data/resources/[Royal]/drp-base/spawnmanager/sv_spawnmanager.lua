DRP.SpawnManager = {}

function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local steamIdentifier
    local identifiers = GetPlayerIdentifiers(player)

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    if steamIdentifier then
        exports.ghmattimysql:execute("SELECT * FROM user_bans WHERE steam_id = ?", {steamIdentifier}, function(data)
            if data[1] then
                local reason = data[1].reason
                if reason == "" then
                    reason = "No Reason Specified"
                end

                deferrals.done("You have been permanently banned | Reason: " .. string.upper(reason));
                CancelEvent()
            else
                -- deferrals.done();
              -- if GetConvarInt('logs_enabled', 0) == 1 then
                    local LogInfo =  GetPlayerName(player).. " is loading into the server"
                    exports['drp-base']:DiscordLog("https://canary.discord.com/api/webhooks/965294258431074374/GNn_Rdszv-RRqYt-4QhvYi4Ni3E8BOgeZLumrb8Ohm2ko3hAhRp-lEwKWNKCvvsjYiQn", player, "Player Joining", "", LogInfo)
               -- end
            end
        end)
    else

    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)
