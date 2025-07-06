--[[ ==========================================================================

ItemType.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions
local pairs = pairs
local tostring = tostring
local tonumber = tonumber

-- WoW API
local GetItemClassInfo = C_Item and C_Item.GetItemClassInfo or GetItemClassInfo
local GetItemSubClassInfo = C_Item.GetItemSubClassInfo
local GetContainerItemID = C_Container and C_Container.GetContainerItemID or GetContainerItemID
local GetItemInfoInstant = C_Item and C_Item.GetItemInfoInstant or GetItemInfoInstant
local GetAuctionItemSubClasses = C_AuctionHouse and C_AuctionHouse.GetAuctionItemSubClasses or GetAuctionItemSubClasses

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local ItemTypes
if AddOn:IsRetailWow() then
    -- scanned Thu Jul 1 21:30:01 2021 - patch 9.1.0
    ItemTypes = {
        [0]="Consumable",
        [1]="Container",
        [2]="Weapon",
        [3]="Gem",
        [4]="Armor",
        [5]="Reagent",
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
        [16]="Glyph",
        [17]="Battle Pets",
        [18]="WoW Token"
    }
end
if AddOn:IsClassicWow() then
    -- scanned Thu Jul 1 15:27:04 2021 - patch 1.13.7
    ItemTypes = {
        [0]="Consumable",
        [1]="Container",
        [2]="Weapon",
        [3]="Jewelry(OBSOLETE)",
        [4]="Armor",
        [5]="Reagent",
        [6]="Projectile",
        [7]="Trade Goods",
        [8]="Generic(OBSOLETE)",
        [9]="Recipe",
        [10]="Money(OBSOLETE)",
        [11]="Quiver",
        [12]="Quest",
        [13]="Key",
        [14]="Permanent(OBSOLETE)",
        [15]="Miscellaneous",
        [18]="WoW Token"
    }
end

if AddOn:IsTBCWow() then
    -- scanned Thu Jul 1 16:14:05 2021 - patch 2.5.1
    ItemTypes = {
        [0]="Consumable",
        [1]="Container",
        [2]="Weapon",
        [3]="Gem",
        [4]="Armor",
        [5]="Reagent",
        [6]="Projectile",
        [7]="Trade Goods",
        [8]="Generic(OBSOLETE)",
        [9]="Recipe",
        [10]="Money(OBSOLETE)",
        [11]="Quiver",
        [12]="Quest",
        [13]="Key",
        [14]="Permanent(OBSOLETE)",
        [15]="Miscellaneous",
        [18]="WoW Token"
    }
end

if AddOn:IsWrathWow() then
    -- scanned Sun Sep 11 04:42:32 2022 - patch 3.4.0
    ItemTypes = {
        [0]="Consumable",
        [1]="Container",
        [2]="Weapon",
        [3]="Gem",
        [4]="Armor",
        [5]="Reagent",
        [6]="Projectile",
        [7]="Trade Goods",
        [8]="Generic(OBSOLETE)",
        [9]="Recipe",
        [10]="Money(OBSOLETE)",
        [11]="Quiver",
        [12]="Quest",
        [13]="Key",
        [14]="Permanent(OBSOLETE)",
        [15]="Miscellaneous",
        [16]="Glyph",
        [18]="WoW Token"
    }
end

if AddOn:IsCataWow() then
    -- scanned Fri May 3 15:20:54 2024 - patch 4.4.0
    ItemTypes = {
        [0]="Consumable",
        [1]="Container",
        [2]="Weapon",
        [3]="Gem",
        [4]="Armor",
        [5]="Reagent",
        [6]="Projectile",
        [7]="Trade Goods",
        [8]="Generic(OBSOLETE)",
        [9]="Recipe",
        [10]="Money(OBSOLETE)",
        [11]="Quiver",
        [12]="Quest",
        [13]="Key",
        [14]="Permanent(OBSOLETE)",
        [15]="Miscellaneous",
        [16]="Glyph",
        [18]="WoW Token"
    }
end

if AddOn:IsMistWow() then
    -- scanned Sun July 6 03:08:26 2025 - patch 5.5.0
    ItemTypes = {
        [0]="Consumable",
        [1]="Container",
        [2]="Weapon",
        [3]="Gem",
        [4]="Armor",
        [5]="Reagent",
--        [6]="Projectile", -- named but not used
        [7]="Trade Goods",
        [8]="Generic(OBSOLETE)",
        [9]="Recipe",
        [10]="Money(OBSOLETE)",
--        [11]="Quiver", -- named but not used
        [12]="Quest",
        [13]="Key",
        [14]="Permanent(OBSOLETE)",
        [15]="Miscellaneous",
        [16]="Glyph",
--        [17]="Battle Pets" -- named but not used
--        [18]="WoW Token" -- named but not used
    }
end

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


  -- Old Scan Method
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
--New Retail Scan
--print("--------------------------")
--print("-- scanned "..date("%c").. " - patch "..(GetBuildInfo()))
--for i = 0, NUM_LE_ITEM_CLASSS-1 do
--	print(i, GetItemClassInfo(i))
--end

local function Matches(bag,slot,rule)
    if not (rule.itype or rule.isubtype) then return end
    local itemid = GetContainerItemID(bag, slot)
    if itemid then
        local _, _, _, _, _, TypeID, SubTypeID = GetItemInfoInstant(itemid)
        if TypeID and SubTypeID then
            return TypeID == rule.itype and (rule.isubtype == nil or SubTypeID == rule.isubtype )
        end
    end
end

AddOn:AddCustomRule("ItemType",
    {
        DisplayName = L["Item Type"],
        Description = L["Filter by Item type and sub-type as returned by GetItemInfo"],
        Matches = Matches,
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
                        AddOn:OnRuleChanged()
                    end,
                values = function(info)
                        local rule = info.arg
                        local tmp = {}
                        tmp.ALL = ALL
                        if rule.itype and ItemTypes[rule.itype] then
                            if AddOn:IsClassicWow() or AddOn:IsTBCWow() or AddOn:IsWrathWow() or AddOn:IsCataWow() then
                                for _,k in pairs({GetAuctionItemSubClasses(rule.itype)}) do
                                    tmp[tostring(k)] = GetItemSubClassInfo(rule.itype, k) or "UNKNOWN"
                                end
                            end
                            if AddOn:IsRetailWow() or AddOn:IsMistWow() then -- mist now uses the retail format here
                                for _,k in pairs(GetAuctionItemSubClasses(rule.itype)) do
                                    tmp[tostring(k)] = GetItemSubClassInfo(rule.itype, k) or "UNKNOWN"
                                end
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
    }
)