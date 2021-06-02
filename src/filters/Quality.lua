--[[ ==========================================================================

Quality.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName] --luacheck: ignore 211

-- LUA Functions
local pairs = _G.pairs

-- WoW API
local GetContainerItemLink = _G.GetContainerItemLink
local GetItemInfo = _G.GetItemInfo

-- Libs
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- Local storage
local QualityNames = { }

-- Build list of qualities
local function BuildQualityNames()

    for k,_ in pairs(_G.ITEM_QUALITY_COLORS) do
        --print(k)
        QualityNames[k] = _G["ITEM_QUALITY" .. k .. "_DESC"]
    end
    --table.insert(QualityNames, 0, "Poor")
    --for k,v in pairs(QualityNames) do
    --    print("k:", k, "v: ", v)
    --end
end

-- Test for match
local function Matches(bag, slot, rule)

    -- Empty rule?
    if not (rule.comp and rule.quality) then
        return false
    end

    -- Correct quality?
    local link = GetContainerItemLink(bag, slot)
    if link then
        local _, _, quality = GetItemInfo(link)
        if quality then
            return  ( rule.comp == "==" and quality == rule.quality ) or
                    ( rule.comp == "<=" and quality <= rule.quality ) or
                    ( rule.comp == ">=" and quality >= rule.quality )
        end
    end

    return false

end

-- Clean rule
local function CleanRule(rule)

    rule.quality = 1
    rule.comp = "=="

end

-- Register filter
AddOn:AddCustomRule(
    "Quality",
    {
        DisplayName = L["Quality"],
        Description = L["Filter by Item Quality"],
        Matches = Matches,
        Ace3Options =
        {
            comp =
            {
                name = L["Comparison"],
                type = "select",
                values = {
                    ["=="] = "==",
                    ["<="] = "<=",
                    [">="] = ">=",
                },
            },
            quality =
            {
                name = L["Quality"],
                type = "select",
                values = QualityNames,
            }
        },
        CleanRule = CleanRule
    }
)

-- Initialize filter
BuildQualityNames()