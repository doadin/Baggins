--
-- This file contains operations on bags/items that are not really part of
-- Baggins core functionality, such as compressing your inventory, splitting
-- items, etc.
--

local _G = _G
local Baggins = _G.Baggins

local pairs, ipairs, next, select, type, tonumber, tostring, format, min, max, wipe =
      _G.pairs, _G.ipairs, _G.next, _G.select, _G.type, _G.tonumber, _G.tostring, _G.format, _G.min, _G.max, _G.wipe
local min, max, ceil, floor, mod  =
      _G.min, _G.max, _G.ceil, _G.floor, _G.mod
local GetItemInfo, GetContainerItemLink, GetContainerItemID, GetContainerItemInfo, GetContainerNumFreeSlots, GetContainerNumSlots, GetItemFamily =
      _G.GetItemInfo, _G.GetContainerItemLink, _G.GetContainerItemID, _G.GetContainerItemInfo, _G.GetContainerNumFreeSlots, _G.GetContainerNumSlots, _G.GetItemFamily
local PickupContainerItem, SplitContainerItem, IsShiftKeyDown =
      _G.PickupContainerItem, _G.SplitContainerItem, _G.IsShiftKeyDown
local band =
      _G.bit.band

local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")
local LBU = LibStub("LibBagUtils-1.0")

local bankBags = { BANK_CONTAINER }
for i=NUM_BAG_SLOTS+1, NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do
	tinsert(bankBags, i);
end

local charBags = {}
for i=0, NUM_BAG_SLOTS do
	tinsert(charBags, i);
end
tinsert(charBags, KEYRING_CONTAINER)


------------------------------------------------------
-- Compress stacks and move stuff to specialty bags --
------------------------------------------------------


local incompleteSlots = {}	-- pairs of itemlink = bag*1000+slot, e.g. "foo" = 2007 (bag 2 slot 7)
local compressLoopProtect = -1

function Baggins:CompressBags(bank)
	compressLoopProtect = 100
	return Baggins:DoCompressBags(bank)
end

function Baggins:CanCompressBags(bank)
	return Baggins:DoCompressBags(bank,true)
end

function Baggins:DoCompressBags(bank,testonly)
	local bags = bank and bankBags or charBags

	wipe(incompleteSlots)

	local lockedSlots

	for _,bag in ipairs(bags) do
		for slot=1,(GetContainerNumSlots(bag) or 0) do
			local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot)
			local link = GetContainerItemLink(bag, slot)
			lockedSlots = lockedSlots or locked
			if link and (testonly or not locked) then
				local _, _, _, _, _, _, _, iMaxStack = GetItemInfo(link)
				if iMaxStack and itemCount < iMaxStack then
					local itemid = link:match("item:(-?[%d]+):")
					if(incompleteSlots[itemid]) then	-- see if we have an incomplete stack of this sitting around
						if testonly then return true end	-- Yup, we've got something that needs compressing!
						compressLoopProtect = compressLoopProtect - 1
						if compressLoopProtect < 0 then return end

						PickupContainerItem(floor(incompleteSlots[itemid]/1000), incompleteSlots[itemid]%1000)
						PickupContainerItem(bag, slot)
						self:ScheduleTimer("DoCompressBags", 0.1, bank)
						return
					else
						incompleteSlots[itemid] = bag*1000 + slot	-- remember that there's an incomplete stack of this item sitting around
					end
				end
			end
		end
	end

	if lockedSlots and not testonly then
		compressLoopProtect = compressLoopProtect - 10
		if compressLoopProtect > 0 then
			self:ScheduleTimer("DoCompressBags", 1, bank)	-- try again in 1s to see if locks released
			return
		end
	end

	return Baggins:MoveToSpecialtyBags(bank,testonly)
end


local specialtyTargetBags = {} -- [family] = bag*1000 + slot

function Baggins:MoveToSpecialtyBags(bank,testonly)

	wipe(specialtyTargetBags)

	for _,bag in ipairs(bank and bankBags or charBags) do
		local free,bagFamily = LBU:GetContainerNumFreeSlots(bag)
		if free>0 and bagFamily~=0 then
			for slot=1, (GetContainerNumSlots(bag) or 0) do
				if not GetContainerItemLink(bag, slot) then
					specialtyTargetBags[bagFamily] =	bag*1000 + slot
					break	-- only interested in the first empty slot, we're only moving one item
				end
			end
		end
	end

	local lockedSlots

	-- Find stuff that can go in specialty bags
	if next(specialtyTargetBags) then
		for _,bag in ipairs(bank and bankBags or charBags) do
			local bagFamily = LBU:GetContainerFamily(bag)
			if bagFamily==0 then	-- only examine stuff in normal bags
				for slot=1, (GetContainerNumSlots(bag) or 0) do
					local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot)
					local link = GetContainerItemLink(bag, slot)
					lockedSlots = lockedSlots or locked
					if link and (testonly or not locked) then
						local itemFamily = GetItemFamily(link)
						if itemFamily and itemFamily~=0 then	-- itemFamily can apparently be null? (before item is cached?)
							if select(9, GetItemInfo(link))=="INVTYPE_BAG" then
								-- specialty bags dont go in specialty bags
							else
								for bagFamily,dest in pairs(specialtyTargetBags) do
									if band(itemFamily,bagFamily)~=0 then
										if testonly then return true end
										compressLoopProtect = compressLoopProtect - 1
										if compressLoopProtect < 0 then return end

										PickupContainerItem(bag,slot)
										PickupContainerItem(floor(dest/1000),dest%1000)
										self:ScheduleTimer("MoveToSpecialtyBags", 0.1, bank)
										return
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if lockedSlots and not testonly then
		compressLoopProtect = compressLoopProtect - 10
		if compressLoopProtect > 0 then
			self:ScheduleTimer("MoveToSpecialtyBags", 1, bank)
			return
		end
	end

	if not testonly then
		compressLoopProtect = -1	-- signals compressor not running
	end
end



Baggins:RegisterSignal("Baggins_AllBagsClosed",
	function(self)
		compressLoopProtect = -1   -- stop compress worker very soon... not STRICTLY needed, but if it titsups, closing bags seems like a good user action to force it to stop
		                           -- stupid stuff HAS happened in the past, like looping on trying to put a herb bag in a herb bag. derp.
	end,
	Baggins
);


local lastCanCompressBags = "maybe";
local lastCanCompressBank = "maybe";

local timerRecheckCompress

function Baggins:RecheckCompress()
	if timerRecheckCompress then
		self:CancelTimer(timerRecheckCompress)
	end
	if compressLoopProtect>0 then
		timerRecheckCompress = self:ScheduleTimer("DoRecheckCompress", 1.5)
	else
		timerRecheckCompress = self:ScheduleTimer("DoRecheckCompress", 0.1)
	end
end

function Baggins:DoRecheckCompress()
	timerRecheckCompress = nil
	local b
	b = self:CanCompressBags(false)	-- false=bags
	if b ~= lastCanCompressBags then
		lastCanCompressBags = b
		self:FireSignal("Baggins_CanCompress", false, b)		-- false=bags
	end
	b = self:CanCompressBags(true)	-- true=bank
	if b ~= lastCanCompressBank then
		lastCanCompressBank = b
		self:FireSignal("Baggins_CanCompress", true, b)  -- true=bank
	end
end

Baggins:RegisterSignal("Baggins_BagsUpdatedWhileOpen",
	function(self)
		self:RecheckCompress()
	end,
	Baggins
);

Baggins:RegisterSignal("Baggins_BagOpened",
	function(self)
		self:RecheckCompress()
	end,
	Baggins
);

Baggins.Baggins_RecheckCompress = Baggins.RecheckCompress

---------------------
-- Splitting items --
---------------------

local function BagginsItemButton_Split(bag,slot,amount)
	-- Pick up the new stack
	local link = GetContainerItemLink(bag,slot)
	SplitContainerItem(bag, slot, amount or 1)

	if(IsShiftKeyDown()) then
		return;	-- Just split off if shift was held down, keep new stack in cursor
	end

	-- First, try to put in specialty bags
	local itemFamily = GetItemFamily(link)
	if itemFamily~=0 then
		for _,destbag in ipairs(charBags) do
			local free,bagFamily = LBU:GetContainerNumFreeSlots(destbag)
			if free>0 and band(bagFamily,itemFamily)~=0 then
				for destslot=1, GetContainerNumSlots(destbag) do
					if not GetContainerItemLink(destbag, destslot) then
						PickupContainerItem(destbag, destslot)
						return
					end
				end
			end
		end
	end

	-- Mkay, shove it in any bag with free slots
	for _,destbag in ipairs(charBags) do
		local free,bagFamily = GetContainerNumFreeSlots(destbag)
		if free>0 and bagFamily==0 then
			for destslot=1, GetContainerNumSlots(destbag) do
				if not GetContainerItemLink(destbag, destslot) then
					PickupContainerItem(destbag, destslot)
					return
				end
			end
		end
	end

	-- Ends up with the item in the cursor if there's no room. Indication enough?
end



---------------------
-- ItemButton menu --
---------------------

local lastSplitSliderValue = 1

local function splitSliderFunc(value)
	lastSplitSliderValue = value;
end

Baggins:RegisterSignal("Baggins_ItemButtonMenu",

	function(self, button, dewdrop, level, value)
		local bag = button:GetParent():GetID();
		local slot = button:GetID();
		local link = GetContainerItemLink(bag,slot)
		if not link then return; end
		local _, itemCount = GetContainerItemInfo(bag, slot);
		local itemstring = link:match("(item:[-%d:]+)");

		if level==1 then
			local b;

			-- "Use"
			if not LBU:IsBank(bag) then
				dewdrop:AddLine("text",L["Use"], "secure", { type="item", item=itemstring },
					"closeWhenClicked",true, "tooltipText", L["Use/equip the item rather than bank/sell it"]);
				b=true;
			end

			-- "Split"
			if itemCount>1 then
				dewdrop:AddLine("text",format(L["Split %d"],lastSplitSliderValue),
					"func", BagginsItemButton_Split,
					"arg1",bag, "arg2",slot, "arg3", lastSplitSliderValue,
					"tooltipText", L["Split_tooltip"],
					"mouseoverUnderline", true,
					"hasArrow",true, "hasSlider", true,
					"sliderMin", 1, "sliderMax", itemCount-1,
					"sliderStep", 1,
					"sliderValue", lastSplitSliderValue,
					"sliderFunc", splitSliderFunc,
					"textR", 1,
					"textG", lastSplitSliderValue>=itemCount and 0.5 or 1,
					"textB", lastSplitSliderValue>=itemCount and 0.5 or 1
				);
				b=true;
			end

			-- separator
			if b then
				dewdrop:AddLine("text","","disabled",1);
			end

		end

	end,
	Baggins
);

--[[
Baggins:RegisterSignal("Baggins_BagsUpdatedWhileOpen",
	function(self)
		if dewdrop:GetOpenedParent() then
			dewdrop:Refresh(1);
		end
	end,
	Baggins
);
--]]
