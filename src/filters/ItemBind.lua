--[[ ==========================================================================

ItemBind.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
--local BankButtonIDToInvSlotID = BankButtonIDToInvSlotID
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local DoesItemExist = C_Item and C_Item.DoesItemExist
local C_ItemIsBound = C_Item and C_Item.IsBound
local ItemLocation = ItemLocation
local TooltipUtil = TooltipUtil
local C_TooltipInfoGetBagItem
if AddOn:IsRetailWow() then
    C_TooltipInfoGetBagItem = C_TooltipInfo.GetBagItem
end

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local bindtoType
if AddOn:IsRetailWow() then
    bindtoType = { --Account Bound
        --[0] = "LE_ITEM_BIND_NONE",
        [1] = ITEM_BIND_ON_PICKUP,
        [2] = ITEM_BIND_ON_EQUIP,
        [3] = ITEM_BIND_ON_USE,
        [4] = ITEM_BIND_QUEST,
        [8] = ITEM_ACCOUNTBOUND,
        [9] = ITEM_ACCOUNTBOUND_UNTIL_EQUIP,
    }
else
    bindtoType = { --Account Bound
        --[0] = "LE_ITEM_BIND_NONE",
        [1] = ITEM_BIND_ON_PICKUP,
        [2] = ITEM_BIND_ON_EQUIP,
        [3] = ITEM_BIND_ON_USE,
        --[4] = "LE_ITEM_BIND_QUEST"
        [8] = "Account Bound",
    }
end

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
    if status == ITEM_SOULBOUND and isBound then
        return true
    end
    if (status == 'unset' or status == 'unbound') and not isBound then
        return true
    end
    if AddOn:IsRetailWow() and (status == ITEM_ACCOUNTBOUND or status == ITEM_ACCOUNTBOUND_UNTIL_EQUIP) then
        local tooltipData = C_TooltipInfoGetBagItem(bag, slot)
        if not tooltipData then return false end
        if TooltipUtil and TooltipUtil.SurfaceArgs then
            TooltipUtil.SurfaceArgs(tooltipData)
            for _, line in ipairs(tooltipData.lines) do
                TooltipUtil.SurfaceArgs(line)
            end
        end

        -- The above SurfaceArgs calls are required to assign values to the
        -- 'type', 'guid', and 'leftText' fields seen below.
        for i=1,#tooltipData.lines do
            if tooltipData.lines[i].leftText and tooltipData.lines[i].leftText:find("Warbound") then
                bindType = 8
            end
            if tooltipData.lines[i].leftText and tooltipData.lines[i].leftText:find("Warbound until equipped") then
                bindType = 9
            end
        end
    end
    return status == bindtoType[bindType]
end
local values
if AddOn:IsRetailWow() then
    values = {
        unbound = L["Unbound"],
        [ITEM_ACCOUNTBOUND] = ITEM_ACCOUNTBOUND,
        [ITEM_ACCOUNTBOUND_UNTIL_EQUIP] = ITEM_ACCOUNTBOUND_UNTIL_EQUIP,
        [ITEM_BIND_ON_EQUIP] = ITEM_BIND_ON_EQUIP,
        [ITEM_BIND_ON_PICKUP] = ITEM_BIND_ON_PICKUP,
        [ITEM_BIND_ON_USE] = ITEM_BIND_ON_USE,
        [ITEM_BIND_QUEST] = ITEM_BIND_QUEST,
        --[ITEM_BIND_TO_ACCOUNT] = ITEM_BIND_TO_ACCOUNT,
        --[ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP] = ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP,
        --[ITEM_BIND_TO_BNETACCOUNT] = ITEM_BIND_TO_BNETACCOUNT,
        --[ITEM_BNETACCOUNTBOUND] = ITEM_BNETACCOUNTBOUND,
        [ITEM_SOULBOUND] = ITEM_SOULBOUND,
    }
else
    values = {
        unbound = L["Unbound"],
        [ITEM_SOULBOUND] = ITEM_SOULBOUND,
        [ITEM_BIND_ON_EQUIP] = ITEM_BIND_ON_EQUIP,
        [ITEM_BIND_ON_PICKUP] = ITEM_BIND_ON_PICKUP,
        [ITEM_BIND_ON_USE] = ITEM_BIND_ON_USE,
        [ITEM_BIND_QUEST] = ITEM_BIND_QUEST,
    }
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
            values = values
        },
    },
})