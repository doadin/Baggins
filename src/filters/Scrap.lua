--[[ ==========================================================================

Scrap.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local DoesItemExist = C_Item and C_Item.DoesItemExist

local function Matches(bag, slot, _)
    if DoesItemExist(ItemLocation:CreateFromBagAndSlot(bag, slot)) then
        local itemLoc = ItemLocation:CreateFromBagAndSlot(bag, slot)
        local CanScrapItem = C_Item.CanScrapItem(itemLoc)
        return CanScrapItem
    end
    return false
end

-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end

AddOn:AddCustomRule("Scrapable", {
    DisplayName = "Scrapable",
    Description = "Matches all Scrapable items.",
    Matches = Matches,
    CleanRule = CleanRule
})