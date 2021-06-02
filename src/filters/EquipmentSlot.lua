--[[ ==========================================================================

EquipmentSlot.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions

-- WoW API
local GetContainerItemID = _G.GetContainerItemID
local GetItemInfoInstant = _G.GetItemInfoInstant

-- Libs
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local INV_TYPES = {
    INVTYPE_HEAD = _G.INVTYPE_HEAD,
    INVTYPE_NECK = _G.INVTYPE_NECK,
    INVTYPE_SHOULDER = _G.INVTYPE_SHOULDER,
    INVTYPE_BODY = _G.INVTYPE_BODY,
    INVTYPE_CHEST = _G.INVTYPE_CHEST,
    INVTYPE_ROBE = _G.INVTYPE_ROBE,
    INVTYPE_WAIST = _G.INVTYPE_WAIST,
    INVTYPE_LEGS = _G.INVTYPE_LEGS,
    INVTYPE_FEET = _G.INVTYPE_FEET,
    INVTYPE_WRIST = _G.INVTYPE_WRIST,
    INVTYPE_HAND = _G.INVTYPE_HAND,
    INVTYPE_FINGER = _G.INVTYPE_FINGER,
    INVTYPE_TRINKET = _G.INVTYPE_TRINKET,
    INVTYPE_CLOAK = _G.INVTYPE_CLOAK,
    INVTYPE_WEAPON = _G.INVTYPE_WEAPON,
    INVTYPE_SHIELD = _G.INVTYPE_SHIELD,
    INVTYPE_2HWEAPON = _G.INVTYPE_2HWEAPON,
    INVTYPE_WEAPONMAINHAND = _G.INVTYPE_WEAPONMAINHAND,
    INVTYPE_WEAPONOFFHAND = _G.INVTYPE_WEAPONOFFHAND,
    INVTYPE_HOLDABLE = _G.INVTYPE_HOLDABLE,
    INVTYPE_RANGED = _G.INVTYPE_RANGED,
    INVTYPE_THROWN = _G.INVTYPE_THROWN,
    INVTYPE_RANGEDRIGHT = _G.INVTYPE_RANGEDRIGHT,
    INVTYPE_RELIC = _G.INVTYPE_RELIC,
    INVTYPE_TABARD = _G.INVTYPE_TABARD,
    INVTYPE_BAG = _G.INVTYPE_BAG,
    INVTYPE_QUIVER = _G.INVTYPE_QUIVER,
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