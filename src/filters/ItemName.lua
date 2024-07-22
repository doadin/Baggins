--[[ ==========================================================================

ItemName.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions

--- WoW API
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- Test for match
local function Matches(bag, slot, rule)

    -- Empty rule?
    if not rule.match then
        return false
    end

    -- Name matches?
    local link = GetContainerItemLink(bag, slot)
    if link then
        local itemname = GetItemInfo(link)
        if itemname and
           itemname:lower():match(rule.match:lower()) then
            return true
        end
    end

    return false

end

-- Register filter
AddOn:AddCustomRule(
    "ItemName",
    {
        DisplayName = L["Item Name"],
        Description = L["Filter by Name or partial name"],
        Matches = Matches,
        Ace3Options =
        {
            match =
            {
                name = L["String to Match"],
                type = "input",
            },
        },
    }
)

