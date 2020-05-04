--[[ ==========================================================================

Tooltip.lua

========================================================================== ]]--

local _G = _G
local Baggins = _G.Baggins
local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")
local gratuity = LibStub("LibGratuity-3.0")

Baggins:AddCustomRule("Tooltip", {
    DisplayName = L["Tooltip"],
    Description = L["Filter based on text contained in its tooltip"],
    Matches = function(bag, slot, rule)
        if not rule.text then return end
        local text = rule.text
        --if the text is the name of a global string then match against that
        if text:upper() == text then
            local gtext = _G[rule.text]
            if type(gtext) == "string" then
                text = gtext
            end
        end
        if bag == -1 then
            gratuity:SetInventoryItem("player", _G.BankButtonIDToInvSlotID(slot))
        else
            gratuity:SetBagItem(bag,slot)
        end
        if gratuity:Find(text) then
            return true
        end
    end,
    GetName = function(rule)
        return L["Tooltip"]..": "..(rule.text or "")
    end,
    Ace3Options = {
        text = {
            name = L["String to Match"],
            desc = "",
            type = 'input',
        },
    },
})
