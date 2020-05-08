--[[ ==========================================================================

Tooltip.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions

-- WoW API
local BankButtonIDToInvSlotID = _G.BankButtonIDToInvSlotID

-- Libs
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)
local LG = LibStub("LibGratuity-3.0")

-- Test for match
local function Matches(bag, slot, rule)

    -- Empty rule?
    if not rule.text then
        return false
    end

    -- Text all UPPER_CASE? Try to match against global string
    local text = rule.text
    if text:upper() == text then
        local gtext = _G[rule.text]
        if type(gtext) == "string" then
            text = gtext
        end
    end

    -- Is item in bags or in bank bags?
    if bag == -1 then
        LG:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
    else
        LG:SetBagItem(bag,slot)
    end

    -- Text found in tooltip?
    if LG:Find(text) then
        return true
    end

    return false

end

-- TODO: [#24] https://github.com/doadin/Baggins/issues/24
-- Return name for specific rule
local function GetName(rule)
    return L["Tooltip"]..": "..(rule.text or "")
end

-- Register filter
AddOn:AddCustomRule(
    "Tooltip",
    {
        DisplayName = L["Tooltip"],
        Description = L["Filter based on text contained in its tooltip"],
        GetName = GetName, -- TODO: [#24] https://github.com/doadin/Baggins/issues/24
        Matches = Matches,
        Ace3Options =
        {
            text =
            {
                name = L["String to Match"],
                type = "input",
            },
        },
    }
)
