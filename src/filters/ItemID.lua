--[[ ==========================================================================

ItemID.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions
local pairs = _G.pairs
local ipairs = _G.ipairs
local tonumber = _G.tonumber
local wipe = _G.wipe

-- WoW API
local GetItemInfo = _G.C_Item.GetItemInfo or _G.GetItemInfo
local GetContainerItemID = _G.C_Container and _G.C_Container.GetContainerItemID or _G.GetContainerItemID

-- Libs
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)
local function getItemIdSummary(info)
    local ids = info.arg.ids
    if not ids then return "" end
    local result = ""
    for k in pairs(ids) do
        local _,v = GetItemInfo(k)
        result = ("%s\n%s (%d)"):format(result, v or _G.UNKNOWN, k)
    end
    return result
end

local function setItemIdList(info, value)
    local idList = { (" "):split(value) }
    local ids
    if not info.arg.ids then
        ids = {}
        info.arg.ids = ids
    else
        ids = wipe(info.arg.ids)
    end
    for _,v in ipairs(idList) do
        if v then
            ids[tonumber(v)] = true
        end
    end
    AddOn:OnRuleChanged()
end

local function getItemIdList(info)
    local result = ""
    if not info.arg.ids then return "" end
    for k in pairs(info.arg.ids) do
        result = ("%s %s"):format(result, k)
    end
    return result:sub(2)
end

local function Matches(bag,slot,rule)
    if not rule.ids then return end
    local itemid = GetContainerItemID(bag, slot)
    return rule.ids[itemid]
end

AddOn:AddCustomRule("ItemID",
    {
        DisplayName = L["Item ID"],
        Description = L["Filter by ItemID, this can be a space delimited list or ids to match."],
        Matches = Matches,
        Ace3Options = {
            ids = {
                type = 'input',
                name = L["Item IDs "],
                desc = "",
                set = setItemIdList,
                get = getItemIdList,
                order = 10,
            },
            desc = {
                type = 'description',
                name = getItemIdSummary,
                order = 11,
            }
        },
    }
)