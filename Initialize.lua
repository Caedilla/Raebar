local addon = LibStub("AceAddon-3.0"):NewAddon("Raebar", "AceConsole-3.0")
addon.addonName = 'RaeBar'

local LDB = LibStub:GetLibrary("LibDataBroker-1.1")

local function NewObject(event, name, obj)
	print('New object:' .. name)
end

LDB.RegisterCallback('RaeBar', 'LibDataBroker_DataObjectCreated', NewObject)

-- TODO setup Ace3 stuff.