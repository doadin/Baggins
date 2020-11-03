--[[ ==========================================================================

EquipmentSlot.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions
local pairs = _G.pairs

-- WoW API
local GetContainerItemID = _G.GetContainerItemID
local GetItemInfoInstant = _G.GetItemInfoInstant

-- Libs
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

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
    AddOn:OnRuleChanged()
end

local function Matches(bag, slot, rule)
    local itemId = GetContainerItemID(bag, slot)
    if not rule.slots then
        return ""
    end
    if not itemId then return end
    local _, _, _, equiploc = GetItemInfoInstant(itemId)
    return rule.slots[equiploc] ~= nil
end

AddOn:AddCustomRule("EquipmentSlot",
    {
        DisplayName = L["Equipment Slot"],
        Description = L["Filter by Equipment Slot"],
        GetName = GetName,
        Matches = Matches,
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
    }
)