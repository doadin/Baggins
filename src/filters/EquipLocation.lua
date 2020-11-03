--[[ ==========================================================================

EquipLocation.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local GetContainerItemLink = _G.GetContainerItemLink
local GetItemInfoInstant = _G.GetItemInfoInstant

-- Libs
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

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

local function Matches(bag,slot,rule)
    if not rule.equiploc then return end
    local link = GetContainerItemLink(bag, slot)
    if link then
        local _, _, _, EquipLoc = GetItemInfoInstant(link)
        if EquipLoc then
            return EquipLoc == rule.equiploc
        end
    end
end

AddOn:AddCustomRule("EquipLoc",
    {
        DisplayName = L["Equip Location"],
        Description = L["Filter by Equip Location as returned by GetItemInfo"],
        Matches = Matches,
        GetName = GetName,
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
    }
)