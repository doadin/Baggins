--[[ ==========================================================================

Bag.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName] --luacheck: ignore 211

-- LUA Functions

-- WoW API
local GetContainerItemLink = _G.C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink
local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER
local BANK_CONTAINER = _G.BANK_CONTAINER
local NUM_BAG_SLOTS = _G.NUM_TOTAL_EQUIPPED_BAG_SLOTS or _G.NUM_BAG_SLOTS
local NUM_BANKBAGSLOTS = _G.NUM_BANKBAGSLOTS
local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER

-- Libs
local LibStub = _G.LibStub
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
