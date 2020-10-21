local addon = LibStub('AceAddon-3.0'):GetAddon('Raebar')
local LDB = LibStub:GetLibrary('LibDataBroker-1.1')
local obj = LDB:NewDataObject('rbDurability', {type = 'data source', text = 'Durability'})

local invSlotIDs = {
	[1] = _G['INVTYPE_HEAD'],
	[3] = _G['INVTYPE_SHOULDER'],
	[5] = _G['INVTYPE_CHEST'],
	[6] = _G['INVTYPE_WAIST'],
	[7] = _G['INVTYPE_LEGS'],
	[8] = _G['INVTYPE_FEET'],
	[9] = _G['INVTYPE_WRIST'],
	[10] = _G['INVTYPE_HAND'],
	[16] = _G['INVTYPE_WEAPONMAINHAND'],
	[17] = _G['INVTYPE_WEAPONOFFHAND'],
	-- TODO: Detect client type and add ranged slot for classic.
	--[18] = _G['INVTYPE_RANGED'],
}
local averageDurability = 0
local curDurability = {}

-- TODO: Add option to show average durability of all equipped items, or show the durability of the item with the lowest current durability.
local function UpdateData(self, event)
	wipe(curDurability)
	for i in pairs(invSlotIDs) do
		local cur,max = GetInventoryItemDurability(i)
		if cur and max then
			curDurability[i] = (cur/max) * 100
		end
	end

	averageDurability = 0
	local equippedCount = 0
	for i in pairs(curDurability) do
		averageDurability = averageDurability + curDurability[i]
		equippedCount = equippedCount + 1
	end
	averageDurability = averageDurability / equippedCount

	obj.text = string.format('Armor: %s%%', averageDurability)
	obj.value = string.format('%.0f',averageDurability)
	obj.suffix = '%'
end
UpdateData()

local updateFrame = CreateFrame('frame')
updateFrame:RegisterEvent('UPDATE_INVENTORY_DURABILITY', UpdateData)
updateFrame:RegisterEvent('MERCHANT_SHOW', UpdateData)
updateFrame:SetScript('OnEvent', UpdateData)