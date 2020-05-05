--[[ ==========================================================================

ContainerType.lua

========================================================================== ]]--

--@retail@
local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions
local pairs = _G.pairs

-- WoW API
local GetAuctionItemSubClasses = _G.C_AuctionHouse.GetAuctionItemSubClasses
local GetItemSubClassInfo = _G.GetItemSubClassInfo
local ContainerIDToInventoryID = _G.ContainerIDToInventoryID
local GetInventoryItemLink = _G.GetInventoryItemLink
local GetItemInfoInstant = _G.GetItemInfoInstant
local LE_ITEM_CLASS_CONTAINER = _G.LE_ITEM_CLASS_CONTAINER
local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS
local NUM_BANKBAGSLOTS = _G.NUM_BANKBAGSLOTS

-- Libs
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- local storage
local ContainerTypes = {}

-- Initialize filter
local function BuildContainerTypes()

    -- Build array of containers
    for _, subClassID in pairs(GetAuctionItemSubClasses(LE_ITEM_CLASS_CONTAINER)) do
        ContainerTypes[subClassID] = GetItemSubClassInfo(LE_ITEM_CLASS_CONTAINER, subClassID)
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
local function Matches(bag, slot, rule)
    
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

-- TODO: [#24] https://github.com/doadin/Baggins/issues/24
-- Return name for specific rule
local function GetName(rule)
    local ctype
    if rule.ctype then
        ctype = BBI[rule.ctype]
    else
        ctype = L["None"]
    end
    return L["Container : "]..ctype
end

-- Register filter
AddOn:AddCustomRule(
    "ContainerType", {
		DisplayName = L["Container Type"],
		Description = L["Filter by the type of container the item is in."],
        Matches = Matches,
		GetName = GetName, -- TODO: [#24] https://github.com/doadin/Baggins/issues/24
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

--@end-retail@
