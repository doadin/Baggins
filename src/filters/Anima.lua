--[[ ==========================================================================

Anima.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = _G.LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local C_Item = _G.C_Item
local IsAnimaItemByID = C_Item.IsAnimaItemByID
local GetContainerItemLink = _G.C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink

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