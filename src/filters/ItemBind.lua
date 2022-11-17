--[[ ==========================================================================

ItemBind.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local BankButtonIDToInvSlotID = _G.BankButtonIDToInvSlotID
local GetContainerItemLink = _G.C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink

-- Libs
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local function Matches(bag, slot, rule)
    local status = rule.status
    if not status then return end
    local itemLink = GetContainerItemLink(bag, slot)
    local bindType = select(14,GetItemInfo(itemLink))
    local isBound = select(11,GetContainerItemInfo(bagID, slot))
    if (status == 'unset' or status == 'unbound') and not isBound then
        return true
    end
    return status == bindType
end

AddOn:AddCustomRule("Bind", {
    DisplayName = L["Bind"],
    Description = L["Filter based on if the item binds, or if it is already bound"],
    Matches = Matches,
    Ace3Options = {
        status = {
            name = L["Bind Type"],
            desc = "",
            type = 'select',
            values = {
                unbound = L["Unbound"],
                [_G.ITEM_SOULBOUND] = _G.ITEM_SOULBOUND,
                [_G.ITEM_BIND_ON_EQUIP] = _G.ITEM_BIND_ON_EQUIP,
                [_G.ITEM_ACCOUNTBOUND] = _G.ITEM_ACCOUNTBOUND,
                [_G.ITEM_BIND_ON_USE] = _G.ITEM_BIND_ON_USE,
            }
        },
    },
})