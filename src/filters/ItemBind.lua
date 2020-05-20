--[[ ==========================================================================

ItemBind.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local BankButtonIDToInvSlotID = _G.BankButtonIDToInvSlotID

-- Libs
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)
local LG = LibStub("LibGratuity-3.0") --luacheck: ignore 211

local function Matches(bag, slot, rule)
    local status = rule.status
    if not status then return	end
    if bag == -1 then
        LG:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
    else
        LG:SetBagItem(bag,slot)
    end
    if status == 'unset' or status == 'unbound' then
        return not (LG:Find(_G.ITEM_SOULBOUND, 2, 6, false, true))
    end
    return (LG:Find(status, 2, 6, false, true))
end

local function GetName(rule)
    if not rule.status then
        return L["Bind *unset*"]
    elseif rule.status == 'unbound' then
        return L["Unbound"]
    end
    return rule.status
end

AddOn:AddCustomRule("Bind", {
    DisplayName = L["Bind"],
    Description = L["Filter based on if the item binds, or if it is already bound"],
    Matches = Matches,
    GetName = GetName,
    Ace3Options = {
        status = {
            name = L["Bind Type"],
            desc = "",
            type = 'select',
            values = {
                unbound = L["Unbound"],
                [ITEM_SOULBOUND] = ITEM_SOULBOUND,
                [ITEM_BIND_ON_EQUIP] = ITEM_BIND_ON_EQUIP,
                [ITEM_ACCOUNTBOUND] = ITEM_ACCOUNTBOUND,
                [ITEM_BIND_ON_USE] = ITEM_BIND_ON_USE,
            }
        },
    },
})