local RaeBar = LibStub('AceAddon-3.0'):NewAddon('Raebar', 'AceConsole-3.0')
local ACD = LibStub('AceConfigDialog-3.0')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local L = LibStub('AceLocale-3.0'):GetLocale('RaeBar')
local addonName = 'RaeBar'
local versionString = string.match(GetAddOnMetadata(addonName,'Version'),'%d+') or 'DEV'

function RaeBar:TempOptions()
	local Options = {
		type = 'group',
		name = function(info)
			return addonName .. ' r|cFFFF2C5A' .. versionString ..'|r'
		end,
		order = 0,
		args = {
				Open = {
					name = L['Open Configuration Panel'],
					type = 'execute',
					order = 0,
					func = function()
						if not InCombatLockdown() then
							-- HideUIPanel protected in 8.2 Prevent UI taint.
							HideUIPanel(InterfaceOptionsFrame)
							HideUIPanel(GameMenuFrame)
							RaeBar:ChatCommand('Open')
						end
					end,
				},
			},
		}
	LibStub('AceConfig-3.0'):RegisterOptionsTable('RaeBar_Blizz', Options) -- Register Options
	self.optionsFrame = ACD:AddToBlizOptions('RaeBar_Blizz', addonName)
end

function RaeBar:ChatCommand(input)
	if not InCombatLockdown() then
		if _G['AceConfigDialog'].OpenFrames[addonName] then
			ACD:Close(addonName)
		else
			ACD:Open(addonName)
		end
	else
		print('|cFFFF2C5A' .. addonName .. ': |r' .. L['Cannot configure while in combat.'])
	end
end

function RaeBar:OnInitialize()
	self.db = LibStub('AceDB-3.0'):New('rbdb', RaeBar.defaults)

	self:RegisterChatCommand('RB', 'ChatCommand')
	self:RegisterChatCommand('RAEBAR', 'ChatCommand')

	-- Profile Management
	self.db.RegisterCallback(self, 'OnProfileChanged', 'RefreshConfig')
	self.db.RegisterCallback(self, 'OnProfileCopied', 'RefreshConfig')
	self.db.RegisterCallback(self, 'OnProfileReset', 'RefreshConfig')

	-- Add Button to open Ace3 Options panel.
	RaeBar:TempOptions()

end

function RaeBar:RefreshConfig()
	RaeBar.db.profile = self.db.profile
end