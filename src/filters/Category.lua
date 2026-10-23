--[[ ==========================================================================

Category.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = LibStub("AceAddon-3.0"):GetAddon("Baggins")

-- LUA Functions
local pairs = pairs

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- Local storage
local BagTypes = AddOn:GetBagTypes()
local bankcategorycache = AddOn:GetBankCategoryCache()
local categorycache = AddOn:GetCategoryCache()

local function Matches(bag,slot,rule)
    if not (bag and slot and rule.category) then return end
    local key = bag..":"..slot
    if BagTypes[bag] == 2 or BagTypes[bag] == 4 then
        return bankcategorycache[rule.category] and bankcategorycache[rule.category][key]
    else
        return categorycache[rule.category] and categorycache[rule.category][key]
    end
end

AddOn:AddCustomRule("Category",
    {
        DisplayName = L["Category"],
        Description = L["Items that match another category"],
        Matches = Matches,
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