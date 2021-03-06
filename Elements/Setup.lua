local RaeBar = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local LSM = LibStub('LibSharedMedia-3.0')

local function GetTipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return 'TOPLEFT', 'BOTTOMLEFT' end
	local hhalf = (x > UIParent:GetWidth()*2/3) and 'RIGHT' or (x < UIParent:GetWidth()/3) and 'LEFT' or ''
	local vhalf = (y > UIParent:GetHeight()/2) and 'TOP' or 'BOTTOM'
	return vhalf..hhalf, frame, (vhalf == 'TOP' and 'BOTTOM' or 'TOP')..hhalf
end

local function OnEnter(self, ...)
	if self.obj.OnEnter then self.obj.OnEnter(self, ...)
	elseif self.obj.OnTooltipShow then
		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
		GameTooltip:SetPoint(GetTipAnchor(self))
		GameTooltip:ClearLines()
		self.obj.OnTooltipShow(GameTooltip, self)
		GameTooltip:Show()
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
	if self.obj.OnLeave then
		self.obj.OnLeave(self, ...)
	else
		GameTooltip:Hide()
	 end
end

local function OnClick(self, ...)
	if self.obj.OnClick then
		self.obj.OnClick(self, ...)
	end
end

local function OnClickChanged(self, event, name, key, value, obj)
	self:SetScript('OnClick', value)
end

local function OnTextChanged(self, event, name, key, value, obj)
	self.text:SetText(obj.text)
end


-- TODO
--[[
3 Bar locations, left, center, and right - right and left can be offset
left and right bar anchor off of first bar - left grows right, right grows left
for center bar:
	build number of elements, if there are an odd number, get the center point of the the middle element and
	then set the anchor point of the middle element to be CENTER / BOTTOM / TOP and then work up and down the array
	anchoring each other element off from the middle one.

	for even numbers, do the same, but anchor the middle 2 on either side, i.e 4,5 in an 8 element setup
	so 4 is anchored from the right going left of the center point, and 5 is anchored left going right from the center point

	text in both cases should be justified to the center
]]--


local elementSpace, elementEnd = 5, 2
RaeBar.frames = {
	group = {

	}
}
function RaeBar:CreateObject(id, objName, groupName)
	local elementName = string.format('%s_%s', 'RaeBarElement', id)

	-- TODO replace nil with bar when I get around to creating it
	local frame = CreateFrame('button', elementName, UIParent)

	frame:RegisterForClicks("anyUp")
	frame.OnClickChanged = OnClickChanged
	frame.OnTextChanged = OnTextChanged

	if not RaeBar.frames.group[groupName] then
		RaeBar.frames.group[groupName] = {}
	end
	if not RaeBar.frames.group[groupName].firstFrame then
		RaeBar.frames.group[groupName].firstFrame = frame
		frame:SetPoint('LEFT', UIParent, 'TOP', 0, -15)
	else
		frame:SetPoint('LEFT', RaeBar.frames.group[groupName].lastframe or UIParent, RaeBar.frames.group[groupName].lastframe and 'RIGHT' or 'LEFT', RaeBar.frames.group[groupName].lastframe and elementSpace or elementEnd, 0)
	end

	frame:SetSize(100,20)
	local text = frame:CreateFontString()
	text:SetAllPoints(frame)
	frame.text = text

	local Font = ''
	Font = LSM:Fetch('font', 'RUF')
	local size = 18
	text:SetFont(Font, size, 'OUTLINE')

	RaeBar:SetDataSource(frame, objName)
	RaeBar.frames.group[groupName][id], RaeBar.frames.group[groupName].lastframe = frame, frame

end

function RaeBar:SetDataSource(frame, name)
	if not frame and not _G[frame] then return end

	-- Unregister all events first so we can use this function to unset elements too.
	LDB.UnregisterAllCallbacks(frame)

	local obj = LDB:GetDataObjectByName(name)
	if not obj then return end

	frame.obj = obj
	frame.objName = name

	frame.text:SetText(obj.text)

	frame:SetScript('OnEnter', OnEnter)
	frame:SetScript('OnLeave', OnLeave)
	frame:SetScript('OnClick', OnClick)

	LDB.RegisterCallback(frame, 'LibDataBroker_AttributeChanged_'..name..'_OnClick', 'OnClickChanged')
	LDB.RegisterCallback(frame, 'LibDataBroker_AttributeChanged_'..name..'_text', 'OnTextChanged')

end

function RaeBar:PositionGroup(groupName)
	local distLeft = RaeBar.frames.group[groupName].firstFrame:GetLeft()
	local distRight = RaeBar.frames.group[groupName].lastframe:GetRight()
	local UIWidth = UIParent:GetWidth()

	local pos = UIWidth / 2 - (distRight - distLeft) / 2
	RaeBar.frames.group[groupName].firstFrame:ClearAllPoints()
	RaeBar.frames.group[groupName].firstFrame:SetPoint('LEFT', UIParent, 'TOP', -pos, -15)
end