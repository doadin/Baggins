--[[ ==========================================================================

Keystone.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local GetContainerItemID = _G.GetContainerItemID

local function Matches(bag, slot, _)
    local ID = GetContainerItemID(bag, slot)
    if (ID and ID == 180653) then
        return true
    end
end

-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end

AddOn:AddCustomRule("Keystone", {
    DisplayName = "Keystone",
    Description = "Matches Keystones.",
    Matches = Matches,
    CleanRule = CleanRule
})