ESX = exports['es_extended']:getSharedObject()
opened = false

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 20) then
            if not opened then

                ESX.TriggerServerCallback('rc_scoreboard:getData', function(cb)
                    cb['id'] = GetPlayerServerId(PlayerId())
                    cb['job'] = ESX.GetPlayerData().job.label
                    cb['name'] = ESX.GetPlayerData().job.grade_label
                    SendNUIMessage({
                        action = 'update',
                        data = cb
                    })
                    SendNUIMessage({
                        action = 'open'
                    })
                    opened = true
                end)
            end
        elseif IsControlJustReleased(0, 20) then
            if opened then
                SendNUIMessage({
                    action = 'close'
                })
                opened = false
            end
        end

        Wait(0)
    end
end)