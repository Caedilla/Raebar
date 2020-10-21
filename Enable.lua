local addon = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local LSM = LibStub('LibSharedMedia-3.0')

-- Attributes: https://github.com/tekkub/libdatabroker-1-1/wiki/Data-Specifications

local function GetTipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return 'TOPLEFT', 'BOTTOMLEFT' end
	local hhalf = (x > UIParent:GetWidth()*2/3) and 'RIGHT' or (x < UIParent:GetWidth()/3) and 'LEFT' or ''
	local vhalf = (y > UIParent:GetHeight()/2) and 'TOP' or 'BOTTOM'
	return vhalf..hhalf, frame, (vhalf == 'TOP' and 'BOTTOM' or 'TOP')..hhalf
end

local function OnEnter(self, ...)
	if self.obj.OnEnter then self.obj.OnEnter(self, ...)
	else
		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
		GameTooltip:SetPoint(GetTipAnchor(self))
		GameTooltip:ClearLines()

		--local name, title, notes = GetAddOnInfo(self.obj.tocname or self.doname)
		--if name then
		--	GameTooltip:AddLine(title or name)
		--	GameTooltip:AddLine(notes)
		--else
		--	GameTooltip:AddLine(self.obj.label or self.doname)
		--end

		-- TODO Build tooltip data

		GameTooltip:AddLine(self.obj.text)

		GameTooltip:Show()
	end
end

local function OnLeave(self, ...)
	if self.obj.OnLeave then self.obj.OnLeave(self, ...)
	else GameTooltip:Hide() end
end

local function OnClickChanged(self, event, name, key, value, obj)
	self:SetScript('OnClick', value)
end

local function OnTextChanged(self, event, name, key, value, obj)
	self.fontString:SetText(obj.text)
end

local elementSpace, elementEnd = 5, 2
local frames, lastframe = {}
local function CreateObject(name)
	local obj = LDB:GetDataObjectByName(name)
	local elementName = string.format("%s_%s", addon.addonName, name)

	-- TODO replace nil with bar when I get around to creating it
	local frame = CreateFrame('frame', elementName, nil, BackdropTemplateMixin and 'BackdropTemplate')

	frame.OnClickChanged = OnClickChanged
	frame.OnTextChanged = OnTextChanged
	frame.obj = obj

	frame:SetPoint("LEFT", lastframe or UIParent, lastframe and "RIGHT" or "LEFT", lastframe and elementSpace or elementEnd, 0)
	frame:SetSize(100,20)
	local text = frame:CreateFontString()
	text:SetAllPoints(frame)
	frame.fontString = text

	local Font = ''
	Font = LSM:Fetch('font', 'RUF')
	local size = 18

	text:SetFont(Font, size)
	text:SetText(obj.text)

	frame:SetScript('OnEnter',OnEnter)
	frame:SetScript('OnLeave',OnLeave)
	if obj.OnClick then
		frame:SetScript('OnClick', obj.OnClick)
	end

	LDB.RegisterCallback(frame, 'LibDataBroker_AttributeChanged_'..name..'_OnClick', 'OnClickChanged')
	LDB.RegisterCallback(frame, 'LibDataBroker_AttributeChanged_'..name..'_text', 'OnTextChanged')

	frames[name], lastframe = frame, frame
end

CreateObject('rbSystem')
CreateObject('rbLatency')
CreateObject('rbDurability')