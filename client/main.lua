local Keys = {
	-- Letters
    ["A"] = 0x7065027D,
    ["B"] = 0x4CC0E2FE,
    ["C"] = 0x9959A6F0,
    ["D"] = 0xB4E465B4,
    ["E"] = 0xCEFD9220,
    ["F"] = 0xB2F377E8,
    ["G"] = 0x760A9C6F,
    ["H"] = 0x24978A28,
    ["I"] = 0xC1989F95,
    ["J"] = 0xF3830D8E,
    -- Missing K, don't know if anything is actually bound to it
    ["L"] = 0x80F28E95,
    ["M"] = 0xE31C6A41,
    ["N"] = 0x4BC9DABB, -- Push to talk key
    ["O"] = 0xF1301666,
    ["P"] = 0xD82E0BD2,
    ["Q"] = 0xDE794E3E,
    ["R"] = 0xE30CD707,
    ["S"] = 0xD27782E3,
    -- Missing T
    ["U"] = 0xD8F73058,
    ["V"] = 0x7F8D09B8,
    ["W"] = 0x8FD015D8,
    ["X"] = 0x8CC9CD42,
    -- Missing Y
    ["Z"] = 0x26E9DC00,

    -- Symbol Keys
    ["RIGHTBRACKET"] = 0xA5BDCD3C,
    ["LEFTBRACKET"] = 0x430593AA,
    -- Mouse buttons
    ["MOUSE1"] = 0x07CE1E61,
    ["MOUSE2"] = 0xF84FA74F,
    ["MOUSE3"] = 0xCEE12B50,
    ["MWUP"] = 0x3076E97C,
    -- Modifier Keys
    ["CTRL"] = 0xDB096B85,
    ["TAB"] = 0xB238FE0B,
    ["SHIFT"] = 0x8FFC75D6,
    ["SPACEBAR"] = 0xD9D0E1C0,
    ["ENTER"] = 0xC7B5340A,
    ["BACKSPACE"] = 0x156F7119,
    ["LALT"] = 0x8AAA0AD4,
    ["DEL"] = 0x4AF4D473,
    ["PGUP"] = 0x446258B6,
    ["PGDN"] = 0x3C3DD371,
    -- Function Keys
    ["F1"] = 0xA8E3F467,
    ["F4"] = 0x1F6D95E5,
    ["F6"] = 0x3C0A40F2,
    -- Number Keys
    ["1"] = 0xE6F612E4,
    ["2"] = 0x1CE6D9EB,
    ["3"] = 0x4F49CC4C,
    ["4"] = 0x8F9F9E58,
    ["5"] = 0xAB62E997,
    ["6"] = 0xA1FDE2A6,
    ["7"] = 0xB03A913B,
    ["8"] = 0x42385422,
    -- Arrow Keys
    ["DOWN"] = 0x05CA7C52,
    ["UP"] = 0x6319DB71,
    ["LEFT"] = 0xA65EBAB4,
    ["RIGHT"] = 0xDEB34313
}

RDX							= nil
local hasAlreadyEnteredMarker	= nil
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}


Citizen.CreateThread(function()
	while RDX == nil do
		TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)
		Citizen.Wait(0)
	end

	while RDX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	RDX.PlayerData = RDX.GetPlayerData()

end)


-- Washed Menu
function OpenWashedMenu(zone)
	local elements = {
		{label = _U('wash_money'), 	value = 'wash_money'},
		--{label = _U('no'),			value = 'no'}
		}
		
		RDX.UI.Menu.CloseAll()
		
		RDX.UI.Menu.Open('default', GetCurrentResourceName(), 'wash', {
			title		= _U('washed_menu'),
			align		= 'top-left',
			elements	= elements
		}, function(data, menu)
			if data.current.value == 'wash_money' then
				RDX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_', {
					title = _U('wash_money_amount')
				}, function(data, menu)
				
					local amount = tonumber(data.value)
					
					if amount == nil then
						RDX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('rdx_moneywash:washMoney', amount)
					end
				end, function(data, menu)
					menu.close()
				end)
			end
			end, function(data, menu)
				menu.close()
			
				CurrentAction	 = 'wash_menu'
				CurrentActionMsg = _U('press_menu')
				CurrentActionData = {zone = zone}			
			
		end)

end


--Enter / Exit Marker
AddEventHandler('rdx_moneywash:hasEnteredMarker', function(zone)
	CurrentAction     = 'wash_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {zone = zone}
end)

AddEventHandler('rdx_moneywash:hasExitedMarker', function(zone)
	CurrentAction = nil
	RDX.UI.Menu.CloseAll()		
end)

-- Create Blips

-- Diplay Markers

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
        Citizen.InvokeNative(0x2A32FAA57B937173, -1795314153, Config.Zonas['lavagem'].x, Config.Zonas['lavagem'].y, Config.Zonas['lavagem'].z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.9, 255, 255, 0, 155, 0, 0, 2, 0, 0, 0, 0)
	end
end)

-- Enter / Exit Marker Events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords		= GetEntityCoords(PlayerPedId())
		local isInMarker	= false
		local currentZone = nil
		
		
		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
					isInMarker = true
					currentZone = k
				end
			end
		end
		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('rdx_moneywash:hasEnteredMarker', currentZone)
		end
		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('rdx_moneywash:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction ~= nil then
			RDX.ShowHelpNotification(CurrentActionMsg)
			
			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'wash_menu' then
					OpenWashedMenu(CurrentActionData.zone)
				end
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
		
