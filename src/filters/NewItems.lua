--[[ ==========================================================================

NewItems.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local BACKPACK_CONTAINER = BACKPACK_CONTAINER
local BANK_CONTAINER = BANK_CONTAINER
local NUM_BAG_SLOTS = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
local NUM_BANKBAGSLOTS = NUM_BANKBAGSLOTS
local REAGENTBANK_CONTAINER = REAGENTBANK_CONTAINER

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

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

    if AddOn:IsClassicWow() or AddOn:IsTBCWow() or AddOn:IsWrathWow() then
        BagTypes[KEYRING_CONTAINER] = 3
    end

    if AddOn:IsRetailWow() then
        BagTypes[REAGENTBANK_CONTAINER] = 4
    end

end

BuildBagTypes()

local function Matches(bag,slot)
    if not (bag and slot) then return end
    if BagTypes[bag] ~= 1 then return end
    local link = GetContainerItemLink(bag, slot)
    if link then
        return AddOn:IsNew(link)
    end
end

AddOn:AddCustomRule("NewItems",
    {
        DisplayName = L["New Items"],
        Description = L["New Items"],
        Matches = Matches,
    }
)