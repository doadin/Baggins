--[[ ==========================================================================

Baggins-Filtering.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName] --luacheck: ignore 211
local Baggins = _G.Baggins

-- TODO: Clean up this section
-- LUA Functions
local pairs, ipairs, type, tonumber, tostring, format, min, max, wipe =
      _G.pairs, _G.ipairs, _G.type, _G.tonumber, _G.tostring, _G.format, _G.min, _G.max, _G.wipe
local tinsert, tsort =
      _G.tinsert, _G.table.sort

-- TODO: Clean up this section
-- WoW API
local BANK_CONTAINER = _G.BANK_CONTAINER

local GetItemInfo, GetContainerItemLink, GetContainerItemID, GetContainerItemInfo, GetContainerNumFreeSlots, GetContainerNumSlots =
      _G.GetItemInfo, _G.GetContainerItemLink, _G.GetContainerItemID, _G.GetContainerItemInfo, _G.GetContainerNumFreeSlots, _G.GetContainerNumSlots
local GetItemInfoInstant, GetItemClassInfo, GetItemSubClassInfo =
      _G.GetItemInfoInstant, _G.GetItemClassInfo, _G.GetItemSubClassInfo
local UnitLevel = _G.UnitLevel
local C_Item, ItemLocation = _G.C_Item, _G.ItemLocation
local BankButtonIDToInvSlotID = _G.BankButtonIDToInvSlotID
--[===[@non-retail@
local GetAuctionItemSubClassesGetAuctionItemSubClasses = _G.GetAuctionItemSubClasses
--@end-non-retail@]===]
--@retail@
local GetAuctionItemSubClasses = _G.C_AuctionHouse.GetAuctionItemSubClasses
--@end-retail@

-- Libs
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)
local LG = LibStub("LibGratuity-3.0") --luacheck: ignore 211
local LIUI = LibStub("LibItemUpgradeInfo-1.0") --luacheck: ignore 211
local LBU = LibStub("LibBagUtils-1.0")

-- Local storage
local BagTypes = {}

-- Build list of bag types
local function BuildBagTypes()

    -- Common bags
    BagTypes[BACKPACK_CONTAINER] = 1
    BagTypes[BANK_CONTAINER] = 2

    for i = 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do

        if i <= NUM_BAG_SLOTS then
            BagTypes[i] = 1 -- Bags
        else
            BagTypes[i] = 2 -- Bank bags
        end

    end

    -- Classic specific bag
    --[===[@non-retail@
    BagTypes[KEYRING_CONTAINER] = 3
    --@end-non-retail@]===]

    -- Retail specific bag
    --@retail@
    BagTypes[REAGENTBANK_CONTAINER] = 4
    --@end-retail@

end

-- TODO: Lots of cleaning up belopw this line :)
-- ... old code ...

local RuleTypes = {}

local categorycache = {}
local useditems = {}
local slotcache = {}

function Baggins:GetCategoryCache() --luacheck: ignore 212
    return categorycache
end

local bankuseditems = {}
local bankcategorycache = {}

local categories

function Baggins:SetCategoryTable(cats) --luacheck: ignore 212
    categories = cats
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

function Baggins:AddCustomRule(ruletype,description) --luacheck: ignore 212
    RuleTypes[ruletype] = description
end

--removes any fields not used by the current rule type and sets up defaults if needed
function Baggins:CleanRule(rule) --luacheck: ignore 212
    wipe(rule)
    rule.type = type

    if RuleTypes[rule.ruletype].CleanRule then
        RuleTypes[rule.ruletype].CleanRule(rule)
    end
end



function Baggins:OpenRuleDewdrop(rule,...) --luacheck: ignore 212
    if RuleTypes[rule.type] then
        RuleTypes[rule.type].DewDropOptions(rule, ...)
    end
end

function Baggins:RuleTypeIterator(sorted) --luacheck: ignore 212
    if not sorted then
        return pairs(RuleTypes)
    end
    local t = {}
    for k,_ in pairs(RuleTypes) do
        tinsert(t,k)
    end
    tsort(t, function(a,b) return RuleTypes[a].DisplayName < RuleTypes[b].DisplayName end)
    local i=0
    return function(k) --luacheck: ignore 212
        i=i+1
        local rt=t[i]
        if not rt then
            return nil,nil
        end
        return rt, RuleTypes[rt]
    end
end

local types = {}
function Baggins:GetRuleTypes() --luacheck: ignore 212
    wipe(types)
    for k,v in pairs(RuleTypes) do
        types[k] = v.DisplayName
    end
    return types
end

-- TODO: [#24] https://github.com/doadin/Baggins/issues/24
function Baggins:GetRuleDesc(rule) --luacheck: ignore 212
    assert(rule, "Baggins Plugin attemped use of GetRuleDesc please report this along with plugins in use to Baggins author. Thanks!")
    if RuleTypes[rule.type] then
        return RuleTypes[rule.type].GetName(rule)
    else
        return format("(|cffff8080%s not loaded|r)", rule.type);
    end
end

function Baggins:GetAce3Opts(rule) --luacheck: ignore 212
    if RuleTypes[rule.type] then
        return RuleTypes[rule.type].Ace3Options
    end
end

function Baggins:RuleIsDeprecated(rule) --luacheck: ignore 212
    local ruleType = RuleTypes[rule.type]
    if not ruleType then return true end
    if ruleType.Ace3Options then return end
    return ruleType.DewDropOptions ~= nil
end

function Baggins:IsSpecialBag(bag) --luacheck: ignore 212
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
    if BagTypes[bag] == 4 then
        return "r"
    end
    if bag>=1 and bag<= 11 then
        local _,fam = GetContainerNumFreeSlots(bag)

        --[===[@non-retail@
        if type(fam)~="number" then
            -- assume normal bag
        elseif fam==0 then
            -- normal bag
        elseif fam==1 or fam==2 then	-- quiver / ammo
            return prefix.."a", fam
        elseif fam==3 then		-- soul
            return prefix.."s", fam
        elseif fam==4 then		-- leatherworking?
            return prefix.."l", fam
        elseif fam==5 then		-- inscription?
            return prefix.."i", fam
        elseif fam==6 then		-- herb
            return prefix.."h", fam
        elseif fam==7 then		-- eNchant
            return prefix.."n", fam
        elseif fam==8 then	-- engineering
            return prefix.."e", fam
        elseif fam==9 then	-- keyring
            return prefix.."k", fam
        elseif fam==10 then	-- gems?
            return prefix.."g", fam
        elseif fam==11 then	-- mining?
            return prefix.."m", fam
        else
            return prefix.."?", fam
        end
        --@end-non-retail@]===]

        --@retail@
        if type(fam)~="number" then --luacheck: ignore 542
            -- assume normal bag
            --self:Debug('IsSpecialBag Got Normal Bag')
        elseif fam==0 then --luacheck: ignore 542
            -- normal bag
            --self:Debug('IsSpecialBag Got Normal Bag')
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
        --@end-retail@

    end

    if prefix ~= "" then
        return prefix, 0
    end
    return nil,0
end

--------------------
-- Item Filtering --
--------------------
function Baggins:CheckSlotsChanged(bag, forceupdate)
  local itemschanged
  for slot = 1, GetContainerNumSlots(bag) do
    local key = bag..":"..slot
    local iteminfo = nil
    local itemid

    local _, count, _, _, _, _, link = GetContainerItemInfo(bag, slot)
    if link then
      itemid = C_Item.GetItemID(ItemLocation:CreateFromBagAndSlot(bag, slot))
    end
    if itemid then
      -- "|cffffffff|Hitem:6948::::::::1:259::::::|h[Hearthstone]|h|r"
      -- "|cff1eff00|Hbattlepet:261:1:2:151:11:10:0000000000000000|h[Personal World Destroyer]|h|r",
      -- "|cffa335ee|Hkeystone:198:9:5:13:0|h[Keystone: Darkheart Thicket]|h|r"
      local itemstring = link:match("|H(.-)|h") or "_"
      iteminfo = ("%s %d %s"):format(itemid, count, itemstring)
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
    if BagTypes[bag] == 2 or BagTypes[bag] == 4 then
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


    for catid, _ in pairs(categories) do
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

function Baggins:ClearSortingCaches() --luacheck: ignore 212
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
    --@retail@
    for bagid in LBU:IterateBags("REAGENTBANK") do
        self:CheckSlotsChanged(bagid, true)
    end
    --@end-retail@

end

function Baggins:GetIncludeRule(category,create) --luacheck: ignore 212
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

function Baggins:GetExcludeRule(category,create) --luacheck: ignore 212
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

    for _, rule in ipairs(cat) do
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

    for _, rule in ipairs(cat) do
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

function Baggins:GetRuleDefinition(rulename) --luacheck: ignore 212
    return RuleTypes[rulename]
end

function Baggins:GetCachedItem(item) --luacheck: ignore 212
    return slotcache[item]
end

-----------------------------------------------------------------------
-- ItemType

--------------------------
-- Baggins: AH category scanned 2016-07-21 22:56:38 - patch 7.0.3

local ItemTypes = {
  [1]="Container",
  [2]="Weapon",
  [3]="Gem",
  [4]="Armor",
  [5]="Reagent",--won't use in classic --
  [6]="Projectile",
  [7]="Tradeskill",
  [8]="Item Enhancement",
  [9]="Recipe",
  [10]="Money(OBSOLETE)",
  [11]="Quiver",
  [12]="Quest",
  [13]="Key",
  [14]="Permanent(OBSOLETE)",
  [15]="Miscellaneous",
  [16]="Glyph",--won't use in classic --
  [17]="Battle Pets",--won't use in classic --
  [18]="WoW Token",--won't use in classic --
  [0]="Consumable"
}

--[[
local ItemTypes = {
 ["Weapon"] = {"One-Handed Axes", "Two-Handed Axes", "Bows", "Guns", "One-Handed Maces", "Two-Handed Maces", "Polearms", "One-Handed Swords", "Two-Handed Swords", "Staves", "Fist Weapons", "Miscellaneous", "Daggers", "Thrown", "Crossbows", "Wands", "Fishing Poles"},
 ["Armor"] = {"Miscellaneous", "Cloth", "Leather", "Mail", "Plate", "Cosmetic", "Shields"},
 ["Container"] = {"Bag", "Herb Bag", "Enchanting Bag", "Engineering Bag", "Gem Bag", "Mining Bag", "Leatherworking Bag", "Inscription Bag", "Tackle Box", "Cooking Bag"},
 ["Gem"] = {"Red", "Blue", "Yellow", "Purple", "Green", "Orange", "Meta", "Simple", "Prismatic", "Cogwheel"},
 ["Consumable"] = {"Food & Drink", "Potion", "Elixir", "Flask", "Bandage", "Item Enhancement", "Scroll", "Other"},
 ["Glyph"] = {"Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Death Knight", "Shaman", "Mage", "Warlock", "Monk", "Druid"},
 ["Item Enhancement"] = {},
 ["Trade Goods"] = {"Elemental", "Cloth", "Leather", "Metal & Stone", "Cooking", "Herb", "Enchanting", "Jewelcrafting", "Parts", "Devices", "Explosives", "Materials", "Other", "Item Enchantment"},
 ["Quest"] = {},
 ["Recipe"] = {"Book", "Leatherworking", "Tailoring", "Engineering", "Blacksmithing", "Cooking", "Alchemy", "First Aid", "Enchanting", "Fishing", "Jewelcrafting", "Inscription"},
 ["Miscellaneous"] = {"Junk", "Reagent", "Companion Pets", "Holiday", "Other", "Mount"},
 ["Battle Pets"] = {"Humanoid", "Dragonkin", "Flying", "Undead", "Critter", "Magic", "Elemental", "Beast", "Aquatic", "Mechanical"},
}--]]


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
            local itemid = GetContainerItemID(bag, slot)
            if itemid then
                local _, _, _, _, _, TypeID, SubTypeID = GetItemInfoInstant(itemid)
                if TypeID and SubTypeID then
                    return TypeID == rule.itype and (rule.isubtype == nil or SubTypeID == rule.isubtype )
                end
            end
        end,
        GetName = function(rule)
            local ltype, lsubtype = "*", "*"
            if rule.itype then
                ltype = GetItemClassInfo(rule.itype) or "?"
            end
            if rule.isubtype then
                lsubtype = GetItemSubClassInfo(rule.itype, rule.isubtype) or "?"
            end
            return L["ItemType - "]..ltype..":"..lsubtype
        end,
        Ace3Options = {
            itype = {
                type = 'select',
                name = L["Item Type"],
                desc = "",
                values = function(info) --luacheck: ignore 212
                        local tmp = {}
                        for i in pairs(ItemTypes) do
                            tmp[i] = GetItemClassInfo(i)
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
                        return tostring(info.arg.isubtype or "ALL")
                    end,
                set = function(info, value)
                        local rule = info.arg
                        if value == "ALL" then
                            rule.isubtype = nil
                        else
                            rule.isubtype = tonumber(value)
                        end
                        Baggins:OnRuleChanged()
                    end,
                values = function(info)
                        local rule = info.arg
                        local tmp = {}
                        tmp.ALL = _G.ALL
                        if rule.itype and ItemTypes[rule.itype] then

                            --[===[@non-retail@
                            for _,k in pairs({GetAuctionItemSubClasses(rule.itype)}) do
                            --@end-non-retail@]===]
                            --@retail@
                            for _,k in pairs(GetAuctionItemSubClasses(rule.itype)) do
                            --@end-retail@
                                tmp[tostring(k)] = GetItemSubClassInfo(rule.itype, k) or UNKNOWN
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
            local itemid = GetContainerItemID(bag, slot)
            return rule.ids[itemid]
        end,
        GetName = function(rule) --luacheck: ignore 212
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
-- Empty

Baggins:AddCustomRule("Empty", {
        DisplayName = L["Empty Slots"],
        Description = L["Empty bag slots"],
        Matches = function(bag,slot,_)
            if not (bag and slot) then return end
            if BagTypes[bag] == 3 then return end
            local link = GetContainerItemLink(bag, slot)
            if not link then
                return true
            end
        end,
        GetName = function()
            return L["Empty Slots"]
        end,
})


-----------------------------------------------------------------------
-- NewItems

Baggins:AddCustomRule("NewItems", {
        DisplayName = L["New Items"],
        Description = L["New Items"],
        Matches = function(bag,slot)
            if not (bag and slot) then return end
            if BagTypes[bag] ~= 1 then return end
            local link = GetContainerItemLink(bag, slot)
            if link then
                return Baggins:IsNew(link)
            end
        end,
        GetName = function()
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
            if BagTypes[bag] == 2 or BagTypes[bag] == 4 then
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
-- EquipLoc

Baggins:AddCustomRule("EquipLoc", {
        DisplayName = L["Equip Location"],
        Description = L["Filter by Equip Location as returned by GetItemInfo"],
        Matches = function(bag,slot,rule)
            if not rule.equiploc then return end
            local link = GetContainerItemLink(bag, slot)
            if link then
                local _, _, _, EquipLoc = GetItemInfoInstant(link)
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

            local _,_,_, itemLevel, itemMinLevel = GetItemInfo(link) --luacheck: ignore 211
            local itemLevel = LIUI:GetUpgradedItemLevel(link) --luacheck: ignore 411
            -- local itemLevel = GetDetailedItemLevelInfo(link)
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
                validate = function(info, value) --luacheck: ignore 212
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
                validate = function(info, value) --luacheck: ignore 212
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
        Matches = function()

            --local key = bag..":"..slot
            --return not useditems[key]
        end,
        GetName = function()
            return L["Unfiltered"]
        end,
})



-----------------------------------------------------------------------
-- Bind

Baggins:AddCustomRule("Bind", {
        DisplayName = L["Bind"],
        Description = L["Filter based on if the item binds, or if it is already bound"],
        Matches = function(bag, slot, rule)
            local status = rule.status
            if not status then return	end
            if bag == -1 then
                LG:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
            else
                LG:SetBagItem(bag,slot)
            end
            if status == 'unset' or status == 'unbound' then
                return not (LG:Find(_G.ITEM_SOULBOUND, 2, 6, false, true))
            end
            return (LG:Find(status, 2, 6, false, true))
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
            if not rule.slots then
                return ""
            end
            if not itemId then return end
            local _, _, _, equiploc = GetItemInfoInstant(itemId)
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

-- Initialize module
BuildBagTypes()
