--[[ ==========================================================================

ItemBind.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local BankButtonIDToInvSlotID = _G.BankButtonIDToInvSlotID
local GetContainerItemLink = _G.C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink
local GetContainerItemInfo = _G.C_Container and _G.C_Container.GetContainerItemInfo or _G.GetContainerItemInfo

-- Libs
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local bindtoType = { --Account Bound
    --[0] = "LE_ITEM_BIND_NONE",
    [1] = "Binds when picked up",
    [2] = "Binds when equipped",
    [3] = "Binds when used",
    --[4] = "LE_ITEM_BIND_QUEST"
    [8] = "Account Bound",
}

local function Matches(bag, slot, rule)
    local status = rule.status
    if not status then return end
    local itemLink = GetContainerItemLink(bag, slot)
    local bindType = itemLink and select(14,GetItemInfo(itemLink))
    local isBound,info
    if AddOn:IsRetailWow() then
        info = GetContainerItemInfo(bag, slot)
        isBound = info and info.isBound
    else
        isBound = select(11,GetContainerItemInfo(bag, slot))
    end
    if (status == 'unset' or status == 'unbound') and not isBound then
        return true
    end
    return status == bindtoType[bindType]
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