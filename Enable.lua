local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')

-- Attributes: https://github.com/tekkub/libdatabroker-1-1/wiki/Data-Specifications

local enabledObjects = {
	'gmSpecs',
	--'rbGold',
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
			RaeBar:CreateObject(i+500, name)
		end
	end

end

function RaeBar:OnEnable()
	RaeBar:CreateBar()
	for i = 1, #enabledObjects do
		RaeBar:CreateObject(i, enabledObjects[i])
	end

	LDB.RegisterCallback('RaeBar', 'LibDataBroker_DataObjectCreated', AddNewElement)

	RaeBar:PositionGroup()

	RaeBar:RegisterOptions()
end