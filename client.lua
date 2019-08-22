ESX                           = nil
local PlayerData              = {}

checkpulse = false
revive = false
checkdefib = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


RegisterNetEvent('esx_defib:togglerevive')
AddEventHandler('esx_defib:togglerevive', function()
    revive = true
    Citizen.CreateThread(function()
        Citizen.Wait(20000)
        revive = false
    end)
end)



RegisterNetEvent('esx_defib:togglerevive')
AddEventHandler('esx_defib:togglerevive', function()
    revive = true
    Citizen.CreateThread(function()
        Citizen.Wait(15000)
        revive = false
    end)
end)

RegisterNetEvent('esx_defib:togglepulse')
AddEventHandler('esx_defib:togglepulse', function()
    checkpulse = true
    print("PULSE TRUE")
    Citizen.CreateThread(function()
        Citizen.Wait(20000)
        checkpulse = false
    end)
end)

RegisterNetEvent('esx_defib:toggledefib')
AddEventHandler('esx_defib:toggledefib', function()
    checkdefib = true
end)

--EMS Checks Pulse
RegisterCommand('checkp', function()
    if PlayerData.job ~= nil then
        if PlayerData.job.name == 'ambulance' then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    ESX.ShowNotification('Checking Pulse')
                    TriggerServerEvent('esx_defib:askplayer', GetPlayerServerId(closestPlayer))
                else
                    ESX.ShowNotification('No Player Nearby')
                end
        else
            ESX.ShowNotification('No Player Nearby')
        end
    end
end, false)

-- Downed player response for checking pulse
RegisterCommand("pulse", function(source, args, raw)
    if checkpulse  == true then
        if args[1] == nil then
            --Normal Pulse Sound
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0,'heartbeatnormal', 0.5)
        elseif args[1] == 'slow' then
            --Slow Pulse Sound
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0,'heartbeatslow', 0.5)
        elseif args[1] == 'fast' then
            --Fast Pulse Sound
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0,'heartbeatfast', 0.5)
        elseif args[1] == 'irreg' then
            -- irreg Pulse Sound
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0,'heartbeatirreg', 0.5)
        elseif args[1] == 'nopulse' then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('esx_defib:npulse', GetPlayerServerId(closestPlayer))
                ESX.ShowNotification('darkness')
            else
                ESX.ShowNotification('No Player Nearby')
            end
        else
            ESX.ShowNotification('Wrong Value:/pulse or /pulse slow, fast, irreg, nopulse')
        end
        checkpulse = false
    else
        ESX.ShowNotification('You need to be checked by a medic')
    end
end, false)

--Response for /pulse nopulse
RegisterNetEvent('esx_defib:nopulse')
AddEventHandler('esx_defib:nopulse', function()
    ESX.ShowNotification('You feel nothing')
end)

RegisterCommand('defibu', function()
    if PlayerData.job.name == 'ambulance' then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification('No Player Nearby')
            else
                TriggerServerEvent('esx_defib:startdefib', GetPlayerServerId(closestPlayer))
                --Defibulator Start Sound
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0,'defibanalyze', 0.5)
            end
    else
        ESX.ShowNotification('You are not permitted to use this command')
    end
end, false)

--Start Defib command
RegisterCommand('defib', function(source, args, raw)
    if checkdefib == true then
        if args[1] == 'nopulse' then
            --check pulse defib sound
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0,'defibnopulse', 0.5)
        elseif args[1] == 'irreg' then
            --irreg pulse defib sound
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0,'defibshock', 0.5)
            Citizen.Wait(12000)
            startAnim("missminuteman_1ig_2", "tasered_1")
            revive = true
            ESX.ShowNotification('Optional: Use /alive to get up')
            Citizen.CreateThread(function()
                Citizen.Wait(10000)
                revive = false
            end)
        else
            ESX.ShowNotification('Invalid Response: /defib or /defib irreg')
        end
        checkdefib = false
    else
        ESX.ShowNotification('You need to be checked by a medic')
    end
end, false)

--Revives Player
RegisterCommand('alive', function()
    if revive == true then
        TriggerEvent('esx_ambulancejob:revive', -1)
        Citizen.Wait(1000)
        laydown()
        revive = false
    else
        ESX.ShowNotification('You need to be checked by a medic')
    end
end, false)

--CPR Command
RegisterCommand('cpr', function()
    local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
    for i=1, 15, 1 do
	    Citizen.Wait(900)
        ESX.Streaming.RequestAnimDict(lib, function()
		    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		end)
	end
end, false)

function laydown()
    TaskStartScenarioInPlace(GetPlayerPed(-1), 'WORLD_HUMAN_SUNBATHE_BACK', 0, false)
end

--- Starts animation for defib
function startAnim(lib, anim)
	RequestAnimDict(lib)
	while not HasAnimDictLoaded( lib) do
		Citizen.Wait(1)
	end

    TaskPlayAnim(GetPlayerPed(-1), lib ,anim ,8.0, -8.0, -1, 0, 0, false, false, false )
    Citizen.Wait(1000)
	--ClearPedTasksImmediately(GetPlayerPed(-1))
end
