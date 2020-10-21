local addon = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local obj = LDB:NewDataObject('rbTime', {type = 'data source', text = 'Time'})
local updatePeriod = 5

local function UpdateData()
	local sHour, sMin = GetGameTime()
	local lDate = date('*t')

	if 1 == 1 then
		obj.text = string.format('%d|cFFFFCC00:|r%d',sHour,sMin)
	else
		obj.text = string.format('%d|cFFFFCC00:|r%d|cFFFFCC00:|r%d',lDate.hour,lDate.min,lDate.sec)
		updatePeriod = 0.5
	end
	C_Timer.After(updatePeriod, UpdateData)
end
UpdateData()