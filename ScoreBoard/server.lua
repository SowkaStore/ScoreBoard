ESX = exports['es_extended']:getSharedObject()

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
    end
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
    end
end)

RegisterServerEvent('esx:playerLoaded', function(src, xPlayer)
    if scoreboard[xPlayer.job.name] then
        scoreboard[xPlayer.job.name]+=1
    end
    scoreboard['players']+=1
end)

AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if scoreboard[xPlayer.job.name] then
        scoreboard[xPlayer.job.name]-=1
    end
    scoreboard['players']-=1
end)

ESX.RegisterServerCallback('rc_scoreboard:getData', function(source, cb)
    cb(scoreboard)
end)
