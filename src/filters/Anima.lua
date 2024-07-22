--[[ ==========================================================================

Anima.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local C_Item = C_Item
local IsAnimaItemByID = C_Item.IsAnimaItemByID
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

local function Matches(bag, slot, _)
    local link = GetContainerItemLink(bag, slot)
    if link and IsAnimaItemByID(link) then
        return true
    end
end

-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end

AddOn:AddCustomRule("Anima", {
    DisplayName = "Anima",
    Description = "Matches all Anima items.",
    Matches = Matches,
    CleanRule = CleanRule
})