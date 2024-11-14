--[[ ==========================================================================

Expansion.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo

local itemExpansion = {
    [0] = "Classic",
    [1] = "The Burning Crusade",
    [2] = "Wrath of the Lich King",
    [3] = "Cataclysm",
    [4] = "Mists of Pandaria",
    [5] = "Warlords of Draenor",
    [6] = "Legion",
    [7] = "Battle for Azeroth",
    [8] = "Shadowlands",
    [9] = "Dragonflight",
    [10] = "The War Within",
}


local function Matches(bag, slot, rule)
    local status = rule.status
    if not status then return end
    local itemLink = GetContainerItemLink(bag, slot)
    local expansionID = itemLink and select(15,GetItemInfo(itemLink))
    return status == itemExpansion[expansionID]
end

AddOn:AddCustomRule("Expansion", {
    DisplayName = "Expansion",
    Description = "Matches all items originating from chosen expansion.",
    Matches = Matches,
    Ace3Options = {
        status = {
            name = "Expansion",
            desc = "",
            type = 'select',
            values = {
                ["Classic"] = "Classic",
                ["The Burning Crusade"] = "The Burning Crusade",
                ["Wrath of the Lich King"] = "Wrath of the Lich King",
                ["Cataclysm"] = "Cataclysm",
                ["Mists of Pandaria"] = "Mists of Pandaria",
                ["Warlords of Draenor"] = "Warlords of Draenor",
                ["Legion"] = "Legion",
                ["Battle for Azeroth"] = "Battle for Azeroth",
                ["Shadowlands"] = "Shadowlands",
                ["Dragonflight"] = "Dragonflight",
                ["The War Within"] = "The War Within",
            }
        },
    },
})
