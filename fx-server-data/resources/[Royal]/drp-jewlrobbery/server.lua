local cooldown = 0
local w = false
local wait = 10000

RegisterServerEvent('av_vangelico:efecto')
AddEventHandler('av_vangelico:efecto', function(carga)
	w = true
	print('^3[AV-Vangelico]: ^2Cooldown started^0')
	cooldown = os.time()
	TriggerClientEvent('av_vangelico:bombaFx',-1, carga)
end)

RegisterServerEvent('av_vangelico:gas')
AddEventHandler('av_vangelico:gas', function()
	TriggerClientEvent('av_vangelico:humo',-1)
end)


RegisterServerEvent("drp-jewelrobbery:AwardItems")
AddEventHandler('drp-jewelrobbery:AwardItems', function()
	local src = source
	--[[if math.random(25) == 20 then
        local myluck = math.random(5)
        if myluck == 1 then
            TriggerClientEvent("player:receiveItem", src, "gruppe63",1)
        end
	end]]

	TriggerClientEvent("player:receiveItem", src, "rolexwatch",math.random(0,2))

	if math.random(7) == 1 then
		TriggerClientEvent("player:receiveItem", src, "goldbar",math.random(0,8))
    end
    if math.random(9) == 1 then
		TriggerClientEvent("player:receiveItem", src, "bdiamond",math.random(0,1))
    end

    if math.random(2) == 1 then
		TriggerClientEvent("player:receiveItem", src, "stolen8ctchain",math.random(0,8))
    end

    if math.random(3) == 1 then
		TriggerClientEvent("player:receiveItem", src, "stolen10ctchain",math.random(0,6))
    end

    if math.random(2) == 1 then
		TriggerClientEvent("player:receiveItem", src, "stolen2ctchain",math.random(0,10))
    end
    
    if math.random(1) == 1 then
		TriggerClientEvent("player:receiveItem", src, "goldcoin",math.random(0,15))
    end

    if math.random(8) == 1 then
      TriggerClientEvent("player:receiveItem", src, "goldore",math.random(0,2))
    end

    if math.random(22) == 1 then
      TriggerClientEvent("player:receiveItem", src, "ruby",math.random(0,1))
    end
end)