ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(50)
        ESX = exports["es_extended"]:getSharedObject()
    end
end)

local display = false

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('calculator:off')
	end
end)

RegisterNUICallback('NUIFocusOff', function()
	TriggerEvent('calculator:off')
end)

RegisterNetEvent('calculator:on')
AddEventHandler('calculator:on', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'ui', 
        display = true
    })
    display = true
end)

RegisterNetEvent('calculator:off')
AddEventHandler('calculator:off', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'ui', 
        display = false
    })
    display = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 170) then -- F3
            local inventory = ESX.GetPlayerData().inventory
			local CalculatorAmount = nil
							
			for i=1, #inventory, 1 do
				if inventory[i].name == 'calculator' then
					CalculatorAmount = inventory[i].count
				end
            end
            
            if CalculatorAmount > 0 then
                if display == false then
                    TriggerEvent('calculator:on')
                end
            else
                pNotify('Du har ingen miniräknare', 'error', 1500)
            end
        end
    end
end)

pNotify = function(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text    = message,
		type    = messageType,
		queue   = "bazookan",
		timeout = messageTimeout,
		layout  = "bottomCenter"
	})
end