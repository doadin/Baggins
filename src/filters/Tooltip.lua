--[[ ==========================================================================

Tooltip.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions

-- WoW API
local C_TooltipInfoGetBagItem = _G.C_TooltipInfo.GetBagItem
local TooltipUtil = _G.TooltipUtil

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

    local tooltipData = C_TooltipInfoGetBagItem(bag, slot)
    if not tooltipData then return false end
    TooltipUtil.SurfaceArgs(tooltipData)
    for _, line in ipairs(tooltipData.lines) do
        TooltipUtil.SurfaceArgs(line)
    end

    -- The above SurfaceArgs calls are required to assign values to the
    -- 'type', 'guid', and 'leftText' fields seen below.
    for i=1,#tooltipData.lines do
        if tooltipData.lines[i].leftText and tooltipData.lines[i].leftText:find(text) then
            return true
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
