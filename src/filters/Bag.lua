--[[ ==========================================================================

Bag.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName] --luacheck: ignore 211

-- LUA Functions

-- WoW API
local GetContainerItemLink = _G.GetContainerItemLink

-- Libs
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
    --[===[@non-retail@
    BagNames[KEYRING_CONTAINER] = L["KeyRing"]
    --@end-non-retail@]===]

    -- Retail specific bag
    --@retail@
    BagNames[REAGENTBANK_CONTAINER] = L["Reagent Bank"]
    --@end-retail@

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
        GetName = GetName, -- TODO: [#24] https://github.com/doadin/Baggins/issues/24
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
