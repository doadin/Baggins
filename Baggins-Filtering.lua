
local pairs, ipairs, next, select, type, tonumber, tostring, format = 
      pairs, ipairs, next, select, type, tonumber, tostring, format

local _G = _G
	  
local min, max = 
      min, max

local wipe=wipe
local tinsert, tremove, tsort = tinsert, tremove, table.sort
local band=bit.band
	  
local BANK_CONTAINER = BANK_CONTAINER

local GetItemInfo, GetContainerItemLink, GetContainerItemID, GetContainerItemInfo, GetContainerNumFreeSlots, GetContainerNumSlots =
      GetItemInfo, GetContainerItemLink, GetContainerItemID, GetContainerItemInfo, GetContainerNumFreeSlots, GetContainerNumSlots

local GetInventoryItemLink, GetItemQualityColor = 
      GetInventoryItemLink, GetItemQualityColor
	  
local GetEquipmentSetInfo, GetEquipmentSetItemIDs, GetNumEquipmentSets =
      GetEquipmentSetInfo, GetEquipmentSetItemIDs, GetNumEquipmentSets

local UnitLevel = UnitLevel



local Baggins = Baggins
local pt = LibStub("LibPeriodicTable-3.1", true)
local gratuity = LibStub("LibGratuity-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")
local BBI = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()

local BattlePetTypes = {
	["Battle Pets"] = L["Battle Pets"],
	["Humanoid"] = _G["BATTLE_PET_NAME_" .. 1],
	["Dragonkin"] = _G["BATTLE_PET_NAME_" .. 2],
	["Flying"] = _G["BATTLE_PET_NAME_" .. 3],
	["Undead"] = _G["BATTLE_PET_NAME_" .. 4],
	["Critter"] = _G["BATTLE_PET_NAME_" .. 5],
	["Magic"] = _G["BATTLE_PET_NAME_" .. 6],
	["Elemental"] = _G["BATTLE_PET_NAME_" .. 7],
	["Beast"] = _G["BATTLE_PET_NAME_" .. 8],
	["Aquatic"] = _G["BATTLE_PET_NAME_" .. 9],
	["Mechanical"] = _G["BATTLE_PET_NAME_" .. 10],
}
local BI = setmetatable({}, { __index = function(self, key)
		return BattlePetTypes[key] or BBI[key]
	end})

local LBU = LibStub("LibBagUtils-1.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local RuleTypes = {}

local categorycache = {}
local useditems = {}
local slotcache = {}

function Baggins:GetCategoryCache()
    return categorycache
end

local ptsets = {}

local bankuseditems = {}
local bankcategorycache = {}

local categories

local colors = {
		black = {r=0,g=0,b=0,hex="|cff000000"},
		white = {r=1,g=1,b=1,hex="|cffffffff"},
		blue = {r=0,g=0.5,b=1,hex="|cff007fff"},
		purple = {r=1,g=0.4,b=1,hex="|cffff66ff"},
	}

function Baggins:SetCategoryTable(cats)
	categories = cats
end


local BagNames = {
	[KEYRING_CONTAINER] = L["KeyRing"],
	[BANK_CONTAINER] = L["Bank Frame"],
	[BACKPACK_CONTAINER] = L["Backpack"],
}
local BagTypes = {
	[BACKPACK_CONTAINER] = 1,
	[BANK_CONTAINER] = 2,
	[KEYRING_CONTAINER] = 3,
}
for i=1,NUM_BAG_SLOTS do
	BagNames[i] = L["Bag"..i]
	BagTypes[i] = 1
end
for i=1,NUM_BANKBAGSLOTS do
	BagNames[NUM_BAG_SLOTS+i] = L["Bank Bag"..i]
	BagTypes[NUM_BAG_SLOTS+i] = 2
end


local QualityNames = {
}
for i=0,99 do
	QualityNames[i]=_G["ITEM_QUALITY"..i.."_DESC"]
	if not QualityNames[i] then
		break
	end
end

local EquipLocs = {
	"INVTYPE_AMMO",
	"INVTYPE_HEAD",
	"INVTYPE_NECK",
	"INVTYPE_SHOULDER",
	"INVTYPE_BODY",
	"INVTYPE_CHEST",
	"INVTYPE_ROBE",
	"INVTYPE_WAIST",
	"INVTYPE_LEGS",
	"INVTYPE_FEET",
	"INVTYPE_WRIST",
	"INVTYPE_HAND",
	"INVTYPE_FINGER",
	"INVTYPE_TRINKET",
	"INVTYPE_CLOAK",
	"INVTYPE_WEAPON",
	"INVTYPE_SHIELD",
	"INVTYPE_2HWEAPON",
	"INVTYPE_WEAPONMAINHAND",
	"INVTYPE_WEAPONOFFHAND",
	"INVTYPE_HOLDABLE",
	"INVTYPE_RANGED",
	"INVTYPE_THROWN",
	"INVTYPE_RANGEDRIGHT",
	"INVTYPE_RELIC",
	"INVTYPE_TABARD",
	"INVTYPE_BAG"
}

local EquipLocs2 = {}
for _,v in ipairs(EquipLocs) do
	EquipLocs2[v] = _G[v] or v
end

function Baggins:AddCustomRule(type,description)
	RuleTypes[type] = description
end

--removes any fields not used by the current rule type and sets up defaults if needed
function Baggins:CleanRule(rule)
	local type = rule.type
	wipe(rule)
	rule.type = type

	if RuleTypes[rule.type].CleanRule then
		RuleTypes[rule.type].CleanRule(rule)
	end
end



local currentRule = nil
function Baggins:OpenRuleDewdrop(rule,...)
	if RuleTypes[rule.type] then
		currentRule = rule
		RuleTypes[rule.type].DewDropOptions(rule, ...)
	end
end

function Baggins:RuleTypeIterator(sorted)
	if not sorted then
		return pairs(RuleTypes)
	end
	local t = {}
	for k,v in pairs(RuleTypes) do
		tinsert(t,k)
	end
	tsort(t, function(a,b) return RuleTypes[a].DisplayName < RuleTypes[b].DisplayName end)
	local i=0
	return function(k)
		i=i+1
		local rt=t[i]
		if not rt then
			return nil,nil
		end
		return rt, RuleTypes[rt]
	end
end

local types = {}
function Baggins:GetRuleTypes()
	wipe(types)
	for k,v in pairs(RuleTypes) do
		types[k] = v.DisplayName
	end
	return types
end

function Baggins:GetRuleDesc(rule)
	if RuleTypes[rule.type] then
		return RuleTypes[rule.type].GetName(rule)
	else
		return format("(|cffff8080%s not loaded|r)", rule.type);
	end
end

function Baggins:GetAce3Opts(rule)
	if RuleTypes[rule.type] then
		return RuleTypes[rule.type].Ace3Options
	end
end

function Baggins:RuleIsDeprecated(rule)
	local ruleType = RuleTypes[rule.type]
	if not ruleType then return true end
	if ruleType.Ace3Options then return end
	return ruleType.DewDropOptions ~= nil
end

function Baggins:IsSpecialBag(bag)
	if not bag then return end
	if type(bag) == "string" then bag = tonumber(bag) end
	local prefix = ""
	if bag == BANK_CONTAINER then
		return "b", 0
	end
	if BagTypes[bag] == 2 then
		prefix = "b"
	end
	if BagTypes[bag] == 3 then
		return "k", 256
	end
	if bag>=1 and bag<= 11 then
		local _,fam = GetContainerNumFreeSlots(bag)
		if type(fam)~="number" then
			-- assume normal bag
		elseif fam==0 then
			-- normal bag
		elseif fam==1 or fam==2 then	-- quiver / ammo
			return prefix.."a", fam
		elseif fam==4 then		-- soul
			return prefix.."s", fam
		elseif fam==8 then		-- leatherworking
			return prefix.."l", fam
		elseif fam==16 then		-- inscription
			return prefix.."i", fam
		elseif fam==32 then		-- herb
			return prefix.."h", fam
		elseif fam==64 then		-- eNchant
			return prefix.."n", fam
		elseif fam==128 then	-- engineering
			return prefix.."e", fam
		elseif fam==256 then	-- keyring
			return prefix.."k", fam
		elseif fam==512 then	-- gems
			return prefix.."g", fam
		elseif fam==1024 then	-- mining
			return prefix.."m", fam
		else
			return prefix.."?", fam
		end
	end

	if prefix ~= "" then
		return prefix, 0
	end
	return nil,0
end

local PET_CAGE_ITEM_ID = 82800
--------------------
-- Item Filtering --
--------------------
function Baggins:CheckSlotsChanged(bag, forceupdate)
	local slot
	local itemschanged
	for slot = 1, GetContainerNumSlots(bag) do
		local key = bag..":"..slot
		local iteminfo

		local link = GetContainerItemLink(bag, slot)
		local itemCount = select(2, GetContainerItemInfo(bag, slot))
		local itemid, itemName
		if link then
			itemid = link:match("item:(%d+)")
			if itemid then -- it's a battle pet				
				itemName = GetItemInfo(link)
				iteminfo = itemid.." "..itemCount.." "..(itemName or "_")
			else
				-- sample battle-pet-link "|cffffd200|Hbattlepet:261:3:-1:253:34:29:6822822|h[Personal World Destroyer]|h|r"
				local speciesID, level, quality, maxhp, power, speed, petid = link:match("battlepet:(%d+):(%d+):([-%d]+):(%d+):(%d+):(%d+):(%d+)")
				local name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique = C_PetJournal.GetPetInfoBySpeciesID( speciesID )
				itemName = name
				itemid = - tonumber(petid) -- use negative itemid values for battle-pets
				if itemid == 0 then
					itemid = - tonumber(speciesID)
				end
				iteminfo = PET_CAGE_ITEM_ID .. " " .. 1 .. " " .. name
			end
		end

		if slotcache[key] ~= iteminfo or forceupdate then
			local olditemid = (slotcache[key] or ""):match("^(%d+)")
			if itemid ~= olditemid then
				itemschanged = true
			end
			slotcache[key] = iteminfo
			self:OnSlotChanged(bag, slot)
		end
	end
	return itemschanged
end

local categoriesrun = { [true] = {}, [false] = {}}
local recursionmagic = 12345


local function CheckCategory(catid, category, bag, slot, key, isbank, cache, used)
	if (categoriesrun[isbank][catid] or 0) == recursionmagic then return end
	categoriesrun[isbank][catid] = recursionmagic

	if not cache[catid] then
		cache[catid] = {}
	end
	local wasMatch = cache[catid][key]
	cache[catid][key] = nil
	local anymatch
	local catmatch = false
	cache[catid]["Other"] = nil
	for ruleid, rule in ipairs(category) do
		local rulematch
		if rule.type == "Other" then
			cache[catid]["Other"] = true
		else
			if rule.type == "Category" then
				if rule.category and categories[rule.category] then
					anymatch = (CheckCategory(rule.category,categories[rule.category], bag, slot, key, isbank, cache, used) and Baggins:CategoryInUse(rule.category, isbank)) or anymatch
				end
			end

			local operation
			if ruleid == 1 then
				operation = "OR"
			else
				operation = rule.operation or "OR"
			end
			rulematch = (RuleTypes[rule.type] and RuleTypes[rule.type].Matches(bag,slot,rule))
			if operation == "OR" then
				catmatch = catmatch or rulematch
			elseif operation == "AND" then
				catmatch = catmatch and rulematch
			elseif operation == "NOT" then
				catmatch = catmatch and (not rulematch)
			end
		end
	end


	if catmatch then
		cache[catid][key] = true
	end

	if not wasMatch and catmatch then
		Baggins:FireSignal("CategoryMatchAdded", catid, key, isbank)
	elseif wasMatch and not catmatch then
		Baggins:FireSignal("CategoryMatchRemoved", catid, key, isbank)
	elseif catmatch and wasMatch then
		Baggins:FireSignal("SlotMoved", catid, key, isbank)
	end

	return catmatch or anymatch
end

function Baggins:OnSlotChanged(bag, slot)
	recursionmagic = recursionmagic + 1
	local isbank
	local cache
	local used
	if BagTypes[bag] == 2 then
		used = bankuseditems
		cache = bankcategorycache
		isbank = true
	else
		used = useditems
		cache = categorycache
		isbank = false	-- nil ain't good enuf because of how :CategoryInUse treats nils
	end

	local key = bag..":"..slot
	if not used[key] then
		used[key] = false
	end
	local anymatch
	for catid, category in pairs(categories) do
		if self:CategoryInUse(catid, isbank) then
		--if true then
			anymatch = CheckCategory(catid, category, bag, slot, key, isbank, cache, used) or anymatch
		end
	end


	for catid, category in pairs(categories) do
		if cache[catid] and cache[catid]["Other"] then
			local wasMatch = cache[catid][key]
			local catmatch
			if not anymatch then
				cache[catid][key] = true
				catmatch = true
			else
				cache[catid][key] = nil
			end
			if not wasMatch and catmatch then
				self:FireSignal("CategoryMatchAdded", catid, key, isbank)
			elseif wasMatch and not catmatch then
				self:FireSignal("CategoryMatchRemoved", catid, key, isbank)
			elseif catmatch and wasMatch then
				self:FireSignal("SlotMoved", catid, key, isbank)
			end
			cache[catid]["Other"] = nil
		end
	end

end

function Baggins:OnRuleChanged()
	self:ForceFullUpdate()
	currentRule = nil
	self:CategoriesChanged()
end

local function ClearCache(cache)
	for k, v in pairs(cache) do
		if type(v) == "table" then
			ClearCache(v)
		else
			cache[k] = nil
		end
	end
end

function Baggins:ClearSortingCaches()
	ClearCache(bankuseditems)
	ClearCache(bankcategorycache)
	ClearCache(useditems)
	ClearCache(categorycache)
	ClearCache(slotcache)
end


function Baggins:ForceFullRefresh()
	self:ClearSortingCaches()
	self:ClearSectionCaches()
	self:ForceFullUpdate()
end

function Baggins:ForceFullUpdate()
	--local start = GetTime()
	local bagid
	for bagid = 0, 11 do
		self:CheckSlotsChanged(bagid, true)
	end
	self:CheckSlotsChanged(-2,true)
	self:CheckSlotsChanged(-1,true)
	self:CategoriesChanged()
end

function Baggins:CategoriesChanged()
	self:Baggins_CategoriesChanged()
end

function Baggins:ForceFullBankUpdate()
	for bagid in LBU:IterateBags("BANK") do
		self:CheckSlotsChanged(bagid, true)
	end
end

function Baggins:GetIncludeRule(category,create)
	local numrules = #category
	for i = numrules,1,-1 do
		if category[i].type == "ItemID" then
			if category[i].operation ~= "NOT" then
				return category[i]
			end
		end
	end
	if create then
		local newrule = { type="ItemID", operation="OR"}
		tinsert( category, newrule )
		return newrule
	end
end

function Baggins:GetExcludeRule(category,create)
	local numrules = #category
	for i = numrules,1,-1 do
		if category[i].type == "ItemID" then
			if category[i].operation == "NOT" then
				return category[i]
			end
		end
	end
	if create then
		local newrule = { type="ItemID", operation="NOT"}
		tinsert( category, newrule )
		return newrule
	end
end

function Baggins:IncludeItemInCategory(catname, itemid)
	local cat = categories[catname]
	if not cat then return end

	for i, rule in ipairs(cat) do
		if rule.ids and rule.operation == "NOT" then
			rule.ids[itemid] = nil
		end
	end
	local rule = self:GetIncludeRule(cat,true)
	if not rule.ids then
		rule.ids = {}
	end
	rule.ids[itemid] = true
	self:RebuildCategoryOptions()
	self:ForceFullUpdate()
end

function Baggins:ExcludeItemFromCategory(catname, itemid)
	local cat = categories[catname]
	if not cat then return end

	for i, rule in ipairs(cat) do
		if rule.ids and rule.operation ~= "NOT" then
			rule.ids[itemid] = nil
		end
	end
	local rule = self:GetExcludeRule(cat,true)
	if not rule.ids then
		rule.ids = {}
	end
	rule.ids[itemid] = true
	self:RebuildCategoryOptions()
	self:ForceFullUpdate()
end

function Baggins:GetRuleDefinition(rulename)
	return RuleTypes[rulename]
end

function Baggins:GetCachedItem(item)
	return slotcache[item]
end











-----------------------------------------------------------------------
-- ItemType

--------------------------
-- Baggins: AH category scanned 04/13/13 10:56:38 - patch 5.2.0

local ItemTypes = {
 ["Weapon"] = {"One-Handed Axes", "Two-Handed Axes", "Bows", "Guns", "One-Handed Maces", "Two-Handed Maces", "Polearms", "One-Handed Swords", "Two-Handed Swords", "Staves", "Fist Weapons", "Miscellaneous", "Daggers", "Thrown", "Crossbows", "Wands", "Fishing Poles"},
 ["Armor"] = {"Miscellaneous", "Cloth", "Leather", "Mail", "Plate", "Cosmetic", "Shields"},  
 ["Container"] = {"Bag", "Herb Bag", "Enchanting Bag", "Engineering Bag", "Gem Bag", "Mining Bag", "Leatherworking Bag", "Inscription Bag", "Tackle Box", "Cooking Bag"},  
 ["Consumable"] = {"Food & Drink", "Potion", "Elixir", "Flask", "Bandage", "Item Enhancement", "Scroll", "Other"},
 ["Glyph"] = {"Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Death Knight", "Shaman", "Mage", "Warlock", "Monk", "Druid"},
 ["Trade Goods"] = {"Elemental", "Cloth", "Leather", "Metal & Stone", "Cooking", "Herb", "Enchanting", "Jewelcrafting", "Parts", "Devices", "Explosives", "Materials", "Other", "Item Enchantment"},
 ["Recipe"] = {"Book", "Leatherworking", "Tailoring", "Engineering", "Blacksmithing", "Cooking", "Alchemy", "First Aid", "Enchanting", "Fishing", "Jewelcrafting", "Inscription"},
 ["Gem"] = {"Red", "Blue", "Yellow", "Purple", "Green", "Orange", "Meta", "Simple", "Prismatic", "Cogwheel"},
 ["Miscellaneous"] = {"Junk", "Reagent", "Companion Pets", "Holiday", "Other", "Mount"},
 ["Quest"] = {},
 ["Battle Pets"] = {"Humanoid", "Dragonkin", "Flying", "Undead", "Critter", "Magic", "Elemental", "Beast", "Aquatic", "Mechanical"},
}

-- Manually added types that do not appear in AH scan
assert(#ItemTypes["Quest"]==0)	-- alert dev if scanned array suddenly looks different
ItemTypes["Quest"] = { "Quest" }
assert(not ItemTypes["Key"])    -- alert dev if scanned array suddenly looks different
ItemTypes["Key"] = { "Key" }

--[[
SELECTED_CHAT_FRAME:AddMessage("--------------------------")
SELECTED_CHAT_FRAME:AddMessage("-- scanned "..date("%c").. " - patch "..(GetBuildInfo()))
SELECTED_CHAT_FRAME:AddMessage("local ItemTypes = {")
for i,class in pairs{GetAuctionItemClasses()} do
  local subs={GetAuctionItemSubClasses(i)}
  if #subs>0 then

    SELECTED_CHAT_FRAME:AddMessage('  ["'..class..'"] = {"'..
      table.concat(subs, '", "') ..
    '"},')
  else
    SELECTED_CHAT_FRAME:AddMessage('  ["'..class..'"] = {},')
  end
end
SELECTED_CHAT_FRAME:AddMessage("}")
--]]

Baggins:AddCustomRule("ItemType", {
		DisplayName = L["Item Type"],
		Description = L["Filter by Item type and sub-type as returned by GetItemInfo"],
		Matches = function(bag,slot,rule)
			if not (rule.itype or rule.isubtype) then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local Type, SubType = select(6, GetItemInfo(link))
				if not Type then
					local speciesID, level, quality, maxhp, power, speed, petid = link:match("battlepet:(%d+):(%d+):([-%d]+):(%d+):(%d+):(%d+):(%d+)")
					if not tonumber(speciesID) then
						return false
					end
					Type = L["Battle Pets"]
					local _, _, petType = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
					SubType = _G["BATTLE_PET_NAME_" .. petType]
				end
				if Type and SubType then
					return Type == BI[rule.itype] and (rule.isubtype == nil or SubType == BI[rule.isubtype] )
				end
			end
		end,
		GetName = function(rule)
			local ltype, lsubtype = "*", "*"
			if rule.itype then
				ltype = BI[rule.itype] or "?"
			end
			if rule.isubtype then
				lsubtype = BI[rule.isubtype] or "?"
			end
			return L["ItemType - "]..ltype..":"..lsubtype
		end,
		Ace3Options = {
			itype = {
				type = 'select',
				name = L["Item Type"],
				desc = "",
				values = function(info)
						local tmp = {}
						for k in pairs(ItemTypes) do
							tmp[k] = k
						end
						return tmp
					end,
				order = 10,
			},
			isubtype = {
				name = L["Item Subtype"],
				desc = "",
				type = "select",
				get = function(info)
						return info.arg.isubtype or "ALL"
					end,
				set = function(info, value)
						local rule = info.arg
						if value == "ALL" then
							rule.isubtype = nil
						else
							rule.isubtype = value
						end
						Baggins:OnRuleChanged()
					end,
				values = function(info)
						local rule = info.arg
						local tmp = {}
						tmp.ALL = _G.ALL
						if rule.itype and ItemTypes[rule.itype] then
							for _,v in ipairs(ItemTypes[rule.itype]) do
								tmp[v] = v
							end
						end
						return tmp
					end,
				order = 20,
			}
		},
		CleanRule = function(rule)
			rule.itype="Miscellaneous"
		end
})

-----------------------------------------------------------------------
-- ContainerType

local ContainerIDToInventoryID = ContainerIDToInventoryID

Baggins:AddCustomRule("ContainerType", {
		DisplayName = L["Container Type"],
		Description = L["Filter by the type of container the item is in."],
		Matches = function(bag,slot,rule)
			if bag < 1 or bag > 11 then return end
			if not rule.ctype then return end
			local link = GetInventoryItemLink("player",ContainerIDToInventoryID(bag))
			if link then
				local SubType = select(7, GetItemInfo(link))
				if SubType then
					return SubType == BI[rule.ctype]
				end
			end
		end,
		GetName = function(rule)
			local ctype
			if rule.ctype then
				ctype = BI[rule.ctype]
			else
				ctype = L["None"]
			end
			return L["Container : "]..ctype
		end,
		Ace3Options = {
			ctype = {
				name = L["Container Type"],
				desc = "",
				type = 'select',
				get = function(info) return info.arg.ctype or "ALL" end,
				set = function(info, value)
						if value == "ALL" then
							info.arg.ctype = nil
						else
							info.arg.ctype = value
						end
						Baggins:OnRuleChanged()
					end,
				values = function()
						local tmp = {
							ALL = _G.ALL,
						}
						for _,v in ipairs(ItemTypes["Container"]) do
							tmp[v] = v
						end
						return tmp
					end,
			},
		},
})





-----------------------------------------------------------------------
-- ItemID

local function getItemIdSummary(info)
	local ids = info.arg.ids
	if not ids then return "" end
	local result = ""
	for k in pairs(ids) do
		local _,v = GetItemInfo(k)
		result = ("%s\n%s (%d)"):format(result, v or _G.UNKNOWN, k)
	end
	return result
end

local function setItemIdList(info, value)
	local idList = { (" "):split(value) }
	local ids
	if not info.arg.ids then
		ids = {}
		info.arg.ids = ids
	else
		ids = wipe(info.arg.ids)
	end
	for _,v in ipairs(idList) do
		local v = tonumber(v)
		if v then
			ids[tonumber(v)] = true
		end
	end
	Baggins:OnRuleChanged()
end

local function getItemIdList(info)
	local result = ""
	if not info.arg.ids then return "" end
	for k in pairs(info.arg.ids) do
		result = ("%s %s"):format(result, k)
	end
	return result:sub(2)
end

Baggins:AddCustomRule("ItemID", {
		DisplayName = L["Item ID"],
		Description = L["Filter by ItemID, this can be a space delimited list or ids to match."],
		Matches = function(bag,slot,rule)
			if not rule.ids then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local itemid = link:match("item:(%d+)")
				return rule.ids[tonumber(itemid)]
			end
		end,
		GetName = function(rule)
			return L["ItemIDs "]
		end,
		Ace3Options = {
			ids = {
				type = 'input',
				name = L["Item IDs "],
				desc = "",
				set = setItemIdList,
				get = getItemIdList,
				order = 10,
			},
			desc = {
				type = 'description',
				name = getItemIdSummary,
				order = 11,
			}
		},
})


-----------------------------------------------------------------------
-- Bag

Baggins:AddCustomRule("Bag", {
		DisplayName = L["Bag"],
		Description = L["Filter by the bag the item is in"],
		Matches = function(bag,slot,rule)
			if rule.noempty then
				local link = GetContainerItemLink(bag, slot)
				if link then
					return bag == rule.bagid
				end
			else
				return bag == rule.bagid
			end
		end,
		GetName = function(rule)
			return "Bag "..(BagNames[rule.bagid] or rule.bagid or "*none*")..((rule.noempty and " *NotEmpty*") or "")
		end,
		Ace3Options = {
			bagid = {
				name = L["Bag"],
				desc = "",
				type = 'select',
				values = BagNames,
			},
			noempty = {
				name = L["Ignore Empty Slots"],
				desc = "",
				type = 'toggle',
			},
		},
		CleanRule = function(rule)
			rule.bagid=0
		end,
})


-----------------------------------------------------------------------
-- ItemName

Baggins:AddCustomRule("ItemName", {
		DisplayName = L["Item Name"],
		Description = L["Filter by Name or partial name"],
		Matches = function(bag,slot,rule)
			if not rule.match then return end
			local link = GetContainerItemLink(bag, slot)

			if link then
				local itemname = GetItemInfo(link)
				if itemname and itemname:lower():match(rule.match:lower()) then
					return true
				end
			end
		end,
		GetName = function(rule)
			return L["Name: "]..(rule.match or "")
		end,
		Ace3Options = {
			match = {
				name = L["String to Match"],
				desc = "",
				type = 'input',
			},
		},
})


-----------------------------------------------------------------------
-- Empty

Baggins:AddCustomRule("Empty", {
		DisplayName = L["Empty Slots"],
		Description = L["Empty bag slots"],
		Matches = function(bag,slot,rule)
			if not (bag and slot) then return end
			if BagTypes[bag] == 3 then return end
			local link = GetContainerItemLink(bag, slot)
			if not link then
				return true
			end
		end,
		GetName = function(rule)
			return L["Empty Slots"]
		end,
})


-----------------------------------------------------------------------
-- NewItems

Baggins:AddCustomRule("NewItems", {
		DisplayName = L["New Items"],
		Description = L["New Items"],
		Matches = function(bag,slot,rule)
			if not (bag and slot) then return end
			if BagTypes[bag] ~= 1 then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				return Baggins:IsNew(link)
			end
		end,
		GetName = function(rule)
			return L["New Items"]
		end,
})




-----------------------------------------------------------------------
-- Category

Baggins:AddCustomRule("Category", {
		DisplayName = L["Category"],
		Description = L["Items that match another category"],
		Matches = function(bag,slot,rule)
			if not (bag and slot and rule.category) then return end
			local key = bag..":"..slot
			if BagTypes[bag] == 2 then
				return bankcategorycache[rule.category] and bankcategorycache[rule.category][key]
			else
				return categorycache[rule.category] and categorycache[rule.category][key]
			end
		end,
		GetName = function(rule)
			if rule.category then
				return L["Category"].." :"..rule.category
			else
				return L["Category"]
			end
		end,
		Ace3Options = {
			category = {
				name = L["Category"],
				desc = "",
				type = 'select',
				values = function()
						local tmp = {}
						for k in pairs(Baggins.db.profile.categories) do
							tmp[k] = k
						end
						return tmp
					end,
			},
		},
})

-----------------------------------------------------------------------
-- Quality

Baggins:AddCustomRule("Quality", {
		DisplayName = L["Quality"],
		Description = L["Filter by Item Quality"],
		Matches = function(bag,slot,rule)
			if not (rule.comp and rule.quality) then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local Rarity = select(3, GetItemInfo(link))
				if Rarity then
					return ( rule.comp == "==" and Rarity == rule.quality ) or
					       ( rule.comp == "<=" and Rarity <= rule.quality ) or
					       ( rule.comp == ">=" and Rarity >= rule.quality )
				end
			end
		end,
		GetName = function(rule)
			local qualname
			if rule.quality then
				local r,g,b,hex = GetItemQualityColor(rule.quality)
				qualname = hex..QualityNames[rule.quality]
			else
				qualname = "*none*"
			end
			return L["Quality"].." "..(rule.comp or "==").." "..qualname
		end,
		Ace3Options = {
			comp = {
				type = 'select',
				name = L["Comparison"],
				desc = "",
				values = {
					["=="] = "==",
					["<="] = "<=",
					[">="] = ">=",
				},
			},
			quality = {
				name = L["Quality"],
				desc = "",
				type = "select",
				values = QualityNames,
			}
		},
		CleanRule = function(rule)
			rule.quality = 1
			rule.comp = "=="
		end,
})


-----------------------------------------------------------------------
-- EquipLoc

Baggins:AddCustomRule("EquipLoc", {
		DisplayName = L["Equip Location"],
		Description = L["Filter by Equip Location as returned by GetItemInfo"],
		Matches = function(bag,slot,rule)
			if not rule.equiploc then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local EquipLoc = select(9, GetItemInfo(link))
				if EquipLoc then
					return EquipLoc == rule.equiploc
				end
			end
		end,
		GetName = function(rule)
			return "Equip Location: "..(_G[rule.equiploc] or rule.equiploc or "*None*")
		end,
		Ace3Options = {
			equiploc = {
				name = L["Location"],
				desc = "",
				type = 'select',
				values = EquipLocs2,
			},
		},
		CleanRule = function(rule)
			rule.equiploc = EquipLocs[1]
		end,
})



-----------------------------------------------------------------------
-- ItemLevel

Baggins:AddCustomRule("ItemLevel", {
		DisplayName = L["Item Level"],
		Description = L["Filter by item's level - either \"ilvl\" or minimum required level"],
		Matches = function(bag,slot,rule)
			local link = GetContainerItemLink(bag, slot)
			if not link then return false end

			local _,_,_, itemLevel, itemMinLevel = GetItemInfo(link)
			local lvl = rule.useminlvl and itemMinLevel or itemLevel

			if not lvl then	-- can happen if itemcache hasn't been updated yet
				return false
			end

			if rule.include0 and lvl==0 then
				return true
			end
			if rule.include1 and lvl==1 then
				return true
			end

			local minlvl = rule.minlvl or -9999
			local maxlvl = rule.maxlvl or 9999
			if rule.minlvl_rel then
				minlvl = UnitLevel("player")+minlvl
			end
			if rule.maxlvl_rel then
				maxlvl = UnitLevel("player")+maxlvl
			end

			return lvl>=minlvl and lvl<=maxlvl
		end,
		GetName = function(rule)
			local minlvl = rule.minlvl or -9999
			local maxlvl = rule.maxlvl or 9999
			if rule.minlvl_rel then
				minlvl = UnitLevel("player")+minlvl
			end
			if rule.maxlvl_rel then
				maxlvl = UnitLevel("player")+maxlvl
			end
			return (rule.useminlvl and L["ReqLvl"] or L["ILvl"]) .. ": " ..
				(rule.include0 and "0, " or "") ..
				(rule.include1 and "1, " or "") ..
				max(minlvl,0) .. "-" ..
				min(maxlvl,9999);
		end,
		Ace3Options = {
			include0 = {
				name = L["Include Level 0"],
				desc = "",
				type = 'toggle',
				order = 10,
			},
			include1 = {
				name = L["Include Level 1"],
				desc = "",
				type = 'toggle',
				order = 11,
			},
			useminlvl = {
				name = L["Look at Required Level"],
				desc = "Look at 'minimum level required' rather than item level",
				descStyle = "inline",
				type = 'toggle',
				order = 12,
				width = "full"
			},
			minlvl = {
				name = L["From level:"],
				desc = "",
				type = 'input',
				set = function(info, value)
						info.arg.minlvl = tonumber(value)
						Baggins:OnRuleChanged()
					end,
				get = function(info)
						return tostring(info.arg.minlvl or "")
					end,
				validate = function(info, value)
						return tonumber(value) ~= nil
					end,
				order = 20,
			},
			minlvl_rel = {
				name = L["... plus Player's Level"],
				desc = "",
				type = 'toggle',
				order = 21,
			},
			maxlvl = {
				name = L["To level:"],
				desc = "",
				type = 'input',
				set = function(info, value)
						info.arg.maxlvl = tonumber(value)
						Baggins:OnRuleChanged()
					end,
				get = function(info)
						return tostring(info.arg.maxlvl or "")
					end,
				validate = function(info, value)
						return tonumber(value) ~= nil
					end,
				order = 30,
			},
			maxlvl_rel = {
				name = L["... plus Player's Level"],
				desc = "",
				type = 'toggle',
				order = 31,
			},
		},
		CleanRule = function(rule)
			rule.include0 = true
			rule.include1 = false
			rule.useminlvl = false
			rule.minlvl_rel = true
			rule.minlvl = -15
			rule.maxlvl_rel = true
			rule.maxlvl = 10
		end,
})



-----------------------------------------------------------------------
-- Other

Baggins:AddCustomRule("Other", {
		DisplayName = L["Unfiltered Items"],
		Description = L["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"],
		Matches = function(bag,slot,rule)

			--local key = bag..":"..slot
			--return not useditems[key]
		end,
		GetName = function(rule)
			return L["Unfiltered"]
		end,
})



-----------------------------------------------------------------------
-- Bind

local BankButtonIDToInvSlotID = BankButtonIDToInvSlotID

Baggins:AddCustomRule("Bind", {
		DisplayName = L["Bind"],
		Description = L["Filter based on if the item binds, or if it is already bound"],
		Matches = function(bag, slot, rule)
			local status = rule.status
			if not status then return	end
			if bag == -1 then
				gratuity:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
			else
				gratuity:SetBagItem(bag,slot)
			end
			if status == 'unset' or status == 'unbound' then
				return not (gratuity:Find(_G.ITEM_SOULBOUND, 2, 6, false, true))
			end
			return (gratuity:Find(status, 2, 6, false, true))
		end,
		GetName = function(rule)
			if not rule.status then
				return L["Bind *unset*"]
			elseif rule.status == 'unbound' then
				return L["Unbound"]
			end
			return rule.status
		end,
		Ace3Options = {
			status = {
				name = L["Bind Type"],
				desc = "",
				type = 'select',
				values = {
					unbound = L["Unbound"],
					[ITEM_SOULBOUND] = ITEM_SOULBOUND,
					[ITEM_BIND_ON_EQUIP] = ITEM_BIND_ON_EQUIP,
					[ITEM_ACCOUNTBOUND] = ITEM_ACCOUNTBOUND,
					[ITEM_BIND_ON_USE] = ITEM_BIND_ON_USE,
				}
			},
		},
})





-----------------------------------------------------------------------
-- Tooltip

Baggins:AddCustomRule("Tooltip", {
		DisplayName = L["Tooltip"],
		Description = L["Filter based on text contained in its tooltip"],
		Matches = function(bag, slot, rule)
			if not rule.text then return end
			local text = rule.text
			--if the text is the name of a global string then match against that
			if text:upper() == text then
				local gtext = _G[rule.text]
				if type(gtext) == "string" then
					text = gtext
				end
			end
			if bag == -1 then
				gratuity:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
			else
				gratuity:SetBagItem(bag,slot)
			end
			if gratuity:Find(text) then
				return true
			end
		end,
		GetName = function(rule)
			return L["Tooltip"]..": "..(rule.text or "")
		end,
		Ace3Options = {
			text = {
				name = L["String to Match"],
				desc = "",
				type = 'input',
			},
		},
})

-----------------------------------------------------------------------
-- PTSet

---------------------
-- PT Set Browser  --
---------------------
function Baggins:BuildPTSetTable()
	if not (pt and self.ptsetsdirty) then
		return
	end
	wipe(ptsets)

	local sets = pt.sets
	for setname in pairs(sets) do
		local workingLevel = ptsets
		local oldLevel, oldParent, allowedFlag
		for parent in setname:gmatch("([^%.]+)") do
			if not workingLevel[parent] then
				workingLevel[parent] = {}
				allowedFlag = true
			else
				allowedFlag = false
			end
			for k, v in pairs(workingLevel) do
				local kname = k:match("0077ff([^%*]+)")
				if kname == parent then
					workingLevel[k] = nil
				end
			end

			oldLevel = workingLevel
			oldParent = parent
			workingLevel = workingLevel[parent]
		end
		if allowedFlag then
			oldLevel[oldParent] = false
		end
	end
	self.ptsetsdirty = false
end

local currentRule
local function buildMenu(tab, name)
	local menu = {}
	for k,v in pairs(tab) do
		local newName
		if not name then
			newName = k
		else
			newName = ("%s.%s"):format(name, k)
		end
		if not v then
			tinsert(menu, {
				text = k,
				func = function()
						currentRule.setname = newName
						AceConfigRegistry:NotifyChange("BagginsEdit")
						Baggins:OnRuleChanged()
					end,
			})
		elseif type(v) == 'table' then
			tinsert(menu, {
				text = k,
				hasArrow = true,
				menuList = buildMenu(v, newName),
				func = function()
						currentRule.setname = newName
						AceConfigRegistry:NotifyChange("BagginsEdit")
						Baggins:OnRuleChanged()
					end,
			})
		end
	end
	return menu
end

local ptdropdownFrame = CreateFrame("Frame", "Baggins_PTConfigMenuFrame", UIParent, "UIDropDownMenuTemplate")
local function showPTDropdown(info)
	local categoryname = info[#info-2]:sub(2)
	local ruleid = info[#info-1]
	local attr = info[#info]
	currentRule = info.arg
	local menu = buildMenu(ptsets)
	EasyMenu(menu, ptdropdownFrame, "cursor", 0, 0, "MENU")
end

if pt then
	Baggins.ptsetsdirty = true
	Baggins:BuildPTSetTable()
	Baggins:AddCustomRule("PTSet", {
		DisplayName = L["PeriodicTable Set"],
		Description = L["Filter by PeriodicTable Set"],
		Matches = function(bag,slot,rule)
			if not rule.setname then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local itemid = link:match("item:(%d+)")
				if not itemid then
					return false
				end
				itemid = tonumber(itemid)
				return pt:ItemInSet(itemid,rule.setname)
			end
		end,
		GetName = function(rule)
			return "PTSet:"..(rule.setname or "*none*")
		end,
		Ace3Options = {
			setname = {
				name = L["Edit"],
				desc = "",
				type = 'execute',
				func = showPTDropdown,
				order = 200,
			},
			description = {
				name = function(info) return info.arg.setname or "*" end,
				type = 'description',
				order = 199,
			}
		},
	})
end

-----------------------------------------------------------------------
-- Equipment Set
local equipmentSets = {}

local function updateSets()
	wipe(equipmentSets)
	for i = 1,GetNumEquipmentSets() do
		local setname = GetEquipmentSetInfo(i)
		equipmentSets[setname] = setname
	end
end

local function fullUpdateSets()
	updateSets()
	Baggins:ForceFullUpdate()
end

Baggins:RegisterEvent("EQUIPMENT_SETS_CHANGED", fullUpdateSets)
-- required when AddonLoader is not installed
Baggins:RegisterEvent("PLAYER_LOGIN", updateSets)
-- required when AddonLoader is installed
updateSets()

local function getEquipmentSetChoices()
	return equipmentSets
end

local function getSetValue(info, key)
	return info.arg.sets and info.arg.sets[key]
end

local function toggleSetValue(info, key, value)
	if not info.arg.sets then
		info.arg.sets = {}
	end
	info.arg.sets[key] = value
	Baggins:OnRuleChanged()
end

local function isAnySet(info)
	return info.arg.anyset
end

Baggins:AddCustomRule("EquipmentSet", {
	DisplayName = L["Equipment Set"],
	Description = L["Filter by Equipment Set"],
	GetName = function(rule)
			local result = ""
			if rule.anySet then
				return L["Any"]
			elseif rule.sets then
				for k in pairs(rule.sets) do
					result = result .. " " .. k
				end
			end
			return result
		end,
	Matches = function(bag, slot, rule)
			local _, item = GetContainerItemInfo(bag, slot)
			local inset, setstring = GetContainerItemEquipmentSetInfo(bag, slot)
			if not inset then return false end
			if rule.anyset then return true end
			if not rule.sets then return false end
			local sets = { (","):split(setstring) }
			for i,v in ipairs(sets) do
			local set = v:gsub("^ ", "") 
				if rule.sets[set] then
					return true
				end
			end
			return false
		end,
	Ace3Options = {
		anyset = {
			name = L["Any"],
			desc = "",
			type = 'toggle',
		},
		sets = {
			name = L["Equipment Sets"],
			desc = "",
			type = 'multiselect',
			values = getEquipmentSetChoices,
			get = getSetValue,
			set = toggleSetValue,
			disabled = isAnySet,
		},
	},
})

local INV_TYPES = {
  INVTYPE_HEAD = INVTYPE_HEAD,
  INVTYPE_NECK = INVTYPE_NECK,
  INVTYPE_SHOULDER = INVTYPE_SHOULDER,
  INVTYPE_BODY = INVTYPE_BODY,
  INVTYPE_CHEST = INVTYPE_CHEST,
  INVTYPE_ROBE = INVTYPE_ROBE,
  INVTYPE_WAIST = INVTYPE_WAIST,
  INVTYPE_LEGS = INVTYPE_LEGS,
  INVTYPE_FEET = INVTYPE_FEET,
  INVTYPE_WRIST = INVTYPE_WRIST,
  INVTYPE_HAND = INVTYPE_HAND,
  INVTYPE_FINGER = INVTYPE_FINGER,
  INVTYPE_TRINKET = INVTYPE_TRINKET,
  INVTYPE_CLOAK = INVTYPE_CLOAK,
  INVTYPE_WEAPON = INVTYPE_WEAPON,
  INVTYPE_SHIELD = INVTYPE_SHIELD,
  INVTYPE_2HWEAPON = INVTYPE_2HWEAPON,
  INVTYPE_WEAPONMAINHAND = INVTYPE_WEAPONMAINHAND,
  INVTYPE_WEAPONOFFHAND = INVTYPE_WEAPONOFFHAND,
  INVTYPE_HOLDABLE = INVTYPE_HOLDABLE,
  INVTYPE_RANGED = INVTYPE_RANGED,
  INVTYPE_THROWN = INVTYPE_THROWN,
  INVTYPE_RANGEDRIGHT = INVTYPE_RANGEDRIGHT,
  INVTYPE_RELIC = INVTYPE_RELIC,
  INVTYPE_TABARD = INVTYPE_TABARD,
  INVTYPE_BAG = INVTYPE_BAG,
  INVTYPE_QUIVER = INVTYPE_QUIVER,
}

local function getSlotValue(info, key)
	return info.arg.slots and info.arg.slots[key]
end

local function toggleSlotValue(info, key, value)
	if not info.arg.slots then
		info.arg.slots = {}
	end
	info.arg.slots[key] = value
	Baggins:OnRuleChanged()
end

Baggins:AddCustomRule("EquipmentSlot", {
	DisplayName = L["Equipment Slot"],
	Description = L["Filter by Equipment Slot"],
	GetName = function(rule)
			if not rule.slots then
				return ""
			end
			local slotlist = {}
			for k in pairs(rule.slots) do
				tinsert(slotlist, k)
			end
			local result = (","):join(slotlist)
			wipe(slotlist)
			return result
		end,
	Matches = function(bag, slot, rule)
			local itemId = GetContainerItemID(bag, slot)
			if not itemId then return end
			local _,_,_,_,_,_,_,_,equiploc = GetItemInfo(itemId)
			return rule.slots[equiploc] ~= nil
		end,
	Ace3Options = {
		slots = {
			name = L["Equipment Slots"],
			desc = "",
			type = 'multiselect',
			values = INV_TYPES,
			get = getSlotValue,
			set = toggleSlotValue,
		},
	},
})
