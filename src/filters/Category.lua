--[[ ==========================================================================

Category.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions
local pairs = _G.pairs

-- Libs
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- Local storage
local BagTypes = {}
local bankcategorycache = {}
local categorycache = {}

local function Matches(bag,slot,rule)
    if not (bag and slot and rule.category) then return end
    local key = bag..":"..slot
    if BagTypes[bag] == 2 or BagTypes[bag] == 4 then
        return bankcategorycache[rule.category] and bankcategorycache[rule.category][key]
    else
        return categorycache[rule.category] and categorycache[rule.category][key]
    end
end

local function GetName(rule)
    if rule.category then
        return L["Category"].." :"..rule.category
    else
        return L["Category"]
    end
end

AddOn:AddCustomRule("Category",
    {
        DisplayName = L["Category"],
        Description = L["Items that match another category"],
        Matches = Matches,
        GetName = GetName,
        Ace3Options = {
            category = {
                name = L["Category"],
                desc = "",
                type = 'select',
                values = function()
                        local tmp = {}
                        for k in pairs(AddOn.db.profile.categories) do
                            tmp[k] = k
                        end
                        return tmp
                    end,
            },
        },
    }
)