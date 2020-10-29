local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local LSM = LibStub('LibSharedMedia-3.0')

RaeBar.Bars = {}

function RaeBar:CreateBar(profile)

	local barName = string.format('%s_%s', 'RaeBar', 1) -- replace 1 with profile.name
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
end

function RaeBar:PositionBar()
	local barName = string.format('%s_%s', 'RaeBar', 1) -- replace 1 with profile.name
	local bar = RaeBar.Bars[barName]

	bar:ClearAllPoints()
	bar:SetPoint('TOPLEFT', RaeBar.firstFrame, 'TOPLEFT', -5, 1)
	bar:SetPoint('TOPRIGHT', RaeBar.lastframe, 'TOPRIGHT', 5, 1)


end