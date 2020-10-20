local raebar = LibStub("AceAddon-3.0"):NewAddon("Raebar", "AceConsole-3.0")
local LSM = LibStub('LibSharedMedia-3.0')

local UPDATEPERIOD, elapsed = 0.5, 0
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")

local function NewObject(event, name, dataObj)
	print('New object:' .. name)
end

LDB.RegisterCallback('RaeBar', 'LibDataBroker_DataObjectCreated', NewObject)

---- TEST FPS Object
local dataObj = LDB:NewDataObject("RaeBarFPS", {type = "data source", text = "75.0 FPS"})
local f = CreateFrame("frame")


f:SetScript("OnUpdate", function(self, elap)
	elapsed = elapsed + elap
	if elapsed < UPDATEPERIOD then return end

	elapsed = 0
	local fps = GetFramerate()
	dataObj.text = string.format("%.1f FPS", fps)
end)

function dataObj:OnTooltipShow()
	self:AddLine(dataObj.text)
end

function dataObj:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
	GameTooltip:ClearLines()
	dataObj.OnTooltipShow(GameTooltip)
	GameTooltip:Show()
end

function dataObj:OnLeave()
	GameTooltip:Hide()
end

local obj = LDB:GetDataObjectByName('RaeBarFPS')
TESTOBJ = obj




local testDisplay = CreateFrame('frame', BackdropTemplateMixin and 'BackdropTemplate')
testDisplay:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
testDisplay:SetSize(100,20)
local testDisplaytext = testDisplay:CreateFontString()
testDisplaytext:SetAllPoints(testDisplay)

local Font = ''
Font = LSM:Fetch('font', 'RUF')
local size = 18

testDisplaytext:SetFont(Font, size)

testDisplaytext:SetText('test')






testDisplaytext:SetText(obj.text)

local hideelapsed = 0
local function OnUpdate(self, elapsed)
	hideelapsed = hideelapsed + elapsed
	if hideelapsed < 2 then return end

	self:ClearAllPoints()
	self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	self:SetScript("OnUpdate", nil)
end

local function testEnter()
	testDisplay:SetScript("OnUpdate", nil)
	testDisplay:ClearAllPoints()
	testDisplay:SetPoint("CENTER", UIParent, "CENTER", 0, 20)
end


local function testLeave()
	hideelapsed = 0
	testDisplay:SetScript("OnUpdate", OnUpdate)
end
testDisplay:SetScript("OnEnter", testEnter)
testDisplay:SetScript("OnLeave", testLeave)



local function Update(event, name, attribute, value, dataObj)
	print(dataObj.text)
	print(name)
	if name == 'RaeBarFPS' then
		testDisplaytext:SetText(dataObj.text)

	end

end

LDB.RegisterCallback('RaeBar', 'LibDataBroker_AttributeChanged', Update)