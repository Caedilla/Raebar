local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local obj = LDB:NewDataObject('rbGold', {type = 'data source', text = 'Gold'})
local updatePeriod = 5
local sessionStartGold, curGold

local function FirstRun()
	if not RaeBar.myRealm then
		RaeBar.myRealm = GetNormalizedRealmName()
	end
	if not RaeBar.myName then
		RaeBar.myName = UnitName('player')
	end
end

local function UpdateData()
	curGold = GetMoney()
	if not sessionStartGold then
		sessionStartGold = curGold
	end
	local goldDiff = math.abs(sessionStartGold - curGold)
	if curGold > sessionStartGold then
		goldDiff = 0 - goldDiff
	end

	RaeBar.db.global.gold[RaeBar.myRealm][RaeBar.myName] = curGold
	RaeBar.rbGold.goldDiff = goldDiff

	if 1 == 1 then
		--obj.text = string.format('%02d|cFFFFCC00:|r%02d',sHour,sMin)
	else
		--obj.text = string.format('%02d|cFFFFCC00:|r%02d|cFFFFCC00:|r%02d',lDate.hour,lDate.min,lDate.sec)
		updatePeriod = 0.5
	end
	C_Timer.After(updatePeriod, UpdateData)

end

function obj:OnTooltipShow()
	UpdateData()

	self:AddLine(RaeBar.rbGold.goldDiff)
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

FirstRun()
UpdateData()

local updateFrame = CreateFrame('frame')
updateFrame:RegisterEvent('PLAYER_MONEY', UpdateData)
updateFrame:RegisterEvent('SEND_MAIL_MONEY_CHANGED', UpdateData)
updateFrame:RegisterEvent('SEND_MAIL_COD_CHANGED', UpdateData)
updateFrame:RegisterEvent('PLAYER_TRADE_MONEY', UpdateData)
updateFrame:RegisterEvent('TRADE_MONEY_CHANGED', UpdateData)
updateFrame:SetScript('OnEvent', UpdateData)