--[[ ==========================================================================

Baggins-Filtering.lua

========================================================================== ]]--

local Baggins = Baggins

-- TODO: Clean up this section
-- LUA Functions
local pairs, ipairs, type, tonumber, wipe =
      pairs, ipairs, type, tonumber, wipe
local tinsert, tsort =
      tinsert, table.sort

-- TODO: Clean up this section
-- WoW API
local BANK_CONTAINER = BANK_CONTAINER or 2
local BACKPACK_CONTAINER = BACKPACK_CONTAINER
local REAGENTBANK_CONTAINER = REAGENTBANK_CONTAINER or -3
local KEYRING_CONTAINER = Enum.BagIndex.Keyring
local REAGENT_CONTAINER = Baggins:IsRetailWow() and Enum.BagIndex.ReagentBag or math.huge
local NUM_BAG_SLOTS = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
local NUM_BANKBAGSLOTS = NUM_BANKBAGSLOTS or 7

local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local GetContainerNumFreeSlots = C_Container and C_Container.GetContainerNumFreeSlots or GetContainerNumFreeSlots
local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local C_Item, ItemLocation = C_Item, ItemLocation

-- Libs
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)
local LibStub = LibStub
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
    if Baggins:IsClassicWow() or Baggins:IsTBCWow() or Baggins:IsWrathWow() then
        BagTypes[KEYRING_CONTAINER] = 3
    end


    -- Retail specific bag
    if Baggins:IsRetailWow() then
        BagTypes[REAGENTBANK_CONTAINER] = 4
        BagTypes[REAGENT_CONTAINER] = 5
    end

end

-- TODO: Lots of cleaning up belopw this line :)
-- ... old code ...

local RuleTypes = {}

local categorycache = {}
local bankcategorycache = {}
local useditems = {}
local slotcache = {}

function Baggins:GetCategoryCache() --luacheck: ignore 212
    return categorycache
end

function Baggins:GetBankCategoryCache() --luacheck: ignore 212
    return bankcategorycache
end

function Baggins:GetBagTypes() --luacheck: ignore 212
    return BagTypes
end

local bankuseditems = {}

local categories

function Baggins:SetCategoryTable(cats) --luacheck: ignore 212
    categories = cats
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
    if BagTypes[bag] == 5 then
        return "re"
    end
    if bag>=1 and bag<= 11 then
        local _,fam = GetContainerNumFreeSlots(bag)

        if Baggins:IsClassicWow() or Baggins:IsTBCWow() or Baggins:IsWrathWow() or Baggins:IsCataWow() or Baggins:IsMistWow() then
            if type(fam)~="number" then --luacheck: ignore 542
                -- assume normal bag
            elseif fam==0 then --luacheck: ignore 542
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
        end

        if Baggins:IsRetailWow() then
            if type(fam)~="number" then --luacheck: ignore 542
                -- assume normal bag
                --Baggins:Debug('IsSpecialBag Got Normal Bag')
            elseif fam==0 then --luacheck: ignore 542
                -- normal bag
                --Baggins:Debug('IsSpecialBag Got Normal Bag')
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
  
      local itemInfo = GetContainerItemInfo(bag, slot)
      local count = itemInfo and itemInfo.stackCount
      local link = itemInfo and itemInfo.hyperlink
  
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
    if type(categories) ~= "table" then
        self:SetCategoryTable(self.db.profile.categories)
    end
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
    self:Baggins_CategoriesChanged()
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
    if not Baggins:IsCataWow() and not Baggins:IsMistWow() then
        self:CheckSlotsChanged(-2,true)
    end
    self:CheckSlotsChanged(-1,true)
    self:Baggins_CategoriesChanged()
end

function Baggins:ForceFullBankUpdate()
    for bagid in LBU:IterateBags("BANK") do
        self:CheckSlotsChanged(bagid, true)
    end
    if Baggins:IsRetailWow() then
        for bagid in LBU:IterateBags("REAGENTBANK") do
            self:CheckSlotsChanged(bagid, true)
        end
    end

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

-- Initialize module
BuildBagTypes()
