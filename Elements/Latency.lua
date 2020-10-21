local addon = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local obj = LDB:NewDataObject('rbLatency', {type = 'data source', text = "Latency"})
local updatePeriod = 0.25

local function UpdateData()
	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
	obj.text = string.format("%.0f MS", latencyWorld)
	obj.value = latencyWorld
	obj.suffix = "MS"
	C_Timer.After(updatePeriod, UpdateData)
end
UpdateData()