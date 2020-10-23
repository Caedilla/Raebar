local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local L = LibStub('AceLocale-3.0'):GetLocale('RaeBar')
local addonName = 'RaeBar'
local versionString = string.match(GetAddOnMetadata(addonName,'Version'),'%d+') or 'DEV'

local function BaseOptions()
	local options = {
		type = 'group',
		name = addonName .. ' r|cFFFF2C5A' .. versionString ..'|r',
		order = 0,
		childGroups = 'tab',
		args = {

		},
	}
	return options
end

function RaeBar:RegisterOptions()
	local optionsTable = BaseOptions()
	LibStub('AceConfig-3.0'):RegisterOptionsTable('RaeBar', optionsTable)

	local profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
	optionsTable.args.profiles = profiles
	optionsTable.args.profiles.order = 100

	LibStub('AceConfigDialog-3.0'):SetDefaultSize('RaeBar',700,700)
	InterfaceAddOnsList_Update()

end

function RaeBar:UpdateOptions()
	RaeBar:RegisterOptions()
	LibStub('AceConfigRegistry-3.0'):NotifyChange('RaeBar')
end