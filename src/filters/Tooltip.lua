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
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

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

    -- Local tooltip for getting tooltip contents
    local ScanTip = CreateFrame("GameTooltip", "BagginsScanTipToolTip", UIParent, "GameTooltipTemplate")
    ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
    ScanTip:ClearLines()
    ScanTip:SetBagItem(bag, slot)
    for i = 1, select("#", ScanTip:GetRegions()) do
        local region = select(i, ScanTip:GetRegions())
        if region and region:GetObjectType() == "FontString" then
            local tooltiptext = region:GetText() -- string or nil
            if tooltiptext and tooltiptext:find(text) then
                return true
            end
        end
    end

    return false

end

-- Register filter
AddOn:AddCustomRule(
    "Tooltip",
    {
        DisplayName = L["Tooltip"],
        Description = L["Filter based on text contained in its tooltip"],
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
