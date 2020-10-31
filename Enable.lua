local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')

-- Attributes: https://github.com/tekkub/libdatabroker-1-1/wiki/Data-Specifications

local enabledObjects = {
	'gmSpecs',
	'rbGold',
	'SavedInstances',
	'gmFriends',
	'gmGuild',
	'rbSystem',
	'rbLatency',
	'rbTime',
	'gmSpeed',
	'SorhaQuestLog',
	'rbDurability',

}

local function AddNewElement(event, name, obj)
	for i in pairs(enabledObjects) do
		if enabledObjects[i] == name then
			RaeBar:CreateObject(i+500, name, 'CenterGroup')
		end
	end

	RaeBar:PositionBar('CenterGroup')
end

function RaeBar:OnEnable()
	RaeBar:CreateBar('CenterGroup')
	for i = 1, #enabledObjects do
		RaeBar:CreateObject(i, enabledObjects[i], 'CenterGroup')
	end

	LDB.RegisterCallback('RaeBar', 'LibDataBroker_DataObjectCreated', AddNewElement)

	RaeBar:PositionGroup('CenterGroup')

	RaeBar:PositionBar('CenterGroup')

	RaeBar:RegisterOptions()
end