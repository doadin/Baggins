--[[ ==========================================================================

Empty.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local GetContainerItemLink = _G.GetContainerItemLink

-- Libs
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

    -- Classic specific bag
    --[===[@non-retail@
    BagTypes[KEYRING_CONTAINER] = 3
    --@end-non-retail@]===]

    -- Retail specific bag
    --@retail@
    BagTypes[REAGENTBANK_CONTAINER] = 4
    --@end-retail@

end

BuildBagTypes()

local function Matches(bag,slot,_)
    if not (bag and slot) then return end
    if BagTypes[bag] == 3 then return end
    local link = GetContainerItemLink(bag, slot)
    if not link then
        return true
    end
end

AddOn:AddCustomRule("Empty", {
    DisplayName = L["Empty Slots"],
    Description = L["Empty bag slots"],
    Matches = Matches,
})