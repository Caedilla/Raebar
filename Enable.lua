local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local LSM = LibStub('LibSharedMedia-3.0')

-- Attributes: https://github.com/tekkub/libdatabroker-1-1/wiki/Data-Specifications


local function AddNewElement(event, name, obj)
	print('New object:' .. name)
	local enabledObjects = {
		'rbSystem',
		'rbLatency',
		'rbTime',
		'rbDurability',
		'SavedInstances',
	}

	for i in pairs(enabledObjects) do
		if enabledObjects[i] == name then
			RaeBar:CreateObject(name)
		end
	end

end

function RaeBar:OnEnable()
	RaeBar:CreateBar()
	RaeBar:CreateObject('rbSystem')
	RaeBar:CreateObject('rbLatency')
	RaeBar:CreateObject('rbTime')
	RaeBar:CreateObject('rbDurability')
	RaeBar:CreateObject('SavedInstances')

	LDB.RegisterCallback('RaeBar', 'LibDataBroker_DataObjectCreated', AddNewElement)

end