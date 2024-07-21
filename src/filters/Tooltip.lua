--[[ ==========================================================================

Tooltip.lua

========================================================================== ]]--

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

local tip
if not AddOn:IsRetailWow() then
    tip = CreateFrame("GAMETOOLTIP", "BagginsTooltipFilterFrame", nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
end

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
            if (tooltipData.lines[i].leftText and tooltipData.lines[i].leftText:find(text))
            or (tooltipData.lines[i].rightText and tooltipData.lines[i].rightText:find(text)) then
                return true
            end
        end

        return false
    end
    if not AddOn:IsRetailWow() then
        if bag == -1 then
            local invId = BankButtonIDToInvSlotID(slot, false)
            tip:SetInventoryItem("player", invId)
        else
            tip:SetBagItem(bag, slot)
        end
        for i = 1, tip:NumLines() do
            local left = _G["BagginsTooltipFilterFrameTextLeft"..i]
            local right = _G["BagginsTooltipFilterFrameTextRight"..i]
            local lefttooltiptext = left and left:GetText()
            local righttooltiptext = right and right:GetText()
            if (lefttooltiptext and lefttooltiptext ~= "" and lefttooltiptext:find(text))
            or (righttooltiptext and righttooltiptext ~= "" and righttooltiptext:find(text)) then
                return true
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
