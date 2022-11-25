--[[ ==========================================================================

Tooltip.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions

-- WoW API
local C_TooltipInfoGetBagItem
if AddOn:IsRetailWow() then
    C_TooltipInfoGetBagItem = _G.C_TooltipInfo.GetBagItem
end

local TooltipUtil
if AddOn:IsRetailWow() then
    TooltipUtil = _G.TooltipUtil
end

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
    if AddOn:IsRetailWow() then
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
    if not AddOn:IsRetailWow() then
        local tip = BagginsTooltipFilterFrame or CreateFrame("GAMETOOLTIP", "BagginsTooltipFilterFrame", nil, "GameTooltipTemplate")
        tip:SetOwner(WorldFrame, "ANCHOR_NONE")
        tip:SetBagItem(bag, slot)
        for i = 1, BagginsTooltipFilterFrame:NumLines() do
            local left = _G["BagginsTooltipFilterFrameTextLeft"..i]
            local tooltiptext = left:GetText()
            if tooltiptext and tooltiptext ~= "" then
                if tooltiptext:find(text) then
                    return true
                end
            end
        end
        return false
    end

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
