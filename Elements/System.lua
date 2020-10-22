local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local obj = LDB:NewDataObject('rbSystem', {type = 'data source', text = 'System'})
local updatePeriod = 0.25

local function UpdateData()
	local fps = GetFramerate()
	obj.text = string.format('%.0f FPS', fps)
	obj.value = string.format('%.0f',fps)
	obj.suffix = 'FPS'
	C_Timer.After(updatePeriod, UpdateData)
end
UpdateData()