ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

scoreboard = {
    ['police'] = 0,
    ['ambulance'] = 0,
    ['mechanic'] = 0,
    ['players'] = 0
}

RegisterServerEvent('esx:setJob', function(source, job, last)
    if scoreboard[job.name] ~= nil then
        scoreboard[job.name]+=1
    end

    if scoreboard[last.name] ~= nil then
        scoreboard[last.name]-=1
        if scoreboard[last.name] < 0 then scoreboard[last.name] = 0 end
    end
    TriggerClientEvent('rc_scoreboard:updateData', -1, scoreboard)
end)

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then
        local xPlayers = ESX.GetExtendedPlayers()

        for k,v in pairs(xPlayers) do
            scoreboard['players']+=1

            if v.job and scoreboard[v.job.name] ~= nil then 
                scoreboard[v.job.name]+=1
            end
        end
        TriggerClientEvent('rc_scoreboard:updateData', -1, scoreboard)
    end
end)

RegisterServerEvent('esx:playerLoaded', function(id, xPlayer)
    if scoreboard[xPlayer.job.name] then
        scoreboard[xPlayer.job.name]+=1
    end
    scoreboard['players']+=1
    TriggerClientEvent('rc_scoreboard:updateData', -1, scoreboard)
end)

AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if scoreboard[xPlayer.job.name] then
        scoreboard[xPlayer.job.name]-=1
    end
    scoreboard['players']-=1
    if scoreboard['players'] < 0 then scoreboard['players'] = 0 end
    TriggerClientEvent('rc_scoreboard:updateData', -1, scoreboard)
end)

function update()
    TriggerClientEvent('rc_scoreboard:updateData', -1, scoreboard)
end
