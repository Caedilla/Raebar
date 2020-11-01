local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local obj = LDB:NewDataObject('rbGold', {type = 'data source', text = 'Gold'})
local updatePeriod = 5
local sessionStartGold, curGold
local initiated
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
	if 1 == 1 then
		obj.text = string.format('%d|cFFFFCC00g|r',g)
	else
		--obj.text = string.format('%02d|cFFFFCC00:|r%02d|cFFFFCC00:|r%02d',lDate.hour,lDate.min,lDate.sec)
		updatePeriod = 0.5
	end
	C_Timer.After(updatePeriod, UpdateData)

end

function obj:OnTooltipShow()
	UpdateData()
	local g, s, c = FormatGold(RaeBar.rbGold.goldDiff)
	local negative = ''
	if RaeBar.rbGold.goldDiff < 0 then
		negative = '-'
	end
	self:AddLine(string.format('%s%d|cFFFFCC00g|r %d|cFFFFCC00s|r %d|cFFFFCC00c|r', negative, g, s, c))

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

local updateFrame = CreateFrame('frame')
updateFrame:RegisterEvent('PLAYER_MONEY', UpdateData)
updateFrame:RegisterEvent('SEND_MAIL_MONEY_CHANGED', UpdateData)
updateFrame:RegisterEvent('SEND_MAIL_COD_CHANGED', UpdateData)
updateFrame:RegisterEvent('PLAYER_TRADE_MONEY', UpdateData)
updateFrame:RegisterEvent('TRADE_MONEY_CHANGED', UpdateData)
updateFrame:SetScript('OnEvent', UpdateData)