--[[ ==========================================================================

Teleport.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = _G.LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local GetContainerItemID = _G.GetContainerItemID

local ids = {
    6948, -- Standard Hearth
    110560, -- Garrison Hearth
    140192, -- Dalaran Hearth
    52251, -- Jaina's Locket
    103678, -- Time-Lost Artifact
    37863, -- Direbrew's Remote
    141605, -- Flight Master's Whistle
    128353 -- Admiral's Compass
}

local function Matches(bag, slot, _)
    local itemId = GetContainerItemID(bag, slot)
    for _, itemlistid in pairs(ids) do
        if itemId == itemlistid then
            return true
        end
    end
end

-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end

AddOn:AddCustomRule("Teleport", {
    DisplayName = "Teleport",
    Description = "Matches items that port your character.",
    Matches = Matches,
    CleanRule = CleanRule
})