--[[ ==========================================================================

ItemBind.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
--local BankButtonIDToInvSlotID = _G.BankButtonIDToInvSlotID
local GetContainerItemLink = _G.C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink
local GetContainerItemInfo = _G.C_Container and _G.C_Container.GetContainerItemInfo or _G.GetContainerItemInfo
local GetItemInfo = _G.C_Item and _G.C_Item.GetItemInfo or _G.GetItemInfo
local DoesItemExist = _G.C_Item and _G.C_Item.DoesItemExist
local C_ItemIsBound = _G.C_Item and _G.C_Item.IsBound
local ItemLocation = _G.ItemLocation
local TooltipUtil = _G.TooltipUtil
local C_TooltipInfoGetBagItem
if AddOn:IsRetailWow() then
    C_TooltipInfoGetBagItem = _G.C_TooltipInfo.GetBagItem
end

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
        if DoesItemExist(ItemLocation:CreateFromBagAndSlot(bag, slot)) then
            isBound = C_ItemIsBound(ItemLocation:CreateFromBagAndSlot(bag, slot))
        end
    end
    if status == _G.ITEM_SOULBOUND and isBound then
        return true
    end
    if (status == 'unset' or status == 'unbound') and not isBound then
        return true
    end
    if AddOn:IsRetailWow() and status == _G.ITEM_ACCOUNTBOUND then
        local tooltipData = C_TooltipInfoGetBagItem(bag, slot)
        if not tooltipData then return false end
        TooltipUtil.SurfaceArgs(tooltipData)
        for _, line in ipairs(tooltipData.lines) do
            TooltipUtil.SurfaceArgs(line)
        end

        -- The above SurfaceArgs calls are required to assign values to the
        -- 'type', 'guid', and 'leftText' fields seen below.
        for i=1,#tooltipData.lines do
            if tooltipData.lines[i].leftText and tooltipData.lines[i].leftText:find("Account Bound") then
                bindType = 8
            end
        end
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
                [_G.ITEM_BIND_ON_PICKUP] = _G.ITEM_BIND_ON_PICKUP,
            }
        },
    },
})