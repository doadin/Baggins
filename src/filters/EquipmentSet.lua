--[[ ==========================================================================

EquipmentSet.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions
local ipairs = ipairs

-- WoW API
local GetEquipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs
local GetEquipmentSetInfo = C_EquipmentSet.GetEquipmentSetInfo
local GetContainerItemEquipmentSetInfo = C_Container and C_Container.GetContainerItemEquipmentSetInfo
local C_EquipmentSetGetItemLocations = C_EquipmentSet and C_EquipmentSet.GetItemLocations
local EquipmentManager_UnpackLocation = EquipmentManager_UnpackLocation

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- Local storage
local EquipmentSets = {}
local itemstable = {}

local function UpdateCache()
    itemstable = {}

    for _, id in next, GetEquipmentSetIDs() do
        local name = GetEquipmentSetInfo(id)
        local itemLocations = C_EquipmentSetGetItemLocations(id)
        for _, location in pairs(itemLocations) do
            --location player, bank, bags, voidStorage, slot, bag
            local slot, bag = select(5,EquipmentManager_UnpackLocation(location)), select(6,EquipmentManager_UnpackLocation(location))
            if slot and bag then
                if not itemstable[bag] then
                    itemstable[bag] = {}
                end
                if itemstable[bag] and itemstable[bag][slot] then
                    local otherSet = itemstable[bag][slot]
                    local newSet = otherSet .. "," .. name
                    itemstable[bag][slot] = newSet
                else
                    itemstable[bag][slot] = name
                end
            end
        end
    end
end

-- Update list of equipment sets
local function UpdateEquipmentSets()

    wipe(EquipmentSets)

    for _, id in next, GetEquipmentSetIDs() do
        local name = GetEquipmentSetInfo(id)
        EquipmentSets[name] = name
    end

    UpdateCache()

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
    --UpdateEquipmentSets()

    -- Item belongs to a set?
    local inset, setstring
    if GetContainerItemEquipmentSetInfo then
        inset, setstring = GetContainerItemEquipmentSetInfo(bag, slot)
    end
    if not inset then
        if itemstable and itemstable[bag] and itemstable[bag][slot] then
            setstring = itemstable[bag][slot]
            inset = true
        else
            inset = false
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
local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", UpdateEquipmentSets)
eventFrame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
eventFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
UpdateEquipmentSets()
