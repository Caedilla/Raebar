local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local LSM = LibStub('LibSharedMedia-3.0')

RaeBar.Bars = {}

function RaeBar:CreateBar(groupName)

	local barName = string.format('%s_%s', 'RaeBar', groupName)
	local bar = CreateFrame('frame', barName, UIParent)
	local background = bar:CreateTexture(nil, 'BACKGROUND')
	local border = CreateFrame('frame', nil, bar, BackdropTemplateMixin and 'BackdropTemplate')

	bar:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 0, 0)
	bar:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', 0, 0)
	bar:SetHeight(21)

	background:SetTexture(LSM:Fetch('background', 'Solid'))
	background:SetVertexColor(0.1, 0.1, 0.125, 0.75)
	background:SetAllPoints(bar)

	local offset = 0 -- profile.border.offset or 0
	border:SetPoint('TOPLEFT',bar,'TOPLEFT',-offset,offset)
	border:SetPoint('BOTTOMRIGHT',bar,'BOTTOMRIGHT',offset,-offset)
	border:SetBackdrop({edgeFile = LSM:Fetch('border', 'RUF Pixel'), edgeSize = 1})
	border:SetBackdropBorderColor(0, 0, 0, 1)

	RaeBar.Bars[barName] = bar

	RaeBar.CreateStatusBar(bar, groupName)
end

local function UpdateXPBar(self, event, ...)
	local xp, xpMax = UnitXP('player'), UnitXPMax('player')
	self:SetMinMaxValues(0, xpMax)
	self:SetValue(xp)

end

function RaeBar:CreateStatusBar(groupName)
	local barName = string.format('%s_%s', 'RaeBarStatusBar', groupName)
	local bar = CreateFrame('StatusBar', barName, self)
	local texture = LSM:Fetch('statusbar', '1.Raeli')
	local events = {
		'PLAYER_XP_UPDATE',
		'UPDATE_EXHAUSTION',
	}

	bar:SetAllPoints(self)
	bar:SetStatusBarTexture(texture)
	bar:SetStatusBarColor(0.9, 0.9, 1, 0.75)
	bar:SetFrameLevel(1)

	for i = 1, #events do
		bar:RegisterEvent(events[i], UpdateXPBar)
	end
	bar:SetScript('OnEvent', UpdateXPBar)

	bar.Update = UpdateXPBar

	bar:Update()
end

function RaeBar:PositionBar(groupName)
	local barName = string.format('%s_%s', 'RaeBar', groupName)
	local bar = RaeBar.Bars[barName]

	bar:ClearAllPoints()
	bar:SetPoint('TOPLEFT', RaeBar.frames.group[groupName].firstFrame, 'TOPLEFT', -5, 1)
	bar:SetPoint('TOPRIGHT', RaeBar.frames.group[groupName].lastframe, 'TOPRIGHT', 5, 1)

end