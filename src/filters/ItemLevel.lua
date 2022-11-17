--[[ ==========================================================================

ItemLevel.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local GetContainerItemLink = _G.C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink
local GetItemInfo = _G.GetItemInfo
local UnitLevel = _G.UnitLevel

-- Libs
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)
local LIUI = LibStub("LibItemUpgradeInfo-1.0") --luacheck: ignore 211

local function Matches(bag,slot,rule)
    local link = GetContainerItemLink(bag, slot)
    if not link then return false end

    local _,_,_, itemLevel, itemMinLevel = GetItemInfo(link) --luacheck: ignore 211
    local itemLevel = LIUI:GetUpgradedItemLevel(link) --luacheck: ignore 411
    -- local itemLevel = GetDetailedItemLevelInfo(link)
    local lvl = rule.useminlvl and itemMinLevel or itemLevel

    if not lvl then	-- can happen if itemcache hasn't been updated yet
        return false
    end

    if rule.include0 and lvl==0 then
        return true
    end
    if rule.include1 and lvl==1 then
        return true
    end

    local minlvl = rule.minlvl or -9999
    local maxlvl = rule.maxlvl or 9999
    if rule.minlvl_rel then
        minlvl = UnitLevel("player")+minlvl
    end
    if rule.maxlvl_rel then
        maxlvl = UnitLevel("player")+maxlvl
    end

    return lvl>=minlvl and lvl<=maxlvl
end

AddOn:AddCustomRule("ItemLevel",
    {
        DisplayName = L["Item Level"],
        Description = L["Filter by item's level - either \"ilvl\" or minimum required level"],
        Matches = Matches,
        Ace3Options = {
            include0 = {
                name = L["Include Level 0"],
                desc = "",
                type = 'toggle',
                order = 10,
            },
            include1 = {
                name = L["Include Level 1"],
                desc = "",
                type = 'toggle',
                order = 11,
            },
            useminlvl = {
                name = L["Look at Required Level"],
                desc = "Look at 'minimum level required' rather than item level",
                descStyle = "inline",
                type = 'toggle',
                order = 12,
                width = "full"
            },
            minlvl = {
                name = L["From level:"],
                desc = "",
                type = 'input',
                set = function(info, value)
                        info.arg.minlvl = tonumber(value)
                        AddOn:OnRuleChanged()
                    end,
                get = function(info)
                        return tostring(info.arg.minlvl or "")
                    end,
                validate = function(info, value) --luacheck: ignore 212
                        return tonumber(value) ~= nil
                    end,
                order = 20,
            },
            minlvl_rel = {
                name = L["... plus Player's Level"],
                desc = "",
                type = 'toggle',
                order = 21,
            },
            maxlvl = {
                name = L["To level:"],
                desc = "",
                type = 'input',
                set = function(info, value)
                        info.arg.maxlvl = tonumber(value)
                        AddOn:OnRuleChanged()
                    end,
                get = function(info)
                        return tostring(info.arg.maxlvl or "")
                    end,
                validate = function(info, value) --luacheck: ignore 212
                        return tonumber(value) ~= nil
                    end,
                order = 30,
            },
            maxlvl_rel = {
                name = L["... plus Player's Level"],
                desc = "",
                type = 'toggle',
                order = 31,
            },
        },
        CleanRule = function(rule)
            rule.include0 = true
            rule.include1 = false
            rule.useminlvl = false
            rule.minlvl_rel = true
            rule.minlvl = -15
            rule.maxlvl_rel = true
            rule.maxlvl = 10
        end,
    }
)