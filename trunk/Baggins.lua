local _G = _G

_G.Baggins = LibStub("AceAddon-3.0"):NewAddon("Baggins", "AceEvent-3.0", "AceHook-3.0", "AceBucket-3.0", "AceTimer-3.0", "AceConsole-3.0")

local Baggins = Baggins
local pt = LibStub("LibPeriodicTable-3.1", true)
local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")
local LBU = LibStub("LibBagUtils-1.0")
local qt = LibStub('LibQTip-1.0')
local dbIcon = LibStub("LibDBIcon-1.0")
local console = LibStub("AceConsole-3.0")
local gratuity = LibStub("LibGratuity-3.0")

local next,unpack,pairs,ipairs,tonumber,select,strmatch =
      next,unpack,pairs,ipairs,tonumber,select,strmatch

local min, max, ceil, floor, mod  =
      min, max, ceil, floor, mod

local tinsert, tremove, tsort =
      tinsert, tremove, table.sort

local tconcat = table.concat
local format = string.format
local band = bit.band
local wipe=wipe
local type = type
local function new() return {} end
local function del(t) wipe(t) end
local rdel = del

local GetItemCount, GetItemInfo, GetInventoryItemLink, GetItemQualityColor, GetItemFamily =
      GetItemCount, GetItemInfo, GetInventoryItemLink, GetItemQualityColor, GetItemFamily

local GetContainerItemInfo, GetContainerItemLink, GetContainerItemQuestInfo, GetContainerNumFreeSlots, GetContainerItemCooldown =
      GetContainerItemInfo, GetContainerItemLink, GetContainerItemQuestInfo, GetContainerNumFreeSlots, GetContainerItemCooldown

-- GLOBALS: UIParent, GameTooltip, BankFrame, CloseBankFrame, TEXTURE_ITEM_QUEST_BANG, TEXTURE_ITEM_QUEST_BORDER
-- GLOBALS: CoinPickupFrame
-- GLOBALS: BagginsCopperIcon, BagginsCopperText, BagginsSilverIcon, BagginsSilverText, BagginsGoldIcon, BagginsGoldText, BagginsMoneyFrame
-- GLOBALS: GetAddOnInfo, GetAddOnMetadata, GetNumAddOns, LoadAddOn
-- GLOBALS: GetCursorInfo, CreateFrame, GetCursorPosition, ClearCursor, GetScreenWidth, GetScreenHeight, GetMouseButtonClicked, IsControlKeyDown, IsAltKeyDown, IsShiftKeyDown
-- GLOBALS: GameFontNormalLarge, GameFontNormal
-- GLOBALS: EasyMenu

-- Bank tab locals, for auto reagent deposit
local BankFrame_ShowPanel = BankFrame_ShowPanel
local BANK_TAB = BANK_PANELS[1].name
local REAGENT_BANK_TAB = BANK_PANELS[2].name

Baggins.hasIcon = "Interface\\Icons\\INV_Jewelry_Ring_03"
Baggins.cannotDetachTooltip = true
Baggins.clickableTooltip = true
Baggins.independentProfile = true
Baggins.hideWithoutStandby = true

-- number of item buttons that should be kept in the pool, so that none need to be created in combat
Baggins.minSpareItemButtons = 10

_G.BINDING_HEADER_BAGGINS = L["Baggins"]
_G.BINDING_NAME_BAGGINS_TOGGLEALL = L["Toggle All Bags"]

local equiplocs = {
	INVTYPE_AMMO = 0,
	INVTYPE_HEAD = 1,
	INVTYPE_NECK = 2,
	INVTYPE_SHOULDER = 3,
	INVTYPE_BODY = 4,
	INVTYPE_CHEST = 5,
	INVTYPE_ROBE = 5,
	INVTYPE_WAIST = 6,
	INVTYPE_LEGS = 7,
	INVTYPE_FEET = 8,
	INVTYPE_WRIST = 9,
	INVTYPE_HAND = 10,
	INVTYPE_FINGER = 11,
	INVTYPE_TRINKET = 13,
	INVTYPE_CLOAK = 15,
	INVTYPE_WEAPON = 16,
	INVTYPE_SHIELD = 17,
	INVTYPE_2HWEAPON = 16,
	INVTYPE_WEAPONMAINHAND = 16,
	INVTYPE_WEAPONOFFHAND = 17,
	INVTYPE_HOLDABLE = 17,
	INVTYPE_RANGED = 18,
	INVTYPE_THROWN = 18,
	INVTYPE_RANGEDRIGHT = 18,
	INVTYPE_RELIC = 18,
	INVTYPE_TABARD = 19,
	INVTYPE_BAG = 20,
}
local currentbag
local currentsection
local currentcategory

local catsorttable = {}
Baggins.itemcounts = {}

local timers = {}
function Baggins:ScheduleNamedTimer(name, callback, delay, arg)
	local alreadyScheduled = timers[name]
	if alreadyScheduled and self:TimeLeft(alreadyScheduled) then
		self:CancelTimer(alreadyScheduled, true)
	end

	timers[name] = self:ScheduleTimer(callback, delay, arg)
end
function Baggins:CancelNamedTimer(name)
	local timer = timers[name]
	if timer then
		timers[name] = nil
		self:CancelTimer(timer, true)
	end
end
local nextFrameTimers = {}
local timerFrame = CreateFrame('Frame')
timerFrame:SetScript("OnUpdate", function(self)
	while next(nextFrameTimers) do
		local func = next(nextFrameTimers)
		local args = nextFrameTimers[func]
		if type(args) == 'table' then
			Baggins[func](Baggins, unpack(args))
			wipe(args)
		else
			Baggins[func](Baggins)
		end
		nextFrameTimers[func] = nil
	end
	self:Hide()
end)
function Baggins:ScheduleForNextFrame(callback, arg, ...)
	nextFrameTimers[callback] = arg and { arg, ... } or true
	timerFrame:Show()
end

-- internal signalling minilibrary

local signals = {}

function Baggins:RegisterSignal(name, handler, arg1)		-- Example: RegisterSignal("MySignal", self.SomeHandler, self)
	if not arg1 then error("want arg1 noob!") end
	if not signals[name] then
		signals[name] = {}
	end
	signals[name][handler]=arg1;
end

function Baggins:FireSignal(name, ...)		-- Example: FireSignal("MySignal", 1, 2, 3);
	if signals[name] then
		for handler,arg1 in pairs(signals[name]) do
			handler(arg1, ...);
		end
	end
end

local function PT3ModuleSet(info, value)
	local name = info[#info]
	Baggins.db.global.pt3mods[name] = value
	if value then
		LoadAddOn(name)
	end
end

local function PT3ModuleGet(info)
	local name = info[#info]
	return Baggins.db.global.pt3mods[name]
end

local tooltip

local ldbDropDownFrame = CreateFrame("Frame", "Baggins_DropDownFrame", UIParent, "UIDropDownMenuTemplate")

local ldbDropDownMenu
local spacer = { text = "", disabled = true, notCheckable = true, notClickable = true}
local function initDropdownMenu()
	ldbDropDownMenu = {
		{
			text = L["Force Full Refresh"],
			tooltipText = L["Forces a Full Refresh of item sorting"],
			func = function()
					Baggins:ForceFullRefresh()
					Baggins:UpdateBags()
				end,
			notCheckable = true,
		},
		spacer,
		{
			text = L["Hide Default Bank"],
			tooltipText = L["Hide the default bank window."],
			checked = Baggins.db.profile.hidedefaultbank,
			keepShownOnClick = true,
			func = function()
					Baggins.db.profile.hidedefaultbank = not Baggins.db.profile.hidedefaultbank
				end,
		},
		{
			text = L["Override Default Bags"],
			tooltipText = L["Baggins will open instead of the default bags"],
			checked = Baggins.db.profile.overridedefaultbags,
			keepShownOnClick = true,
			func = function()
					Baggins.db.profile.overridedefaultbags = not Baggins.db.profile.overridedefaultbags
					Baggins:UpdateBagHooks()
				end,
		},
		spacer,
		{
			text = L["Config Window"],
			func = function() Baggins:OpenConfig() end,
			notCheckable = true,
		},
		{
			text = L["Bag/Category Config"],
			func = function() Baggins:OpenEditConfig() end,
			notCheckable = true,
		},
	}
end

local function updateMenu()
	if not ldbDropDownMenu then
		initDropdownMenu()
		return
	end
	ldbDropDownMenu[3].checked = Baggins.db.profile.hidedefaultbank
	ldbDropDownMenu[4].checked = Baggins.db.profile.overridedefaultbags
end

local ldbdata = {
	type = "data source",
	icon = "Interface\\Icons\\INV_Jewelry_Ring_03",
	OnClick = function(self, message)
			if message == "RightButton" then
				tooltip:Hide()
				updateMenu()
				EasyMenu(ldbDropDownMenu, ldbDropDownFrame, "cursor", 0, 0, "MENU")
				-- Baggins:OpenConfig()
			else
				Baggins:OnClick()
			end
		end,
	label = "Baggins",
	text = "",
	OnEnter = function(self)
			tooltip = qt:Acquire('BagginsTooltip', 1)
			tooltip:SetHeaderFont(GameFontNormalLarge)
			tooltip:SetScript("OnHide", function(self)
					qt:Release(self)
				end)
			Baggins:UpdateTooltip(true)
			self.tooltip = tooltip
			tooltip:SmartAnchorTo(self)
			tooltip:SetAutoHideDelay(0.2, self)
			tooltip:Show()
		end,
}
Baggins.obj = LibStub("LibDataBroker-1.1"):NewDataObject("Baggins", ldbdata)

do
	local buttonCount = 0
	local buttonPool = {}

	local function createItemButton()
		local frame = CreateFrame("Button","BagginsPooledItemButton"..buttonCount,nil,"ContainerFrameItemButtonTemplate")
		buttonCount = buttonCount + 1
		if InCombatLockdown() then
			print("Baggins: WARNING: item-frame will be tainted")
			Baggins:RegisterEvent("PLAYER_REGEN_ENABLED")
			frame.tainted = true
		end
		return frame
	end

	function Baggins:RepopulateButtonPool(num)
		if InCombatLockdown() then
			Baggins:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		end
		while #buttonPool < num do
			local frame = createItemButton()
			table.insert(buttonPool, frame)
		end
	end

	local usedButtons = 0
	function Baggins:GetItemButton()
		usedButtons = usedButtons + 1
		self.db.char.lastNumItemButtons = usedButtons
		local frame
		if next(buttonPool) then
			frame = table.remove(buttonPool, 1)
		else
			frame = createItemButton()
		end
		self:ScheduleTimer("RepopulateButtonPool", 0, Baggins.minSpareItemButtons)
		return frame
	end

	function Baggins:ReleaseItemButton(button)
		button.glow:Hide()
		button.newtext:Hide()
		table.insert(buttonPool, button)
	end
end

function Baggins:PLAYER_REGEN_ENABLED()
	for _,bagframe in ipairs(Baggins.bagframes) do
		for _,section in ipairs(bagframe.sections) do
			for i,item in ipairs(section.items) do
				if item.tainted then
					local tainted = section.items[i]
					tainted:Hide()
					section.items[i] = self:CreateItemButton()
				end
			end
		end
	end
	self:ForceFullUpdate()
	self:RepopulateButtonPool(Baggins.minSpareItemButtons)
end

function Baggins:OnInitialize()
	self.bagframes = {}
	self.colors = {
		black = {r=0,g=0,b=0,hex="|cff000000"},
		white = {r=1,g=1,b=1,hex="|cffffffff"},
		blue = {r=0,g=0.5,b=1,hex="|cff007fff"},
		purple = {r=1,g=0.4,b=1,hex="|cffff66ff"},
	}

	self:InitOptions()
	local buttonsToPool = (self.db.char.lastNumItemButtons or 90) + Baggins.minSpareItemButtons -- create a few spare buttons
	self:RepopulateButtonPool(buttonsToPool)
	self:InitBagCategoryOptions()
	self:RegisterChatCommand("baggins", "OpenConfig")
	self.OnMenuRequest = self.opts

	dbIcon:Register("Baggins", ldbdata, self.db.profile.minimap)

	self.ptsetsdirty = true

	local PT3Modules
	if pt then
		for i = 1, GetNumAddOns() do
			local metadata = GetAddOnMetadata(i, "X-PeriodicTable-3.1-Module")
			if metadata then
				local name, _, _, enabled = GetAddOnInfo(i)
				if enabled then
					PT3Modules = PT3Modules or {}
				  PT3Modules[name] = true
				end
		  end
		end
	end

	if PT3Modules then
		self.opts.args.PT3LOD = {
				name = L["PT3 LoD Modules"],
				type = "group",
				desc = L["Choose PT3 LoD Modules to load at startup, Will load immediately when checked"],
				order = 135,
				args = {

				},
			}
		local order = 1
		for name in pairs(PT3Modules) do
			self.opts.args.PT3LOD.args[name] = {
				name = name,
				type = "toggle",
				order = order,
				desc = L["Load %s at Startup"]:format(name),
				arg = name,
				get = PT3ModuleGet,
				set = PT3ModuleSet,
			}
			order = order + 1
		end
	end

	-- self:RegisterChatCommand({ "/baggins" }, self.opts, "BAGGINS")

end

function Baggins:IsActive()
	return true
end

function Baggins:OnEnable()
	--self:SetBagUpdateSpeed();
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN", "UpdateItemButtonCooldowns")
	self:RegisterEvent("ITEM_LOCK_CHANGED", "UpdateItemButtonLocks")
	self:RegisterEvent("QUEST_ACCEPTED", "UpdateItemButtons")
	self:RegisterEvent("UNIT_QUEST_LOG_CHANGED", "UpdateItemButtons")
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", "OnBankChanged")
	self:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED", "OnReagentBankChanged")
	self:RegisterEvent("REAGENTBANK_PURCHASED", "OnReagentBankPurchased")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED", "OnBankSlotPurchased")
	self:RegisterEvent("BANKFRAME_CLOSED", "OnBankClosed")
	self:RegisterEvent("BANKFRAME_OPENED", "OnBankOpened")
	self:RegisterEvent("PLAYER_MONEY", "UpdateMoneyFrame")
	self:RegisterEvent('AUCTION_HOUSE_SHOW', "AuctionHouse")
	self:RegisterEvent('AUCTION_HOUSE_CLOSED', "CloseAllBags")
	self:RegisterBucketEvent('ADDON_LOADED', 5,'OnAddonLoaded')

	self:RegisterSignal('CategoryMatchAdded', self.CategoryMatchAdded, self)
	self:RegisterSignal('CategoryMatchRemoved', self.CategoryMatchRemoved, self)
	self:RegisterSignal('SlotMoved', self.SlotMoved, self)

	self:ScheduleRepeatingTimer("RunBagUpdates", 20)
	self:ScheduleRepeatingTimer("RunItemCountUpdates", 60)

	self:UpdateBagHooks()
	self:UpdateBackpackHook()
	self:RawHook("CloseSpecialWindows", true)
	self:RawHookScript(BankFrame,"OnEvent","BankFrame_OnEvent")

	-- hook blizzard PLAYERBANKSLOTS_CHANGED function to filter inactive table
	-- this is required to prevent a nil error when working with a tab that the
	-- default UI is not currently showing
	self:RawHook("BankFrameItemButton_Update", true)

	--force an update of all bags on first opening
	self.doInitialUpdate = true
	self.doInitialBankUpdate = true
	self:ResortSections()
	self:UpdateText()
	--self:SetDebugging(true)

	if pt then
		for name, load in pairs(self.db.global.pt3mods) do
			if GetAddOnMetadata(name, "X-PeriodicTable-3.1-Module") then
				if load then
					LoadAddOn(name)
				end
			else
				self.db.global.pt3mods[name] = nil
			end
		end
	end

	if self.db.profile.hideduplicates == true then
		self.db.profile.hideduplicates = "global"
	end
	self:CreateMoneyFrame()
	self:UpdateMoneyFrame()
	self:CreateBankControlFrame()
	self:UpdateBankControlFrame()
	local skin = self:GetSkin(self.db.profile.skin)
	if not skin then -- if skin doesn't exist anymore, reset to default
		console:Print("|cFFFF0000Baggins|r "..L["Skin '%s' not found, resetting to default"]:format(self.db.profile.skin))
		self.db.profile.skin = "default"
	end
	self:EnableSkin(self.db.profile.skin)
	self:OnProfileEnable()
	self:RunBagUpdates()
end

function Baggins:Baggins_CategoriesChanged()
	self:UpdateBags()
	self.doInitialBankUpdate = true
end

function Baggins:BankFrame_OnEvent(...)
	if not self:IsActive() or not self.db.profile.hidedefaultbank then
		self.hooks[BankFrame].OnEvent(...)
	end
end

function Baggins:UpdateBagHooks()
	if self.db.profile.overridedefaultbags then
		self:RawHook("OpenAllBags", "ToggleAllBags", true)
		self:RawHook("ToggleAllBags", true)
		self:RawHook("CloseAllBags", true)
	else
		self:UnhookBagHooks()
	end
end

function Baggins:UnhookBagHooks()
	if self:IsHooked("OpenAllBags") then
		self:Unhook("OpenAllBags")
	end
	if self:IsHooked("ToggleAllBags") then
		self:Unhook("ToggleAllBags")
	end
	if self:IsHooked("CloseAllBags") then
		self:Unhook("CloseAllBags")
	end
end

function Baggins:UpdateBackpackHook()
	if self.db.profile.overridebackpack then
		self:RawHookScript(MainMenuBarBackpackButton, "OnClick", "MainMenuBarBackpackButtonOnClick")
	else
		self:UnhookBackpack()
	end
end

function Baggins:UnhookBackpack()
	if self:IsHooked(MainMenuBarBackpackButton, "OnClick") then
		self:Unhook(MainMenuBarBackpackButton, "OnClick")
	end
end

function Baggins:OnDisable()
	self:CloseAllBags()
end

local INVSLOT_LAST_EQUIPPED, CONTAINER_BAG_OFFSET, NUM_BAG_SLOTS =
      INVSLOT_LAST_EQUIPPED, CONTAINER_BAG_OFFSET, NUM_BAG_SLOTS

function Baggins:SaveItemCounts()
	local itemcounts = self.itemcounts
	wipe(itemcounts)
	for bag,slot,link in LBU:Iterate("BAGS") do	-- includes keyring
		if link then
			local id = tonumber(link:match("item:(%d+)"))
			if id and not itemcounts[id] then
				itemcounts[id] = { count = GetItemCount(id), ts = time() }
			end
		end
	end
	for bag,slot,link in LBU:Iterate("REAGENTBANK") do
		if link then
			local id = tonumber(link:match("item:(%d+)"))
			if id and not itemcounts[id] then
				itemcounts[id] = { count = GetItemCount(id), ts = time() }
			end
		end
	end
	for slot = 0, INVSLOT_LAST_EQUIPPED do	-- 0--19
		local link = GetInventoryItemLink("player",slot)
		if link then
			local id = tonumber(link:match("item:(%d+)"))
			if id and not itemcounts[id] then
				itemcounts[id] = { count = GetItemCount(id), ts = time() }
			end
		end
	end
	for slot = 1+CONTAINER_BAG_OFFSET, NUM_BAG_SLOTS+CONTAINER_BAG_OFFSET do  -- 20--23
		local link = GetInventoryItemLink("player",slot)
		if link then
			local id = tonumber(link:match("item:(%d+)"))
			if id and not itemcounts[id] then
				itemcounts[id] = { count = GetItemCount(id), ts = time() }
			end
		end
	end
end

function Baggins:RunItemCountUpdates()
	if self.db.profile.newitemduration > 0 then
		Baggins:ForceFullUpdate()
	end
end

function Baggins:IsCompressed(itemID)
	local p = self.db.profile
	if self.tempcompressnone then
		return false
	end
	--slot sorting will break compression horribly
	if p.sort == "slot" then
		return false
	end
	if p.compressall then
		return true
	end
	--string id's here are empty slots
	if type(itemID) == "string" and p.compressempty then
		return true
	end

	if type(itemID) == "number" then
		local itemFamily = GetItemFamily(itemID)
		local _, _, _, _, _, _, _, itemStackCount, itemEquipLoc = GetItemInfo(itemID)
		if itemFamily then	-- likes to be nil during login
			if p.compressshards and band(itemFamily,4)~=0 and itemEquipLoc~="INVTYPE_BAG" then
				return true
			end
			if p.compressammo and band(itemFamily,3)~=0 and itemEquipLoc~="INVTYPE_BAG" then
				return true
			end
		end
		if p.compressstackable and itemStackCount and itemStackCount>1 then
			return true
		end
	end
end

function Baggins:OnAddonLoaded(name)
	if not pt and name then return end
	local module
	if type(name) == "string" then
		module = GetAddOnMetadata(name, "X-PeriodicTable-3.1-Module")
	else
		for k in pairs(name) do
			module = module or GetAddOnMetadata(k, "X-PeriodicTable-3.1-Module")
		end
	end
	if module then
		self.ptsetsdirty = true
	end
end

function Baggins:OnBankClosed()
	-- don't remove the test, it prevents infinite recursion loop on CloseBankFrame()
	if self.bankIsOpen then
		self.bankIsOpen = nil
		self:CloseAllBags()
	end
end

function Baggins:OnBankOpened()
	if self.doInitialBankUpdate then
		self.doInitialBankUpdate = nil
		Baggins:ForceFullBankUpdate()
	end
	self.bankIsOpen = true
	self:OpenAllBags()
end

function Baggins:OnBankChanged()
	self:OnBagUpdate(-1)
end

function Baggins:OnReagentBankChanged()
	self:OnBagUpdate(REAGENTBANK_CONTAINER)
end

function Baggins:OnReagentBankPurchased()
	self:UpdateBankControlFrame()
	self:ForceFullBankUpdate()
	self:UpdateBags()
end

function Baggins:OnBankSlotPurchased()
	self:UpdateBankControlFrame()
	self:ForceFullBankUpdate()
	self:UpdateBags()
end

-------------------------
-- Update Bag Contents --
-------------------------
local scheduled_refresh = false

function Baggins:ScheduleRefresh()
	if not scheduled_refresh then
		scheduled_refresh = self:ScheduleForNextFrame('Baggins_RefreshBags')
	end
end

function Baggins:Baggins_RefreshBags()
	if self.dirtyBags then
		--self:Debug('Updating bags')
		self:ReallyUpdateBags()
	end
	for bagid,bagframe in pairs(self.bagframes) do
		for secid,sectionframe in pairs(bagframe.sections) do
			if sectionframe.used and sectionframe.dirty then
				--self:Debug('Updating section #%d-%d', bagid, secid)
				self:ReallyLayoutSection(sectionframe)
			end
		end

		if bagframe.dirty then
			self:ReallyUpdateBagFrameSize(bagid)
		end
	end
	if self.dirtyBagLayout then
		self:ReallyLayoutBagFrames()
	end

	scheduled_refresh = nil
end

function Baggins:UpdateBags()
	self.dirtyBags = true
	self:ScheduleRefresh()
end

local othersections = {}

local function CheckSection(bagframe, secid)
	for i = 1,secid do
		if not bagframe.sections[i] then
			bagframe.sections[i] = Baggins:CreateSectionFrame(bagframe,i)
			if i == 1 then
				bagframe.sections[i]:SetPoint("TOPLEFT",bagframe,"TOPLEFT",10,-36)
			else
				bagframe.sections[i]:SetPoint("TOPLEFT",bagframe.sections[i-1],"BOTTOMLEFT",0,1)
			end
		end
	end
end

local function GetSlotInfo(item)
	local bag, slot = item:match("^(-?%d+):(%d+)$")
	local bagType = Baggins:IsSpecialBag(bag)
	local itemID
	local cacheditem = Baggins:GetCachedItem(item)
	if cacheditem then
		itemID = tonumber(cacheditem:match("^(%d+)"))
	end
	return bag, slot, itemID, bagType
end

function Baggins:CategoryMatchAdded(category, slot, isbank)
	local p = self.db.profile
	for bagid, bag in pairs(p.bags) do
		local bagframe = self.bagframes[bagid]
		if bagframe then
			for sectionid, section in pairs(bag.sections) do
				for catid, catname in pairs(section.cats) do
					if catname == category and (not bag.isBank == not isbank) then
						CheckSection(bagframe, sectionid)
						local secframe = bagframe.sections[sectionid]
						secframe.slots[slot] = ( secframe.slots[slot] or 0 ) + 1
						local layout = secframe.layout
						local bagnum, slotnum, itemid, bagtype = GetSlotInfo(slot)
						if not itemid then
							itemid = (bagtype or "")
						end
						local found

						--check for an existing stack to add the slot to
						for k, entry in ipairs(layout) do
							if type(entry) == "table" then
								if entry.itemid == itemid and entry.slots[slot] then
									found = true
								elseif entry.itemid == itemid then
									if self:IsCompressed(itemid) then
										if not entry.slots[slot] then
											entry.slots[slot] = true
											entry.slotcount = entry.slotcount + 1
										end
										found = true
									end
								else
									if entry.slots[slot] then
										entry.slots[slot] = nil
										entry.slotcount = entry.slotcount - 1
										if entry.slotcount == 0 then
											del(entry.slots)
											del(entry)
											layout[k] = slot
										end
									end
								end
							end
						end
						if not found then
							local newentry = new()
							newentry.slots = new()
							newentry.slots[slot] = true
							newentry.slotcount = 1
							newentry.itemid = itemid
							tinsert(layout, newentry)
							secframe.needssorting = true
						end
					end
				end
			end
		end
	end
end

function Baggins:CategoryMatchRemoved(category, slot, isbank)
	local p = self.db.profile
	for bagid, bag in pairs(p.bags) do
	local bagframe = self.bagframes[bagid]
		if bagframe then
			for sectionid, section in pairs(bag.sections) do
				for catid, catname in pairs(section.cats) do
					if catname == category and (not bag.isBank == not isbank) then
						CheckSection(bagframe, sectionid)
						local secframe = bagframe.sections[sectionid]
						secframe.slots[slot] = ( secframe.slots[slot] or 1 ) - 1
						if secframe.slots[slot] == 0 then
							secframe.slots[slot] = false
						end

						local layout = secframe.layout

						--remove the slot from any stacks that contain it
						for k, entry in ipairs(layout) do
							if type(entry) == "table" then
								if entry.slots[slot] then
									entry.slots[slot] = nil
									entry.slotcount = entry.slotcount - 1
								end
								if entry.slotcount == 0 then
									del(entry.slots)
									del(entry)
									layout[k] = slot
								end
							end
						end

					end
				end
			end
		end
	end
end

function Baggins:SlotMoved(category, slot, isbank)
	local p = self.db.profile
	for bagid, bag in pairs(p.bags) do
		local bagframe = self.bagframes[bagid]
		if bagframe then
			for sectionid, section in pairs(bag.sections) do
				for catid, catname in pairs(section.cats) do
					if catname == category and (not bag.isBank == not isbank) then
						CheckSection(bagframe, sectionid)
						local secframe = bagframe.sections[sectionid]
						secframe.needssorting = true
						local layout = secframe.layout
						local bagnum, slotnum, itemid, bagtype = GetSlotInfo(slot)
						if not itemid then
							itemid = (bagtype or "")
						end

						--remove the slot from any stacks that contain it
						for k, entry in ipairs(layout) do
							if type(entry) == "table" then
								if entry.slots[slot] then
									entry.slots[slot] = nil
									entry.slotcount = entry.slotcount - 1
								end
								if entry.slotcount == 0 then
									del(entry.slots)
									del(entry)
									layout[k] = slot
								end
							end
						end
						local found
						--check for an existing stack to add the slot to
						for k, entry in ipairs(layout) do
							if type(entry) == "table" then
								if entry.itemid == itemid then
									if self:IsCompressed(itemid) then
										if not entry.slots[slot] then
											entry.slots[slot] = true
											entry.slotcount = entry.slotcount + 1
										end
										found = true
									end
								else
									if entry.slots[slot] then
										entry.slots[slot] = nil
										entry.slotcount = entry.slotcount - 1
										if entry.slotcount == 0 then
											del(entry.slots)
											del(entry)
											layout[k] = slot
										end
									end
								end
							end
						end
						if not found then
							local newentry = new()
							newentry.slots = new()
							newentry.slots[slot] = true
							newentry.slotcount = 1
							newentry.itemid = itemid
							tinsert(layout, newentry)
							secframe.needssorting = true
						end

					end
				end
			end
		end
	end
end

function Baggins:ForceSectionReLayout(bagid)
	local bagframe = self.bagframes[bagid]
	if bagframe then
		for secid, secframe in pairs(bagframe.sections) do
			if secframe then
				for k, v in pairs(secframe.slots) do
					if v == false then
						secframe.slots[k] = nil
					end
				end
				secframe.needssorting = true
			end
		end
	end
end

function Baggins:ClearSectionCaches()
	for bagid, bag in ipairs(self.db.profile.bags) do
		local bagframe = self.bagframes[bagid]
		if bagframe then
			for secid, secframe in pairs(bagframe.sections) do
				if secframe then
					local layout = secframe.layout
					for k, v in pairs(layout) do
						if type(v) == "table" then
							del(v.slots)
							del(v)
						end
						layout[k] = nil
					end
					for k, v in pairs(secframe.slots) do
						secframe.slots[k] = nil
					end
				end
			end
		end
	end
end

function Baggins:RebuildSectionLayouts()
	for bagid, bag in ipairs(self.db.profile.bags) do
		local bagframe = self.bagframes[bagid]
		if bagframe then
			for secid, secframe in pairs(bagframe.sections) do
				if secframe then
					local layout = secframe.layout
					for k, v in pairs(layout) do
						if type(v) == "table" then
							del(v.slots)
							del(v)
						end
						layout[k] = nil
					end
					for slot, refcount in pairs(secframe.slots) do
						local bagnum, slotnum, itemid, bagtype = GetSlotInfo(slot)
						if not itemid then
							itemid = (bagtype or "")
						end
						local found
						--check for an existing stack to add the slot to
						for k, entry in ipairs(layout) do
							if entry then
								if entry.itemid == itemid then
									if self:IsCompressed(itemid) then
										if not entry.slots[slot] then
											entry.slots[slot] = true
											entry.slotcount = entry.slotcount + 1
										end
										found = true
									end
								else
									if entry.slots[slot] then
										entry.slots[slot] = nil
										entry.slotcount = entry.slotcount - 1
										if entry.slotcount == 0 then
											del(entry.slots)
											del(entry)
											layout[k] = slot
										end
									end
								end
							end
						end
						if not found then
							local newentry = new()
							newentry.slots = new()
							newentry.slots[slot] = true
							newentry.slotcount = 1
							newentry.itemid = itemid
							tinsert(layout, newentry)
							secframe.needssorting = true
						end
					end
					secframe.needssorting = true
				end
			end
		end
	end
end


function Baggins:ReallyUpdateBags()
	local p = self.db.profile
	local isVisible = false
	BagginsMoneyFrame:Hide()
	BagginsBankControlFrame:Hide()
	for bagid, bag in pairs(p.bags) do
		if self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
			isVisible = true
		end
	end
	if not isVisible then return end
	for bagid, bag in pairs(p.bags) do
		if ( not bag.isBank ) or self.bankIsOpen then
			if self.bagframes[bagid] then
				self:SetBagTitle(bagid,bag.name)
				if self.currentSkin then
					self.currentSkin:SetBankVisual(self.bagframes[bagid], bag.isBank)
				end
				for k, v in pairs(self.bagframes[bagid].sections) do
					v.used = nil
					v:Hide()
					for i, itemframe in pairs(v.items) do
						itemframe:Hide()
					end
				end
				for sectionid, section in pairs(bag.sections) do
					if (self.bagframes[bagid]:IsVisible() or p.hideemptybags) then
						self:UpdateSection(bagid,sectionid,section.name) --,Baggins:FinishSection())
					end
				end
				self:UpdateBagFrameSize(bagid)
			end
		end
	end

	self:UpdateLayout()
	self.dirtyBags = nil
end

function Baggins:UpdateSection(bagid, secid,title) --, contents)
	local bagframe = self.bagframes[bagid]
	if not bagframe then return end
	local i
	for i = 1,secid do
		if not bagframe.sections[i] then
			bagframe.sections[i] = self:CreateSectionFrame(bagframe,i)
			if i == 1 then
				bagframe.sections[i]:SetPoint("TOPLEFT",bagframe,"TOPLEFT",10,-36)
			else
				bagframe.sections[i]:SetPoint("TOPLEFT",bagframe.sections[i-1],"BOTTOMLEFT",0,1)
			end
		end
	end
	self:UpdateSectionContents(bagframe.sections[secid],title) --,contents)
	self:UpdateBagFrameSize(bagid)
end

-----------------
-- Bag Updates --
-----------------

local firstbagupdate = true

local bagupdatebucket = {}
local lastbag,lastbagfree=-1,-1

function Baggins:BAG_UPDATE(_, ...)
	self:OnBagUpdate(...)
end

function Baggins:OnBagUpdate(bagid)
	--ignore bags -4 ( currency ); -3 is reagent bank
	if bagid <= -4 then return end
	bagupdatebucket[bagid] = true
	if self:IsWhateverOpen() then
		self:ScheduleTimer("RunBagUpdates",0.1)
		lastbagfree=-1
	else
		-- Update panel text.
		-- Optimization mostly for hunters - their bags change for every damn arrow they fire:
		local free=GetContainerNumFreeSlots(bagid)
		if lastbag==bagid and lastbagfree==free then
			-- nada!
		else
			lastbag=bagid
			lastbagfree=free
			self:UpdateText()
		end
	end
end

function Baggins:RunBagUpdates()
	if firstbagupdate then
		firstbagupdate = false
		self:SaveItemCounts()
		self:ForceFullUpdate()
	end
	if not next(bagupdatebucket) then
		return
	end
	self:UpdateText()

	local itemschanged
	for bag in pairs(bagupdatebucket) do
		itemschanged = Baggins:CheckSlotsChanged(bag) or itemschanged
		bagupdatebucket[bag] = nil
	end

	if itemschanged then
		self:UpdateBags()
	else
		self:UpdateItemButtons()
	end

	if(self:IsWhateverOpen()) then
		Baggins:FireSignal("Baggins_BagsUpdatedWhileOpen");
	end
end

-----------------------------
-- Update Section Contents --
-----------------------------
function Baggins:UpdateSectionContents(sectionframe,title)
	local p = self.db.profile

	sectionframe.used = true
	if sectionframe.needssorting or self.db.profile.alwaysresort then
		local layout = sectionframe.layout
		local size = #layout
		if size > 0 then
			for i = size, 1, -1 do
				if type(layout[i]) == "string" then
					tremove(layout, i)
				end
			end
		end

		self:SortItemList(layout, p.sort)
		sectionframe.needssorting = false
	end
	sectionframe:Show()

	self:LayoutSection(sectionframe, title)
end


local function baseComp(a, b)
	local p = Baggins.db.profile
	if type(a) == "table" then
		for k, v in pairs(a.slots) do
			if v then
				a = k
				break
			end
		end
	end
	if type(b) == "table" then
		for k, v in pairs(b.slots) do
			if v then
				b = k
				break
			end
		end
	end
	-- getting a or b as nil here shouldn't happen. but it happens.
	local baga, slota = strmatch(a or "", "^(-?%d+):(%d+)$")
	local bagb, slotb = strmatch(b or "", "^(-?%d+):(%d+)$")
	baga=tonumber(baga)
	slota=tonumber(slota)
	bagb=tonumber(bagb)
	slotb=tonumber(slotb)
	local linka = baga and slota and GetContainerItemLink(baga, slota)
	local linkb = bagb and slotb and GetContainerItemLink(bagb, slotb)
	--if both are empty slots compare based on bag type
	if not linka and not linkb then
		local bagtypea = Baggins:IsSpecialBag(baga)
		local bagtypeb = Baggins:IsSpecialBag(bagb)
		if not bagtypea then
			return false
		end
		if not bagtypeb then
			return true
		end
		return bagtypea < bagtypeb
	end
	if not linka then
		return false
	end
	if not linkb then
		return true
	end

	if p.sortnewfirst and baga>=0 and baga<=NUM_BAG_SLOTS then
		local newa, newb = Baggins:IsNew(linka), Baggins:IsNew(linkb)
		if newa and not newb then
			return true
		end
		if newb and not newa then
			return false
		end
	end

	return nil,linka,linkb,baga,slota,bagb,slotb
end

local function getBattlePetInfoFromLink(link)
	local speciesID, level, quality, maxHealth, power, speed, petid, name = link:match("battlepet:(%d+):(%d+):([-%d]+):(%d+):(%d+):(%d+):([x%d]+)|h%[([%a%s]+)")
	return tonumber(speciesID), tonumber(level), tonumber(quality), tonumber(maxHealth), tonumber(power), tonumber(speed), tonumber(petid), name
end

local function getCompInfo(link)
	if not link:match("battlepet:") then
		return GetItemInfo(link)
	end
	local speciesID, level, quality, maxHealth, power, speed, petid, name = getBattlePetInfoFromLink(link)
	local petType = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
	local subtype = _G["BATTLE_PET_NAME_" .. petType]
	return name, nil, quality, level, nil, L["Battle Pets"], subtype
end

local function NameComp(a, b)
	local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
	if res~=nil then return res end

	local namea = getCompInfo(linka)
	local nameb = getCompInfo(linkb)

	if namea ~= nameb then
		return (namea  or "?") < (nameb or "?")
	end

	local counta = select(2, GetContainerItemInfo(baga, slota))
	local countb = select(2, GetContainerItemInfo(bagb, slotb))
	return (counta  or 0) > (countb or 0)
end
local function QualityComp(a, b)
	local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
	if res~=nil then return res end

	local namea, _, quala = getCompInfo(linka)
	local nameb, _, qualb = getCompInfo(linkb)

	if quala~=qualb then
		return (quala  or 0) > (qualb  or 0)
	end

	if namea ~= nameb then
		return (namea  or "?") < (nameb or "?")
	end

	local counta = select(2, GetContainerItemInfo(baga, slota))
	local countb = select(2, GetContainerItemInfo(bagb, slotb))
	return (counta  or 0) > (countb  or 0)
end
local function TypeComp(a, b)
	local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
	if res~=nil then return res end

	local namea, _, quala, _, _, typea, subtypea, _, equiploca = getCompInfo(linka)
	local nameb, _, qualb, _, _, typeb, subtypeb, _, equiplocb = getCompInfo(linkb)

	if typea ~= typeb then
		return (typea or "?") < (typeb or "?")
	end

	if (equiploca and equiplocs[equiploca]) and (equiplocb and equiplocs[equiplocb]) then
		if equiplocs[equiploca] ~= equiplocs[equiplocb] then
			return equiplocs[equiploca] < equiplocs[equiplocb]
		end
	end

	if quala~=qualb then
		return (quala or 0)  > (qualb or 0)
	end

	if namea ~= nameb then
		return (namea or "?")  < (nameb or "?")
	end

	local counta = select(2, GetContainerItemInfo(baga, slota))
	local countb = select(2, GetContainerItemInfo(bagb, slotb))
	return (counta or 0)  > (countb or 0)
end
local function SlotComp(a, b)
	local p = Baggins.db.profile
	if type(a) == "table" then
		a, b = (next(a.slots)), (next(b.slots))
	end
	local baga, slota = a:match("^(-?%d+):(%d+)$")
	local bagb, slotb = b:match("^(-?%d+):(%d+)$")
	if baga == bagb then
		slota = tonumber(slota)
		slotb = tonumber(slotb)
		return slota < slotb
	else
		return baga < bagb
	end
end
local function IlvlComp(a, b)
	local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
	if res~=nil then return res end

	local namea, _, quala, ilvla = getCompInfo(linka)
	local nameb, _, qualb, ilvlb = getCompInfo(linkb)
	if ilvla~=ilvlb then
		return (ilvla or 0) > (ilvlb or 0)
	end

	if quala~=qualb then
		return (quala or 0) > (qualb or 0)
	end

	if namea ~= nameb then
		return (namea or "?")  < (nameb or "?")
	end

	local counta = select(2, GetContainerItemInfo(baga, slota))
	local countb = select(2, GetContainerItemInfo(bagb, slotb))
	return (counta  or 0) > (countb or 0)
end

function Baggins:SortItemList(itemlist, sorttype)
	local func
	if sorttype == "name" then
		func = NameComp
	elseif sorttype == "quality" then
		func = QualityComp
	elseif sorttype == "type" then
		func = TypeComp
	elseif sorttype == "slot" then
		func = SlotComp
	elseif sorttype == "ilvl" then
		func = IlvlComp
	else
		return
	end
	tsort(itemlist, func)
end

------------------------
-- Section/Bag Layout --
------------------------
function Baggins:GetSectionSize(sectionframe, maxcols)
	local count
	local bagconf = self.db.profile.bags[sectionframe.bagid]
	if not bagconf then return 0,0 end
	local sectionconf = bagconf.sections[sectionframe.secid]
	if not sectionconf then return 0,0 end
	if sectionconf.hidden then
		count = 0
	else
		count = sectionframe.itemcount
	end
	maxcols = maxcols or count
	local columns = min(count, maxcols)
	local rows = ceil(count / maxcols)
	local width = columns * 39 - 2
	local height = rows * 39 - 2
	-- Flow requires we still get a height
	if maxcols < 1 then-- and not self.db.profile.flow_sections then
		height = 0
	end

	if self.db.profile.showsectiontitle then
		width = max(width, sectionframe.title:GetWidth())
		height = height + sectionframe.title:GetHeight()
	end

	return width, height, columns, rows
end


-- Flow layout
function Baggins:FlowSections(bagid)
	-- Bag references
	local bag = self.bagframes[bagid]
	local sections_conf = self.db.profile.bags[bagid].sections
	local skin = self.currentSkin
	-- Bag dimensions
	local width, height = 0, 0
	local xoff, yoff = skin.BagLeftPadding, -skin.BagTopPadding
	local max_cols = self.db.profile.columns
	-- Flow data
	local flow_x, flow_y, flow_anchor = 0, 0
	local flow_items, flow_sections, max_sections = 0, 0, 0
	local bagempty = true

	-- Like a river, man. LIKE A RIVER DO YOU HEAR ME
	for id, section in ipairs(self.bagframes[bagid].sections) do
		if section.used and section.itemcount > 0 then
			bagempty = false
			local available = max_cols - flow_items

			-- Give collapsed sections a virtual size to account for title length
			local x, y, section_items = self:GetSectionSize(section, max_cols)
			if not section_items then print('oops') return nil end
			local title_length = ceil(section.title:GetStringWidth()/39)
			if sections_conf[id] and sections_conf[id].hidden then
				section_items = title_length
			-- Account for long labels with one or two items
			else
				section_items = max(title_length, section_items)
			end
			flow_items = flow_items + section_items

			-- Add to last row
			if flow_anchor and available >= section_items then
				flow_sections = flow_sections + 1
				section:SetPoint("TOPLEFT", flow_anchor, "TOPLEFT", flow_x + 10, 0)
				flow_x = flow_x + x + 10
				flow_y = max(y, flow_y)

			else
				-- New row
				if flow_anchor then
					section:SetPoint("TOPLEFT", flow_anchor, "TOPLEFT", 0, -flow_y -5)
					y = y + 5
					max_sections = max(max_sections, flow_sections)
					height = height + flow_y + 5

				-- First row
				else
					section:SetPoint("TOPLEFT", bag, "TOPLEFT", xoff, yoff)
					--height = height + y
				end

				-- Frame/flow Data
				flow_anchor = section
				flow_items = section_items
				flow_sections = 0
				flow_x = x
				flow_y = y
			end

			width = max(x, width, flow_x)
		end
	end

	if (self.db.profile.hideemptybags and bagempty) then
		bag.isempty = true
	end

	-- Dimensions
	return width + skin.BagLeftPadding + skin.BagRightPadding, height + flow_y + skin.BagTopPadding + skin.BagBottomPadding
end

local areas = {}
function Baggins:OptimizeSectionLayout(bagid)
	local bagframe = self.bagframes[bagid]
	if not bagframe then
		return
	end
	local p = self.db.profile
	local s = self.currentSkin
	local titlefactor = p.showsectiontitle and 1 or 0
	local totalwidth, totalheight = 0, 0

	for k in pairs(areas) do areas[k] = nil end

	tinsert(areas, format('0:0:%d:3000', self.db.profile.columns * 39))

	--self:Debug("**** Laying out bag #%d ***", bagid)
	local bagempty = true

	for secid,sectionframe in ipairs(bagframe.sections) do
		local count = sectionframe.itemcount
		if sectionframe.used and (count > 0 or not p.hideemptysections) then
			bagempty = false
			local minwidth = self:GetSectionSize(sectionframe, 1)
			local minheight = select(2, self:GetSectionSize(sectionframe))

			--[[
			self:Debug("Section #%d, %d item(s), title width: %q, min width: %q, min height: %q",
				secid,	sectionframe.itemcount, sectionframe.title:GetWidth(), minwidth,
				minheight)
			--]]

			sectionframe.layout_waste = nil
			sectionframe.layout_columns = nil
			sectionframe.layout_area_index = nil

			for areaid,area in pairs(areas) do
				--self:Debug("  Area #%d: %s", areaid, area)

				local area_w,area_h = area:match('^%d+:%d+:(%d+):(%d+)$')
				area_w = tonumber(area_w)
				area_h = tonumber(area_h)

				if area_w >= minwidth and area_h >= minheight then
					local cols = floor(area_w / 39)
					local width, height = self:GetSectionSize(sectionframe, cols)
					--self:Debug("    %d columns", cols)

					if area_h >= height then
						local waste = (area_w * area_h) - (width * height)
						--self:Debug("    area waste: %d", waste)

						if not sectionframe.layout_waste or waste < sectionframe.layout_waste then
							sectionframe.layout_waste = waste
							sectionframe.layout_columns = cols
							sectionframe.layout_areaid = areaid
							--self:Debug("    -> best fit")
						else
							--self:Debug("    -> do not fit")
						end

					else
						--self:Debug("  -> too short")
					end
				else
					--self:Debug("  -> too small")
				end
			end
			local areaid = sectionframe.layout_areaid
			local area_x, area_y, area_w, area_h = tremove(areas, areaid):match('^(%d+):(%d+):(%d+):(%d+)$')
			area_x = tonumber(area_x)
			area_y = tonumber(area_y)
			area_w = tonumber(area_w)
			area_h = tonumber(area_h)
			local cols = sectionframe.layout_columns
			local width, height = self:GetSectionSize(sectionframe, cols)
			sectionframe:SetPoint('TOPLEFT', bagframe, 'TOPLEFT', s.BagLeftPadding + area_x, - (s.BagTopPadding + area_y) )
			sectionframe:SetWidth(width)
			sectionframe:SetHeight(height)

			totalwidth = max(totalwidth, area_x + width)
			totalheight = max(totalheight,area_y + height)
			--self:ReallyLayoutSection(sectionframe, cols)

			width = width + 10
			height = height + 10
			if area_w - width >= 39 then
				local area = format('%d:%d:%d:%d', area_x + width, area_y, area_w - width, height)
				--self:Debug("Created new area: %s", area)
				tinsert(areas, area)
			end
			if area_h - height >= 39 then
				local area = format('%d:%d:%d:%d', area_x, area_y + height, area_w, area_h - height)
				--self:Debug("Created new area: %s", area)
				tinsert(areas, area)
			end
		end
	end
	if (p.hideemptybags and bagempty) then
		bagframe.isempty = true
	end
	return s.BagLeftPadding + s.BagRightPadding + totalwidth, s.BagTopPadding + s.BagBottomPadding + totalheight
end

function Baggins:UpdateBagFrameSize(bagid)
	local bagframe = self.bagframes[bagid]
	if not bagframe then return end
	bagframe.dirty = true
	self:ScheduleRefresh()
end

function Baggins:ReallyUpdateBagFrameSize(bagid)
	local bagframe = self.bagframes[bagid]
	if not bagframe then return end
	local p = self.db.profile
	local s = self.currentSkin

	--self:Debug('Updating bag #%d', bagid)
	bagframe.isempty = false

	local hpadding = s.BagLeftPadding + s.BagRightPadding
	local width = s.BagLeftPadding + s.TitlePadding
	local height = s.BagTopPadding + s.BagBottomPadding

	if not p.shrinkbagtitle then
		width = width + bagframe.title:GetStringWidth()
 	end

	local layout = p.section_layout or "flow"
	if layout == 'optimize' then
		local swidth, sheight = Baggins:OptimizeSectionLayout(bagid)
		width = max(width, swidth)
		height = max(height, sheight)
	elseif layout == 'flow' then
		local x, y = self:FlowSections(bagid)
		width = max(x, width)
		height = max(y, height)
	else
		local lastsection
		local bagempty = true
		for id,section in ipairs(bagframe.sections) do
			if section.used and (not p.hideemptysections or section.itemcount > 0) then
				bagempty = false
				if not lastsection then
					section:SetPoint("TOPLEFT",bagframe,"TOPLEFT",s.BagLeftPadding,-s.BagTopPadding)
				else
					section:SetPoint("TOPLEFT",lastsection,"BOTTOMLEFT",0,-5)
					height = height + 5
				end
				lastsection = section
				--self:ReallyLayoutSection(section)
				width = max(width,section:GetWidth()+hpadding)
				height = height + section:GetHeight()
			end
		end
		if (p.hideemptybags and bagempty) then
			bagframe.isempty = true
		end
	end

	if p.moneybag == bagid then
		bagframe.isempty = false
		BagginsMoneyFrame:SetParent(bagframe)
		BagginsMoneyFrame:ClearAllPoints()
		BagginsMoneyFrame:SetPoint("BOTTOMLEFT",bagframe,"BOTTOMLEFT",8,6)
		BagginsMoneyFrame:Show()
		width = max(BagginsMoneyFrame:GetWidth() + 16, width)
		height = height + 30
	end

	if p.bankcontrolbag == bagid then
		bagframe.isempty = false
		BagginsBankControlFrame:SetParent(bagframe)
		BagginsBankControlFrame:ClearAllPoints()
		BagginsBankControlFrame:SetPoint("BOTTOMLEFT",bagframe,"BOTTOMLEFT",12,8)
		BagginsBankControlFrame:Show()
		width = max(BagginsBankControlFrame:GetWidth() + 16, width)
		height = height + BagginsBankControlFrame:GetHeight()
	end

	if not p.shrinkwidth then
		width = max(p.columns*39 + hpadding, width)
	end

	if bagframe:GetWidth() ~= width or bagframe:GetHeight() ~= height then
		bagframe:SetWidth(width)
		bagframe:SetHeight(height)
		self.dirtyBagLayout = true
	end

	bagframe.dirty = nil
end

local sectionSortTab = {}
local function sectionComp(a, b)
    local bags = Baggins.db.profile.bags

    local bagA, secA = floor(a/1000), mod(a,1000)
    local bagB, secB = floor(b/1000), mod(b,1000)

    local PriA = (bags[bagA].priority or 1) + (bags[bagA].sections[secA].priority or 1)
    local PriB = (bags[bagB].priority or 1) + (bags[bagB].sections[secB].priority or 1)

    if PriA == PriB then
        return a < b
    else
        return PriA > PriB
    end
end

function Baggins:ResortSections()
    self.sectionOrderDirty = true
end

function Baggins:IsSlotMine(mybagid, mysecid, slot, wasMine)
	local p = self.db.profile
	if not p.hideduplicates or p.hideduplicates == "disabled" then
		return true
	end

	local bag = p.bags[mybagid]
	if not bag then return false end
	local section = bag.sections[mysecid]
	if not section then return false end

    if section.allowdupes then
        return true
    end

	if type(slot) == 'table' then
		for k, v in pairs(slot) do
			if v then
				slot = k
				break
			end
		end
	end

	--if self.sectionOrderDirty then
        local i = 1

        local numbags = #p.bags

    	if p.hideduplicates == true or p.hideduplicates == "global" then
            for bagid = 1, numbags do
                local numsections = #p.bags[bagid].sections
                local bag = p.bags[bagid]
                if bag then
                    for secid = 1, numsections do
                        local section = bag.sections[secid]
                        if not section.allowdupes then
                            sectionSortTab[i] = bagid*1000 + secid
                            i = i + 1
                        end
                    end
                end
            end
    	elseif p.hideduplicates == "bag" then
    	    local numsections = #p.bags[mybagid].sections
    	    local bag = p.bags[mybagid]
    	    if bag then
                for secid = 1, numsections do
                    local section = bag.sections[secid]
                    if not section.allowdupes then
                        sectionSortTab[i] = mybagid*1000 + secid
                        i = i + 1
                    end
                end
            end
    	end

        while sectionSortTab[i] do
            sectionSortTab[i] = nil
            i = i + 1
        end
        self.sectionOrderDirty = nil
    --end

    tsort(sectionSortTab, sectionComp)

	for i, v in ipairs(sectionSortTab) do
	    local bagid, secid = floor(v/1000), mod(v,1000)
	    local section = self.bagframes[bagid].sections[secid]
		if section and ((not wasMine and section.slots[slot]) or (wasMine and section.slots[slot] == false)) then
			if mybagid == bagid and mysecid == secid then
				return true
			else
				return false
			end
		end
	end
end

function Baggins:LayoutSection(sectionframe, title, cols)
	sectionframe.dirty = true
	sectionframe.set_title = title
	sectionframe.set_columns = cols
	self:ScheduleRefresh()
end

function Baggins:ReallyLayoutSection(sectionframe, cols)
	local bagid, secid = sectionframe.bagid, sectionframe.secid
	local p = self.db.profile
	local bagconf = p.bags[sectionframe.bagid]
	if not bagconf then return end
	local sectionconf = bagconf.sections[sectionframe.secid]
	if not sectionconf then return end
	local totalwidth, totalheight = 1,1
	local s = self.currentSkin
	cols = cols or sectionframe.set_columns or p.columns

	if p.showsectiontitle then
		totalheight = totalheight + s.SectionTitleHeight
	end
	sectionframe.itemcount = 0
	if sectionconf.hidden then
		for itemnum, itemframe in ipairs(sectionframe.items) do
			itemframe:Hide()
		end
		for k, v in ipairs(sectionframe.layout) do
			sectionframe.itemcount = sectionframe.itemcount + 1
		end
	else
		local itemnum = 1
		local itemframeno = 1
		local BaseTop
		if p.showsectiontitle then
			BaseTop = (sectionframe.title:GetHeight() + 1)
		else
			BaseTop = 0
		end
		for k, v in pairs(sectionframe.items) do
			v:Hide()
		end
		for k, v in ipairs(sectionframe.layout) do
			if (type(v) == "string" and self:IsSlotMine(bagid, secid, v, true)) or (type(v) == "table" and self:IsSlotMine(bagid, secid, v.slots)) then
				if type(v) == "table" then
					sectionframe.items[itemframeno] = sectionframe.items[itemframeno] or self:CreateItemButton(sectionframe,itemframeno)
					local itemframe = sectionframe.items[itemframeno]
					itemframeno = itemframeno + 1
					itemframe:SetPoint("TOPLEFT",sectionframe,"TOPLEFT",((itemnum-1)%cols)*39,-(BaseTop+(floor((itemnum-1)/cols)*39)))
					local bag, slot, itemid = GetSlotInfo(next(v.slots))
					if v.slotcount > 1 or ((p.compressall or p.compressempty) and not itemid) then
						itemframe.countoverride = true
					else
						itemframe.countoverride = nil
					end
					if not itemframe.slots then
						itemframe.slots = {}
					else
						wipe(itemframe.slots)
					end
					for slot in pairs(v.slots) do
						tinsert(itemframe.slots, slot)
					end
					self:UpdateItemButton(sectionframe:GetParent(),itemframe,tonumber(bag),tonumber(slot))

					itemframe:Show()
				end
				sectionframe.itemcount = sectionframe.itemcount + 1
				if itemnum == 1 then
					totalwidth = 39
					totalheight = totalheight+39
				elseif itemnum%cols == 1 then
					totalheight = totalheight+39
				else
					if itemnum <= cols then
						totalwidth = totalwidth+39
					end
				end
				itemnum = itemnum + 1
			end
		end
		-- cleaning up unused itembuttons
		for i = itemframeno,#sectionframe.items do
			local unusedframe = table.remove(sectionframe.items, itemframeno)
			self:ReleaseItemButton(unusedframe)
		end
	end

	if p.showsectiontitle then
		local title = sectionframe.set_title
		if sectionconf.hidden then
			title = ("+ %s (%d)"):format(title, sectionframe.itemcount)
		else
			title = ("- %s"):format(title)
		end
		sectionframe.title:SetText(title)
		totalwidth = max(totalwidth,sectionframe.title:GetWidth())
	else
		sectionframe.title:SetText("")
	end

	if sectionframe.itemcount == 0 and p.hideemptysections then
		totalheight = 1
		sectionframe:Hide()
	end

	if sectionframe:GetWidth() ~= totalwidth or sectionframe:GetHeight() ~= totalheight then
		sectionframe:SetWidth(totalwidth)
		sectionframe:SetHeight(totalheight)
		self.bagframes[sectionframe.bagid].dirty = true
	end

	sectionframe.dirty = nil
end

---------------------
-- Frame Creation  --
---------------------
function Baggins:CreateBagPlacementFrame()
local f = CreateFrame("frame","BagginsBagPlacement",UIParent)

	f:SetWidth(130)
	f:SetHeight(300)
	f:SetPoint("CENTER",UIParent,"CENTER",0,0)
	f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	                                            edgeFile = false,
	                                            edgeSize = 0,
	                                            insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	f:SetBackdropColor(0.2,0.5,1,0.5)

	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetResizable(true)
	f:SetClampedToScreen(true)
	f:SetScript("OnMouseDown",function(this, button) if button == "RightButton" then this:Hide() else this:StartMoving() end end)
	f:SetScript("OnMouseUp", function(this) this:StopMovingOrSizing() self:SaveBagPlacement() end)

	f.t = CreateFrame("frame","BagginsBagPlacementTopMover",f)
	f.t:SetPoint("TOPLEFT",f,"TOPLEFT",0,0)
	f.t:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,0)
	f.t:SetHeight(20)
	f.t:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	                                            edgeFile = false,
	                                            edgeSize = 0,
	                                            insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	f.t:SetBackdropColor(0,0,1,1)
	f.t:EnableMouse(true)
	f.t:SetScript("OnMouseDown",function(this) this:GetParent():StartSizing("TOP") end)
	f.t:SetScript("OnMouseUp", function(this) this:GetParent():StopMovingOrSizing() self:SaveBagPlacement() end)

	f.b = CreateFrame("frame","BagginsBagPlacementTopMover",f)
	f.b:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0)
	f.b:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,0)
	f.b:SetHeight(20)
	f.b:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	                                            edgeFile = false,
	                                            edgeSize = 0,
	                                            insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	f.b:SetBackdropColor(0,0,1,1)
	f.b:EnableMouse(true)
	f.b:SetScript("OnMouseDown",function(this) this:GetParent():StartSizing("BOTTOM") end)
	f.b:SetScript("OnMouseUp", function(this) this:GetParent():StopMovingOrSizing() self:SaveBagPlacement() end)

	f.midtext = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	f.midtext:SetText(L["Drag to Move\nRight-Click to Close"])
	f.midtext:SetPoint("LEFT",f,"LEFT",0,0)
	f.midtext:SetPoint("RIGHT",f,"RIGHT",0,0)
	f.midtext:SetHeight(45)
	f.midtext:SetVertexColor(1, 1, 1)

	f.toptext = f.t:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	f.toptext:SetText(L["Drag to Size"])
	f.toptext:SetPoint("TOPLEFT",f,"TOPLEFT",0,-2)
	f.toptext:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,-2)
	f.toptext:SetHeight(15)
	f.toptext:SetVertexColor(1, 1, 1)

	f.bottext = f.b:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	f.bottext:SetText(L["Drag to Size"])
	f.bottext:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,2)
	f.bottext:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,2)
	f.bottext:SetHeight(15)
	f.bottext:SetVertexColor(1, 1, 1)
end

local function BagginsItemButton_OnEnter(button)
	if ( not button ) then
		button = this
	end

	local x
	x = button:GetRight()
	if ( x >= ( GetScreenWidth() / 2 ) ) then
		GameTooltip:SetOwner(button, "ANCHOR_LEFT")
	else
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	end

	-- Keyring specific code
	button:UpdateTooltip()

end

local KEYRING_CONTAINER = KEYRING_CONTAINER

local function showBattlePetTooltip(link)
	local speciesID, level, quality, maxHealth, power, speed = getBattlePetInfoFromLink(link)
	BattlePetToolTip_Show(speciesID, level, quality, maxHealth, power, speed)
end

local function BagginsItemButton_UpdateTooltip(button)
	if ( button:GetParent():GetID() == KEYRING_CONTAINER ) then
		GameTooltip:SetInventoryItem("player", KeyRingButtonIDToInvSlotID(button:GetID(),button.isBag))
		CursorUpdate(button)
		return
	end
	local hasItem, hasCooldown, repairCost
	if button:GetParent():GetID() == -1 then
		if ( not GameTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(button:GetID(),button.isBag)) ) then
			if ( button.isBag ) then
				GameTooltip:SetText(button.tooltipText);
			end
		end
		CursorUpdate(button);
		return
	end
	if button:GetParent():GetID() == REAGENTBANK_CONTAINER then
		if ( not GameTooltip:SetInventoryItem("player", ReagentBankButtonIDToInvSlotID(button:GetID(),button.isBag)) ) then
			if ( button.isBag ) then
				GameTooltip:SetText(button.tooltipText);
			end
		end
		CursorUpdate(button);
		return
	end


	local showSell = nil;
	local itemlink = GetContainerItemLink(button:GetParent():GetID(), button:GetID())
	if itemlink and itemlink:match("battlepet:") then
		showBattlePetTooltip(itemlink)
		return
	end
	local hasCooldown, repairCost = GameTooltip:SetBagItem(button:GetParent():GetID(), button:GetID());
	if ( InRepairMode() and (repairCost and repairCost > 0) ) then
		GameTooltip:AddLine(REPAIR_COST, "", 1, 1, 1);
		SetTooltipMoney(GameTooltip, repairCost);
		GameTooltip:Show();
	elseif ( MerchantFrame:IsShown() and MerchantFrame.selectedTab == 1 and not button.locked ) then
		showSell = 1;
	end

	if ( IsModifiedClick("DRESSUP") and button.hasItem ) then
		ShowInspectCursor();
	elseif ( showSell ) then
		ShowContainerSellCursor(button:GetParent():GetID(),button:GetID());
	elseif ( button.readable ) then
		ShowInspectCursor();
	else
		ResetCursor();
	end
end

do
	local menu = {}

	local function includeItemInCategory(info, itemID)
		Baggins:IncludeItemInCategory(info.value, itemID)
	end

	local function excludeItemFromCategory(info, itemID)
		Baggins:ExcludeItemFromCategory(info.value, itemID)
	end

	local useButton = CreateFrame("Button", "BagginsUseItemButton", UIParent, "SecureActionButtonTemplate")
	useButton:SetAttribute("type", "item")
	useButton:SetAttribute("item", nil)
	useButton:Hide()

	local function reallyHideUseButton()
		useButton:ClearAllPoints()
		useButton:SetAttribute("item", nil)
		useButton:UnregisterAllEvents()
		useButton:Hide()
		Baggins:Unhook(_G["DropDownList1Button" .. useButton.owner], "OnHide")
		useButton.owner = nil
	end

	useButton:SetScript("OnEvent", function(self, event)
		UIDropDownMenu_Refresh(Baggins_ItemMenuFrame)
		if event == "PLAYER_REGEN_DISABLED" then
			self:Hide()
		elseif event == "PLAYER_REGEN_ENABLED" then
			if self.hideaftercombat then
				reallyHideUseButton()
				return
			end
			self:Show()
		end
	end)

	useButton:SetScript("OnEnter", function(self)
		local button = _G["DropDownList1Button" .. self.owner]
		button:GetScript("OnEnter")(button)
	end)

	useButton:SetScript("OnLeave", function(self)
		local button = _G["DropDownList1Button" .. self.owner]
		button:GetScript("OnLeave")(button)
	end)

	useButton:HookScript("OnClick", function(self)
		local button = _G["DropDownList1Button" .. self.owner]
		button:GetScript("OnClick")(button)
	end)

	local function hideUseButton()
		if InCombatLockdown() then
			useButton.hideaftercombat = true
			return
		end
		reallyHideUseButton()
	end

	local function showUseButton(bag, slot)
		useButton:SetAttribute("item", ("%d %d"):format(bag, slot))
		useButton:ClearAllPoints()
		local button = _G["DropDownList1Button" .. useButton.owner]
		useButton:SetAllPoints(button)
		useButton:SetFrameStrata(button:GetFrameStrata())
		useButton:SetFrameLevel(button:GetFrameLevel()+1)
		useButton:SetToplevel(true)
		useButton:RegisterEvent("PLAYER_REGEN_ENABLED")
		useButton:RegisterEvent("PLAYER_REGEN_DISABLED")
		useButton:Show()
		Baggins:SecureHookScript(button, "OnHide", hideUseButton)
	end

	local addCategoryIndex
	local excludeCategoryIndex
	-- some code to make the UIDropDownMenu scrollable
	local offset = 0
	local switchpage
	local function pageup(self)
		offset = max(offset - 1,0)
		switchpage(self)
	end
	local function pagedown(self)
		offset = min(offset + 1, #catsorttable)
		switchpage(self)
	end
	function switchpage(self)
		-- check if it's one of the category-menus
		if self.parentID ~= addCategoryIndex and self.parentID ~= excludeCategoryIndex then
			offset = 0
			return
		end
		if offset < 0 then
			offset = 0
		end
		local maxoffset = #catsorttable - 20
		if offset > maxoffset then
			offset = maxoffset
		end
		for x = 1,20 do
			local y = x + offset
			local newtext
			local button = _G[self:GetName() .. "Button" .. x]
			if x == 1 and offset > 0 then
				newtext = "..."
				button.func = pageup
				button.keepShownOnClick = true
			elseif x == 20 and y < #catsorttable then
				newtext = "..."
				button.func = pagedown
				button.keepShownOnClick = true
			else
				newtext = catsorttable[y] or ""
				button.func = menu[self.parentID].menuList[2].func
				button.keepShownOnClick = false
			end
			button:SetText(newtext)
			button.value = newtext
		end
		UIDropDownMenu_Refresh(Baggins_ItemMenuFrame)
	end

	function makeMenu(bag, slot)
		wipe(menu)
		if not LBU:IsBank(bag, true) then
			local use = {
				text = L["Use"],
				tooltipTitle = L["Use"],
				tooltipText = L["Use/equip the item rather than bank/sell it"],
				-- tooltipOnButton = true,
				notCheckable = true,
				disabled = InCombatLockdown(),
				func = function()
					if InCombatLockdown() then
						print("Baggins: Could not use item because you are in combat.")
					end
				end,
			}
			tinsert(menu, use)
			useButton.owner = #menu
		end

		local addToCatMenu = {
			text = L["Add To Category"],
			hasArrow = true,
			menuList = {},
			notCheckable = true,
		}
		tinsert(menu, addToCatMenu)
		addCategoryIndex = #menu

		local excludeFromCatMenu = {
			text = L["Exclude From Category"],
			hasArrow = true,
			notCheckable = true,
			menuList = {},
		}
		tinsert(menu, excludeFromCatMenu)
		excludeCategoryIndex = #menu

		local _, itemCount, _, itemQuality, _, _, itemLink, _, _, itemID = GetContainerItemInfo(bag, slot)
		local itemName, _, _, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc = GetItemInfo(itemLink)
		if not itemName then
			itemName, _, _, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc = GetItemInfo(itemID)
			itemLink = itemID
		end

		local itemInfo = {
			text = L["Item Info"],
			hasArrow = true,
			notCheckable = true,
			menuList = {
				{ text = L["ItemID: "]..itemID, notCheckable = true },
			},
		}

		if itemType then
			tinsert(itemInfo.menuList, { text = L["Item Type: "]..itemType, notCheckable = true })
			tinsert(itemInfo.menuList, { text = L["Item Subtype: "]..itemSubType, notCheckable = true })
		end
		tinsert(itemInfo.menuList, { text = L["Quality: "].._G["ITEM_QUALITY" .. itemQuality .. "_DESC"], notCheckable = true })
		if itemLevel and itemLevel > 1 then
			local effectiveItemLevel = GetDetailedItemLevelInfo(itemLink)
			if itemLevel ~= effectiveItemLevel then
				itemLevel = ("%d (%d)"):format(itemLevel, effectiveItemLevel)
			end
			tinsert(itemInfo.menuList, { text = L["Item Level: "]..itemLevel, notCheckable = true })
		end
		if itemMinLevel and itemMinLevel > 1 then
			tinsert(itemInfo.menuList, { text = L["Required Level: "]..itemMinLevel, notCheckable = true })
		end
		if itemStackCount and itemStackCount > 1 then
			tinsert(itemInfo.menuList, { text = L["Stack Size: "]..itemStackCount, notCheckable = true })
		end
		if itemEquipLoc and itemEquipLoc ~= "" then
			tinsert(itemInfo.menuList, { text = L["Equip Location: "]..(_G[itemEquipLoc] or itemEquipLoc), notCheckable = true })
		end
		-- tinsert(itemInfo.menuList, { text = ("Bag Location: %d %d"):format(bag, slot), notCheckable = true })

		tinsert(menu, itemInfo)
		local categories = Baggins.db.profile.categories
		while #catsorttable > 0 do
			tremove(catsorttable,#catsorttable)
		end
		for catid in pairs(categories) do
			tinsert(catsorttable,catid)
		end
		tsort(catsorttable)
		for i, name in ipairs(catsorttable) do
			if i == 20 and #catsorttable > 20 then
				addToCatMenu.menuList[i] = {
					text= " ...",
					notCheckable = true,
					func = pagedown,
					keepShownOnClick = true,
				}
				excludeFromCatMenu.menuList[i] = {
					text = "...",
					notCheckable = true,
					func = pagedown,
					keepShownOnClick = true,
				}
				break
			end
			addToCatMenu.menuList[i] = {
				text = name,
				notCheckable = true,
				func = includeItemInCategory,
				arg1 = itemID,
			}
			excludeFromCatMenu.menuList[i] = {
				text = name,
				notCheckable = true,
				func = excludeItemFromCategory,
				arg1 = itemID,
			}
		end
		DropDownList2:EnableMouseWheel(true)
		DropDownList2:SetScript("OnMouseWheel", function(self, delta)
			offset = offset - delta
			switchpage(self)
		end)
		return menu
	end

	local itemDropdownFrame = CreateFrame("Frame", "Baggins_ItemMenuFrame", UIParent, "UIDropDownMenuTemplate")

	local function BagginsItemButton_GetTargetBankTab(bag, slot)
		-- There's likely a better way then looking at the tooltip
		-- It seems all crafting reagents now have a line in the tooltip called "Crafting Reagent" in enUS.

		-- setup gratuity based on bag and slot
		if LBU:IsReagentBank(bag) then
			gratuity:SetInventoryItem("player", ReagentBankButtonIDToInvSlotID(slot))
		elseif LBU:IsBank(bag) then
			gratuity:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
		else
			gratuity:SetBagItem(bag, slot)
		end

		-- count remaining slots and switch the tab based on the item type
		local count = LBU:CountSlots("REAGENTBANK")
		if gratuity:Find(L["Crafting Reagent"]) and count ~= nil and count > 0 then
			return REAGENT_BANK_TAB
		end

		return BANK_TAB
	end

	local function BagginsItemButton_OnClick(button)
		local bag = button:GetParent():GetID()
		local slot = button:GetID()
		UseContainerItem(bag, slot, nil, true)

		button:SetScript("OnClick",button.origOnClick)
		button.origOnClick = nil
	end

	local function BagginsItemButton_AutoReagent(button, mouseButton, ...)
		if Baggins.bankIsOpen and Baggins.db.profile.autoreagent
				and not IsModifiedClick() and mouseButton == "RightButton" then
			local bag = button:GetParent():GetID()
			local slot = button:GetID()

			local target = BagginsItemButton_GetTargetBankTab(bag, slot)

			if target == REAGENT_BANK_TAB then
				BankFrame.selectedTab = 2
				button.origOnClick = button:GetScript("OnClick")
				button:SetScript("OnClick",BagginsItemButton_OnClick)
			else
				BankFrame.selectedTab = 1
			end
		end
	end

	local function BagginsItemButton_PreClick(button)
		BagginsItemButton_AutoReagent(button, GetMouseButtonClicked())
		if GetMouseButtonClicked() == "RightButton" and button.tainted then
			print("|cff00cc00Baggins: |cffffff00Right-clicking this button will not work until you leave combat|r")
		end
		for i, v in ipairs(button.slots) do
			local bag, slot = GetSlotInfo(v)
			local locked =select(3, GetContainerItemInfo(bag, slot))
			if not locked then
				button:SetID(slot)
				local bagframe = button:GetParent():GetParent()
				if not bagframe.bagparents[bag] then
					bagframe.bagparents[bag] = CreateFrame("Frame",nil,bagframe)
					bagframe.bagparents[bag]:SetID(bag)
				end
				button:SetParent(bagframe.bagparents[bag])
				break
			end
		end
		if (IsControlKeyDown() or IsAltKeyDown()) and GetMouseButtonClicked() == "RightButton" then
			local bag = button:GetParent():GetID();
			local slot = button:GetID();
			local itemid = GetContainerItemID(bag, slot)
			if itemid then
				if DropDownList1:IsShown() then
					DropDownList1:Hide()
					return
				end
				makeMenu(bag, slot)
				EasyMenu(menu, itemDropdownFrame, "cursor", 0, 0, "MENU")
				-- make sure we restore the original scroll-wheel behavior for the DropdownList2-Frame
				-- when the item-dropdown is closed
				Baggins:SecureHookScript(DropDownList1, "OnHide", function(self)
					DropDownList2:EnableMouseWheel(false)
					DropDownList2:SetScript("OnMouseWheel", nil)
					Baggins:Unhook(DropDownList1, "OnHide")
				end)

				if not LBU:IsBank(bag, true) and not InCombatLockdown() then
					showUseButton(bag, slot)
				else
					hideUseButton()
				end
			end
		end
	end

	function Baggins:CreateItemButton(sectionframe,item)
		local frame = Baggins:GetItemButton()
		frame.glow = frame.glow or frame:CreateTexture(nil,"OVERLAY")
		frame.glow:SetTexture("Interface\\Addons\\Baggins\\Textures\\Glow")
		frame.glow:SetAlpha(0.3)
		frame.glow:SetAllPoints(frame)

		frame.newtext = frame.newtext or frame:CreateFontString(frame:GetName().."NewText","OVERLAY","GameFontNormal")
		frame.newtext:SetPoint("TOP",frame,"TOP",0,0)
		frame.newtext:SetHeight(13)
		frame.newtext:SetTextColor(0,1,0,1)
		frame.newtext:SetShadowColor(0,0,0,1)
		frame.newtext:SetShadowOffset(1,-1)
		frame.newtext:SetText("*New*")
		frame.newtext:Hide()

		frame:ClearAllPoints()
		local cooldown = _G[frame:GetName().."Cooldown"]
		cooldown:SetAllPoints(frame)
		cooldown:SetFrameLevel(10)
		frame:SetFrameStrata("HIGH")
		frame:SetScript("OnEnter",BagginsItemButton_OnEnter)
		frame:SetScript("PreClick",BagginsItemButton_PreClick)
		frame.UpdateTooltip = BagginsItemButton_UpdateTooltip
		if frame.BattlepayItemTexture then
			-- New blue glow introduced in 6.0. Purposely keeping this conditional - it smells like something that could change name or get removed in a future patch.
			frame.BattlepayItemTexture:Hide()
		end
		--frame:SetScript("OnUpdate",BagginsItemButton_OnUpdate)
		if self.currentSkin then
			self.currentSkin:SkinItem(frame)
		end
		frame:Show()
		return frame
	end
end

do
	local dropdown = CreateFrame("Frame", "BagginsCategoryAddDropdown")
	local info = { }

	local function Close()
		CloseDropDownMenus()
	end

	local function Click(dropdown, arg1, arg2)
		Baggins:IncludeItemInCategory(arg1, arg2)
		Baggins:UpdateBags()
	end

	local dd_categories, dd_id
	dropdown.initialize = function(self, level)

		-- Title
		wipe(info)
		info.text = L["Add To Category"]
		info.isTitle = true
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, 1)

		-- Categories
		for k, v in ipairs(dd_categories) do
			wipe(info)
			info.text = v
			info.arg1 = v
			info.arg2 = dd_id
			info.func = Click
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, 1)
		end

		-- Close
		wipe(info)
		info.text = "|cff777777"..L["Close"]
		info.func = Close
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, 1)
	end

	local function RecieveDrag(self)
		local section = self:GetParent()
		local categories = Baggins.db.profile.bags[section.bagid].sections[section.secid].cats
		local ctype, cid, clink = GetCursorInfo()
		if ctype ~= 'item' then return nil end
		if #categories == 1 then
			Click(nil, categories[1], cid)
		else
			dd_categories = categories
			dd_id = cid
			ToggleDropDownMenu(1, nil, BagginsCategoryAddDropdown, "UIParent", GetCursorPosition())
		end
		ClearCursor()
	end

	function Baggins:CreateSectionFrame(bagframe,secid)
		local frame = CreateFrame("Frame",bagframe:GetName().."Section"..secid,bagframe)

		frame.title = frame:CreateFontString(bagframe:GetName().."SectionTitle","OVERLAY","GameFontNormalSmall")
		frame.titleframe = CreateFrame("button",bagframe:GetName().."SectionTitleFrame",frame)
		frame.titleframe:SetAllPoints(frame.title)
		frame.titleframe:SetScript("OnClick", function(this) self:ToggleSection(this:GetParent()) end)
		frame.titleframe:SetScript("OnReceiveDrag", RecieveDrag)
		--[[
		frame.titleframe:SetScript("OnEnter", function(this) self:ShowSectionTooltip(this:GetParent()) end)
		frame.titleframe:SetScript("OnLeave", function(this) self:HideSectionTooltip(this:GetParent()) end)
		--]]
		frame:SetFrameStrata("HIGH")
		frame:Show()
		frame.items = {}
		frame.slots = {}
		frame.layout = {}
		frame.secid = secid
		frame.bagid = bagframe.bagid
		frame.itemcount = 0
		if self.currentSkin then
			self.currentSkin:SkinSection(frame)
		end

		return frame
	end
end

function Baggins:ToggleSection(sectionframe)
	local p = self.db.profile

	local bag = p.bags[sectionframe.bagid]
	if bag then
		local section = bag.sections[sectionframe.secid]
		if section then
			section.hidden = not section.hidden
			self:LayoutSection(sectionframe, section.name, p.columns)
			self:UpdateBagFrameSize(sectionframe.bagid)
		end
	end
end

function Baggins:CreateAllBags()
	for k, v in ipairs(self.db.profile.bags) do
		if not self.bagframes[k] then
			self:CreateBagFrame(k)
		end
	end
end

function Baggins:CreateBagFrame(bagid)
	if not bagid then return end
	local bagname = "BagginsBag"..bagid

	local frame = CreateFrame("Frame",bagname,UIParent)
	self.bagframes[bagid] = frame
	frame.bagid = bagid
	frame:SetToplevel(true)
	frame:SetWidth(100)
	frame:SetHeight(100)
	frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetScript("OnMouseDown",function(this,arg1)
		if arg1=="LeftButton" and not self:AreBagsLocked() then
			this:StartMoving()
		end
	end)
	frame:SetScript("OnMouseUp",function(this,arg1)
		if arg1=="LeftButton" then
			this:StopMovingOrSizing() self:SaveBagPosition(this.bagid)
		elseif arg1=="RightButton" then
			Baggins:DoBagMenu(frame);
		end
	end)
	frame:SetScript("OnShow",function() self:FireSignal("Baggins_BagOpened", frame); end)


	frame.closebutton = CreateFrame("Button",bagname.."CloseButton",frame,"UIPanelCloseButton")
	frame.closebutton:SetScript("OnClick", function(this)
		if IsShiftKeyDown() then
			self:CloseAllBags()
		else
  		    self:CloseBag(this:GetParent().bagid)
		end
	end)

	frame.compressbutton = CreateFrame("Button",bagname.."CompressButton",frame,nil);
	frame.compressbutton:Hide();
	frame.compressbutton:SetScript("OnClick", function()
		self:CompressBags(Baggins.db.profile.bags[frame.bagid].isBank);
	end)
	frame.compressbutton:SetScript("OnEnter", function(this)
		GameTooltip:SetOwner(this, 'ANCHOR_DEFAULT')
		GameTooltip:SetText(L["Compress bag contents"]);
		GameTooltip:Show();
	end)
	frame.compressbutton:SetScript("OnLeave", function(this)
		if(GameTooltip:IsOwned(this)) then
			GameTooltip:Hide();
		end
	end)
	frame.compressbutton:SetHeight(32);
	frame.compressbutton:SetWidth(32);
	frame.compressbutton:SetNormalTexture("Interface\\AddOns\\Baggins\\Textures\\compressbutton.tga");
	self:RegisterSignal("Baggins_CanCompress", function(self, bank, compressable)
			if Baggins.db.profile.bags[self.bagid] then
				if (not Baggins.db.profile.bags[self.bagid].isBank) == (not bank) then
					(compressable and self.compressbutton.Show or self.compressbutton.Hide)(self.compressbutton);
				end
			end
		end,
		frame
	);

	frame.title = frame:CreateFontString(bagname.."Title","OVERLAY","GameFontNormalLarge")
	frame.title:SetText("Baggins")
	frame:SetFrameStrata("HIGH")
	frame:SetClampedToScreen(true)
	frame:SetScale(self.db.profile.scale)
	frame.sections = {}
	frame.bagparents = {}

	if self.currentSkin then
		self.currentSkin:SkinBag(frame)
	end

	self:UpdateBagFrameSize(bagid)
	frame:Hide()
end

local function getsecond(_, value)
	return value
end

local function MoneyFrame_OnClick(button)
	local money = GetMoney()
	local multiplier
	if money < 100 then
		multiplier = 1
	elseif money < 10000 then
		multiplier = 100
	else
		multiplier = 10000
	end
	button.moneyType = "PLAYER"
	CoinPickupFrame:ClearAllPoints()
	OpenCoinPickupFrame(multiplier, money, button)
	button.hasPickup = 1

	CoinPickupFrame:ClearAllPoints()
	local frame = button

	if frame:GetCenter() < GetScreenWidth()/2 then
		if getsecond(frame:GetCenter()) < GetScreenHeight()/2 then
			CoinPickupFrame:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
		else
			CoinPickupFrame:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")
		end
	else
		if getsecond(frame:GetCenter()) < GetScreenHeight()/2 then
			CoinPickupFrame:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT")
		else
			CoinPickupFrame:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT")
		end
	end
end

function Baggins:CreateMoneyFrame()
	local frame = CreateFrame("Button","BagginsMoneyFrame",UIParent)
	frame:SetPoint("CENTER")
	frame:SetWidth(100)
	frame:SetHeight(18)
	frame:EnableMouse(true)
	frame:SetScript("OnClick",MoneyFrame_OnClick)
	local goldIcon = frame:CreateTexture("BagginsGoldIcon", "ARTWORK")
	goldIcon:SetWidth(16)
	goldIcon:SetHeight(16)
	goldIcon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
	goldIcon:SetTexCoord(0, 0.25, 0, 1)

	local silverIcon = frame:CreateTexture("BagginsSilverIcon", "ARTWORK")
	silverIcon:SetWidth(16)
	silverIcon:SetHeight(16)
	silverIcon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
	silverIcon:SetTexCoord(0.25, 0.5, 0, 1)

	local copperIcon = frame:CreateTexture("BagginsCopperIcon", "ARTWORK")
	copperIcon:SetWidth(16)
	copperIcon:SetHeight(16)
	copperIcon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
	copperIcon:SetTexCoord(0.5, 0.75, 0, 1)

	local goldText = frame:CreateFontString("BagginsGoldText", "OVERLAY")
	goldText:SetJustifyH("RIGHT")
	goldText:SetPoint("RIGHT", goldIcon, "LEFT", 0, 1)
	goldText:SetFontObject(GameFontNormal)

	local silverText = frame:CreateFontString("BagginsSilverText", "OVERLAY")
	silverText:SetJustifyH("RIGHT")
	silverText:SetPoint("RIGHT", silverIcon, "LEFT", 0, 1)
	silverText:SetFontObject(GameFontNormal)

	local copperText = frame:CreateFontString("BagginsCopperText", "OVERLAY")
	copperText:SetJustifyH("RIGHT")
	copperText:SetPoint("RIGHT", copperIcon, "LEFT", 0, 1)
	copperText:SetFontObject(GameFontNormal)

	copperIcon:SetPoint("RIGHT", frame, "RIGHT")
	silverIcon:SetPoint("RIGHT", copperText, "LEFT")
	goldIcon:SetPoint("RIGHT", silverText, "LEFT")
	frame:Hide()
end

function Baggins:UpdateMoneyFrame()

	local copper = GetMoney()
	local gold = floor(copper / 10000)
	local silver = mod(floor(copper / 100), 100)
	copper = mod(copper, 100)

	local width = 0

	if gold == 0 then
		BagginsGoldIcon:Hide()
		BagginsGoldText:Hide()
	else
		BagginsGoldIcon:Show()
		BagginsGoldText:Show()
		BagginsGoldText:SetWidth(0)
		BagginsGoldText:SetText(gold)
		width = width + BagginsGoldIcon:GetWidth() + BagginsGoldText:GetWidth()
	end
	if gold == 0 and silver == 0 then
		BagginsSilverIcon:Hide()
		BagginsSilverText:Hide()
	else
		BagginsSilverIcon:Show()
		BagginsSilverText:Show()
		BagginsSilverText:SetWidth(0)
		BagginsSilverText:SetText(silver)
		width = width + BagginsSilverIcon:GetWidth() + BagginsSilverText:GetWidth()
	end
	BagginsCopperIcon:Show()
	BagginsCopperText:Show()
	BagginsCopperText:SetWidth(0)
	BagginsCopperText:SetText(copper)
	width = width + BagginsCopperIcon:GetWidth() + BagginsCopperText:GetWidth()
	BagginsMoneyFrame:SetWidth(width)
end

function Baggins:CreateBankControlFrame()
	local frame = CreateFrame("Frame", "BagginsBankControlFrame", UIParent)
	frame:SetPoint("CENTER")
	frame:SetWidth(160)
	--frame:SetHeight((18 + 2) * 3)

	-- A button to allow purchase of bank slots
	-- Not super useful as you still require the default UI to place the bags,
	-- but can help as a reminder if a slot is not purchased with the default UI hidden.
	-- OnClick handler's are just like Blizzards default UI (see BankFrame.xml)
	frame.slotbuy = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.slotbuy:SetScript("OnClick", function(this)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		StaticPopup_Show("CONFIRM_BUY_BANK_SLOT");
	end)
	frame.slotbuy:SetWidth(160)
	frame.slotbuy:SetHeight(18)
	frame.slotbuy:SetText(L["Buy Bank Bag Slot"])
	frame.slotbuy:Hide()

	-- A button to buy the reagent bank
	frame.rabuy = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.rabuy:SetScript("OnClick", function(this)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
	end)
	frame.rabuy:SetWidth(160)
	frame.rabuy:SetHeight(18)
	frame.rabuy:SetText(L["Buy Reagent Bank"])
	frame.rabuy:Hide()

	-- Finally, a button to allow blizzards "Deposit All Reagents" feature to work.
	-- this takes all your reagents and moves them into the reagent bank
	frame.radeposit = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.radeposit:SetScript("OnClick", function(this)
		DepositReagentBank()
	end)
	frame.radeposit:SetWidth(160)
	frame.radeposit:SetHeight(18)
	frame.radeposit:SetText(L["Deposit All Reagents"])
	frame.radeposit:Hide()

	frame:Hide()
end

function Baggins:UpdateBankControlFrame()
	local frame = BagginsBankControlFrame
	local numbuttons = 0
	local anchorframe = frame
	local anchorpoint = "TOPLEFT"
	local anchoryoffset = 0

	local _, full = GetNumBankSlots()
	if full then
		frame.slotbuy:Hide()
	else
		frame.slotbuy:SetPoint("TOPLEFT", anchorframe, anchorpoint, 0, anchoryoffset)
		frame.slotbuy:Show()

		numbuttons = numbuttons + 1
		anchorframe = frame.slotbuy
		anchorpoint = "BOTTOMLEFT"
		anchoryoffset = -2
	end

	if IsReagentBankUnlocked() then
		frame.radeposit:SetPoint("TOPLEFT", anchorframe, anchorpoint, 0, anchoryoffset)
		frame.radeposit:Show()
		frame.rabuy:Hide()
		numbuttons = numbuttons + 1
	else
		frame.rabuy:SetPoint("TOPLEFT", anchorframe, anchorpoint, 0, anchoryoffset)
		frame.rabuy:Show()
		frame.radeposit:Hide()
		numbuttons = numbuttons + 1
	end

	frame:SetHeight((18 + 2) * numbuttons)
end

function Baggins:SetBagTitle(bagid,title)
	if self.bagframes[bagid] then
		self.bagframes[bagid].title:SetText(title)
		self:UpdateBagFrameSize(bagid)
	end
end

function Baggins:AreBagsLocked()
	return self.db.profile.lock or self.db.profile.layout == "auto"
end

function Baggins:UpdateLayout()
	if self.db.profile.layout == "auto" then
		self:LayoutBagFrames()
	else
		self:LoadBagPositions()
	end
end

----------------------
-- ItemButton Funcs --
----------------------
function Baggins:UpdateItemButtons()
	for bagid, bag in ipairs(self.bagframes) do
		for sectionid, section in ipairs(bag.sections) do
			for buttonid, button in ipairs(section.items) do
				if button:IsVisible() then
					self:UpdateItemButton(bag,button,button:GetParent():GetID(),button:GetID())
				end
			end
		end
	end
end

function Baggins:UpdateItemButtonLocks()
	for bagid, bag in ipairs(self.bagframes) do
		for sectionid, section in ipairs(bag.sections) do
			for buttonid, button in ipairs(section.items) do
				if button:IsVisible() then
					local locked = select(3, GetContainerItemInfo(button:GetParent():GetID(), button:GetID()))
					SetItemButtonDesaturated(button, locked, 0.5, 0.5, 0.5)
				end
			end
		end
	end
end

function Baggins:UpdateItemButtonCooldowns()
	for bagid, bag in ipairs(self.bagframes) do
		for sectionid, section in ipairs(bag.sections) do
			for buttonid, button in ipairs(section.items) do
				if button:IsVisible() then
					local container = button:GetParent():GetID()
					local slot = button:GetID()
					local texture = GetContainerItemInfo(container, slot)
					if ( texture ) then
						self:UpdateItemButtonCooldown(container, button)
						button.hasItem = 1
					else
						_G[button:GetName().."Cooldown"]:Hide()
						button.hasItem = nil
					end
				end
			end
		end
	end
end

function Baggins:SetItemButtonCount(button, count, realcount)
	if not button then
		return
	end
	if not count then
		count = 0
	end
	local counttext = _G[button:GetName().."Count"]
	if button.countoverride then
		button.count = realcount
	else
		button.count = count
	end
	if type(count) == "string" then
		counttext:ClearAllPoints()
		counttext:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-5,2)
		counttext:SetText(count)
		counttext:Show()
	elseif ( count > 1 or (button.isBag and count > 0) ) then
		if ( count > 999 ) then
			count = (floor(count/100)/10).."k"
			counttext:ClearAllPoints()
			counttext:SetPoint("BOTTOM",button,"BOTTOM",0,2)
		else
			counttext:ClearAllPoints()
			counttext:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-5,2)
		end
		counttext:SetText(count)
		counttext:Show()
	else
		counttext:Hide()
	end
end

function Baggins:IsNew(itemid)
	local itemcounts = self.itemcounts
	itemid = tonumber(itemid) or tonumber(itemid:match("item:(%d+)"))
	if not itemid then
		return nil
	end
	local savedcount = itemcounts[itemid]
	if not savedcount then
		return 1	-- completely new
	else
		local count = GetItemCount(itemid)
		if count ~= savedcount.count
			and (self.db.profile.newitemduration > 0 and time() - savedcount.ts < self.db.profile.newitemduration) then
			return 2	-- more of an existing
		else
			return nil	-- not new
		end
	end
end

function Baggins:UpdateItemButton(bagframe,button,bag,slot)
	local p = self.db.profile
	if not C_NewItems.IsNewItem(bag, slot) then
		local newItemTexture = _G[button:GetName().."NewItemTexture"]
		if newItemTexture then
			newItemTexture:Hide()
		end
	end
	local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot)
	local link = GetContainerItemLink(bag, slot)
	local itemid
	if link then
		local qual = select(3, GetItemInfo(link))
		quality = qual or quality
		itemid = tonumber(link:match("item:(%d+)"))
	end
	button:SetID(slot)
	-- quest item glow introduced in 3.3 (with silly logic)
	local isQuestItem, questId, isActive = GetContainerItemQuestInfo(bag, slot)
	local questTexture = (questId and not isActive) and TEXTURE_ITEM_QUEST_BANG or (questId or isQuestItem) and TEXTURE_ITEM_QUEST_BORDER
	if p.highlightquestitems and texture and questTexture then
		button.glow:SetTexture(questTexture)
		button.glow:SetVertexColor(1,1,1)
		button.glow:SetAlpha(1)
		button.glow:Show()
	elseif p.qualitycolor and texture and quality >= p.qualitycolormin then
		local r, g, b = GetItemQualityColor(quality)
		button.glow:SetTexture("Interface\\Addons\\Baggins\\Textures\\Glow")
		button.glow:SetVertexColor(r,g,b)
		button.glow:SetAlpha(p.qualitycolorintensity)
		button.glow:Show()
	else
		button.glow:Hide()
	end
	local text = button.newtext
	if p.highlightnew and itemid and not LBU:IsBank(bag, true) then
		local isNew = self:IsNew(itemid)
		if isNew == 1 then
			text:SetText(L["*New*"])
			text:Show()
		elseif isNew == 2 then
			text:SetText("*+++*")
			text:Show()
		else
			text:Hide()
		end
	else
		text:Hide()
	end

	if not bagframe.bagparents[bag] then
		bagframe.bagparents[bag] = CreateFrame("Frame",nil,bagframe)
		bagframe.bagparents[bag]:SetID(bag)
	end
	button:SetParent(bagframe.bagparents[bag])
	if texture then
		SetItemButtonTexture(button, texture)
	elseif self.currentSkin and self.currentSkin.EmptySlotTexture then
		SetItemButtonTexture(button, self.currentSkin.EmptySlotTexture)
	else
		SetItemButtonTexture(button, nil)
	end
	if button.countoverride then
		local count
		if not itemid then
			local bagtype, itemFamily = Baggins:IsSpecialBag(bag)
			bagtype = bagtype or ""
			count = bagtype..LBU:CountSlots(LBU:IsBank(bag) and "BANK" or LBU:IsReagentBank(bag) and "REAGENTBANK" or "BAGS", itemFamily)
		else
			count = GetItemCount(itemid)
			if LBU:IsBank(bag, true) then
				count = GetItemCount(itemid,true) - count
			end
			if IsEquippedItem(itemid) then
				count = count - 1
			end
		end
		self:SetItemButtonCount(button, count, itemCount)
	else
		self:SetItemButtonCount(button, itemCount)
	end
	SetItemButtonDesaturated(button, locked, 0.5, 0.5, 0.5)

	if ( texture ) then
		self:UpdateItemButtonCooldown(bag, button)
		button.hasItem = 1
	else
		_G[button:GetName().."Cooldown"]:Hide()
		button.hasItem = nil
	end
	if button.tainted then
		button.icon:SetAlpha(0.3)
	else
		button.icon:SetAlpha(1)
	end

	button.readable = readable
	--local normalTexture = getglobal(name.."Item"..j.."NormalTexture")
	--if ( quality and quality ~= -1) then
	--	local color = getglobal("ITEM_QUALITY".. quality .."_COLOR")
	--	normalTexture:SetVertexColor(color.r, color.g, color.b)
	--else
	--	normalTexture:SetVertexColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
	--end
	--[[
	if button:GetParent():GetID() == -1 then
		if ( not GameTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(button:GetID(),button.isBag)) ) then
			if ( self.isBag ) then
				GameTooltip:SetText(self.tooltipText);
			end
		end
		CursorUpdate();
		return
	end

	local showSell = nil;
	local hasCooldown, repairCost = GameTooltip:SetBagItem(button:GetParent():GetID(), button:GetID());
	if ( InRepairMode() and (repairCost and repairCost > 0) ) then
		GameTooltip:AddLine(REPAIR_COST, "", 1, 1, 1);
		SetTooltipMoney(GameTooltip, repairCost);
		GameTooltip:Show();
	elseif ( MerchantFrame:IsShown() and MerchantFrame.selectedTab == 1 and not button.locked ) then
		showSell = 1;
	end

	if ( IsModifiedClick("DRESSUP") and button.hasItem ) then
		ShowInspectCursor();
	elseif ( showSell ) then
		ShowContainerSellCursor(button:GetParent():GetID(),button:GetID());
	elseif ( button.readable ) then
		ShowInspectCursor();
	else
		ResetCursor();
	end]]

	self:FireSignal("Baggins_ItemButtonUpdated", bagframe, button, bag, slot)
end

function Baggins:UpdateItemButtonCooldown(container, button)
	local cooldown = _G[button:GetName().."Cooldown"]
	local start, duration, enable = GetContainerItemCooldown(container, button:GetID())

	-- CooldownFrame_SetTimer has been renamed to CooldownFrame_Set in 7.0
	-- We'll check for the new name and use it if it's available. This lets the patch
	-- work with both 6.2 and 7.0.
	local setTimer = nil
	if (CooldownFrame_Set ~= nil) then
		setTimer = CooldownFrame_Set
	else
		setTimer = CooldownFrame_SetTimer
	end
	setTimer(cooldown, start, duration, enable)

	if ( duration > 0 and enable == 0 ) then
		SetItemButtonTextureVertexColor(button, 0.4, 0.4, 0.4)
	end
end


---------------------
-- Frame Placement --
---------------------
-- manual
function Baggins:SaveBagPosition(bagid)
	local frame = self.bagframes[bagid]
	if not frame then return end
	local s = frame:GetEffectiveScale()
	self.db.profile.bags[bagid].x = frame:GetLeft() * s
	self.db.profile.bags[bagid].y = frame:GetTop() * s
end

function Baggins:LoadBagPositions()
	for i = 1, #self.db.profile.bags do
		self:LoadBagPosition(i)
	end
end

function Baggins:LoadBagPosition(bagid)
	local bag = self.db.profile.bags[bagid]
	local frame = self.bagframes[bagid]
	if not frame then return end
	local s = frame:GetEffectiveScale()
	frame:ClearAllPoints()
	if bag.x and bag.y then
		frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT", bag.x / s, bag.y / s)
	else
		frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
	end
end
-- auto
function Baggins:SaveBagPlacement()
	local p = self.db.profile
	local frame = BagginsBagPlacement
	if not frame then return end
	local s = frame:GetEffectiveScale()
	p.rightoffset = (GetScreenWidth() - frame:GetRight() )
	p.bottomoffset = frame:GetBottom()
	p.topoffset = (GetScreenHeight() - frame:GetTop() )
	p.leftoffset = frame:GetLeft()
end

function Baggins:LoadBagPlacement()
	local p = self.db.profile
	local frame = BagginsBagPlacement
	if not frame then return end
	local s = frame:GetEffectiveScale()
	frame:ClearAllPoints()
	frame:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT", - p.rightoffset, p.bottomoffset)
	frame:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT", - p.rightoffset, - p.topoffset)
end

function Baggins:ShowPlacementFrame()
	if not BagginsBagPlacement then
		self:CreateBagPlacementFrame()
	end
	Baggins:LoadBagPlacement()
	BagginsBagPlacement:Show()
end

function Baggins:LayoutBagFrames()
	self.dirtyBagLayout = true
	self:ScheduleRefresh()
end

local CONTAINER_SPACING, VISIBLE_CONTAINER_SPACING =
      CONTAINER_SPACING, VISIBLE_CONTAINER_SPACING

function Baggins:ReallyLayoutBagFrames()
	local p = self.db.profile
	if p.layout ~= "auto" then return end
	local frame, xOffset, yOffset, screenHeight, freeScreenHeight, column, maxwidth
	local screenWidth = GetScreenWidth()

	screenHeight = GetScreenHeight()

	local initialcorner = p.layoutanchor
	local nextcorner, vdir, hdir
	local availableScreenHeight
	if initialcorner == "BOTTOMRIGHT" then
		hdir = -1
		vdir = 1
		nextcorner = "TOPRIGHT"
		xOffset = p.rightoffset
		yOffset = p.bottomoffset
		availableScreenHeight = screenHeight - yOffset - p.topoffset
	elseif initialcorner == "BOTTOMLEFT" then
		hdir = 1
		vdir = 1
		nextcorner = "TOPLEFT"
		xOffset = p.leftoffset
		yOffset = p.bottomoffset
		availableScreenHeight = screenHeight - yOffset - p.topoffset
	elseif initialcorner == "TOPRIGHT" then
		hdir = -1
		vdir = -1
		nextcorner = "BOTTOMRIGHT"
		xOffset = p.rightoffset
		yOffset = p.topoffset
		availableScreenHeight = screenHeight - yOffset - p.bottomoffset
	elseif initialcorner == "TOPLEFT" then
		hdir = 1
		vdir = -1
		nextcorner = "BOTTOMLEFT"
		xOffset = p.leftoffset
		yOffset = p.topoffset
		availableScreenHeight = screenHeight - yOffset - p.bottomoffset
	end
	-- Adjust the start anchor for bags depending on the multibars

	-- freeScreenHeight determines when to start a new column of bags
	freeScreenHeight = availableScreenHeight
	maxwidth = 1
	column = 0
	local index = 1
	local columnoffset = 0
	local prevframe
	for id, frame in ipairs(self.bagframes) do
		if (p.hideemptybags) then
			if (frame.isempty) then
				if (frame:IsVisible()) then
					frame.autohide = true
					frame:Hide()
				end
			else
				if (frame.autohide) then
					frame.autohide = false
					frame:Show()
				end
			end
		end
		if frame:IsVisible() then
			--self:ReallyUpdateBagFrameSize(id)
			frame:ClearAllPoints()
			local s = frame:GetEffectiveScale() / UIParent:GetEffectiveScale()
			if ( index == 1 ) then
				-- First bag
				frame:SetPoint(initialcorner, frame:GetParent(), initialcorner,  hdir * xOffset/s, vdir * yOffset/s )
				index = index + 1
				prevframe = frame
			elseif ( freeScreenHeight < frame:GetHeight()*s ) then
				-- Start a new column
				column = column + 1
				columnoffset = columnoffset + maxwidth
				maxwidth = 1
				freeScreenHeight = availableScreenHeight
				frame:SetPoint(initialcorner, frame:GetParent(), initialcorner, hdir * ( columnoffset + xOffset/s), vdir * yOffset/s )
				index = index + 1
				prevframe = frame
			else
				-- Anchor to the previous bag
				frame:SetPoint(initialcorner, prevframe, nextcorner, 0, vdir * CONTAINER_SPACING)
				index = index + 1
				prevframe = frame
			end
			maxwidth = max(maxwidth, frame:GetWidth())
			self:SaveBagPosition(id)
			freeScreenHeight = freeScreenHeight - frame:GetHeight()*s - VISIBLE_CONTAINER_SPACING
		end
	end
	self.dirtyBagLayout = nil
end

function Baggins:UpdateBagScale()
	for i, frame in ipairs(self.bagframes) do
		frame:SetScale(self.db.profile.scale)
	end
end

---------------------
-- Fubar Plugin    --
---------------------
function Baggins:UpdateText()
	self:OnTextUpdate()
end

function Baggins:SetText(text)
	ldbdata.text = text
end

function Baggins:OnClick()
	if IsShiftKeyDown() then
		self:SaveItemCounts()
		self:ForceFullUpdate()
	elseif IsControlKeyDown() and self.db.profile.layout == 'manual' then
		self.db.profile.lock = not self.db.profile.lock
	else
		self:ToggleAllBags()
	end
end

function Baggins:UpdateTooltip(force)
	if not tooltip then return end
	if not tooltip:IsShown() and not force then return end
	ldbdata:OnTooltipUpdate()
end

local function openBag(self, line)
	Baggins:ToggleBag(line)
end

function ldbdata:OnTooltipUpdate()
	tooltip:Clear()
	local title = tooltip:AddHeader()
	tooltip:SetCell(title, 1, "Baggins", tooltip:GetHeaderFont(), "LEFT")
	tooltip:AddLine()
	for bagid, bag in ipairs(Baggins.db.profile.bags) do
		if not bag.isBank or (bag.isBank and self.bankIsOpen) then
			local color
			if bag.isBank then
				color = Baggins.colors.blue
			else
				color = Baggins.colors.white
			end
			local name = bag.name
			if Baggins.bagframes[bagid] and Baggins.bagframes[bagid]:IsVisible() then
				name = "* "..name
			end
			local line = tooltip:AddLine(name)
			tooltip:SetLineScript(line, "OnMouseUp", openBag, line - 2)
		end
	end
end



function Baggins:BuildCountString(empty, total, color)
	local p = self.db.profile
	color = color or ""
	local div = "|r/"
	if p.showtotal then
		if p.showused and p.showempty then
			return format("%s%i%s%s%i%s%s%i", color, total-empty, div, color, empty, div, color, total)
		elseif p.showused then
			return format("%s%i%s%s%i", color, total-empty, div, color, total)
		elseif p.showempty then
			return format("%s%i%s%s%i", color, empty, div, color, total)
		end
		return format("%s%i", color, total)
	end

	if p.showused and p.showempty then
		return format("%s%i%s%s%i", color, total-empty, div, color, empty)
	elseif p.showused then
		return format("%s%i", color, total-empty)
	elseif p.showempty then
		return format("%s%i", color, empty)
	end
	return ""
end


local texts={}
function Baggins:OnTextUpdate()
	local p = self.db.profile
	local color

	if p.combinecounts then
		local normalempty,normaltotal = LBU:CountSlots("BAGS", 0)
		local itemFamilies
		if p.showspecialcount then
			itemFamilies = 2047-256-4-2-1   -- all except keyring, ammo, quiver, soul
		else
			itemFamilies = 0
		end
		if p.showammocount then
			itemFamilies = itemFamilies +1 +2
		end
		if p.showsoulcount then
			itemFamilies = itemFamilies +4
		end

		local empty, total = LBU:CountSlots("BAGS", itemFamilies)
		empty=empty+normalempty
		total=total+normaltotal

		local fullness = 1 - (empty/total)
		local r, g
		r = min(1,fullness * 2)
		g = min(1,(1-fullness) *2)
		color = ("|cFF%2X%2X00"):format(r*255,g*255)

		self:SetText(self:BuildCountString(empty,total,color))
		return
	end

	-- separate normal/ammo/soul/special counts

	local n=0	-- count of strings in texts{}

	local normalempty, normaltotal = LBU:CountSlots("BAGS", 0)

	local fullness = 1 - (normalempty/normaltotal)
	local r, g
	r = min(1,fullness * 2)
	g = min(1,(1-fullness) *2)
	color = ("|cFF%2X%2X00"):format(r*255,g*255)

	n=n+1
	texts[n] = self:BuildCountString(normalempty,normaltotal,color)

	if self.db.profile.showsoulcount then
		local soulempty, soultotal = LBU:CountSlots("BAGS", 4)
		if soultotal>0 then
			color = self.colors.purple.hex
			n=n+1
			texts[n] = self:BuildCountString(soulempty,soultotal,color)
		end
	end

	if self.db.profile.showammocount then
		local ammoempty, ammototal = LBU:CountSlots("BAGS", 1+2)
		if ammototal>0 then
			color = self.colors.white.hex
			n=n+1
			texts[n] = self:BuildCountString(ammoempty,ammototal,color)
		end
	end

	if self.db.profile.showspecialcount then
		local specialempty, specialtotal = LBU:CountSlots("BAGS", 2047-256-4-2-1)
		if specialtotal>0 then
			color = self.colors.blue.hex
			n=n+1
			texts[n] = self:BuildCountString(specialempty,specialtotal,color)
		end
	end

	if n==1 then
		self:SetText(texts[1])
	else
		self:SetText(tconcat(texts, " ", 1, n))
	end
end

---------------------
-- Add/Remove/Move --
---------------------
function Baggins:NewBag(bagname)
	local bags = self.db.profile.bags
	tinsert(bags, { name=bagname, openWithAll=true, sections={}})
	if not self.bagframes[#bags] then
		self:CreateBagFrame(#bags)
	end
	currentbag = #bags
	self:ResortSections()
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
	self:BuildMoneyBagOptions()
	self:BuildBankControlsBagOptions()
end

function Baggins:MoveBag(bagid, down)
	local bags = self.db.profile.bags
	local other
	if down then
		other = bagid + 1
	else
		other = bagid - 1
	end

	if bags[bagid] and bags[other] then
		bags[bagid], bags[other] = bags[other], bags[bagid]
	end
	self:ResortSections()
	self:ForceFullRefresh()
	self:BuildMoneyBagOptions()
	self:BuildBankControlsBagOptions()
end

function Baggins:MoveSection(bagid, sectionid, down)
	local other
	if down then
		other = sectionid + 1
	else
		other = sectionid - 1
	end
	if self.db.profile.bags[bagid] then
		local sections = self.db.profile.bags[bagid].sections
		if sections[sectionid] and sections[other] then
			sections[sectionid], sections[other] = sections[other], sections[sectionid]
		end
	end
    self:ResortSections()
	self:ForceFullRefresh()
end

function Baggins:MoveRule(categoryid, ruleid, down)
	local other
	if down then
		other = ruleid + 1
	else
		other = ruleid - 1
	end
	local rules = self.db.profile.categories[categoryid]
	if rules then
		if rules[ruleid] and rules[other] then
			rules[ruleid], rules[other] = rules[other], rules[ruleid]
		end
	end
end

function Baggins:RemoveBag(bagid)
	self:CloseBag(bagid)
	tremove(self.db.profile.bags, bagid)
	self:ResetCatInUse()
	self:ResortSections()
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
	local numbags, numbagframes = #self.db.profile.bags, #self.bagframes
	for i = numbags+1, numbagframes do
		if self.bagframes[i] then
			self.bagframes[i]:Hide()
		end
	end
	self:BuildMoneyBagOptions()
	self:BuildBankControlsBagOptions()
end

function Baggins:NewSection(bagid,sectionname)
	tinsert(self.db.profile.bags[bagid].sections, { name=sectionname, cats = {} })
	currentsection = #self.db.profile.bags[bagid].sections
	self:ResortSections()
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
end

function Baggins:NewCategory(catname)
	if not self.db.profile.categories[catname] then
		self.db.profile.categories[catname] = { name=catname }
		currentcategory = catname
		--tablet:Refresh("BagginsEditCategories")
		self:RebuildCategoryOptions()
	end
end

function Baggins:RemoveSection(bagid, sectionid)
	tremove(self.db.profile.bags[bagid].sections, sectionid)
	self:ResetCatInUse()
	self:ResortSections()
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
end

function Baggins:RemoveRule(catid, ruleid)
	tremove(self.db.profile.categories[catid], ruleid)
	--tablet:Refresh("BagginsEditCategories")
	Baggins:OnRuleChanged()
end

function Baggins:AddCategory(bagid,sectionid,category)
	tinsert(self.db.profile.bags[bagid].sections[sectionid].cats,category)
	self:ResetCatInUse(category)
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
end

do
	local catinuse = { [true] = {}, [false] = {}}
	function Baggins:ResetCatInUse(catname)
		if catname then
			catinuse[true][catname] = nil
			catinuse[false][catname] = nil
		else
			for k in pairs(catinuse[true]) do
				catinuse[true][k] = nil
			end
			for k in pairs(catinuse[false]) do
				catinuse[false][k] = nil
			end
		end
	end

	function Baggins:CategoryInUse(catname, isbank)
		if not catname then return end
		if isbank == nil or catinuse[isbank][catname] == nil then
			for bid, bag in ipairs(self.db.profile.bags) do
				if isbank==nil or (not bag.isBank == not isbank) then
					for sid, section in ipairs(bag.sections) do
						for cid, cat in ipairs(section.cats) do
							if cat == catname then
								if isbank ~= nil then
									catinuse[isbank][catname] = true
								end
								return true
							end
						end
					end
				end
			end
			if isbank ~= nil then
				catinuse[isbank][catname] = false
			end
			return false
		else
			return catinuse[isbank][catname]
		end
	end
end

function Baggins:RemoveCategory(bagid,sectionid,catid)
	local p = self.db.profile
	if type(bagid) == "string" then
		--removing a category completely
		if not self:CategoryInUse(bagid) then
			p.categories[bagid] = nil
		end
		self:RebuildCategoryOptions()
	else
		--removing a category from a bag
		tremove(p.bags[bagid].sections[sectionid].cats,catid)
		self:ResetCatInUse()
		self:ForceFullRefresh()
		self:UpdateBags()
		self:UpdateLayout()
	end
end

---------------------
-- Bag Open/Close  --
---------------------
function Baggins:CloseBag(bagid)
	if self.bagframes[bagid] then
		self.bagframes[bagid]:Hide()
		if self.db.profile.hidedefaultbank and self.db.profile.bags[bagid].isBank then
			if self.bankIsOpen and not self:IsAnyBankOpen() then
				CloseBankFrame()
			end
		end
		self:UpdateLayout()
	end
	self:UpdateTooltip()

	if(not Baggins:IsWhateverOpen()) then
		--self:SetBagUpdateSpeed(false);	-- indicate bags closed
		self:FireSignal("Baggins_AllBagsClosed");
		-- reset temp no item compression
		if self.tempcompressnone then
			self.tempcompressnone = nil
			self:RebuildSectionLayouts()
		end
	end
end

function Baggins:CloseAllBags()
	for bagid, bag in ipairs(self.db.profile.bags) do
		Baggins:CloseBag(bagid)
	end
end

function Baggins:MainMenuBarBackpackButtonOnClick(button)
	if IsAltKeyDown() then
		BackpackButton_OnClick(button)
	else
		self:ToggleAllBags()
		button:SetChecked(false)
	end
end

function Baggins:ToggleBag(bagid)
	if not self.bagframes[bagid] then
		self:CreateBagFrame(bagid)
		self:OpenBag(bagid)
	elseif self.bagframes[bagid]:IsVisible() then
		self:CloseBag(bagid)
	else
		self:OpenBag(bagid)
	end
end

function Baggins:OpenBag(bagid,noupdate)
	--self:SetBagUpdateSpeed(true);	-- indicate bags open
	local p = self.db.profile
	if not self:IsActive() then
		return
	end
	if self.doInitialUpdate then
		Baggins:ForceFullUpdate()
		-- note: we use self.doInitialUpdate further down, and nil it there
	end

	if p.bags[bagid].isBank and not self.bankIsOpen then
		return
	end
	self:ForceSectionReLayout(bagid)
	if not self.bagframes[bagid] then
		self:CreateBagFrame(bagid)
	end
	self.bagframes[bagid]:Show()
	if not noupdate then

		self:RunBagUpdates()
		self:UpdateBags()
	end
	self:UpdateLayout()
	self:UpdateTooltip()

	-- reuse self.doInitialUpdate to only run once
	-- this fixes the duplicate stacks bug upon login
	if self.doInitialUpdate then
		-- rebuild layouts to fix duplicate stacks
		self:RebuildSectionLayouts()
		-- this time we set to nil so this only runs the first time
		self.doInitialUpdate = nil
	end
end

-- "All Bags" in these 3 functions refers to bags that are set to openWithAll
function Baggins:OpenAllBags()
	local p = self.db.profile
	if not self:IsActive() then
		return
	end
	for bagid, bag in ipairs(p.bags) do
		if bag.openWithAll then
			Baggins:OpenBag(bagid,true)
		end
	end
	self:RunBagUpdates()
	self:UpdateBags()
	self:UpdateLayout()
end

function Baggins:AuctionHouse()
 	if self.db.profile.openatauction then
 		self:OpenAllBags()
 	end
end


function Baggins:ToggleAllBags(forceopen)
	local p = self.db.profile
	if (forceopen) then
		self:OpenAllBags()
	elseif (p.hideemptybags) then
		if self:IsAnyOpen() then
			self:CloseAllBags()
		else
			self:OpenAllBags()
		end
	else
		if self:IsAllOpen() then
			self:CloseAllBags()
		else
			self:OpenAllBags()
		end
	end
end

function Baggins:IsAllOpen()
	for bagid, bag in ipairs(self.db.profile.bags) do
		if bag.openWithAll and (not bag.isBank or self.bankIsOpen) then
			if not ( self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() ) then
				return false
			end
		end
	end
	return true
end

function Baggins:IsAnyOpen()
	for bagid, bag in ipairs(self.db.profile.bags) do
		if bag.openWithAll and (not bag.isBank or self.bankIsOpen) then
			if self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
				return true
			end
		end
	end
end

function Baggins:IsWhateverOpen()
	for bagid, bag in ipairs(self.db.profile.bags) do
		if self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
			return true
		end
	end
end

function Baggins:IsAnyBankOpen()
	for bagid, bag in ipairs(self.db.profile.bags) do
		if bag.isBank and self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
			return true
		end
	end
end

function Baggins:IsEmpty(bagid)
	local count = 0
	if self.bagframes[bagid] then
		for i, v in ipairs(self.bagframes[bagid].sections) do
			count = count + v.itemcount or 0
		end
	end
	return count == 0
end

function Baggins:OpenBackpack()
	self:OpenAllBags()
end

function Baggins:CloseBackpack()
	self:CloseAllBags()
end

function Baggins:ToggleBackpack()
	if self:IsAnyOpen() then
		self:CloseAllBags()
	else
		self:OpenAllBags()
	end
end

function Baggins:CloseSpecialWindows()
    if self:IsAnyOpen() then
		self:CloseAllBags()
		return true
	end
	return self.hooks.CloseSpecialWindows()
end

function Baggins:BankFrameItemButton_Update(button)
	if button ~= nil then
		return self.hooks.BankFrameItemButton_Update(button)
	end
end
