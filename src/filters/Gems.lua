--[[ ==========================================================================

Gems.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local GetContainerItemID = _G.GetContainerItemID

local function Matches(bag, slot, _)
    local ID = GetContainerItemID(bag, slot)
    local _, _, _, _, _, itemType = GetItemInfo(ID)
    if (itemType == "Gem") then
        return true
    end
end

-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end

AddOn:AddCustomRule("Gems", {
    DisplayName = "Gems",
    Description = "Matches Gems.",
    Matches = Matches,
    CleanRule = CleanRule
})