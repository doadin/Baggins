--[[ ==========================================================================

Toy.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = _G.LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local GetContainerItemID = _G.GetContainerItemID

local function Matches(bag, slot, _)
    local itemId = GetContainerItemID(bag, slot)
    local itemLink = C_ToyBox.GetToyLink(itemID)
    if type(itemLink) == "string" then
        return true
    end
end

-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end

AddOn:AddCustomRule("Toys", {
    DisplayName = "Toys",
    Description = "Matches toys.",
    Matches = Matches,
    CleanRule = CleanRule
})