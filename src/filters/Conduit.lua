--[[ ==========================================================================

Conduit.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local IsItemConduitByItemInfo = C_Soulbinds.IsItemConduitByItemInfo
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

local function Matches(bag, slot, _)
    local link = GetContainerItemLink(bag, slot)
    if link and IsItemConduitByItemInfo(link) then
        return true
    end
end

-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end

AddOn:AddCustomRule("Conduit", {
    DisplayName = "Conduit",
    Description = "Matches all Conduit items.",
    Matches = Matches,
    CleanRule = CleanRule
})