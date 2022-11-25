--[[ ==========================================================================

EquipmentSet.lua

========================================================================== ]]--

--@retail@
local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions
local ipairs = _G.ipairs

-- WoW API
local GetEquipmentSetIDs = _G.C_EquipmentSet.GetEquipmentSetIDs
local GetEquipmentSetInfo = _G.C_EquipmentSet.GetEquipmentSetInfo
local GetContainerItemEquipmentSetInfo = _G.C_Container and _G.C_Container.GetContainerItemEquipmentSetInfo or _G.GetContainerItemEquipmentSetInfo
local GetContainerItemInfo = _G.C_Container and _G.C_Container.GetContainerItemInfo
local C_EquipmentSetGetItemIDs = _G.C_EquipmentSet and _G.C_EquipmentSet.GetItemIDs

-- Libs
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- Local storage
local EquipmentSets = {}

-- Update list of equipment sets
local function UpdateEquipmentSets()

    wipe(EquipmentSets)

    for _, id in next, GetEquipmentSetIDs() do
        local name = GetEquipmentSetInfo(id)
        EquipmentSets[name] = name
    end

end

-- Get argument 'sets'
local function GetOptionSets(info, key)

    return info.arg.sets and info.arg.sets[key]

end

-- Set argument 'sets'
local function SetOptionSets(info, key, value)

    if not info.arg.sets then
        info.arg.sets = {}
    end

    info.arg.sets[key] = value
    AddOn:OnRuleChanged()

end

-- Test for 'Any' set
local function isAnySet(info)

    return info.arg.anyset

end

-- Test for match
local function Matches(bag, slot, rule)

    -- Item belongs to a set?
    local inset, setstring = GetContainerItemEquipmentSetInfo(bag, slot)
    if not inset then
        for _, id in next, GetEquipmentSetIDs() do
            local name, _, _, _, _, _, _, _, _ = GetEquipmentSetInfo(id)
            local items = C_EquipmentSetGetItemIDs(id)
            for i = 1, 19 do
                if items[i] then
                    local setitemid = items[i]
                    local containerInfo = GetContainerItemInfo(bag, slot)
                    if name and containerInfo and setitemid == containerInfo.itemID then
                        inset = true
                        setstring = name
                    end
                end
            end
        end
    end

    if not inset then
        return false
    end

    -- Match all sets?
    if rule.anyset then
        return true
    end

    -- Empty rule?
    if not rule.sets then
        return false
    end

    -- Item belongs to a set in rule.sets[]?
    local sets = { (","):split(setstring) }
    for _, v in ipairs(sets) do
    local set = v:gsub("^ ", "")
        if rule.sets[set] then
            return true
        end
    end

    return false

end

-- Register filter
AddOn:AddCustomRule(
    "EquipmentSet",
    {
        DisplayName = L["Equipment Set"],
        Description = L["Filter by Equipment Set"],
        Matches = Matches,
        Ace3Options =
        {
            anyset =
            {
                name = L["Any"],
                type = "toggle",
            },
            sets =
            {
                name = L["Equipment Sets"],
                type = "multiselect",
                values = EquipmentSets,
                get = GetOptionSets,
                set = SetOptionSets,
                disabled = isAnySet,
            },
        },
    }
)

-- Initialize filter
AddOn:RegisterEvent("EQUIPMENT_SETS_CHANGED", UpdateEquipmentSets)
AddOn:RegisterEvent("PLAYER_LOGIN", UpdateEquipmentSets)
UpdateEquipmentSets()

--@end-retail@