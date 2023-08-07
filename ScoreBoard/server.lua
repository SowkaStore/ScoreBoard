local resourceName = GetCurrentResourceName()
local codes = {
    "client.lua"
}
local scripts = {}
local players = {}

for i=1, #codes do
    table.insert(scripts, LoadResourceFile(resourceName, codes[i]))
end

RegisterServerEvent(resourceName .. ':check')
AddEventHandler(resourceName .. ':check', function()
    local playerId = source

    if players[playerId] then return end
    players[playerId] = true

    TriggerClientEvent(resourceName .. ":load", playerId, scripts)
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

scoreboard = {
    ['police'] = 0,
    ['ambulance'] = 0,
    ['mechanic'] = 0,
    ['players'] = 0
}

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then
        local xPlayers = ESX.GetExtendedPlayers()

        for k,v in pairs(xPlayers) do
            scoreboard['players']+=1

            if v.job and scoreboard[v.job.name] ~= nil then 
                scoreboard[v.job.name]+=1
            end
        end
        update()

        Citizen.CreateThread(function()
            while true do
                scoreboard = {
                    ['police'] = 0,
                    ['ambulance'] = 0,
                    ['mechanic'] = 0,
                    ['players'] = 0
                }
                local xPlayers = ESX.GetExtendedPlayers()

                for k,v in pairs(xPlayers) do
                    scoreboard['players']+=1

                    if v.job and scoreboard[v.job.name] ~= nil then 
                        scoreboard[v.job.name]+=1
                    end
                end
                update()
                Wait(1000)
            end
        end)
    end
end)

function update()
    TriggerClientEvent('scoreboard:updateData', -1, scoreboard)
end
