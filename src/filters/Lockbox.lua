--[[ ==========================================================================

Lockbox.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local GetContainerItemID = C_Container and C_Container.GetContainerItemID or GetContainerItemID

local ids = {
    4632, -- Ornate Bronze Lockbox
    4633, -- Heavy Bronze Lockbox
    4634,  -- Iron Lockbox
    4636, -- Strong Iron Lockbox
    4637, -- Steel Lockbox
    4638, -- Reinforced Steel Lockbox
    5758, -- Mithril Lockbox
    5759, -- Thorium Lockbox
    5760, -- Eternium Lockbox
    31952, -- Khorium Lockbox
    43622, -- Froststeel Lockbox
    43624, -- Titanium Lockbox
    45986, -- Tiny Titanium Lockbox
    68729, -- Elementium Lockbox
    88567, -- Ghost Iron Lockbox
    116920, -- True Steel Lockbox
    121331, -- Leystone Lockbox
    169475, -- Barnacled Lockbox
    179311, -- Oxxein Lockbox
    180522, -- Phaedrum Lockbox
    180532, -- Laestrite Lockbox
    180533, -- Solenium Lockbox
    186161, -- Stygian Lockbox
    190954, -- Serevite Lockbox
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

AddOn:AddCustomRule("Lockbox", {
    DisplayName = "Lockbox",
    Description = "Matches Lockboxes.",
    Matches = Matches,
    CleanRule = CleanRule
})