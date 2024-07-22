--[[ ==========================================================================

Bag.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName] --luacheck: ignore 211

-- LUA Functions

-- WoW API
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local BACKPACK_CONTAINER = BACKPACK_CONTAINER
local BANK_CONTAINER = BANK_CONTAINER
local NUM_BAG_SLOTS = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
local NUM_BANKBAGSLOTS = NUM_BANKBAGSLOTS
local KEYRING_CONTAINER = KEYRING_CONTAINER
local REAGENTBANK_CONTAINER = REAGENTBANK_CONTAINER
local REAGENT_CONTAINER = AddOn:IsRetailWow() and Enum.BagIndex.ReagentBag or math.huge

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- Local storage
local BagNames = {}


-- Build list of bag names
local function BuildBagNames()

    -- Common bags
    BagNames[BACKPACK_CONTAINER] = L["Backpack"]
    BagNames[BANK_CONTAINER] = L["Bank Frame"]

    for i = 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do

        local name
        if i <= NUM_BAG_SLOTS then
           name = L[ "Bag " .. i ]
        else
           name = L[ "Bank Bag " .. i - NUM_BAG_SLOTS ]
        end
        BagNames[i] = name

    end

    -- Classic specific bag
    if AddOn:IsClassicWow() or AddOn:IsTBCWow() or AddOn:IsWrathWow() then
        BagNames[KEYRING_CONTAINER] = L["KeyRing"]
    end

    -- Retail specific bag
    if AddOn:IsRetailWow() then
        BagNames[REAGENTBANK_CONTAINER] = L["Reagent Bank"]
        BagNames[REAGENT_CONTAINER] = "Reagent Bag"
    end

end


-- Test for match
local function Matches(bag, slot, rule)
    -- BUG: [#31] https://github.com/doadin/Baggins/issues/31
    -- if rule.noempty then
        local link = GetContainerItemLink(bag, slot)
        if link then
            return bag == rule.bagid
        end
    -- BUG: [#31] https://github.com/doadin/Baggins/issues/31
    -- else
    --     return bag == rule.bagid
    -- end
end

-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end


-- Register filter
AddOn:AddCustomRule(
    "Bag",
    {
        DisplayName = L["Bag"],
        Description = L["Filter by the bag the item is in"],
        Matches = Matches,
        Ace3Options =
        {
            bagid =
            {
                name = L["Bag"],
                type = "select",
                values = BagNames,
            },
            -- BUG: [#31] https://github.com/doadin/Baggins/issues/31
            -- noempty =
            -- {
            -- 	name = L["Ignore Empty Slots"],
            -- 	type = "toggle",
            -- },
        },
        CleanRule = CleanRule
})


-- Initialize filter
BuildBagNames()
