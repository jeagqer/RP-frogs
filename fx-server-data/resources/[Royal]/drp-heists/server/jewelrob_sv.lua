local canhit = true
cooldownglobalJewl = 0

RegisterServerEvent("jewel:hasrobbed")
AddEventHandler("jewel:hasrobbed", function(num)
    hasrobbed[num] = true
    canhit = false
    TriggerClientEvent("jewel:robbed", -1, hasrobbed)
end)

RegisterServerEvent("jewel:request")
AddEventHandler("jewel:request", function()
    hasrobbed = {}
    hasrobbed[1] = false
    hasrobbed[2] = false
    hasrobbed[3] = false
    hasrobbed[4] = false
    hasrobbed[5] = false
    hasrobbed[6] = false
    hasrobbed[7] = false
    hasrobbed[8] = false
    hasrobbed[9] = false
    hasrobbed[10] = false
    hasrobbed[11] = false
    hasrobbed[12] = false
    hasrobbed[13] = false
    hasrobbed[14] = false
    hasrobbed[15] = false
    hasrobbed[16] = false
    hasrobbed[17] = false
    hasrobbed[18] = false
    hasrobbed[19] = false
    hasrobbed[20] = false
    TriggerClientEvent("jewel:robbed", -1, hasrobbed)
    SetTimeout(4800000, resetJewels)
end)

function resetJewels()
    hasrobbed = {}
    hasrobbed[1] = false
    hasrobbed[2] = false
    hasrobbed[3] = false
    hasrobbed[4] = false
    hasrobbed[5] = false
    hasrobbed[6] = false
    hasrobbed[7] = false
    hasrobbed[8] = false
    hasrobbed[9] = false
    hasrobbed[10] = false
    hasrobbed[11] = false
    hasrobbed[12] = false
    hasrobbed[13] = false
    hasrobbed[14] = false
    hasrobbed[15] = false
    hasrobbed[16] = false
    hasrobbed[17] = false
    hasrobbed[18] = false
    hasrobbed[19] = false
    hasrobbed[20] = false
    TriggerClientEvent("jewel:robbed", -1, hasrobbed)
    SetTimeout(4800000, resetJewels)
end

SetTimeout(4800000, resetJewels)

RegisterServerEvent("jewel:canhit")
AddEventHandler("jewel:canhit", function()
    local source = source
    if not canhit then
        TriggerClientEvent('drp-notification:client:Alert', src, {style = 'error', duration = 3000, message = "This has already been robbed!"})
        Citizen.Wait(2700000)
        canhit = true
    elseif canhit then
        print('working???')
        TriggerEvent('drp-jewelry:setCooldown')
        TriggerEvent("jewel:request")
    end
end)

local jcooldownAttempts = 3

RegisterServerEvent("drp-jewelry:getHitSV")
AddEventHandler("drp-jewelry:getHitSV", function()
    TriggerClientEvent('drp-jewelry:getHit', -1, jcooldownAttempts)
end)

RegisterServerEvent("drp-jewelry:getHitSVSV")
AddEventHandler("drp-jewelry:getHitSVSV", function(jewerlyBanksTimes)
    jcooldownAttempts = jewerlyBanksTimes
end)

RegisterServerEvent("drp-jewelry:getTimeSV")
AddEventHandler("drp-jewelry:getTimeSV", function()
    TriggerClientEvent('drp-jewelry:GetTimeCL', -1, cooldownglobalJewl)
end)

RegisterServerEvent("drp-jewelry:TimePoggers")
AddEventHandler("drp-jewelry:TimePoggers", function()
    local _source = source
    TriggerClientEvent("drp-jewelry:outcome", _source, "The jewelry store has been recently robbed. You need to wait "..math.floor((jewelry.cooldown - (os.time() - cooldownglobalJewl)) / 60)..":"..math.fmod((jewelry.cooldown - (os.time() - cooldownglobalJewl)), 60))
end)

RegisterServerEvent("drp-jewelry:setCooldown")
AddEventHandler("drp-jewelry:setCooldown", function()
    cooldownglobalJewl = os.time()
end)