--[[ ==========================================================================

EquipmentSet.lua

========================================================================== ]]--

local AddOnName, _ = ...
local Baggins = _G[AddOnName]

-- WoW API
local GetEquipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs
local GetEquipmentSetInfo = C_EquipmentSet.GetEquipmentSetInfo
local GetItemLocations = C_EquipmentSet.GetItemLocations
local UnpackItemLocation = EquipmentManager_UnpackLocation
local BankButtonIDToInvSlotID = BankButtonIDToInvSlotID
local RunNextFrame = RunNextFrame
local BANK_CONTAINER = BANK_CONTAINER

local BANK_INVENTORY_OFFSET = BankButtonIDToInvSlotID(1, false) - 1

-- i18n
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- mutable state
local equipmentSets = {}
local itemCache = {}

--

local function UpdateItemsCache()
    wipe(itemCache)
    for _, setId in ipairs(GetEquipmentSetIDs()) do
        for _, packedLoc in pairs(GetItemLocations(setId)) do
            local player, bank, bags, slot, bag = UnpackItemLocation(packedLoc)
            -- NOTE: unlike documented, this method in Cataclysm Classic
            -- no longer returns the voidstorage field between bags and slot.
            -- TODO: requires additional testing on retail!

            if bank then
                bag = BANK_CONTAINER
                slot = slot - BANK_INVENTORY_OFFSET
            end

            if (player or bags or bank) and (bag ~= nil) and (slot ~= nil) then
                if not itemCache[bag] then
                    itemCache[bag] = {}
                end
                if not itemCache[bag][slot] then
                    itemCache[bag][slot] = { sets = {} }
                end
                local cachedItem = itemCache[bag][slot]
                local cachedSets = cachedItem.sets
                cachedSets[#cachedSets + 1] = setId
            end
        end
    end
end


local function UpdateEquipmentSets()
    wipe(equipmentSets)
    for _, setId in ipairs(GetEquipmentSetIDs()) do
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

    local cachedInfo
    if itemCache[bag] and itemCache[bag][slot] then
        cachedInfo = itemCache[bag][slot]
    else
        return false
    end

    if rule.anyset then
        -- we have a cached item, so it must belong to some set.
        return true
    end

    if not rule.sets then
        -- no sets have been selected, nothing to match.
        return false
    end

    for _,setId in ipairs(cachedInfo.sets) do
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
    Baggins:OnRuleChanged()
end


local function GetAnySetOption(info)
    return info.arg.anyset
end


local function SetAnySetOption(info, value)
    info.arg.anyset = value
    UpdateItemsCache()
    Baggins:OnRuleChanged()
end


Baggins:AddCustomRule("EquipmentSet", {
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
