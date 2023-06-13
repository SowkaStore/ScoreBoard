ESX = nil
PlayerData = {}
opened = false
tempPlayers = {}
scoreboard = {
    ['police'] = 0,
    ['ambulance'] = 0,
    ['mechanic'] = 0,
    ['players'] = 0
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
    while true do
        scoreboard['id'] = GetPlayerServerId(PlayerId())
        if IsControlJustPressed(0, 20) then
            SendNUIMessage({
                action = 'setuID',
                uID = PlayerData.uID
            })

            if not opened then
                scoreboard['job'] = PlayerData.job.label
                scoreboard['name'] = PlayerData.job.grade_label
                SendNUIMessage({
                    action = 'update',
                    data = scoreboard
                })
                SendNUIMessage({
                    action = 'open'
                })
                opened = true
            end
        elseif IsControlJustReleased(0, 20) then
            if opened then
                SendNUIMessage({
                    action = 'close'
                })
                opened = false
            else
                Wait(70)
            end
        end

        if opened then
            for i=1, #tempPlayers do
                local ped = GetPlayerPed(tempPlayers[i])
                local coords = GetEntityCoords(ped)
                DrawText3D(coords.x, coords.y, coords.z + 1.3, GetPlayerServerId(tempPlayers[i]), (NetworkIsPlayerTalking(tempPlayers[i]) and {128, 0, 255} or {255, 255, 255}))
            end
        end

        Wait(7)
    end
end)

Citizen.CreateThread(function()
    while true do
        if opened then
            tempPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 10.0)
            table.insert(tempPlayers, PlayerId())
            Wait(100)
        else
            tempPlayers = {}
            Wait(500)
        end
    end
end)

RegisterNetEvent('esx:playerLoaded', function(data)
    PlayerData = data
end)

RegisterNetEvent('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('rc_scoreboard:updateData', function(data)
    scoreboard = data
end)

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    local scale = (1 / GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(1.0 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
