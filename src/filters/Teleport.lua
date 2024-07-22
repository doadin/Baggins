--[[ ==========================================================================

Teleport.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local GetContainerItemID = C_Container and C_Container.GetContainerItemID or GetContainerItemID

local ids = {
    6948, -- Standard Hearth
    110560, -- Garrison Hearth
    140192, -- Dalaran Hearth
    52251, -- Jaina's Locket
    103678, -- Time-Lost Artifact
    37863, -- Direbrew's Remote
    141605, -- Flight Master's Whistle
    128353, -- Admiral's Compass
    103678, -- Time-Lost Artifact
    65274, -- Cloak of Coordination
    64457, --the last relic of argus
    46874, --argent crusaders tabard
    180817, --Cypher of Relocation
    167075, --Ultrasafe Transporter: Mechagon
    140493, --Adept's Guide to Dimensional Rifting
    118663, --Relic of Karabor
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