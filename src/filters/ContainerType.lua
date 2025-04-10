--[[ ==========================================================================

ContainerType.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions
local pairs = pairs

-- WoW API
local GetAuctionItemSubClasses = C_AuctionHouse and C_AuctionHouse.GetAuctionItemSubClasses or GetAuctionItemSubClasses
local GetItemSubClassInfo = C_Item and C_Item.GetItemSubClassInfo or GetItemSubClassInfo
local ContainerIDToInventoryID = C_Container and C_Container.ContainerIDToInventoryID or ContainerIDToInventoryID
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfoInstant = C_Item and C_Item.GetItemInfoInstant or GetItemInfoInstant
local LE_ITEM_CLASS_CONTAINER = LE_ITEM_CLASS_CONTAINER or Enum.ItemClass.Container
local NUM_BAG_SLOTS = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
local NUM_BANKBAGSLOTS = NUM_BANKBAGSLOTS

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- local storage
local ContainerTypes = {}

-- Initialize filter
local function BuildContainerTypes()
    -- Build array of containers
    if AddOn:IsClassicWow() then
        for _, subClassID in pairs({GetAuctionItemSubClasses(LE_ITEM_CLASS_CONTAINER)}) do
            --print(subClassID, (GetItemSubClassInfo(LE_ITEM_CLASS_CONTAINER, subClassID)))
            ContainerTypes[subClassID] = GetItemSubClassInfo(LE_ITEM_CLASS_CONTAINER, subClassID)
        end
    end
    if not AddOn:IsClassicWow() then
        for _, subClassID in pairs(GetAuctionItemSubClasses(LE_ITEM_CLASS_CONTAINER)) do
            ContainerTypes[subClassID] = GetItemSubClassInfo(LE_ITEM_CLASS_CONTAINER, subClassID)
        end
    end
end

-- Get argument 'ctype'
local function GetOptionCType(info)

    return info.arg.ctype

end

-- Enumerate valid options for 'ctype'
local function EnumOptionValuesCType()

    local result = {}

    for _, v in pairs(ContainerTypes) do
        result[v] = v
    end

    return result

end

-- Set argument 'ctype'
local function SetOptionCType(info, value)

    info.arg.ctype = value

    AddOn:OnRuleChanged()

end


-- Test for match
local function Matches(bag, _, rule)

    -- Empty rule?
    if not rule.ctype then
        return false
    end

    -- Valid bag number?
    if bag < 1 or bag > NUM_BAG_SLOTS + NUM_BANKBAGSLOTS then
        return false
    end

    local link = GetInventoryItemLink("player",ContainerIDToInventoryID(bag))
    if link then
        local _, _, _, _, _, itemClassID, itemSubClassID = GetItemInfoInstant(link)
        -- Is Container?
        if itemClassID == LE_ITEM_CLASS_CONTAINER then
            -- Is correct type of Container?
            return ContainerTypes[itemSubClassID] == rule.ctype
        end
    end

end

-- Register filter
AddOn:AddCustomRule(
    "ContainerType", {
        DisplayName = L["Container Type"],
        Description = L["Filter by the type of container the item is in."],
        Matches = Matches,
        Ace3Options =
        {
            ctype =
            {
                name = L["Container Type"],
                type = "select",
                get = GetOptionCType,
                set = SetOptionCType,
                values = EnumOptionValuesCType,
            },
        },
    }
)

-- Initialize filter
BuildContainerTypes()

