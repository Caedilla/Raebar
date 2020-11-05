local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local obj = LDB:NewDataObject('rbGold', {type = 'data source', text = 'Gold'})
local sessionStartGold, curGold
local initiated
local colors = {
	['g'] = 'ffbf35',
	['s'] = 'c4c4c4',
	['c'] = 'da8f47',
}
RaeBar.rbGold = {}

local function FirstRun()
	if not RaeBar.myRealm then
		RaeBar.myRealm = GetNormalizedRealmName()
	end
	if not RaeBar.myName then
		RaeBar.myName = UnitName('player')
	end

	if not RaeBar.db.global.gold then
		RaeBar.db.global.gold = {
			[RaeBar.myRealm] = {
				[RaeBar.myName] = 0
			}
		}
	elseif not RaeBar.db.global.gold[RaeBar.myRealm] then
		RaeBar.db.global.gold[RaeBar.myRealm] = {
			[RaeBar.myName] = 0
		}
	end
	initiated = true
end

local function FormatGold(amount)
	local value = abs(amount)
	local gold = floor(value / 10000)
	local silver = floor(mod(value / 100, 100))
	local copper = floor(mod(value, 100))


	return gold, silver, copper
end

local function UpdateData()
	if not initiated then
		FirstRun()
	end
	curGold = GetMoney()
	if not sessionStartGold then
		sessionStartGold = curGold
	end
	local goldDiff = curGold - sessionStartGold

	RaeBar.db.global.gold[RaeBar.myRealm][RaeBar.myName] = curGold
	RaeBar.rbGold.goldDiff = goldDiff


	local g, s, c = FormatGold(curGold)
	g, s, c = BreakUpLargeNumbers(g), BreakUpLargeNumbers(s), BreakUpLargeNumbers(c)

	obj.text = string.format('%s|cFF%sg|r',g, colors.g)
end

function obj:OnTooltipShow()
	UpdateData()
	local g, s, c = FormatGold(RaeBar.rbGold.goldDiff)
	g, s, c = BreakUpLargeNumbers(g), BreakUpLargeNumbers(s), BreakUpLargeNumbers(c)
	local negative = ''
	if RaeBar.rbGold.goldDiff < 0 then
		negative = '-'
	end
	self:AddLine(string.format('|cFFFFFFFF%s%s|cFF%sg|r %s|cFF%ss|r %s|cFF%sc|r|r', negative, g, colors.g, s, colors.s, c, colors.c))
end

function obj:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
	GameTooltip:ClearLines()
	obj.OnTooltipShow(GameTooltip)
	GameTooltip:Show()
end

function obj:OnLeave()
	GameTooltip:Hide()
end

local events = {
	'PLAYER_ENTERING_WORLD',
	'PLAYER_MONEY',
	'SEND_MAIL_MONEY_CHANGED',
	'SEND_MAIL_COD_CHANGED',
	'PLAYER_TRADE_MONEY',
	'TRADE_MONEY_CHANGED',
}

local updateFrame = CreateFrame('frame')
for i = 1, #events do
	updateFrame:RegisterEvent(events[i], UpdateData)
end
updateFrame:SetScript('OnEvent', UpdateData)