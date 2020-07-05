RDX = nil

TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)


RegisterServerEvent('rdx_moneywash:washMoney')
AddEventHandler('rdx_moneywash:washMoney', function(amount)
	local xPlayer = RDX.GetPlayerFromId(source)
	local tax = Config.taxRate
	amount = RDX.Math.Round(tonumber(amount))
	washedCash = amount * tax
	washedTotal = RDX.Math.Round(tonumber(washedCash))
	
	if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
		xPlayer.removeAccountMoney('black_money', amount)
		TriggerClientEvent('rdx:showNotification', xPlayer.source, _U('you_have_washed') .. RDX.Math.GroupDigits(amount) .. _U('dirty_money') .. _U('you_have_received') .. RDX.Math.GroupDigits(washedTotal) .. _U('clean_money'))
		xPlayer.addMoney(washedTotal)
	else
		TriggerClientEvent('rdx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)