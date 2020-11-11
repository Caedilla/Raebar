local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local obj = LDB:NewDataObject('rbGold', {type = 'data source', text = 'Gold'})
local sessionStartGold, curGold
local initiated
local myRealm, myName = GetNormalizedRealmName(), UnitName('player')
local colors = {
	['g'] = 'ffbf35',
	['s'] = 'c4c4c4',
	['c'] = 'da8f47',
}
local goldDiff
local serverGold = {}

local function FirstRun()
	if not myRealm then
		myRealm = GetNormalizedRealmName()
	end

	if not RaeBar.db.global.gold then
		RaeBar.db.global.gold = {
			[myRealm] = {
				[myName] = 0
			}
		}
	elseif not RaeBar.db.global.gold[myRealm] then
		RaeBar.db.global.gold[myRealm] = {
			[myName] = 0
		}
	end
	initiated = true
end

local function FormatGold(amount)
	local value = math.abs(amount)
	local gold = math.floor(value / 10000)
	local silver = math.floor(mod(value / 100, 100))
	local copper = math.floor(mod(value, 100))

	return BreakUpLargeNumbers(gold), BreakUpLargeNumbers(silver), BreakUpLargeNumbers(copper)
end

local function UpdateData()
	if not initiated then
		FirstRun()
	end
	curGold = GetMoney()
	if not sessionStartGold then
		sessionStartGold = curGold
	end
	goldDiff = curGold - sessionStartGold

	RaeBar.db.global.gold[myRealm][myName] = curGold

	local g, s, c = FormatGold(curGold)

	obj.text = string.format('%s|cFF%sg|r',g, colors.g)
end

function obj:OnClick(button)
	if button == 'LeftButton' then
		ToggleAllBags()
	elseif IsShiftKeyDown() then
		goldDiff = 0
		sessionStartGold = curGold
		obj.OnEnter(self)
	end
end

function obj:OnTooltipShow()
	UpdateData()
	local g, s, c = FormatGold(goldDiff)

	local leftText = ''
	if goldDiff < 0 then
		leftText = 'Spent: '
	else
		leftText = 'Earned: '
	end
	if goldDiff ~= 0 then
		self:AddDoubleLine(leftText, string.format('|cFFFFFFFF%s|cFF%sg|r %s|cFF%ss|r %s|cFF%sc|r|r', g, colors.g, s, colors.s, c, colors.c))
		self:AddLine(' ')
	end

	serverGold[myRealm] = 0
	for k,v in pairs(RaeBar.db.global.gold[myRealm]) do
		if k ~= myName then
			serverGold[myRealm] = serverGold[myRealm] + v
			g, s, c = FormatGold(RaeBar.db.global.gold[myRealm][k])
			self:AddDoubleLine(string.format('%s: ', k), string.format('|cFFFFFFFF%s|cFF%sg|r %s|cFF%ss|r %s|cFF%sc|r|r', g, colors.g, s, colors.s, c, colors.c))
		end
	end

	g,s,c = FormatGold(serverGold[myRealm] + GetMoney())
	self:AddLine(' ')
	self:AddDoubleLine('Total: ', string.format('|cFFFFFFFF%s|cFF%sg|r %s|cFF%ss|r %s|cFF%sc|r|r', g, colors.g, s, colors.s, c, colors.c))

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