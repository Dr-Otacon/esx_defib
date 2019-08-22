ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_defib:askplayer')
AddEventHandler('esx_defib:askplayer', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('chatMessage', target, "EMS IS CHECKING YOUR PULSE", {255, 255, 0}, "/pulse [optional: slow, fast, irreg, nopulse]")
		TriggerClientEvent('esx_defib:togglepulse', target)
	else
		print(('esx_ambulancejob: %s attempted to check pulse!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_defib:esx_defib:askpulse')
AddEventHandler('esx_defib:esx_defib:askpulse', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('chatMessage', target, "EMS IS CHECKING YOUR PULSE", {255, 255, 0}, "/pulse [optional: slow, fast, irreg, nopulse]")
		TriggerClientEvent('esx_defib:togglepulse', target)
	else
		print(('esx_ambulancejob: %s attempted to check pulse!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_defib:startdefib')
AddEventHandler('esx_defib:startdefib', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('chatMessage', target, "DEFIBULATOR RESPONSE", {255, 255, 0}, "/defib nopulse, or irreg")
		TriggerClientEvent('esx_defib:toggledefib', target)
	else
		print(('esx_ambulancejob: %s attempted to check pulse!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_defib:npulse')
AddEventHandler('esx_defib:npulse', function(target)
	TriggerClientEvent('esx_defib:nopulse', target)
end)

RegisterServerEvent('esx_defib:shockgiven')
AddEventHandler('esx_defib:shockgiven', function(target)
	TriggerClientEvent('esx_defib:nopluse', target)
end)
