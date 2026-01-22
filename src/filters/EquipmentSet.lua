--[[ ==========================================================================

EquipmentSet.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local GetEquipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs
local GetEquipmentSetInfo = C_EquipmentSet.GetEquipmentSetInfo
local GetItemLocations = C_EquipmentSet.GetItemLocations
local BankButtonIDToInvSlotID = BankButtonIDToInvSlotID
local RunNextFrame = _G.RunNextFrame
local BANK_CONTAINER = BANK_CONTAINER

local BANK_INVENTORY_OFFSET = C_Container.ContainerIDToInventoryID(1) - 1

-- i18n
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- mutable state
local equipmentSets = {}
local itemCache = {}

--

-- Prefer current unpack helper, with legacy fallback for older clients.
local function SafeUnpackItemLocation(packedLoc)
    if EquipmentManager_GetLocationData then
        local locationData = EquipmentManager_GetLocationData(packedLoc)
        if not locationData then
            return nil, nil, nil, nil, nil
        end
        return locationData.isPlayer, locationData.isBank, locationData.isBags, locationData.slot, locationData.bag
    end

    if EquipmentManager_UnpackLocation then
        if AddOn:IsRetailWow() then
            local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(packedLoc)
            return player, bank, bags, slot, bag
        end
        return EquipmentManager_UnpackLocation(packedLoc)
    end

    return nil, nil, nil, nil, nil
end

local function UpdateItemsCache()
    wipe(itemCache)
    local setIDs = GetEquipmentSetIDs() -- Cache result
    for _, setId in ipairs(setIDs) do
        for _, packedLoc in pairs(GetItemLocations(setId)) do
            local player, bank, bags, slot, bag = SafeUnpackItemLocation(packedLoc)

            if bank then
                bag = BANK_CONTAINER
                slot = slot - BANK_INVENTORY_OFFSET
            end

            if (player or bags or bank) and (bag ~= nil) and (slot ~= nil) then
                itemCache[bag] = itemCache[bag] or {}
                itemCache[bag][slot] = itemCache[bag][slot] or { sets = {} }
                table.insert(itemCache[bag][slot].sets, setId)
            end
        end
    end
end

local function UpdateEquipmentSets()
    wipe(equipmentSets)
    local setIDs = GetEquipmentSetIDs() -- Cache result
    for _, setId in ipairs(setIDs) do
        local name = GetEquipmentSetInfo(setId)
        equipmentSets[setId] = name
    end
end


local function debounce(fn)
    local armed = true
    local target = fn

    local rearm = function() armed = true end

    return function(...)
        if armed then
            armed = false
            target(unpack({...}))
            RunNextFrame(rearm)
        end
    end
end


local UpdateItemsCacheOnce = debounce(UpdateItemsCache)


local function Matches(bag, slot, rule)
    UpdateItemsCacheOnce()

    local cachedInfo = itemCache[bag] and itemCache[bag][slot]
    if not cachedInfo then
        return false
    end

    if rule.anyset then
        return true -- Any set matches
    end

    if not rule.sets then
        return false -- No sets selected
    end

    for _, setId in ipairs(cachedInfo.sets) do
        if rule.sets[setId] then
            return true
        end
    end

    return false
end


local function GetSelectedSetsOption(info, key)
    return info.arg.sets and info.arg.sets[key]
end


local function SetSelectedSetsOption(info, key, value)
    if not info.arg.sets then
        info.arg.sets = {}
    end
    info.arg.sets[key] = value
    UpdateItemsCache()
    AddOn:OnRuleChanged()
end


local function GetAnySetOption(info)
    return info.arg.anyset
end


local function SetAnySetOption(info, value)
    info.arg.anyset = value
    UpdateItemsCache()
    AddOn:OnRuleChanged()
end


AddOn:AddCustomRule("EquipmentSet", {
    DisplayName = L["Equipment Set"],
    Description = L["Filter by Equipment Set"],
    Matches = Matches,
    Ace3Options = {
        anyset = {
            name = L["Any"],
            type = "toggle",
            set = SetAnySetOption
        },
        sets = {
            name = L["Equipment Sets"],
            type = "multiselect",
            values = equipmentSets,
            get = GetSelectedSetsOption,
            set = SetSelectedSetsOption,
            disabled = GetAnySetOption,
        },
    },
})


local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", debounce(function()
    UpdateEquipmentSets()
    UpdateItemsCache()
    Baggins:OnRuleChanged()
end))
