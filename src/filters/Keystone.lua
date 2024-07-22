--[[ ==========================================================================

Keystone.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local GetContainerItemID = C_Container and C_Container.GetContainerItemID or GetContainerItemID

local function Matches(bag, slot, _)
    local ID = GetContainerItemID(bag, slot)
    if (ID and ID == 180653) or (ID and ID == 187786) then
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