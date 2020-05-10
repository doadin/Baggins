--[[ ==========================================================================

Quality.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName] --luacheck: ignore 211


-- LUA Functions
local ipairs = _G.ipairs

-- WoW API
local GetItemQualityColor = _G.GetItemQualityColor
local GetContainerItemLink = _G.GetContainerItemLink
local GetItemInfo = _G.GetItemInfo


-- Libs
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)


-- Local storage
local QualityNames = { }


-- Build list of qualities
local function BuildQualityNames()

    for k,_ in ipairs(_G.ITEM_QUALITY_COLORS) do
        QualityNames[k] = _G["ITEM_QUALITY" .. k .. "_DESC"]
    end

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


-- TODO: [#24] https://github.com/doadin/Baggins/issues/24
-- Return name for specific rule
local function GetName(rule)

    local name

    if rule.quality then
        local _, _, _, hex = GetItemQualityColor(rule.quality)
        name = hex .. QualityNames[rule.quality]
    else
        name = "*none*"
    end

    return L["Quality"] .. " " .. (rule.comp or "==") .. " " .. name

end


-- Clean rule
local function CleanRule(rule)

    rule.quality = 1
    rule.comp = "=="

end

-- Register filter
Baggins:AddCustomRule(
    "Quality",
    {
        DisplayName = L["Quality"],
        Description = L["Filter by Item Quality"],
        Matches = Matches,
        GetName = GetName, -- TODO: [#24] https://github.com/doadin/Baggins/issues/24
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